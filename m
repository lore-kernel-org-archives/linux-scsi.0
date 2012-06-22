From: Dan Williams <dan.j.williams@intel.com>
Subject: [set1 PATCH 2/4] scsi: fix eh wakeup (scsi_schedule_eh vs
 scsi_restart_operations)
Date: Thu, 21 Jun 2012 23:25:32 -0700
Message-ID: <20120622062532.21162.59654.stgit@dwillia2-linux.jf.intel.com>
References: <20120622062521.21162.31523.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120622062521.21162.31523.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, Tom Jackson <thomas.p.jackson@intel.com>, stable@vger.kernel.org
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
eh.  Since i/o that is released by scsi_restart_operations has been
blocked for at least one eh cycle, this implementation allows those
i/o's to run before another eh cycle starts to discourage hung task
timeouts.

Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Reported-by: Tom Jackson <thomas.p.jackson@intel.com>
Tested-by: Tom Jackson <thomas.p.jackson@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi_error.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d0f71e5..804f632 100644
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

