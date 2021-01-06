Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E66C433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5310B22EBF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbhAGEwb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 23:52:31 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.221.30]:51644 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727021AbhAGEwb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 23:52:31 -0500
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id A00C4398D0;
        Wed,  6 Jan 2021 20:41:58 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com A00C4398D0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1609994519;
        bh=pSYkeLq0QOewKsgKXqAmYmXBx81AhVPYgbCJhRRnHoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+OKGGuEA67S0L0IZuXRuaRupNJuaQ+qFU9hUdfKYno7yYhWDO1GXJb4PXpziZzJX
         2A5f2p6kCEh2YSbzuGvlTh425iH3sLSYm8/B6xvcOJSDDI5y2oPJXwmcn/I5FVq8xY
         AF7rz52j/Mqj960xSCwYBePG2SLSrRfjsJIPTvEI=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v8 2/5] scsi: No retries on abort success
Date:   Thu,  7 Jan 2021 03:19:05 +0530
Message-Id: <1609969748-17684-3-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Added a new optional routine eh_should_retry_cmd
in scsi_host_template that allows the transport to decide if a
cmd is retryable.Return true if the transport is in a state the
cmd should be retried on.

Added a new interface scsi_eh_should_retry_cmd which checks and
calls the new routine eh_should_retry_cmd.

Made changes in scmd_eh_abort_handler and scsi_eh_flush_done_q which
calls the scsi_eh_should_retry_cmd to check whether the
command needs to be retried.

The above changes were done based on a patch by Mike Christie.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v8:
Rebased the patches on top of 5.11-rc2

v7:
Added New routine in scsi_host_template to decide if a cmd is
retryable instead of checking the same using  SCMD_NORETRIES_ABORT
bit as the cmd retry part can be checked by validating the port state.

Moved the DID_TRANSPORT_MARGINAL changes to previous patch
for reordering

v6:
Rearranged the patch by merging second hunk of the patch2 in v5
to this patch

v5:
added the DID_TRANSPORT_MARGINAL case to
scsi_decide_disposition
v4:
Modified the comments in the code appropriately

v3:
Merged  first part of the previous patch(v2 patch3) with
this patch.

v2:
set the hostbyte as DID_TRANSPORT_MARGINAL instead of
DID_TRANSPORT_FAILFAST.
---
 drivers/scsi/scsi_error.c | 17 +++++++++++++++--
 include/scsi/scsi_host.h  |  6 ++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 28056ee498b3..1cdfa5a8ca09 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -124,6 +124,17 @@ static bool scsi_cmd_retry_allowed(struct scsi_cmnd *cmd)
 	return ++cmd->retries <= cmd->allowed;
 }
 
+static bool scsi_eh_should_retry_cmd(struct scsi_cmnd *cmd)
+{
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *host = sdev->host;
+
+	if (host->hostt->eh_should_retry_cmd)
+		return  host->hostt->eh_should_retry_cmd(cmd);
+
+	return true;
+}
+
 /**
  * scmd_eh_abort_handler - Handle command aborts
  * @work:	command to be aborted.
@@ -159,7 +170,8 @@ scmd_eh_abort_handler(struct work_struct *work)
 						    "eh timeout, not retrying "
 						    "aborted command\n"));
 			} else if (!scsi_noretry_cmd(scmd) &&
-				   scsi_cmd_retry_allowed(scmd)) {
+				   scsi_cmd_retry_allowed(scmd) &&
+				scsi_eh_should_retry_cmd(scmd)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
 						    "retry aborted command\n"));
@@ -2111,7 +2123,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
-		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd)) {
+		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd) &&
+			scsi_eh_should_retry_cmd(scmd)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
 					     "%s: flush retry cmd\n",
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 701f178b20ae..e30fd963b97d 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -314,6 +314,12 @@ struct scsi_host_template {
 	 * Status: OPTIONAL
 	 */
 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
+	/*
+	 * Optional routine that allows the transport to decide if a cmd
+	 * is retryable. Return true if the transport is in a state the
+	 * cmd should be retried on.
+	 */
+	bool (*eh_should_retry_cmd)(struct scsi_cmnd *scmd);
 
 	/* This is an optional routine that allows transport to initiate
 	 * LLD adapter or firmware reset using sysfs attribute.
-- 
2.26.2

