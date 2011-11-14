From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v2 4/4] ata: add ata port runtime PM callbacks
Date: Mon, 14 Nov 2011 13:14:21 +0800
Message-ID: <1321247661.6599.110.camel@minggr>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
	 <1320906166-15459-5-git-send-email-ming.m.lin@intel.com>
	 <CAF1ivSZ3rnb90u6LHXfWCBW-6mtfmWYjj1xXfABmm=uNVbomRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32453 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab1KNFOY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Nov 2011 00:14:24 -0500
In-Reply-To: <CAF1ivSZ3rnb90u6LHXfWCBW-6mtfmWYjj1xXfABmm=uNVbomRw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>

On Mon, 2011-11-14 at 11:22 +0800, Lin Ming wrote:
> 
> Add ata port runtime suspend/resume/idle callbacks.
> Set ->eh_noresume to skip the runtime PM calls on scsi host
> in the error handler to avoid dead lock.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/ata/libata-core.c      |   19 +++++++++++++++++++
>  drivers/ata/libata-scsi.c      |    1 +
>  drivers/ata/libata-transport.c |    3 +++
>  3 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index b77c40c..719d23c 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -66,6 +66,7 @@
>  #include <asm/byteorder.h>
>  #include <linux/cdrom.h>
>  #include <linux/ratelimit.h>
> +#include <linux/pm_runtime.h>
> 
>  #include "libata.h"
>  #include "libata-transport.h"
> @@ -5302,9 +5303,27 @@ static int ata_port_resume(struct device *dev)
>        return rc;
>  }
> 
> +static int ata_port_runtime_suspend(struct device *dev)
> +{
> +       struct ata_port *ap = to_ata_port(dev);
> +       int rc;
> +
> +       rc = ata_port_request_pm(ap, PMSG_SUSPEND, 0, ATA_EHI_QUIET, 1);
> +       return rc;
> +}
> +
> +static int ata_port_runtime_idle(struct device *dev)
> +{
> +       return pm_runtime_suspend(dev);
> +}
> +
>  static const struct dev_pm_ops ata_port_pm_ops = {
>        .suspend = ata_port_suspend,
>        .resume = ata_port_resume,
> +
> +       .runtime_suspend = ata_port_runtime_suspend,
> +       .runtime_resume = ata_port_resume,
> +       .runtime_idle = ata_port_runtime_idle,
>  };
> 
>  /**
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 4c2a524..f7afdd5 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3377,6 +3377,7 @@ int ata_scsi_add_hosts(struct ata_host *host,
> struct scsi_host_template *sht)
>                if (!shost)
>                        goto err_alloc;
> 
> +               shost->eh_noresume = 1;
>                *(struct ata_port **)&shost->hostdata[0] = ap;
>                ap->scsi_host = shost;
> 
> diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
> index a979bd76..9a7f0ea 100644
> --- a/drivers/ata/libata-transport.c
> +++ b/drivers/ata/libata-transport.c
> @@ -291,6 +291,9 @@ int ata_tport_add(struct device *parent,
>                goto tport_err;
>        }
> 
> +       pm_runtime_set_active(dev);
> +       pm_runtime_enable(dev);
> +
>        transport_add_device(dev);
>        transport_configure_device(dev);
> 
> --
> 1.7.2.5

Current patches has a bug that system suspend fails if ata port was
runtime suspended.

disk suspend issues sync cache and stop device commands that obviously
need ata port to be active. So we need to runtime resume ata port first.

Alan, Tejun

How about below fix?

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..ebb87fbf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
@@ -2762,6 +2763,14 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 	if (!sdkp)
 		return 0;	/* this can happen */
 
+	/*
+	 * Resume parent device to handle sync cache and
+	 * stop device commands
+	 */
+	ret = pm_runtime_get_sync(dev->parent);
+	if (ret)
+		goto exit;
+
 	if (sdkp->WCE) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp);
@@ -2775,6 +2784,8 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 	}
 
 done:
+	pm_runtime_put_sync(dev->parent);
+exit:
 	scsi_disk_put(sdkp);
 	return ret;
 }


