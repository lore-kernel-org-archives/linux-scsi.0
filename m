From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: [PATCH][SCSI] mpt2sas: fix for unused variable 'event_data' warning
Date: Tue, 26 Feb 2013 17:36:12 +0530
Message-ID: <20130226120612.GA1684@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:49838 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753724Ab3BZMJx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Feb 2013 07:09:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com
Cc: linux-scsi@vger.kernel.org, sreekanth.reddy@lsi.com

If CONFIG_SCSI_MPT2SAS_LOGGING is undefined, then these warnings are emitted

drivers/scsi/mpt2sas/mpt2sas_scsih.c: In function '_scsih_sas_broadcast_primitive_event'
drivers/scsi/mpt2sas/mpt2sas_scsih.c:5810:40: warning: unused variable 'event_data'

Use pr_info() function instead of dewtprintk().

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c6bdc92..197ccad 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5815,9 +5815,10 @@ _scsih_sas_broadcast_primitive_event(struct MPT2SAS_ADAPTER *ioc,
 	u8 task_abort_retries;
 
 	mutex_lock(&ioc->tm_cmds.mutex);
-	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter: phy number(%d), "
-	    "width(%d)\n", ioc->name, __func__, event_data->PhyNum,
-	     event_data->PortWidth));
+	pr_info(MPT2SAS_FMT
+		"%s: enter: phy number(%d), width(%d)\n",
+		ioc->name, __func__, event_data->PhyNum,
+		event_data->PortWidth);
 
 	_scsih_block_io_all_device(ioc);
 
