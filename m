From: akpm@linux-foundation.org
Subject: [patch 1/2] drivers/message/fusion/mptsas.c: fix warning
Date: Tue, 18 Jan 2011 14:01:31 -0800
Message-ID: <201101182201.p0IM1W4g007848@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730Ab1ARWBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 17:01:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Eric.Moore@lsil.com

From: Andrew Morton <akpm@linux-foundation.org>

drivers/message/fusion/mptsas.c: In function 'mptsas_event_process':
drivers/message/fusion/mptsas.c:5010: warning: unused variable 'log_info'

Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptsas.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/message/fusion/mptsas.c~drivers-message-fusion-mptsasc-fix-warning drivers/message/fusion/mptsas.c
--- a/drivers/message/fusion/mptsas.c~drivers-message-fusion-mptsasc-fix-warning
+++ a/drivers/message/fusion/mptsas.c
@@ -5009,7 +5009,6 @@ mptsas_event_process(MPT_ADAPTER *ioc, E
 			(ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)) {
 			VirtTarget *vtarget = NULL;
 			u8		id, channel;
-			u32	 log_info = le32_to_cpu(reply->IOCLogInfo);
 
 			id = sas_event_data->TargetID;
 			channel = sas_event_data->Bus;
@@ -5020,7 +5019,8 @@ mptsas_event_process(MPT_ADAPTER *ioc, E
 				    "LogInfo (0x%x) available for "
 				   "INTERNAL_DEVICE_RESET"
 				   "fw_id %d fw_channel %d\n", ioc->name,
-				   log_info, id, channel));
+				   le32_to_cpu(reply->IOCLogInfo), id,
+				   channel));
 				if (vtarget->raidVolume) {
 					devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 					"Skipping Raid Volume for inDMD\n",
_
