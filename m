From: jiang.biao2@zte.com.cn
Subject: [Patch] scsi_error: should not get sense for timeout IO in scsi error
 handler
Date: Fri, 31 Jul 2015 17:52:10 +0800
Message-ID: <OFAF74C95C.6058723F-ON48257E93.00322982-48257E93.00363C6C@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx7.zte.com.cn ([202.103.147.169]:47117 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751029AbbGaKIu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 06:08:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@odin.com

scsi_error: should not get sense for timeout IO in scsi error handler

When an IO timeout occurs, the IO will be aborted in
scsi_abort_command() and SCSI_EH_ABORT_SCHEDULED will be set. Because
of that, the SCSI_EH_CANCEL_CMD will be clear in scsi_eh_scmd_add().
So when scsi error handler starts, it will get sense for this
timeout IO and the scmd of the IO request will be reused. In that
case, the scmd may be double released when racing with io_done(),
which will result in crash.
SO SCSI_EH_ABORT_SCHEDULED should also be checked when getting sense.
The bug maybe reproduced when the link between host and disk is
unstable.

Signed-off-by: Jiang Biao <jiang.biao2@zte.com.cn>
Signed-off-by: Long Chun <long.chun@zte.com.cn>
Reviewed-by: Tan Hu <tan.hu@zte.com.cn>
Reviewed-by: Chen Donghai <chen.donghai@zte.com.cn>
Reviewed-by: Cai Qu <cai.qu@zte.com.cn>

diff -uprN drivers/scsi/scsi_error.c drivers_new/scsi/scsi_error.c
--- scsi/scsi_error.c   2015-07-31 16:03:18.000000000 +0800
+++ scsi_new/scsi_error.c       2015-07-31 16:29:25.000000000 +0800
@@ -1156,9 +1156,14 @@ int scsi_eh_get_sense(struct list_head *
        struct Scsi_Host *shost;
        int rtn;

+       /*
+        * If SCSI_EH_ABORT_SCHEDULED has been set, it is timeout IO,
+        * should not get sense.
+        */
        list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
                if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
-                   SCSI_SENSE_VALID(scmd))
+                   (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) ||
+                    SCSI_SENSE_VALID(scmd))
                        continue;

                shost = scmd->device->host;
