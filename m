Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBA9EB64DA
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jun 2023 00:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjFWA3R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jun 2023 20:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjFWA3P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jun 2023 20:29:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3768C170E
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2023 17:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A562061935
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 00:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E107C433C8;
        Fri, 23 Jun 2023 00:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687480154;
        bh=9WsA5vj2mNv67bpSROnniP5CyJ4/6MwfhvyJbuQuVuI=;
        h=From:To:Cc:Subject:Date:From;
        b=Pg6A9xPkcUq+wrJB88Yt05AQZ8+8+cmMZ3QkJ0Qitjb8Zio+sqtX14/gbd6Shhf9c
         l91J0bTNrPumVzkqwOVlVMRroQ72AEhDnG0EgyJvvmU7FlqiQ0ZzGHU1KI6kDDb0HZ
         /oGUryS4ot6WmMlMm0sPJ0gEo1gRx1NzqyTF+nXmx7bQy2JxJ2eDyBoMhcXaFYUQq8
         +WNdtHq5F1S4Pinzh1SH45ed+OyCJTWiYvoEX1IBTtV9VsVzTzh86/nyoQyPFtjVto
         sMkGbJkOoWyv6Ud7Yz6m35L/6A++B830SW1oqZLIGiCOz6Y5hqVmiQZJFLv0Rwo9Vr
         EZRmDUXmXOqPg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH] scsi: Simplify scsi_cdl_check_cmd()
Date:   Fri, 23 Jun 2023 09:29:12 +0900
Message-Id: <20230623002912.808251-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reading the 800+ pages of SPC often leads to a brain shutdown and to
less than ideal code... This resulted in the checks of the rwcdlp and
cdlp fields in scsi_cdl_check_cmd() to have identical if-else branches.

Replace this with a comment describing the cases we are interested in
and replace the if-else code block with a simple test of the cdlp field
that is used as the function return value.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Closes: https://lore.kernel.org/r/202306221657.BJHEADkz-lkp@intel.com/
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/scsi.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c4bf99a842f3..cea10616e630 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -586,31 +586,22 @@ static bool scsi_cdl_check_cmd(struct scsi_device *sdev, u8 opcode, u16 sa,
 	if ((buf[1] & 0x03) != 0x03)
 		return false;
 
-	/* See SPC-6, one command format of REPORT SUPPORTED OPERATION CODES */
+	/*
+	 * See SPC-6, one command format of REPORT SUPPORTED OPERATION CODES.
+	 * We have the following cases depending on rwcdlp (buf[0] & 0x01)
+	 * value:
+	 *  - rwcdlp == 0: then cdlp indicates support for the A mode page when
+	 *		   it is equal to 1 and for the B mode page when it is
+	 *		   equal to 2.
+	 *  - rwcdlp == 1: then cdlp indicates support for the T2A mode page
+	 *		   when it is equal to 1 and for the T2B mode page when
+	 *		   it is equal to 2.
+	 * Overall, to detect support for command duration limits, we only need
+	 * to check that cdlp is 1 or 2.
+	 */
 	cdlp = (buf[1] & 0x18) >> 3;
-	if (buf[0] & 0x01) {
-		/* rwcdlp == 1 */
-		switch (cdlp) {
-		case 0x01:
-			/* T2A page */
-			return true;
-		case 0x02:
-			/* T2B page */
-			return true;
-		}
-	} else {
-		/* rwcdlp == 0 */
-		switch (cdlp) {
-		case 0x01:
-			/* A page */
-			return true;
-		case 0x02:
-			/* B page */
-			return true;
-		}
-	}
 
-	return false;
+	return cdlp == 0x01 || cdlp == 0x02;
 }
 
 /**
-- 
2.40.1

