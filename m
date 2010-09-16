From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH] scsi, mptsas : drop scsi_host lock when calling mptsas_qcmd
Date: Thu, 16 Sep 2010 12:44:14 -0700
Message-ID: <1284666254.7280.54.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57346 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab0IPTnF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 15:43:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, vasu.dev@intel.com, ak@linux.intel.com, willy@linux.intel.com

During testing of FFSB benchmark (configured with 
128 threaded write to 128 files on 16 SSD), scsi_host lock was 
heavily contended, accounting for 23.7% of cpu cycles.  There
are 64 cores in our test system and the JBOD
is connected with a mptsas HBA.  Taking a similar approach
as the patch by Vasu (http://permalink.gmane.org/gmane.linux.scsi.open-fcoe.devel/10110)
for Fiber Channel adapter, the following patch on 2.6.35 kernel 
avoids taking the scsi host lock when queueing mptsas scsi command. We see
a big drop in the cpu cycles contending for the lock (from 23.7% to 1.8%).  
The number of IO per sec increase by 10.6% from 62.9K per sec to 69.6K per sec.

If there is no good reason to prevent mptsas_qcmd from being 
executed in parallel, we should remove this lock from the queue 
command code path.  Other adapters probably can
benefit in a similar manner.


                        %cpu cycles contending host lock
                        2.6.35		2.6.35+patch
-----------------------------------------------------
scsi_dispatch_cmd       5.5%		0.44%
scsi_device_unbusy      6.1%		0.66%
scsi_request_fn         6.6%		0.35%
scsi_run_queue          5.5%		0.35%


Tim Chen


Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index ac000e8..ab3aab9 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4984,6 +4984,8 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sh->max_lun = max_lun;
 	sh->transportt = mptsas_transport_template;
 
+	sh->unlocked_qcmds = 1;
+
 	/* Required entry.
 	 */
 	sh->unique_id = ioc->id;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ad0ed21..3819d66 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -749,11 +749,16 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	if (unlikely(host->shost_state == SHOST_DEL)) {
 		cmd->result = (DID_NO_CONNECT << 16);
 		scsi_done(cmd);
+		spin_unlock_irqrestore(host->host_lock, flags);
 	} else {
 		trace_scsi_dispatch_cmd_start(cmd);
+		if (host->unlocked_qcmds)
+			spin_unlock_irqrestore(host->host_lock, flags);
 		rtn = host->hostt->queuecommand(cmd, scsi_done);
+		if (!host->unlocked_qcmds)
+			spin_unlock_irqrestore(host->host_lock, flags);
 	}
-	spin_unlock_irqrestore(host->host_lock, flags);
+
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b7bdecb..1814c51 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -636,6 +636,9 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	unsigned async_scan:1;
 
+	/* call queuecommand without Scsi_Host lock held */
+	unsigned unlocked_qcmds:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */



