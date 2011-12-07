From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v5 5/6] ata: add ata port system PM callbacks
Date: Wed, 7 Dec 2011 16:38:38 +0800
Message-ID: <CAF1ivSbhL0-46rnKjHdTBOrJG+9n_cKYF4=fL+HR8YFtmDVZOg@mail.gmail.com>
References: <1323048028-10421-1-git-send-email-ming.m.lin@intel.com>
	<1323048028-10421-6-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1323048028-10421-6-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 5, 2011 at 9:20 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> Change ata_host_request_pm to ata_port_request_pm which performs
> port suspend/resume.
>
> Add ata port type driver which implements port PM callbacks.

Hi Tejun & Alan,

How about this patch?

Lin Ming

>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
> =A0drivers/ata/libata-core.c =A0 =A0 =A0| =A0144 ++++++++++++++++++++=
-------------------
> =A0drivers/ata/libata-transport.c | =A0 =A01 +
> =A0drivers/ata/libata.h =A0 =A0 =A0 =A0 =A0 | =A0 =A01 +
> =A03 files changed, 76 insertions(+), 70 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index c04ad68..04c208e 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5234,112 +5234,116 @@ bool ata_link_offline(struct ata_link *link=
)
> =A0}
>
> =A0#ifdef CONFIG_PM
> -static int ata_host_request_pm(struct ata_host *host, pm_message_t m=
esg,
> +static int ata_port_request_pm(struct ata_port *ap, pm_message_t mes=
g,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned =
int action, unsigned int ehi_flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int wait)
> =A0{
> + =A0 =A0 =A0 struct ata_link *link;
> =A0 =A0 =A0 =A0unsigned long flags;
> - =A0 =A0 =A0 int i, rc;
> -
> - =A0 =A0 =A0 for (i =3D 0; i < host->n_ports; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ata_port *ap =3D host->ports[i];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ata_link *link;
> + =A0 =A0 =A0 int rc;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Previous resume operation might stil=
l be in
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* progress. =A0Wait for PM_PENDING t=
o clear.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ap->pflags & ATA_PFLAG_PM_PENDING) =
{
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ata_port_wait_eh(ap);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(ap->pflags & AT=
A_PFLAG_PM_PENDING);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 /* Previous resume operation might still be in
> + =A0 =A0 =A0 =A0* progress. =A0Wait for PM_PENDING to clear.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (ap->pflags & ATA_PFLAG_PM_PENDING) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ata_port_wait_eh(ap);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDI=
NG);
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* request PM ops to EH */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(ap->lock, flags);
> + =A0 =A0 =A0 /* request PM ops to EH */
> + =A0 =A0 =A0 spin_lock_irqsave(ap->lock, flags);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ap->pm_mesg =3D mesg;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wait) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ap->pm_result =3D &rc;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 ap->pm_mesg =3D mesg;
> + =A0 =A0 =A0 if (wait) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ap->pm_result =3D &rc;
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ap->pflags |=3D ATA_PFLAG_PM_PENDING;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ata_for_each_link(link, ap, HOST_FIRST)=
 {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 link->eh_info.action |=3D=
 action;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 link->eh_info.flags |=3D=
 ehi_flags;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 ap->pflags |=3D ATA_PFLAG_PM_PENDING;
> + =A0 =A0 =A0 ata_for_each_link(link, ap, HOST_FIRST) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 link->eh_info.action |=3D action;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 link->eh_info.flags |=3D ehi_flags;
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ata_port_schedule_eh(ap);
> + =A0 =A0 =A0 ata_port_schedule_eh(ap);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(ap->lock, flags)=
;
> + =A0 =A0 =A0 spin_unlock_irqrestore(ap->lock, flags);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* wait and check result */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wait) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ata_port_wait_eh(ap);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(ap->pflags & AT=
A_PFLAG_PM_PENDING);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
rc;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 /* wait and check result */
> + =A0 =A0 =A0 if (wait) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ata_port_wait_eh(ap);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDI=
NG);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 return rc;
> =A0}
>
> +#define to_ata_port(d) container_of(d, struct ata_port, tdev)
> +
> +static int ata_port_suspend_common(struct device *dev)
> +{
> + =A0 =A0 =A0 struct ata_port *ap =3D to_ata_port(dev);
> + =A0 =A0 =A0 int rc;
> +
> + =A0 =A0 =A0 rc =3D ata_port_request_pm(ap, PMSG_SUSPEND, 0, ATA_EHI=
_QUIET, 1);
> + =A0 =A0 =A0 return rc;
> +}
> +
> +static int ata_port_suspend(struct device *dev)
> +{
> + =A0 =A0 =A0 if (pm_runtime_suspended(dev))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 return ata_port_suspend_common(dev);
> +}
> +
> +static int ata_port_resume(struct device *dev)
> +{
> + =A0 =A0 =A0 struct ata_port *ap =3D to_ata_port(dev);
> + =A0 =A0 =A0 int rc;
> +
> + =A0 =A0 =A0 rc =3D ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 1);
> + =A0 =A0 =A0 return rc;
> +}
> +
> +static const struct dev_pm_ops ata_port_pm_ops =3D {
> + =A0 =A0 =A0 .suspend =3D ata_port_suspend,
> + =A0 =A0 =A0 .resume =3D ata_port_resume,
> +};
> +
> =A0/**
> =A0* =A0 =A0 ata_host_suspend - suspend host
> =A0* =A0 =A0 @host: host to suspend
> =A0* =A0 =A0 @mesg: PM message
> =A0*
> - * =A0 =A0 Suspend @host. =A0Actual operation is performed by EH. =A0=
This
> - * =A0 =A0 function requests EH to perform PM operations and waits f=
or EH
> - * =A0 =A0 to finish.
> - *
> - * =A0 =A0 LOCKING:
> - * =A0 =A0 Kernel thread context (may sleep).
> - *
> - * =A0 =A0 RETURNS:
> - * =A0 =A0 0 on success, -errno on failure.
> + * =A0 =A0 Suspend @host. =A0Actual operation is performed by port s=
uspend.
> =A0*/
> =A0int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
> =A0{
> - =A0 =A0 =A0 unsigned int ehi_flags =3D ATA_EHI_QUIET;
> - =A0 =A0 =A0 int rc;
> -
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* On some hardware, device fails to respond after sp=
un down
> - =A0 =A0 =A0 =A0* for suspend. =A0As the device won't be used before=
 being
> - =A0 =A0 =A0 =A0* resumed, we don't need to touch the device. =A0Ask=
 EH to skip
> - =A0 =A0 =A0 =A0* the usual stuff and proceed directly to suspend.
> - =A0 =A0 =A0 =A0*
> - =A0 =A0 =A0 =A0* http://thread.gmane.org/gmane.linux.ide/46764
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 if (mesg.event =3D=3D PM_EVENT_SUSPEND)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ehi_flags |=3D ATA_EHI_NO_AUTOPSY | ATA=
_EHI_NO_RECOVERY;
> -
> - =A0 =A0 =A0 rc =3D ata_host_request_pm(host, mesg, 0, ehi_flags, 1)=
;
> - =A0 =A0 =A0 if (rc =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 host->dev->power.power_state =3D mesg;
> - =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 host->dev->power.power_state =3D mesg;
> + =A0 =A0 =A0 return 0;
> =A0}
>
> =A0/**
> =A0* =A0 =A0 ata_host_resume - resume host
> =A0* =A0 =A0 @host: host to resume
> =A0*
> - * =A0 =A0 Resume @host. =A0Actual operation is performed by EH. =A0=
This
> - * =A0 =A0 function requests EH to perform PM operations and returns=
=2E
> - * =A0 =A0 Note that all resume operations are performed parallelly.
> - *
> - * =A0 =A0 LOCKING:
> - * =A0 =A0 Kernel thread context (may sleep).
> + * =A0 =A0 Resume @host. =A0Actual operation is performed by port re=
sume.
> =A0*/
> =A0void ata_host_resume(struct ata_host *host)
> =A0{
> - =A0 =A0 =A0 ata_host_request_pm(host, PMSG_ON, ATA_EH_RESET,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ATA_EHI_NO_AUTO=
PSY | ATA_EHI_QUIET, 0);
> =A0 =A0 =A0 =A0host->dev->power.power_state =3D PMSG_ON;
> =A0}
> =A0#endif
>
> +struct device_type ata_port_type =3D {
> + =A0 =A0 =A0 .name =3D "ata_port",
> +#ifdef CONFIG_PM
> + =A0 =A0 =A0 .pm =3D &ata_port_pm_ops,
> +#endif
> +};
> +
> =A0/**
> =A0* =A0 =A0 ata_dev_init - Initialize an ata_device structure
> =A0* =A0 =A0 @dev: Device structure to initialize
> diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-tran=
sport.c
> index ce9dc62..3ceb3d9 100644
> --- a/drivers/ata/libata-transport.c
> +++ b/drivers/ata/libata-transport.c
> @@ -279,6 +279,7 @@ int ata_tport_add(struct device *parent,
> =A0 =A0 =A0 =A0struct device *dev =3D &ap->tdev;
>
> =A0 =A0 =A0 =A0device_initialize(dev);
> + =A0 =A0 =A0 dev->type =3D &ata_port_type;
>
> =A0 =A0 =A0 =A0dev->parent =3D get_device(parent);
> =A0 =A0 =A0 =A0dev->release =3D ata_tport_release;
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 773de97..814486d 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -58,6 +58,7 @@ extern int atapi_passthru16;
> =A0extern int libata_fua;
> =A0extern int libata_noacpi;
> =A0extern int libata_allow_tpm;
> +extern struct device_type ata_port_type;
> =A0extern struct ata_link *ata_dev_phys_link(struct ata_device *dev);
> =A0extern void ata_force_cbl(struct ata_port *ap);
> =A0extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
