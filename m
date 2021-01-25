Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC89C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 20:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 717DD22B3B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 20:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbhAZF1x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:27:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:36330 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbhAYJPX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Jan 2021 04:15:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 34FA7AD6B;
        Mon, 25 Jan 2021 08:54:18 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] ncr53c8xx: Fixup typos
Date:   Mon, 25 Jan 2021 09:54:15 +0100
Message-Id: <20210125085415.70574-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patch to switch using SAM status values had some typos;
fix them up.

Fixes: 491152c7c3b5 ("scsi: ncr53c8xx: Use SAM status values")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ncr53c8xx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 71e97384102a..c76e9f05d042 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4999,7 +4999,7 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 		/*
 		**   SCSI bus reset
 		*/
-		set_status_byte(cmd, sp->scsi_status);
+		set_status_byte(cmd, cp->scsi_status);
 		set_host_byte(cmd, DID_RESET);
 
 	} else if (cp->host_status == HS_ABORTED) {
@@ -6605,7 +6605,7 @@ static void ncr_sir_to_redo(struct ncb *np, int num, struct ccb *cp)
 		OUTL_DSP (NCB_SCRIPT_PHYS (np, reselect));
 		return;
 	case SAM_STAT_COMMAND_TERMINATED:
-	case SAM_STAT_CHECK_CONDIION:
+	case SAM_STAT_CHECK_CONDITION:
 		/*
 		**	If we were requesting sense, give up.
 		*/
@@ -8044,7 +8044,7 @@ printk("ncr53c8xx_queue_command\n");
      spin_lock_irqsave(&np->smp_lock, flags);
 
      if ((sts = ncr_queue_command(np, cmd)) != DID_OK) {
-	     set_host_byte(cmd, sts;
+	     set_host_byte(cmd, sts);
 #ifdef DEBUG_NCR53C8XX
 printk("ncr53c8xx : command not queued - result=%d\n", sts);
 #endif
-- 
2.29.2

