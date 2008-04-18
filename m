From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/3] zfcp: Remove zfcp_erp_wait from slave destory handler to fix deadlock
Date: Fri, 18 Apr 2008 12:51:56 +0200
Message-ID: <20080418105455.513195000@de.ibm.com>
References: <20080418105154.135704000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:59298 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYDRKy5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Apr 2008 06:54:57 -0400
Content-Disposition: inline; filename=zfcp-fix-60s-chpid-off-on.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The testcase
# chchp -v 0 0.da && sleep 59 && chchp -v 1 0.da
results in this deadlock situation:

STACK TRACE FOR TASK: 0x7e9a2048 (zfcperp0.0.c613)
0 schedule+816 [0x356b3c]
1 schedule_timeout+172 [0x357340]
2 wait_for_common+192 [0x3565fc]
3 flush_cpu_workqueue+116 [0x52af0]
4 flush_workqueue+116 [0x533b8]
5 fc_remote_port_add+64 [0x1c83ec]
6 zfcp_erp_thread+4534 [0x26585a]
7 kernel_thread_starter+6 [0x195d2]

STACK TRACE FOR TASK: 0x7f8ec048 (fc_wq_0)
0 schedule+816 [0x356b3c]
1 zfcp_erp_wait+104 [0x264568]
2 zfcp_scsi_slave_destroy+64 [0x261b24]
3 __scsi_remove_device+154 [0x1c24ba]
4 scsi_remove_device+62 [0x1c2512]
5 __scsi_remove_target+198 [0x1c25ea]
6 __remove_child+58 [0x1c26d6]
7 device_for_each_child+66 [0x1ab566]
8 scsi_remove_target+98 [0x1c268a]
9 run_workqueue+200 [0x5272c]
10 worker_thread+146 [0x52882]
11 kthread+140 [0x58360]
12 kernel_thread_starter+6 [0x195d2]

Remove the zfcp_erp_wait call that is not required here to prevent the
deadlock situation.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2008-04-18 12:43:05.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-04-18 12:43:09.000000000 +0200
@@ -181,7 +181,6 @@ static void zfcp_scsi_slave_destroy(stru
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
 
 	if (unit) {
-		zfcp_erp_wait(unit->port->adapter);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
 		sdpnt->hostdata = NULL;
 		unit->device = NULL;

-- 
