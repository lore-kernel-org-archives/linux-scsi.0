Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCDEC004C0
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 09:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjJWJ3E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 05:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbjJWJ2u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 05:28:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CAFBE
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 02:28:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7DE5221AD0;
        Mon, 23 Oct 2023 09:28:43 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id D5E8A2CF58;
        Mon, 23 Oct 2023 09:28:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id F148C51EC34C; Mon, 23 Oct 2023 11:28:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/10] scsi: set host byte after EH completed
Date:   Mon, 23 Oct 2023 11:28:32 +0200
Message-Id: <20231023092837.33786-6-hare@suse.de>
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
         BAYES_HAM(-0.00)[12.03%]
X-Rspamd-Queue-Id: 7DE5221AD0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When SCSI EH completes we should be setting the host byte to
DID_ABORT, DID_RESET, or DID_TRANSPORT_DISRUPTED to inform
the caller that some EH processing has happened.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 826bc7f4d59f..42e12756d6f4 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1450,9 +1450,10 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 			if (scmd->device == sdev) {
 				if (finish_cmds &&
 				    (try_stu ||
-				     scsi_eh_action(scmd, SUCCESS) == SUCCESS))
+				     scsi_eh_action(scmd, SUCCESS) == SUCCESS)) {
+					set_host_byte(scmd, DID_RESET);
 					scsi_eh_finish_cmd(scmd, done_q);
-				else
+				} else
 					list_move_tail(&scmd->eh_entry, work_q);
 			}
 	}
@@ -1599,9 +1600,10 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				list_for_each_entry_safe(scmd, next,
 							 work_q, eh_entry) {
 					if (scmd->device == sdev &&
-					    scsi_eh_action(scmd, rtn) != FAILED)
-						scsi_eh_finish_cmd(scmd,
-								   done_q);
+					    scsi_eh_action(scmd, rtn) != FAILED) {
+						set_host_byte(scmd, DID_RESET);
+						scsi_eh_finish_cmd(scmd, done_q);
+					}
 				}
 			}
 		} else {
@@ -1670,9 +1672,10 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 
 			if (rtn == SUCCESS)
 				list_move_tail(&scmd->eh_entry, &check_list);
-			else if (rtn == FAST_IO_FAIL)
+			else if (rtn == FAST_IO_FAIL) {
+				set_host_byte(scmd, DID_TRANSPORT_FAILFAST);
 				scsi_eh_finish_cmd(scmd, done_q);
-			else
+			} else
 				/* push back on work queue for further processing */
 				list_move(&scmd->eh_entry, work_q);
 		}
@@ -1735,10 +1738,11 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (channel == scmd_channel(scmd)) {
-					if (rtn == FAST_IO_FAIL)
-						scsi_eh_finish_cmd(scmd,
-								   done_q);
-					else
+					if (rtn == FAST_IO_FAIL) {
+						set_host_byte(scmd,
+							DID_TRANSPORT_FAILFAST);
+						scsi_eh_finish_cmd(scmd, done_q);
+					} else
 						list_move_tail(&scmd->eh_entry,
 							       &check_list);
 				}
@@ -1781,7 +1785,8 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
 			list_splice_init(work_q, &check_list);
 		} else if (rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-					scsi_eh_finish_cmd(scmd, done_q);
+				set_host_byte(scmd, DID_TRANSPORT_FAILFAST);
+				scsi_eh_finish_cmd(scmd, done_q);
 			}
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
-- 
2.35.3

