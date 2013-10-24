From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/3] target: Add missing XCOPY I/O operation sense_buffer
Date: Thu, 24 Oct 2013 07:30:57 +0000
Message-ID: <1382599859-13204-2-git-send-email-nab@daterainc.com>
References: <1382599859-13204-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:58605 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab3JXHsw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2013 03:48:52 -0400
Received: by mail-ob0-f177.google.com with SMTP id vb8so1931309obc.36
        for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2013 00:48:51 -0700 (PDT)
In-Reply-To: <1382599859-13204-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the missing xcopy_pt_cmd->sense_buffer[] required for
correctly handling CHECK_CONDITION exceptions within the locally
generated XCOPY I/O path.

Also update target_xcopy_read_source() + target_xcopy_setup_pt_cmd()
to pass this buffer into transport_init_se_cmd() to correctly setup
se_cmd->sense_buffer.

Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_xcopy.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index eeeaf99..5edcd2b 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -360,6 +360,7 @@ struct xcopy_pt_cmd {
 	struct se_cmd se_cmd;
 	struct xcopy_op *xcopy_op;
 	struct completion xpt_passthrough_sem;
+	unsigned char sense_buffer[TRANSPORT_SENSE_BUFFER];
 };
 
 static struct se_port xcopy_pt_port;
@@ -711,7 +712,7 @@ static int target_xcopy_read_source(
 		(unsigned long long)src_lba, src_sectors, length);
 
 	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, NULL, length,
-				DMA_FROM_DEVICE, 0, NULL);
+			      DMA_FROM_DEVICE, 0, &xpt_cmd->sense_buffer[0]);
 	xop->src_pt_cmd = xpt_cmd;
 
 	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, src_dev, &cdb[0],
@@ -771,7 +772,7 @@ static int target_xcopy_write_destination(
 		(unsigned long long)dst_lba, dst_sectors, length);
 
 	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, NULL, length,
-				DMA_TO_DEVICE, 0, NULL);
+			      DMA_TO_DEVICE, 0, &xpt_cmd->sense_buffer[0]);
 	xop->dst_pt_cmd = xpt_cmd;
 
 	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, dst_dev, &cdb[0],
-- 
1.7.2.5

