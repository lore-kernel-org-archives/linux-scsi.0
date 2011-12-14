From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 3/3] ata: update ata port's runtime status during system resume
Date: Thu, 15 Dec 2011 02:45:01 +0800
Message-ID: <CAF1ivSbt6a=CNqXJ9byrDmTHdhygBKSbr6Pxf+Cwwpa6B++BZw@mail.gmail.com>
References: <1323832681-7177-1-git-send-email-ming.m.lin@intel.com>
	<1323832681-7177-4-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1323832681-7177-4-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 14, 2011 at 11:18 AM, Lin Ming <ming.m.lin@intel.com> wrote=
:
> The ata port is brought back to full power state during system resume=
=2E
> So its runtime PM status will have to be updated to reflect
> the actual post-system sleep status.
>
> This also fixes below warning during system suspend/resume.
>
> WARNING: at /work/linux/drivers/ata/libata-eh.c:4034
> ata_scsi_port_error_handler+0x89/0x557()
>
> 4034 =A0 =A0 =A0 =A0 WARN_ON(!(ap->pflags & ATA_PFLAG_SUSPENDED));
>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Hi Alan,

Would you like to Ack this one also?

Thanks,
Lin Ming

> ---
> =A0drivers/ata/libata-core.c | =A0 18 ++++++++++++++++--
> =A01 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 15a3d4d..8996758 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5298,7 +5298,7 @@ static int ata_port_suspend(struct device *dev)
> =A0 =A0 =A0 =A0return ata_port_suspend_common(dev);
> =A0}
>
> -static int ata_port_resume(struct device *dev)
> +static int ata_port_resume_common(struct device *dev)
> =A0{
> =A0 =A0 =A0 =A0struct ata_port *ap =3D to_ata_port(dev);
> =A0 =A0 =A0 =A0int rc;
> @@ -5308,6 +5308,20 @@ static int ata_port_resume(struct device *dev)
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +static int ata_port_resume(struct device *dev)
> +{
> + =A0 =A0 =A0 int rc;
> +
> + =A0 =A0 =A0 rc =3D ata_port_resume_common(dev);
> + =A0 =A0 =A0 if (!rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm_runtime_disable(dev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm_runtime_set_active(dev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm_runtime_enable(dev);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0static int ata_port_runtime_idle(struct device *dev)
> =A0{
> =A0 =A0 =A0 =A0return pm_runtime_suspend(dev);
> @@ -5318,7 +5332,7 @@ static const struct dev_pm_ops ata_port_pm_ops =
=3D {
> =A0 =A0 =A0 =A0.resume =3D ata_port_resume,
>
> =A0 =A0 =A0 =A0.runtime_suspend =3D ata_port_suspend_common,
> - =A0 =A0 =A0 .runtime_resume =3D ata_port_resume,
> + =A0 =A0 =A0 .runtime_resume =3D ata_port_resume_common,
> =A0 =A0 =A0 =A0.runtime_idle =3D ata_port_runtime_idle,
> =A0};
>
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
