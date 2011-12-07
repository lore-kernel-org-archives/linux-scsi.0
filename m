From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v5 6/6] ata: add ata port runtime PM callbacks
Date: Wed, 7 Dec 2011 16:42:09 +0800
Message-ID: <CAF1ivSbr3b8vkgtA1Lzy-hKvm6MJ77bS5V2JkJF5+ybKCPObKg@mail.gmail.com>
References: <1323048028-10421-1-git-send-email-ming.m.lin@intel.com>
	<1323048028-10421-7-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1323048028-10421-7-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 5, 2011 at 9:20 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> Add ata port runtime suspend/resume/idle callbacks.
> Set ->eh_noresume to skip the runtime PM calls on scsi host
> in the error handler to avoid dead lock.

Hi Tejun & Alan,

How about this patch?

Lin Ming

>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
> =A0drivers/ata/libata-core.c =A0 =A0 =A0| =A0 10 ++++++++++
> =A0drivers/ata/libata-scsi.c =A0 =A0 =A0| =A0 =A01 +
> =A0drivers/ata/libata-transport.c | =A0 =A04 ++++
> =A03 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 04c208e..15a3d4d 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -66,6 +66,7 @@
> =A0#include <asm/byteorder.h>
> =A0#include <linux/cdrom.h>
> =A0#include <linux/ratelimit.h>
> +#include <linux/pm_runtime.h>
>
> =A0#include "libata.h"
> =A0#include "libata-transport.h"
> @@ -5307,9 +5308,18 @@ static int ata_port_resume(struct device *dev)
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +static int ata_port_runtime_idle(struct device *dev)
> +{
> + =A0 =A0 =A0 return pm_runtime_suspend(dev);
> +}
> +
> =A0static const struct dev_pm_ops ata_port_pm_ops =3D {
> =A0 =A0 =A0 =A0.suspend =3D ata_port_suspend,
> =A0 =A0 =A0 =A0.resume =3D ata_port_resume,
> +
> + =A0 =A0 =A0 .runtime_suspend =3D ata_port_suspend_common,
> + =A0 =A0 =A0 .runtime_resume =3D ata_port_resume,
> + =A0 =A0 =A0 .runtime_idle =3D ata_port_runtime_idle,
> =A0};
>
> =A0/**
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 7ae1e77..508a60b 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3381,6 +3381,7 @@ int ata_scsi_add_hosts(struct ata_host *host, s=
truct scsi_host_template *sht)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!shost)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err_alloc;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 shost->eh_noresume =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*(struct ata_port **)&shost->hostdata[=
0] =3D ap;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ap->scsi_host =3D shost;
>
> diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-tran=
sport.c
> index 3ceb3d9..9a7f0ea 100644
> --- a/drivers/ata/libata-transport.c
> +++ b/drivers/ata/libata-transport.c
> @@ -32,6 +32,7 @@
> =A0#include <linux/libata.h>
> =A0#include <linux/hdreg.h>
> =A0#include <linux/uaccess.h>
> +#include <linux/pm_runtime.h>
>
> =A0#include "libata.h"
> =A0#include "libata-transport.h"
> @@ -290,6 +291,9 @@ int ata_tport_add(struct device *parent,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto tport_err;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 pm_runtime_set_active(dev);
> + =A0 =A0 =A0 pm_runtime_enable(dev);
> +
> =A0 =A0 =A0 =A0transport_add_device(dev);
> =A0 =A0 =A0 =A0transport_configure_device(dev);
>
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
