From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v5 1/3] libata, libsas: kill pm_result and related cleanup
Date: Wed, 05 Mar 2014 12:17:30 -0800
Message-ID: <20140305201730.20088.42218.stgit@viggo.jf.intel.com>
References: <20140305201443.20088.85361.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140305201443.20088.85361.stgit@viggo.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, JBottomley@Parallels.com
Cc: Phillip Susi <psusi@ubuntu.com>, Todd Brandt <todd.e.brandt@intel.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun says:
  "At least for libata, worrying about suspend/resume failures don't make
   whole lot of sense.  If suspend failed, just proceed with suspend.  If
   the device can't be woken up afterwards, that's that.  There isn't
   anything we could have done differently anyway.  The same for resume, if
   spinup fails, the device is dud and the following commands will invoke
   EH actions and will eventually fail.  Again, there really isn't any
   *choice* to make.  Just making sure the errors are handled gracefully
   (ie. don't crash) and the following commands are handled correctly
   should be enough."

The only libata user that actually cares about the result from a suspend
operation is libsas.  However, it only cares about whether queuing a new
operation collides with an in-flight one.  All libsas does with the
error is retry, but we can just let libata wait for the previous
operation before continuing.

While we're at it take an opportunity to replace helper functions that
just do a to_ata_port(dev) conversion with macros whose names readily
distinguish sync vs async (queued) operations.

Reference: http://marc.info/?l=linux-scsi&m=138995409532286&w=2

Cc: Phillip Susi <psusi@ubuntu.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/ata/libata-core.c     |   75 +++++++++++++++--------------------------
 drivers/ata/libata-eh.c       |   13 +------
 drivers/scsi/libsas/sas_ata.c |   35 +++----------------
 include/linux/libata.h        |    9 ++---
 include/scsi/libsas.h         |    1 -
 5 files changed, 39 insertions(+), 94 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1a3dbd1b196e..0f47436c714c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5351,22 +5351,17 @@ bool ata_link_offline(struct ata_link *link)
 }
 
 #ifdef CONFIG_PM
-static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
-			       unsigned int action, unsigned int ehi_flags,
-			       int *async)
+static void ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
+				unsigned int action, unsigned int ehi_flags,
+				bool async)
 {
 	struct ata_link *link;
 	unsigned long flags;
-	int rc = 0;
 
 	/* Previous resume operation might still be in
 	 * progress.  Wait for PM_PENDING to clear.
 	 */
 	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
-		if (async) {
-			*async = -EAGAIN;
-			return 0;
-		}
 		ata_port_wait_eh(ap);
 		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
 	}
@@ -5375,11 +5370,6 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 	spin_lock_irqsave(ap->lock, flags);
 
 	ap->pm_mesg = mesg;
-	if (async)
-		ap->pm_result = async;
-	else
-		ap->pm_result = &rc;
-
 	ap->pflags |= ATA_PFLAG_PM_PENDING;
 	ata_for_each_link(link, ap, HOST_FIRST) {
 		link->eh_info.action |= action;
@@ -5390,16 +5380,13 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	/* wait and check result */
 	if (!async) {
 		ata_port_wait_eh(ap);
 		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
 	}
-
-	return rc;
 }
 
-static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg, int *async)
+static int ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg, bool async)
 {
 	/*
 	 * On some hardware, device fails to respond after spun down
@@ -5411,59 +5398,53 @@ static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg, int
 	 */
 	unsigned int ehi_flags = ATA_EHI_QUIET | ATA_EHI_NO_AUTOPSY |
 				 ATA_EHI_NO_RECOVERY;
-	return ata_port_request_pm(ap, mesg, 0, ehi_flags, async);
+	ata_port_request_pm(ap, mesg, 0, ehi_flags, async);
+	return 0;
 }
 
-static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
-{
-	struct ata_port *ap = to_ata_port(dev);
-
-	return __ata_port_suspend_common(ap, mesg, NULL);
-}
+#define ata_port_suspend_sync(ap, msg) ata_port_suspend_common((ap), (msg), false)
+#define queue_ata_port_suspend(ap, msg) ata_port_suspend_common((ap), (msg), true)
 
 static int ata_port_suspend(struct device *dev)
 {
+	struct ata_port *ap = to_ata_port(dev);
+
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	return ata_port_suspend_common(dev, PMSG_SUSPEND);
+	return ata_port_suspend_sync(ap, PMSG_SUSPEND);
 }
 
 static int ata_port_do_freeze(struct device *dev)
 {
+	struct ata_port *ap = to_ata_port(dev);
+
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	return ata_port_suspend_common(dev, PMSG_FREEZE);
+	return ata_port_suspend_sync(ap, PMSG_FREEZE);
 }
 
 static int ata_port_poweroff(struct device *dev)
 {
-	return ata_port_suspend_common(dev, PMSG_HIBERNATE);
+	return ata_port_suspend_sync(to_ata_port(dev), PMSG_HIBERNATE);
 }
 
-static int __ata_port_resume_common(struct ata_port *ap, pm_message_t mesg,
-				    int *async)
+static int ata_port_resume_common(struct ata_port *ap, pm_message_t mesg, bool async)
 {
-	int rc;
-
-	rc = ata_port_request_pm(ap, mesg, ATA_EH_RESET,
-		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, async);
-	return rc;
+	ata_port_request_pm(ap, mesg, ATA_EH_RESET,
+			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, async);
+	return 0;
 }
 
-static int ata_port_resume_common(struct device *dev, pm_message_t mesg)
-{
-	struct ata_port *ap = to_ata_port(dev);
-
-	return __ata_port_resume_common(ap, mesg, NULL);
-}
+#define ata_port_resume_sync(ap, msg) ata_port_resume_common((ap), (msg), false)
+#define queue_ata_port_resume(ap, msg) ata_port_resume_common((ap), (msg), true)
 
 static int ata_port_resume(struct device *dev)
 {
 	int rc;
 
-	rc = ata_port_resume_common(dev, PMSG_RESUME);
+	rc = ata_port_resume_sync(to_ata_port(dev), PMSG_RESUME);
 	if (!rc) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
@@ -5499,12 +5480,12 @@ static int ata_port_runtime_idle(struct device *dev)
 
 static int ata_port_runtime_suspend(struct device *dev)
 {
-	return ata_port_suspend_common(dev, PMSG_AUTO_SUSPEND);
+	return ata_port_suspend_sync(to_ata_port(dev), PMSG_AUTO_SUSPEND);
 }
 
 static int ata_port_runtime_resume(struct device *dev)
 {
-	return ata_port_resume_common(dev, PMSG_AUTO_RESUME);
+	return ata_port_resume_sync(to_ata_port(dev), PMSG_AUTO_RESUME);
 }
 
 static const struct dev_pm_ops ata_port_pm_ops = {
@@ -5525,15 +5506,15 @@ static const struct dev_pm_ops ata_port_pm_ops = {
  * level. sas suspend/resume is async to allow parallel port recovery
  * since sas has multiple ata_port instances per Scsi_Host.
  */
-int ata_sas_port_async_suspend(struct ata_port *ap, int *async)
+int ata_sas_port_async_suspend(struct ata_port *ap)
 {
-	return __ata_port_suspend_common(ap, PMSG_SUSPEND, async);
+	return queue_ata_port_suspend(ap, PMSG_SUSPEND);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_async_suspend);
 
-int ata_sas_port_async_resume(struct ata_port *ap, int *async)
+int ata_sas_port_async_resume(struct ata_port *ap)
 {
-	return __ata_port_resume_common(ap, PMSG_RESUME, async);
+	return queue_ata_port_resume(ap, PMSG_RESUME);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_async_resume);
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 6d8757008318..b4d0596f30a8 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -4069,7 +4069,7 @@ static void ata_eh_handle_port_suspend(struct ata_port *ap)
 
 	ata_acpi_set_state(ap, ap->pm_mesg);
  out:
-	/* report result */
+	/* update the flags */
 	spin_lock_irqsave(ap->lock, flags);
 
 	ap->pflags &= ~ATA_PFLAG_PM_PENDING;
@@ -4078,11 +4078,6 @@ static void ata_eh_handle_port_suspend(struct ata_port *ap)
 	else if (ap->pflags & ATA_PFLAG_FROZEN)
 		ata_port_schedule_eh(ap);
 
-	if (ap->pm_result) {
-		*ap->pm_result = rc;
-		ap->pm_result = NULL;
-	}
-
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	return;
@@ -4134,13 +4129,9 @@ static void ata_eh_handle_port_resume(struct ata_port *ap)
 	/* tell ACPI that we're resuming */
 	ata_acpi_on_resume(ap);
 
-	/* report result */
+	/* update the flags */
 	spin_lock_irqsave(ap->lock, flags);
 	ap->pflags &= ~(ATA_PFLAG_PM_PENDING | ATA_PFLAG_SUSPENDED);
-	if (ap->pm_result) {
-		*ap->pm_result = rc;
-		ap->pm_result = NULL;
-	}
 	spin_unlock_irqrestore(ap->lock, flags);
 }
 #endif /* CONFIG_PM */
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index d2895836f9fa..9a2af18fd843 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -700,46 +700,26 @@ void sas_probe_sata(struct asd_sas_port *port)
 
 }
 
-static bool sas_ata_flush_pm_eh(struct asd_sas_port *port, const char *func)
+static void sas_ata_flush_pm_eh(struct asd_sas_port *port, const char *func)
 {
 	struct domain_device *dev, *n;
-	bool retry = false;
 
 	list_for_each_entry_safe(dev, n, &port->dev_list, dev_list_node) {
-		int rc;
-
 		if (!dev_is_sata(dev))
 			continue;
 
 		sas_ata_wait_eh(dev);
-		rc = dev->sata_dev.pm_result;
-		if (rc == -EAGAIN)
-			retry = true;
-		else if (rc) {
-			/* since we don't have a
-			 * ->port_{suspend|resume} routine in our
-			 *  ata_port ops, and no entanglements with
-			 *  acpi, suspend should just be mechanical trip
-			 *  through eh, catch cases where these
-			 *  assumptions are invalidated
-			 */
-			WARN_ONCE(1, "failed %s %s error: %d\n", func,
-				 dev_name(&dev->rphy->dev), rc);
-		}
 
 		/* if libata failed to power manage the device, tear it down */
 		if (ata_dev_disabled(sas_to_ata_dev(dev)))
 			sas_fail_probe(dev, func, -ENODEV);
 	}
-
-	return retry;
 }
 
 void sas_suspend_sata(struct asd_sas_port *port)
 {
 	struct domain_device *dev;
 
- retry:
 	mutex_lock(&port->ha->disco_mutex);
 	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
 		struct sata_device *sata;
@@ -751,20 +731,17 @@ void sas_suspend_sata(struct asd_sas_port *port)
 		if (sata->ap->pm_mesg.event == PM_EVENT_SUSPEND)
 			continue;
 
-		sata->pm_result = -EIO;
-		ata_sas_port_async_suspend(sata->ap, &sata->pm_result);
+		ata_sas_port_async_suspend(sata->ap);
 	}
 	mutex_unlock(&port->ha->disco_mutex);
 
-	if (sas_ata_flush_pm_eh(port, __func__))
-		goto retry;
+	sas_ata_flush_pm_eh(port, __func__);
 }
 
 void sas_resume_sata(struct asd_sas_port *port)
 {
 	struct domain_device *dev;
 
- retry:
 	mutex_lock(&port->ha->disco_mutex);
 	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
 		struct sata_device *sata;
@@ -776,13 +753,11 @@ void sas_resume_sata(struct asd_sas_port *port)
 		if (sata->ap->pm_mesg.event == PM_EVENT_ON)
 			continue;
 
-		sata->pm_result = -EIO;
-		ata_sas_port_async_resume(sata->ap, &sata->pm_result);
+		ata_sas_port_async_resume(sata->ap);
 	}
 	mutex_unlock(&port->ha->disco_mutex);
 
-	if (sas_ata_flush_pm_eh(port, __func__))
-		goto retry;
+	sas_ata_flush_pm_eh(port, __func__);
 }
 
 /**
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bec6dbe939a0..304d023a91aa 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -848,7 +848,6 @@ struct ata_port {
 	struct completion	park_req_pending;
 
 	pm_message_t		pm_mesg;
-	int			*pm_result;
 	enum ata_lpm_policy	target_lpm_policy;
 
 	struct timer_list	fastdrain_timer;
@@ -1140,14 +1139,14 @@ extern bool ata_link_offline(struct ata_link *link);
 #ifdef CONFIG_PM
 extern int ata_host_suspend(struct ata_host *host, pm_message_t mesg);
 extern void ata_host_resume(struct ata_host *host);
-extern int ata_sas_port_async_suspend(struct ata_port *ap, int *async);
-extern int ata_sas_port_async_resume(struct ata_port *ap, int *async);
+extern int ata_sas_port_async_suspend(struct ata_port *ap);
+extern int ata_sas_port_async_resume(struct ata_port *ap);
 #else
-static inline int ata_sas_port_async_suspend(struct ata_port *ap, int *async)
+static inline int ata_sas_port_async_suspend(struct ata_port *ap)
 {
 	return 0;
 }
-static inline int ata_sas_port_async_resume(struct ata_port *ap, int *async)
+static inline int ata_sas_port_async_resume(struct ata_port *ap)
 {
 	return 0;
 }
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index f843dd8722a9..ef7872c20da9 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -172,7 +172,6 @@ struct sata_device {
         enum   ata_command_set command_set;
         struct smp_resp        rps_resp; /* report_phy_sata_resp */
         u8     port_no;        /* port number, if this is a PM (Port) */
-	int    pm_result;
 
 	struct ata_port *ap;
 	struct ata_host ata_host;

