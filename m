From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH] SCSI / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Tue, 09 Dec 2014 14:19:57 +0800
Message-ID: <5486948D.1060807@intel.com>
References: <3237237.IIIiULdqDt@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <3237237.IIIiULdqDt@vostro.rjw.lan>
Sender: linux-pm-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-scsi@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 12/04/2014 09:22 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere under
> drivers/scsi/ and in include/scsi/scsi_device.h.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.
> 
> ---
>  drivers/scsi/scsi_pm.c           |    4 ++--
>  drivers/scsi/scsi_priv.h         |    5 ++---
>  drivers/scsi/ufs/ufshcd-pci.c    |   11 ++++-------
>  drivers/scsi/ufs/ufshcd-pltfrm.c |   11 ++++-------
>  include/scsi/scsi_device.h       |    4 ++--
>  5 files changed, 14 insertions(+), 21 deletions(-)
> 
> Index: linux-pm/drivers/scsi/scsi_pm.c
> ===================================================================
> --- linux-pm.orig/drivers/scsi/scsi_pm.c
> +++ linux-pm/drivers/scsi/scsi_pm.c
> @@ -213,7 +213,7 @@ static int scsi_bus_restore(struct devic
>  
>  #endif /* CONFIG_PM_SLEEP */
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  
>  static int sdev_runtime_suspend(struct device *dev)
>  {
> @@ -338,7 +338,7 @@ void scsi_autopm_put_host(struct Scsi_Ho
>  #define scsi_runtime_resume	NULL
>  #define scsi_runtime_idle	NULL
>  
> -#endif /* CONFIG_PM_RUNTIME */
> +#endif /* CONFIG_PM */
>  
>  const struct dev_pm_ops scsi_bus_pm_ops = {
>  	.prepare =		scsi_bus_prepare,

Just one nitpeak: since scsi_pm.o is only compiled when CONFIG_PM is
set, I think we can skip the #ifdef CONFIG_PM ... #endif macro in this
file now. I mean something like this:

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 7454498..9e43ae1 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -213,8 +213,6 @@ static int scsi_bus_restore(struct device *dev)
 
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM_RUNTIME
-
 static int sdev_runtime_suspend(struct device *dev)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
@@ -332,14 +330,6 @@ void scsi_autopm_put_host(struct Scsi_Host *shost)
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

Thanks,
Aaron
