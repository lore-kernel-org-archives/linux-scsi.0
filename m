From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v6 1/3] libata, libsas: kill pm_result and related cleanup
Date: Fri, 14 Mar 2014 13:52:48 -0700
Message-ID: <20140314205248.1269.33730.stgit@viggo.jf.intel.com>
References: <20140314205204.1269.44402.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140314205204.1269.44402.stgit@viggo.jf.intel.com>
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

Other cleanups include:
1/ Unifying all ata port pm operations on an ata_port_pm_ prefix
2/ Marking all ata port pm helper routines as returning void, only
   ata_port_pm_ entry points need to fake a 0 return value.
3/ Killing ata_port_{suspend|resume}_common() in favor of calling
   ata_port_request_pm() directly
4/ Killing the wrappers that just do a to_ata_port() conversion
5/ Clearly marking the entry points that do async operations with an
  _async suffix.

Reference: http://marc.info/?l=linux-scsi&m=138995409532286&w=2

Cc: Phillip Susi <psusi@ubuntu.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/ata/libata-core.c     |  135 ++++++++++++++++++-----------------------
 drivers/ata/libata-eh.c       |   13 +---
 drivers/scsi/libsas/sas_ata.c |   35 ++---------
 include/linux/libata.h        |   11 +--
 include/scsi/libsas.h         |    1 
 5 files changed, 71 insertions(+), 124 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1a3dbd1b196e..66110ed2c1c0 100644
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
@@ -5390,87 +5380,81 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 
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
+/*
+ * On some hardware, device fails to respond after spun down for suspend.  As
+ * the device won't be used before being resumed, we don't need to touch the
+ * device.  Ask EH to skip the usual stuff and proceed directly to suspend.
+ *
+ * http://thread.gmane.org/gmane.linux.ide/46764
+ */
+static const unsigned int ata_port_suspend_ehi = ATA_EHI_QUIET
+						 | ATA_EHI_NO_AUTOPSY
+						 | ATA_EHI_NO_RECOVERY;
+
+static void ata_port_suspend(struct ata_port *ap, pm_message_t mesg)
 {
-	/*
-	 * On some hardware, device fails to respond after spun down
-	 * for suspend.  As the device won't be used before being
-	 * resumed, we don't need to touch the device.  Ask EH to skip
-	 * the usual stuff and proceed directly to suspend.
-	 *
-	 * http://thread.gmane.org/gmane.linux.ide/46764
-	 */
-	unsigned int ehi_flags = ATA_EHI_QUIET | ATA_EHI_NO_AUTOPSY |
-				 ATA_EHI_NO_RECOVERY;
-	return ata_port_request_pm(ap, mesg, 0, ehi_flags, async);
+	ata_port_request_pm(ap, mesg, 0, ata_port_suspend_ehi, false);
 }
 
-static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
+static void ata_port_suspend_async(struct ata_port *ap, pm_message_t mesg)
 {
-	struct ata_port *ap = to_ata_port(dev);
-
-	return __ata_port_suspend_common(ap, mesg, NULL);
+	ata_port_request_pm(ap, mesg, 0, ata_port_suspend_ehi, true);
 }
 
-static int ata_port_suspend(struct device *dev)
+static int ata_port_pm_suspend(struct device *dev)
 {
+	struct ata_port *ap = to_ata_port(dev);
+
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	return ata_port_suspend_common(dev, PMSG_SUSPEND);
+	ata_port_suspend(ap, PMSG_SUSPEND);
+	return 0;
 }
 
-static int ata_port_do_freeze(struct device *dev)
+static int ata_port_pm_freeze(struct device *dev)
 {
+	struct ata_port *ap = to_ata_port(dev);
+
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	return ata_port_suspend_common(dev, PMSG_FREEZE);
+	ata_port_suspend(ap, PMSG_FREEZE);
+	return 0;
 }
 
-static int ata_port_poweroff(struct device *dev)
+static int ata_port_pm_poweroff(struct device *dev)
 {
-	return ata_port_suspend_common(dev, PMSG_HIBERNATE);
+	ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE);
+	return 0;
 }
 
-static int __ata_port_resume_common(struct ata_port *ap, pm_message_t mesg,
-				    int *async)
-{
-	int rc;
+static const unsigned int ata_port_resume_ehi = ATA_EHI_NO_AUTOPSY
+						| ATA_EHI_QUIET;
 
-	rc = ata_port_request_pm(ap, mesg, ATA_EH_RESET,
-		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, async);
-	return rc;
+static void ata_port_resume(struct ata_port *ap, pm_message_t mesg)
+{
+	ata_port_request_pm(ap, mesg, ATA_EH_RESET, ata_port_resume_ehi, false);
 }
 
-static int ata_port_resume_common(struct device *dev, pm_message_t mesg)
+static void ata_port_resume_async(struct ata_port *ap, pm_message_t mesg)
 {
-	struct ata_port *ap = to_ata_port(dev);
-
-	return __ata_port_resume_common(ap, mesg, NULL);
+	ata_port_request_pm(ap, mesg, ATA_EH_RESET, ata_port_resume_ehi, true);
 }
 
-static int ata_port_resume(struct device *dev)
+static int ata_port_pm_resume(struct device *dev)
 {
-	int rc;
-
-	rc = ata_port_resume_common(dev, PMSG_RESUME);
-	if (!rc) {
-		pm_runtime_disable(dev);
-		pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
-	}
-
-	return rc;
+	ata_port_resume(to_ata_port(dev), PMSG_RESUME);
+	pm_runtime_disable(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+	return 0;
 }
 
 /*
@@ -5499,21 +5483,23 @@ static int ata_port_runtime_idle(struct device *dev)
 
 static int ata_port_runtime_suspend(struct device *dev)
 {
-	return ata_port_suspend_common(dev, PMSG_AUTO_SUSPEND);
+	ata_port_suspend(to_ata_port(dev), PMSG_AUTO_SUSPEND);
+	return 0;
 }
 
 static int ata_port_runtime_resume(struct device *dev)
 {
-	return ata_port_resume_common(dev, PMSG_AUTO_RESUME);
+	ata_port_resume(to_ata_port(dev), PMSG_AUTO_RESUME);
+	return 0;
 }
 
 static const struct dev_pm_ops ata_port_pm_ops = {
-	.suspend = ata_port_suspend,
-	.resume = ata_port_resume,
-	.freeze = ata_port_do_freeze,
-	.thaw = ata_port_resume,
-	.poweroff = ata_port_poweroff,
-	.restore = ata_port_resume,
+	.suspend = ata_port_pm_suspend,
+	.resume = ata_port_pm_resume,
+	.freeze = ata_port_pm_freeze,
+	.thaw = ata_port_pm_resume,
+	.poweroff = ata_port_pm_poweroff,
+	.restore = ata_port_pm_resume,
 
 	.runtime_suspend = ata_port_runtime_suspend,
 	.runtime_resume = ata_port_runtime_resume,
@@ -5525,18 +5511,17 @@ static const struct dev_pm_ops ata_port_pm_ops = {
  * level. sas suspend/resume is async to allow parallel port recovery
  * since sas has multiple ata_port instances per Scsi_Host.
  */
-int ata_sas_port_async_suspend(struct ata_port *ap, int *async)
+void ata_sas_port_suspend(struct ata_port *ap)
 {
-	return __ata_port_suspend_common(ap, PMSG_SUSPEND, async);
+	ata_port_suspend_async(ap, PMSG_SUSPEND);
 }
-EXPORT_SYMBOL_GPL(ata_sas_port_async_suspend);
+EXPORT_SYMBOL_GPL(ata_sas_port_suspend);
 
-int ata_sas_port_async_resume(struct ata_port *ap, int *async)
+void ata_sas_port_resume(struct ata_port *ap)
 {
-	return __ata_port_resume_common(ap, PMSG_RESUME, async);
+	ata_port_resume_async(ap, PMSG_RESUME);
 }
-EXPORT_SYMBOL_GPL(ata_sas_port_async_resume);
-
+EXPORT_SYMBOL_GPL(ata_sas_port_resume);
 
 /**
  *	ata_host_suspend - suspend host
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
index d2895836f9fa..766098af4eb7 100644
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
+		ata_sas_port_suspend(sata->ap);
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
+		ata_sas_port_resume(sata->ap);
 	}
 	mutex_unlock(&port->ha->disco_mutex);
 
-	if (sas_ata_flush_pm_eh(port, __func__))
-		goto retry;
+	sas_ata_flush_pm_eh(port, __func__);
 }
 
 /**
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bec6dbe939a0..5c09e86982c9 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -848,7 +848,6 @@ struct ata_port {
 	struct completion	park_req_pending;
 
 	pm_message_t		pm_mesg;
-	int			*pm_result;
 	enum ata_lpm_policy	target_lpm_policy;
 
 	struct timer_list	fastdrain_timer;
@@ -1140,16 +1139,14 @@ extern bool ata_link_offline(struct ata_link *link);
 #ifdef CONFIG_PM
 extern int ata_host_suspend(struct ata_host *host, pm_message_t mesg);
 extern void ata_host_resume(struct ata_host *host);
-extern int ata_sas_port_async_suspend(struct ata_port *ap, int *async);
-extern int ata_sas_port_async_resume(struct ata_port *ap, int *async);
+extern void ata_sas_port_suspend(struct ata_port *ap);
+extern void ata_sas_port_resume(struct ata_port *ap);
 #else
-static inline int ata_sas_port_async_suspend(struct ata_port *ap, int *async)
+static inline void ata_sas_port_suspend(struct ata_port *ap)
 {
-	return 0;
 }
-static inline int ata_sas_port_async_resume(struct ata_port *ap, int *async)
+static inline void ata_sas_port_async_resume(struct ata_port *ap)
 {
-	return 0;
 }
 #endif
 extern int ata_ratelimit(void);
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

