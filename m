From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 2/5] scsi host / scsi target state model update
Date: Thu, 16 Jun 2005 11:13:42 -0700
Message-ID: <20050616181342.GC20923@us.ibm.com>
References: <20050616181058.GA20923@us.ibm.com> <20050616181238.GB20923@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:32720 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261787AbVFPSNO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2005 14:13:14 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5GIDDIU023221
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:13:13 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5GIDDCk237622
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:13:13 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5GIDDZ3008808
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:13:13 -0400
Received: from hmsbounty.us.ibm.com (sig-9-48-50-108.mts.ibm.com [9.48.50.108])
	by d01av01.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j5GIDCiB008737
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:13:13 -0400
Content-Disposition: inline
In-Reply-To: <20050616181238.GB20923@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove the old scsi_host_cancel function as it has not been working for
sometime do to the device list possibly being empty when it is called and
possible race issues. Add setting of SHOST_CANCEL at the state of beginning
of scsi_remove_host.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/hosts.c |   18 +-----------------
 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi.c  |    2 +-
 2 files changed, 2 insertions(+), 18 deletions(-)

diff -puN drivers/scsi/hosts.c~host_cancel drivers/scsi/hosts.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/hosts.c~host_cancel	2005-06-16 10:43:44.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/hosts.c	2005-06-16 10:45:21.000000000 -0700
@@ -128,29 +128,13 @@ int scsi_host_set_state(struct Scsi_Host
 EXPORT_SYMBOL(scsi_host_set_state);
 
 /**
- * scsi_host_cancel - cancel outstanding IO to this host
- * @shost:	pointer to struct Scsi_Host
- * recovery:	recovery requested to run.
- **/
-static void scsi_host_cancel(struct Scsi_Host *shost, int recovery)
-{
-	struct scsi_device *sdev;
-
-	scsi_host_set_state(shost, SHOST_CANCEL);
-	shost_for_each_device(sdev, shost) {
-		scsi_device_cancel(sdev, recovery);
-	}
-	wait_event(shost->host_wait, (shost->shost_state != SHOST_RECOVERY));
-}
-
-/**
  * scsi_remove_host - remove a scsi host
  * @shost:	a pointer to a scsi host to remove
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
+	scsi_host_set_state(shost, SHOST_CANCEL);
 	scsi_forget_host(shost);
-	scsi_host_cancel(shost, 0);
 	scsi_proc_host_rm(shost);
 
 	scsi_host_set_state(shost, SHOST_DEL);
diff -puN drivers/scsi/scsi.c~host_cancel drivers/scsi/scsi.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/scsi.c~host_cancel	2005-06-16 10:43:44.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi.c	2005-06-16 10:43:44.000000000 -0700
@@ -632,7 +632,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	spin_lock_irqsave(host->host_lock, flags);
 	scsi_cmd_get_serial(host, cmd); 
 
-	if (unlikely(host->shost_state == SHOST_CANCEL)) {
+	if (unlikely(host->shost_state == SHOST_DEL)) {
 		cmd->result = (DID_NO_CONNECT << 16);
 		scsi_done(cmd);
 	} else {
_
