Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB808CDB483
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 09:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbjJPJZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 05:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbjJPJYv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 05:24:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A5EE8
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 02:24:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B36A321C4A;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 23BC32D115;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 05C9C51EBDDF; Mon, 16 Oct 2023 11:24:44 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/17] dc395x: Remove 'scmd' parameter from doing_srb_done()
Date:   Mon, 16 Oct 2023 11:24:30 +0200
Message-Id: <20231016092430.55557-18-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231016092430.55557-1-hare@suse.de>
References: <20231016092430.55557-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++++
Authentication-Results: smtp-out1.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [8.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[5];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_SPAM_LONG(3.00)[1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-3.00)[100.00%]
X-Rspamd-Queue-Id: B36A321C4A
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

doing_srb_done() has two passes, one for the 'going' list
and one for the 'waiting' list. When aborting commands on these
lists we should be calling scsi_done() for each command, and
not only for the command which triggered the error.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/dc395x.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index c8e86f8a631e..822d21e7da14 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -367,8 +367,7 @@ static inline void enable_msgout_abort(struct AdapterCtlBlk *acb,
 		struct ScsiReqBlk *srb);
 static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb);
-static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_code,
-		struct scsi_cmnd *cmd, u8 force);
+static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_code, u8 force);
 static void scsi_reset_detect(struct AdapterCtlBlk *acb);
 static void pci_unmap_srb(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb);
 static void pci_unmap_srb_sense(struct AdapterCtlBlk *acb,
@@ -1182,7 +1181,7 @@ static int __dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
 	set_basic_config(acb);
 
 	reset_dev_param(acb);
-	doing_srb_done(acb, DID_RESET, cmd, 0);
+	doing_srb_done(acb, DID_RESET, 0);
 	acb->active_dcb = NULL;
 	acb->acb_flag = 0;	/* RESET_DETECT, RESET_DONE ,RESET_DEV */
 	waiting_process_next(acb);
@@ -2896,7 +2895,7 @@ static void disconnect(struct AdapterCtlBlk *acb)
 		dcb->flag &= ~ABORT_DEV_;
 		acb->last_reset = jiffies + HZ / 2 + 1;
 		dprintkl(KERN_ERR, "disconnect: SRB_ABORT_SENT\n");
-		doing_srb_done(acb, DID_ABORT, srb->cmd, 1);
+		doing_srb_done(acb, DID_ABORT, 1);
 		waiting_process_next(acb);
 	} else {
 		if ((srb->state & (SRB_START_ + SRB_MSGOUT))
@@ -3337,8 +3336,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 
 
 /* abort all cmds in our queues */
-static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
-		struct scsi_cmnd *cmd, u8 force)
+static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag, u8 force)
 {
 	struct DeviceCtlBlk *dcb;
 	dprintkl(KERN_INFO, "doing_srb_done: pids ");
@@ -3389,7 +3387,7 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 			if (force) {
 				/* For new EH, we normally don't need to give commands back,
 				 * as they all complete or all time out */
-				scsi_done(cmd);
+				scsi_done(p);
 			}
 		}
 		if (!list_empty(&dcb->srb_waiting_list))
@@ -3475,7 +3473,7 @@ static void scsi_reset_detect(struct AdapterCtlBlk *acb)
 	} else {
 		acb->acb_flag |= RESET_DETECT;
 		reset_dev_param(acb);
-		doing_srb_done(acb, DID_RESET, NULL, 1);
+		doing_srb_done(acb, DID_RESET, 1);
 		/*DC395x_RecoverSRB( acb ); */
 		acb->active_dcb = NULL;
 		acb->acb_flag = 0;
-- 
2.35.3

