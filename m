From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.15-rc8
Date: Fri, 19 Jan 2018 14:12:25 -0800
Message-ID: <1516399945.29417.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48680 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756492AbeASWM1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 17:12:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

One fix for SAS attached SATA CD-ROMs.  It turns out that the libata
handling of CD devices relies on the SCSI error handler, so disable
async aborts (which don't start the error handler) for these devices.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Hannes Reinecke (1):
      scsi: libsas: Disable asynchronous aborts for SATA devices

And the diffstat:

 drivers/scsi/libsas/sas_scsi_host.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 91795eb56206..eea94aa4091c 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -486,15 +486,28 @@ static int sas_queue_reset(struct domain_device *dev, int reset_type,
 
 int sas_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	int res;
+	int res = TMF_RESP_FUNC_FAILED;
 	struct sas_task *task = TO_SAS_TASK(cmd);
 	struct Scsi_Host *host = cmd->device->host;
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct sas_internal *i = to_sas_internal(host->transportt);
+	unsigned long flags;
 
 	if (!i->dft->lldd_abort_task)
 		return FAILED;
 
-	res = i->dft->lldd_abort_task(task);
+	spin_lock_irqsave(host->host_lock, flags);
+	/* We cannot do async aborts for SATA devices */
+	if (dev_is_sata(dev) && !host->host_eh_scheduled) {
+		spin_unlock_irqrestore(host->host_lock, flags);
+		return FAILED;
+	}
+	spin_unlock_irqrestore(host->host_lock, flags);
+
+	if (task)
+		res = i->dft->lldd_abort_task(task);
+	else
+		SAS_DPRINTK("no task to abort\n");
 	if (res == TMF_RESP_FUNC_SUCC || res == TMF_RESP_FUNC_COMPLETE)
 		return SUCCESS;
 
