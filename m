From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [Update][PATCH] SCSI / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Tue, 09 Dec 2014 22:47:47 +0100
Message-ID: <3039454.iyzHXUp3Uj@vostro.rjw.lan>
References: <3237237.IIIiULdqDt@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3237237.IIIiULdqDt@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lu@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: SCSI / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM

After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
depending on CONFIG_PM_RUNTIME may now be changed to depend on
CONFIG_PM.

Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere under
drivers/scsi/ and in include/scsi/scsi_device.h.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 drivers/scsi/scsi_pm.c           |   10 ----------
 drivers/scsi/scsi_priv.h         |    5 ++---
 drivers/scsi/ufs/ufshcd-pci.c    |   11 ++++-------
 drivers/scsi/ufs/ufshcd-pltfrm.c |   11 ++++-------
 include/scsi/scsi_device.h       |    4 ++--
 5 files changed, 12 insertions(+), 29 deletions(-)

Index: linux-pm/include/scsi/scsi_device.h
===================================================================
--- linux-pm.orig/include/scsi/scsi_device.h
+++ linux-pm/include/scsi/scsi_device.h
@@ -440,13 +440,13 @@ static inline int scsi_execute_req(struc
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 extern int scsi_autopm_get_device(struct scsi_device *);
 extern void scsi_autopm_put_device(struct scsi_device *);
 #else
 static inline int scsi_autopm_get_device(struct scsi_device *d) { return 0; }
 static inline void scsi_autopm_put_device(struct scsi_device *d) {}
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 static inline int __must_check scsi_device_reprobe(struct scsi_device *sdev)
 {
Index: linux-pm/drivers/scsi/scsi_priv.h
===================================================================
--- linux-pm.orig/drivers/scsi/scsi_priv.h
+++ linux-pm/drivers/scsi/scsi_priv.h
@@ -157,8 +157,7 @@ static inline void scsi_netlink_exit(voi
 /* scsi_pm.c */
 #ifdef CONFIG_PM
 extern const struct dev_pm_ops scsi_bus_pm_ops;
-#endif
-#ifdef CONFIG_PM_RUNTIME
+
 extern void scsi_autopm_get_target(struct scsi_target *);
 extern void scsi_autopm_put_target(struct scsi_target *);
 extern int scsi_autopm_get_host(struct Scsi_Host *);
@@ -168,7 +167,7 @@ static inline void scsi_autopm_get_targe
 static inline void scsi_autopm_put_target(struct scsi_target *t) {}
 static inline int scsi_autopm_get_host(struct Scsi_Host *h) { return 0; }
 static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 extern struct async_domain scsi_sd_pm_domain;
 extern struct async_domain scsi_sd_probe_domain;
Index: linux-pm/drivers/scsi/scsi_pm.c
===================================================================
--- linux-pm.orig/drivers/scsi/scsi_pm.c
+++ linux-pm/drivers/scsi/scsi_pm.c
@@ -213,8 +213,6 @@ static int scsi_bus_restore(struct devic
 
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM_RUNTIME
-
 static int sdev_runtime_suspend(struct device *dev)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
@@ -332,14 +330,6 @@ void scsi_autopm_put_host(struct Scsi_Ho
 	pm_runtime_put_sync(&shost->shost_gendev);
 }
 
-#else
-
-#define scsi_runtime_suspend	NULL
-#define scsi_runtime_resume	NULL
-#define scsi_runtime_idle	NULL
-
-#endif /* CONFIG_PM_RUNTIME */
-
 const struct dev_pm_ops scsi_bus_pm_ops = {
 	.prepare =		scsi_bus_prepare,
 	.suspend =		scsi_bus_suspend,
Index: linux-pm/drivers/scsi/ufs/ufshcd-pci.c
===================================================================
--- linux-pm.orig/drivers/scsi/ufs/ufshcd-pci.c
+++ linux-pm/drivers/scsi/ufs/ufshcd-pci.c
@@ -62,12 +62,7 @@ static int ufshcd_pci_resume(struct devi
 {
 	return ufshcd_system_resume(dev_get_drvdata(dev));
 }
-#else
-#define ufshcd_pci_suspend	NULL
-#define ufshcd_pci_resume	NULL
-#endif /* CONFIG_PM */
 
-#ifdef CONFIG_PM_RUNTIME
 static int ufshcd_pci_runtime_suspend(struct device *dev)
 {
 	return ufshcd_runtime_suspend(dev_get_drvdata(dev));
@@ -80,11 +75,13 @@ static int ufshcd_pci_runtime_idle(struc
 {
 	return ufshcd_runtime_idle(dev_get_drvdata(dev));
 }
-#else /* !CONFIG_PM_RUNTIME */
+#else /* !CONFIG_PM */
+#define ufshcd_pci_suspend	NULL
+#define ufshcd_pci_resume	NULL
 #define ufshcd_pci_runtime_suspend	NULL
 #define ufshcd_pci_runtime_resume	NULL
 #define ufshcd_pci_runtime_idle	NULL
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 /**
  * ufshcd_pci_shutdown - main function to put the controller in reset state
Index: linux-pm/drivers/scsi/ufs/ufshcd-pltfrm.c
===================================================================
--- linux-pm.orig/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ linux-pm/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -266,12 +266,7 @@ static int ufshcd_pltfrm_resume(struct d
 {
 	return ufshcd_system_resume(dev_get_drvdata(dev));
 }
-#else
-#define ufshcd_pltfrm_suspend	NULL
-#define ufshcd_pltfrm_resume	NULL
-#endif
 
-#ifdef CONFIG_PM_RUNTIME
 static int ufshcd_pltfrm_runtime_suspend(struct device *dev)
 {
 	return ufshcd_runtime_suspend(dev_get_drvdata(dev));
@@ -284,11 +279,13 @@ static int ufshcd_pltfrm_runtime_idle(st
 {
 	return ufshcd_runtime_idle(dev_get_drvdata(dev));
 }
-#else /* !CONFIG_PM_RUNTIME */
+#else /* !CONFIG_PM */
+#define ufshcd_pltfrm_suspend	NULL
+#define ufshcd_pltfrm_resume	NULL
 #define ufshcd_pltfrm_runtime_suspend	NULL
 #define ufshcd_pltfrm_runtime_resume	NULL
 #define ufshcd_pltfrm_runtime_idle	NULL
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 static void ufshcd_pltfrm_shutdown(struct platform_device *pdev)
 {
