From: Borislav Petkov <bp@amd64.org>
Subject: [PATCH] mptsas: Fix annoying warning
Date: Mon,  2 May 2011 16:49:38 +0200
Message-ID: <1304347778-12129-1-git-send-email-bp@amd64.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49641 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759719Ab1EBOuJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2011 10:50:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Shut up

drivers/message/fusion/mptsas.c: In function 'mptsas_event_process':
drivers/message/fusion/mptsas.c:5015: warning: unused variable 'log_info'

for configs with CONFIG_SCSI_MPT2SAS_LOGGING unset.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/message/fusion/mptsas.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 66f9412..7596aec 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5012,7 +5012,6 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 			(ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)) {
 			VirtTarget *vtarget = NULL;
 			u8		id, channel;
-			u32	 log_info = le32_to_cpu(reply->IOCLogInfo);
 
 			id = sas_event_data->TargetID;
 			channel = sas_event_data->Bus;
@@ -5023,7 +5022,8 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 				    "LogInfo (0x%x) available for "
 				   "INTERNAL_DEVICE_RESET"
 				   "fw_id %d fw_channel %d\n", ioc->name,
-				   log_info, id, channel));
+				   le32_to_cpu(reply->IOCLogInfo),
+				   id, channel));
 				if (vtarget->raidVolume) {
 					devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 					"Skipping Raid Volume for inDMD\n",
-- 
1.7.4.rc2

