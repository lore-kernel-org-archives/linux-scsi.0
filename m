From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [libsas PATCH v10 3/9] libata, libsas: introduce sched_eh and
 end_eh port ops
Date: Tue, 10 Apr 2012 19:13:12 -0700
Message-ID: <CAA9_cmc1j4Xs7P=eh+Y833o5uA3K4rCGc56cYZrB=xF8XO-p+A@mail.gmail.com>
References: <20120311043722.27797.97791.stgit@dwillia2-linux.jf.intel.com>
	<20120311043912.27797.20898.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120311043912.27797.20898.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Ping?  Ack on the ata changes?  I'd like to submit this to
scsi-rc-fixes for 3.4-rc to fix regression fallout around
host_eh_scheduled handling now that libsas ata eh is asynchronous.

On Sat, Mar 10, 2012 at 8:39 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> When managing shost->host_eh_scheduled libata assumes that there is a
> 1:1 shost-to-ata_port relationship. =A0libsas creates a 1:N relations=
hip
> so it needs to manage host_eh_scheduled cumulatively at the host leve=
l.
> The sched_eh and end_eh port port ops allow libsas to track when doma=
in
> devices enter/leave the "eh-pending" state under ha->lock (previously
> named ha->state_lock, but it is no longer just a lock for ha->state
> changes).
>
> Since host_eh_scheduled indicates eh without backing commands pinning
> the device it can be deallocated at any time. =A0Move the taking of t=
he
> domain_device reference under the port_lock to guarantee that the
> ata_port stays around for the duration of eh.
>
> Cc: Tejun Heo <tj@kernel.org>
> Acked-by: Jacek Danecki <jacek.danecki@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0drivers/ata/libata-core.c =A0 =A0 =A0 =A0 =A0 | =A0 =A04 ++
> =A0drivers/ata/libata-eh.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 57 +++++++++=
+++++++++++++++++++-------
> =A0drivers/scsi/libsas/sas_ata.c =A0 =A0 =A0 | =A0 38 +++++++++++++++=
++++++--
> =A0drivers/scsi/libsas/sas_discover.c =A0| =A0 =A06 ++--
> =A0drivers/scsi/libsas/sas_event.c =A0 =A0 | =A0 12 ++++---
> =A0drivers/scsi/libsas/sas_init.c =A0 =A0 =A0| =A0 14 ++++-----
> =A0drivers/scsi/libsas/sas_scsi_host.c | =A0 27 +++++++++++++----
> =A0include/linux/libata.h =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A04 ++
> =A0include/scsi/libsas.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A04 ++
> =A0include/scsi/sas_ata.h =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A05 +++
> =A010 files changed, 134 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 1654c94..827881e 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -79,6 +79,8 @@ const struct ata_port_operations ata_base_port_ops =
=3D {
> =A0 =A0 =A0 =A0.prereset =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D ata_std_prer=
eset,
> =A0 =A0 =A0 =A0.postreset =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D ata_std_post=
reset,
> =A0 =A0 =A0 =A0.error_handler =A0 =A0 =A0 =A0 =A0=3D ata_std_error_ha=
ndler,
> + =A0 =A0 =A0 .sched_eh =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D ata_std_sched=
_eh,
> + =A0 =A0 =A0 .end_eh =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D ata_std_end=
_eh,
> =A0};
>
> =A0const struct ata_port_operations sata_port_ops =3D {
> @@ -6573,6 +6575,8 @@ struct ata_port_operations ata_dummy_port_ops =3D=
 {
> =A0 =A0 =A0 =A0.qc_prep =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D ata_noop_q=
c_prep,
> =A0 =A0 =A0 =A0.qc_issue =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D ata_dummy_qc=
_issue,
> =A0 =A0 =A0 =A0.error_handler =A0 =A0 =A0 =A0 =A0=3D ata_dummy_error_=
handler,
> + =A0 =A0 =A0 .sched_eh =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D ata_std_sched=
_eh,
> + =A0 =A0 =A0 .end_eh =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D ata_std_end=
_eh,
> =A0};
>
> =A0const struct ata_port_info ata_dummy_port_info =3D {
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index c61316e..4f12f63 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -793,12 +793,12 @@ void ata_scsi_port_error_handler(struct Scsi_Ho=
st *host, struct ata_port *ap)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ata_for_each_link(link, ap, HOST_FIRST=
)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(&link->eh_info,=
 0, sizeof(link->eh_info));
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Clear host_eh_scheduled while holdin=
g ap->lock such
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* that if exception occurs after thi=
s point but
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* before EH completion, SCSI midlaye=
r will
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* end eh (clear host_eh_scheduled) whi=
le holding
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ap->lock such that if exception oc=
curs after this
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* point but before EH completion, SC=
SI midlayer will
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * re-initiate EH.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 host->host_eh_scheduled =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ap->ops->end_eh(ap);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(ap->lock, flags=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ata_eh_release(ap);
> @@ -986,16 +986,13 @@ void ata_qc_schedule_eh(struct ata_queued_cmd *=
qc)
> =A0}
>
> =A0/**
> - * =A0 =A0 ata_port_schedule_eh - schedule error handling without a =
qc
> - * =A0 =A0 @ap: ATA port to schedule EH for
> - *
> - * =A0 =A0 Schedule error handling for @ap. =A0EH will kick in as so=
on as
> - * =A0 =A0 all commands are drained.
> + * ata_std_sched_eh - non-libsas ata_ports issue eh with this common=
 routine
> + * @ap: ATA port to schedule EH for
> =A0*
> - * =A0 =A0 LOCKING:
> + * =A0 =A0 LOCKING: inherited from ata_port_schedule_eh
> =A0* =A0 =A0 spin_lock_irqsave(host lock)
> =A0*/
> -void ata_port_schedule_eh(struct ata_port *ap)
> +void ata_std_sched_eh(struct ata_port *ap)
> =A0{
> =A0 =A0 =A0 =A0WARN_ON(!ap->ops->error_handler);
>
> @@ -1007,6 +1004,44 @@ void ata_port_schedule_eh(struct ata_port *ap)
>
> =A0 =A0 =A0 =A0DPRINTK("port EH scheduled\n");
> =A0}
> +EXPORT_SYMBOL_GPL(ata_std_sched_eh);
> +
> +/**
> + * ata_std_end_eh - non-libsas ata_ports complete eh with this commo=
n routine
> + * @ap: ATA port to end EH for
> + *
> + * In the libata object model there is a 1:1 mapping of ata_port to
> + * shost, so host fields can be directly manipulated under ap->lock,=
 in
> + * the libsas case we need to hold a lock at the ha->level to coordi=
nate
> + * these events.
> + *
> + * =A0 =A0 LOCKING:
> + * =A0 =A0 spin_lock_irqsave(host lock)
> + */
> +void ata_std_end_eh(struct ata_port *ap)
> +{
> + =A0 =A0 =A0 struct Scsi_Host *host =3D ap->scsi_host;
> +
> + =A0 =A0 =A0 host->host_eh_scheduled =3D 0;
> +}
> +EXPORT_SYMBOL(ata_std_end_eh);
> +
> +
> +/**
> + * =A0 =A0 ata_port_schedule_eh - schedule error handling without a =
qc
> + * =A0 =A0 @ap: ATA port to schedule EH for
> + *
> + * =A0 =A0 Schedule error handling for @ap. =A0EH will kick in as so=
on as
> + * =A0 =A0 all commands are drained.
> + *
> + * =A0 =A0 LOCKING:
> + * =A0 =A0 spin_lock_irqsave(host lock)
> + */
> +void ata_port_schedule_eh(struct ata_port *ap)
> +{
> + =A0 =A0 =A0 /* see: ata_std_sched_eh, unless you know better */
> + =A0 =A0 =A0 ap->ops->sched_eh(ap);
> +}
>
> =A0static int ata_do_link_abort(struct ata_port *ap, struct ata_link =
*link)
> =A0{
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_=
ata.c
> index 729a7b6..d30a093 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -523,6 +523,31 @@ static void sas_ata_set_dmamode(struct ata_port =
*ap, struct ata_device *ata_dev)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i->dft->lldd_ata_set_dmamode(dev);
> =A0}
>
> +static void sas_ata_sched_eh(struct ata_port *ap)
> +{
> + =A0 =A0 =A0 struct domain_device *dev =3D ap->private_data;
> + =A0 =A0 =A0 struct sas_ha_struct *ha =3D dev->port->ha;
> + =A0 =A0 =A0 unsigned long flags;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(&ha->lock, flags);
> + =A0 =A0 =A0 if (!test_and_set_bit(SAS_DEV_EH_PENDING, &dev->state))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ha->eh_active++;
> + =A0 =A0 =A0 ata_std_sched_eh(ap);
> + =A0 =A0 =A0 spin_unlock_irqrestore(&ha->lock, flags);
> +}
> +
> +void sas_ata_end_eh(struct ata_port *ap)
> +{
> + =A0 =A0 =A0 struct domain_device *dev =3D ap->private_data;
> + =A0 =A0 =A0 struct sas_ha_struct *ha =3D dev->port->ha;
> + =A0 =A0 =A0 unsigned long flags;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(&ha->lock, flags);
> + =A0 =A0 =A0 if (test_and_clear_bit(SAS_DEV_EH_PENDING, &dev->state)=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ha->eh_active--;
> + =A0 =A0 =A0 spin_unlock_irqrestore(&ha->lock, flags);
> +}
> +
> =A0static struct ata_port_operations sas_sata_ops =3D {
> =A0 =A0 =A0 =A0.prereset =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D ata_std_prer=
eset,
> =A0 =A0 =A0 =A0.hardreset =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D sas_ata_hard=
_reset,
> @@ -536,6 +561,8 @@ static struct ata_port_operations sas_sata_ops =3D=
 {
> =A0 =A0 =A0 =A0.port_start =A0 =A0 =A0 =A0 =A0 =A0 =3D ata_sas_port_s=
tart,
> =A0 =A0 =A0 =A0.port_stop =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D ata_sas_port=
_stop,
> =A0 =A0 =A0 =A0.set_dmamode =A0 =A0 =A0 =A0 =A0 =A0=3D sas_ata_set_dm=
amode,
> + =A0 =A0 =A0 .sched_eh =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D sas_ata_sched=
_eh,
> + =A0 =A0 =A0 .end_eh =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D sas_ata_end=
_eh,
> =A0};
>
> =A0static struct ata_port_info sata_port_info =3D {
> @@ -684,10 +711,6 @@ static void async_sas_ata_eh(void *data, async_c=
ookie_t cookie)
> =A0 =A0 =A0 =A0struct ata_port *ap =3D dev->sata_dev.ap;
> =A0 =A0 =A0 =A0struct sas_ha_struct *ha =3D dev->port->ha;
>
> - =A0 =A0 =A0 /* hold a reference over eh since we may be racing with=
 final
> - =A0 =A0 =A0 =A0* remove once all commands are completed
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 kref_get(&dev->kref);
> =A0 =A0 =A0 =A0sas_ata_printk(KERN_DEBUG, dev, "dev error handler\n")=
;
> =A0 =A0 =A0 =A0ata_scsi_port_error_handler(ha->core.shost, ap);
> =A0 =A0 =A0 =A0sas_put_device(dev);
> @@ -730,6 +753,13 @@ void sas_ata_strategy_handler(struct Scsi_Host *=
shost)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_for_each_entry(dev, &port->dev_li=
st, dev_list_node) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!sas_ata_dev_eh_va=
lid(dev))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0contin=
ue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* hold a reference ove=
r eh since we may be
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* racing with final =
remove once all commands
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* are completed
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kref_get(&dev->kref);
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0async_schedule_domain(=
async_sas_ata_eh, dev, &async);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&port->dev_list_lock);
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas=
/sas_discover.c
> index bd8c636..a730ac9 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -282,6 +282,8 @@ static void sas_unregister_common_dev(struct asd_=
sas_port *port, struct domain_d
>
> =A0 =A0 =A0 =A0spin_lock_irq(&port->dev_list_lock);
> =A0 =A0 =A0 =A0list_del_init(&dev->dev_list_node);
> + =A0 =A0 =A0 if (dev_is_sata(dev))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sas_ata_end_eh(dev->sata_dev.ap);
> =A0 =A0 =A0 =A0spin_unlock_irq(&port->dev_list_lock);
>
> =A0 =A0 =A0 =A0sas_put_device(dev);
> @@ -479,9 +481,9 @@ static void sas_chain_event(int event, unsigned l=
ong *pending,
> =A0 =A0 =A0 =A0if (!test_and_set_bit(event, pending)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long flags;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&ha->state_lock, flag=
s);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&ha->lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sas_chain_work(ha, sw);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&ha->state_lock,=
 flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&ha->lock, flags=
);
> =A0 =A0 =A0 =A0}
> =A0}
>
> diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sa=
s_event.c
> index 4e4292d..789c4d8 100644
> --- a/drivers/scsi/libsas/sas_event.c
> +++ b/drivers/scsi/libsas/sas_event.c
> @@ -47,9 +47,9 @@ static void sas_queue_event(int event, unsigned lon=
g *pending,
> =A0 =A0 =A0 =A0if (!test_and_set_bit(event, pending)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long flags;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&ha->state_lock, flag=
s);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&ha->lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sas_queue_work(ha, work);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&ha->state_lock,=
 flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&ha->lock, flags=
);
> =A0 =A0 =A0 =A0}
> =A0}
>
> @@ -61,18 +61,18 @@ void __sas_drain_work(struct sas_ha_struct *ha)
>
> =A0 =A0 =A0 =A0set_bit(SAS_HA_DRAINING, &ha->state);
> =A0 =A0 =A0 =A0/* flush submitters */
> - =A0 =A0 =A0 spin_lock_irq(&ha->state_lock);
> - =A0 =A0 =A0 spin_unlock_irq(&ha->state_lock);
> + =A0 =A0 =A0 spin_lock_irq(&ha->lock);
> + =A0 =A0 =A0 spin_unlock_irq(&ha->lock);
>
> =A0 =A0 =A0 =A0drain_workqueue(wq);
>
> - =A0 =A0 =A0 spin_lock_irq(&ha->state_lock);
> + =A0 =A0 =A0 spin_lock_irq(&ha->lock);
> =A0 =A0 =A0 =A0clear_bit(SAS_HA_DRAINING, &ha->state);
> =A0 =A0 =A0 =A0list_for_each_entry_safe(sw, _sw, &ha->defer_q, drain_=
node) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del_init(&sw->drain_node);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sas_queue_work(ha, sw);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 spin_unlock_irq(&ha->state_lock);
> + =A0 =A0 =A0 spin_unlock_irq(&ha->lock);
> =A0}
>
> =A0int sas_drain_work(struct sas_ha_struct *ha)
> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas=
_init.c
> index 10cb5ae..6909fef 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -114,7 +114,7 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sas_ha->lldd_queue_size =3D 128; /* Sa=
nity */
>
> =A0 =A0 =A0 =A0set_bit(SAS_HA_REGISTERED, &sas_ha->state);
> - =A0 =A0 =A0 spin_lock_init(&sas_ha->state_lock);
> + =A0 =A0 =A0 spin_lock_init(&sas_ha->lock);
> =A0 =A0 =A0 =A0mutex_init(&sas_ha->drain_mutex);
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&sas_ha->defer_q);
>
> @@ -163,9 +163,9 @@ int sas_unregister_ha(struct sas_ha_struct *sas_h=
a)
> =A0 =A0 =A0 =A0 * events to be queued, and flush any in-progress drai=
ners
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0mutex_lock(&sas_ha->drain_mutex);
> - =A0 =A0 =A0 spin_lock_irq(&sas_ha->state_lock);
> + =A0 =A0 =A0 spin_lock_irq(&sas_ha->lock);
> =A0 =A0 =A0 =A0clear_bit(SAS_HA_REGISTERED, &sas_ha->state);
> - =A0 =A0 =A0 spin_unlock_irq(&sas_ha->state_lock);
> + =A0 =A0 =A0 spin_unlock_irq(&sas_ha->lock);
> =A0 =A0 =A0 =A0__sas_drain_work(sas_ha);
> =A0 =A0 =A0 =A0mutex_unlock(&sas_ha->drain_mutex);
>
> @@ -411,9 +411,9 @@ static int queue_phy_reset(struct sas_phy *phy, i=
nt hard_reset)
> =A0 =A0 =A0 =A0d->reset_result =3D 0;
> =A0 =A0 =A0 =A0d->hard_reset =3D hard_reset;
>
> - =A0 =A0 =A0 spin_lock_irq(&ha->state_lock);
> + =A0 =A0 =A0 spin_lock_irq(&ha->lock);
> =A0 =A0 =A0 =A0sas_queue_work(ha, &d->reset_work);
> - =A0 =A0 =A0 spin_unlock_irq(&ha->state_lock);
> + =A0 =A0 =A0 spin_unlock_irq(&ha->lock);
>
> =A0 =A0 =A0 =A0rc =3D sas_drain_work(ha);
> =A0 =A0 =A0 =A0if (rc =3D=3D 0)
> @@ -438,9 +438,9 @@ static int queue_phy_enable(struct sas_phy *phy, =
int enable)
> =A0 =A0 =A0 =A0d->enable_result =3D 0;
> =A0 =A0 =A0 =A0d->enable =3D enable;
>
> - =A0 =A0 =A0 spin_lock_irq(&ha->state_lock);
> + =A0 =A0 =A0 spin_lock_irq(&ha->lock);
> =A0 =A0 =A0 =A0sas_queue_work(ha, &d->enable_work);
> - =A0 =A0 =A0 spin_unlock_irq(&ha->state_lock);
> + =A0 =A0 =A0 spin_unlock_irq(&ha->lock);
>
> =A0 =A0 =A0 =A0rc =3D sas_drain_work(ha);
> =A0 =A0 =A0 =A0if (rc =3D=3D 0)
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsa=
s/sas_scsi_host.c
> index 49a9113..cd63d80 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -667,16 +667,20 @@ static void sas_eh_handle_sas_errors(struct Scs=
i_Host *shost, struct list_head *
> =A0 =A0 =A0 =A0goto out;
> =A0}
>
> +
> =A0void sas_scsi_recover_host(struct Scsi_Host *shost)
> =A0{
> =A0 =A0 =A0 =A0struct sas_ha_struct *ha =3D SHOST_TO_SAS_HA(shost);
> - =A0 =A0 =A0 unsigned long flags;
> =A0 =A0 =A0 =A0LIST_HEAD(eh_work_q);
> + =A0 =A0 =A0 int tries =3D 0;
> + =A0 =A0 =A0 bool retry;
>
> - =A0 =A0 =A0 spin_lock_irqsave(shost->host_lock, flags);
> +retry:
> + =A0 =A0 =A0 tries++;
> + =A0 =A0 =A0 retry =3D true;
> + =A0 =A0 =A0 spin_lock_irq(shost->host_lock);
> =A0 =A0 =A0 =A0list_splice_init(&shost->eh_cmd_q, &eh_work_q);
> - =A0 =A0 =A0 shost->host_eh_scheduled =3D 0;
> - =A0 =A0 =A0 spin_unlock_irqrestore(shost->host_lock, flags);
> + =A0 =A0 =A0 spin_unlock_irq(shost->host_lock);
>
> =A0 =A0 =A0 =A0SAS_DPRINTK("Enter %s busy: %d failed: %d\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, shost->host_busy, sh=
ost->host_failed);
> @@ -710,8 +714,19 @@ out:
>
> =A0 =A0 =A0 =A0scsi_eh_flush_done_q(&ha->eh_done_q);
>
> - =A0 =A0 =A0 SAS_DPRINTK("--- Exit %s: busy: %d failed: %d\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, shost->host_busy, sho=
st->host_failed);
> + =A0 =A0 =A0 /* check if any new eh work was scheduled during the la=
st run */
> + =A0 =A0 =A0 spin_lock_irq(&ha->lock);
> + =A0 =A0 =A0 if (ha->eh_active =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 shost->host_eh_scheduled =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 retry =3D false;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock_irq(&ha->lock);
> +
> + =A0 =A0 =A0 if (retry)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto retry;
> +
> + =A0 =A0 =A0 SAS_DPRINTK("--- Exit %s: busy: %d failed: %d tries: %d=
\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, shost->host_busy, sho=
st->host_failed, tries);
> =A0}
>
> =A0enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 42378d6..83ff256 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -845,6 +845,8 @@ struct ata_port_operations {
> =A0 =A0 =A0 =A0void (*error_handler)(struct ata_port *ap);
> =A0 =A0 =A0 =A0void (*lost_interrupt)(struct ata_port *ap);
> =A0 =A0 =A0 =A0void (*post_internal_cmd)(struct ata_queued_cmd *qc);
> + =A0 =A0 =A0 void (*sched_eh)(struct ata_port *ap);
> + =A0 =A0 =A0 void (*end_eh)(struct ata_port *ap);
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Optional features
> @@ -1165,6 +1167,8 @@ extern void ata_do_eh(struct ata_port *ap, ata_=
prereset_fn_t prereset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ata_reset_fn_t softreset, =
ata_reset_fn_t hardreset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ata_postreset_fn_t postres=
et);
> =A0extern void ata_std_error_handler(struct ata_port *ap);
> +extern void ata_std_sched_eh(struct ata_port *ap);
> +extern void ata_std_end_eh(struct ata_port *ap);
> =A0extern int ata_link_nr_enabled(struct ata_link *link);
>
> =A0/*
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index f4f1c96..c0c94b3 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -177,6 +177,7 @@ struct sata_device {
> =A0enum {
> =A0 =A0 =A0 =A0SAS_DEV_GONE,
> =A0 =A0 =A0 =A0SAS_DEV_DESTROY,
> + =A0 =A0 =A0 SAS_DEV_EH_PENDING,
> =A0};
>
> =A0struct domain_device {
> @@ -384,7 +385,8 @@ struct sas_ha_struct {
> =A0 =A0 =A0 =A0struct list_head =A0defer_q; /* work queued while drai=
ning */
> =A0 =A0 =A0 =A0struct mutex =A0 =A0 =A0drain_mutex;
> =A0 =A0 =A0 =A0unsigned long =A0 =A0 state;
> - =A0 =A0 =A0 spinlock_t =A0 =A0 =A0 =A0state_lock;
> + =A0 =A0 =A0 spinlock_t =A0 =A0 =A0 =A0lock;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 eh_active;
>
> =A0 =A0 =A0 =A0struct mutex disco_mutex;
>
> diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
> index 6d5d60c..3e13c28 100644
> --- a/include/scsi/sas_ata.h
> +++ b/include/scsi/sas_ata.h
> @@ -44,6 +44,7 @@ void sas_ata_eh(struct Scsi_Host *shost, struct lis=
t_head *work_q,
> =A0void sas_ata_schedule_reset(struct domain_device *dev);
> =A0void sas_ata_wait_eh(struct domain_device *dev);
> =A0void sas_probe_sata(struct asd_sas_port *port);
> +void sas_ata_end_eh(struct ata_port *ap);
> =A0#else
>
>
> @@ -81,6 +82,10 @@ static inline int sas_get_ata_info(struct domain_d=
evice *dev, struct ex_phy *phy
> =A0{
> =A0 =A0 =A0 =A0return 0;
> =A0}
> +
> +static inline void sas_ata_end_eh(struct ata_port *ap)
> +{
> +}
> =A0#endif
>
> =A0#endif /* _SAS_ATA_H_ */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
