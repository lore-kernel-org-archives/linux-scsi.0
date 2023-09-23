Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82612CE7A89
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Sep 2023 00:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjIWAaE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 20:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjIWA35 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 20:29:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70571AD;
        Fri, 22 Sep 2023 17:29:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1D2C433CB;
        Sat, 23 Sep 2023 00:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695428991;
        bh=gRfGxVc1daq/nrFb0KHKXOqTTy7EybTfeFXo5KQ/LCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWhoMQCcucj5yOJ1HA+xVpjuCsPuiMmBr5TJIj7vhxfBRDB4wqlbR03/VQADIQ/yJ
         Pf6XV1gnv85uNC4iIATV+GE+zRzkhufd2jd/wNKoiKjbbOgpxk9OZFUCS2qopB06oy
         mS0SU9PlYdZh6wbOXS7wEll7DRfj3qyo0zXOE473XtcIx52mNSvdeAwVoSrKdEcBeT
         Wa94HjgCBzOPnudPqNT5c+eAGSKWwKEiue4aNTkx7mohin9mjWiXRe6BpTDymdD+9p
         QhnhinC1YuIRd/ufAby25Btug/PaIV06RVLFTAcjvXbWtYaIMZVjuci0tppGbe8ACq
         LP17ibeIDPxPg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH v6 11/23] ata: libata-eh: Fix compilation warning in ata_eh_link_report()
Date:   Sat, 23 Sep 2023 09:29:20 +0900
Message-ID: <20230923002932.1082348-12-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230923002932.1082348-1-dlemoal@kernel.org>
References: <20230923002932.1082348-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 6 bytes length of the tries_buf string in ata_eh_link_report() is
too short and results in a gcc compilation warning with W-!:

drivers/ata/libata-eh.c: In function ‘ata_eh_link_report’:
drivers/ata/libata-eh.c:2371:59: warning: ‘%d’ directive output may be truncated writing between 1 and 11 bytes into a region of size 4 [-Wformat-truncation=]
 2371 |                 snprintf(tries_buf, sizeof(tries_buf), " t%d",
      |                                                           ^~
drivers/ata/libata-eh.c:2371:56: note: directive argument in the range [-2147483648, 4]
 2371 |                 snprintf(tries_buf, sizeof(tries_buf), " t%d",
      |                                                        ^~~~~~
drivers/ata/libata-eh.c:2371:17: note: ‘snprintf’ output between 4 and 14 bytes into a destination of size 6
 2371 |                 snprintf(tries_buf, sizeof(tries_buf), " t%d",
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 2372 |                          ap->eh_tries);
      |                          ~~~~~~~~~~~~~

Avoid this warning by increasing the string size to 16B.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-eh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index b1b2c276371e..5686353e442c 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2332,7 +2332,7 @@ static void ata_eh_link_report(struct ata_link *link)
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_queued_cmd *qc;
 	const char *frozen, *desc;
-	char tries_buf[6] = "";
+	char tries_buf[16] = "";
 	int tag, nr_failed = 0;
 
 	if (ehc->i.flags & ATA_EHI_QUIET)
-- 
2.41.0

