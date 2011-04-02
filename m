From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT] isci: update for 4/1
Date: Fri, 01 Apr 2011 18:15:50 -0700
Message-ID: <1301706950.1429.9.camel@dwillia2-linux>
References: <1301194067.28442.22.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57157 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab1DBBIU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 21:08:20 -0400
In-Reply-To: <1301194067.28442.22.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: David Milburn <dmilburn@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, hch@infradead.org, Jeff Skirvin <jeffrey.d.skirvin@intel.com>

isci.git has been updated with bug fixes around error handling and
cleanups driven by the ongoing review, details below.  The patches that
have not appeared on the mailing list are included inline.

--
Dan

The following changes since commit 2fdebe19b880dbf1e3d5b265da2f2aab887d9522:

  isci: Remove "screaming" data types (2011-03-26 19:23:23 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

Christoph Hellwig (5):
      isci: remove mmio wrappers
      isci: remove base_controller abstraction
      isci: remove base_request abstraction
      isci: kill dead data structures in scic_io_request.h
      isci: simplify request state handlers

Dan Williams (2):
      isci: cleanup isci_remote_device[_not]_ready interface
      isci: fix fragile/conditional isci_host lookups

Jeff Skirvin (4):
      isci: Properly handle requests in the "aborting" state.
      isci: Free host lock for SATA/STP abort escalation at submission time.
      isci: Fix use of SATA soft reset state machine.
      isci: Qualify when the host lock is managed for STP/SATA callbacks.

 drivers/scsi/isci/core/sci_base_controller.h       |  304 ---------
 drivers/scsi/isci/core/sci_base_remote_device.h    |    6 +-
 drivers/scsi/isci/core/sci_base_request.h          |  195 ------
 drivers/scsi/isci/core/sci_controller.h            |   29 -
 drivers/scsi/isci/core/scic_io_request.h           |  180 -----
 drivers/scsi/isci/core/scic_sds_controller.c       |  713 +++++++++-----------
 drivers/scsi/isci/core/scic_sds_controller.h       |  231 +++++--
 .../scsi/isci/core/scic_sds_controller_registers.h |  463 -------------
 drivers/scsi/isci/core/scic_sds_pci.h              |   94 ---
 drivers/scsi/isci/core/scic_sds_phy.c              |  146 +++--
 drivers/scsi/isci/core/scic_sds_phy_registers.h    |  248 -------
 drivers/scsi/isci/core/scic_sds_port.c             |  125 ++---
 drivers/scsi/isci/core/scic_sds_port.h             |   23 -
 drivers/scsi/isci/core/scic_sds_port_registers.h   |   81 ---
 drivers/scsi/isci/core/scic_sds_remote_device.c    |  160 ++---
 drivers/scsi/isci/core/scic_sds_remote_device.h    |    7 +-
 drivers/scsi/isci/core/scic_sds_request.c          |  572 +++++------------
 drivers/scsi/isci/core/scic_sds_request.h          |  138 +++--
 .../scsi/isci/core/scic_sds_smp_remote_device.c    |   69 +-
 drivers/scsi/isci/core/scic_sds_smp_request.c      |   54 +-
 drivers/scsi/isci/core/scic_sds_ssp_request.c      |   59 +--
 .../scsi/isci/core/scic_sds_stp_packet_request.c   |   36 +-
 .../scsi/isci/core/scic_sds_stp_remote_device.c    |  274 +++-----
 drivers/scsi/isci/core/scic_sds_stp_request.c      |  177 ++----
 drivers/scsi/isci/core/scic_sds_stp_request.h      |    4 -
 .../isci/core/scic_sds_unsolicited_frame_control.c |    5 +-
 drivers/scsi/isci/host.c                           |   10 +-
 drivers/scsi/isci/host.h                           |   13 +-
 drivers/scsi/isci/isci.h                           |    2 +-
 drivers/scsi/isci/phy.c                            |    2 +-
 drivers/scsi/isci/port.c                           |   68 +--
 drivers/scsi/isci/port.h                           |    5 +-
 drivers/scsi/isci/remote_device.c                  |   92 +--
 drivers/scsi/isci/remote_device.h                  |   71 +--
 drivers/scsi/isci/request.c                        |   50 +-
 drivers/scsi/isci/request.h                        |    2 +-
 drivers/scsi/isci/sata.c                           |   37 +-
 drivers/scsi/isci/task.c                           |  130 ++---
 drivers/scsi/isci/task.h                           |   37 +
 39 files changed, 1347 insertions(+), 3565 deletions(-)
 delete mode 100644 drivers/scsi/isci/core/sci_base_controller.h
 delete mode 100644 drivers/scsi/isci/core/sci_base_request.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_controller_registers.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_pci.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_phy_registers.h

commit b940f7fbc060ae202f7be4c8cb66b1c2193bcec9
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Thu Mar 31 13:10:34 2011 -0700

    isci: Properly handle requests in the "aborting" state.
    
    When a TMF times-out, the request is set back to "aborting".
    Requests in the "aborting" state must be terminated when
    LUN and device resets occur.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/request.h b/drivers/scsi/isci/request.h
index 4a63bb6..0c08da6 100644
--- a/drivers/scsi/isci/request.h
+++ b/drivers/scsi/isci/request.h
@@ -199,7 +199,7 @@ static inline enum isci_request_status isci_request_change_started_to_newstate(
 
 	old_state = isci_request->status;
 
-	if (old_state == started) {
+	if (old_state == started || old_state == aborting) {
 		BUG_ON(isci_request->io_request_completion != NULL);
 
 		isci_request->io_request_completion = completion_ptr;
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 7e96684..338f08e 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -903,7 +903,9 @@ static void isci_terminate_request(
 		new_request_state
 		);
 
-	if ((old_state == started) || (old_state == completed)) {
+	if ((old_state == started) ||
+	    (old_state == completed) ||
+	    (old_state == aborting)) {
 
 		/* If the old_state is started:
 		 * This request was not already being aborted. If it had been,
@@ -920,6 +922,10 @@ static void isci_terminate_request(
 		 * This request completed from the SCU hardware perspective
 		 * and now just needs cleaning up in terms of freeing the
 		 * request and potentially calling up to libsas.
+		 *
+		 * If old_state == aborting:
+		 * This request has already gone through a TMF timeout, but may
+		 * not have been terminated; needs cleaning up at least.
 		 */
 		isci_terminate_request_core(isci_host, isci_device,
 					    isci_request);
@@ -1297,14 +1303,16 @@ int isci_task_abort_task(struct sas_task *task)
 
 	spin_lock_irqsave(&isci_host->scic_lock, flags);
 
-	/* Check the request status and change to "aborting" if currently
+	/* Check the request status and change to "aborted" if currently
 	 * "starting"; if true then set the I/O kernel completion
 	 * struct that will be triggered when the request completes.
 	 */
 	old_state = isci_task_validate_request_to_abort(
 				old_request, isci_host, isci_device,
 				&aborted_io_completion);
-	if ((old_state != started) && (old_state != completed)) {
+	if ((old_state != started) &&
+	    (old_state != completed) &&
+	    (old_state != aborting)) {
 
 		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
 

commit b5a2fc10a57529f61960679b9ce79d638330d132
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Thu Mar 31 13:10:36 2011 -0700

    isci: Free host lock for SATA/STP abort escalation at submission time.
    
    In the case of I/O requests that fail at submit time because of a
    pending reset condition, the host lock for SATA/STP devices must be
    managed for any SCSI-initiated I/O before sas_task_abort is called.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index c6ce9d0..946caae 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -53,6 +53,7 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
+#include <scsi/sas_ata.h>
 #include "isci.h"
 #include "scic_remote_device.h"
 #include "scic_io_request.h"
@@ -356,33 +357,6 @@ int isci_request_alloc_tmf(
 }
 
 /**
- * isci_request_signal_device_reset() - This function will set the "device
- *    needs target reset" flag in the given sas_tasks' task_state_flags, and
- *    then cause the task to be added into the SCSI error handler queue which
- *    will eventually be escalated to a target reset.
- *
- *
- */
-static void isci_request_signal_device_reset(
-	struct isci_request *isci_request)
-{
-	unsigned long flags;
-	struct sas_task *task = isci_request_access_task(isci_request);
-
-	dev_dbg(&isci_request->isci_host->pdev->dev,
-		"%s: request=%p, task=%p\n", __func__, isci_request, task);
-
-	spin_lock_irqsave(&task->task_state_lock, flags);
-	task->task_state_flags |= SAS_TASK_NEED_DEV_RESET;
-	spin_unlock_irqrestore(&task->task_state_lock, flags);
-
-	/* Cause this task to be scheduled in the SCSI error handler
-	 * thread.
-	 */
-	sas_task_abort(task);
-}
-
-/**
  * isci_request_execute() - This function allocates the isci_request object,
  *    all fills in some common fields.
  * @isci_host: This parameter specifies the ISCI host object
@@ -453,11 +427,18 @@ int isci_request_execute(
 				/* Save the tag for possible task mgmt later. */
 				request->io_tag = scic_io_request_get_io_tag(
 						     request->sci_request_handle);
+			} else {
+				/* The request did not really start in the
+				 * hardware, so clear the request handle
+				 * here so no terminations will be done.
+				 */
+				request->sci_request_handle = NULL;
 			}
+
 		} else
 			dev_warn(&isci_host->pdev->dev,
-				 "%s: failed request start\n",
-				 __func__);
+				 "%s: failed request start (0x%x)\n",
+				 __func__, status);
 
 		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
 
@@ -467,7 +448,26 @@ int isci_request_execute(
 			* handler thread to work on this I/O and that
 			* we want a device reset.
 			*/
-			isci_request_signal_device_reset(request);
+			spin_lock_irqsave(&task->task_state_lock, flags);
+			task->task_state_flags |= SAS_TASK_NEED_DEV_RESET;
+			spin_unlock_irqrestore(&task->task_state_lock, flags);
+
+			/* Cause this task to be scheduled in the SCSI error handler
+			* thread.
+			*/
+			if (dev_is_sata(task->dev)) {
+				/* Since we are still in the submit path, and since
+				* libsas takes the host lock on behalf of SATA
+				* devices before I/O starts, we need to unlock
+				* before we can put the task in the error path.
+				*/
+				raw_local_irq_save(flags);
+				spin_unlock(isci_host->shost->host_lock);
+				sas_task_abort(task);
+				spin_lock(isci_host->shost->host_lock);
+				raw_local_irq_restore(flags);
+			} else
+				sas_task_abort(task);
 
 			/* Change the status, since we are holding
 			* the I/O until it is managed by the SCSI

commit 6834c1ea09d40c334521a916bb6b765993df72eb
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Thu Mar 31 13:10:38 2011 -0700

    isci: Fix use of SATA soft reset state machine.
    
    The driver SATA LUN reset function incorrectly sent an SRST deassert
    FIS, which is unnecessary because the core initiates the entire SATA
    soft reset state machine from the assert request.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/sata.c b/drivers/scsi/isci/sata.c
index 7a1b586..794ab7c 100644
--- a/drivers/scsi/isci/sata.c
+++ b/drivers/scsi/isci/sata.c
@@ -301,8 +301,8 @@ int isci_task_send_lu_reset_sata(
 	int ret = TMF_RESP_FUNC_FAILED;
 	unsigned long flags;
 
-	/* Send the initial SRST to the target */
-	#define ISCI_SRST_TIMEOUT_MS 20 /* 20 ms timeout. */
+	/* Send the soft reset to the target */
+	#define ISCI_SRST_TIMEOUT_MS 25000 /* 25 second timeout. */
 	isci_task_build_tmf(&tmf, isci_device, isci_tmf_sata_srst_high,
 			    NULL, NULL
 			    );
@@ -319,38 +319,6 @@ int isci_task_send_lu_reset_sata(
 		/* Return the failure so that the LUN reset is escalated
 		 * to a target reset.
 		 */
-		goto out;
 	}
-
-	/* Leave SRST high for a bit. */
-	#define ISCI_SRST_ASSERT_DELAY 100 /* usecs */
-	udelay(ISCI_SRST_ASSERT_DELAY);
-
-	/* Deassert SRST. */
-	isci_task_build_tmf(&tmf, isci_device, isci_tmf_sata_srst_low,
-			    NULL, NULL
-			    );
-	ret = isci_task_execute_tmf(isci_host, &tmf, ISCI_SRST_TIMEOUT_MS);
-
-	if (ret == TMF_RESP_FUNC_COMPLETE)
-		dev_dbg(&isci_host->pdev->dev,
-			"%s: SATA LUN reset passed (%p)\n",
-			__func__,
-			isci_device);
-	else
-		dev_warn(&isci_host->pdev->dev,
-			 "%s: Deassert SRST failed (%p)=%x\n",
-			 __func__,
-			 isci_device,
-			 ret);
-
- out:
-	spin_lock_irqsave(&isci_host->scic_lock, flags);
-
-	/* Resume the device. */
-	scic_sds_remote_device_resume(to_sci_dev(isci_device));
-
-	spin_unlock_irqrestore(&isci_host->scic_lock, flags);
-
 	return ret;
 }

commit 40da93d97d03ca25355bea3ac4bc1203bbb17c92
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Thu Mar 31 13:10:40 2011 -0700

    isci: Qualify when the host lock is managed for STP/SATA callbacks.
    
    In the case of internal discovery related STP/SATA I/O started
    through sas_execute_task the host lock is not taken by libsas before
    calling lldd_execute_task, so the lock should not be managed before
    calling back to libsas through task->task_done or sas_task_abort.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 946caae..b519373 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -53,7 +53,6 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <scsi/sas_ata.h>
 #include "isci.h"
 #include "scic_remote_device.h"
 #include "scic_io_request.h"
@@ -452,22 +451,11 @@ int isci_request_execute(
 			task->task_state_flags |= SAS_TASK_NEED_DEV_RESET;
 			spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-			/* Cause this task to be scheduled in the SCSI error handler
-			* thread.
+			/* Cause this task to be scheduled in the SCSI error
+			* handler thread.
 			*/
-			if (dev_is_sata(task->dev)) {
-				/* Since we are still in the submit path, and since
-				* libsas takes the host lock on behalf of SATA
-				* devices before I/O starts, we need to unlock
-				* before we can put the task in the error path.
-				*/
-				raw_local_irq_save(flags);
-				spin_unlock(isci_host->shost->host_lock);
-				sas_task_abort(task);
-				spin_lock(isci_host->shost->host_lock);
-				raw_local_irq_restore(flags);
-			} else
-				sas_task_abort(task);
+			isci_execpath_callback(isci_host, task,
+					       sas_task_abort);
 
 			/* Change the status, since we are holding
 			* the I/O until it is managed by the SCSI
diff --git a/drivers/scsi/isci/sata.c b/drivers/scsi/isci/sata.c
index 794ab7c..c941d909 100644
--- a/drivers/scsi/isci/sata.c
+++ b/drivers/scsi/isci/sata.c
@@ -299,7 +299,6 @@ int isci_task_send_lu_reset_sata(
 {
 	struct isci_tmf tmf;
 	int ret = TMF_RESP_FUNC_FAILED;
-	unsigned long flags;
 
 	/* Send the soft reset to the target */
 	#define ISCI_SRST_TIMEOUT_MS 25000 /* 25 second timeout. */
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 338f08e..5bcea60 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -55,7 +55,6 @@
 
 #include <linux/completion.h>
 #include <linux/irqflags.h>
-#include <scsi/sas_ata.h>
 #include "scic_task_request.h"
 #include "scic_remote_device.h"
 #include "scic_io_request.h"
@@ -93,26 +92,13 @@ static void isci_task_refuse(struct isci_host *ihost, struct sas_task *task,
 		case isci_perform_normal_io_completion:
 			/* Normal notification (task_done) */
 			dev_dbg(&ihost->pdev->dev,
-				"%s: Normal - task = %p, response=%d, status=%d\n",
+				"%s: Normal - task = %p, response=%d, "
+				"status=%d\n",
 				__func__, task, response, status);
 
 			task->lldd_task = NULL;
-			if (dev_is_sata(task->dev)) {
-				/* Since we are still in the submit path, and since
-				* libsas takes the host lock on behalf of SATA
-				* devices before I/O starts, we need to unlock
-				* before we can call back and report the I/O
-				* submission error.
-				*/
-				unsigned long flags;
 
-				raw_local_irq_save(flags);
-				spin_unlock(ihost->shost->host_lock);
-				task->task_done(task);
-				spin_lock(ihost->shost->host_lock);
-				raw_local_irq_restore(flags);
-			} else
-				task->task_done(task);
+			isci_execpath_callback(ihost, task, task->task_done);
 			break;
 
 		case isci_perform_aborted_io_completion:
@@ -120,16 +106,19 @@ static void isci_task_refuse(struct isci_host *ihost, struct sas_task *task,
 			* abort path.
 			*/
 			dev_warn(&ihost->pdev->dev,
-				 "%s: Aborted - task = %p, response=%d, status=%d\n",
+				 "%s: Aborted - task = %p, response=%d, "
+				"status=%d\n",
 				 __func__, task, response, status);
 			break;
 
 		case isci_perform_error_io_completion:
 			/* Use sas_task_abort */
 			dev_warn(&ihost->pdev->dev,
-				 "%s: Error - task = %p, response=%d, status=%d\n",
+				 "%s: Error - task = %p, response=%d, "
+				"status=%d\n",
 				 __func__, task, response, status);
-			sas_task_abort(task);
+
+			isci_execpath_callback(ihost, task, sas_task_abort);
 			break;
 
 		default:
diff --git a/drivers/scsi/isci/task.h b/drivers/scsi/isci/task.h
index d7cb6fe..c5afd1c 100644
--- a/drivers/scsi/isci/task.h
+++ b/drivers/scsi/isci/task.h
@@ -56,6 +56,8 @@
 #if !defined(_ISCI_TASK_H_)
 #define _ISCI_TASK_H_
 
+#include <scsi/sas_ata.h>
+
 struct isci_request;
 struct isci_host;
 
@@ -332,5 +334,40 @@ isci_task_set_completion_status(
 	return task_notification_selection;
 
 }
+/**
+* isci_execpath_callback() - This function is called from the task
+* execute path when the task needs to callback libsas about the submit-time
+* task failure.  The callback occurs either through the task's done function
+* or through sas_task_abort.  In the case of regular non-discovery SATA/STP I/O
+* requests, libsas takes the host lock before calling execute task.  Therefore
+* in this situation the host lock must be managed before calling the func.
+*
+* @ihost: This parameter is the controller to which the I/O request was sent.
+* @task: This parameter is the I/O request.
+* @func: This parameter is the function to call in the correct context.
+* @status: This parameter is the status code for the completed task.
+*
+*/
+static inline void isci_execpath_callback(
+	struct isci_host *ihost,
+	struct sas_task  *task,
+	void (*func)(struct sas_task *))
+{
+	unsigned long flags;
+
+	if (dev_is_sata(task->dev) && task->uldd_task) {
+		/* Since we are still in the submit path, and since
+		* libsas takes the host lock on behalf of SATA
+		* devices before I/O starts (in the non-discovery case),
+		* we need to unlock before we can call the callback function.
+		*/
+		raw_local_irq_save(flags);
+		spin_unlock(ihost->shost->host_lock);
+		func(task);
+		spin_lock(ihost->shost->host_lock);
+		raw_local_irq_restore(flags);
+	} else
+		func(task);
+}
 
 #endif /* !defined(_SCI_TASK_H_) */

commit 9c1551f60d8c84ac168c92dbc956e6bfac7f14f4
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Mar 31 13:10:42 2011 -0700

    isci: cleanup isci_remote_device[_not]_ready interface
    
    Require a valid isci_host in support of the general cleanup to not
    re-lookup the host via potentially fragile methods when more robust
    methods are available.  Also cleans up some more casting that should be
    using container_of() to up-cast a base structure in a more type-safe
    manner.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/core/scic_sds_remote_device.c b/drivers/scsi/isci/core/scic_sds_remote_device.c
index e100fde..a6bcaa1 100644
--- a/drivers/scsi/isci/core/scic_sds_remote_device.c
+++ b/drivers/scsi/isci/core/scic_sds_remote_device.c
@@ -1513,24 +1513,19 @@ static void scic_sds_remote_device_stopped_state_enter(
  * sets the starting state handlers, sets the device not ready, and posts the
  * remote node context to the hardware. none
  */
-static void scic_sds_remote_device_starting_state_enter(
-	struct sci_base_object *object)
+static void scic_sds_remote_device_starting_state_enter(struct sci_base_object *object)
 {
-	struct scic_sds_controller *scic;
-	struct scic_sds_remote_device *sci_dev =
-		(struct scic_sds_remote_device *)object;
+	struct scic_sds_remote_device *sci_dev = container_of(object, typeof(*sci_dev),
+							      parent.parent);
+	struct scic_sds_controller *scic = scic_sds_remote_device_get_controller(sci_dev);
+	struct isci_host *ihost = sci_object_get_association(scic);
 	struct isci_remote_device *idev = sci_object_get_association(sci_dev);
 
-	scic = scic_sds_remote_device_get_controller(sci_dev);
-
-	SET_STATE_HANDLER(
-			sci_dev,
-			scic_sds_remote_device_state_handler_table,
-			SCI_BASE_REMOTE_DEVICE_STATE_STARTING);
+	SET_STATE_HANDLER(sci_dev, scic_sds_remote_device_state_handler_table,
+			  SCI_BASE_REMOTE_DEVICE_STATE_STARTING);
 
-	isci_remote_device_not_ready(
-			idev,
-			SCIC_REMOTE_DEVICE_NOT_READY_START_REQUESTED);
+	isci_remote_device_not_ready(ihost, idev,
+				     SCIC_REMOTE_DEVICE_NOT_READY_START_REQUESTED);
 }
 
 static void scic_sds_remote_device_starting_state_exit(struct sci_base_object *object)
@@ -1556,14 +1551,13 @@ static void scic_sds_remote_device_starting_state_exit(struct sci_base_object *o
  * This is the enter function for the SCI_BASE_REMOTE_DEVICE_STATE_READY it sets
  * the ready state handlers, and starts the ready substate machine. none
  */
-static void scic_sds_remote_device_ready_state_enter(
-	struct sci_base_object *object)
+static void scic_sds_remote_device_ready_state_enter(struct sci_base_object *object)
 {
-	struct scic_sds_remote_device *sci_dev =
-		(struct scic_sds_remote_device *)object;
+	struct scic_sds_remote_device *sci_dev = container_of(object, typeof(*sci_dev),
+							      parent.parent);
+	struct scic_sds_controller *scic = scic_sds_remote_device_get_controller(sci_dev);
+	struct isci_host *ihost = sci_object_get_association(scic);
 	struct isci_remote_device *idev = sci_object_get_association(sci_dev);
-	struct scic_sds_controller *scic
-		= scic_sds_remote_device_get_controller(sci_dev);
 
 	SET_STATE_HANDLER(sci_dev,
 			  scic_sds_remote_device_state_handler_table,
@@ -1574,7 +1568,7 @@ static void scic_sds_remote_device_ready_state_enter(
 	if (sci_dev->has_ready_substate_machine)
 		sci_base_state_machine_start(&sci_dev->ready_substate_machine);
 	else
-		isci_remote_device_ready(idev);
+		isci_remote_device_ready(ihost, idev);
 }
 
 /**
@@ -1588,16 +1582,18 @@ static void scic_sds_remote_device_ready_state_enter(
 static void scic_sds_remote_device_ready_state_exit(
 	struct sci_base_object *object)
 {
-	struct scic_sds_remote_device *sci_dev =
-		(struct scic_sds_remote_device *)object;
-	struct isci_remote_device *idev = sci_object_get_association(sci_dev);
-
+	struct scic_sds_remote_device *sci_dev = container_of(object, typeof(*sci_dev),
+							      parent.parent);
 	if (sci_dev->has_ready_substate_machine)
 		sci_base_state_machine_stop(&sci_dev->ready_substate_machine);
-	else
-		isci_remote_device_not_ready(
-				idev,
-				SCIC_REMOTE_DEVICE_NOT_READY_STOP_REQUESTED);
+	else {
+		struct scic_sds_controller *scic = scic_sds_remote_device_get_controller(sci_dev);
+		struct isci_host *ihost = sci_object_get_association(scic);
+		struct isci_remote_device *idev = sci_object_get_association(sci_dev);
+
+		isci_remote_device_not_ready(ihost, idev,
+					     SCIC_REMOTE_DEVICE_NOT_READY_STOP_REQUESTED);
+	}
 }
 
 /**
diff --git a/drivers/scsi/isci/core/scic_sds_smp_remote_device.c b/drivers/scsi/isci/core/scic_sds_smp_remote_device.c
index 5520248..06cb932 100644
--- a/drivers/scsi/isci/core/scic_sds_smp_remote_device.c
+++ b/drivers/scsi/isci/core/scic_sds_smp_remote_device.c
@@ -253,20 +253,19 @@ static const struct scic_sds_remote_device_state_handler scic_sds_smp_remote_dev
  * This function sets the ready cmd substate handlers and reports the device as
  * ready. none
  */
-static inline void scic_sds_smp_remote_device_ready_idle_substate_enter(
-	struct sci_base_object *object)
+static void scic_sds_smp_remote_device_ready_idle_substate_enter(struct sci_base_object *object)
 {
-	struct scic_sds_remote_device *sci_dev =
-		(struct scic_sds_remote_device *)object;
+	struct scic_sds_remote_device *sci_dev = container_of(object, typeof(*sci_dev),
+							      parent.parent);
+	struct scic_sds_controller *scic = scic_sds_remote_device_get_controller(sci_dev);
+	struct isci_host *ihost = sci_object_get_association(scic);
 	struct isci_remote_device *idev = sci_object_get_association(sci_dev);
 
+	SET_STATE_HANDLER(sci_dev,
+			  scic_sds_smp_remote_device_ready_substate_handler_table,
+			  SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_IDLE);
 
-	SET_STATE_HANDLER(
-			sci_dev,
-			scic_sds_smp_remote_device_ready_substate_handler_table,
-			SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_IDLE);
-
-	isci_remote_device_ready(idev);
+	isci_remote_device_ready(ihost, idev);
 }
 
 /**
@@ -281,20 +280,20 @@ static inline void scic_sds_smp_remote_device_ready_idle_substate_enter(
 static void scic_sds_smp_remote_device_ready_cmd_substate_enter(
 	struct sci_base_object *object)
 {
-	struct scic_sds_remote_device *sci_dev =
-		(struct scic_sds_remote_device *)object;
+	struct scic_sds_remote_device *sci_dev = container_of(object, typeof(*sci_dev),
+							      parent.parent);
+	struct scic_sds_controller *scic = scic_sds_remote_device_get_controller(sci_dev);
+	struct isci_host *ihost = sci_object_get_association(scic);
 	struct isci_remote_device *idev = sci_object_get_association(sci_dev);
 
 	BUG_ON(sci_dev->working_request == NULL);
 
-	SET_STATE_HANDLER(
-			sci_dev,
-			scic_sds_smp_remote_device_ready_substate_handler_table,
-			SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_CMD);
+	SET_STATE_HANDLER(sci_dev,
+			  scic_sds_smp_remote_device_ready_substate_handler_table,
+			  SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_CMD);
 
-	isci_remote_device_not_ready(
-			idev,
-			SCIC_REMOTE_DEVICE_NOT_READY_SMP_REQUEST_STARTED);
+	isci_remote_device_not_ready(ihost, idev,
+				     SCIC_REMOTE_DEVICE_NOT_READY_SMP_REQUEST_STARTED);
 }
 
 /**
@@ -304,12 +303,11 @@ static void scic_sds_smp_remote_device_ready_cmd_substate_enter(
  *
  * This is the SCIC_SDS_SSP_REMOTE_DEVICE_READY_SUBSTATE_CMD exit method. none
  */
-static void scic_sds_smp_remote_device_ready_cmd_substate_exit(
-	struct sci_base_object *object)
+static void scic_sds_smp_remote_device_ready_cmd_substate_exit(struct sci_base_object *object)
 {
-	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
-
-	this_device->working_request = NULL;
+	struct scic_sds_remote_device *sci_dev = container_of(object, typeof(*sci_dev),
+							      parent.parent);
+	sci_dev->working_request = NULL;
 }
 
 /* --------------------------------------------------------------------------- */
diff --git a/drivers/scsi/isci/core/scic_sds_stp_remote_device.c b/drivers/scsi/isci/core/scic_sds_stp_remote_device.c
index 193a95f..0a00a40 100644
--- a/drivers/scsi/isci/core/scic_sds_stp_remote_device.c
+++ b/drivers/scsi/isci/core/scic_sds_stp_remote_device.c
@@ -677,13 +677,13 @@ static const struct scic_sds_remote_device_state_handler scic_sds_stp_remote_dev
  * *  STP REMOTE DEVICE READY SUBSTATE PRIVATE METHODS
  * ***************************************************************************** */
 
-static inline void
-scic_sds_stp_remote_device_ready_idle_substate_resume_complete_handler(
-		void *user_cookie)
+static void
+scic_sds_stp_remote_device_ready_idle_substate_resume_complete_handler(void *user_cookie)
 {
-	struct scic_sds_remote_device *sci_dev =
-		(struct scic_sds_remote_device *)user_cookie;
+	struct scic_sds_remote_device *sci_dev = user_cookie;
 	struct isci_remote_device *idev = sci_object_get_association(sci_dev);
+	struct scic_sds_controller *scic = scic_sds_remote_device_get_controller(sci_dev);
+	struct isci_host *ihost = sci_object_get_association(scic);
 
 	/*
 	 * For NCQ operation we do not issue a
@@ -692,7 +692,7 @@ scic_sds_stp_remote_device_ready_idle_substate_resume_complete_handler(
 	 */
 	if (sci_dev->ready_substate_machine.previous_state_id !=
 			SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ)
-		isci_remote_device_ready(idev);
+		isci_remote_device_ready(ihost, idev);
 }
 
 /*
@@ -737,87 +737,48 @@ static void scic_sds_stp_remote_device_ready_idle_substate_enter(
 	}
 }
 
-/*
- * *****************************************************************************
- * *  STP REMOTE DEVICE READY CMD SUBSTATE
- * ***************************************************************************** */
-
-/**
- *
- * @device: This is the SCI base object which is cast into a
- *    struct scic_sds_remote_device object.
- *
- */
-static inline void scic_sds_stp_remote_device_ready_cmd_substate_enter(
-	struct sci_base_object *device)
+static void scic_sds_stp_remote_device_ready_cmd_substate_enter(struct sci_base_object *object)
 {
-	struct scic_sds_remote_device *sci_dev =
-		(struct scic_sds_remote_device *)device;
+	struct scic_sds_remote_device *sci_dev = container_of(object, typeof(*sci_dev),
+							      parent.parent);
+	struct scic_sds_controller *scic = scic_sds_remote_device_get_controller(sci_dev);
+	struct isci_host *ihost = sci_object_get_association(scic);
 	struct isci_remote_device *idev = sci_object_get_association(sci_dev);
 
 	BUG_ON(sci_dev->working_request == NULL);
 
-	SET_STATE_HANDLER(
-			sci_dev,
-			scic_sds_stp_remote_device_ready_substate_handler_table,
-			SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_CMD);
+	SET_STATE_HANDLER(sci_dev,
+			  scic_sds_stp_remote_device_ready_substate_handler_table,
+			  SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_CMD);
 
-	isci_remote_device_not_ready(
-			idev,
-			SCIC_REMOTE_DEVICE_NOT_READY_SATA_REQUEST_STARTED);
+	isci_remote_device_not_ready(ihost, idev,
+				     SCIC_REMOTE_DEVICE_NOT_READY_SATA_REQUEST_STARTED);
 }
 
-/*
- * *****************************************************************************
- * *  STP REMOTE DEVICE READY NCQ SUBSTATE
- * ***************************************************************************** */
-
-/**
- *
- * @device: This is the SCI base object which is cast into a
- *    struct scic_sds_remote_device object.
- *
- */
-static void scic_sds_stp_remote_device_ready_ncq_substate_enter(
-	struct sci_base_object *device)
+static void scic_sds_stp_remote_device_ready_ncq_substate_enter(struct sci_base_object *object)
 {
-	struct scic_sds_remote_device *this_device;
-
-	this_device = (struct scic_sds_remote_device *)device;
-
-	SET_STATE_HANDLER(
-		this_device,
-		scic_sds_stp_remote_device_ready_substate_handler_table,
-		SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ
-		);
+	struct scic_sds_remote_device *sci_dev = container_of(object, typeof(*sci_dev),
+							      parent.parent);
+	SET_STATE_HANDLER(sci_dev,
+			  scic_sds_stp_remote_device_ready_substate_handler_table,
+			  SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ);
 }
 
-/*
- * *****************************************************************************
- * *  STP REMOTE DEVICE READY NCQ ERROR SUBSTATE
- * ***************************************************************************** */
-
-/**
- *
- * @device: This is the SCI base object which is cast into a
- *    struct scic_sds_remote_device object.
- *
- */
-static inline void scic_sds_stp_remote_device_ready_ncq_error_substate_enter(
-	struct sci_base_object *device)
+static void scic_sds_stp_remote_device_ready_ncq_error_substate_enter(struct sci_base_object *object)
 {
-	struct scic_sds_remote_device *sci_dev =
-		(struct scic_sds_remote_device *)device;
+	struct scic_sds_remote_device *sci_dev = container_of(object, typeof(*sci_dev),
+							      parent.parent);
+	struct scic_sds_controller *scic = scic_sds_remote_device_get_controller(sci_dev);
+	struct isci_host *ihost = sci_object_get_association(scic);
 	struct isci_remote_device *idev = sci_object_get_association(sci_dev);
 
-	SET_STATE_HANDLER(
-			sci_dev,
-			scic_sds_stp_remote_device_ready_substate_handler_table,
-			SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ_ERROR);
+	SET_STATE_HANDLER(sci_dev,
+			  scic_sds_stp_remote_device_ready_substate_handler_table,
+			  SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ_ERROR);
 
 	if (sci_dev->not_ready_reason ==
 		SCIC_REMOTE_DEVICE_NOT_READY_SATA_SDB_ERROR_FIS_RECEIVED)
-		isci_remote_device_not_ready(idev, sci_dev->not_ready_reason);
+		isci_remote_device_not_ready(ihost, idev, sci_dev->not_ready_reason);
 }
 
 /*
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 6fe6815..0fdaa6d 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -281,13 +281,12 @@ isci_remote_device_alloc(struct isci_host *ihost, struct isci_port *iport)
  * isci_remote_device_ready() - This function is called by the scic when the
  *    remote device is ready. We mark the isci device as ready and signal the
  *    waiting proccess.
- * @idev: This parameter specifies the remote device
+ * @ihost: our valid isci_host
+ * @idev: remote device
  *
  */
-void isci_remote_device_ready(struct isci_remote_device *idev)
+void isci_remote_device_ready(struct isci_host *ihost, struct isci_remote_device *idev)
 {
-	struct isci_host *ihost = idev->isci_port->isci_host;
-
 	dev_dbg(&ihost->pdev->dev,
 		"%s: idev = %p\n", __func__, idev);
 
@@ -304,18 +303,17 @@ void isci_remote_device_ready(struct isci_remote_device *idev)
  * @isci_device: This parameter specifies the remote device
  *
  */
-void isci_remote_device_not_ready(
-	struct isci_remote_device *isci_device,
-	u32 reason_code)
+void isci_remote_device_not_ready(struct isci_host *ihost,
+				  struct isci_remote_device *idev, u32 reason)
 {
-	dev_dbg(&isci_device->isci_port->isci_host->pdev->dev,
-		"%s: isci_device = %p\n", __func__, isci_device);
+	dev_dbg(&ihost->pdev->dev,
+		"%s: isci_device = %p\n", __func__, idev);
 
-	if (reason_code == SCIC_REMOTE_DEVICE_NOT_READY_STOP_REQUESTED)
-		isci_remote_device_change_state(isci_device, isci_stopping);
+	if (reason == SCIC_REMOTE_DEVICE_NOT_READY_STOP_REQUESTED)
+		isci_remote_device_change_state(idev, isci_stopping);
 	else
 		/* device ready is actually a "not ready for io" state. */
-		isci_remote_device_change_state(isci_device, isci_ready);
+		isci_remote_device_change_state(idev, isci_ready);
 }
 
 /**
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index f45a5f0..cf5302a 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -109,12 +109,11 @@ enum sci_status isci_remote_device_stop(struct isci_host *ihost,
 void isci_remote_device_nuke_requests(
 	struct isci_remote_device *isci_device);
 
-void isci_remote_device_ready(
-	struct isci_remote_device *);
+void isci_remote_device_ready(struct isci_host *ihost,
+			      struct isci_remote_device *idev);
 
-void isci_remote_device_not_ready(
-	struct isci_remote_device *,
-	u32);
+void isci_remote_device_not_ready(struct isci_host *ihost,
+				  struct isci_remote_device *idev, u32 reason);
 
 void isci_remote_device_gone(
 	struct domain_device *domain_dev);

commit 495126b08f8834381b58030645c8208c401b32fc
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Mar 31 13:10:44 2011 -0700

    isci: fix fragile/conditional isci_host lookups
    
    A domain_device can always reference back to ->lldd_ha unlike local lldd
    structures.  Fix up cases where the driver uses local objects to look up the
    isci_host.  This also changes the calling conventions of some routines to
    expect a valid isci_host parameter rather than re-lookup the pointer on entry.
    
    Incidentally cleans up some macros that are longer to type than the open-coded
    equivalent:
      isci_host_from_sas_ha
      isci_dev_from_domain_dev
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 79515be..6644959 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -129,7 +129,7 @@ void isci_host_start_complete(struct isci_host *ihost, enum sci_status completio
 
 int isci_host_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
-	struct isci_host *ihost = isci_host_from_sas_ha(SHOST_TO_SAS_HA(shost));
+	struct isci_host *ihost = SHOST_TO_SAS_HA(shost)->lldd_ha;
 
 	if (test_bit(IHOST_START_PENDING, &ihost->flags))
 		return 0;
@@ -149,7 +149,7 @@ int isci_host_scan_finished(struct Scsi_Host *shost, unsigned long time)
 
 void isci_host_scan_start(struct Scsi_Host *shost)
 {
-	struct isci_host *ihost = isci_host_from_sas_ha(SHOST_TO_SAS_HA(shost));
+	struct isci_host *ihost = SHOST_TO_SAS_HA(shost)->lldd_ha;
 	struct scic_sds_controller *scic = ihost->core_controller;
 	unsigned long tmo = scic_controller_get_suggested_start_timeout(scic);
 
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index d012b69..8372094 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -233,15 +233,10 @@ static inline void wait_for_device_stop(struct isci_host *ihost, struct isci_rem
 	wait_event(ihost->eventq, !test_bit(IDEV_STOP_PENDING, &idev->flags));
 }
 
-/**
- * isci_host_from_sas_ha() - This accessor retrieves the isci_host object
- *    reference from the Linux sas_ha_struct reference.
- * @ha_struct,: This parameter points to the Linux sas_ha_struct object
- *
- * A reference to the associated isci_host structure.
- */
-#define isci_host_from_sas_ha(ha_struct) \
-	((struct isci_host *)(ha_struct)->lldd_ha)
+static inline struct isci_host *dev_to_ihost(struct domain_device *dev)
+{
+	return dev->port->ha->lldd_ha;
+}
 
 /**
  * isci_host_scan_finished() -
diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index decc0c0..9e081a4 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -163,7 +163,7 @@ int isci_phy_control(struct asd_sas_phy *sas_phy,
 			return -ENODEV;
 
 		/* Perform the port reset. */
-		ret = isci_port_perform_hard_reset(iport, iphy);
+		ret = isci_port_perform_hard_reset(ihost, iport, iphy);
 
 		break;
 
diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 74dc96d..b675a94 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -400,55 +400,43 @@ void isci_port_hard_reset_complete(struct isci_port *isci_port,
 
 	complete_all(&isci_port->hard_reset_complete);
 }
-/**
- * isci_port_perform_hard_reset() - This function is one of the SAS Domain
- *    Template functions. This is a phy management function.
- * @isci_port:
- * @isci_phy:
- *
- * status, TMF_RESP_FUNC_COMPLETE indicates success.
- */
-int isci_port_perform_hard_reset(
-	struct isci_port *isci_port,
-	struct isci_phy *isci_phy)
+
+int isci_port_perform_hard_reset(struct isci_host *ihost, struct isci_port *iport,
+				 struct isci_phy *iphy)
 {
+	unsigned long flags;
 	enum sci_status status;
 	int ret = TMF_RESP_FUNC_COMPLETE;
-	unsigned long flags;
 
+	dev_dbg(&ihost->pdev->dev, "%s: iport = %p\n",
+		__func__, iport);
 
-	dev_dbg(&isci_port->isci_host->pdev->dev,
-		"%s: isci_port = %p\n",
-		__func__, isci_port);
-
-	BUG_ON(isci_port == NULL);
-
-	init_completion(&isci_port->hard_reset_complete);
+	init_completion(&iport->hard_reset_complete);
 
-	spin_lock_irqsave(&isci_port->isci_host->scic_lock, flags);
+	spin_lock_irqsave(&ihost->scic_lock, flags);
 
 	#define ISCI_PORT_RESET_TIMEOUT SCIC_SDS_SIGNATURE_FIS_TIMEOUT
-	status = scic_port_hard_reset(isci_port->sci_port_handle,
+	status = scic_port_hard_reset(iport->sci_port_handle,
 				      ISCI_PORT_RESET_TIMEOUT);
 
-	spin_unlock_irqrestore(&isci_port->isci_host->scic_lock, flags);
+	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
 	if (status == SCI_SUCCESS) {
-		wait_for_completion(&isci_port->hard_reset_complete);
+		wait_for_completion(&iport->hard_reset_complete);
 
-		dev_dbg(&isci_port->isci_host->pdev->dev,
-			"%s: isci_port = %p; hard reset completion\n",
-			__func__, isci_port);
+		dev_dbg(&ihost->pdev->dev,
+			"%s: iport = %p; hard reset completion\n",
+			__func__, iport);
 
-		if (isci_port->hard_reset_status != SCI_SUCCESS)
+		if (iport->hard_reset_status != SCI_SUCCESS)
 			ret = TMF_RESP_FUNC_FAILED;
 	} else {
 		ret = TMF_RESP_FUNC_FAILED;
 
-		dev_err(&isci_port->isci_host->pdev->dev,
-			"%s: isci_port = %p; scic_port_hard_reset call"
+		dev_err(&ihost->pdev->dev,
+			"%s: iport = %p; scic_port_hard_reset call"
 			" failed 0x%x\n",
-			__func__, isci_port, status);
+			__func__, iport, status);
 
 	}
 
@@ -456,19 +444,12 @@ int isci_port_perform_hard_reset(
 	 * the same as link failures on all phys in the port.
 	 */
 	if (ret != TMF_RESP_FUNC_COMPLETE) {
-		BUG_ON(isci_port->isci_host == NULL);
-
-		dev_err(&isci_port->isci_host->pdev->dev,
-			"%s: isci_port = %p; hard reset failed "
+		dev_err(&ihost->pdev->dev,
+			"%s: iport = %p; hard reset failed "
 			"(0x%x) - sending link down to libsas for phy %p\n",
-			__func__,
-			isci_port,
-			isci_port->hard_reset_status,
-			isci_phy);
-
-		isci_port_link_down(isci_port->isci_host,
-				    isci_phy,
-				    isci_port);
+			__func__, iport, iport->hard_reset_status, iphy);
+
+		isci_port_link_down(ihost, iphy, iport);
 	}
 
 	return ret;
@@ -491,8 +472,7 @@ void isci_port_invalid_link_up(struct scic_sds_controller *scic,
 				      struct scic_sds_port *sci_port,
 				      struct scic_sds_phy *phy)
 {
-	struct isci_host *ihost =
-		(struct isci_host *)sci_object_get_association(scic);
+	struct isci_host *ihost = sci_object_get_association(scic);
 
 	dev_warn(&ihost->pdev->dev, "Invalid link up!\n");
 }
diff --git a/drivers/scsi/isci/port.h b/drivers/scsi/isci/port.h
index dfdd12a..76546fd 100644
--- a/drivers/scsi/isci/port.h
+++ b/drivers/scsi/isci/port.h
@@ -143,9 +143,8 @@ void isci_port_hard_reset_complete(
 	struct isci_port *isci_port,
 	enum sci_status completion_status);
 
-int isci_port_perform_hard_reset(
-	struct isci_port *isci_port_ptr,
-	struct isci_phy *isci_phy_ptr);
+int isci_port_perform_hard_reset(struct isci_host *ihost, struct isci_port *iport,
+				 struct isci_phy *iphy);
 
 void isci_port_invalid_link_up(
 		struct scic_sds_controller *scic,
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 0fdaa6d..ab638ec 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -218,33 +218,20 @@ static enum sci_status isci_remote_device_construct(
 	return status;
 }
 
-
-/**
- * isci_remote_device_nuke_requests() - This function terminates all requests
- *    for a given remote device.
- * @isci_device: This parameter specifies the remote device
- *
- */
-void isci_remote_device_nuke_requests(
-	struct isci_remote_device *isci_device)
+void isci_remote_device_nuke_requests(struct isci_host *ihost, struct isci_remote_device *idev)
 {
 	DECLARE_COMPLETION_ONSTACK(aborted_task_completion);
-	struct isci_host *isci_host;
 
-	isci_host = isci_device->isci_port->isci_host;
-
-	dev_dbg(&isci_host->pdev->dev,
-		"%s: isci_device = %p\n", __func__, isci_device);
+	dev_dbg(&ihost->pdev->dev,
+		"%s: idev = %p\n", __func__, idev);
 
 	/* Cleanup all requests pending for this device. */
-	isci_terminate_pending_requests(isci_host, isci_device, terminating);
+	isci_terminate_pending_requests(ihost, idev, terminating);
 
-	dev_dbg(&isci_host->pdev->dev,
-		"%s: isci_device = %p, done\n", __func__, isci_device);
+	dev_dbg(&ihost->pdev->dev,
+		"%s: idev = %p, done\n", __func__, idev);
 }
 
-
-
 /**
  * This function builds the isci_remote_device when a libsas dev_found message
  *    is received.
@@ -380,7 +367,7 @@ enum sci_status isci_remote_device_stop(struct isci_host *ihost, struct isci_rem
 	isci_remote_device_change_state(idev, isci_stopping);
 
 	/* Kill all outstanding requests. */
-	isci_remote_device_nuke_requests(idev);
+	isci_remote_device_nuke_requests(ihost, idev);
 
 	set_bit(IDEV_STOP_PENDING, &idev->flags);
 
@@ -409,7 +396,7 @@ enum sci_status isci_remote_device_stop(struct isci_host *ihost, struct isci_rem
  */
 void isci_remote_device_gone(struct domain_device *dev)
 {
-	struct isci_host *ihost = dev->port->ha->lldd_ha;
+	struct isci_host *ihost = dev_to_ihost(dev);
 	struct isci_remote_device *idev = dev->lldd_dev;
 
 	dev_dbg(&ihost->pdev->dev,
@@ -431,7 +418,7 @@ void isci_remote_device_gone(struct domain_device *dev)
  */
 int isci_remote_device_found(struct domain_device *domain_dev)
 {
-	struct isci_host *isci_host;
+	struct isci_host *isci_host = dev_to_ihost(domain_dev);
 	struct isci_port *isci_port;
 	struct isci_phy *isci_phy;
 	struct asd_sas_port *sas_port;
@@ -439,8 +426,6 @@ int isci_remote_device_found(struct domain_device *domain_dev)
 	struct isci_remote_device *isci_device;
 	enum sci_status status;
 
-	isci_host = isci_host_from_sas_ha(domain_dev->port->ha);
-
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: domain_device = %p\n", __func__, domain_dev);
 
@@ -556,41 +541,22 @@ bool isci_device_is_reset_pending(
  *
  * true if there is a reset pending for the device.
  */
-void isci_device_clear_reset_pending(struct isci_remote_device *isci_device)
+void isci_device_clear_reset_pending(struct isci_host *ihost, struct isci_remote_device *idev)
 {
 	struct isci_request *isci_request;
 	struct isci_request *tmp_req;
-	struct isci_host *isci_host = NULL;
 	unsigned long flags = 0;
 
-	/* FIXME more port gone confusion, and this time it makes the
-	 * locking "fun"
-	 */
-	if (isci_device->isci_port != NULL)
-		isci_host = isci_device->isci_port->isci_host;
-
-	/*
-	 * FIXME when the isci_host gets sorted out
-	 * use dev_dbg()
-	 */
-	pr_debug("%s: isci_device=%p, isci_host=%p\n",
-		 __func__, isci_device, isci_host);
+	dev_dbg(&ihost->pdev->dev, "%s: idev=%p, ihost=%p\n",
+		 __func__, idev, ihost);
 
-	if (isci_host != NULL)
-		spin_lock_irqsave(&isci_host->scic_lock, flags);
-	else
-		pr_err("%s: isci_device %p; isci_host == NULL!\n",
-		       __func__, isci_device);
+	spin_lock_irqsave(&ihost->scic_lock, flags);
 
 	/* Clear reset pending on all pending requests. */
 	list_for_each_entry_safe(isci_request, tmp_req,
-				 &isci_device->reqs_in_process, dev_node) {
-		/*
-		 * FIXME when the conditional spinlock is gone
-		 * change to dev_dbg()
-		 */
-		pr_debug("%s: isci_device = %p request = %p\n",
-			 __func__, isci_device, isci_request);
+				 &idev->reqs_in_process, dev_node) {
+		dev_dbg(&ihost->pdev->dev, "%s: idev = %p request = %p\n",
+			 __func__, idev, isci_request);
 
 		if (isci_request->ttype == io_task) {
 
@@ -603,9 +569,7 @@ void isci_device_clear_reset_pending(struct isci_remote_device *isci_device)
 			spin_unlock_irqrestore(&task->task_state_lock, flags2);
 		}
 	}
-
-	if (isci_host != NULL)
-		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
+	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 }
 
 /**
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index cf5302a..9925316 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -78,59 +78,29 @@ static inline struct scic_sds_remote_device *to_sci_dev(struct isci_remote_devic
 	return (struct scic_sds_remote_device *) &idev[1];
 }
 
-#define to_isci_remote_device(p)	\
-	container_of(p, struct isci_remote_device, sci_remote_device);
-
 #define ISCI_REMOTE_DEVICE_START_TIMEOUT 5000
 
-
-/**
- * isci_dev_from_domain_dev() - This accessor retrieves the remote_device
- *    object reference from the Linux domain_device reference.
- * @domdev,: This parameter points to the Linux domain_device object .
- *
- * A reference to the associated isci remote device.
- */
-#define isci_dev_from_domain_dev(domdev) \
-	((struct isci_remote_device *)(domdev)->lldd_dev)
-
-void isci_remote_device_start_complete(
-	struct isci_host *,
-	struct isci_remote_device *,
-	enum sci_status);
-
-void isci_remote_device_stop_complete(
-	struct isci_host *,
-	struct isci_remote_device *,
-	enum sci_status);
-
+void isci_remote_device_start_complete(struct isci_host *ihost,
+				       struct isci_remote_device *idev,
+				       enum sci_status);
+void isci_remote_device_stop_complete(struct isci_host *ihost,
+				      struct isci_remote_device *idev,
+				      enum sci_status);
 enum sci_status isci_remote_device_stop(struct isci_host *ihost,
 					struct isci_remote_device *idev);
-void isci_remote_device_nuke_requests(
-	struct isci_remote_device *isci_device);
-
+void isci_remote_device_nuke_requests(struct isci_host *ihost,
+				      struct isci_remote_device *idev);
 void isci_remote_device_ready(struct isci_host *ihost,
 			      struct isci_remote_device *idev);
-
 void isci_remote_device_not_ready(struct isci_host *ihost,
 				  struct isci_remote_device *idev, u32 reason);
-
-void isci_remote_device_gone(
-	struct domain_device *domain_dev);
-
-int isci_remote_device_found(
-	struct domain_device *domain_dev);
-
-bool isci_device_is_reset_pending(
-	struct isci_host *isci_host,
-	struct isci_remote_device *isci_device);
-
-void isci_device_clear_reset_pending(
-	struct isci_remote_device *isci_device);
-
-void isci_remote_device_change_state(
-	struct isci_remote_device *isci_device,
-	enum isci_status status);
+void isci_remote_device_gone(struct domain_device *domain_dev);
+int isci_remote_device_found(struct domain_device *domain_dev);
+bool isci_device_is_reset_pending(struct isci_host *ihost,
+				  struct isci_remote_device *idev);
+void isci_device_clear_reset_pending(struct isci_host *ihost,
+				     struct isci_remote_device *idev);
+void isci_remote_device_change_state(struct isci_remote_device *idev,
+				     enum isci_status status);
 
 #endif /* !defined(_ISCI_REMOTE_DEVICE_H_) */
-
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index b519373..37ffedc 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -379,7 +379,7 @@ int isci_request_execute(
 	struct isci_request *request;
 	unsigned long flags;
 
-	isci_device = isci_dev_from_domain_dev(task->dev);
+	isci_device = task->dev->lldd_dev;
 	sci_device = to_sci_dev(isci_device);
 
 	/* do common allocation and init of request object. */
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 5bcea60..c6c97ad 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -146,7 +146,7 @@ static void isci_task_refuse(struct isci_host *ihost, struct sas_task *task,
  */
 int isci_task_execute_task(struct sas_task *task, int num, gfp_t gfp_flags)
 {
-	struct isci_host *ihost = task->dev->port->ha->lldd_ha;
+	struct isci_host *ihost = dev_to_ihost(task->dev);
 	struct isci_request *request = NULL;
 	struct isci_remote_device *device;
 	unsigned long flags;
@@ -169,7 +169,7 @@ int isci_task_execute_task(struct sas_task *task, int num, gfp_t gfp_flags)
 			"task = %p, num = %d; dev = %p; cmd = %p\n",
 			    task, num, task->dev, task->uldd_task);
 
-		device = isci_dev_from_domain_dev(task->dev);
+		device = task->dev->lldd_dev;
 
 		if (device)
 			device_status = device->status;
@@ -593,7 +593,6 @@ static void isci_task_build_abort_task_tmf(
 
 static struct isci_request *isci_task_get_request_from_task(
 	struct sas_task *task,
-	struct isci_host **isci_host,
 	struct isci_remote_device **isci_device)
 {
 
@@ -609,9 +608,6 @@ static struct isci_request *isci_task_get_request_from_task(
 	    (task->task_state_flags & SAS_TASK_AT_INITIATOR) &&
 	    (request != NULL)) {
 
-		if (isci_host != NULL)
-			*isci_host = request->isci_host;
-
 		if (isci_device != NULL)
 			*isci_device = request->isci_device;
 	}
@@ -1027,26 +1023,17 @@ static int isci_task_send_lu_reset_sas(
  *
  * status, zero indicates success.
  */
-int isci_task_lu_reset(
-	struct domain_device *domain_device,
-	u8 *lun)
+int isci_task_lu_reset(struct domain_device *domain_device, u8 *lun)
 {
-	struct isci_host *isci_host = NULL;
+	struct isci_host *isci_host = dev_to_ihost(domain_device);
 	struct isci_remote_device *isci_device = NULL;
 	int ret;
 	bool device_stopping = false;
 
-	if (domain_device == NULL) {
-		pr_warn("%s: domain_device == NULL\n", __func__);
-		return TMF_RESP_FUNC_FAILED;
-	}
-
-	isci_device = isci_dev_from_domain_dev(domain_device);
-
-	if (domain_device->port != NULL)
-		isci_host = isci_host_from_sas_ha(domain_device->port->ha);
+	isci_device = domain_device->lldd_dev;
 
-	pr_debug("%s: domain_device=%p, isci_host=%p; isci_device=%p\n",
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: domain_device=%p, isci_host=%p; isci_device=%p\n",
 		 __func__, domain_device, isci_host, isci_device);
 
 	if (isci_device != NULL)
@@ -1057,24 +1044,18 @@ int isci_task_lu_reset(
 	 * device's list, fail this LUN reset request in order to
 	 * escalate to the device reset.
 	 */
-	if ((isci_device == NULL) ||
-	    (isci_host == NULL) ||
-	    ((isci_host != NULL) &&
-	     (isci_device != NULL) &&
-	     (device_stopping ||
-	      (isci_device_is_reset_pending(isci_host, isci_device))))) {
+	if (!isci_device || device_stopping ||
+	    isci_device_is_reset_pending(isci_host, isci_device)) {
 		dev_warn(&isci_host->pdev->dev,
-			 "%s: No dev (%p), no host (%p), or "
+			 "%s: No dev (%p), or "
 			 "RESET PENDING: domain_device=%p\n",
-			 __func__, isci_device, isci_host, domain_device);
+			 __func__, isci_device, domain_device);
 		return TMF_RESP_FUNC_FAILED;
 	}
 
 	/* Send the task management part of the reset. */
 	if (sas_protocol_ata(domain_device->tproto)) {
-		ret = isci_task_send_lu_reset_sata(
-			isci_host, isci_device, lun
-			);
+		ret = isci_task_send_lu_reset_sata(isci_host, isci_device, lun);
 	} else
 		ret = isci_task_send_lu_reset_sas(isci_host, isci_device, lun);
 
@@ -1173,11 +1154,11 @@ static void isci_abort_task_process_cb(
  */
 int isci_task_abort_task(struct sas_task *task)
 {
+	struct isci_host *isci_host = dev_to_ihost(task->dev);
 	DECLARE_COMPLETION_ONSTACK(aborted_io_completion);
 	struct isci_request       *old_request = NULL;
 	enum isci_request_status  old_state;
 	struct isci_remote_device *isci_device = NULL;
-	struct isci_host          *isci_host = NULL;
 	struct isci_tmf           tmf;
 	int                       ret = TMF_RESP_FUNC_FAILED;
 	unsigned long             flags;
@@ -1189,8 +1170,7 @@ int isci_task_abort_task(struct sas_task *task)
 	 * in the device, because tasks driving resets may land here
 	 * after completion in the core.
 	 */
-	old_request = isci_task_get_request_from_task(task, &isci_host,
-						      &isci_device);
+	old_request = isci_task_get_request_from_task(task, &isci_device);
 
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: task = %p\n", __func__, task);
@@ -1610,37 +1590,29 @@ u32 isci_task_ssp_request_get_response_data_length(
  */
 int isci_bus_reset_handler(struct scsi_cmnd *cmd)
 {
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
+	struct isci_host *isci_host = dev_to_ihost(dev);
 	unsigned long flags = 0;
-	struct isci_host *isci_host = NULL;
 	enum sci_status status;
 	int base_status;
-	struct isci_remote_device *isci_dev
-		= isci_dev_from_domain_dev(
-		sdev_to_domain_dev(cmd->device));
+	struct isci_remote_device *isci_dev = dev->lldd_dev;
 
-	dev_dbg(&cmd->device->sdev_gendev,
+	dev_dbg(&isci_host->pdev->dev,
 		"%s: cmd %p, isci_dev %p\n",
 		__func__, cmd, isci_dev);
 
 	if (!isci_dev) {
-		dev_warn(&cmd->device->sdev_gendev,
+		dev_warn(&isci_host->pdev->dev,
 			 "%s: isci_dev is GONE!\n",
 			 __func__);
 
 		return TMF_RESP_FUNC_COMPLETE; /* Nothing to reset. */
 	}
 
-	if (isci_dev->isci_port != NULL)
-		isci_host = isci_dev->isci_port->isci_host;
-
-	if (isci_host != NULL)
-		spin_lock_irqsave(&isci_host->scic_lock, flags);
-
+	spin_lock_irqsave(&isci_host->scic_lock, flags);
 	status = scic_remote_device_reset(to_sci_dev(isci_dev));
 	if (status != SCI_SUCCESS) {
-
-		if (isci_host != NULL)
-			spin_unlock_irqrestore(&isci_host->scic_lock, flags);
+		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
 
 		scmd_printk(KERN_WARNING, cmd,
 			    "%s: scic_remote_device_reset(%p) returned %d!\n",
@@ -1648,14 +1620,13 @@ int isci_bus_reset_handler(struct scsi_cmnd *cmd)
 
 		return TMF_RESP_FUNC_FAILED;
 	}
-	if (isci_host != NULL)
-		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
+	spin_unlock_irqrestore(&isci_host->scic_lock, flags);
 
 	/* Make sure all pending requests are able to be fully terminated. */
-	isci_device_clear_reset_pending(isci_dev);
+	isci_device_clear_reset_pending(isci_host, isci_dev);
 
 	/* Terminate in-progress I/O now. */
-	isci_remote_device_nuke_requests(isci_dev);
+	isci_remote_device_nuke_requests(isci_host, isci_dev);
 
 	/* Call into the libsas default handler (which calls sas_phy_reset). */
 	base_status = sas_eh_bus_reset_handler(cmd);
@@ -1672,13 +1643,9 @@ int isci_bus_reset_handler(struct scsi_cmnd *cmd)
 	}
 
 	/* WHAT TO DO HERE IF sas_phy_reset FAILS? */
-
-	if (isci_host != NULL)
-		spin_lock_irqsave(&isci_host->scic_lock, flags);
+	spin_lock_irqsave(&isci_host->scic_lock, flags);
 	status = scic_remote_device_reset_complete(to_sci_dev(isci_dev));
-
-	if (isci_host != NULL)
-		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
+	spin_unlock_irqrestore(&isci_host->scic_lock, flags);
 
 	if (status != SCI_SUCCESS) {
 		scmd_printk(KERN_WARNING, cmd,
@@ -1688,7 +1655,7 @@ int isci_bus_reset_handler(struct scsi_cmnd *cmd)
 	}
 	/* WHAT TO DO HERE IF scic_remote_device_reset_complete FAILS? */
 
-	dev_dbg(&cmd->device->sdev_gendev,
+	dev_dbg(&isci_host->pdev->dev,
 		"%s: cmd %p, isci_dev %p complete.\n",
 		__func__, cmd, isci_dev);
 

commit f1cef7d518628b2e03e02893257733505bcc37a0
Author: Christoph Hellwig <hch@infradead.org>
Date:   Sun Mar 27 20:07:54 2011 -0400

    isci: remove mmio wrappers
    
    Remove a couple of layers around read/writel to make the driver readable.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 13ca34a2560b0348a1819514f71beceb86fc2583
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Mar 28 09:21:04 2011 -0400

    isci: remove base_controller abstraction
    
    Merge struct sci_base_controller into scic_sds_controller, and also factor
    the two types of state machine handlers into one function.  While we're at
    it also remove lots of duplicate incorrect kerneldoc comments for the state
    machine handlers.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 96a7f153bef7841fceacbd475b0e08e2d948796e
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Mar 28 09:21:14 2011 -0400

    isci: remove base_request abstraction
    
    Merge struct sci_base_request into scic_sds_request, and also factor the two
    types of state machine handlers into one function.  While we're at it also
    remove lots of duplicate incorrect kerneldoc comments for the state machine
    handlers.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 7b783f341b464cd12b51d2da09835b058a2e9d70
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 31 11:01:39 2011 -0400

    isci: kill dead data structurs in scic_io_request.h
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3e7cb6c0c44c01a0e701c6227f8d7351ea04aa14
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Mar 31 11:06:16 2011 -0400

    isci: simplify request state handlers
    
    Instead of filling up tables with default handlers call the default
    handler in the only caller.
    
    IMHO the whole state handlers concept is not very suitable for the
    isci request.  For example there is a single real instance of the
    start handler, and we'd be much better off just having a check for
    the right state in the only caller, than all this mess.  It's
    quite similar for the abort handler as well.
    
    Even the actual state machine has a lot of states that are rather
    pointless.  The initial and constructed states are not needed at all
    as the request is not reachable for calls before it's fully set up and
    started.  And the abort state should be replaced with an abort actions
    and a state transition to the completed state.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>



