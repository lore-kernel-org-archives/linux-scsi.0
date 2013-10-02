From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/3] target: Reset data_length for COMPARE_AND_WRITE to NoLB * block_size
Date: Wed,  2 Oct 2013 00:13:14 +0000
Message-ID: <1380672796-437-2-git-send-email-nab@daterainc.com>
References: <1380672796-437-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:57800 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3JBAab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2013 20:30:31 -0400
Received: by mail-oa0-f48.google.com with SMTP id m6so102920oag.35
        for <linux-scsi@vger.kernel.org>; Tue, 01 Oct 2013 17:30:31 -0700 (PDT)
In-Reply-To: <1380672796-437-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch resets se_cmd->data_length for COMPARE_AND_WRITE emulation
within sbc_compare_and_write() to NoLB * block_size in order to address
a bug with FILEIO backends where a I/O failure will occur when data_length
does not match the I/O size being actually dispatched for the individual
per block READs + WRITEs.

This is done late enough in sbc_compare_and_write() after the memory
allocations have occured in transport_generic_new_cmd() to not cause
any unwanted side-effects.

Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Thomas Glanzmann <thomas@glanzmann.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 6c17295..a9dca11 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -508,6 +508,12 @@ sbc_compare_and_write(struct se_cmd *cmd)
 		cmd->transport_complete_callback = NULL;
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
+	/*
+	 * Reset cmd->data_length to individual block_size in order to not
+	 * confuse backend drivers that depend on this value matching the
+	 * size of the I/O being submitted.
+	 */
+	cmd->data_length = cmd->t_task_nolb * dev->dev_attrib.block_size;
 
 	ret = cmd->execute_rw(cmd, cmd->t_bidi_data_sg, cmd->t_bidi_data_nents,
 			      DMA_FROM_DEVICE);
-- 
1.8.4.rc3

