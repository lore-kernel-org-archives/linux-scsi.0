Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C67ACDB474
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 09:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbjJWJ2t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 05:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjJWJ2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 05:28:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30FAB7
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 02:28:44 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2C5E821ACE;
        Mon, 23 Oct 2023 09:28:43 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id D5DB02CF57;
        Mon, 23 Oct 2023 09:28:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 03BD051EC34E; Mon, 23 Oct 2023 11:28:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/10] scsi_error: iterate over list of failed commands in scsi_eh_bus_reset()
Date:   Mon, 23 Oct 2023 11:28:33 +0200
Message-Id: <20231023092837.33786-7-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231023092837.33786-1-hare@suse.de>
References: <20231023092837.33786-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
Authentication-Results: smtp-out1.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [5.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[5];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-0.00)[16.61%]
X-Rspamd-Queue-Id: 2C5E821ACE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Iterating over all possible bus number in scsi_eh_bus_reset() is
inefficient as not all busses may be affected during SCSI EH.
So rewrite the loop in scsi_eh_bus_reset() to match the loop
in scsi_eh_target_reset() and only loop over failed commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_error.c | 62 ++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 42e12756d6f4..7c9c376affda 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1694,21 +1694,20 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			     struct list_head *work_q,
 			     struct list_head *done_q)
 {
-	struct scsi_cmnd *scmd, *chan_scmd, *next;
+	LIST_HEAD(tmp_list);
 	LIST_HEAD(check_list);
-	unsigned int channel;
-	enum scsi_disposition rtn;
 
-	/*
-	 * we really want to loop over the various channels, and do this on
-	 * a channel by channel basis.  we should also check to see if any
-	 * of the failed commands are on soft_reset devices, and if so, skip
-	 * the reset.
-	 */
+	list_splice_init(work_q, &tmp_list);
+
+	while (!list_empty(&tmp_list)) {
+		struct scsi_cmnd *next, *scmd;
+		enum scsi_disposition rtn;
+		unsigned int channel;
 
-	for (channel = 0; channel <= shost->max_channel; channel++) {
 		if (scsi_host_eh_past_deadline(shost)) {
+			/* push back on work queue for further processing */
 			list_splice_init(&check_list, work_q);
+			list_splice_init(&tmp_list, work_q);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
 					    "%s: skip BRST, past eh deadline\n",
@@ -1716,43 +1715,32 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			return list_empty(work_q);
 		}
 
-		chan_scmd = NULL;
-		list_for_each_entry(scmd, work_q, eh_entry) {
-			if (channel == scmd_channel(scmd)) {
-				chan_scmd = scmd;
-				break;
-				/*
-				 * FIXME add back in some support for
-				 * soft_reset devices.
-				 */
-			}
-		}
+		scmd = list_first_entry(&tmp_list, struct scsi_cmnd, eh_entry);
+		channel = scmd_channel(scmd);
 
-		if (!chan_scmd)
-			continue;
 		SCSI_LOG_ERROR_RECOVERY(3,
 			shost_printk(KERN_INFO, shost,
 				     "%s: Sending BRST chan: %d\n",
 				     current->comm, channel));
-		rtn = scsi_try_bus_reset(chan_scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
-			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-				if (channel == scmd_channel(scmd)) {
-					if (rtn == FAST_IO_FAIL) {
-						set_host_byte(scmd,
-							DID_TRANSPORT_FAILFAST);
-						scsi_eh_finish_cmd(scmd, done_q);
-					} else
-						list_move_tail(&scmd->eh_entry,
-							       &check_list);
-				}
-			}
-		} else {
+		rtn = scsi_try_bus_reset(scmd);
+		if (rtn != SUCCESS && rtn != FAST_IO_FAIL) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
 					     "%s: BRST failed chan: %d\n",
 					     current->comm, channel));
 		}
+		list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
+			if (scmd_channel(scmd) != channel)
+				continue;
+
+			if (rtn == SUCCESS)
+				list_move_tail(&scmd->eh_entry, &check_list);
+			else if (rtn == FAST_IO_FAIL) {
+				set_host_byte(scmd, DID_TRANSPORT_FAILFAST);
+				scsi_eh_finish_cmd(scmd, done_q);
+			} else
+				list_move_tail(&scmd->eh_entry, work_q);
+		}
 	}
 	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
 }
-- 
2.35.3

