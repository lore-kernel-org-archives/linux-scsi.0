From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] isci: sas controller driver for 3.0
Date: Sun, 03 Jul 2011 14:14:45 -0500
Message-ID: <1309720485.2619.44.camel@mulgrave>
References: <1309563349.19567.26.camel@dwillia2-linux>
	 <1309646729.2554.17.camel@mulgrave>  <4E0FD74F.4000701@intel.com>
	 <1309670184.2554.28.camel@mulgrave> <4E10024F.8020403@intel.com>
	 <1309693038.13127.20.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40512 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755707Ab1GCTOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jul 2011 15:14:48 -0400
In-Reply-To: <1309693038.13127.20.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, David Milburn <dmilburn@redhat.com>, Jeff Garzik <jeff@garzik.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "hare@suse.de" <hare@suse.de>

On Sun, 2011-07-03 at 04:37 -0700, Dan Williams wrote:
> On Sat, 2011-07-02 at 22:46 -0700, Dan Williams wrote:
> > > I just stopped at the first failure ... please ensure that there aren't
> > > any more ... as in test every bisection point in the tree, don't just
> > > squash the commit I've flagged as failing.
> > >
> > > The fact that there is a bisection failure tends to indicate you haven't
> > > been careful to check each commit in the tree ... which does make it
> > > suspect and will mean every commit in the reconstituted tree needs
> > > checking for bisectability.
> > >
> > 
> > Will verify each commit.
> 
> I have pushed out a rebased tree it:
> 
> 1/ discards the history prior to the first public release of the driver.
> 
> 2/ discards merge commits and the cherry-pick backports
> 
> 3/ deletes the reverts, and moves the CONFIG_EFI=n compile fix into the
> patch that introduced efi support.  No other commit edits were required
> after this step.
> 
> 4/ passes a compile test of every commit using a script like:
> for p in $(stg series --noprefix | xargs)
> do
>         stg goto $p
>         if ! make -j 8; then
>                 echo $p >> build-breakers
>         else
>                 echo $p >> build-clean
>         fi
> done
> 
> 5/ is identical to the previous release

Great, thanks.

You still have nine legitimate checkpatch.pl errors (all of which were
introduced in your series).  I applied the following to fix them, but I
need future patches to be checkpatch clean as well, please.

James

---

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index d8f893e..79313a7 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -197,7 +197,7 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	llctl = SCU_SAS_LLCTL_GEN_VAL(NO_OUTBOUND_TASK_TIMEOUT,
 		(u8)ihost->user_parameters.no_outbound_task_timeout);
 
-	switch(phy_user->max_speed_generation) {
+	switch (phy_user->max_speed_generation) {
 	case SCIC_SDS_PARM_GEN3_SPEED:
 		link_rate = SCU_SAS_LINK_LAYER_CONTROL_MAX_LINK_RATE_GEN3;
 		break;
diff --git a/drivers/scsi/isci/probe_roms.c b/drivers/scsi/isci/probe_roms.c
index 4b9d813..917d437 100644
--- a/drivers/scsi/isci/probe_roms.c
+++ b/drivers/scsi/isci/probe_roms.c
@@ -34,8 +34,9 @@
 #include "task.h"
 #include "probe_roms.h"
 
-static efi_char16_t isci_efivar_name[] =
-			{'R', 's', 't', 'S', 'c', 'u', 'O'};
+static efi_char16_t isci_efivar_name[] = {
+	'R', 's', 't', 'S', 'c', 'u', 'O'
+};
 
 struct isci_orom *isci_request_oprom(struct pci_dev *pdev)
 {
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 85e54f5..b6e6368 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -73,7 +73,7 @@
 static void isci_remote_device_not_ready(struct isci_host *ihost,
 				  struct isci_remote_device *idev, u32 reason)
 {
-	struct isci_request * ireq;
+	struct isci_request *ireq;
 
 	dev_dbg(&ihost->pdev->dev,
 		"%s: isci_device = %p\n", __func__, idev);
diff --git a/drivers/scsi/isci/request.h b/drivers/scsi/isci/request.h
index 11bc279..7a1d5a9 100644
--- a/drivers/scsi/isci/request.h
+++ b/drivers/scsi/isci/request.h
@@ -440,8 +440,8 @@ void sci_smp_request_copy_response(struct isci_request *ireq);
 static inline int isci_task_is_ncq_recovery(struct sas_task *task)
 {
 	return (sas_protocol_ata(task->task_proto) &&
-	        task->ata_task.fis.command == ATA_CMD_READ_LOG_EXT &&
-	        task->ata_task.fis.lbal == ATA_LOG_SATA_NCQ);
+		task->ata_task.fis.command == ATA_CMD_READ_LOG_EXT &&
+		task->ata_task.fis.lbal == ATA_LOG_SATA_NCQ);
 
 }
 
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 2df45c5..d6bcdd0 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -88,44 +88,45 @@ static void isci_task_refuse(struct isci_host *ihost, struct sas_task *task,
 	 * function should not be completed to the host in the regular path.
 	 */
 	switch (disposition) {
-		case isci_perform_normal_io_completion:
-			/* Normal notification (task_done) */
-			dev_dbg(&ihost->pdev->dev,
-				"%s: Normal - task = %p, response=%d, "
-				"status=%d\n",
-				__func__, task, response, status);
+	case isci_perform_normal_io_completion:
+		/* Normal notification (task_done) */
+		dev_dbg(&ihost->pdev->dev,
+			"%s: Normal - task = %p, response=%d, "
+			"status=%d\n",
+			__func__, task, response, status);
 
-			task->lldd_task = NULL;
+		task->lldd_task = NULL;
 
-			isci_execpath_callback(ihost, task, task->task_done);
-			break;
+		isci_execpath_callback(ihost, task, task->task_done);
+		break;
 
-		case isci_perform_aborted_io_completion:
-			/* No notification because this request is already in the
-			* abort path.
-			*/
-			dev_dbg(&ihost->pdev->dev,
-				 "%s: Aborted - task = %p, response=%d, "
-				"status=%d\n",
-				 __func__, task, response, status);
-			break;
+	case isci_perform_aborted_io_completion:
+		/*
+		 * No notification because this request is already in the
+		 * abort path.
+		 */
+		dev_dbg(&ihost->pdev->dev,
+			"%s: Aborted - task = %p, response=%d, "
+			"status=%d\n",
+			__func__, task, response, status);
+		break;
 
-		case isci_perform_error_io_completion:
-			/* Use sas_task_abort */
-			dev_dbg(&ihost->pdev->dev,
-				 "%s: Error - task = %p, response=%d, "
-				"status=%d\n",
-				 __func__, task, response, status);
+	case isci_perform_error_io_completion:
+		/* Use sas_task_abort */
+		dev_dbg(&ihost->pdev->dev,
+			"%s: Error - task = %p, response=%d, "
+			"status=%d\n",
+			__func__, task, response, status);
 
-			isci_execpath_callback(ihost, task, sas_task_abort);
-			break;
+		isci_execpath_callback(ihost, task, sas_task_abort);
+		break;
 
-		default:
-			dev_dbg(&ihost->pdev->dev,
-				 "%s: isci task notification default case!",
-				 __func__);
-			sas_task_abort(task);
-			break;
+	default:
+		dev_dbg(&ihost->pdev->dev,
+			"%s: isci task notification default case!",
+			__func__);
+		sas_task_abort(task);
+		break;
 	}
 }
 
@@ -1056,7 +1057,7 @@ int isci_task_abort_task(struct sas_task *task)
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: old_request == %p\n", __func__, old_request);
 
-	any_dev_reset = isci_device_is_reset_pending(isci_host,isci_device);
+	any_dev_reset = isci_device_is_reset_pending(isci_host, isci_device);
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 
@@ -1115,9 +1116,9 @@ int isci_task_abort_task(struct sas_task *task)
 				__func__, task);
 		}
 		goto out;
-	}
-	else
+	} else {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
+	}
 
 	spin_lock_irqsave(&isci_host->scic_lock, flags);
 


