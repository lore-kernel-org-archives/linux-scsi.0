From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Wed, 22 Apr 2009 12:08:38 -0700
Message-ID: <da824cf30904221208l42e41d38g5af52b1b3b5ea9a1@mail.gmail.com>
References: <20090422090929.GA14928@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090422090929.GA14928@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 22, 2009 at 2:09 AM, Jeff Garzik <jeff@garzik.org> wrote:
>
> Currently, libata creates a Scsi_Host per port. =C2=A0This was origin=
ally
> done to leverage SCSI's infrastructure to arbitrate among master/slav=
e
> devices, but is not needed for most modern SATA controllers. =C2=A0 A=
nd I
> _think_ it is not needed for master/slave if done properly, either.
>
> The patch below converts libata such that there is now a 1:1
> correspondence between struct Scsi_Host and struct ata_host. =C2=A0AT=
A ports
> are represented as SCSI layer 'channels', which is more natural.

Jeff,
So far in reading this, the only reasons I gather for changing this
mapping are "not needed" and "is more natural". Data Center
environments (not just Google's) like to track disks in many different
ways, including the SCSI identifiers since this one "key" for physical
location. Breaking the current mappings is going to cause some people
a world of pain since they will need to manually build (and integrate)
old->new maps of the SCSI identifiers. Can you propose some real,
tangible benefit to making this change? (e.g. enables some other
feature)

Mark already pointed out this might cause issues with Error Handling
(forcing a review of all that code). So before triggering other
developers (e.g. HW vendors) do that kind of work I'd like to hear
what the reward is going to be at the end.

thanks,
grant

>
> This patch is an experiment, and not meant for upstream anytime soon.
> I just wanted to see what kind of effort would be required to get it
> to work.
>
> I was able to successfully boot the following patch on
> AHCI/x86-64/Fedora.
>
> It may work with other controllers -- TRY AT YOUR OWN RISK. =C2=A0It =
will
> probably fail for master/slave configurations, and SAS & PMP also
> need looking at. =C2=A0It yielded this lsscsi output on my AHCI box:
>
> [0:0:0:0] =C2=A0 =C2=A0disk =C2=A0 =C2=A0ATA =C2=A0 =C2=A0 =C2=A0ST35=
00320AS =C2=A0 =C2=A0 =C2=A0SD15 =C2=A0/dev/sda
> [0:2:0:0] =C2=A0 =C2=A0disk =C2=A0 =C2=A0ATA =C2=A0 =C2=A0 =C2=A0G.SK=
ILL 128GB SS 02.1 =C2=A0/dev/sdb
> [0:5:0:0] =C2=A0 =C2=A0cd/dvd =C2=A0PIONEER =C2=A0BD-ROM =C2=A0BDC-20=
2 =C2=A01.04 =C2=A0/dev/sr0
>
> NOT-signed-off-by: me
>
> =C2=A0drivers/ata/ahci.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A0 =C2=A04
> =C2=A0drivers/ata/libata-core.c =C2=A0 =C2=A0 | =C2=A0 17 +--
> =C2=A0drivers/ata/libata-eh.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 47 ++++++=
--
> =C2=A0drivers/ata/libata-scsi.c =C2=A0 =C2=A0 | =C2=A0237 +++++++++++=
++++++++++---------------------
> =C2=A0drivers/ata/libata.h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0=
 =C2=A03
> =C2=A0drivers/scsi/libsas/sas_ata.c | =C2=A0 =C2=A02
> =C2=A0include/linux/libata.h =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A0=
9 -
> =C2=A07 files changed, 184 insertions(+), 135 deletions(-)
>
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 08186ec..b0468a8 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -326,14 +326,18 @@ static ssize_t ahci_activity_store(struct ata_d=
evice *dev,
> =C2=A0static void ahci_init_sw_activity(struct ata_link *link);
>
> =C2=A0static struct device_attribute *ahci_shost_attrs[] =3D {
> +#if 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0&dev_attr_link_power_management_policy,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0&dev_attr_em_message_type,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0&dev_attr_em_message,
> +#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0NULL
> =C2=A0};
>
> =C2=A0static struct device_attribute *ahci_sdev_attrs[] =3D {
> +#if 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0&dev_attr_sw_activity,
> +#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0&dev_attr_unload_heads,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0NULL
> =C2=A0};
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 17c5d48..71f32dc 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -95,6 +95,7 @@ static void ata_dev_xfermask(struct ata_device *dev=
);
> =C2=A0static unsigned long ata_dev_blacklisted(const struct ata_devic=
e *dev);
>
> =C2=A0unsigned int ata_print_id =3D 1;
> +unsigned int ata_host_print_id =3D 1;
> =C2=A0static struct workqueue_struct *ata_wq;
>
> =C2=A0struct workqueue_struct *ata_aux_wq;
> @@ -2308,7 +2309,7 @@ static void ata_dev_config_ncq(struct ata_devic=
e *dev,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ap->flags & ATA_FLAG_NCQ) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hdepth =3D min(ap-=
>scsi_host->can_queue, ATA_MAX_QUEUE - 1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hdepth =3D min(ap-=
>host->scsi_host->can_queue, ATA_MAX_QUEUE - 1);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev->flags |=3D=
 ATA_DFLAG_NCQ;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> @@ -5635,15 +5636,15 @@ static void ata_host_release(struct device *g=
endev, void *res)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ap)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0continue;
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ap->scsi_host)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 scsi_host_put(ap->scsi_host);
> -
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(ap->pmp_=
link);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(ap->slav=
e_link);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(ap);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0host->ports[i]=
 =3D NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> + =C2=A0 =C2=A0 =C2=A0 if (host->scsi_host)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_host_put(host=
->scsi_host);
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_set_drvdata(gendev, NULL);
> =C2=A0}
>
> @@ -6089,6 +6090,8 @@ int ata_host_register(struct ata_host *host, st=
ruct scsi_host_template *sht)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i < host->n_ports; i++)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0host->ports[i]=
->print_id =3D ata_print_id++;
>
> + =C2=A0 =C2=A0 =C2=A0 host->print_id =3D ata_host_print_id++;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D ata_scsi_add_hosts(host, sht);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> @@ -6222,8 +6225,7 @@ static void ata_port_detach(struct ata_port *ap=
)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cancel_rearming_delayed_work(&ap->hotplug_=
task);
>
> =C2=A0skip_eh:
> - =C2=A0 =C2=A0 =C2=A0 /* remove the associated SCSI host */
> - =C2=A0 =C2=A0 =C2=A0 scsi_remove_host(ap->scsi_host);
> + =C2=A0 =C2=A0 =C2=A0 return;
> =C2=A0}
>
> =C2=A0/**
> @@ -6242,6 +6244,9 @@ void ata_host_detach(struct ata_host *host)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i < host->n_ports; i++)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ata_port_detac=
h(host->ports[i]);
>
> + =C2=A0 =C2=A0 =C2=A0 /* remove the associated SCSI host */
> + =C2=A0 =C2=A0 =C2=A0 scsi_remove_host(host->scsi_host);
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* the host is dead now, dissociate ACPI *=
/
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ata_acpi_dissociate(host);
> =C2=A0}
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 0183131..db8a66f 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -466,14 +466,22 @@ static void ata_eh_clear_action(struct ata_link=
 *link, struct ata_device *dev,
> =C2=A0*/
> =C2=A0enum blk_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *c=
md)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct Scsi_Host *host =3D cmd->device->host;
> - =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap =3D ata_shost_to_port(host=
);
> + =C2=A0 =C2=A0 =C2=A0 struct Scsi_Host *shost =3D cmd->device->host;
> + =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap;
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host;
> + =C2=A0 =C2=A0 =C2=A0 struct ata_device *atadev;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_queued_cmd *qc;
> - =C2=A0 =C2=A0 =C2=A0 enum blk_eh_timer_return ret;
> + =C2=A0 =C2=A0 =C2=A0 enum blk_eh_timer_return ret =3D BLK_EH_NOT_HA=
NDLED;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0DPRINTK("ENTER\n");
>
> + =C2=A0 =C2=A0 =C2=A0 host =3D ata_shost_to_host(shost);
> + =C2=A0 =C2=A0 =C2=A0 atadev =3D ata_scsi_find_dev(host, cmd->device=
);
> + =C2=A0 =C2=A0 =C2=A0 if (!atadev)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 ap =3D atadev->link->ap;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ap->ops->error_handler) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D BLK_EH=
_NOT_HANDLED;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> @@ -532,13 +540,12 @@ static void ata_eh_unload(struct ata_port *ap)
> =C2=A0* =C2=A0 =C2=A0 RETURNS:
> =C2=A0* =C2=A0 =C2=A0 Zero.
> =C2=A0*/
> -void ata_scsi_error(struct Scsi_Host *host)
> +static void __ata_scsi_error(struct Scsi_Host *shost, struct ata_por=
t *ap)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap =3D ata_shost_to_port(host=
);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int i;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
>
> - =C2=A0 =C2=A0 =C2=A0 DPRINTK("ENTER\n");
> + =C2=A0 =C2=A0 =C2=A0 DPRINTK("ENTER, port_no %u\n", ap->port_no);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* synchronize with port task */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ata_port_flush_task(ap);
> @@ -575,7 +582,7 @@ void ata_scsi_error(struct Scsi_Host *host)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ap->ops->l=
ost_interrupt)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ap->ops->lost_interrupt(ap);
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entr=
y_safe(scmd, tmp, &host->eh_cmd_q, eh_entry) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entr=
y_safe(scmd, tmp, &shost->eh_cmd_q, eh_entry) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0struct ata_queued_cmd *qc;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0for (i =3D 0; i < ATA_MAX_QUEUE; i++) {
> @@ -698,7 +705,7 @@ void ata_scsi_error(struct Scsi_Host *host)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * before EH c=
ompletion, SCSI midlayer will
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * re-initiate=
 EH.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 host->host_eh_sche=
duled =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 shost->host_eh_sch=
eduled =3D 0;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_ir=
qrestore(ap->lock, flags);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> @@ -707,7 +714,7 @@ void ata_scsi_error(struct Scsi_Host *host)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* finish or retry handled scmd's and clea=
n up */
> - =C2=A0 =C2=A0 =C2=A0 WARN_ON(host->host_failed || !list_empty(&host=
->eh_cmd_q));
> + =C2=A0 =C2=A0 =C2=A0 WARN_ON(shost->host_failed || !list_empty(&sho=
st->eh_cmd_q));
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0scsi_eh_flush_done_q(&ap->eh_done_q);
>
> @@ -733,6 +740,24 @@ void ata_scsi_error(struct Scsi_Host *host)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0DPRINTK("EXIT\n");
> =C2=A0}
>
> +void ata_scsi_error(struct Scsi_Host *shost)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host =3D ata_shost_to_host(sh=
ost);
> + =C2=A0 =C2=A0 =C2=A0 unsigned int i;
> +
> + =C2=A0 =C2=A0 =C2=A0 DPRINTK("ENTER\n");
> +
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < host->n_ports; i++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ata_port *a=
p =3D host->ports[i];
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ap->pflags & A=
TA_PFLAG_EH_PENDING)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 __ata_scsi_error(shost, ap);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 DPRINTK("EXIT\n");
> +}
> +
> +
> =C2=A0/**
> =C2=A0* =C2=A0 =C2=A0 ata_port_wait_eh - Wait for the currently pendi=
ng EH to complete
> =C2=A0* =C2=A0 =C2=A0 @ap: Port to wait EH for
> @@ -761,7 +786,7 @@ void ata_port_wait_eh(struct ata_port *ap)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irqrestore(ap->lock, flags);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* make sure SCSI EH is complete */
> - =C2=A0 =C2=A0 =C2=A0 if (scsi_host_in_recovery(ap->scsi_host)) {
> + =C2=A0 =C2=A0 =C2=A0 if (scsi_host_in_recovery(ap->host->scsi_host)=
) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0msleep(10);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto retry;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> @@ -901,7 +926,7 @@ void ata_port_schedule_eh(struct ata_port *ap)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ata_eh_set_pending(ap, 1);
> - =C2=A0 =C2=A0 =C2=A0 scsi_schedule_eh(ap->scsi_host);
> + =C2=A0 =C2=A0 =C2=A0 scsi_schedule_eh(ap->host->scsi_host);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0DPRINTK("port EH scheduled\n");
> =C2=A0}
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2733b0c..7aa6aa6 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -58,10 +58,8 @@ static u8 ata_scsi_rbuf[ATA_SCSI_RBUF_SIZE];
>
> =C2=A0typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *=
qc);
>
> -static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
> +static struct ata_device *__ata_scsi_find_dev(struct ata_host *,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c=
onst struct scsi_device *scsidev);
> -static struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 const struct scsi_device *scsidev);
> =C2=A0static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned=
 int channel,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int id, unsigned int lun);
>
> @@ -136,6 +134,7 @@ static const char *ata_scsi_lpm_get(enum link_pm =
policy)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> =C2=A0}
>
> +#if 0
> =C2=A0static ssize_t ata_scsi_lpm_put(struct device *dev,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct device_attribute *attr=
,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *buf, size_t count=
)
> @@ -183,6 +182,7 @@ ata_scsi_lpm_show(struct device *dev, struct devi=
ce_attribute *attr, char *buf)
> =C2=A0DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ata_scsi_lpm_s=
how, ata_scsi_lpm_put);
> =C2=A0EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
> +#endif
>
> =C2=A0static ssize_t ata_scsi_park_show(struct device *device,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct device_attribut=
e *attr, char *buf)
> @@ -190,19 +190,21 @@ static ssize_t ata_scsi_park_show(struct device=
 *device,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct scsi_device *sdev =3D to_scsi_devic=
e(device);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_port *ap;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_link *link;
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_device *dev;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags, now;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int uninitialized_var(msecs);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int rc =3D 0;
>
> - =C2=A0 =C2=A0 =C2=A0 ap =3D ata_shost_to_port(sdev->host);
> + =C2=A0 =C2=A0 =C2=A0 host =3D ata_shost_to_host(sdev->host);
>
> - =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(ap->lock, flags);
> - =C2=A0 =C2=A0 =C2=A0 dev =3D ata_scsi_find_dev(ap, sdev);
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&host->lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 dev =3D ata_scsi_find_dev(host, sdev);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dev) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -ENODEV=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto unlock;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> + =C2=A0 =C2=A0 =C2=A0 ap =3D dev->link->ap;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -EOPNOT=
SUPP;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto unlock;
> @@ -218,7 +220,7 @@ static ssize_t ata_scsi_park_show(struct device *=
device,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0msecs =3D 0;
>
> =C2=A0unlock:
> - =C2=A0 =C2=A0 =C2=A0 spin_unlock_irq(ap->lock);
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irq(&host->lock);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc ? rc : snprintf(buf, 20, "%u\n",=
 msecs);
> =C2=A0}
> @@ -230,6 +232,7 @@ static ssize_t ata_scsi_park_store(struct device =
*device,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct scsi_device *sdev =3D to_scsi_devic=
e(device);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_port *ap;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_device *dev;
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0long int input;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int rc;
> @@ -242,14 +245,15 @@ static ssize_t ata_scsi_park_store(struct devic=
e *device,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0input =3D ATA_=
TMOUT_MAX_PARK;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> - =C2=A0 =C2=A0 =C2=A0 ap =3D ata_shost_to_port(sdev->host);
> + =C2=A0 =C2=A0 =C2=A0 host =3D ata_shost_to_host(sdev->host);
>
> - =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(ap->lock, flags);
> - =C2=A0 =C2=A0 =C2=A0 dev =3D ata_scsi_find_dev(ap, sdev);
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&host->lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 dev =3D ata_scsi_find_dev(host, sdev);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!dev)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -ENODEV=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto unlock;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> + =C2=A0 =C2=A0 =C2=A0 ap =3D dev->link->ap;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dev->class !=3D ATA_DEV_ATA) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -EOPNOT=
SUPP;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto unlock;
> @@ -276,7 +280,7 @@ static ssize_t ata_scsi_park_store(struct device =
*device,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0unlock:
> - =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(ap->lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&host->lock, flags);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc ? rc : len;
> =C2=A0}
> @@ -291,6 +295,7 @@ static void ata_scsi_set_sense(struct scsi_cmnd *=
cmd, u8 sk, u8 asc, u8 ascq)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0scsi_build_sense_buffer(0, cmd->sense_buff=
er, sk, asc, ascq);
> =C2=A0}
>
> +#if 0
> =C2=A0static ssize_t
> =C2=A0ata_scsi_em_message_store(struct device *dev, struct device_att=
ribute *attr,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0const char *buf, size_t count)
> @@ -335,8 +340,9 @@ ata_scsi_activity_show(struct device *dev, struct=
 device_attribute *attr,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0char *buf)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct scsi_device *sdev =3D to_scsi_devic=
e(dev);
> - =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap =3D ata_shost_to_port(sdev=
->host);
> - =C2=A0 =C2=A0 =C2=A0 struct ata_device *atadev =3D ata_scsi_find_de=
v(ap, sdev);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host =3D ata_shost_to_host(sd=
ev->host);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_device *atadev =3D ata_scsi_find_de=
v(host, sdev);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap =3D atadev->ap;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ap->ops->sw_activity_show && (ap->flag=
s & ATA_FLAG_SW_ACTIVITY))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ap->ops=
->sw_activity_show(atadev, buf);
> @@ -348,8 +354,9 @@ ata_scsi_activity_store(struct device *dev, struc=
t device_attribute *attr,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *buf, size_t count)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct scsi_device *sdev =3D to_scsi_devic=
e(dev);
> - =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap =3D ata_shost_to_port(sdev=
->host);
> - =C2=A0 =C2=A0 =C2=A0 struct ata_device *atadev =3D ata_scsi_find_de=
v(ap, sdev);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host =3D ata_shost_to_host(sd=
ev->host);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_device *atadev =3D ata_scsi_find_de=
v(host, sdev);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap =3D atadev->ap;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0enum sw_activity val;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int rc;
>
> @@ -369,6 +376,7 @@ ata_scsi_activity_store(struct device *dev, struc=
t device_attribute *attr,
> =C2=A0DEVICE_ATTR(sw_activity, S_IWUGO | S_IRUGO, ata_scsi_activity_s=
how,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ata_scsi_activity_store);
> =C2=A0EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
> +#endif
>
> =C2=A0struct device_attribute *ata_common_sdev_attrs[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0&dev_attr_unload_heads,
> @@ -425,10 +433,10 @@ int ata_std_bios_param(struct scsi_device *sdev=
, struct block_device *bdev,
> =C2=A0* =C2=A0 =C2=A0 RETURNS:
> =C2=A0* =C2=A0 =C2=A0 Zero on success, negative errno on error.
> =C2=A0*/
> -static int ata_get_identity(struct ata_port *ap, struct scsi_device =
*sdev,
> +static int ata_get_identity(struct ata_host *host, struct scsi_devic=
e *sdev,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0void __user *arg)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct ata_device *dev =3D ata_scsi_find_dev(a=
p, sdev);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_device *dev =3D ata_scsi_find_dev(h=
ost, sdev);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u16 __user *dst =3D arg;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0char buf[40];
>
> @@ -656,11 +664,18 @@ static int ata_ioc32(struct ata_port *ap)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
>
> -int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *scsi=
dev,
> +int ata_sas_scsi_ioctl(struct ata_host *host, struct scsi_device *sc=
sidev,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 int cmd, void __user *arg)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int val =3D -EINVAL, rc =3D -EINVAL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
> + =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap;
> + =C2=A0 =C2=A0 =C2=A0 struct ata_device *atadev;
> +
> + =C2=A0 =C2=A0 =C2=A0 atadev =3D ata_scsi_find_dev(host, scsidev);
> + =C2=A0 =C2=A0 =C2=A0 if (!atadev)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOENT;
> + =C2=A0 =C2=A0 =C2=A0 ap =3D atadev->link->ap;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (cmd) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case ATA_IOC_GET_IO32:
> @@ -688,7 +703,7 @@ int ata_sas_scsi_ioctl(struct ata_port *ap, struc=
t scsi_device *scsidev,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case HDIO_GET_IDENTITY:
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ata_get_ide=
ntity(ap, scsidev, arg);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ata_get_ide=
ntity(host, scsidev, arg);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case HDIO_DRIVE_CMD:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!capable(C=
AP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
> @@ -711,7 +726,7 @@ EXPORT_SYMBOL_GPL(ata_sas_scsi_ioctl);
>
> =C2=A0int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void _=
_user *arg)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 return ata_sas_scsi_ioctl(ata_shost_to_port(sc=
sidev->host),
> + =C2=A0 =C2=A0 =C2=A0 return ata_sas_scsi_ioctl(ata_shost_to_host(sc=
sidev->host),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scsidev, cmd, arg);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
> @@ -1157,8 +1172,8 @@ static int ata_scsi_dev_config(struct scsi_devi=
ce *sdev,
>
> =C2=A0int ata_scsi_slave_config(struct scsi_device *sdev)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap =3D ata_shost_to_port(sdev=
->host);
> - =C2=A0 =C2=A0 =C2=A0 struct ata_device *dev =3D __ata_scsi_find_dev=
(ap, sdev);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host =3D ata_shost_to_host(sd=
ev->host);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_device *dev =3D __ata_scsi_find_dev=
(host, sdev);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int rc =3D 0;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ata_scsi_sdev_config(sdev);
> @@ -1185,27 +1200,34 @@ int ata_scsi_slave_config(struct scsi_device =
*sdev)
> =C2=A0*/
> =C2=A0void ata_scsi_slave_destroy(struct scsi_device *sdev)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap =3D ata_shost_to_port(sdev=
->host);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host =3D ata_shost_to_host(sd=
ev->host);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct request_queue *q =3D sdev->request_=
queue;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_device *dev;
> + =C2=A0 =C2=A0 =C2=A0 bool new_eh =3D true;
>
> - =C2=A0 =C2=A0 =C2=A0 if (!ap->ops->error_handler)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> -
> - =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(ap->lock, flags);
> - =C2=A0 =C2=A0 =C2=A0 dev =3D __ata_scsi_find_dev(ap, sdev);
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&host->lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 dev =3D __ata_scsi_find_dev(host, sdev);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dev && dev->sdev) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ata_port *a=
p =3D dev->link->ap;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ap->ops->erro=
r_handler)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 new_eh =3D false;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* SCSI device=
 already in CANCEL state, no need to offline it */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev->sdev =3D =
NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev->flags |=3D=
 ATA_DFLAG_DETACH;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ata_port_sched=
ule_eh(ap);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> - =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(ap->lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&host->lock, flags);
>
> - =C2=A0 =C2=A0 =C2=A0 kfree(q->dma_drain_buffer);
> - =C2=A0 =C2=A0 =C2=A0 q->dma_drain_buffer =3D NULL;
> - =C2=A0 =C2=A0 =C2=A0 q->dma_drain_size =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 if (new_eh) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(q->dma_drain=
_buffer);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 q->dma_drain_buffe=
r =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 q->dma_drain_size =
=3D 0;
> + =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0}
>
> =C2=A0/**
> @@ -1225,25 +1247,25 @@ void ata_scsi_slave_destroy(struct scsi_devic=
e *sdev)
> =C2=A0*/
> =C2=A0int ata_scsi_change_queue_depth(struct scsi_device *sdev, int q=
ueue_depth)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap =3D ata_shost_to_port(sdev=
->host);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host =3D ata_shost_to_host(sd=
ev->host);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_device *dev;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (queue_depth < 1 || queue_depth =3D=3D =
sdev->queue_depth)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return sdev->q=
ueue_depth;
>
> - =C2=A0 =C2=A0 =C2=A0 dev =3D ata_scsi_find_dev(ap, sdev);
> + =C2=A0 =C2=A0 =C2=A0 dev =3D ata_scsi_find_dev(host, sdev);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dev || !ata_dev_enabled(dev))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return sdev->q=
ueue_depth;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* NCQ enabled? */
> - =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(ap->lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&host->lock, flags);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0dev->flags &=3D ~ATA_DFLAG_NCQ_OFF;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (queue_depth =3D=3D 1 || !ata_ncq_enabl=
ed(dev)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev->flags |=3D=
 ATA_DFLAG_NCQ_OFF;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0queue_depth =3D=
 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> - =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(ap->lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&host->lock, flags);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* limit and apply queue depth */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0queue_depth =3D min(queue_depth, sdev->hos=
t->can_queue);
> @@ -2690,21 +2712,20 @@ static struct ata_device *ata_find_dev(struct=
 ata_port *ap, int devno)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> =C2=A0}
>
> -static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
> +static struct ata_device *__ata_scsi_find_dev(struct ata_host *host,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0const struct scsi_device *scsidev)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int devno;
> + =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap;
>
> - =C2=A0 =C2=A0 =C2=A0 /* skip commands not addressed to targets we s=
imulate */
> - =C2=A0 =C2=A0 =C2=A0 if (!sata_pmp_attached(ap)) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(scsid=
ev->channel || scsidev->lun))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return NULL;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 devno =3D scsidev-=
>id;
> - =C2=A0 =C2=A0 =C2=A0 } else {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(scsid=
ev->id || scsidev->lun))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return NULL;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 devno =3D scsidev-=
>channel;
> - =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 if (scsidev->channel > host->n_ports)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> +
> + =C2=A0 =C2=A0 =C2=A0 ap =3D host->ports[scsidev->channel];
> + =C2=A0 =C2=A0 =C2=A0 if (ata_port_is_dummy(ap))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> +
> + =C2=A0 =C2=A0 =C2=A0 devno =3D scsidev->id;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ata_find_dev(ap, devno);
> =C2=A0}
> @@ -2725,10 +2746,10 @@ static struct ata_device *__ata_scsi_find_dev=
(struct ata_port *ap,
> =C2=A0* =C2=A0 =C2=A0 RETURNS:
> =C2=A0* =C2=A0 =C2=A0 Associated ATA device, or %NULL if not found.
> =C2=A0*/
> -static struct ata_device *
> -ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scs=
idev)
> +struct ata_device *
> +ata_scsi_find_dev(struct ata_host *host, const struct scsi_device *s=
csidev)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct ata_device *dev =3D __ata_scsi_find_dev=
(ap, scsidev);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_device *dev =3D __ata_scsi_find_dev=
(host, scsidev);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!dev || !ata_dev_enabled(dev)=
))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> @@ -2983,15 +3004,13 @@ static inline ata_xlat_func_t ata_get_xlat_fu=
nc(struct ata_device *dev, u8 cmd)
> =C2=A0* =C2=A0 =C2=A0 Prints the contents of a SCSI command via print=
k().
> =C2=A0*/
>
> -static inline void ata_scsi_dump_cdb(struct ata_port *ap,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct scsi_cmn=
d *cmd)
> +static inline void ata_scsi_dump_cdb(struct scsi_cmnd *cmd)
> =C2=A0{
> =C2=A0#ifdef ATA_DEBUG
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct scsi_device *scsidev =3D cmd->devic=
e;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 *scsicmd =3D cmd->cmnd;
>
> - =C2=A0 =C2=A0 =C2=A0 DPRINTK("CDB (%u:%d,%d,%d) %02x %02x %02x %02x=
 %02x %02x %02x %02x %02x\n",
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ap->print_id,
> + =C2=A0 =C2=A0 =C2=A0 DPRINTK("CDB (%d,%d,%d) %02x %02x %02x %02x %0=
2x %02x %02x %02x %02x\n",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scsidev->chann=
el, scsidev->id, scsidev->lun,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scsicmd[0], sc=
sicmd[1], scsicmd[2], scsicmd[3],
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0scsicmd[4], sc=
sicmd[5], scsicmd[6], scsicmd[7],
> @@ -3069,20 +3088,20 @@ static inline int __ata_scsi_queuecmd(struct =
scsi_cmnd *scmd,
> =C2=A0*/
> =C2=A0int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struc=
t scsi_cmnd *))
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_device *dev;
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct scsi_device *scsidev =3D cmd->devic=
e;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct Scsi_Host *shost =3D scsidev->host;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int rc =3D 0;
>
> - =C2=A0 =C2=A0 =C2=A0 ap =3D ata_shost_to_port(shost);
> + =C2=A0 =C2=A0 =C2=A0 host =3D ata_shost_to_host(shost);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(shost->host_lock);
> - =C2=A0 =C2=A0 =C2=A0 spin_lock(ap->lock);
> + =C2=A0 =C2=A0 =C2=A0 spin_lock(&host->lock);
>
> - =C2=A0 =C2=A0 =C2=A0 ata_scsi_dump_cdb(ap, cmd);
> + =C2=A0 =C2=A0 =C2=A0 ata_scsi_dump_cdb(cmd);
>
> - =C2=A0 =C2=A0 =C2=A0 dev =3D ata_scsi_find_dev(ap, scsidev);
> + =C2=A0 =C2=A0 =C2=A0 dev =3D ata_scsi_find_dev(host, scsidev);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (likely(dev))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D __ata_s=
csi_queuecmd(cmd, done, dev);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
> @@ -3090,7 +3109,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, vo=
id (*done)(struct scsi_cmnd *))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0done(cmd);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> - =C2=A0 =C2=A0 =C2=A0 spin_unlock(ap->lock);
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock(&host->lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(shost->host_lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> =C2=A0}
> @@ -3217,56 +3236,43 @@ void ata_scsi_simulate(struct ata_device *dev=
, struct scsi_cmnd *cmd,
>
> =C2=A0int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_=
template *sht)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 int i, rc;
> -
> - =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < host->n_ports; i++) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ata_port *a=
p =3D host->ports[i];
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct Scsi_Host *=
shost;
> + =C2=A0 =C2=A0 =C2=A0 int rc;
> + =C2=A0 =C2=A0 =C2=A0 struct Scsi_Host *shost;
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -ENOMEM;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 shost =3D scsi_hos=
t_alloc(sht, sizeof(struct ata_port *));
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!shost)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto err_alloc;
> + =C2=A0 =C2=A0 =C2=A0 shost =3D scsi_host_alloc(sht, sizeof(struct a=
ta_host *));
> + =C2=A0 =C2=A0 =C2=A0 if (!shost)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *(struct ata_port =
**)&shost->hostdata[0] =3D ap;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ap->scsi_host =3D =
shost;
> + =C2=A0 =C2=A0 =C2=A0 *(struct ata_host **)&shost->hostdata[0] =3D h=
ost;
> + =C2=A0 =C2=A0 =C2=A0 host->scsi_host =3D shost;
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 shost->transportt =
=3D &ata_scsi_transport_template;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 shost->unique_id =3D=
 ap->print_id;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 shost->max_id =3D =
16;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 shost->max_lun =3D=
 1;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 shost->max_channel=
 =3D 1;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 shost->max_cmd_len=
 =3D 16;
> + =C2=A0 =C2=A0 =C2=A0 shost->transportt =3D &ata_scsi_transport_temp=
late;
> + =C2=A0 =C2=A0 =C2=A0 shost->unique_id =3D host->print_id;
> + =C2=A0 =C2=A0 =C2=A0 shost->max_id =3D 32;
> + =C2=A0 =C2=A0 =C2=A0 shost->max_lun =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 shost->max_channel =3D 32;
> + =C2=A0 =C2=A0 =C2=A0 shost->max_cmd_len =3D 16;
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Schedule policy=
 is determined by ->qc_defer()
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* callback a=
nd it needs to see every deferred qc.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Set host_b=
locked to 1 to prevent SCSI midlayer from
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* automatica=
lly deferring requests.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 shost->max_host_bl=
ocked =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 /* Schedule policy is determined by ->qc_defer=
()
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* callback and it needs to see every def=
erred qc.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Set host_blocked to 1 to prevent SCSI =
midlayer from
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* automatically deferring requests.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 shost->max_host_blocked =3D 1;
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D scsi_add_ho=
st(ap->scsi_host, ap->host->dev);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto err_add;
> + =C2=A0 =C2=A0 =C2=A0 rc =3D scsi_add_host(shost, host->dev);
> + =C2=A0 =C2=A0 =C2=A0 if (rc) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_host_put(shos=
t);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> -
> - err_add:
> - =C2=A0 =C2=A0 =C2=A0 scsi_host_put(host->ports[i]->scsi_host);
> - err_alloc:
> - =C2=A0 =C2=A0 =C2=A0 while (--i >=3D 0) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct Scsi_Host *=
shost =3D host->ports[i]->scsi_host;
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_remove_host(s=
host);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_host_put(shos=
t);
> - =C2=A0 =C2=A0 =C2=A0 }
> - =C2=A0 =C2=A0 =C2=A0 return rc;
> =C2=A0}
>
> =C2=A0void ata_scsi_scan_host(struct ata_port *ap, int sync)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int tries =3D 5;
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host =3D ap->host;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_device *last_failed_dev =3D NUL=
L;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_link *link;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_device *dev;
> @@ -3278,7 +3284,7 @@ void ata_scsi_scan_host(struct ata_port *ap, in=
t sync)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ata_for_each_link(link, ap, EDGE) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ata_for_each_d=
ev(dev, link, ENABLED) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0struct scsi_device *sdev;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 int channel =3D 0, id =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 int id =3D 0;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (dev->sdev)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0continue;
> @@ -3286,9 +3292,10 @@ void ata_scsi_scan_host(struct ata_port *ap, i=
nt sync)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (ata_is_host_link(link))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0id =3D dev->devno;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0else
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 channel =3D link->pmp;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 id =3D link->pmp;
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 sdev =3D __scsi_add_device(ap->scsi_host, channel, id, 0,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 sdev =3D __scsi_add_device(host->scsi_host,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0ap->port_no, id, 0,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 NULL);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (!IS_ERR(sdev)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev->sdev =3D sdev;
> @@ -3376,6 +3383,7 @@ int ata_scsi_offline_dev(struct ata_device *dev=
)
> =C2=A0static void ata_scsi_remove_dev(struct ata_device *dev)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_port *ap =3D dev->link->ap;
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host =3D ap->host;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct scsi_device *sdev;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
>
> @@ -3385,7 +3393,7 @@ static void ata_scsi_remove_dev(struct ata_devi=
ce *dev)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * be removed if there is __scsi_device_ge=
t() interface which
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * increments reference counts regardless =
of device state.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 mutex_lock(&ap->scsi_host->scan_mutex);
> + =C2=A0 =C2=A0 =C2=A0 mutex_lock(&host->scsi_host->scan_mutex);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irqsave(ap->lock, flags);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* clearing dev->sdev is protected by host=
 lock */
> @@ -3411,7 +3419,7 @@ static void ata_scsi_remove_dev(struct ata_devi=
ce *dev)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irqrestore(ap->lock, flags);
> - =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&ap->scsi_host->scan_mutex);
> + =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&host->scsi_host->scan_mutex);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sdev) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ata_dev_printk=
(dev, KERN_INFO, "detaching (SCSI %s)\n",
> @@ -3517,25 +3525,28 @@ void ata_scsi_hotplug(struct work_struct *wor=
k)
> =C2=A0static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned=
 int channel,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int id, unsigned int lun)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap =3D ata_shost_to_port(shos=
t);
> + =C2=A0 =C2=A0 =C2=A0 struct ata_port *ap;
> + =C2=A0 =C2=A0 =C2=A0 struct ata_host *host =3D ata_shost_to_host(sh=
ost);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int devno, rc =3D 0;
>
> + =C2=A0 =C2=A0 =C2=A0 if (channel =3D=3D SCAN_WILD_CARD)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ap =3D host->ports=
[0];
> + =C2=A0 =C2=A0 =C2=A0 else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (channel > host=
->n_ports)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return -EINVAL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ap =3D host->ports=
[channel];
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ap->ops->error_handler)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EOPNOT=
SUPP;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (lun !=3D SCAN_WILD_CARD && lun)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL=
;
>
> - =C2=A0 =C2=A0 =C2=A0 if (!sata_pmp_attached(ap)) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (channel !=3D S=
CAN_WILD_CARD && channel)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return -EINVAL;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 devno =3D id;
> - =C2=A0 =C2=A0 =C2=A0 } else {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (id !=3D SCAN_W=
ILD_CARD && id)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return -EINVAL;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 devno =3D channel;
> - =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 if (id !=3D SCAN_WILD_CARD && id)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> + =C2=A0 =C2=A0 =C2=A0 devno =3D id;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irqsave(ap->lock, flags);
>
> @@ -3749,7 +3760,7 @@ int ata_sas_queuecmd(struct scsi_cmnd *cmd, voi=
d (*done)(struct scsi_cmnd *),
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int rc =3D 0;
>
> - =C2=A0 =C2=A0 =C2=A0 ata_scsi_dump_cdb(ap, cmd);
> + =C2=A0 =C2=A0 =C2=A0 ata_scsi_dump_cdb(cmd);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (likely(ata_dev_enabled(ap->link.device=
)))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D __ata_s=
csi_queuecmd(cmd, done, ap->link.device);
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 89a1e00..af890b4 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -205,4 +205,7 @@ extern u8 ata_irq_on(struct ata_port *ap);
> =C2=A0extern void ata_pio_task(struct work_struct *work);
> =C2=A0#endif /* CONFIG_ATA_SFF */
>
> +struct ata_device *
> +ata_scsi_find_dev(struct ata_host *host, const struct scsi_device *s=
csidev);
> +
> =C2=A0#endif /* __LIBATA_H__ */
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_=
ata.c
> index e155011..758df0b 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -375,6 +375,7 @@ int sas_ata_init_host_and_port(struct domain_devi=
ce *found_dev,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ha->dev,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0sata_port_info.flags,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0&sas_sata_ops);
> + =C2=A0 =C2=A0 =C2=A0 found_dev->sata_dev.ata_host.scsi_host =3D sho=
st;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ap =3D ata_sas_port_alloc(&found_dev->sata=
_dev.ata_host,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&sata_port_info,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0shost);
> @@ -385,7 +386,6 @@ int sas_ata_init_host_and_port(struct domain_devi=
ce *found_dev,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ap->private_data =3D found_dev;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ap->cbl =3D ATA_CBL_SATA;
> - =C2=A0 =C2=A0 =C2=A0 ap->scsi_host =3D shost;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0found_dev->sata_dev.ap =3D ap;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 3d501db..2ea4dce 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -507,10 +507,12 @@ struct ata_ioports {
> =C2=A0#endif /* CONFIG_ATA_SFF */
>
> =C2=A0struct ata_host {
> + =C2=A0 =C2=A0 =C2=A0 struct Scsi_Host =C2=A0 =C2=A0 =C2=A0 =C2=A0*s=
csi_host; /* our co-allocated scsi host */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spinlock_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0lock;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct device =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 *dev;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0void __iomem * const =C2=A0 =C2=A0*iomap;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0n_ports;
> + =C2=A0 =C2=A0 =C2=A0 unsigned int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0print_id; /* user visible unique host ID */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0void =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*private_data;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_port_operations *ops;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 flags;
> @@ -690,7 +692,6 @@ struct ata_link {
> =C2=A0};
>
> =C2=A0struct ata_port {
> - =C2=A0 =C2=A0 =C2=A0 struct Scsi_Host =C2=A0 =C2=A0 =C2=A0 =C2=A0*s=
csi_host; /* our co-allocated scsi host */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ata_port_operations *ops;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spinlock_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0*lock;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Flags owned by the EH context. Only EH =
should touch these once the
> @@ -947,7 +948,7 @@ extern void ata_host_init(struct ata_host *, stru=
ct device *,
> =C2=A0extern int ata_scsi_detect(struct scsi_host_template *sht);
> =C2=A0extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, voi=
d __user *arg);
> =C2=A0extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done=
)(struct scsi_cmnd *));
> -extern int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_devic=
e *dev,
> +extern int ata_sas_scsi_ioctl(struct ata_host *, struct scsi_device =
*dev,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0int cmd, void __user *arg);
> =C2=A0extern void ata_sas_port_destroy(struct ata_port *);
> =C2=A0extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
> @@ -1472,9 +1473,9 @@ static inline unsigned int __ac_err_mask(u8 sta=
tus)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return mask;
> =C2=A0}
>
> -static inline struct ata_port *ata_shost_to_port(struct Scsi_Host *h=
ost)
> +static inline struct ata_host *ata_shost_to_host(struct Scsi_Host *h=
ost)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 return *(struct ata_port **)&host->hostdata[0]=
;
> + =C2=A0 =C2=A0 =C2=A0 return *(struct ata_host **)&host->hostdata[0]=
;
> =C2=A0}
>
> =C2=A0static inline int ata_check_ready(u8 status)
>
