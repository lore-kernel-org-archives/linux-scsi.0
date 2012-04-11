From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] scsi: fix eh wakeup (scsi_schedule_eh vs
 scsi_restart_operations)
Date: Tue, 10 Apr 2012 19:34:19 -0700
Message-ID: <20120411023054.791.37365.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, Tom Jackson <thomas.p.jackson@intel.com>
List-Id: linux-scsi@vger.kernel.org

Rapid ata hotplug on a libsas controller results in cases where libsas
is waiting indefinitely on eh to perform an ata probe.

A race exists between scsi_schedule_eh() and scsi_restart_operations()
in the case when scsi_restart_operations() issues i/o to other devices
in the sas domain.  When this happens the host state transitions from
SHOST_RECOVERY (set by scsi_schedule_eh) back to SHOST_RUNNING and
->host_busy is non-zero so we put the eh thread to sleep even though
->host_eh_scheduled is active.

Before putting the error handler to sleep we need to check if the
host_state needs to return to SHOST_RECOVERY for another trip through
eh.

Cc: Tejun Heo <tj@kernel.org>
Reported-by: Tom Jackson <thomas.p.jackson@intel.com>
Tested-by: Tom Jackson <thomas.p.jackson@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 More host_eh_scheduled fallout that I would like to roll into a
 libsas-fixes pull request along with the other fixes that were pending
 when the merge window closed.

 I'll resend the entire patch series when posting the branch, but wanted
 to call this fix out separately since it is new.

 --
 Dan

 drivers/scsi/scsi_error.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2cfcbff..0945d47 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1687,6 +1687,20 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * requests are started.
 	 */
 	scsi_run_host_queues(shost);
+
+	/*
+	 * if eh is active and host_eh_scheduled is pending we need to re-run
+	 * recovery.  we do this check after scsi_run_host_queues() to allow
+	 * everything pent up since the last eh run a chance to make forward
+	 * progress before we sync again.  Either we'll immediately re-run
+	 * recovery or scsi_device_unbusy() will wake us again when these
+	 * pending commands complete.
+	 */
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (shost->host_eh_scheduled)
+		if (scsi_host_set_state(shost, SHOST_RECOVERY))
+			WARN_ON(scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY));
+	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /**

