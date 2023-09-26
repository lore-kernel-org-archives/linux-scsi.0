Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E7BCE7D24D
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 08:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbjIZIPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 04:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbjIZIPi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 04:15:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC1B97;
        Tue, 26 Sep 2023 01:15:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FD5C433C9;
        Tue, 26 Sep 2023 08:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695716131;
        bh=gRfGxVc1daq/nrFb0KHKXOqTTy7EybTfeFXo5KQ/LCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQeJ0jvct0lGFyRcOENnCw5iYldKLkXMEpPHrlFLkTrQKV14BKD0NuwS7Cl5+3BwI
         K5hq9uvdUOurI8WX5/SENZLJrtFWL0ER/FgNgM2PuRbg2C2GuI4jJa3S9YoSb6vHBG
         64QkpkckRi0Wi5Wz8bHwc7a9vom9kxOEJQDSmgZdaQ0mjM7IXbdXmJkhMfYgEitSZy
         pqGkqMKlMR56e3wI6gQZ9hRSUw0fmr5D4s1r8fRc8Ona0hfvh6/uBhNm1xPj8rJmPc
         7E+s9G7AywrNHhCZGSm25yUoxi53aS5kZGTznrYDZgvczXcHvsLaYkBe7bmNvf5QgU
         MEBfwCDDO5WjA==
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
Subject: [PATCH v7 11/23] ata: libata-eh: Fix compilation warning in ata_eh_link_report()
Date:   Tue, 26 Sep 2023 17:14:55 +0900
Message-ID: <20230926081507.69346-12-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230926081507.69346-1-dlemoal@kernel.org>
References: <20230926081507.69346-1-dlemoal@kernel.org>
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

