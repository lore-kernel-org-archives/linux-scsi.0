From: Audio Haven <audiohaven@gmail.com>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Tue, 29 Jun 2010 13:46:38 +0200
Message-ID: <AANLkTimAdlkXIx7KW3URSx9EXYxZ1eaLlXoOg0fIQIr1@mail.gmail.com>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
	<1267786018.8894.43.camel@mulgrave.site>
	<6B62480106F2B34D8404CF2FDAA4D9EF71F65D5D21@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6d63fb43edcc7048a29ca3a
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45751 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0F2Lql (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jun 2010 07:46:41 -0400
Received: by bwz1 with SMTP id 1so669238bwz.19
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2010 04:46:38 -0700 (PDT)
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF71F65D5D21@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--0016e6d63fb43edcc7048a29ca3a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Srinivas,

I have tested this patch with a stock 2.6.32.7 kernel on a x86_64
running Centos 5.5.
I have another box with 8 1TB disks in a raid6 config: 6 drives are
SAMSUNG HD103SI, 2 drives are Hitachi HDT721010SLA360.

I frequently get the following behaviour:

A large file IO suddenly becomes very slow (eg watching a HDTV file
over samba), then the following is then reported:

drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1967:Release slot [2] tag[2], task
[ffff880035138700]:
drivers/scsi/mvsas/mv_sas.c 1967:Release slot [0] tag[0], task
[ffff88003b436000]:
drivers/scsi/mvsas/mv_sas.c 1967:Release slot [3] tag[3], task
[ffff88003b4361c0]:
drivers/scsi/mvsas/mv_sas.c 1967:Release slot [4] tag[4], task
[ffff88003b436380]:
drivers/scsi/mvsas/mv_sas.c 1967:Release slot [5] tag[5], task
[ffff88003b436540]:
drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for device[7]:rc=3D 0
ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata18: status=3D0x01 { Error }
ata18: error=3D0x04 { DriveStatusError }
ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata18: status=3D0x01 { Error }
ata18: error=3D0x04 { DriveStatusError }
ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata18: status=3D0x01 { Error }
ata18: error=3D0x04 { DriveStatusError }
ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata18: status=3D0x01 { Error }
ata18: error=3D0x04 { DriveStatusError }
ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata18: status=3D0x01 { Error }
ata18: error=3D0x04 { DriveStatusError }
ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata18: status=3D0x01 { Error }
ata18: error=3D0x04 { DriveStatusError }
ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata18: status=3D0x01 { Error }
ata18: error=3D0x04 { DriveStatusError }

Now the disks are never kicked out of raid

md2 : active raid6 sdl1[7] sde1[0] sdk1[6] sdj1[5] sdi1[4] sdh1[3]
sdg1[2] sdf1[1]
      5860558848 blocks super 1.2 level 6, 1024k chunk, algorithm 2
[8/8] [UUUUUUUU]

but anything running on this disk is halted and causes time outs. In
the past all these drives were connected to my motherboards SATA ports
as JBOD and they never failed or timed out. When connected to the
Supermicro AOC-SASLP-MV8 using your latest patch with the 10ms delay,
they sometimes timeout, which is difficult to predict.

Best regards,

Frederic Vanden Poel
aka Audio Haven

On Mon, Mar 8, 2010 at 1:58 PM, Srinivas Naga Venkatasatya
Pasagadugula - ERS, HCL Tech <satyasrinivasp@hcl.in> wrote:
> James,
>
> Thanks a lot for reviewing this patch.
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_update_phyinfo (mvi, phy=
_no, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phy->phy_type & PORT_TYPE_=
SAS) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_DISP-=
>phy_reset (mvi, phy_no, 2);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdelay (100);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> I agree with your analysis on the same. Mainly I have added this piece of=
 code for Tape issues. Here I used 100 ms delay which is not required, so I=
 have changed to 10ms i.e mdelay (10). I didn't face any issues with device=
s after changing it to 10ms.
> Please try to include this patch in RC tree. If required I will submit on=
e more patch for the same by considering your suggestion i.e reset in paral=
lel and then the settle time, but this requires a lot of testing to be done=
 so it will take some time to submit the patch.
>
> NOTE: I have attached the patch (copied from below thread) which is havin=
g one change i.e mdelay (10).
>
> Thanks,
> Srinivas.
>
> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@suse.de]
> Sent: Friday, March 05, 2010 4:17 PM
> To: Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
>
> On Tue, 2010-02-16 at 16:40 +0530, Srinivas Naga Venkatasatya
> Pasagadugula - ERS, HCL Tech wrote:
>> From: Srinivas <satyasrinivasp@hcl.in>
>> Date: Mon, 15 Feb 2010
>
> So, I'll add it, it seems to work based on the reports.
>
>> Subject: [PATCH]: Fix for hot plug handling and IO issues.
>> =A0 =A0 =A0 Added code for handling of hot-plugging drives and tape issu=
es.
>
> This is a bit terse for a change like this.
>
>> Signed-off-by: Srinivas <satyasrinivasp@hcl.in>
>
> This is the only bit that seems to have a serious technical problem:
>
>> @@ -2085,6 +2145,11 @@ void mvs_int_port(struct mvs_info *mvi, int phy_n=
o, u32 events)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy_no, tmp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_update_phyinfo(mvi, phy_=
no, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phy->phy_type & PORT_TYPE_=
SAS) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_DISP-=
>phy_reset(mvi, phy_no, 2);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdelay(100);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_bytes_dmaed(mvi, phy_no)=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* whether driver is going t=
o handle hot plug */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phy->phy_event & PHY_PLU=
G_OUT) {
>
> It's doing a 100ms CPU spin for each port initialisation. =A0For an eight
> port system, that's nearly a second, all of which is done with the
> mvi->lock held. =A0In particular, this is done in the ISR on some systems=
,
> so that's really going to add massive delays.
>
> It looks like this is just a bus settle time for the SAS ports, so
> obviously they could all be reset in parallel and then the settle time
> could be waited out (rather than doing each one in sequence), but
> realistically even a single 100ms wait in an interrupt routine is too
> long ... the port probably has to be marked as in reset somehow to avoid
> this.
>
> Other than the above, there were a large number of checkpatch errors,
> which I fixed:
>
> total: 58 errors, 19 warnings, 632 lines checked
>
> can you start with the patch below to carry these fixes forwards?
>
> Thanks,
>
> James
>
> ---
>
> diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
> index 10a5077..afc7f6f 100644
> --- a/drivers/scsi/mvsas/mv_64xx.c
> +++ b/drivers/scsi/mvsas/mv_64xx.c
> @@ -132,9 +132,9 @@ static void mvs_64xx_phy_reset(struct mvs_info *mvi, =
u32 phy_id, int hard)
> =A0 =A0 =A0 =A0tmp &=3D ~PHYEV_RDY_CH;
> =A0 =A0 =A0 =A0mvs_write_port_irq_stat(mvi, phy_id, tmp);
> =A0 =A0 =A0 =A0tmp =3D mvs_read_phy_ctl(mvi, phy_id);
> - =A0 =A0 =A0 if (hard)
> + =A0 =A0 =A0 if (hard =3D=3D 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tmp |=3D PHY_RST_HARD;
> - =A0 =A0 =A0 else
> + =A0 =A0 =A0 else if (hard =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tmp |=3D PHY_RST;
> =A0 =A0 =A0 =A0mvs_write_phy_ctl(mvi, phy_id, tmp);
> =A0 =A0 =A0 =A0if (hard) {
> @@ -144,6 +144,26 @@ static void mvs_64xx_phy_reset(struct mvs_info *mvi,=
 u32 phy_id, int hard)
> =A0 =A0 =A0 =A0}
> =A0}
>
> +void mvs_64xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set, u8 clear_a=
ll)
> +{
> + =A0 =A0 =A0 void __iomem *regs =3D mvi->regs;
> + =A0 =A0 =A0 u32 tmp;
> + =A0 =A0 =A0 if (clear_all) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D mr32(MVS_INT_STAT_SRS_0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tmp) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_DEBUG "check SR=
S 0 %08X.\n", tmp);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mw32(MVS_INT_STAT_SRS_0, tm=
p);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D mr32(MVS_INT_STAT_SRS_0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tmp & =A0(1 << (reg_set % 32))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_DEBUG "register=
 set 0x%x was stopped.\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0reg_set);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mw32(MVS_INT_STAT_SRS_0, 1 =
<< (reg_set % 32));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +}
> +
> =A0static int __devinit mvs_64xx_chip_reset(struct mvs_info *mvi)
> =A0{
> =A0 =A0 =A0 =A0void __iomem *regs =3D mvi->regs;
> @@ -761,6 +781,7 @@ const struct mvs_dispatch mvs_64xx_dispatch =3D {
> =A0 =A0 =A0 =A0mvs_write_port_irq_mask,
> =A0 =A0 =A0 =A0mvs_get_sas_addr,
> =A0 =A0 =A0 =A0mvs_64xx_command_active,
> + =A0 =A0 =A0 mvs_64xx_clear_srs_irq,
> =A0 =A0 =A0 =A0mvs_64xx_issue_stop,
> =A0 =A0 =A0 =A0mvs_start_delivery,
> =A0 =A0 =A0 =A0mvs_rx_update,
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index cae6b2c..203ff93 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -37,6 +37,7 @@ static const struct mvs_chip_info mvs_chips[] =3D {
> =A0};
>
> =A0#define SOC_SAS_NUM 2
> +#define SG_MX 64
>
> =A0static struct scsi_host_template mvs_sht =3D {
> =A0 =A0 =A0 =A0.module =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D THIS_MODULE,
> @@ -53,10 +54,10 @@ static struct scsi_host_template mvs_sht =3D {
> =A0 =A0 =A0 =A0.can_queue =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 1,
> =A0 =A0 =A0 =A0.cmd_per_lun =A0 =A0 =A0 =A0 =A0 =A0=3D 1,
> =A0 =A0 =A0 =A0.this_id =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D -1,
> - =A0 =A0 =A0 .sg_tablesize =A0 =A0 =A0 =A0 =A0 =3D SG_ALL,
> + =A0 =A0 =A0 .sg_tablesize =A0 =A0 =A0 =A0 =A0 =3D SG_MX,
> =A0 =A0 =A0 =A0.max_sectors =A0 =A0 =A0 =A0 =A0 =A0=3D SCSI_DEFAULT_MAX_S=
ECTORS,
> =A0 =A0 =A0 =A0.use_clustering =A0 =A0 =A0 =A0 =3D ENABLE_CLUSTERING,
> - =A0 =A0 =A0 .eh_device_reset_handler =A0 =A0 =A0 =A0=3D sas_eh_device_r=
eset_handler,
> + =A0 =A0 =A0 .eh_device_reset_handler =3D sas_eh_device_reset_handler,
> =A0 =A0 =A0 =A0.eh_bus_reset_handler =A0 =3D sas_eh_bus_reset_handler,
> =A0 =A0 =A0 =A0.slave_alloc =A0 =A0 =A0 =A0 =A0 =A0=3D mvs_slave_alloc,
> =A0 =A0 =A0 =A0.target_destroy =A0 =A0 =A0 =A0 =3D sas_target_destroy,
> @@ -65,19 +66,17 @@ static struct scsi_host_template mvs_sht =3D {
>
> =A0static struct sas_domain_function_template mvs_transport_ops =3D {
> =A0 =A0 =A0 =A0.lldd_dev_found =A0 =A0 =A0 =A0 =3D mvs_dev_found,
> - =A0 =A0 =A0 .lldd_dev_gone =A0=3D mvs_dev_gone,
> -
> + =A0 =A0 =A0 .lldd_dev_gone =A0 =A0 =A0 =A0 =A0=3D mvs_dev_gone,
> =A0 =A0 =A0 =A0.lldd_execute_task =A0 =A0 =A0=3D mvs_queue_command,
> =A0 =A0 =A0 =A0.lldd_control_phy =A0 =A0 =A0 =3D mvs_phy_control,
>
> =A0 =A0 =A0 =A0.lldd_abort_task =A0 =A0 =A0 =A0=3D mvs_abort_task,
> =A0 =A0 =A0 =A0.lldd_abort_task_set =A0 =A0=3D mvs_abort_task_set,
> =A0 =A0 =A0 =A0.lldd_clear_aca =A0 =A0 =A0 =A0 =3D mvs_clear_aca,
> - =A0 =A0 =A0 .lldd_clear_task_set =A0 =A0=3D mvs_clear_task_set,
> + =A0 =A0 =A0 .lldd_clear_task_set =A0 =A0=3D mvs_clear_task_set,
> =A0 =A0 =A0 =A0.lldd_I_T_nexus_reset =A0 =3D mvs_I_T_nexus_reset,
> =A0 =A0 =A0 =A0.lldd_lu_reset =A0 =A0 =A0 =A0 =A0=3D mvs_lu_reset,
> =A0 =A0 =A0 =A0.lldd_query_task =A0 =A0 =A0 =A0=3D mvs_query_task,
> -
> =A0 =A0 =A0 =A0.lldd_port_formed =A0 =A0 =A0 =3D mvs_port_formed,
> =A0 =A0 =A0 =A0.lldd_port_deformed =A0 =A0 =3D mvs_port_deformed,
>
> @@ -213,7 +212,11 @@ static irqreturn_t mvs_interrupt(int irq, void *opaq=
ue)
>
> =A0static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host =
*shost)
> =A0{
> - =A0 =A0 =A0 int i, slot_nr;
> + =A0 =A0 =A0 int i =3D 0, j =3D 0, slot_nr;
> + =A0 =A0 =A0 unsigned long buf_size;
> + =A0 =A0void *buf;
> + =A0 =A0dma_addr_t buf_dma;
> + =A0 =A0struct mvs_slot_info *slot =3D 0;
>
> =A0 =A0 =A0 =A0if (mvi->flags & MVF_FLAG_SOC)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0slot_nr =3D MVS_SOC_SLOTS;
> @@ -232,6 +235,7 @@ static int __devinit mvs_alloc(struct mvs_info *mvi, =
struct Scsi_Host *shost)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi->devices[i].dev_type =3D NO_DEVICE;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi->devices[i].device_id =3D i;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi->devices[i].dev_status =3D MVS_DEV_NOR=
MAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 init_timer(&mvi->devices[i].timer);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/*
> @@ -437,6 +441,7 @@ static int __devinit mvs_prep_sas_ha_init(struct Scsi=
_Host *shost,
>
> =A0 =A0 =A0 =A0sha->sas_phy =3D arr_phy;
> =A0 =A0 =A0 =A0sha->sas_port =3D arr_port;
> + =A0 =A0 =A0 sha->core.shost =3D shost;
>
> =A0 =A0 =A0 =A0sha->lldd_ha =3D kzalloc(sizeof(struct mvs_prv_info), GFP_=
KERNEL);
> =A0 =A0 =A0 =A0if (!sha->lldd_ha)
> @@ -574,6 +579,10 @@ static int __devinit mvs_pci_init(struct pci_dev *pd=
ev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nhost++;
> =A0 =A0 =A0 =A0} while (nhost < chip->n_host);
> +#ifdef MVS_USE_TASKLET
> + =A0 =A0 =A0 tasklet_init(&mv_tasklet, mvs_tasklet,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long)SHOST_TO_SAS_HA(s=
host));
> +#endif
>
> =A0 =A0 =A0 =A0mvs_post_sas_ha_init(shost, chip);
>
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index 0d21386..4be7010 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -259,8 +259,6 @@ static inline void mvs_free_reg_set(struct mvs_info *=
mvi,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_printk("device has been free.\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 if (dev->runing_req !=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> =A0 =A0 =A0 =A0if (dev->taskfileset =3D=3D MVS_ID_NOT_MAPPED)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0MVS_CHIP_DISP->free_reg_set(mvi, &dev->taskfileset);
> @@ -597,7 +595,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
> =A0 =A0 =A0 =A0struct mvs_slot_info *slot;
> =A0 =A0 =A0 =A0void *buf_prd;
> =A0 =A0 =A0 =A0u32 tag =3D tei->tag, hdr_tag;
> - =A0 =A0 =A0 u32 flags, del_q;
> + =A0 =A0 =A0 u32 flags, del_q, phy_mask;
> =A0 =A0 =A0 =A0void *buf_tmp;
> =A0 =A0 =A0 =A0u8 *buf_cmd, *buf_oaf;
> =A0 =A0 =A0 =A0dma_addr_t buf_tmp_dma;
> @@ -762,8 +760,6 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0if (is_tmf)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags |=3D (MCH_SSP_FR_TASK << MCH_SSP_FR_=
TYPE_SHIFT);
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D (MCH_SSP_FR_CMD << MCH_SSP_FR_TY=
PE_SHIFT);
> =A0 =A0 =A0 =A0hdr->flags =3D cpu_to_le32(flags | (tei->n_elem << MCH_PRD=
_LEN_SHIFT));
> =A0 =A0 =A0 =A0hdr->tags =3D cpu_to_le32(tag);
> =A0 =A0 =A0 =A0hdr->data_len =3D cpu_to_le32(task->total_xfer_len);
> @@ -878,14 +874,15 @@ static int mvs_task_exec(struct sas_task *task, con=
st int num, gfp_t gfp_flags,
> =A0 =A0 =A0 =A0struct mvs_slot_info *slot;
> =A0 =A0 =A0 =A0u32 tag =3D 0xdeadbeef, rc, n_elem =3D 0;
> =A0 =A0 =A0 =A0u32 n =3D num, pass =3D 0;
> - =A0 =A0 =A0 unsigned long flags =3D 0;
> + =A0 =A0 =A0 unsigned long flags =3D 0, =A0flags_libsas =3D 0;
>
> =A0 =A0 =A0 =A0if (!dev->port) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct task_status_struct *tsm =3D &t->tas=
k_status;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tsm->resp =3D SAS_TASK_UNDELIVERED;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tsm->stat =3D SAS_PHY_DOWN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->task_done(t);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev->dev_type !=3D SATA_DEV)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->task_done(t);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
>
> @@ -910,12 +907,24 @@ static int mvs_task_exec(struct sas_task *task, con=
st int num, gfp_t gfp_flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tei.port =3D &mvi->port[de=
v->port->id];
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!tei.port->port_attached) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tei.port && !tei.port->port_attached) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sas_protocol_ata(t->ta=
sk_proto)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_dprintk=
("port %d does not"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0"attached device.\n", dev->port->id);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SAS_=
PHY_DOWN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_do=
ne;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct task=
_status_struct *ts =3D &t->task_status;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ts->stat =
=3D SAS_PROTO_RESPONSE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ts->stat =
=3D SAS_PHY_DOWN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock=
_irqrestore(dev->sata_dev.ap->lock,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags_libsas);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock=
_irqrestore(&mvi->lock, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->task_don=
e(t);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_i=
rqsave(&mvi->lock, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_i=
rqsave(dev->sata_dev.ap->lock,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 flags_libsas);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (n > 1)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 t =3D list_entry(t->list.next,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct sas_task, list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct tas=
k_status_struct *ts =3D &t->task_status;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ts->resp =
=3D SAS_TASK_UNDELIVERED;
> @@ -973,8 +982,8 @@ static int mvs_task_exec(struct sas_task *task, const=
 int num, gfp_t gfp_flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_printk(KERN_ERR, mvi->=
dev,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "unknown sa=
s_task proto: 0x%x\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->task_pro=
to);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"unk=
nown sas_task proto: 0x%x\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0t->t=
ask_proto);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EINVAL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -993,11 +1002,15 @@ static int mvs_task_exec(struct sas_task *task, co=
nst int num, gfp_t gfp_flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&t->task_state_lock);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_hba_memory_dump(mvi, tag, t->task_prot=
o);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->runing_req++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->running_req++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0++pass;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi->tx_prod =3D (mvi->tx_prod + 1) & (MVS=
_CHIP_SLOT_SZ - 1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (n > 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0t =3D list_entry(t->list.n=
ext, struct sas_task, list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(pass))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_DISP->start_delive=
ry(mvi, (mvi->tx_prod - 1) &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (MVS_CHIP_SLOT_SZ - 1));
> +
> =A0 =A0 =A0 =A0} while (--n);
> =A0 =A0 =A0 =A0rc =3D 0;
> =A0 =A0 =A0 =A0goto out_done;
> @@ -1012,10 +1025,6 @@ err_out:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dma_unmap_sg(mvi->dev, t->=
scatter, n_elem,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t=
->data_dir);
> =A0out_done:
> - =A0 =A0 =A0 if (likely(pass)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_DISP->start_delivery(mvi,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (mvi->tx_prod - 1) & (MVS_C=
HIP_SLOT_SZ - 1));
> - =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&mvi->lock, flags);
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -1187,7 +1196,7 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i=
, int get_st)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MVS_CHIP_D=
ISP->phy_reset(mvi, i, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_d=
one;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (phy-=
>phy_type & PORT_TYPE_SAS
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } =A0 =A0 =A0 else if (phy->phy_type & PORT=
_TYPE_SAS
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|| phy->att_dev_info & POR=
T_SSP_INIT_MASK) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy->phy_attached =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy->identify.device_type =
=3D
> @@ -1256,7 +1265,20 @@ static void mvs_port_notify_formed(struct asd_sas_=
phy *sas_phy, int lock)
>
> =A0static void mvs_port_notify_deformed(struct asd_sas_phy *sas_phy, int =
lock)
> =A0{
> - =A0 =A0 =A0 /*Nothing*/
> + =A0 =A0 =A0 struct domain_device *dev;
> + =A0 =A0 =A0 struct mvs_phy *phy =3D sas_phy->lldd_phy;
> + =A0 =A0 =A0 struct mvs_info *mvi =3D phy->mvi;
> + =A0 =A0 =A0 struct asd_sas_port *port =3D sas_phy->port;
> + =A0 =A0 =A0 int phy_no =3D 0;
> +
> + =A0 =A0 =A0 while (phy !=3D &mvi->phy[phy_no]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy_no++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phy_no >=3D MVS_MAX_PHYS)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 list_for_each_entry(dev, &port->dev_list, dev_list_node)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_do_release_task(phy->mvi, phy_no, NULL)=
;
> +
> =A0}
>
>
> @@ -1316,6 +1338,7 @@ int mvs_dev_found_notify(struct domain_device *dev,=
 int lock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto found_out;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0dev->lldd_dev =3D mvi_device;
> + =A0 =A0 =A0 mvi_device->dev_status =3D MVS_DEV_NORMAL;
> =A0 =A0 =A0 =A0mvi_device->dev_type =3D dev->dev_type;
> =A0 =A0 =A0 =A0mvi_device->mvi_info =3D mvi;
> =A0 =A0 =A0 =A0if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type)) {
> @@ -1351,18 +1374,18 @@ int mvs_dev_found(struct domain_device *dev)
> =A0 =A0 =A0 =A0return mvs_dev_found_notify(dev, 1);
> =A0}
>
> -void mvs_dev_gone_notify(struct domain_device *dev, int lock)
> +void mvs_dev_gone_notify(struct domain_device *dev)
> =A0{
> =A0 =A0 =A0 =A0unsigned long flags =3D 0;
> =A0 =A0 =A0 =A0struct mvs_device *mvi_dev =3D dev->lldd_dev;
> =A0 =A0 =A0 =A0struct mvs_info *mvi =3D mvi_dev->mvi_info;
>
> - =A0 =A0 =A0 if (lock)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&mvi->lock, flags);
> + =A0 =A0 =A0 spin_lock_irqsave(&mvi->lock, flags);
>
> =A0 =A0 =A0 =A0if (mvi_dev) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_dprintk("found dev[%d:%x] is gone.\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi_dev->device_id, mvi_de=
v->dev_type);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_release_task(mvi, dev);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_free_reg_set(mvi, mvi_dev);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_free_dev(mvi_dev);
> =A0 =A0 =A0 =A0} else {
> @@ -1370,14 +1393,13 @@ void mvs_dev_gone_notify(struct domain_device *de=
v, int lock)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0dev->lldd_dev =3D NULL;
>
> - =A0 =A0 =A0 if (lock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&mvi->lock, flags);
> =A0}
>
>
> =A0void mvs_dev_gone(struct domain_device *dev)
> =A0{
> - =A0 =A0 =A0 mvs_dev_gone_notify(dev, 1);
> + =A0 =A0 =A0 mvs_dev_gone_notify(dev);
> =A0}
>
> =A0static =A0struct sas_task *mvs_alloc_task(void)
> @@ -1540,7 +1562,7 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun=
)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num =3D mvs_find_dev_phyno(dev, phyno);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock_irqsave(&mvi->lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i < num; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_release_task(mvi, phyno=
[i], dev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_release_task(mvi, dev);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&mvi->lock, flags);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0/* If failed, fall-through I_T_Nexus reset */
> @@ -1552,8 +1574,8 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun=
)
> =A0int mvs_I_T_nexus_reset(struct domain_device *dev)
> =A0{
> =A0 =A0 =A0 =A0unsigned long flags;
> - =A0 =A0 =A0 int i, phyno[WIDE_PORT_MAX_PHY], num , rc =3D TMF_RESP_FUNC=
_FAILED;
> - =A0 =A0 =A0 struct mvs_device * mvi_dev =3D (struct mvs_device *)dev->l=
ldd_dev;
> + =A0 =A0 =A0 int rc =3D TMF_RESP_FUNC_FAILED;
> + =A0 =A0struct mvs_device * mvi_dev =3D (struct mvs_device *)dev->lldd_d=
ev;
> =A0 =A0 =A0 =A0struct mvs_info *mvi =3D mvi_dev->mvi_info;
>
> =A0 =A0 =A0 =A0if (mvi_dev->dev_status !=3D MVS_DEV_EH)
> @@ -1563,10 +1585,8 @@ int mvs_I_T_nexus_reset(struct domain_device *dev)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, mvi_dev->device_id, rc);
>
> =A0 =A0 =A0 =A0/* housekeeper */
> - =A0 =A0 =A0 num =3D mvs_find_dev_phyno(dev, phyno);
> =A0 =A0 =A0 =A0spin_lock_irqsave(&mvi->lock, flags);
> - =A0 =A0 =A0 for (i =3D 0; i < num; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_release_task(mvi, phyno[i], dev);
> + =A0 =A0 =A0 mvs_release_task(mvi, dev);
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&mvi->lock, flags);
>
> =A0 =A0 =A0 =A0return rc;
> @@ -1603,6 +1623,9 @@ int mvs_query_task(struct sas_task *task)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case TMF_RESP_FUNC_FAILED:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case TMF_RESP_FUNC_COMPLETE:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D TMF_RESP_FUNC_COMPLE=
TE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0mv_printk("%s:rc=3D %d\n", __func__, rc);
> @@ -1621,8 +1644,11 @@ int mvs_abort_task(struct sas_task *task)
> =A0 =A0 =A0 =A0unsigned long flags;
> =A0 =A0 =A0 =A0u32 tag;
>
> - =A0 =A0 =A0 if (mvi->exp_req)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi->exp_req--;
> + =A0 =A0 =A0 if (!mvi_dev) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_printk("%s:%d TMF_RESP_FUNC_FAILED\n", _=
_func__, __LINE__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D TMF_RESP_FUNC_FAILED;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0spin_lock_irqsave(&task->task_state_lock, flags);
> =A0 =A0 =A0 =A0if (task->task_state_flags & SAS_TASK_STATE_DONE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&task->task_state_l=
ock, flags);
> @@ -1630,6 +1656,7 @@ int mvs_abort_task(struct sas_task *task)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&task->task_state_lock, flags);
> + =A0 =A0 =A0 mvi_dev->dev_status =3D MVS_DEV_EH;
> =A0 =A0 =A0 =A0if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP=
) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct scsi_cmnd * cmnd =3D (struct scsi_c=
mnd *)task->uldd_task;
>
> @@ -1654,12 +1681,31 @@ int mvs_abort_task(struct sas_task *task)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (task->lldd_task) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0slot =3D t=
ask->lldd_task;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0slot_no =
=3D (u32) (slot - mvi->slot_info);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_i=
rqsave(&mvi->lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_slot_c=
omplete(mvi, slot_no, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock=
_irqrestore(&mvi->lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> +
> =A0 =A0 =A0 =A0} else if (task->task_proto & SAS_PROTOCOL_SATA ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0task->task_proto & SAS_PROTOCOL_STP) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* to do free register_set */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (SATA_DEV =3D=3D dev->dev_type) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mvs_slot_info *slot =
=3D task->lldd_task;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct task_status_struct *=
tstat;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 slot_idx =3D (u32)(slot=
 - mvi->slot_info);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tstat =3D &task->task_statu=
s;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_dprintk(KERN_DEBUG "mv_a=
bort_task() mvi=3D%p task=3D%p "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"slo=
t=3D%p slot_idx=3Dx%x\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi,=
 task, slot, slot_idx);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tstat->stat =3D SAS_ABORTED=
_TASK;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mvi_dev && mvi_dev->run=
ning_req)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->ru=
nning_req--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sas_protocol_ata(task->=
task_proto))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_free_re=
g_set(mvi, mvi_dev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_slot_task_free(mvi, tas=
k, slot, slot_idx);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* SMP */
>
> @@ -1717,8 +1763,13 @@ static int mvs_sata_done(struct mvs_info *mvi, str=
uct sas_task *task,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 SATA_RECEIVED_D2H_FIS(mvi_dev->taskfileset),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct dev_to_host_fis));
> =A0 =A0 =A0 =A0tstat->buf_valid_size =3D sizeof(*resp);
> - =A0 =A0 =A0 if (unlikely(err))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat =3D SAS_PROTO_RESPONSE;
> + =A0 =A0 =A0 if (unlikely(err)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(err & CMD_ISS_STPD))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat =3D SAS_OPEN_REJECT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat =3D SAS_PROTO_RESPONSE=
;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0return stat;
> =A0}
>
> @@ -1728,6 +1779,7 @@ static int mvs_slot_err(struct mvs_info *mvi, struc=
t sas_task *task,
> =A0 =A0 =A0 =A0struct mvs_slot_info *slot =3D &mvi->slot_info[slot_idx];
> =A0 =A0 =A0 =A0int stat;
> =A0 =A0 =A0 =A0u32 err_dw0 =3D le32_to_cpu(*(u32 *) (slot->response));
> + =A0 =A0 =A0 u32 err_dw1 =3D le32_to_cpu(*((u32 *)slot->response+1));
> =A0 =A0 =A0 =A0u32 tfs =3D 0;
> =A0 =A0 =A0 =A0enum mvs_port_type type =3D PORT_TYPE_SAS;
>
> @@ -1753,9 +1805,7 @@ static int mvs_slot_err(struct mvs_info *mvi, struc=
t sas_task *task,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_printk("find reserved e=
rror, why?\n");
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0task->ata_task.use_ncq =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat =3D SAS_PROTO_RESPONSE;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_sata_done(mvi, task, slot_idx, 1);
> -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_sata_done(mvi, task, slot_idx, err_dw0)=
;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0default:
> @@ -1772,18 +1822,20 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 r=
x_desc, u32 flags)
> =A0 =A0 =A0 =A0struct sas_task *task =3D slot->task;
> =A0 =A0 =A0 =A0struct mvs_device *mvi_dev =3D NULL;
> =A0 =A0 =A0 =A0struct task_status_struct *tstat;
> + =A0 =A0 =A0 struct domain_device *dev;
> + =A0 =A0 =A0 u32 aborted;
>
> - =A0 =A0 =A0 bool aborted;
> =A0 =A0 =A0 =A0void *to;
> =A0 =A0 =A0 =A0enum exec_status sts;
>
> =A0 =A0 =A0 =A0if (mvi->exp_req)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi->exp_req--;
> - =A0 =A0 =A0 if (unlikely(!task || !task->lldd_task))
> + =A0 =A0 =A0 if (unlikely(!task || !task->lldd_task || !task->dev))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
>
> =A0 =A0 =A0 =A0tstat =3D &task->task_status;
> - =A0 =A0 =A0 mvi_dev =3D task->dev->lldd_dev;
> + =A0 =A0 =A0 dev =3D task->dev;
> + =A0 =A0 =A0 mvi_dev =3D dev->lldd_dev;
>
> =A0 =A0 =A0 =A0mvs_hba_cq_dump(mvi);
>
> @@ -1800,8 +1852,8 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_=
desc, u32 flags)
>
> =A0 =A0 =A0 =A0if (unlikely(aborted)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tstat->stat =3D SAS_ABORTED_TASK;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mvi_dev)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->runing_req--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mvi_dev && mvi_dev->running_req)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->running_req--;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sas_protocol_ata(task->task_proto))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_free_reg_set(mvi, mvi_=
dev);
>
> @@ -1809,24 +1861,17 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 r=
x_desc, u32 flags)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if (unlikely(!mvi_dev || !slot->port->port_attached || flag=
s)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_dprintk("port has not device.\n");
> + =A0 =A0 =A0 if (unlikely(!mvi_dev || flags)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!mvi_dev)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_dprintk("port has not de=
vice.\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tstat->stat =3D SAS_PHY_DOWN;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 if (unlikely((rx_desc & RXQ_ERR) || (*(u64 *) slot->respons=
e))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_dprintk("Find device[%016llx] RXQ_ERR=
 %X,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err info:%016llx\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SAS_ADDR(task->dev->sas_addr),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rx_desc, (u64)(*(u64 *) slot->response))=
;
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 */
> -
> =A0 =A0 =A0 =A0/* error info record present */
> =A0 =A0 =A0 =A0if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->respon=
se))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tstat->stat =3D mvs_slot_err(mvi, task, sl=
ot_idx);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tstat->resp =3D SAS_TASK_COMPLETE;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> @@ -1868,11 +1913,16 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 r=
x_desc, u32 flags)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tstat->stat =3D SAM_CHECK_COND;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 if (!slot->port->port_attached) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_dprintk("port %d has removed.\n", slot->=
port->sas_port.id);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tstat->stat =3D SAS_PHY_DOWN;
> + =A0 =A0 =A0 }
> +
>
> =A0out:
> - =A0 =A0 =A0 if (mvi_dev) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->runing_req--;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sas_protocol_ata(task->task_proto))
> + =A0 =A0 =A0 if (mvi_dev && mvi_dev->running_req) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->running_req--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sas_protocol_ata(task->task_proto) && !=
mvi_dev->running_req)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_free_reg_set(mvi, mvi_=
dev);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0mvs_slot_task_free(mvi, task, slot, slot_idx);
> @@ -1888,10 +1938,10 @@ out:
> =A0 =A0 =A0 =A0return sts;
> =A0}
>
> -void mvs_release_task(struct mvs_info *mvi,
> +void mvs_do_release_task(struct mvs_info *mvi,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int phy_no, struct domain_device *dev)
> =A0{
> - =A0 =A0 =A0 int i =3D 0; u32 slot_idx;
> + =A0 =A0 =A0 u32 slot_idx;
> =A0 =A0 =A0 =A0struct mvs_phy *phy;
> =A0 =A0 =A0 =A0struct mvs_port *port;
> =A0 =A0 =A0 =A0struct mvs_slot_info *slot, *slot2;
> @@ -1900,6 +1950,10 @@ void mvs_release_task(struct mvs_info *mvi,
> =A0 =A0 =A0 =A0port =3D phy->port;
> =A0 =A0 =A0 =A0if (!port)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> + =A0 =A0 =A0 /* clean cmpl queue in case request is already finished */
> + =A0 =A0 =A0 mvs_int_rx(mvi, false);
> +
> +
>
> =A0 =A0 =A0 =A0list_for_each_entry_safe(slot, slot2, &port->list, entry) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct sas_task *task;
> @@ -1911,18 +1965,22 @@ void mvs_release_task(struct mvs_info *mvi,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_printk("Release slot [%x] tag[%x], task=
 [%p]:\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0slot_idx, slot->slot_tag, =
task);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (task->task_proto & SAS_PROTOCOL_SSP) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_printk("attached with SS=
P task CDB[");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < 16; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_printk("=
 %02x", task->ssp_task.cdb[i]);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_printk(" ]\n");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_DISP->command_active(mvi, slot_idx=
);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_slot_complete(mvi, slot_idx, 1);
> =A0 =A0 =A0 =A0}
> =A0}
>
> +void mvs_release_task(struct mvs_info *mvi,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct domain_device *dev)
> +{
> + =A0 =A0 =A0 int i, phyno[WIDE_PORT_MAX_PHY], num;
> + =A0 =A0 =A0 /* housekeeper */
> + =A0 =A0 =A0 num =3D mvs_find_dev_phyno(dev, phyno);
> + =A0 =A0 =A0 for (i =3D 0; i < num; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_do_release_task(mvi, phyno[i], dev);
> +}
> +
> =A0static void mvs_phy_disconnected(struct mvs_phy *phy)
> =A0{
> =A0 =A0 =A0 =A0phy->phy_attached =3D 0;
> @@ -2029,16 +2087,18 @@ void mvs_int_port(struct mvs_info *mvi, int phy_n=
o, u32 events)
> =A0 =A0 =A0 =A0* we need check the interrupt status which belongs to per =
port.
> =A0 =A0 =A0 =A0*/
>
> - =A0 =A0 =A0 if (phy->irq_status & PHYEV_DCDR_ERR)
> + =A0 =A0 =A0 if (phy->irq_status & PHYEV_DCDR_ERR) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_dprintk("port %d STP decoding error.\n"=
,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy_no+mvi->id*mvi->chip->n_phy);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy_no + mvi->id*mvi->chip->n_phy);
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0if (phy->irq_status & PHYEV_POOF) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!(phy->phy_event & PHY_PLUG_OUT)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int dev_sata =3D phy->phy_=
type & PORT_TYPE_SATA;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int ready;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_release_task(mvi, phy_n=
o, NULL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_do_release_task(mvi, ph=
y_no, NULL);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy->phy_event |=3D PHY_PL=
UG_OUT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_DISP->clear_srs_ir=
q(mvi, 0, 1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_handle_event(mvi,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(void *)(u=
nsigned long)phy_no,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PHY_PLUG_E=
VENT);
> @@ -2085,6 +2145,11 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no=
, u32 events)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy_no, tmp);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_update_phyinfo(mvi, ph=
y_no, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phy->phy_type & PORT_TY=
PE_SAS) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_DI=
SP->phy_reset(mvi, phy_no, 2);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdelay(100)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_bytes_dmaed(mvi, phy_n=
o);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* whether driver is going=
 to handle hot plug */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (phy->phy_event & PHY_P=
LUG_OUT) {
> diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
> index aa2270a..85b79c7 100644
> --- a/drivers/scsi/mvsas/mv_sas.h
> +++ b/drivers/scsi/mvsas/mv_sas.h
> @@ -38,6 +38,7 @@
> =A0#include <linux/irq.h>
> =A0#include <linux/vmalloc.h>
> =A0#include <scsi/libsas.h>
> +#include <scsi/scsi.h>
> =A0#include <scsi/scsi_tcq.h>
> =A0#include <scsi/sas_ata.h>
> =A0#include <linux/version.h>
> @@ -48,7 +49,7 @@
> =A0#define _MV_DUMP =A0 =A0 =A0 =A0 =A0 =A0 =A0 0
> =A0#define MVS_ID_NOT_MAPPED =A0 =A0 =A00x7f
> =A0/* #define DISABLE_HOTPLUG_DMA_FIX */
> -#define MAX_EXP_RUNNING_REQ =A0 =A02
> +// #define MAX_EXP_RUNNING_REQ 2
> =A0#define WIDE_PORT_MAX_PHY =A0 =A0 =A0 =A0 =A0 =A0 =A04
> =A0#define =A0 =A0 =A0 =A0MV_DISABLE_NCQ =A00
> =A0#define mv_printk(fmt, arg ...) =A0 =A0 =A0 =A0\
> @@ -128,6 +129,7 @@ struct mvs_dispatch {
>
> =A0 =A0 =A0 =A0void (*get_sas_addr)(void *buf, u32 buflen);
> =A0 =A0 =A0 =A0void (*command_active)(struct mvs_info *mvi, u32 slot_idx)=
;
> + =A0 =A0 =A0 void (*clear_srs_irq)(struct mvs_info *mvi, u8 reg_set, u8 =
clear_all);
> =A0 =A0 =A0 =A0void (*issue_stop)(struct mvs_info *mvi, enum mvs_port_typ=
e type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u32 tfs);
> =A0 =A0 =A0 =A0void (*start_delivery)(struct mvs_info *mvi, u32 tx);
> @@ -235,9 +237,10 @@ struct mvs_device {
> =A0 =A0 =A0 =A0enum sas_dev_type dev_type;
> =A0 =A0 =A0 =A0struct mvs_info *mvi_info;
> =A0 =A0 =A0 =A0struct domain_device *sas_device;
> + =A0 =A0 =A0 struct timer_list timer;
> =A0 =A0 =A0 =A0u32 attached_phy;
> =A0 =A0 =A0 =A0u32 device_id;
> - =A0 =A0 =A0 u32 runing_req;
> + =A0 =A0 =A0 u32 running_req;
> =A0 =A0 =A0 =A0u8 taskfileset;
> =A0 =A0 =A0 =A0u8 dev_status;
> =A0 =A0 =A0 =A0u16 reserved;
> @@ -396,7 +399,9 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun);
> =A0int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags);
> =A0int mvs_I_T_nexus_reset(struct domain_device *dev);
> =A0int mvs_query_task(struct sas_task *task);
> -void mvs_release_task(struct mvs_info *mvi, int phy_no,
> +void mvs_release_task(struct mvs_info *mvi,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct domain_device *dev);
> +void mvs_do_release_task(struct mvs_info *mvi, int phy_no,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct domain_device *dev)=
;
> =A0void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events);
> =A0void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
>
>
>
> DISCLAIMER:
> -------------------------------------------------------------------------=
----------------------------------------------
>
> The contents of this e-mail and any attachment(s) are confidential and in=
tended for the named recipient(s) only.
> It shall not attach any liability on the originator or HCL or its affilia=
tes. Any views or opinions presented in
> this email are solely those of the author and may not necessarily reflect=
 the opinions of HCL or its affiliates.
> Any form of reproduction, dissemination, copying, disclosure, modificatio=
n, distribution and / or publication of
> this message without the prior written consent of the author of this e-ma=
il is strictly prohibited. If you have
> received this email in error please delete it and notify the sender immed=
iately. Before opening any mail and
> attachments please check them for viruses and defect.
>
> -------------------------------------------------------------------------=
----------------------------------------------
>

--0016e6d63fb43edcc7048a29ca3a
Content-Type: application/octet-stream; name=".config"
Content-Disposition: attachment; filename=".config"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gb0odhp12

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMgTGlu
dXgga2VybmVsIHZlcnNpb246IDIuNi4zMi43CiMgRnJpIEp1biAyNSAxMzozMDoyOCAyMDEwCiMK
Q09ORklHXzY0QklUPXkKIyBDT05GSUdfWDg2XzMyIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl82ND15
CkNPTkZJR19YODY9eQpDT05GSUdfT1VUUFVUX0ZPUk1BVD0iZWxmNjQteDg2LTY0IgpDT05GSUdf
QVJDSF9ERUZDT05GSUc9ImFyY2gveDg2L2NvbmZpZ3MveDg2XzY0X2RlZmNvbmZpZyIKQ09ORklH
X0dFTkVSSUNfVElNRT15CkNPTkZJR19HRU5FUklDX0NNT1NfVVBEQVRFPXkKQ09ORklHX0NMT0NL
U09VUkNFX1dBVENIRE9HPXkKQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFM9eQpDT05GSUdfR0VO
RVJJQ19DTE9DS0VWRU5UU19CUk9BRENBU1Q9eQpDT05GSUdfTE9DS0RFUF9TVVBQT1JUPXkKQ09O
RklHX1NUQUNLVFJBQ0VfU1VQUE9SVD15CkNPTkZJR19IQVZFX0xBVEVOQ1lUT1BfU1VQUE9SVD15
CkNPTkZJR19NTVU9eQpDT05GSUdfWk9ORV9ETUE9eQpDT05GSUdfR0VORVJJQ19JU0FfRE1BPXkK
Q09ORklHX0dFTkVSSUNfSU9NQVA9eQpDT05GSUdfR0VORVJJQ19CVUc9eQpDT05GSUdfR0VORVJJ
Q19CVUdfUkVMQVRJVkVfUE9JTlRFUlM9eQpDT05GSUdfR0VORVJJQ19IV0VJR0hUPXkKQ09ORklH
X0FSQ0hfTUFZX0hBVkVfUENfRkRDPXkKQ09ORklHX1JXU0VNX0dFTkVSSUNfU1BJTkxPQ0s9eQoj
IENPTkZJR19SV1NFTV9YQ0hHQUREX0FMR09SSVRITSBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX0hB
U19DUFVfSURMRV9XQUlUPXkKQ09ORklHX0dFTkVSSUNfQ0FMSUJSQVRFX0RFTEFZPXkKQ09ORklH
X0dFTkVSSUNfVElNRV9WU1lTQ0FMTD15CkNPTkZJR19BUkNIX0hBU19DUFVfUkVMQVg9eQpDT05G
SUdfQVJDSF9IQVNfREVGQVVMVF9JRExFPXkKQ09ORklHX0FSQ0hfSEFTX0NBQ0hFX0xJTkVfU0la
RT15CkNPTkZJR19IQVZFX1NFVFVQX1BFUl9DUFVfQVJFQT15CkNPTkZJR19ORUVEX1BFUl9DUFVf
RU1CRURfRklSU1RfQ0hVTks9eQpDT05GSUdfTkVFRF9QRVJfQ1BVX1BBR0VfRklSU1RfQ0hVTks9
eQpDT05GSUdfSEFWRV9DUFVNQVNLX09GX0NQVV9NQVA9eQpDT05GSUdfQVJDSF9ISUJFUk5BVElP
Tl9QT1NTSUJMRT15CkNPTkZJR19BUkNIX1NVU1BFTkRfUE9TU0lCTEU9eQpDT05GSUdfWk9ORV9E
TUEzMj15CkNPTkZJR19BUkNIX1BPUFVMQVRFU19OT0RFX01BUD15CkNPTkZJR19BVURJVF9BUkNI
PXkKQ09ORklHX0FSQ0hfU1VQUE9SVFNfT1BUSU1JWkVEX0lOTElOSU5HPXkKQ09ORklHX0FSQ0hf
U1VQUE9SVFNfREVCVUdfUEFHRUFMTE9DPXkKQ09ORklHX0hBVkVfSU5URUxfVFhUPXkKQ09ORklH
X0dFTkVSSUNfSEFSRElSUVM9eQpDT05GSUdfR0VORVJJQ19IQVJESVJRU19OT19fRE9fSVJRPXkK
Q09ORklHX0dFTkVSSUNfSVJRX1BST0JFPXkKQ09ORklHX0dFTkVSSUNfUEVORElOR19JUlE9eQpD
T05GSUdfVVNFX0dFTkVSSUNfU01QX0hFTFBFUlM9eQpDT05GSUdfWDg2XzY0X1NNUD15CkNPTkZJ
R19YODZfSFQ9eQpDT05GSUdfWDg2X1RSQU1QT0xJTkU9eQojIENPTkZJR19LVElNRV9TQ0FMQVIg
aXMgbm90IHNldApDT05GSUdfREVGQ09ORklHX0xJU1Q9Ii9saWIvbW9kdWxlcy8kVU5BTUVfUkVM
RUFTRS8uY29uZmlnIgpDT05GSUdfQ09OU1RSVUNUT1JTPXkKCiMKIyBHZW5lcmFsIHNldHVwCiMK
Q09ORklHX0VYUEVSSU1FTlRBTD15CkNPTkZJR19MT0NLX0tFUk5FTD15CkNPTkZJR19JTklUX0VO
Vl9BUkdfTElNSVQ9MzIKQ09ORklHX0xPQ0FMVkVSU0lPTj0iIgojIENPTkZJR19MT0NBTFZFUlNJ
T05fQVVUTyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0tFUk5FTF9HWklQPXkKQ09ORklHX0hBVkVf
S0VSTkVMX0JaSVAyPXkKQ09ORklHX0hBVkVfS0VSTkVMX0xaTUE9eQpDT05GSUdfS0VSTkVMX0da
SVA9eQojIENPTkZJR19LRVJORUxfQlpJUDIgaXMgbm90IHNldAojIENPTkZJR19LRVJORUxfTFpN
QSBpcyBub3Qgc2V0CkNPTkZJR19TV0FQPXkKQ09ORklHX1NZU1ZJUEM9eQpDT05GSUdfU1lTVklQ
Q19TWVNDVEw9eQpDT05GSUdfUE9TSVhfTVFVRVVFPXkKQ09ORklHX1BPU0lYX01RVUVVRV9TWVND
VEw9eQpDT05GSUdfQlNEX1BST0NFU1NfQUNDVD15CiMgQ09ORklHX0JTRF9QUk9DRVNTX0FDQ1Rf
VjMgaXMgbm90IHNldApDT05GSUdfVEFTS1NUQVRTPXkKQ09ORklHX1RBU0tfREVMQVlfQUNDVD15
CkNPTkZJR19UQVNLX1hBQ0NUPXkKQ09ORklHX1RBU0tfSU9fQUNDT1VOVElORz15CkNPTkZJR19B
VURJVD15CkNPTkZJR19BVURJVFNZU0NBTEw9eQpDT05GSUdfQVVESVRfVFJFRT15CgojCiMgUkNV
IFN1YnN5c3RlbQojCkNPTkZJR19UUkVFX1JDVT15CiMgQ09ORklHX1RSRUVfUFJFRU1QVF9SQ1Ug
aXMgbm90IHNldAojIENPTkZJR19SQ1VfVFJBQ0UgaXMgbm90IHNldApDT05GSUdfUkNVX0ZBTk9V
VD02NAojIENPTkZJR19SQ1VfRkFOT1VUX0VYQUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfVFJFRV9S
Q1VfVFJBQ0UgaXMgbm90IHNldAojIENPTkZJR19JS0NPTkZJRyBpcyBub3Qgc2V0CkNPTkZJR19M
T0dfQlVGX1NISUZUPTE3CkNPTkZJR19IQVZFX1VOU1RBQkxFX1NDSEVEX0NMT0NLPXkKQ09ORklH
X0dST1VQX1NDSEVEPXkKQ09ORklHX0ZBSVJfR1JPVVBfU0NIRUQ9eQpDT05GSUdfUlRfR1JPVVBf
U0NIRUQ9eQojIENPTkZJR19VU0VSX1NDSEVEIGlzIG5vdCBzZXQKQ09ORklHX0NHUk9VUF9TQ0hF
RD15CkNPTkZJR19DR1JPVVBTPXkKIyBDT05GSUdfQ0dST1VQX0RFQlVHIGlzIG5vdCBzZXQKQ09O
RklHX0NHUk9VUF9OUz15CkNPTkZJR19DR1JPVVBfRlJFRVpFUj15CkNPTkZJR19DR1JPVVBfREVW
SUNFPXkKQ09ORklHX0NQVVNFVFM9eQpDT05GSUdfUFJPQ19QSURfQ1BVU0VUPXkKQ09ORklHX0NH
Uk9VUF9DUFVBQ0NUPXkKQ09ORklHX1JFU09VUkNFX0NPVU5URVJTPXkKQ09ORklHX0NHUk9VUF9N
RU1fUkVTX0NUTFI9eQpDT05GSUdfQ0dST1VQX01FTV9SRVNfQ1RMUl9TV0FQPXkKQ09ORklHX01N
X09XTkVSPXkKIyBDT05GSUdfU1lTRlNfREVQUkVDQVRFRF9WMiBpcyBub3Qgc2V0CkNPTkZJR19S
RUxBWT15CkNPTkZJR19OQU1FU1BBQ0VTPXkKQ09ORklHX1VUU19OUz15CkNPTkZJR19JUENfTlM9
eQpDT05GSUdfVVNFUl9OUz15CkNPTkZJR19QSURfTlM9eQpDT05GSUdfTkVUX05TPXkKQ09ORklH
X0JMS19ERVZfSU5JVFJEPXkKQ09ORklHX0lOSVRSQU1GU19TT1VSQ0U9IiIKQ09ORklHX1JEX0da
SVA9eQpDT05GSUdfUkRfQlpJUDI9eQpDT05GSUdfUkRfTFpNQT15CkNPTkZJR19DQ19PUFRJTUla
RV9GT1JfU0laRT15CkNPTkZJR19TWVNDVEw9eQpDT05GSUdfQU5PTl9JTk9ERVM9eQojIENPTkZJ
R19FTUJFRERFRCBpcyBub3Qgc2V0CkNPTkZJR19VSUQxNj15CkNPTkZJR19TWVNDVExfU1lTQ0FM
TD15CkNPTkZJR19LQUxMU1lNUz15CkNPTkZJR19LQUxMU1lNU19BTEw9eQpDT05GSUdfS0FMTFNZ
TVNfRVhUUkFfUEFTUz15CkNPTkZJR19IT1RQTFVHPXkKQ09ORklHX1BSSU5USz15CkNPTkZJR19C
VUc9eQpDT05GSUdfRUxGX0NPUkU9eQpDT05GSUdfUENTUEtSX1BMQVRGT1JNPXkKQ09ORklHX0JB
U0VfRlVMTD15CkNPTkZJR19GVVRFWD15CkNPTkZJR19FUE9MTD15CkNPTkZJR19TSUdOQUxGRD15
CkNPTkZJR19USU1FUkZEPXkKQ09ORklHX0VWRU5URkQ9eQpDT05GSUdfU0hNRU09eQpDT05GSUdf
QUlPPXkKQ09ORklHX0hBVkVfUEVSRl9FVkVOVFM9eQoKIwojIEtlcm5lbCBQZXJmb3JtYW5jZSBF
dmVudHMgQW5kIENvdW50ZXJzCiMKQ09ORklHX1BFUkZfRVZFTlRTPXkKQ09ORklHX0VWRU5UX1BS
T0ZJTEU9eQpDT05GSUdfUEVSRl9DT1VOVEVSUz15CiMgQ09ORklHX0RFQlVHX1BFUkZfVVNFX1ZN
QUxMT0MgaXMgbm90IHNldApDT05GSUdfVk1fRVZFTlRfQ09VTlRFUlM9eQpDT05GSUdfUENJX1FV
SVJLUz15CkNPTkZJR19TTFVCX0RFQlVHPXkKIyBDT05GSUdfQ09NUEFUX0JSSyBpcyBub3Qgc2V0
CiMgQ09ORklHX1NMQUIgaXMgbm90IHNldApDT05GSUdfU0xVQj15CiMgQ09ORklHX1NMT0IgaXMg
bm90IHNldApDT05GSUdfUFJPRklMSU5HPXkKQ09ORklHX1RSQUNFUE9JTlRTPXkKQ09ORklHX09Q
Uk9GSUxFPW0KQ09ORklHX09QUk9GSUxFX0lCUz15CiMgQ09ORklHX09QUk9GSUxFX0VWRU5UX01V
TFRJUExFWCBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX09QUk9GSUxFPXkKQ09ORklHX0tQUk9CRVM9
eQpDT05GSUdfSEFWRV9FRkZJQ0lFTlRfVU5BTElHTkVEX0FDQ0VTUz15CkNPTkZJR19LUkVUUFJP
QkVTPXkKQ09ORklHX0hBVkVfSU9SRU1BUF9QUk9UPXkKQ09ORklHX0hBVkVfS1BST0JFUz15CkNP
TkZJR19IQVZFX0tSRVRQUk9CRVM9eQpDT05GSUdfSEFWRV9BUkNIX1RSQUNFSE9PSz15CkNPTkZJ
R19IQVZFX0RNQV9BVFRSUz15CkNPTkZJR19IQVZFX0RNQV9BUElfREVCVUc9eQoKIwojIEdDT1Yt
YmFzZWQga2VybmVsIHByb2ZpbGluZwojCiMgQ09ORklHX0dDT1ZfS0VSTkVMIGlzIG5vdCBzZXQK
Q09ORklHX1NMT1dfV09SSz15CiMgQ09ORklHX1NMT1dfV09SS19ERUJVRyBpcyBub3Qgc2V0CiMg
Q09ORklHX0hBVkVfR0VORVJJQ19ETUFfQ09IRVJFTlQgaXMgbm90IHNldApDT05GSUdfU0xBQklO
Rk89eQpDT05GSUdfUlRfTVVURVhFUz15CkNPTkZJR19CQVNFX1NNQUxMPTAKQ09ORklHX01PRFVM
RVM9eQojIENPTkZJR19NT0RVTEVfRk9SQ0VfTE9BRCBpcyBub3Qgc2V0CkNPTkZJR19NT0RVTEVf
VU5MT0FEPXkKIyBDT05GSUdfTU9EVUxFX0ZPUkNFX1VOTE9BRCBpcyBub3Qgc2V0CiMgQ09ORklH
X01PRFZFUlNJT05TIGlzIG5vdCBzZXQKQ09ORklHX01PRFVMRV9TUkNWRVJTSU9OX0FMTD15CkNP
TkZJR19TVE9QX01BQ0hJTkU9eQpDT05GSUdfQkxPQ0s9eQpDT05GSUdfQkxLX0RFVl9CU0c9eQpD
T05GSUdfQkxLX0RFVl9JTlRFR1JJVFk9eQpDT05GSUdfQkxPQ0tfQ09NUEFUPXkKCiMKIyBJTyBT
Y2hlZHVsZXJzCiMKQ09ORklHX0lPU0NIRURfTk9PUD15CkNPTkZJR19JT1NDSEVEX0FTPXkKQ09O
RklHX0lPU0NIRURfREVBRExJTkU9eQpDT05GSUdfSU9TQ0hFRF9DRlE9eQojIENPTkZJR19ERUZB
VUxUX0FTIGlzIG5vdCBzZXQKIyBDT05GSUdfREVGQVVMVF9ERUFETElORSBpcyBub3Qgc2V0CkNP
TkZJR19ERUZBVUxUX0NGUT15CiMgQ09ORklHX0RFRkFVTFRfTk9PUCBpcyBub3Qgc2V0CkNPTkZJ
R19ERUZBVUxUX0lPU0NIRUQ9ImNmcSIKQ09ORklHX1BSRUVNUFRfTk9USUZJRVJTPXkKQ09ORklH
X0ZSRUVaRVI9eQoKIwojIFByb2Nlc3NvciB0eXBlIGFuZCBmZWF0dXJlcwojCkNPTkZJR19USUNL
X09ORVNIT1Q9eQpDT05GSUdfTk9fSFo9eQpDT05GSUdfSElHSF9SRVNfVElNRVJTPXkKQ09ORklH
X0dFTkVSSUNfQ0xPQ0tFVkVOVFNfQlVJTEQ9eQpDT05GSUdfU01QPXkKQ09ORklHX1g4Nl9YMkFQ
SUM9eQpDT05GSUdfU1BBUlNFX0lSUT15CkNPTkZJR19OVU1BX0lSUV9ERVNDPXkKQ09ORklHX1g4
Nl9NUFBBUlNFPXkKQ09ORklHX1g4Nl9FWFRFTkRFRF9QTEFURk9STT15CiMgQ09ORklHX1g4Nl9W
U01QIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1VWIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9TVVBQ
T1JUU19NRU1PUllfRkFJTFVSRT15CkNPTkZJR19TQ0hFRF9PTUlUX0ZSQU1FX1BPSU5URVI9eQpD
T05GSUdfUEFSQVZJUlRfR1VFU1Q9eQpDT05GSUdfWEVOPXkKQ09ORklHX1hFTl9NQVhfRE9NQUlO
X01FTU9SWT0zMgpDT05GSUdfWEVOX1NBVkVfUkVTVE9SRT15CkNPTkZJR19YRU5fREVCVUdfRlM9
eQpDT05GSUdfS1ZNX0NMT0NLPXkKQ09ORklHX0tWTV9HVUVTVD15CkNPTkZJR19QQVJBVklSVD15
CiMgQ09ORklHX1BBUkFWSVJUX1NQSU5MT0NLUyBpcyBub3Qgc2V0CkNPTkZJR19QQVJBVklSVF9D
TE9DSz15CiMgQ09ORklHX1BBUkFWSVJUX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVNVEVT
VCBpcyBub3Qgc2V0CiMgQ09ORklHX00zODYgaXMgbm90IHNldAojIENPTkZJR19NNDg2IGlzIG5v
dCBzZXQKIyBDT05GSUdfTTU4NiBpcyBub3Qgc2V0CiMgQ09ORklHX001ODZUU0MgaXMgbm90IHNl
dAojIENPTkZJR19NNTg2TU1YIGlzIG5vdCBzZXQKIyBDT05GSUdfTTY4NiBpcyBub3Qgc2V0CiMg
Q09ORklHX01QRU5USVVNSUkgaXMgbm90IHNldAojIENPTkZJR19NUEVOVElVTUlJSSBpcyBub3Qg
c2V0CiMgQ09ORklHX01QRU5USVVNTSBpcyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVNNCBpcyBu
b3Qgc2V0CiMgQ09ORklHX01LNiBpcyBub3Qgc2V0CiMgQ09ORklHX01LNyBpcyBub3Qgc2V0CiMg
Q09ORklHX01LOCBpcyBub3Qgc2V0CiMgQ09ORklHX01DUlVTT0UgaXMgbm90IHNldAojIENPTkZJ
R19NRUZGSUNFT04gaXMgbm90IHNldAojIENPTkZJR19NV0lOQ0hJUEM2IGlzIG5vdCBzZXQKIyBD
T05GSUdfTVdJTkNISVAzRCBpcyBub3Qgc2V0CiMgQ09ORklHX01HRU9ERUdYMSBpcyBub3Qgc2V0
CiMgQ09ORklHX01HRU9ERV9MWCBpcyBub3Qgc2V0CiMgQ09ORklHX01DWVJJWElJSSBpcyBub3Qg
c2V0CiMgQ09ORklHX01WSUFDM18yIGlzIG5vdCBzZXQKIyBDT05GSUdfTVZJQUM3IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTVBTQyBpcyBub3Qgc2V0CiMgQ09ORklHX01DT1JFMiBpcyBub3Qgc2V0CiMg
Q09ORklHX01BVE9NIGlzIG5vdCBzZXQKQ09ORklHX0dFTkVSSUNfQ1BVPXkKQ09ORklHX1g4Nl9D
UFU9eQpDT05GSUdfWDg2X0wxX0NBQ0hFX0JZVEVTPTY0CkNPTkZJR19YODZfSU5URVJOT0RFX0NB
Q0hFX0JZVEVTPTY0CkNPTkZJR19YODZfQ01QWENIRz15CkNPTkZJR19YODZfTDFfQ0FDSEVfU0hJ
RlQ9NgpDT05GSUdfWDg2X1dQX1dPUktTX09LPXkKQ09ORklHX1g4Nl9UU0M9eQpDT05GSUdfWDg2
X0NNUFhDSEc2ND15CkNPTkZJR19YODZfQ01PVj15CkNPTkZJR19YODZfTUlOSU1VTV9DUFVfRkFN
SUxZPTY0CkNPTkZJR19YODZfREVCVUdDVExNU1I9eQpDT05GSUdfQ1BVX1NVUF9JTlRFTD15CkNP
TkZJR19DUFVfU1VQX0FNRD15CkNPTkZJR19DUFVfU1VQX0NFTlRBVVI9eQojIENPTkZJR19YODZf
RFMgaXMgbm90IHNldApDT05GSUdfSFBFVF9USU1FUj15CkNPTkZJR19IUEVUX0VNVUxBVEVfUlRD
PXkKQ09ORklHX0RNST15CkNPTkZJR19HQVJUX0lPTU1VPXkKQ09ORklHX0NBTEdBUllfSU9NTVU9
eQpDT05GSUdfQ0FMR0FSWV9JT01NVV9FTkFCTEVEX0JZX0RFRkFVTFQ9eQpDT05GSUdfQU1EX0lP
TU1VPXkKQ09ORklHX0FNRF9JT01NVV9TVEFUUz15CkNPTkZJR19TV0lPVExCPXkKQ09ORklHX0lP
TU1VX0hFTFBFUj15CkNPTkZJR19JT01NVV9BUEk9eQojIENPTkZJR19NQVhTTVAgaXMgbm90IHNl
dApDT05GSUdfTlJfQ1BVUz0yNTYKQ09ORklHX1NDSEVEX1NNVD15CkNPTkZJR19TQ0hFRF9NQz15
CiMgQ09ORklHX1BSRUVNUFRfTk9ORSBpcyBub3Qgc2V0CkNPTkZJR19QUkVFTVBUX1ZPTFVOVEFS
WT15CiMgQ09ORklHX1BSRUVNUFQgaXMgbm90IHNldApDT05GSUdfWDg2X0xPQ0FMX0FQSUM9eQpD
T05GSUdfWDg2X0lPX0FQSUM9eQpDT05GSUdfWDg2X1JFUk9VVEVfRk9SX0JST0tFTl9CT09UX0lS
UVM9eQpDT05GSUdfWDg2X01DRT15CkNPTkZJR19YODZfTUNFX0lOVEVMPXkKQ09ORklHX1g4Nl9N
Q0VfQU1EPXkKQ09ORklHX1g4Nl9NQ0VfVEhSRVNIT0xEPXkKIyBDT05GSUdfWDg2X01DRV9JTkpF
Q1QgaXMgbm90IHNldApDT05GSUdfWDg2X1RIRVJNQUxfVkVDVE9SPXkKQ09ORklHX0k4Sz1tCkNP
TkZJR19NSUNST0NPREU9bQpDT05GSUdfTUlDUk9DT0RFX0lOVEVMPXkKQ09ORklHX01JQ1JPQ09E
RV9BTUQ9eQpDT05GSUdfTUlDUk9DT0RFX09MRF9JTlRFUkZBQ0U9eQpDT05GSUdfWDg2X01TUj15
CkNPTkZJR19YODZfQ1BVSUQ9eQpDT05GSUdfWDg2X0NQVV9ERUJVRz1tCkNPTkZJR19BUkNIX1BI
WVNfQUREUl9UXzY0QklUPXkKQ09ORklHX0RJUkVDVF9HQlBBR0VTPXkKQ09ORklHX05VTUE9eQpD
T05GSUdfSzhfTlVNQT15CkNPTkZJR19YODZfNjRfQUNQSV9OVU1BPXkKQ09ORklHX05PREVTX1NQ
QU5fT1RIRVJfTk9ERVM9eQojIENPTkZJR19OVU1BX0VNVSBpcyBub3Qgc2V0CkNPTkZJR19OT0RF
U19TSElGVD05CkNPTkZJR19BUkNIX1BST0NfS0NPUkVfVEVYVD15CkNPTkZJR19BUkNIX1NQQVJT
RU1FTV9ERUZBVUxUPXkKQ09ORklHX0FSQ0hfU1BBUlNFTUVNX0VOQUJMRT15CkNPTkZJR19BUkNI
X1NFTEVDVF9NRU1PUllfTU9ERUw9eQpDT05GSUdfU0VMRUNUX01FTU9SWV9NT0RFTD15CiMgQ09O
RklHX0ZMQVRNRU1fTUFOVUFMIGlzIG5vdCBzZXQKIyBDT05GSUdfRElTQ09OVElHTUVNX01BTlVB
TCBpcyBub3Qgc2V0CkNPTkZJR19TUEFSU0VNRU1fTUFOVUFMPXkKQ09ORklHX1NQQVJTRU1FTT15
CkNPTkZJR19ORUVEX01VTFRJUExFX05PREVTPXkKQ09ORklHX0hBVkVfTUVNT1JZX1BSRVNFTlQ9
eQpDT05GSUdfU1BBUlNFTUVNX0VYVFJFTUU9eQpDT05GSUdfU1BBUlNFTUVNX1ZNRU1NQVBfRU5B
QkxFPXkKQ09ORklHX1NQQVJTRU1FTV9WTUVNTUFQPXkKIyBDT05GSUdfTUVNT1JZX0hPVFBMVUcg
aXMgbm90IHNldApDT05GSUdfUEFHRUZMQUdTX0VYVEVOREVEPXkKQ09ORklHX1NQTElUX1BUTE9D
S19DUFVTPTQKQ09ORklHX01JR1JBVElPTj15CkNPTkZJR19QSFlTX0FERFJfVF82NEJJVD15CkNP
TkZJR19aT05FX0RNQV9GTEFHPTEKQ09ORklHX0JPVU5DRT15CkNPTkZJR19WSVJUX1RPX0JVUz15
CkNPTkZJR19IQVZFX01MT0NLPXkKQ09ORklHX0hBVkVfTUxPQ0tFRF9QQUdFX0JJVD15CkNPTkZJ
R19NTVVfTk9USUZJRVI9eQpDT05GSUdfS1NNPXkKQ09ORklHX0RFRkFVTFRfTU1BUF9NSU5fQURE
Uj00MDk2CkNPTkZJR19BUkNIX1NVUFBPUlRTX01FTU9SWV9GQUlMVVJFPXkKIyBDT05GSUdfTUVN
T1JZX0ZBSUxVUkUgaXMgbm90IHNldAojIENPTkZJR19YODZfQ0hFQ0tfQklPU19DT1JSVVBUSU9O
IGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9SRVNFUlZFX0xPV182NEs9eQpDT05GSUdfTVRSUj15CkNP
TkZJR19NVFJSX1NBTklUSVpFUj15CkNPTkZJR19NVFJSX1NBTklUSVpFUl9FTkFCTEVfREVGQVVM
VD0xCkNPTkZJR19NVFJSX1NBTklUSVpFUl9TUEFSRV9SRUdfTlJfREVGQVVMVD0xCkNPTkZJR19Y
ODZfUEFUPXkKQ09ORklHX0FSQ0hfVVNFU19QR19VTkNBQ0hFRD15CkNPTkZJR19FRkk9eQpDT05G
SUdfU0VDQ09NUD15CkNPTkZJR19DQ19TVEFDS1BST1RFQ1RPUj15CiMgQ09ORklHX0haXzEwMCBp
cyBub3Qgc2V0CiMgQ09ORklHX0haXzI1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0haXzMwMCBpcyBu
b3Qgc2V0CkNPTkZJR19IWl8xMDAwPXkKQ09ORklHX0haPTEwMDAKQ09ORklHX1NDSEVEX0hSVElD
Sz15CkNPTkZJR19LRVhFQz15CkNPTkZJR19DUkFTSF9EVU1QPXkKQ09ORklHX0tFWEVDX0pVTVA9
eQpDT05GSUdfUEhZU0lDQUxfU1RBUlQ9MHgxMDAwMDAwCkNPTkZJR19SRUxPQ0FUQUJMRT15CkNP
TkZJR19QSFlTSUNBTF9BTElHTj0weDEwMDAwMDAKQ09ORklHX0hPVFBMVUdfQ1BVPXkKIyBDT05G
SUdfQ09NUEFUX1ZEU08gaXMgbm90IHNldAojIENPTkZJR19DTURMSU5FX0JPT0wgaXMgbm90IHNl
dApDT05GSUdfQVJDSF9FTkFCTEVfTUVNT1JZX0hPVFBMVUc9eQpDT05GSUdfSEFWRV9BUkNIX0VB
UkxZX1BGTl9UT19OSUQ9eQoKIwojIFBvd2VyIG1hbmFnZW1lbnQgYW5kIEFDUEkgb3B0aW9ucwoj
CkNPTkZJR19BUkNIX0hJQkVSTkFUSU9OX0hFQURFUj15CkNPTkZJR19QTT15CkNPTkZJR19QTV9E
RUJVRz15CiMgQ09ORklHX1BNX1ZFUkJPU0UgaXMgbm90IHNldApDT05GSUdfQ0FOX1BNX1RSQUNF
PXkKQ09ORklHX1BNX1RSQUNFPXkKQ09ORklHX1BNX1RSQUNFX1JUQz15CkNPTkZJR19QTV9TTEVF
UF9TTVA9eQpDT05GSUdfUE1fU0xFRVA9eQpDT05GSUdfU1VTUEVORD15CiMgQ09ORklHX1BNX1RF
U1RfU1VTUEVORCBpcyBub3Qgc2V0CkNPTkZJR19TVVNQRU5EX0ZSRUVaRVI9eQpDT05GSUdfSElC
RVJOQVRJT05fTlZTPXkKQ09ORklHX0hJQkVSTkFUSU9OPXkKQ09ORklHX1BNX1NURF9QQVJUSVRJ
T049IiIKIyBDT05GSUdfUE1fUlVOVElNRSBpcyBub3Qgc2V0CkNPTkZJR19BQ1BJPXkKQ09ORklH
X0FDUElfU0xFRVA9eQpDT05GSUdfQUNQSV9QUk9DRlM9eQpDT05GSUdfQUNQSV9QUk9DRlNfUE9X
RVI9eQojIENPTkZJR19BQ1BJX1BPV0VSX01FVEVSIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfU1lT
RlNfUE9XRVI9eQpDT05GSUdfQUNQSV9QUk9DX0VWRU5UPXkKQ09ORklHX0FDUElfQUM9eQpDT05G
SUdfQUNQSV9CQVRURVJZPXkKQ09ORklHX0FDUElfQlVUVE9OPXkKQ09ORklHX0FDUElfVklERU89
bQpDT05GSUdfQUNQSV9GQU49eQpDT05GSUdfQUNQSV9ET0NLPXkKQ09ORklHX0FDUElfUFJPQ0VT
U09SPXkKQ09ORklHX0FDUElfSE9UUExVR19DUFU9eQojIENPTkZJR19BQ1BJX1BST0NFU1NPUl9B
R0dSRUdBVE9SIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfVEhFUk1BTD15CkNPTkZJR19BQ1BJX05V
TUE9eQojIENPTkZJR19BQ1BJX0NVU1RPTV9EU0RUIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfQkxB
Q0tMSVNUX1lFQVI9MAojIENPTkZJR19BQ1BJX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0FDUElf
UENJX1NMT1Q9eQpDT05GSUdfWDg2X1BNX1RJTUVSPXkKQ09ORklHX0FDUElfQ09OVEFJTkVSPXkK
Q09ORklHX0FDUElfU0JTPW0KIyBDT05GSUdfU0ZJIGlzIG5vdCBzZXQKCiMKIyBDUFUgRnJlcXVl
bmN5IHNjYWxpbmcKIwpDT05GSUdfQ1BVX0ZSRVE9eQpDT05GSUdfQ1BVX0ZSRVFfVEFCTEU9bQpD
T05GSUdfQ1BVX0ZSRVFfREVCVUc9eQpDT05GSUdfQ1BVX0ZSRVFfU1RBVD1tCkNPTkZJR19DUFVf
RlJFUV9TVEFUX0RFVEFJTFM9eQojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9QRVJGT1JN
QU5DRSBpcyBub3Qgc2V0CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX1BPV0VSU0FWRSBp
cyBub3Qgc2V0CkNPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9VU0VSU1BBQ0U9eQojIENPTkZJ
R19DUFVfRlJFUV9ERUZBVUxUX0dPVl9PTkRFTUFORCBpcyBub3Qgc2V0CiMgQ09ORklHX0NQVV9G
UkVRX0RFRkFVTFRfR09WX0NPTlNFUlZBVElWRSBpcyBub3Qgc2V0CkNPTkZJR19DUFVfRlJFUV9H
T1ZfUEVSRk9STUFOQ0U9eQpDT05GSUdfQ1BVX0ZSRVFfR09WX1BPV0VSU0FWRT1tCkNPTkZJR19D
UFVfRlJFUV9HT1ZfVVNFUlNQQUNFPXkKQ09ORklHX0NQVV9GUkVRX0dPVl9PTkRFTUFORD1tCkNP
TkZJR19DUFVfRlJFUV9HT1ZfQ09OU0VSVkFUSVZFPW0KCiMKIyBDUFVGcmVxIHByb2Nlc3NvciBk
cml2ZXJzCiMKQ09ORklHX1g4Nl9BQ1BJX0NQVUZSRVE9bQpDT05GSUdfWDg2X1BPV0VSTk9XX0s4
PW0KIyBDT05GSUdfWDg2X1NQRUVEU1RFUF9DRU5UUklOTyBpcyBub3Qgc2V0CkNPTkZJR19YODZf
UDRfQ0xPQ0tNT0Q9bQoKIwojIHNoYXJlZCBvcHRpb25zCiMKQ09ORklHX1g4Nl9TUEVFRFNURVBf
TElCPW0KQ09ORklHX0NQVV9JRExFPXkKQ09ORklHX0NQVV9JRExFX0dPVl9MQURERVI9eQpDT05G
SUdfQ1BVX0lETEVfR09WX01FTlU9eQoKIwojIE1lbW9yeSBwb3dlciBzYXZpbmdzCiMKQ09ORklH
X0k3MzAwX0lETEVfSU9BVF9DSEFOTkVMPXkKQ09ORklHX0k3MzAwX0lETEU9bQoKIwojIEJ1cyBv
cHRpb25zIChQQ0kgZXRjLikKIwpDT05GSUdfUENJPXkKQ09ORklHX1BDSV9ESVJFQ1Q9eQpDT05G
SUdfUENJX01NQ09ORklHPXkKQ09ORklHX1BDSV9ET01BSU5TPXkKQ09ORklHX0RNQVI9eQpDT05G
SUdfRE1BUl9ERUZBVUxUX09OPXkKQ09ORklHX0RNQVJfRkxPUFBZX1dBPXkKQ09ORklHX0lOVFJf
UkVNQVA9eQpDT05GSUdfUENJRVBPUlRCVVM9eQpDT05GSUdfSE9UUExVR19QQ0lfUENJRT15CkNP
TkZJR19QQ0lFQUVSPXkKQ09ORklHX1BDSUVfRUNSQz15CkNPTkZJR19QQ0lFQUVSX0lOSkVDVD1t
CkNPTkZJR19QQ0lFQVNQTT15CiMgQ09ORklHX1BDSUVBU1BNX0RFQlVHIGlzIG5vdCBzZXQKQ09O
RklHX0FSQ0hfU1VQUE9SVFNfTVNJPXkKQ09ORklHX1BDSV9NU0k9eQpDT05GSUdfUENJX0xFR0FD
WT15CiMgQ09ORklHX1BDSV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19QQ0lfU1RVQj15CkNPTkZJ
R19IVF9JUlE9eQpDT05GSUdfUENJX0lPVj15CkNPTkZJR19JU0FfRE1BX0FQST15CkNPTkZJR19L
OF9OQj15CkNPTkZJR19QQ0NBUkQ9eQojIENPTkZJR19QQ01DSUFfREVCVUcgaXMgbm90IHNldApD
T05GSUdfUENNQ0lBPXkKQ09ORklHX1BDTUNJQV9MT0FEX0NJUz15CkNPTkZJR19QQ01DSUFfSU9D
VEw9eQpDT05GSUdfQ0FSREJVUz15CgojCiMgUEMtY2FyZCBicmlkZ2VzCiMKQ09ORklHX1lFTlRB
PW0KQ09ORklHX1lFTlRBX08yPXkKQ09ORklHX1lFTlRBX1JJQ09IPXkKQ09ORklHX1lFTlRBX1RJ
PXkKQ09ORklHX1lFTlRBX0VORV9UVU5FPXkKQ09ORklHX1lFTlRBX1RPU0hJQkE9eQpDT05GSUdf
UEQ2NzI5PW0KQ09ORklHX0k4MjA5Mj1tCkNPTkZJR19QQ0NBUkRfTk9OU1RBVElDPW0KQ09ORklH
X0hPVFBMVUdfUENJPXkKQ09ORklHX0hPVFBMVUdfUENJX0ZBS0U9bQpDT05GSUdfSE9UUExVR19Q
Q0lfQUNQST15CkNPTkZJR19IT1RQTFVHX1BDSV9BQ1BJX0lCTT1tCiMgQ09ORklHX0hPVFBMVUdf
UENJX0NQQ0kgaXMgbm90IHNldApDT05GSUdfSE9UUExVR19QQ0lfU0hQQz1tCgojCiMgRXhlY3V0
YWJsZSBmaWxlIGZvcm1hdHMgLyBFbXVsYXRpb25zCiMKQ09ORklHX0JJTkZNVF9FTEY9eQpDT05G
SUdfQ09NUEFUX0JJTkZNVF9FTEY9eQpDT05GSUdfQ09SRV9EVU1QX0RFRkFVTFRfRUxGX0hFQURF
UlM9eQojIENPTkZJR19IQVZFX0FPVVQgaXMgbm90IHNldApDT05GSUdfQklORk1UX01JU0M9eQpD
T05GSUdfSUEzMl9FTVVMQVRJT049eQojIENPTkZJR19JQTMyX0FPVVQgaXMgbm90IHNldApDT05G
SUdfQ09NUEFUPXkKQ09ORklHX0NPTVBBVF9GT1JfVTY0X0FMSUdOTUVOVD15CkNPTkZJR19TWVNW
SVBDX0NPTVBBVD15CkNPTkZJR19ORVQ9eQpDT05GSUdfQ09NUEFUX05FVExJTktfTUVTU0FHRVM9
eQoKIwojIE5ldHdvcmtpbmcgb3B0aW9ucwojCkNPTkZJR19QQUNLRVQ9eQpDT05GSUdfUEFDS0VU
X01NQVA9eQpDT05GSUdfVU5JWD15CkNPTkZJR19YRlJNPXkKQ09ORklHX1hGUk1fVVNFUj15CkNP
TkZJR19YRlJNX1NVQl9QT0xJQ1k9eQpDT05GSUdfWEZSTV9NSUdSQVRFPXkKQ09ORklHX1hGUk1f
U1RBVElTVElDUz15CkNPTkZJR19YRlJNX0lQQ09NUD1tCkNPTkZJR19ORVRfS0VZPW0KQ09ORklH
X05FVF9LRVlfTUlHUkFURT15CkNPTkZJR19JTkVUPXkKQ09ORklHX0lQX01VTFRJQ0FTVD15CkNP
TkZJR19JUF9BRFZBTkNFRF9ST1VURVI9eQpDT05GSUdfQVNLX0lQX0ZJQl9IQVNIPXkKIyBDT05G
SUdfSVBfRklCX1RSSUUgaXMgbm90IHNldApDT05GSUdfSVBfRklCX0hBU0g9eQpDT05GSUdfSVBf
TVVMVElQTEVfVEFCTEVTPXkKQ09ORklHX0lQX1JPVVRFX01VTFRJUEFUSD15CkNPTkZJR19JUF9S
T1VURV9WRVJCT1NFPXkKIyBDT05GSUdfSVBfUE5QIGlzIG5vdCBzZXQKQ09ORklHX05FVF9JUElQ
PW0KQ09ORklHX05FVF9JUEdSRT1tCkNPTkZJR19ORVRfSVBHUkVfQlJPQURDQVNUPXkKQ09ORklH
X0lQX01ST1VURT15CkNPTkZJR19JUF9QSU1TTV9WMT15CkNPTkZJR19JUF9QSU1TTV9WMj15CkNP
TkZJR19BUlBEPXkKQ09ORklHX1NZTl9DT09LSUVTPXkKQ09ORklHX0lORVRfQUg9bQpDT05GSUdf
SU5FVF9FU1A9bQpDT05GSUdfSU5FVF9JUENPTVA9bQpDT05GSUdfSU5FVF9YRlJNX1RVTk5FTD1t
CkNPTkZJR19JTkVUX1RVTk5FTD1tCkNPTkZJR19JTkVUX1hGUk1fTU9ERV9UUkFOU1BPUlQ9bQpD
T05GSUdfSU5FVF9YRlJNX01PREVfVFVOTkVMPW0KQ09ORklHX0lORVRfWEZSTV9NT0RFX0JFRVQ9
bQpDT05GSUdfSU5FVF9MUk89eQpDT05GSUdfSU5FVF9ESUFHPW0KQ09ORklHX0lORVRfVENQX0RJ
QUc9bQpDT05GSUdfVENQX0NPTkdfQURWQU5DRUQ9eQpDT05GSUdfVENQX0NPTkdfQklDPW0KQ09O
RklHX1RDUF9DT05HX0NVQklDPXkKQ09ORklHX1RDUF9DT05HX1dFU1RXT09EPW0KQ09ORklHX1RD
UF9DT05HX0hUQ1A9bQpDT05GSUdfVENQX0NPTkdfSFNUQ1A9bQpDT05GSUdfVENQX0NPTkdfSFlC
TEE9bQpDT05GSUdfVENQX0NPTkdfVkVHQVM9bQpDT05GSUdfVENQX0NPTkdfU0NBTEFCTEU9bQpD
T05GSUdfVENQX0NPTkdfTFA9bQpDT05GSUdfVENQX0NPTkdfVkVOTz1tCkNPTkZJR19UQ1BfQ09O
R19ZRUFIPW0KQ09ORklHX1RDUF9DT05HX0lMTElOT0lTPW0KIyBDT05GSUdfREVGQVVMVF9CSUMg
aXMgbm90IHNldApDT05GSUdfREVGQVVMVF9DVUJJQz15CiMgQ09ORklHX0RFRkFVTFRfSFRDUCBp
cyBub3Qgc2V0CiMgQ09ORklHX0RFRkFVTFRfVkVHQVMgaXMgbm90IHNldAojIENPTkZJR19ERUZB
VUxUX1dFU1RXT09EIGlzIG5vdCBzZXQKIyBDT05GSUdfREVGQVVMVF9SRU5PIGlzIG5vdCBzZXQK
Q09ORklHX0RFRkFVTFRfVENQX0NPTkc9ImN1YmljIgpDT05GSUdfVENQX01ENVNJRz15CkNPTkZJ
R19JUFY2PW0KQ09ORklHX0lQVjZfUFJJVkFDWT15CkNPTkZJR19JUFY2X1JPVVRFUl9QUkVGPXkK
Q09ORklHX0lQVjZfUk9VVEVfSU5GTz15CkNPTkZJR19JUFY2X09QVElNSVNUSUNfREFEPXkKQ09O
RklHX0lORVQ2X0FIPW0KQ09ORklHX0lORVQ2X0VTUD1tCkNPTkZJR19JTkVUNl9JUENPTVA9bQpD
T05GSUdfSVBWNl9NSVA2PW0KQ09ORklHX0lORVQ2X1hGUk1fVFVOTkVMPW0KQ09ORklHX0lORVQ2
X1RVTk5FTD1tCkNPTkZJR19JTkVUNl9YRlJNX01PREVfVFJBTlNQT1JUPW0KQ09ORklHX0lORVQ2
X1hGUk1fTU9ERV9UVU5ORUw9bQpDT05GSUdfSU5FVDZfWEZSTV9NT0RFX0JFRVQ9bQpDT05GSUdf
SU5FVDZfWEZSTV9NT0RFX1JPVVRFT1BUSU1JWkFUSU9OPW0KQ09ORklHX0lQVjZfU0lUPW0KQ09O
RklHX0lQVjZfTkRJU0NfTk9ERVRZUEU9eQpDT05GSUdfSVBWNl9UVU5ORUw9bQpDT05GSUdfSVBW
Nl9NVUxUSVBMRV9UQUJMRVM9eQpDT05GSUdfSVBWNl9TVUJUUkVFUz15CkNPTkZJR19JUFY2X01S
T1VURT15CkNPTkZJR19JUFY2X1BJTVNNX1YyPXkKQ09ORklHX05FVExBQkVMPXkKQ09ORklHX05F
VFdPUktfU0VDTUFSSz15CkNPTkZJR19ORVRGSUxURVI9eQojIENPTkZJR19ORVRGSUxURVJfREVC
VUcgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX0FEVkFOQ0VEPXkKQ09ORklHX0JSSURHRV9O
RVRGSUxURVI9eQoKIwojIENvcmUgTmV0ZmlsdGVyIENvbmZpZ3VyYXRpb24KIwpDT05GSUdfTkVU
RklMVEVSX05FVExJTks9bQpDT05GSUdfTkVURklMVEVSX05FVExJTktfUVVFVUU9bQpDT05GSUdf
TkVURklMVEVSX05FVExJTktfTE9HPW0KQ09ORklHX05GX0NPTk5UUkFDSz15CkNPTkZJR19ORl9D
VF9BQ0NUPXkKQ09ORklHX05GX0NPTk5UUkFDS19NQVJLPXkKQ09ORklHX05GX0NPTk5UUkFDS19T
RUNNQVJLPXkKQ09ORklHX05GX0NPTk5UUkFDS19FVkVOVFM9eQpDT05GSUdfTkZfQ1RfUFJPVE9f
RENDUD1tCkNPTkZJR19ORl9DVF9QUk9UT19HUkU9bQpDT05GSUdfTkZfQ1RfUFJPVE9fU0NUUD1t
CkNPTkZJR19ORl9DVF9QUk9UT19VRFBMSVRFPW0KQ09ORklHX05GX0NPTk5UUkFDS19BTUFOREE9
bQpDT05GSUdfTkZfQ09OTlRSQUNLX0ZUUD1tCkNPTkZJR19ORl9DT05OVFJBQ0tfSDMyMz1tCkNP
TkZJR19ORl9DT05OVFJBQ0tfSVJDPW0KQ09ORklHX05GX0NPTk5UUkFDS19ORVRCSU9TX05TPW0K
Q09ORklHX05GX0NPTk5UUkFDS19QUFRQPW0KQ09ORklHX05GX0NPTk5UUkFDS19TQU5FPW0KQ09O
RklHX05GX0NPTk5UUkFDS19TSVA9bQpDT05GSUdfTkZfQ09OTlRSQUNLX1RGVFA9bQpDT05GSUdf
TkZfQ1RfTkVUTElOSz1tCkNPTkZJR19ORVRGSUxURVJfVFBST1hZPW0KQ09ORklHX05FVEZJTFRF
Ul9YVEFCTEVTPXkKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfQ0xBU1NJRlk9bQpDT05GSUdf
TkVURklMVEVSX1hUX1RBUkdFVF9DT05OTUFSSz1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VU
X0NPTk5TRUNNQVJLPW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfRFNDUD1tCkNPTkZJR19O
RVRGSUxURVJfWFRfVEFSR0VUX0hMPW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfTEVEPW0K
Q09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfTUFSSz1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFS
R0VUX05GTE9HPW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfTkZRVUVVRT1tCkNPTkZJR19O
RVRGSUxURVJfWFRfVEFSR0VUX05PVFJBQ0s9bQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9S
QVRFRVNUPW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfVFBST1hZPW0KQ09ORklHX05FVEZJ
TFRFUl9YVF9UQVJHRVRfVFJBQ0U9bQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9TRUNNQVJL
PW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfVENQTVNTPW0KQ09ORklHX05FVEZJTFRFUl9Y
VF9UQVJHRVRfVENQT1BUU1RSSVA9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NMVVNURVI9
bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NPTU1FTlQ9bQpDT05GSUdfTkVURklMVEVSX1hU
X01BVENIX0NPTk5CWVRFUz1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfQ09OTkxJTUlUPW0K
Q09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9DT05OTUFSSz1tCkNPTkZJR19ORVRGSUxURVJfWFRf
TUFUQ0hfQ09OTlRSQUNLPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9EQ0NQPW0KQ09ORklH
X05FVEZJTFRFUl9YVF9NQVRDSF9EU0NQPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9FU1A9
bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0hBU0hMSU1JVD1tCkNPTkZJR19ORVRGSUxURVJf
WFRfTUFUQ0hfSEVMUEVSPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9ITD1tCkNPTkZJR19O
RVRGSUxURVJfWFRfTUFUQ0hfSVBSQU5HRT1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfTEVO
R1RIPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9MSU1JVD1tCkNPTkZJR19ORVRGSUxURVJf
WFRfTUFUQ0hfTUFDPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9NQVJLPW0KQ09ORklHX05F
VEZJTFRFUl9YVF9NQVRDSF9NVUxUSVBPUlQ9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX09X
TkVSPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9QT0xJQ1k9bQpDT05GSUdfTkVURklMVEVS
X1hUX01BVENIX1BIWVNERVY9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1BLVFRZUEU9bQpD
T05GSUdfTkVURklMVEVSX1hUX01BVENIX1FVT1RBPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRD
SF9SQVRFRVNUPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9SRUFMTT1tCkNPTkZJR19ORVRG
SUxURVJfWFRfTUFUQ0hfUkVDRU5UPW0KIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1JFQ0VO
VF9QUk9DX0NPTVBBVCBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU0NUUD1t
CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU09DS0VUPW0KQ09ORklHX05FVEZJTFRFUl9YVF9N
QVRDSF9TVEFURT15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU1RBVElTVElDPW0KQ09ORklH
X05FVEZJTFRFUl9YVF9NQVRDSF9TVFJJTkc9bQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1RD
UE1TUz1tCkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfVElNRT1tCkNPTkZJR19ORVRGSUxURVJf
WFRfTUFUQ0hfVTMyPW0KQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9PU0Y9bQpDT05GSUdfSVBf
VlM9bQojIENPTkZJR19JUF9WU19JUFY2IGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfVlNfREVCVUcg
aXMgbm90IHNldApDT05GSUdfSVBfVlNfVEFCX0JJVFM9MTIKCiMKIyBJUFZTIHRyYW5zcG9ydCBw
cm90b2NvbCBsb2FkIGJhbGFuY2luZyBzdXBwb3J0CiMKQ09ORklHX0lQX1ZTX1BST1RPX1RDUD15
CkNPTkZJR19JUF9WU19QUk9UT19VRFA9eQpDT05GSUdfSVBfVlNfUFJPVE9fQUhfRVNQPXkKQ09O
RklHX0lQX1ZTX1BST1RPX0VTUD15CkNPTkZJR19JUF9WU19QUk9UT19BSD15CgojCiMgSVBWUyBz
Y2hlZHVsZXIKIwpDT05GSUdfSVBfVlNfUlI9bQpDT05GSUdfSVBfVlNfV1JSPW0KQ09ORklHX0lQ
X1ZTX0xDPW0KQ09ORklHX0lQX1ZTX1dMQz1tCkNPTkZJR19JUF9WU19MQkxDPW0KQ09ORklHX0lQ
X1ZTX0xCTENSPW0KQ09ORklHX0lQX1ZTX0RIPW0KQ09ORklHX0lQX1ZTX1NIPW0KQ09ORklHX0lQ
X1ZTX1NFRD1tCkNPTkZJR19JUF9WU19OUT1tCgojCiMgSVBWUyBhcHBsaWNhdGlvbiBoZWxwZXIK
IwpDT05GSUdfSVBfVlNfRlRQPW0KCiMKIyBJUDogTmV0ZmlsdGVyIENvbmZpZ3VyYXRpb24KIwpD
T05GSUdfTkZfREVGUkFHX0lQVjQ9eQpDT05GSUdfTkZfQ09OTlRSQUNLX0lQVjQ9eQojIENPTkZJ
R19ORl9DT05OVFJBQ0tfUFJPQ19DT01QQVQgaXMgbm90IHNldApDT05GSUdfSVBfTkZfUVVFVUU9
bQpDT05GSUdfSVBfTkZfSVBUQUJMRVM9eQpDT05GSUdfSVBfTkZfTUFUQ0hfQUREUlRZUEU9bQpD
T05GSUdfSVBfTkZfTUFUQ0hfQUg9bQpDT05GSUdfSVBfTkZfTUFUQ0hfRUNOPW0KQ09ORklHX0lQ
X05GX01BVENIX1RUTD1tCkNPTkZJR19JUF9ORl9GSUxURVI9eQpDT05GSUdfSVBfTkZfVEFSR0VU
X1JFSkVDVD15CkNPTkZJR19JUF9ORl9UQVJHRVRfTE9HPW0KQ09ORklHX0lQX05GX1RBUkdFVF9V
TE9HPW0KQ09ORklHX05GX05BVD1tCkNPTkZJR19ORl9OQVRfTkVFREVEPXkKQ09ORklHX0lQX05G
X1RBUkdFVF9NQVNRVUVSQURFPW0KQ09ORklHX0lQX05GX1RBUkdFVF9ORVRNQVA9bQpDT05GSUdf
SVBfTkZfVEFSR0VUX1JFRElSRUNUPW0KQ09ORklHX05GX05BVF9TTk1QX0JBU0lDPW0KQ09ORklH
X05GX05BVF9QUk9UT19EQ0NQPW0KQ09ORklHX05GX05BVF9QUk9UT19HUkU9bQpDT05GSUdfTkZf
TkFUX1BST1RPX1VEUExJVEU9bQpDT05GSUdfTkZfTkFUX1BST1RPX1NDVFA9bQpDT05GSUdfTkZf
TkFUX0ZUUD1tCkNPTkZJR19ORl9OQVRfSVJDPW0KQ09ORklHX05GX05BVF9URlRQPW0KQ09ORklH
X05GX05BVF9BTUFOREE9bQpDT05GSUdfTkZfTkFUX1BQVFA9bQpDT05GSUdfTkZfTkFUX0gzMjM9
bQpDT05GSUdfTkZfTkFUX1NJUD1tCkNPTkZJR19JUF9ORl9NQU5HTEU9bQpDT05GSUdfSVBfTkZf
VEFSR0VUX0NMVVNURVJJUD1tCkNPTkZJR19JUF9ORl9UQVJHRVRfRUNOPW0KQ09ORklHX0lQX05G
X1RBUkdFVF9UVEw9bQpDT05GSUdfSVBfTkZfUkFXPW0KQ09ORklHX0lQX05GX1NFQ1VSSVRZPW0K
Q09ORklHX0lQX05GX0FSUFRBQkxFUz1tCkNPTkZJR19JUF9ORl9BUlBGSUxURVI9bQpDT05GSUdf
SVBfTkZfQVJQX01BTkdMRT1tCgojCiMgSVB2NjogTmV0ZmlsdGVyIENvbmZpZ3VyYXRpb24KIwpD
T05GSUdfTkZfQ09OTlRSQUNLX0lQVjY9bQpDT05GSUdfSVA2X05GX1FVRVVFPW0KQ09ORklHX0lQ
Nl9ORl9JUFRBQkxFUz1tCkNPTkZJR19JUDZfTkZfTUFUQ0hfQUg9bQpDT05GSUdfSVA2X05GX01B
VENIX0VVSTY0PW0KQ09ORklHX0lQNl9ORl9NQVRDSF9GUkFHPW0KQ09ORklHX0lQNl9ORl9NQVRD
SF9PUFRTPW0KQ09ORklHX0lQNl9ORl9NQVRDSF9ITD1tCkNPTkZJR19JUDZfTkZfTUFUQ0hfSVBW
NkhFQURFUj1tCkNPTkZJR19JUDZfTkZfTUFUQ0hfTUg9bQpDT05GSUdfSVA2X05GX01BVENIX1JU
PW0KQ09ORklHX0lQNl9ORl9UQVJHRVRfSEw9bQpDT05GSUdfSVA2X05GX1RBUkdFVF9MT0c9bQpD
T05GSUdfSVA2X05GX0ZJTFRFUj1tCkNPTkZJR19JUDZfTkZfVEFSR0VUX1JFSkVDVD1tCkNPTkZJ
R19JUDZfTkZfTUFOR0xFPW0KQ09ORklHX0lQNl9ORl9SQVc9bQpDT05GSUdfSVA2X05GX1NFQ1VS
SVRZPW0KCiMKIyBERUNuZXQ6IE5ldGZpbHRlciBDb25maWd1cmF0aW9uCiMKIyBDT05GSUdfREVD
TkVUX05GX0dSQUJVTEFUT1IgaXMgbm90IHNldApDT05GSUdfQlJJREdFX05GX0VCVEFCTEVTPW0K
Q09ORklHX0JSSURHRV9FQlRfQlJPVVRFPW0KQ09ORklHX0JSSURHRV9FQlRfVF9GSUxURVI9bQpD
T05GSUdfQlJJREdFX0VCVF9UX05BVD1tCkNPTkZJR19CUklER0VfRUJUXzgwMl8zPW0KQ09ORklH
X0JSSURHRV9FQlRfQU1PTkc9bQpDT05GSUdfQlJJREdFX0VCVF9BUlA9bQpDT05GSUdfQlJJREdF
X0VCVF9JUD1tCkNPTkZJR19CUklER0VfRUJUX0lQNj1tCkNPTkZJR19CUklER0VfRUJUX0xJTUlU
PW0KQ09ORklHX0JSSURHRV9FQlRfTUFSSz1tCkNPTkZJR19CUklER0VfRUJUX1BLVFRZUEU9bQpD
T05GSUdfQlJJREdFX0VCVF9TVFA9bQpDT05GSUdfQlJJREdFX0VCVF9WTEFOPW0KQ09ORklHX0JS
SURHRV9FQlRfQVJQUkVQTFk9bQpDT05GSUdfQlJJREdFX0VCVF9ETkFUPW0KQ09ORklHX0JSSURH
RV9FQlRfTUFSS19UPW0KQ09ORklHX0JSSURHRV9FQlRfUkVESVJFQ1Q9bQpDT05GSUdfQlJJREdF
X0VCVF9TTkFUPW0KQ09ORklHX0JSSURHRV9FQlRfTE9HPW0KQ09ORklHX0JSSURHRV9FQlRfVUxP
Rz1tCkNPTkZJR19CUklER0VfRUJUX05GTE9HPW0KQ09ORklHX0lQX0RDQ1A9bQpDT05GSUdfSU5F
VF9EQ0NQX0RJQUc9bQoKIwojIERDQ1AgQ0NJRHMgQ29uZmlndXJhdGlvbiAoRVhQRVJJTUVOVEFM
KQojCiMgQ09ORklHX0lQX0RDQ1BfQ0NJRDJfREVCVUcgaXMgbm90IHNldApDT05GSUdfSVBfREND
UF9DQ0lEMz15CiMgQ09ORklHX0lQX0RDQ1BfQ0NJRDNfREVCVUcgaXMgbm90IHNldApDT05GSUdf
SVBfRENDUF9DQ0lEM19SVE89MTAwCkNPTkZJR19JUF9EQ0NQX1RGUkNfTElCPXkKCiMKIyBEQ0NQ
IEtlcm5lbCBIYWNraW5nCiMKIyBDT05GSUdfSVBfRENDUF9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJ
R19ORVRfRENDUFBST0JFPW0KQ09ORklHX0lQX1NDVFA9bQojIENPTkZJR19TQ1RQX0RCR19NU0cg
aXMgbm90IHNldAojIENPTkZJR19TQ1RQX0RCR19PQkpDTlQgaXMgbm90IHNldAojIENPTkZJR19T
Q1RQX0hNQUNfTk9ORSBpcyBub3Qgc2V0CkNPTkZJR19TQ1RQX0hNQUNfU0hBMT15CiMgQ09ORklH
X1NDVFBfSE1BQ19NRDUgaXMgbm90IHNldApDT05GSUdfUkRTPW0KIyBDT05GSUdfUkRTX1JETUEg
aXMgbm90IHNldAojIENPTkZJR19SRFNfVENQIGlzIG5vdCBzZXQKIyBDT05GSUdfUkRTX0RFQlVH
IGlzIG5vdCBzZXQKQ09ORklHX1RJUEM9bQojIENPTkZJR19USVBDX0FEVkFOQ0VEIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVElQQ19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19BVE09bQpDT05GSUdfQVRN
X0NMSVA9bQojIENPTkZJR19BVE1fQ0xJUF9OT19JQ01QIGlzIG5vdCBzZXQKQ09ORklHX0FUTV9M
QU5FPW0KIyBDT05GSUdfQVRNX01QT0EgaXMgbm90IHNldApDT05GSUdfQVRNX0JSMjY4ND1tCiMg
Q09ORklHX0FUTV9CUjI2ODRfSVBGSUxURVIgaXMgbm90IHNldApDT05GSUdfU1RQPW0KQ09ORklH
X0dBUlA9bQpDT05GSUdfQlJJREdFPW0KQ09ORklHX05FVF9EU0E9eQpDT05GSUdfTkVUX0RTQV9U
QUdfRFNBPXkKQ09ORklHX05FVF9EU0FfVEFHX0VEU0E9eQpDT05GSUdfTkVUX0RTQV9UQUdfVFJB
SUxFUj15CkNPTkZJR19ORVRfRFNBX01WODhFNlhYWD15CkNPTkZJR19ORVRfRFNBX01WODhFNjA2
MD15CkNPTkZJR19ORVRfRFNBX01WODhFNlhYWF9ORUVEX1BQVT15CkNPTkZJR19ORVRfRFNBX01W
ODhFNjEzMT15CkNPTkZJR19ORVRfRFNBX01WODhFNjEyM182MV82NT15CkNPTkZJR19WTEFOXzgw
MjFRPW0KQ09ORklHX1ZMQU5fODAyMVFfR1ZSUD15CkNPTkZJR19ERUNORVQ9bQpDT05GSUdfREVD
TkVUX1JPVVRFUj15CkNPTkZJR19MTEM9bQojIENPTkZJR19MTEMyIGlzIG5vdCBzZXQKQ09ORklH
X0lQWD1tCiMgQ09ORklHX0lQWF9JTlRFUk4gaXMgbm90IHNldApDT05GSUdfQVRBTEs9bQpDT05G
SUdfREVWX0FQUExFVEFMSz1tCkNPTkZJR19JUEREUD1tCkNPTkZJR19JUEREUF9FTkNBUD15CkNP
TkZJR19JUEREUF9ERUNBUD15CiMgQ09ORklHX1gyNSBpcyBub3Qgc2V0CiMgQ09ORklHX0xBUEIg
aXMgbm90IHNldAojIENPTkZJR19FQ09ORVQgaXMgbm90IHNldApDT05GSUdfV0FOX1JPVVRFUj1t
CkNPTkZJR19QSE9ORVQ9bQpDT05GSUdfSUVFRTgwMjE1ND1tCkNPTkZJR19ORVRfU0NIRUQ9eQoK
IwojIFF1ZXVlaW5nL1NjaGVkdWxpbmcKIwpDT05GSUdfTkVUX1NDSF9DQlE9bQpDT05GSUdfTkVU
X1NDSF9IVEI9bQpDT05GSUdfTkVUX1NDSF9IRlNDPW0KQ09ORklHX05FVF9TQ0hfQVRNPW0KQ09O
RklHX05FVF9TQ0hfUFJJTz1tCkNPTkZJR19ORVRfU0NIX01VTFRJUT1tCkNPTkZJR19ORVRfU0NI
X1JFRD1tCkNPTkZJR19ORVRfU0NIX1NGUT1tCkNPTkZJR19ORVRfU0NIX1RFUUw9bQpDT05GSUdf
TkVUX1NDSF9UQkY9bQpDT05GSUdfTkVUX1NDSF9HUkVEPW0KQ09ORklHX05FVF9TQ0hfRFNNQVJL
PW0KQ09ORklHX05FVF9TQ0hfTkVURU09bQpDT05GSUdfTkVUX1NDSF9EUlI9bQpDT05GSUdfTkVU
X1NDSF9JTkdSRVNTPW0KCiMKIyBDbGFzc2lmaWNhdGlvbgojCkNPTkZJR19ORVRfQ0xTPXkKQ09O
RklHX05FVF9DTFNfQkFTSUM9bQpDT05GSUdfTkVUX0NMU19UQ0lOREVYPW0KQ09ORklHX05FVF9D
TFNfUk9VVEU0PW0KQ09ORklHX05FVF9DTFNfUk9VVEU9eQpDT05GSUdfTkVUX0NMU19GVz1tCkNP
TkZJR19ORVRfQ0xTX1UzMj1tCkNPTkZJR19DTFNfVTMyX1BFUkY9eQpDT05GSUdfQ0xTX1UzMl9N
QVJLPXkKQ09ORklHX05FVF9DTFNfUlNWUD1tCkNPTkZJR19ORVRfQ0xTX1JTVlA2PW0KQ09ORklH
X05FVF9DTFNfRkxPVz1tCkNPTkZJR19ORVRfQ0xTX0NHUk9VUD15CkNPTkZJR19ORVRfRU1BVENI
PXkKQ09ORklHX05FVF9FTUFUQ0hfU1RBQ0s9MzIKQ09ORklHX05FVF9FTUFUQ0hfQ01QPW0KQ09O
RklHX05FVF9FTUFUQ0hfTkJZVEU9bQpDT05GSUdfTkVUX0VNQVRDSF9VMzI9bQpDT05GSUdfTkVU
X0VNQVRDSF9NRVRBPW0KQ09ORklHX05FVF9FTUFUQ0hfVEVYVD1tCkNPTkZJR19ORVRfQ0xTX0FD
VD15CkNPTkZJR19ORVRfQUNUX1BPTElDRT1tCkNPTkZJR19ORVRfQUNUX0dBQ1Q9bQpDT05GSUdf
R0FDVF9QUk9CPXkKQ09ORklHX05FVF9BQ1RfTUlSUkVEPW0KQ09ORklHX05FVF9BQ1RfSVBUPW0K
Q09ORklHX05FVF9BQ1RfTkFUPW0KQ09ORklHX05FVF9BQ1RfUEVESVQ9bQpDT05GSUdfTkVUX0FD
VF9TSU1QPW0KQ09ORklHX05FVF9BQ1RfU0tCRURJVD1tCkNPTkZJR19ORVRfQ0xTX0lORD15CkNP
TkZJR19ORVRfU0NIX0ZJRk89eQpDT05GSUdfRENCPXkKCiMKIyBOZXR3b3JrIHRlc3RpbmcKIwpD
T05GSUdfTkVUX1BLVEdFTj1tCiMgQ09ORklHX05FVF9UQ1BQUk9CRSBpcyBub3Qgc2V0CkNPTkZJ
R19ORVRfRFJPUF9NT05JVE9SPXkKQ09ORklHX0hBTVJBRElPPXkKCiMKIyBQYWNrZXQgUmFkaW8g
cHJvdG9jb2xzCiMKQ09ORklHX0FYMjU9bQpDT05GSUdfQVgyNV9EQU1BX1NMQVZFPXkKQ09ORklH
X05FVFJPTT1tCkNPTkZJR19ST1NFPW0KCiMKIyBBWC4yNSBuZXR3b3JrIGRldmljZSBkcml2ZXJz
CiMKQ09ORklHX01LSVNTPW0KQ09ORklHXzZQQUNLPW0KQ09ORklHX0JQUUVUSEVSPW0KQ09ORklH
X0JBWUNPTV9TRVJfRkRYPW0KQ09ORklHX0JBWUNPTV9TRVJfSERYPW0KQ09ORklHX0JBWUNPTV9Q
QVI9bQpDT05GSUdfWUFNPW0KQ09ORklHX0NBTj1tCkNPTkZJR19DQU5fUkFXPW0KQ09ORklHX0NB
Tl9CQ009bQoKIwojIENBTiBEZXZpY2UgRHJpdmVycwojCkNPTkZJR19DQU5fVkNBTj1tCkNPTkZJ
R19DQU5fREVWPW0KQ09ORklHX0NBTl9DQUxDX0JJVFRJTUlORz15CkNPTkZJR19DQU5fU0pBMTAw
MD1tCkNPTkZJR19DQU5fU0pBMTAwMF9QTEFURk9STT1tCkNPTkZJR19DQU5fRU1TX1BDST1tCkNP
TkZJR19DQU5fS1ZBU0VSX1BDST1tCgojCiMgQ0FOIFVTQiBpbnRlcmZhY2VzCiMKIyBDT05GSUdf
Q0FOX0VNU19VU0IgaXMgbm90IHNldAojIENPTkZJR19DQU5fREVCVUdfREVWSUNFUyBpcyBub3Qg
c2V0CkNPTkZJR19JUkRBPW0KCiMKIyBJckRBIHByb3RvY29scwojCkNPTkZJR19JUkxBTj1tCkNP
TkZJR19JUk5FVD1tCkNPTkZJR19JUkNPTU09bQojIENPTkZJR19JUkRBX1VMVFJBIGlzIG5vdCBz
ZXQKCiMKIyBJckRBIG9wdGlvbnMKIwpDT05GSUdfSVJEQV9DQUNIRV9MQVNUX0xTQVA9eQpDT05G
SUdfSVJEQV9GQVNUX1JSPXkKIyBDT05GSUdfSVJEQV9ERUJVRyBpcyBub3Qgc2V0CgojCiMgSW5m
cmFyZWQtcG9ydCBkZXZpY2UgZHJpdmVycwojCgojCiMgU0lSIGRldmljZSBkcml2ZXJzCiMKQ09O
RklHX0lSVFRZX1NJUj1tCgojCiMgRG9uZ2xlIHN1cHBvcnQKIwpDT05GSUdfRE9OR0xFPXkKQ09O
RklHX0VTSV9ET05HTEU9bQpDT05GSUdfQUNUSVNZU19ET05HTEU9bQpDT05GSUdfVEVLUkFNX0RP
TkdMRT1tCkNPTkZJR19UT0lNMzIzMl9ET05HTEU9bQpDT05GSUdfTElURUxJTktfRE9OR0xFPW0K
Q09ORklHX01BNjAwX0RPTkdMRT1tCkNPTkZJR19HSVJCSUxfRE9OR0xFPW0KQ09ORklHX01DUDIx
MjBfRE9OR0xFPW0KQ09ORklHX09MRF9CRUxLSU5fRE9OR0xFPW0KQ09ORklHX0FDVDIwMExfRE9O
R0xFPW0KQ09ORklHX0tJTkdTVU5fRE9OR0xFPW0KQ09ORklHX0tTREFaWkxFX0RPTkdMRT1tCkNP
TkZJR19LUzk1OV9ET05HTEU9bQoKIwojIEZJUiBkZXZpY2UgZHJpdmVycwojCkNPTkZJR19VU0Jf
SVJEQT1tCkNPTkZJR19TSUdNQVRFTF9GSVI9bQpDT05GSUdfTlNDX0ZJUj1tCkNPTkZJR19XSU5C
T05EX0ZJUj1tCkNPTkZJR19TTUNfSVJDQ19GSVI9bQpDT05GSUdfQUxJX0ZJUj1tCkNPTkZJR19W
TFNJX0ZJUj1tCkNPTkZJR19WSUFfRklSPW0KQ09ORklHX01DU19GSVI9bQpDT05GSUdfQlQ9bQpD
T05GSUdfQlRfTDJDQVA9bQpDT05GSUdfQlRfU0NPPW0KQ09ORklHX0JUX1JGQ09NTT1tCkNPTkZJ
R19CVF9SRkNPTU1fVFRZPXkKQ09ORklHX0JUX0JORVA9bQpDT05GSUdfQlRfQk5FUF9NQ19GSUxU
RVI9eQpDT05GSUdfQlRfQk5FUF9QUk9UT19GSUxURVI9eQpDT05GSUdfQlRfQ01UUD1tCkNPTkZJ
R19CVF9ISURQPW0KCiMKIyBCbHVldG9vdGggZGV2aWNlIGRyaXZlcnMKIwpDT05GSUdfQlRfSENJ
QlRVU0I9bQpDT05GSUdfQlRfSENJQlRTRElPPW0KQ09ORklHX0JUX0hDSVVBUlQ9bQpDT05GSUdf
QlRfSENJVUFSVF9IND15CkNPTkZJR19CVF9IQ0lVQVJUX0JDU1A9eQpDT05GSUdfQlRfSENJVUFS
VF9MTD15CkNPTkZJR19CVF9IQ0lCQ00yMDNYPW0KQ09ORklHX0JUX0hDSUJQQTEwWD1tCkNPTkZJ
R19CVF9IQ0lCRlVTQj1tCkNPTkZJR19CVF9IQ0lEVEwxPW0KQ09ORklHX0JUX0hDSUJUM0M9bQpD
T05GSUdfQlRfSENJQkxVRUNBUkQ9bQpDT05GSUdfQlRfSENJQlRVQVJUPW0KQ09ORklHX0JUX0hD
SVZIQ0k9bQojIENPTkZJR19CVF9NUlZMIGlzIG5vdCBzZXQKIyBDT05GSUdfQUZfUlhSUEMgaXMg
bm90IHNldApDT05GSUdfRklCX1JVTEVTPXkKQ09ORklHX1dJUkVMRVNTPXkKQ09ORklHX0NGRzgw
MjExPW0KIyBDT05GSUdfTkw4MDIxMV9URVNUTU9ERSBpcyBub3Qgc2V0CiMgQ09ORklHX0NGRzgw
MjExX0RFVkVMT1BFUl9XQVJOSU5HUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NGRzgwMjExX1JFR19E
RUJVRyBpcyBub3Qgc2V0CkNPTkZJR19DRkc4MDIxMV9ERUZBVUxUX1BTPXkKQ09ORklHX0NGRzgw
MjExX0RFRkFVTFRfUFNfVkFMVUU9MQpDT05GSUdfQ0ZHODAyMTFfREVCVUdGUz15CiMgQ09ORklH
X1dJUkVMRVNTX09MRF9SRUdVTEFUT1JZIGlzIG5vdCBzZXQKQ09ORklHX1dJUkVMRVNTX0VYVD15
CkNPTkZJR19XSVJFTEVTU19FWFRfU1lTRlM9eQpDT05GSUdfTElCODAyMTE9bQpDT05GSUdfTElC
ODAyMTFfQ1JZUFRfV0VQPW0KQ09ORklHX0xJQjgwMjExX0NSWVBUX0NDTVA9bQpDT05GSUdfTElC
ODAyMTFfQ1JZUFRfVEtJUD1tCiMgQ09ORklHX0xJQjgwMjExX0RFQlVHIGlzIG5vdCBzZXQKQ09O
RklHX01BQzgwMjExPW0KQ09ORklHX01BQzgwMjExX1JDX01JTlNUUkVMPXkKIyBDT05GSUdfTUFD
ODAyMTFfUkNfREVGQVVMVF9QSUQgaXMgbm90IHNldApDT05GSUdfTUFDODAyMTFfUkNfREVGQVVM
VF9NSU5TVFJFTD15CkNPTkZJR19NQUM4MDIxMV9SQ19ERUZBVUxUPSJtaW5zdHJlbCIKIyBDT05G
SUdfTUFDODAyMTFfTUVTSCBpcyBub3Qgc2V0CkNPTkZJR19NQUM4MDIxMV9MRURTPXkKQ09ORklH
X01BQzgwMjExX0RFQlVHRlM9eQojIENPTkZJR19NQUM4MDIxMV9ERUJVR19NRU5VIGlzIG5vdCBz
ZXQKQ09ORklHX1dJTUFYPW0KQ09ORklHX1dJTUFYX0RFQlVHX0xFVkVMPTgKQ09ORklHX1JGS0lM
TD1tCkNPTkZJR19SRktJTExfTEVEUz15CkNPTkZJR19SRktJTExfSU5QVVQ9eQpDT05GSUdfTkVU
XzlQPW0KQ09ORklHX05FVF85UF9WSVJUSU89bQpDT05GSUdfTkVUXzlQX1JETUE9bQojIENPTkZJ
R19ORVRfOVBfREVCVUcgaXMgbm90IHNldAoKIwojIERldmljZSBEcml2ZXJzCiMKCiMKIyBHZW5l
cmljIERyaXZlciBPcHRpb25zCiMKQ09ORklHX1VFVkVOVF9IRUxQRVJfUEFUSD0iIgojIENPTkZJ
R19ERVZUTVBGUyBpcyBub3Qgc2V0CkNPTkZJR19TVEFOREFMT05FPXkKQ09ORklHX1BSRVZFTlRf
RklSTVdBUkVfQlVJTEQ9eQpDT05GSUdfRldfTE9BREVSPXkKIyBDT05GSUdfRklSTVdBUkVfSU5f
S0VSTkVMIGlzIG5vdCBzZXQKQ09ORklHX0VYVFJBX0ZJUk1XQVJFPSIiCiMgQ09ORklHX0RFQlVH
X0RSSVZFUiBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19ERVZSRVM9eQpDT05GSUdfU1lTX0hZUEVS
VklTT1I9eQpDT05GSUdfQ09OTkVDVE9SPXkKQ09ORklHX1BST0NfRVZFTlRTPXkKQ09ORklHX01U
RD1tCiMgQ09ORklHX01URF9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9URVNUUyBpcyBu
b3Qgc2V0CkNPTkZJR19NVERfQ09OQ0FUPW0KQ09ORklHX01URF9QQVJUSVRJT05TPXkKQ09ORklH
X01URF9SRURCT09UX1BBUlRTPW0KQ09ORklHX01URF9SRURCT09UX0RJUkVDVE9SWV9CTE9DSz0t
MQojIENPTkZJR19NVERfUkVEQk9PVF9QQVJUU19VTkFMTE9DQVRFRCBpcyBub3Qgc2V0CiMgQ09O
RklHX01URF9SRURCT09UX1BBUlRTX1JFQURPTkxZIGlzIG5vdCBzZXQKQ09ORklHX01URF9BUjdf
UEFSVFM9bQoKIwojIFVzZXIgTW9kdWxlcyBBbmQgVHJhbnNsYXRpb24gTGF5ZXJzCiMKQ09ORklH
X01URF9DSEFSPW0KQ09ORklHX01URF9CTEtERVZTPW0KQ09ORklHX01URF9CTE9DSz1tCkNPTkZJ
R19NVERfQkxPQ0tfUk89bQpDT05GSUdfRlRMPW0KQ09ORklHX05GVEw9bQpDT05GSUdfTkZUTF9S
Vz15CkNPTkZJR19JTkZUTD1tCkNPTkZJR19SRkRfRlRMPW0KQ09ORklHX1NTRkRDPW0KQ09ORklH
X01URF9PT1BTPW0KCiMKIyBSQU0vUk9NL0ZsYXNoIGNoaXAgZHJpdmVycwojCkNPTkZJR19NVERf
Q0ZJPW0KQ09ORklHX01URF9KRURFQ1BST0JFPW0KQ09ORklHX01URF9HRU5fUFJPQkU9bQojIENP
TkZJR19NVERfQ0ZJX0FEVl9PUFRJT05TIGlzIG5vdCBzZXQKQ09ORklHX01URF9NQVBfQkFOS19X
SURUSF8xPXkKQ09ORklHX01URF9NQVBfQkFOS19XSURUSF8yPXkKQ09ORklHX01URF9NQVBfQkFO
S19XSURUSF80PXkKIyBDT05GSUdfTVREX01BUF9CQU5LX1dJRFRIXzggaXMgbm90IHNldAojIENP
TkZJR19NVERfTUFQX0JBTktfV0lEVEhfMTYgaXMgbm90IHNldAojIENPTkZJR19NVERfTUFQX0JB
TktfV0lEVEhfMzIgaXMgbm90IHNldApDT05GSUdfTVREX0NGSV9JMT15CkNPTkZJR19NVERfQ0ZJ
X0kyPXkKIyBDT05GSUdfTVREX0NGSV9JNCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9DRklfSTgg
aXMgbm90IHNldApDT05GSUdfTVREX0NGSV9JTlRFTEVYVD1tCkNPTkZJR19NVERfQ0ZJX0FNRFNU
RD1tCkNPTkZJR19NVERfQ0ZJX1NUQUE9bQpDT05GSUdfTVREX0NGSV9VVElMPW0KQ09ORklHX01U
RF9SQU09bQpDT05GSUdfTVREX1JPTT1tCkNPTkZJR19NVERfQUJTRU5UPW0KCiMKIyBNYXBwaW5n
IGRyaXZlcnMgZm9yIGNoaXAgYWNjZXNzCiMKQ09ORklHX01URF9DT01QTEVYX01BUFBJTkdTPXkK
IyBDT05GSUdfTVREX1BIWVNNQVAgaXMgbm90IHNldApDT05GSUdfTVREX1NDNTIwQ0RQPW0KQ09O
RklHX01URF9ORVRTQzUyMD1tCkNPTkZJR19NVERfVFM1NTAwPW0KIyBDT05GSUdfTVREX1NCQ19H
WFggaXMgbm90IHNldAojIENPTkZJR19NVERfQU1ENzZYUk9NIGlzIG5vdCBzZXQKIyBDT05GSUdf
TVREX0lDSFhST00gaXMgbm90IHNldApDT05GSUdfTVREX0VTQjJST009bQpDT05GSUdfTVREX0NL
ODA0WFJPTT1tCkNPTkZJR19NVERfU0NCMl9GTEFTSD1tCiMgQ09ORklHX01URF9ORVR0ZWwgaXMg
bm90IHNldAojIENPTkZJR19NVERfTDQ0MEdYIGlzIG5vdCBzZXQKQ09ORklHX01URF9QQ0k9bQoj
IENPTkZJR19NVERfSU5URUxfVlJfTk9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX1BMQVRSQU0g
aXMgbm90IHNldAoKIwojIFNlbGYtY29udGFpbmVkIE1URCBkZXZpY2UgZHJpdmVycwojCkNPTkZJ
R19NVERfUE1DNTUxPW0KIyBDT05GSUdfTVREX1BNQzU1MV9CVUdGSVggaXMgbm90IHNldAojIENP
TkZJR19NVERfUE1DNTUxX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX1NMUkFNIGlzIG5v
dCBzZXQKIyBDT05GSUdfTVREX1BIUkFNIGlzIG5vdCBzZXQKQ09ORklHX01URF9NVERSQU09bQpD
T05GSUdfTVREUkFNX1RPVEFMX1NJWkU9NDA5NgpDT05GSUdfTVREUkFNX0VSQVNFX1NJWkU9MTI4
CkNPTkZJR19NVERfQkxPQ0syTVREPW0KCiMKIyBEaXNrLU9uLUNoaXAgRGV2aWNlIERyaXZlcnMK
IwojIENPTkZJR19NVERfRE9DMjAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9ET0MyMDAxIGlz
IG5vdCBzZXQKIyBDT05GSUdfTVREX0RPQzIwMDFQTFVTIGlzIG5vdCBzZXQKQ09ORklHX01URF9O
QU5EPW0KIyBDT05GSUdfTVREX05BTkRfVkVSSUZZX1dSSVRFIGlzIG5vdCBzZXQKQ09ORklHX01U
RF9OQU5EX0VDQ19TTUM9eQojIENPTkZJR19NVERfTkFORF9NVVNFVU1fSURTIGlzIG5vdCBzZXQK
Q09ORklHX01URF9OQU5EX0lEUz1tCkNPTkZJR19NVERfTkFORF9ESVNLT05DSElQPW0KIyBDT05G
SUdfTVREX05BTkRfRElTS09OQ0hJUF9QUk9CRV9BRFZBTkNFRCBpcyBub3Qgc2V0CkNPTkZJR19N
VERfTkFORF9ESVNLT05DSElQX1BST0JFX0FERFJFU1M9MAojIENPTkZJR19NVERfTkFORF9ESVNL
T05DSElQX0JCVFdSSVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX05BTkRfQ0FGRSBpcyBub3Qg
c2V0CkNPTkZJR19NVERfTkFORF9OQU5EU0lNPW0KIyBDT05GSUdfTVREX05BTkRfUExBVEZPUk0g
aXMgbm90IHNldApDT05GSUdfTVREX0FMQVVEQT1tCiMgQ09ORklHX01URF9PTkVOQU5EIGlzIG5v
dCBzZXQKCiMKIyBMUEREUiBmbGFzaCBtZW1vcnkgZHJpdmVycwojCkNPTkZJR19NVERfTFBERFI9
bQpDT05GSUdfTVREX1FJTkZPX1BST0JFPW0KCiMKIyBVQkkgLSBVbnNvcnRlZCBibG9jayBpbWFn
ZXMKIwpDT05GSUdfTVREX1VCST1tCkNPTkZJR19NVERfVUJJX1dMX1RIUkVTSE9MRD00MDk2CkNP
TkZJR19NVERfVUJJX0JFQl9SRVNFUlZFPTEKIyBDT05GSUdfTVREX1VCSV9HTFVFQkkgaXMgbm90
IHNldAoKIwojIFVCSSBkZWJ1Z2dpbmcgb3B0aW9ucwojCiMgQ09ORklHX01URF9VQklfREVCVUcg
aXMgbm90IHNldApDT05GSUdfUEFSUE9SVD1tCkNPTkZJR19QQVJQT1JUX1BDPW0KQ09ORklHX1BB
UlBPUlRfU0VSSUFMPW0KIyBDT05GSUdfUEFSUE9SVF9QQ19GSUZPIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEFSUE9SVF9QQ19TVVBFUklPIGlzIG5vdCBzZXQKQ09ORklHX1BBUlBPUlRfUENfUENNQ0lB
PW0KIyBDT05GSUdfUEFSUE9SVF9HU0MgaXMgbm90IHNldAojIENPTkZJR19QQVJQT1JUX0FYODg3
OTYgaXMgbm90IHNldApDT05GSUdfUEFSUE9SVF8xMjg0PXkKQ09ORklHX1BBUlBPUlRfTk9UX1BD
PXkKQ09ORklHX1BOUD15CiMgQ09ORklHX1BOUF9ERUJVR19NRVNTQUdFUyBpcyBub3Qgc2V0Cgoj
CiMgUHJvdG9jb2xzCiMKQ09ORklHX1BOUEFDUEk9eQpDT05GSUdfQkxLX0RFVj15CkNPTkZJR19C
TEtfREVWX0ZEPW0KQ09ORklHX1BBUklERT1tCgojCiMgUGFyYWxsZWwgSURFIGhpZ2gtbGV2ZWwg
ZHJpdmVycwojCkNPTkZJR19QQVJJREVfUEQ9bQpDT05GSUdfUEFSSURFX1BDRD1tCkNPTkZJR19Q
QVJJREVfUEY9bQpDT05GSUdfUEFSSURFX1BUPW0KQ09ORklHX1BBUklERV9QRz1tCgojCiMgUGFy
YWxsZWwgSURFIHByb3RvY29sIG1vZHVsZXMKIwpDT05GSUdfUEFSSURFX0FURU49bQpDT05GSUdf
UEFSSURFX0JQQ0s9bQpDT05GSUdfUEFSSURFX0NPTU09bQpDT05GSUdfUEFSSURFX0RTVFI9bQpD
T05GSUdfUEFSSURFX0ZJVDI9bQpDT05GSUdfUEFSSURFX0ZJVDM9bQpDT05GSUdfUEFSSURFX0VQ
QVQ9bQpDT05GSUdfUEFSSURFX0VQQVRDOD15CkNPTkZJR19QQVJJREVfRVBJQT1tCkNPTkZJR19Q
QVJJREVfRlJJUT1tCkNPTkZJR19QQVJJREVfRlJQVz1tCkNPTkZJR19QQVJJREVfS0JJQz1tCkNP
TkZJR19QQVJJREVfS1RUST1tCkNPTkZJR19QQVJJREVfT04yMD1tCkNPTkZJR19QQVJJREVfT04y
Nj1tCkNPTkZJR19CTEtfQ1BRX0RBPW0KQ09ORklHX0JMS19DUFFfQ0lTU19EQT1tCkNPTkZJR19D
SVNTX1NDU0lfVEFQRT15CkNPTkZJR19CTEtfREVWX0RBQzk2MD1tCkNPTkZJR19CTEtfREVWX1VN
RU09bQojIENPTkZJR19CTEtfREVWX0NPV19DT01NT04gaXMgbm90IHNldApDT05GSUdfQkxLX0RF
Vl9MT09QPXkKQ09ORklHX0JMS19ERVZfQ1JZUFRPTE9PUD1tCkNPTkZJR19CTEtfREVWX05CRD1t
CkNPTkZJR19CTEtfREVWX09TRD1tCkNPTkZJR19CTEtfREVWX1NYOD1tCiMgQ09ORklHX0JMS19E
RVZfVUIgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9SQU09eQpDT05GSUdfQkxLX0RFVl9SQU1f
Q09VTlQ9MTYKQ09ORklHX0JMS19ERVZfUkFNX1NJWkU9MTYzODQKIyBDT05GSUdfQkxLX0RFVl9Y
SVAgaXMgbm90IHNldApDT05GSUdfQ0RST01fUEtUQ0RWRD1tCkNPTkZJR19DRFJPTV9QS1RDRFZE
X0JVRkZFUlM9OAojIENPTkZJR19DRFJPTV9QS1RDRFZEX1dDQUNIRSBpcyBub3Qgc2V0CkNPTkZJ
R19BVEFfT1ZFUl9FVEg9bQpDT05GSUdfWEVOX0JMS0RFVl9GUk9OVEVORD1tCkNPTkZJR19WSVJU
SU9fQkxLPW0KIyBDT05GSUdfQkxLX0RFVl9IRCBpcyBub3Qgc2V0CkNPTkZJR19NSVNDX0RFVklD
RVM9eQojIENPTkZJR19JQk1fQVNNIGlzIG5vdCBzZXQKIyBDT05GSUdfUEhBTlRPTSBpcyBub3Qg
c2V0CkNPTkZJR19TR0lfSU9DND1tCkNPTkZJR19USUZNX0NPUkU9bQpDT05GSUdfVElGTV83WFgx
PW0KQ09ORklHX0lDUzkzMlM0MDE9bQpDT05GSUdfRU5DTE9TVVJFX1NFUlZJQ0VTPW0KIyBDT05G
SUdfSFBfSUxPIGlzIG5vdCBzZXQKQ09ORklHX0RFTExfTEFQVE9QPW0KQ09ORklHX0lTTDI5MDAz
PW0KIyBDT05GSUdfQzJQT1JUIGlzIG5vdCBzZXQKCiMKIyBFRVBST00gc3VwcG9ydAojCkNPTkZJ
R19FRVBST01fQVQyND1tCkNPTkZJR19FRVBST01fTEVHQUNZPW0KQ09ORklHX0VFUFJPTV9NQVg2
ODc1PW0KQ09ORklHX0VFUFJPTV85M0NYNj1tCkNPTkZJR19DQjcxMF9DT1JFPW0KIyBDT05GSUdf
Q0I3MTBfREVCVUcgaXMgbm90IHNldApDT05GSUdfQ0I3MTBfREVCVUdfQVNTVU1QVElPTlM9eQpD
T05GSUdfSEFWRV9JREU9eQojIENPTkZJR19JREUgaXMgbm90IHNldAoKIwojIFNDU0kgZGV2aWNl
IHN1cHBvcnQKIwpDT05GSUdfUkFJRF9BVFRSUz1tCkNPTkZJR19TQ1NJPXkKQ09ORklHX1NDU0lf
RE1BPXkKQ09ORklHX1NDU0lfVEdUPW0KQ09ORklHX1NDU0lfTkVUTElOSz15CkNPTkZJR19TQ1NJ
X1BST0NfRlM9eQoKIwojIFNDU0kgc3VwcG9ydCB0eXBlIChkaXNrLCB0YXBlLCBDRC1ST00pCiMK
Q09ORklHX0JMS19ERVZfU0Q9eQpDT05GSUdfQ0hSX0RFVl9TVD1tCkNPTkZJR19DSFJfREVWX09T
U1Q9bQpDT05GSUdfQkxLX0RFVl9TUj15CkNPTkZJR19CTEtfREVWX1NSX1ZFTkRPUj15CkNPTkZJ
R19DSFJfREVWX1NHPXkKQ09ORklHX0NIUl9ERVZfU0NIPW0KQ09ORklHX1NDU0lfRU5DTE9TVVJF
PW0KQ09ORklHX1NDU0lfTVVMVElfTFVOPXkKQ09ORklHX1NDU0lfQ09OU1RBTlRTPXkKQ09ORklH
X1NDU0lfTE9HR0lORz15CkNPTkZJR19TQ1NJX1NDQU5fQVNZTkM9eQpDT05GSUdfU0NTSV9XQUlU
X1NDQU49bQoKIwojIFNDU0kgVHJhbnNwb3J0cwojCkNPTkZJR19TQ1NJX1NQSV9BVFRSUz1tCkNP
TkZJR19TQ1NJX0ZDX0FUVFJTPW0KQ09ORklHX1NDU0lfRkNfVEdUX0FUVFJTPXkKQ09ORklHX1ND
U0lfSVNDU0lfQVRUUlM9bQpDT05GSUdfU0NTSV9TQVNfQVRUUlM9bQpDT05GSUdfU0NTSV9TQVNf
TElCU0FTPW0KQ09ORklHX1NDU0lfU0FTX0FUQT15CkNPTkZJR19TQ1NJX1NBU19IT1NUX1NNUD15
CiMgQ09ORklHX1NDU0lfU0FTX0xJQlNBU19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX1NS
UF9BVFRSUz1tCkNPTkZJR19TQ1NJX1NSUF9UR1RfQVRUUlM9eQpDT05GSUdfU0NTSV9MT1dMRVZF
TD15CkNPTkZJR19JU0NTSV9UQ1A9bQpDT05GSUdfU0NTSV9DWEdCM19JU0NTST1tCkNPTkZJR19T
Q1NJX0JOWDJfSVNDU0k9bQojIENPTkZJR19CRTJJU0NTSSBpcyBub3Qgc2V0CkNPTkZJR19CTEtf
REVWXzNXX1hYWFhfUkFJRD1tCkNPTkZJR19TQ1NJXzNXXzlYWFg9bQpDT05GSUdfU0NTSV9BQ0FS
RD1tCkNPTkZJR19TQ1NJX0FBQ1JBSUQ9bQpDT05GSUdfU0NTSV9BSUM3WFhYPW0KQ09ORklHX0FJ
QzdYWFhfQ01EU19QRVJfREVWSUNFPTQKQ09ORklHX0FJQzdYWFhfUkVTRVRfREVMQVlfTVM9MTUw
MDAKIyBDT05GSUdfQUlDN1hYWF9ERUJVR19FTkFCTEUgaXMgbm90IHNldApDT05GSUdfQUlDN1hY
WF9ERUJVR19NQVNLPTAKIyBDT05GSUdfQUlDN1hYWF9SRUdfUFJFVFRZX1BSSU5UIGlzIG5vdCBz
ZXQKQ09ORklHX1NDU0lfQUlDN1hYWF9PTEQ9bQpDT05GSUdfU0NTSV9BSUM3OVhYPW0KQ09ORklH
X0FJQzc5WFhfQ01EU19QRVJfREVWSUNFPTQKQ09ORklHX0FJQzc5WFhfUkVTRVRfREVMQVlfTVM9
MTUwMDAKIyBDT05GSUdfQUlDNzlYWF9ERUJVR19FTkFCTEUgaXMgbm90IHNldApDT05GSUdfQUlD
NzlYWF9ERUJVR19NQVNLPTAKIyBDT05GSUdfQUlDNzlYWF9SRUdfUFJFVFRZX1BSSU5UIGlzIG5v
dCBzZXQKQ09ORklHX1NDU0lfQUlDOTRYWD1tCiMgQ09ORklHX0FJQzk0WFhfREVCVUcgaXMgbm90
IHNldApDT05GSUdfU0NTSV9NVlNBUz1tCiMgQ09ORklHX1NDU0lfTVZTQVNfREVCVUcgaXMgbm90
IHNldAojIENPTkZJR19TQ1NJX0RQVF9JMk8gaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FEVkFO
U1lTIGlzIG5vdCBzZXQKQ09ORklHX1NDU0lfQVJDTVNSPW0KQ09ORklHX1NDU0lfQVJDTVNSX0FF
Uj15CkNPTkZJR19NRUdBUkFJRF9ORVdHRU49eQpDT05GSUdfTUVHQVJBSURfTU09bQpDT05GSUdf
TUVHQVJBSURfTUFJTEJPWD1tCkNPTkZJR19NRUdBUkFJRF9MRUdBQ1k9bQpDT05GSUdfTUVHQVJB
SURfU0FTPW0KQ09ORklHX1NDU0lfTVBUMlNBUz1tCkNPTkZJR19TQ1NJX01QVDJTQVNfTUFYX1NH
RT0xMjgKQ09ORklHX1NDU0lfTVBUMlNBU19MT0dHSU5HPXkKQ09ORklHX1NDU0lfSFBUSU9QPW0K
Q09ORklHX1NDU0lfQlVTTE9HSUM9bQpDT05GSUdfTElCRkM9bQpDT05GSUdfTElCRkNPRT1tCkNP
TkZJR19GQ09FPW0KQ09ORklHX0ZDT0VfRk5JQz1tCiMgQ09ORklHX1NDU0lfRE1YMzE5MUQgaXMg
bm90IHNldAojIENPTkZJR19TQ1NJX0VBVEEgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0ZVVFVS
RV9ET01BSU4gaXMgbm90IHNldApDT05GSUdfU0NTSV9HRFRIPW0KQ09ORklHX1NDU0lfSVBTPW0K
Q09ORklHX1NDU0lfSU5JVElPPW0KQ09ORklHX1NDU0lfSU5JQTEwMD1tCkNPTkZJR19TQ1NJX1BQ
QT1tCkNPTkZJR19TQ1NJX0lNTT1tCiMgQ09ORklHX1NDU0lfSVpJUF9FUFAxNiBpcyBub3Qgc2V0
CiMgQ09ORklHX1NDU0lfSVpJUF9TTE9XX0NUUiBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX1NURVg9
bQpDT05GSUdfU0NTSV9TWU01M0M4WFhfMj1tCkNPTkZJR19TQ1NJX1NZTTUzQzhYWF9ETUFfQURE
UkVTU0lOR19NT0RFPTEKQ09ORklHX1NDU0lfU1lNNTNDOFhYX0RFRkFVTFRfVEFHUz0xNgpDT05G
SUdfU0NTSV9TWU01M0M4WFhfTUFYX1RBR1M9NjQKQ09ORklHX1NDU0lfU1lNNTNDOFhYX01NSU89
eQojIENPTkZJR19TQ1NJX0lQUiBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX1FMT0dJQ18xMjgwPW0K
Q09ORklHX1NDU0lfUUxBX0ZDPW0KQ09ORklHX1NDU0lfUUxBX0lTQ1NJPW0KQ09ORklHX1NDU0lf
TFBGQz1tCiMgQ09ORklHX1NDU0lfTFBGQ19ERUJVR19GUyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJ
X0RDMzk1eD1tCkNPTkZJR19TQ1NJX0RDMzkwVD1tCkNPTkZJR19TQ1NJX0RFQlVHPW0KIyBDT05G
SUdfU0NTSV9QTUNSQUlEIGlzIG5vdCBzZXQKQ09ORklHX1NDU0lfU1JQPW0KIyBDT05GSUdfU0NT
SV9CRkFfRkMgaXMgbm90IHNldApDT05GSUdfU0NTSV9MT1dMRVZFTF9QQ01DSUE9eQojIENPTkZJ
R19QQ01DSUFfRkRPTUFJTiBpcyBub3Qgc2V0CkNPTkZJR19QQ01DSUFfUUxPR0lDPW0KQ09ORklH
X1BDTUNJQV9TWU01M0M1MDA9bQpDT05GSUdfU0NTSV9ESD15CkNPTkZJR19TQ1NJX0RIX1JEQUM9
bQpDT05GSUdfU0NTSV9ESF9IUF9TVz1tCkNPTkZJR19TQ1NJX0RIX0VNQz1tCkNPTkZJR19TQ1NJ
X0RIX0FMVUE9bQpDT05GSUdfU0NTSV9PU0RfSU5JVElBVE9SPW0KQ09ORklHX1NDU0lfT1NEX1VM
RD1tCkNPTkZJR19TQ1NJX09TRF9EUFJJTlRfU0VOU0U9MQojIENPTkZJR19TQ1NJX09TRF9ERUJV
RyBpcyBub3Qgc2V0CkNPTkZJR19BVEE9eQojIENPTkZJR19BVEFfTk9OU1RBTkRBUkQgaXMgbm90
IHNldApDT05GSUdfQVRBX1ZFUkJPU0VfRVJST1I9eQpDT05GSUdfQVRBX0FDUEk9eQpDT05GSUdf
U0FUQV9QTVA9eQpDT05GSUdfU0FUQV9BSENJPXkKQ09ORklHX1NBVEFfU0lMMjQ9bQpDT05GSUdf
QVRBX1NGRj15CkNPTkZJR19TQVRBX1NWVz1tCkNPTkZJR19BVEFfUElJWD15CkNPTkZJR19TQVRB
X01WPW0KQ09ORklHX1NBVEFfTlY9bQpDT05GSUdfUERDX0FETUE9bQpDT05GSUdfU0FUQV9RU1RP
Uj1tCkNPTkZJR19TQVRBX1BST01JU0U9bQpDT05GSUdfU0FUQV9TWDQ9bQpDT05GSUdfU0FUQV9T
SUw9bQpDT05GSUdfU0FUQV9TSVM9bQpDT05GSUdfU0FUQV9VTEk9bQpDT05GSUdfU0FUQV9WSUE9
bQpDT05GSUdfU0FUQV9WSVRFU1NFPW0KQ09ORklHX1NBVEFfSU5JQzE2Mlg9bQpDT05GSUdfUEFU
QV9BQ1BJPW0KQ09ORklHX1BBVEFfQUxJPW0KQ09ORklHX1BBVEFfQU1EPW0KQ09ORklHX1BBVEFf
QVJUT1A9bQojIENPTkZJR19QQVRBX0FUUDg2N1ggaXMgbm90IHNldApDT05GSUdfUEFUQV9BVElJ
WFA9bQpDT05GSUdfUEFUQV9DTUQ2NDBfUENJPW0KQ09ORklHX1BBVEFfQ01ENjRYPW0KQ09ORklH
X1BBVEFfQ1M1NTIwPW0KQ09ORklHX1BBVEFfQ1M1NTMwPW0KQ09ORklHX1BBVEFfQ1lQUkVTUz1t
CkNPTkZJR19QQVRBX0VGQVI9bQpDT05GSUdfQVRBX0dFTkVSSUM9bQpDT05GSUdfUEFUQV9IUFQz
NjY9bQpDT05GSUdfUEFUQV9IUFQzN1g9bQpDT05GSUdfUEFUQV9IUFQzWDJOPW0KQ09ORklHX1BB
VEFfSFBUM1gzPW0KIyBDT05GSUdfUEFUQV9IUFQzWDNfRE1BIGlzIG5vdCBzZXQKQ09ORklHX1BB
VEFfSVQ4MjFYPW0KQ09ORklHX1BBVEFfSVQ4MjEzPW0KQ09ORklHX1BBVEFfSk1JQ1JPTj1tCkNP
TkZJR19QQVRBX1RSSUZMRVg9bQpDT05GSUdfUEFUQV9NQVJWRUxMPW0KQ09ORklHX1BBVEFfTVBJ
SVg9bQpDT05GSUdfUEFUQV9PTERQSUlYPW0KQ09ORklHX1BBVEFfTkVUQ0VMTD1tCkNPTkZJR19Q
QVRBX05JTkpBMzI9bQpDT05GSUdfUEFUQV9OUzg3NDEwPW0KQ09ORklHX1BBVEFfTlM4NzQxNT1t
CkNPTkZJR19QQVRBX09QVEk9bQpDT05GSUdfUEFUQV9PUFRJRE1BPW0KQ09ORklHX1BBVEFfUENN
Q0lBPW0KQ09ORklHX1BBVEFfUERDX09MRD1tCiMgQ09ORklHX1BBVEFfUkFESVNZUyBpcyBub3Qg
c2V0CiMgQ09ORklHX1BBVEFfUkRDIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9SWjEwMDAgaXMg
bm90IHNldAojIENPTkZJR19QQVRBX1NDMTIwMCBpcyBub3Qgc2V0CkNPTkZJR19QQVRBX1NFUlZF
UldPUktTPW0KQ09ORklHX1BBVEFfUERDMjAyN1g9bQpDT05GSUdfUEFUQV9TSUw2ODA9bQpDT05G
SUdfUEFUQV9TSVM9bQpDT05GSUdfUEFUQV9WSUE9bQpDT05GSUdfUEFUQV9XSU5CT05EPW0KQ09O
RklHX1BBVEFfU0NIPW0KQ09ORklHX01EPXkKQ09ORklHX0JMS19ERVZfTUQ9eQpDT05GSUdfTURf
QVVUT0RFVEVDVD15CkNPTkZJR19NRF9MSU5FQVI9bQpDT05GSUdfTURfUkFJRDA9bQpDT05GSUdf
TURfUkFJRDE9bQpDT05GSUdfTURfUkFJRDEwPW0KQ09ORklHX01EX1JBSUQ0NTY9bQojIENPTkZJ
R19NVUxUSUNPUkVfUkFJRDQ1NiBpcyBub3Qgc2V0CkNPTkZJR19NRF9SQUlENl9QUT1tCiMgQ09O
RklHX0FTWU5DX1JBSUQ2X1RFU1QgaXMgbm90IHNldApDT05GSUdfTURfTVVMVElQQVRIPW0KQ09O
RklHX01EX0ZBVUxUWT1tCkNPTkZJR19CTEtfREVWX0RNPXkKQ09ORklHX0RNX0RFQlVHPXkKQ09O
RklHX0RNX0NSWVBUPW0KQ09ORklHX0RNX1NOQVBTSE9UPXkKQ09ORklHX0RNX01JUlJPUj15CkNP
TkZJR19ETV9MT0dfVVNFUlNQQUNFPW0KQ09ORklHX0RNX1pFUk89eQpDT05GSUdfRE1fTVVMVElQ
QVRIPW0KQ09ORklHX0RNX01VTFRJUEFUSF9RTD1tCkNPTkZJR19ETV9NVUxUSVBBVEhfU1Q9bQoj
IENPTkZJR19ETV9ERUxBWSBpcyBub3Qgc2V0CkNPTkZJR19ETV9VRVZFTlQ9eQpDT05GSUdfRlVT
SU9OPXkKQ09ORklHX0ZVU0lPTl9TUEk9bQpDT05GSUdfRlVTSU9OX0ZDPW0KQ09ORklHX0ZVU0lP
Tl9TQVM9bQpDT05GSUdfRlVTSU9OX01BWF9TR0U9NDAKQ09ORklHX0ZVU0lPTl9DVEw9bQpDT05G
SUdfRlVTSU9OX0xBTj1tCkNPTkZJR19GVVNJT05fTE9HR0lORz15CgojCiMgSUVFRSAxMzk0IChG
aXJlV2lyZSkgc3VwcG9ydAojCgojCiMgWW91IGNhbiBlbmFibGUgb25lIG9yIGJvdGggRmlyZVdp
cmUgZHJpdmVyIHN0YWNrcy4KIwoKIwojIFNlZSB0aGUgaGVscCB0ZXh0cyBmb3IgbW9yZSBpbmZv
cm1hdGlvbi4KIwpDT05GSUdfRklSRVdJUkU9bQpDT05GSUdfRklSRVdJUkVfT0hDST1tCkNPTkZJ
R19GSVJFV0lSRV9PSENJX0RFQlVHPXkKQ09ORklHX0ZJUkVXSVJFX1NCUDI9bQpDT05GSUdfRklS
RVdJUkVfTkVUPW0KIyBDT05GSUdfSUVFRTEzOTQgaXMgbm90IHNldApDT05GSUdfSTJPPW0KIyBD
T05GSUdfSTJPX0xDVF9OT1RJRllfT05fQ0hBTkdFUyBpcyBub3Qgc2V0CkNPTkZJR19JMk9fRVhU
X0FEQVBURUM9eQpDT05GSUdfSTJPX0VYVF9BREFQVEVDX0RNQTY0PXkKQ09ORklHX0kyT19DT05G
SUc9bQpDT05GSUdfSTJPX0NPTkZJR19PTERfSU9DVEw9eQpDT05GSUdfSTJPX0JVUz1tCkNPTkZJ
R19JMk9fQkxPQ0s9bQpDT05GSUdfSTJPX1NDU0k9bQpDT05GSUdfSTJPX1BST0M9bQpDT05GSUdf
TUFDSU5UT1NIX0RSSVZFUlM9eQpDT05GSUdfTUFDX0VNVU1PVVNFQlROPXkKQ09ORklHX05FVERF
VklDRVM9eQpDT05GSUdfSUZCPW0KQ09ORklHX0RVTU1ZPW0KQ09ORklHX0JPTkRJTkc9bQpDT05G
SUdfTUFDVkxBTj1tCkNPTkZJR19FUVVBTElaRVI9bQpDT05GSUdfVFVOPW0KQ09ORklHX1ZFVEg9
bQpDT05GSUdfTkVUX1NCMTAwMD1tCiMgQ09ORklHX0FSQ05FVCBpcyBub3Qgc2V0CkNPTkZJR19Q
SFlMSUI9eQoKIwojIE1JSSBQSFkgZGV2aWNlIGRyaXZlcnMKIwpDT05GSUdfTUFSVkVMTF9QSFk9
bQpDT05GSUdfREFWSUNPTV9QSFk9bQpDT05GSUdfUVNFTUlfUEhZPW0KQ09ORklHX0xYVF9QSFk9
bQpDT05GSUdfQ0lDQURBX1BIWT1tCkNPTkZJR19WSVRFU1NFX1BIWT1tCkNPTkZJR19TTVNDX1BI
WT1tCkNPTkZJR19CUk9BRENPTV9QSFk9bQpDT05GSUdfSUNQTFVTX1BIWT1tCkNPTkZJR19SRUFM
VEVLX1BIWT1tCkNPTkZJR19OQVRJT05BTF9QSFk9bQpDT05GSUdfU1RFMTBYUD1tCkNPTkZJR19M
U0lfRVQxMDExQ19QSFk9bQpDT05GSUdfRklYRURfUEhZPXkKQ09ORklHX01ESU9fQklUQkFORz1t
CkNPTkZJR19ORVRfRVRIRVJORVQ9eQpDT05GSUdfTUlJPW0KQ09ORklHX0hBUFBZTUVBTD1tCkNP
TkZJR19TVU5HRU09bQpDT05GSUdfQ0FTU0lOST1tCkNPTkZJR19ORVRfVkVORE9SXzNDT009eQpD
T05GSUdfVk9SVEVYPW0KQ09ORklHX1RZUEhPT049bQpDT05GSUdfRVRIT0M9bQpDT05GSUdfRE5F
VD1tCkNPTkZJR19ORVRfVFVMSVA9eQpDT05GSUdfREUyMTA0WD1tCkNPTkZJR19ERTIxMDRYX0RT
TD0wCkNPTkZJR19UVUxJUD1tCiMgQ09ORklHX1RVTElQX01XSSBpcyBub3Qgc2V0CkNPTkZJR19U
VUxJUF9NTUlPPXkKIyBDT05GSUdfVFVMSVBfTkFQSSBpcyBub3Qgc2V0CkNPTkZJR19ERTRYNT1t
CkNPTkZJR19XSU5CT05EXzg0MD1tCkNPTkZJR19ETTkxMDI9bQpDT05GSUdfVUxJNTI2WD1tCkNP
TkZJR19QQ01DSUFfWElSQ09NPW0KIyBDT05GSUdfSFAxMDAgaXMgbm90IHNldAojIENPTkZJR19J
Qk1fTkVXX0VNQUNfWk1JSSBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19SR01JSSBp
cyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19UQUggaXMgbm90IHNldAojIENPTkZJR19J
Qk1fTkVXX0VNQUNfRU1BQzQgaXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfTk9fRkxP
V19DVFJMIGlzIG5vdCBzZXQKIyBDT05GSUdfSUJNX05FV19FTUFDX01BTF9DTFJfSUNJTlRTVEFU
IGlzIG5vdCBzZXQKIyBDT05GSUdfSUJNX05FV19FTUFDX01BTF9DT01NT05fRVJSIGlzIG5vdCBz
ZXQKQ09ORklHX05FVF9QQ0k9eQpDT05GSUdfUENORVQzMj1tCkNPTkZJR19BTUQ4MTExX0VUSD1t
CkNPTkZJR19BREFQVEVDX1NUQVJGSVJFPW0KQ09ORklHX0I0ND1tCkNPTkZJR19CNDRfUENJX0FV
VE9TRUxFQ1Q9eQpDT05GSUdfQjQ0X1BDSUNPUkVfQVVUT1NFTEVDVD15CkNPTkZJR19CNDRfUENJ
PXkKQ09ORklHX0ZPUkNFREVUSD1tCkNPTkZJR19GT1JDRURFVEhfTkFQST15CkNPTkZJR19FMTAw
PW0KQ09ORklHX0ZFQUxOWD1tCkNPTkZJR19OQVRTRU1JPW0KQ09ORklHX05FMktfUENJPW0KQ09O
RklHXzgxMzlDUD1tCkNPTkZJR184MTM5VE9PPW0KIyBDT05GSUdfODEzOVRPT19QSU8gaXMgbm90
IHNldAojIENPTkZJR184MTM5VE9PX1RVTkVfVFdJU1RFUiBpcyBub3Qgc2V0CkNPTkZJR184MTM5
VE9PXzgxMjk9eQojIENPTkZJR184MTM5X09MRF9SWF9SRVNFVCBpcyBub3Qgc2V0CkNPTkZJR19S
NjA0MD1tCkNPTkZJR19TSVM5MDA9bQpDT05GSUdfRVBJQzEwMD1tCkNPTkZJR19TTVNDOTQyMD1t
CkNPTkZJR19TVU5EQU5DRT1tCiMgQ09ORklHX1NVTkRBTkNFX01NSU8gaXMgbm90IHNldApDT05G
SUdfVExBTj1tCiMgQ09ORklHX0tTODg0MiBpcyBub3Qgc2V0CiMgQ09ORklHX0tTODg1MV9NTEwg
aXMgbm90IHNldApDT05GSUdfVklBX1JISU5FPW0KQ09ORklHX1ZJQV9SSElORV9NTUlPPXkKQ09O
RklHX1NDOTIwMzE9bQpDT05GSUdfTkVUX1BPQ0tFVD15CkNPTkZJR19BVFA9bQpDT05GSUdfREU2
MDA9bQpDT05GSUdfREU2MjA9bQpDT05GSUdfQVRMMj1tCkNPTkZJR19ORVRERVZfMTAwMD15CkNP
TkZJR19BQ0VOSUM9bQojIENPTkZJR19BQ0VOSUNfT01JVF9USUdPTl9JIGlzIG5vdCBzZXQKQ09O
RklHX0RMMks9bQpDT05GSUdfRTEwMDA9bQpDT05GSUdfRTEwMDBFPW0KQ09ORklHX0lQMTAwMD1t
CkNPTkZJR19JR0I9bQpDT05GSUdfSUdCX0RDQT15CkNPTkZJR19JR0JWRj1tCkNPTkZJR19OUzgz
ODIwPW0KQ09ORklHX0hBTUFDSEk9bQpDT05GSUdfWUVMTE9XRklOPW0KQ09ORklHX1I4MTY5PW0K
Q09ORklHX1I4MTY5X1ZMQU49eQpDT05GSUdfU0lTMTkwPW0KQ09ORklHX1NLR0U9bQojIENPTkZJ
R19TS0dFX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1NLWTI9bQojIENPTkZJR19TS1kyX0RFQlVH
IGlzIG5vdCBzZXQKQ09ORklHX1ZJQV9WRUxPQ0lUWT1tCkNPTkZJR19USUdPTjM9bQpDT05GSUdf
Qk5YMj1tCkNPTkZJR19DTklDPW0KQ09ORklHX1FMQTNYWFg9bQpDT05GSUdfQVRMMT1tCkNPTkZJ
R19BVEwxRT1tCkNPTkZJR19BVEwxQz1tCkNPTkZJR19KTUU9bQpDT05GSUdfTkVUREVWXzEwMDAw
PXkKQ09ORklHX01ESU89bQpDT05GSUdfQ0hFTFNJT19UMT1tCkNPTkZJR19DSEVMU0lPX1QxXzFH
PXkKQ09ORklHX0NIRUxTSU9fVDNfREVQRU5EUz15CkNPTkZJR19DSEVMU0lPX1QzPW0KQ09ORklH
X0VOSUM9bQpDT05GSUdfSVhHQkU9bQpDT05GSUdfSVhHQkVfRENBPXkKQ09ORklHX0lYR0JFX0RD
Qj15CkNPTkZJR19JWEdCPW0KQ09ORklHX1MySU89bQpDT05GSUdfVlhHRT1tCiMgQ09ORklHX1ZY
R0VfREVCVUdfVFJBQ0VfQUxMIGlzIG5vdCBzZXQKQ09ORklHX01ZUkkxMEdFPW0KQ09ORklHX01Z
UkkxMEdFX0RDQT15CkNPTkZJR19ORVRYRU5fTklDPW0KQ09ORklHX05JVT1tCkNPTkZJR19NTFg0
X0VOPW0KQ09ORklHX01MWDRfQ09SRT1tCkNPTkZJR19NTFg0X0RFQlVHPXkKQ09ORklHX1RFSFVU
ST1tCkNPTkZJR19CTlgyWD1tCkNPTkZJR19RTEdFPW0KQ09ORklHX1NGQz1tCkNPTkZJR19TRkNf
TVREPXkKQ09ORklHX0JFMk5FVD1tCiMgQ09ORklHX1RSIGlzIG5vdCBzZXQKQ09ORklHX1dMQU49
eQojIENPTkZJR19XTEFOX1BSRTgwMjExIGlzIG5vdCBzZXQKQ09ORklHX1dMQU5fODAyMTE9eQoj
IENPTkZJR19QQ01DSUFfUkFZQ1MgaXMgbm90IHNldApDT05GSUdfTElCRVJUQVM9bQpDT05GSUdf
TElCRVJUQVNfVVNCPW0KQ09ORklHX0xJQkVSVEFTX0NTPW0KQ09ORklHX0xJQkVSVEFTX1NESU89
bQpDT05GSUdfTElCRVJUQVNfREVCVUc9eQpDT05GSUdfTElCRVJUQVNfVEhJTkZJUk09bQpDT05G
SUdfTElCRVJUQVNfVEhJTkZJUk1fVVNCPW0KQ09ORklHX0FJUk89bQpDT05GSUdfQVRNRUw9bQpD
T05GSUdfUENJX0FUTUVMPW0KQ09ORklHX1BDTUNJQV9BVE1FTD1tCkNPTkZJR19BVDc2QzUwWF9V
U0I9bQpDT05GSUdfQUlST19DUz1tCkNPTkZJR19QQ01DSUFfV0wzNTAxPW0KQ09ORklHX1BSSVNN
NTQ9bQpDT05GSUdfVVNCX1pEMTIwMT1tCkNPTkZJR19VU0JfTkVUX1JORElTX1dMQU49bQpDT05G
SUdfUlRMODE4MD1tCkNPTkZJR19SVEw4MTg3PW0KQ09ORklHX1JUTDgxODdfTEVEUz15CkNPTkZJ
R19BRE04MjExPW0KQ09ORklHX01BQzgwMjExX0hXU0lNPW0KQ09ORklHX01XTDhLPW0KQ09ORklH
X1A1NF9DT01NT049bQpDT05GSUdfUDU0X1VTQj1tCkNPTkZJR19QNTRfUENJPW0KQ09ORklHX1A1
NF9MRURTPXkKQ09ORklHX0FUSF9DT01NT049bQpDT05GSUdfQVRINUs9bQpDT05GSUdfQVRINUtf
REVCVUc9eQpDT05GSUdfQVRIOUs9bQojIENPTkZJR19BVEg5S19ERUJVRyBpcyBub3Qgc2V0CkNP
TkZJR19BUjkxNzBfVVNCPW0KQ09ORklHX0FSOTE3MF9MRURTPXkKQ09ORklHX0lQVzIxMDA9bQpD
T05GSUdfSVBXMjEwMF9NT05JVE9SPXkKIyBDT05GSUdfSVBXMjEwMF9ERUJVRyBpcyBub3Qgc2V0
CkNPTkZJR19JUFcyMjAwPW0KQ09ORklHX0lQVzIyMDBfTU9OSVRPUj15CkNPTkZJR19JUFcyMjAw
X1JBRElPVEFQPXkKQ09ORklHX0lQVzIyMDBfUFJPTUlTQ1VPVVM9eQpDT05GSUdfSVBXMjIwMF9R
T1M9eQojIENPTkZJR19JUFcyMjAwX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0xJQklQVz1tCiMg
Q09ORklHX0xJQklQV19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19JV0xXSUZJPW0KQ09ORklHX0lX
TFdJRklfTEVEUz15CkNPTkZJR19JV0xXSUZJX1NQRUNUUlVNX01FQVNVUkVNRU5UPXkKQ09ORklH
X0lXTFdJRklfREVCVUc9eQpDT05GSUdfSVdMV0lGSV9ERUJVR0ZTPXkKQ09ORklHX0lXTEFHTj1t
CkNPTkZJR19JV0w0OTY1PXkKQ09ORklHX0lXTDUwMDA9eQpDT05GSUdfSVdMMzk0NT1tCkNPTkZJ
R19JV0wzOTQ1X1NQRUNUUlVNX01FQVNVUkVNRU5UPXkKQ09ORklHX0hPU1RBUD1tCkNPTkZJR19I
T1NUQVBfRklSTVdBUkU9eQpDT05GSUdfSE9TVEFQX0ZJUk1XQVJFX05WUkFNPXkKQ09ORklHX0hP
U1RBUF9QTFg9bQpDT05GSUdfSE9TVEFQX1BDST1tCkNPTkZJR19IT1NUQVBfQ1M9bQpDT05GSUdf
QjQzPW0KQ09ORklHX0I0M19QQ0lfQVVUT1NFTEVDVD15CkNPTkZJR19CNDNfUENJQ09SRV9BVVRP
U0VMRUNUPXkKQ09ORklHX0I0M19QQ01DSUE9eQojIENPTkZJR19CNDNfU0RJTyBpcyBub3Qgc2V0
CkNPTkZJR19CNDNfUElPPXkKQ09ORklHX0I0M19QSFlfTFA9eQpDT05GSUdfQjQzX0xFRFM9eQpD
T05GSUdfQjQzX0hXUk5HPXkKIyBDT05GSUdfQjQzX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0I0
M0xFR0FDWT1tCkNPTkZJR19CNDNMRUdBQ1lfUENJX0FVVE9TRUxFQ1Q9eQpDT05GSUdfQjQzTEVH
QUNZX1BDSUNPUkVfQVVUT1NFTEVDVD15CkNPTkZJR19CNDNMRUdBQ1lfTEVEUz15CkNPTkZJR19C
NDNMRUdBQ1lfSFdSTkc9eQojIENPTkZJR19CNDNMRUdBQ1lfREVCVUcgaXMgbm90IHNldApDT05G
SUdfQjQzTEVHQUNZX0RNQT15CkNPTkZJR19CNDNMRUdBQ1lfUElPPXkKQ09ORklHX0I0M0xFR0FD
WV9ETUFfQU5EX1BJT19NT0RFPXkKIyBDT05GSUdfQjQzTEVHQUNZX0RNQV9NT0RFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQjQzTEVHQUNZX1BJT19NT0RFIGlzIG5vdCBzZXQKQ09ORklHX1pEMTIxMVJX
PW0KIyBDT05GSUdfWkQxMjExUldfREVCVUcgaXMgbm90IHNldApDT05GSUdfUlQyWDAwPW0KQ09O
RklHX1JUMjQwMFBDST1tCkNPTkZJR19SVDI1MDBQQ0k9bQpDT05GSUdfUlQ2MVBDST1tCkNPTkZJ
R19SVDI1MDBVU0I9bQpDT05GSUdfUlQ3M1VTQj1tCkNPTkZJR19SVDI4MDBVU0I9bQpDT05GSUdf
UlQyWDAwX0xJQl9QQ0k9bQpDT05GSUdfUlQyWDAwX0xJQl9VU0I9bQpDT05GSUdfUlQyWDAwX0xJ
Qj1tCkNPTkZJR19SVDJYMDBfTElCX0hUPXkKQ09ORklHX1JUMlgwMF9MSUJfRklSTVdBUkU9eQpD
T05GSUdfUlQyWDAwX0xJQl9DUllQVE89eQpDT05GSUdfUlQyWDAwX0xJQl9MRURTPXkKQ09ORklH
X1JUMlgwMF9MSUJfREVCVUdGUz15CiMgQ09ORklHX1JUMlgwMF9ERUJVRyBpcyBub3Qgc2V0CkNP
TkZJR19IRVJNRVM9bQpDT05GSUdfSEVSTUVTX0NBQ0hFX0ZXX09OX0lOSVQ9eQpDT05GSUdfUExY
X0hFUk1FUz1tCkNPTkZJR19UTURfSEVSTUVTPW0KQ09ORklHX05PUlRFTF9IRVJNRVM9bQpDT05G
SUdfUENJX0hFUk1FUz1tCkNPTkZJR19QQ01DSUFfSEVSTUVTPW0KQ09ORklHX1BDTUNJQV9TUEVD
VFJVTT1tCiMgQ09ORklHX1dMMTJYWCBpcyBub3Qgc2V0CkNPTkZJR19JV009bQojIENPTkZJR19J
V01fREVCVUcgaXMgbm90IHNldAoKIwojIFdpTUFYIFdpcmVsZXNzIEJyb2FkYmFuZCBkZXZpY2Vz
CiMKQ09ORklHX1dJTUFYX0kyNDAwTT1tCkNPTkZJR19XSU1BWF9JMjQwME1fVVNCPW0KQ09ORklH
X1dJTUFYX0kyNDAwTV9TRElPPW0KQ09ORklHX1dJTUFYX0kyNDAwTV9ERUJVR19MRVZFTD04Cgoj
CiMgVVNCIE5ldHdvcmsgQWRhcHRlcnMKIwpDT05GSUdfVVNCX0NBVEM9bQpDT05GSUdfVVNCX0tB
V0VUSD1tCkNPTkZJR19VU0JfUEVHQVNVUz1tCkNPTkZJR19VU0JfUlRMODE1MD1tCkNPTkZJR19V
U0JfVVNCTkVUPW0KQ09ORklHX1VTQl9ORVRfQVg4ODE3WD1tCkNPTkZJR19VU0JfTkVUX0NEQ0VU
SEVSPW0KQ09ORklHX1VTQl9ORVRfQ0RDX0VFTT1tCkNPTkZJR19VU0JfTkVUX0RNOTYwMT1tCkNP
TkZJR19VU0JfTkVUX1NNU0M5NVhYPW0KQ09ORklHX1VTQl9ORVRfR0w2MjBBPW0KQ09ORklHX1VT
Ql9ORVRfTkVUMTA4MD1tCkNPTkZJR19VU0JfTkVUX1BMVVNCPW0KQ09ORklHX1VTQl9ORVRfTUNT
NzgzMD1tCkNPTkZJR19VU0JfTkVUX1JORElTX0hPU1Q9bQpDT05GSUdfVVNCX05FVF9DRENfU1VC
U0VUPW0KQ09ORklHX1VTQl9BTElfTTU2MzI9eQpDT05GSUdfVVNCX0FOMjcyMD15CkNPTkZJR19V
U0JfQkVMS0lOPXkKQ09ORklHX1VTQl9BUk1MSU5VWD15CkNPTkZJR19VU0JfRVBTT04yODg4PXkK
Q09ORklHX1VTQl9LQzIxOTA9eQpDT05GSUdfVVNCX05FVF9aQVVSVVM9bQpDT05GSUdfVVNCX0hT
Tz1tCkNPTkZJR19VU0JfTkVUX0lOVDUxWDE9bQpDT05GSUdfVVNCX0NEQ19QSE9ORVQ9bQpDT05G
SUdfTkVUX1BDTUNJQT15CkNPTkZJR19QQ01DSUFfM0M1ODk9bQpDT05GSUdfUENNQ0lBXzNDNTc0
PW0KQ09ORklHX1BDTUNJQV9GTVZKMThYPW0KQ09ORklHX1BDTUNJQV9QQ05FVD1tCkNPTkZJR19Q
Q01DSUFfTk1DTEFOPW0KQ09ORklHX1BDTUNJQV9TTUM5MUM5Mj1tCkNPTkZJR19QQ01DSUFfWElS
QzJQUz1tCkNPTkZJR19QQ01DSUFfQVhORVQ9bQojIENPTkZJR19XQU4gaXMgbm90IHNldApDT05G
SUdfQVRNX0RSSVZFUlM9eQojIENPTkZJR19BVE1fRFVNTVkgaXMgbm90IHNldApDT05GSUdfQVRN
X1RDUD1tCiMgQ09ORklHX0FUTV9MQU5BSSBpcyBub3Qgc2V0CkNPTkZJR19BVE1fRU5JPW0KIyBD
T05GSUdfQVRNX0VOSV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0FUTV9FTklfVFVORV9CVVJT
VCBpcyBub3Qgc2V0CkNPTkZJR19BVE1fRklSRVNUUkVBTT1tCiMgQ09ORklHX0FUTV9aQVRNIGlz
IG5vdCBzZXQKIyBDT05GSUdfQVRNX0lEVDc3MjUyIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNX0FN
QkFTU0FET1IgaXMgbm90IHNldAojIENPTkZJR19BVE1fSE9SSVpPTiBpcyBub3Qgc2V0CiMgQ09O
RklHX0FUTV9JQSBpcyBub3Qgc2V0CiMgQ09ORklHX0FUTV9GT1JFMjAwRSBpcyBub3Qgc2V0CiMg
Q09ORklHX0FUTV9IRSBpcyBub3Qgc2V0CkNPTkZJR19BVE1fU09MT1M9bQpDT05GSUdfSUVFRTgw
MjE1NF9EUklWRVJTPW0KQ09ORklHX0lFRUU4MDIxNTRfRkFLRUhBUkQ9bQpDT05GSUdfWEVOX05F
VERFVl9GUk9OVEVORD1tCkNPTkZJR19GRERJPXkKIyBDT05GSUdfREVGWFggaXMgbm90IHNldApD
T05GSUdfU0tGUD1tCiMgQ09ORklHX0hJUFBJIGlzIG5vdCBzZXQKQ09ORklHX1BMSVA9bQpDT05G
SUdfUFBQPW0KQ09ORklHX1BQUF9NVUxUSUxJTks9eQpDT05GSUdfUFBQX0ZJTFRFUj15CkNPTkZJ
R19QUFBfQVNZTkM9bQpDT05GSUdfUFBQX1NZTkNfVFRZPW0KQ09ORklHX1BQUF9ERUZMQVRFPW0K
IyBDT05GSUdfUFBQX0JTRENPTVAgaXMgbm90IHNldApDT05GSUdfUFBQX01QUEU9bQpDT05GSUdf
UFBQT0U9bQpDT05GSUdfUFBQT0FUTT1tCkNPTkZJR19QUFBPTDJUUD1tCkNPTkZJR19TTElQPW0K
Q09ORklHX1NMSVBfQ09NUFJFU1NFRD15CkNPTkZJR19TTEhDPW0KQ09ORklHX1NMSVBfU01BUlQ9
eQojIENPTkZJR19TTElQX01PREVfU0xJUDYgaXMgbm90IHNldApDT05GSUdfTkVUX0ZDPXkKQ09O
RklHX05FVENPTlNPTEU9bQpDT05GSUdfTkVUQ09OU09MRV9EWU5BTUlDPXkKQ09ORklHX05FVFBP
TEw9eQpDT05GSUdfTkVUUE9MTF9UUkFQPXkKQ09ORklHX05FVF9QT0xMX0NPTlRST0xMRVI9eQpD
T05GSUdfVklSVElPX05FVD1tCiMgQ09ORklHX1ZNWE5FVDMgaXMgbm90IHNldApDT05GSUdfSVNE
Tj15CkNPTkZJR19JU0ROX0k0TD1tCkNPTkZJR19NSVNETj1tCkNPTkZJR19NSVNETl9EU1A9bQpD
T05GSUdfTUlTRE5fTDFPSVA9bQoKIwojIG1JU0ROIGhhcmR3YXJlIGRyaXZlcnMKIwpDT05GSUdf
TUlTRE5fSEZDUENJPW0KQ09ORklHX01JU0ROX0hGQ01VTFRJPW0KQ09ORklHX01JU0ROX0hGQ1VT
Qj1tCiMgQ09ORklHX01JU0ROX0FWTUZSSVRaIGlzIG5vdCBzZXQKIyBDT05GSUdfTUlTRE5fU1BF
RURGQVggaXMgbm90IHNldAojIENPTkZJR19NSVNETl9JTkZJTkVPTiBpcyBub3Qgc2V0CiMgQ09O
RklHX01JU0ROX1c2NjkyIGlzIG5vdCBzZXQKIyBDT05GSUdfTUlTRE5fTkVUSkVUIGlzIG5vdCBz
ZXQKQ09ORklHX0lTRE5fUFBQPXkKQ09ORklHX0lTRE5fUFBQX1ZKPXkKQ09ORklHX0lTRE5fTVBQ
PXkKQ09ORklHX0lQUFBfRklMVEVSPXkKIyBDT05GSUdfSVNETl9QUFBfQlNEQ09NUCBpcyBub3Qg
c2V0CkNPTkZJR19JU0ROX0FVRElPPXkKQ09ORklHX0lTRE5fVFRZX0ZBWD15CgojCiMgSVNETiBm
ZWF0dXJlIHN1Ym1vZHVsZXMKIwpDT05GSUdfSVNETl9ESVZFUlNJT049bQoKIwojIElTRE40TGlu
dXggaGFyZHdhcmUgZHJpdmVycwojCgojCiMgUGFzc2l2ZSBjYXJkcwojCkNPTkZJR19JU0ROX0RS
Vl9ISVNBWD1tCgojCiMgRC1jaGFubmVsIHByb3RvY29sIGZlYXR1cmVzCiMKQ09ORklHX0hJU0FY
X0VVUk89eQpDT05GSUdfREVfQU9DPXkKQ09ORklHX0hJU0FYX05PX1NFTkRDT01QTEVURT15CkNP
TkZJR19ISVNBWF9OT19MTEM9eQpDT05GSUdfSElTQVhfTk9fS0VZUEFEPXkKQ09ORklHX0hJU0FY
XzFUUjY9eQpDT05GSUdfSElTQVhfTkkxPXkKQ09ORklHX0hJU0FYX01BWF9DQVJEUz04CgojCiMg
SGlTYXggc3VwcG9ydGVkIGNhcmRzCiMKQ09ORklHX0hJU0FYXzE2XzM9eQpDT05GSUdfSElTQVhf
VEVMRVNQQ0k9eQpDT05GSUdfSElTQVhfUzBCT1g9eQpDT05GSUdfSElTQVhfRlJJVFpQQ0k9eQpD
T05GSUdfSElTQVhfQVZNX0ExX1BDTUNJQT15CkNPTkZJR19ISVNBWF9FTFNBPXkKQ09ORklHX0hJ
U0FYX0RJRUhMRElWQT15CkNPTkZJR19ISVNBWF9TRURMQkFVRVI9eQpDT05GSUdfSElTQVhfTkVU
SkVUPXkKQ09ORklHX0hJU0FYX05FVEpFVF9VPXkKQ09ORklHX0hJU0FYX05JQ0NZPXkKQ09ORklH
X0hJU0FYX0JLTV9BNFQ9eQpDT05GSUdfSElTQVhfU0NUX1FVQURSTz15CkNPTkZJR19ISVNBWF9H
QVpFTD15CkNPTkZJR19ISVNBWF9IRkNfUENJPXkKQ09ORklHX0hJU0FYX1c2NjkyPXkKQ09ORklH
X0hJU0FYX0hGQ19TWD15CkNPTkZJR19ISVNBWF9FTlRFUk5PV19QQ0k9eQojIENPTkZJR19ISVNB
WF9ERUJVRyBpcyBub3Qgc2V0CgojCiMgSGlTYXggUENNQ0lBIGNhcmQgc2VydmljZSBtb2R1bGVz
CiMKQ09ORklHX0hJU0FYX1NFRExCQVVFUl9DUz1tCkNPTkZJR19ISVNBWF9FTFNBX0NTPW0KQ09O
RklHX0hJU0FYX0FWTV9BMV9DUz1tCkNPTkZJR19ISVNBWF9URUxFU19DUz1tCgojCiMgSGlTYXgg
c3ViIGRyaXZlciBtb2R1bGVzCiMKQ09ORklHX0hJU0FYX1NUNTQ4MT1tCiMgQ09ORklHX0hJU0FY
X0hGQ1VTQiBpcyBub3Qgc2V0CkNPTkZJR19ISVNBWF9IRkM0UzhTPW0KQ09ORklHX0hJU0FYX0ZS
SVRaX1BDSVBOUD1tCgojCiMgQWN0aXZlIGNhcmRzCiMKQ09ORklHX0hZU0ROPW0KQ09ORklHX0hZ
U0ROX0NBUEk9eQpDT05GSUdfSVNETl9IRExDPW0KQ09ORklHX0lTRE5fQ0FQST1tCkNPTkZJR19J
U0ROX0RSVl9BVk1CMV9WRVJCT1NFX1JFQVNPTj15CiMgQ09ORklHX0NBUElfVFJBQ0UgaXMgbm90
IHNldApDT05GSUdfSVNETl9DQVBJX01JRERMRVdBUkU9eQpDT05GSUdfSVNETl9DQVBJX0NBUEky
MD1tCkNPTkZJR19JU0ROX0NBUElfQ0FQSUZTX0JPT0w9eQpDT05GSUdfSVNETl9DQVBJX0NBUElG
Uz1tCkNPTkZJR19JU0ROX0NBUElfQ0FQSURSVj1tCgojCiMgQ0FQSSBoYXJkd2FyZSBkcml2ZXJz
CiMKQ09ORklHX0NBUElfQVZNPXkKQ09ORklHX0lTRE5fRFJWX0FWTUIxX0IxUENJPW0KQ09ORklH
X0lTRE5fRFJWX0FWTUIxX0IxUENJVjQ9eQpDT05GSUdfSVNETl9EUlZfQVZNQjFfQjFQQ01DSUE9
bQpDT05GSUdfSVNETl9EUlZfQVZNQjFfQVZNX0NTPW0KQ09ORklHX0lTRE5fRFJWX0FWTUIxX1Qx
UENJPW0KQ09ORklHX0lTRE5fRFJWX0FWTUIxX0M0PW0KQ09ORklHX0NBUElfRUlDT049eQpDT05G
SUdfSVNETl9ESVZBUz1tCkNPTkZJR19JU0ROX0RJVkFTX0JSSVBDST15CkNPTkZJR19JU0ROX0RJ
VkFTX1BSSVBDST15CkNPTkZJR19JU0ROX0RJVkFTX0RJVkFDQVBJPW0KQ09ORklHX0lTRE5fRElW
QVNfVVNFUklEST1tCkNPTkZJR19JU0ROX0RJVkFTX01BSU5UPW0KQ09ORklHX0lTRE5fRFJWX0dJ
R0FTRVQ9bQpDT05GSUdfR0lHQVNFVF9CQVNFPW0KQ09ORklHX0dJR0FTRVRfTTEwNT1tCkNPTkZJ
R19HSUdBU0VUX00xMDE9bQojIENPTkZJR19HSUdBU0VUX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEhPTkUgaXMgbm90IHNldAoKIwojIElucHV0IGRldmljZSBzdXBwb3J0CiMKQ09ORklHX0lO
UFVUPXkKQ09ORklHX0lOUFVUX0ZGX01FTUxFU1M9eQpDT05GSUdfSU5QVVRfUE9MTERFVj1tCgoj
CiMgVXNlcmxhbmQgaW50ZXJmYWNlcwojCkNPTkZJR19JTlBVVF9NT1VTRURFVj15CiMgQ09ORklH
X0lOUFVUX01PVVNFREVWX1BTQVVYIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX01PVVNFREVWX1ND
UkVFTl9YPTEwMjQKQ09ORklHX0lOUFVUX01PVVNFREVWX1NDUkVFTl9ZPTc2OApDT05GSUdfSU5Q
VVRfSk9ZREVWPW0KQ09ORklHX0lOUFVUX0VWREVWPXkKIyBDT05GSUdfSU5QVVRfRVZCVUcgaXMg
bm90IHNldApDT05GSUdfWEVOX0tCRERFVl9GUk9OVEVORD15CgojCiMgSW5wdXQgRGV2aWNlIERy
aXZlcnMKIwpDT05GSUdfSU5QVVRfS0VZQk9BUkQ9eQojIENPTkZJR19LRVlCT0FSRF9BRFA1NTg4
IGlzIG5vdCBzZXQKQ09ORklHX0tFWUJPQVJEX0FUS0JEPXkKIyBDT05GSUdfUVQyMTYwIGlzIG5v
dCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTEtLQkQgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FS
RF9MTTgzMjMgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9NQVg3MzU5IGlzIG5vdCBzZXQK
IyBDT05GSUdfS0VZQk9BUkRfTkVXVE9OIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfT1BF
TkNPUkVTIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfU1RPV0FXQVkgaXMgbm90IHNldAoj
IENPTkZJR19LRVlCT0FSRF9TVU5LQkQgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9YVEtC
RCBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9NT1VTRT15CkNPTkZJR19NT1VTRV9QUzI9eQpDT05G
SUdfTU9VU0VfUFMyX0FMUFM9eQpDT05GSUdfTU9VU0VfUFMyX0xPR0lQUzJQUD15CkNPTkZJR19N
T1VTRV9QUzJfU1lOQVBUSUNTPXkKQ09ORklHX01PVVNFX1BTMl9MSUZFQk9PSz15CkNPTkZJR19N
T1VTRV9QUzJfVFJBQ0tQT0lOVD15CkNPTkZJR19NT1VTRV9QUzJfRUxBTlRFQ0g9eQojIENPTkZJ
R19NT1VTRV9QUzJfU0VOVEVMSUMgaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9QUzJfVE9VQ0hL
SVQgaXMgbm90IHNldApDT05GSUdfTU9VU0VfU0VSSUFMPW0KQ09ORklHX01PVVNFX0FQUExFVE9V
Q0g9bQpDT05GSUdfTU9VU0VfQkNNNTk3ND1tCkNPTkZJR19NT1VTRV9WU1hYWEFBPW0KQ09ORklH
X01PVVNFX1NZTkFQVElDU19JMkM9bQpDT05GSUdfSU5QVVRfSk9ZU1RJQ0s9eQpDT05GSUdfSk9Z
U1RJQ0tfQU5BTE9HPW0KQ09ORklHX0pPWVNUSUNLX0EzRD1tCkNPTkZJR19KT1lTVElDS19BREk9
bQpDT05GSUdfSk9ZU1RJQ0tfQ09CUkE9bQpDT05GSUdfSk9ZU1RJQ0tfR0YySz1tCkNPTkZJR19K
T1lTVElDS19HUklQPW0KQ09ORklHX0pPWVNUSUNLX0dSSVBfTVA9bQpDT05GSUdfSk9ZU1RJQ0tf
R1VJTExFTU9UPW0KQ09ORklHX0pPWVNUSUNLX0lOVEVSQUNUPW0KQ09ORklHX0pPWVNUSUNLX1NJ
REVXSU5ERVI9bQpDT05GSUdfSk9ZU1RJQ0tfVE1EQz1tCkNPTkZJR19KT1lTVElDS19JRk9SQ0U9
bQpDT05GSUdfSk9ZU1RJQ0tfSUZPUkNFX1VTQj15CkNPTkZJR19KT1lTVElDS19JRk9SQ0VfMjMy
PXkKQ09ORklHX0pPWVNUSUNLX1dBUlJJT1I9bQpDT05GSUdfSk9ZU1RJQ0tfTUFHRUxMQU49bQpD
T05GSUdfSk9ZU1RJQ0tfU1BBQ0VPUkI9bQpDT05GSUdfSk9ZU1RJQ0tfU1BBQ0VCQUxMPW0KQ09O
RklHX0pPWVNUSUNLX1NUSU5HRVI9bQpDT05GSUdfSk9ZU1RJQ0tfVFdJREpPWT1tCkNPTkZJR19K
T1lTVElDS19aSEVOSFVBPW0KQ09ORklHX0pPWVNUSUNLX0RCOT1tCkNPTkZJR19KT1lTVElDS19H
QU1FQ09OPW0KQ09ORklHX0pPWVNUSUNLX1RVUkJPR1JBRlg9bQpDT05GSUdfSk9ZU1RJQ0tfSk9Z
RFVNUD1tCkNPTkZJR19KT1lTVElDS19YUEFEPW0KQ09ORklHX0pPWVNUSUNLX1hQQURfRkY9eQpD
T05GSUdfSk9ZU1RJQ0tfWFBBRF9MRURTPXkKQ09ORklHX0pPWVNUSUNLX1dBTEtFUkEwNzAxPW0K
Q09ORklHX0lOUFVUX1RBQkxFVD15CkNPTkZJR19UQUJMRVRfVVNCX0FDRUNBRD1tCkNPTkZJR19U
QUJMRVRfVVNCX0FJUFRFSz1tCkNPTkZJR19UQUJMRVRfVVNCX0dUQ089bQpDT05GSUdfVEFCTEVU
X1VTQl9LQlRBQj1tCkNPTkZJR19UQUJMRVRfVVNCX1dBQ09NPW0KQ09ORklHX0lOUFVUX1RPVUNI
U0NSRUVOPXkKQ09ORklHX1RPVUNIU0NSRUVOX0FENzg3OV9JMkM9bQpDT05GSUdfVE9VQ0hTQ1JF
RU5fQUQ3ODc5PW0KQ09ORklHX1RPVUNIU0NSRUVOX0VFVEk9bQpDT05GSUdfVE9VQ0hTQ1JFRU5f
RlVKSVRTVT1tCkNPTkZJR19UT1VDSFNDUkVFTl9HVU5aRT1tCkNPTkZJR19UT1VDSFNDUkVFTl9F
TE89bQpDT05GSUdfVE9VQ0hTQ1JFRU5fV0FDT01fVzgwMDE9bQojIENPTkZJR19UT1VDSFNDUkVF
Tl9NQ1M1MDAwIGlzIG5vdCBzZXQKQ09ORklHX1RPVUNIU0NSRUVOX01UT1VDSD1tCkNPTkZJR19U
T1VDSFNDUkVFTl9JTkVYSU89bQpDT05GSUdfVE9VQ0hTQ1JFRU5fTUs3MTI9bQpDT05GSUdfVE9V
Q0hTQ1JFRU5fUEVOTU9VTlQ9bQpDT05GSUdfVE9VQ0hTQ1JFRU5fVE9VQ0hSSUdIVD1tCkNPTkZJ
R19UT1VDSFNDUkVFTl9UT1VDSFdJTj1tCiMgQ09ORklHX1RPVUNIU0NSRUVOX1dNOTdYWCBpcyBu
b3Qgc2V0CkNPTkZJR19UT1VDSFNDUkVFTl9VU0JfQ09NUE9TSVRFPW0KQ09ORklHX1RPVUNIU0NS
RUVOX1VTQl9FR0FMQVg9eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX1BBTkpJVD15CkNPTkZJR19U
T1VDSFNDUkVFTl9VU0JfM009eQpDT05GSUdfVE9VQ0hTQ1JFRU5fVVNCX0lUTT15CkNPTkZJR19U
T1VDSFNDUkVFTl9VU0JfRVRVUkJPPXkKQ09ORklHX1RPVUNIU0NSRUVOX1VTQl9HVU5aRT15CkNP
TkZJR19UT1VDSFNDUkVFTl9VU0JfRE1DX1RTQzEwPXkKQ09ORklHX1RPVUNIU0NSRUVOX1VTQl9J
UlRPVUNIPXkKQ09ORklHX1RPVUNIU0NSRUVOX1VTQl9JREVBTFRFSz15CkNPTkZJR19UT1VDSFND
UkVFTl9VU0JfR0VORVJBTF9UT1VDSD15CkNPTkZJR19UT1VDSFNDUkVFTl9VU0JfR09UT1A9eQpD
T05GSUdfVE9VQ0hTQ1JFRU5fVVNCX0pBU1RFQz15CkNPTkZJR19UT1VDSFNDUkVFTl9VU0JfRTJJ
PXkKQ09ORklHX1RPVUNIU0NSRUVOX1RPVUNISVQyMTM9bQpDT05GSUdfVE9VQ0hTQ1JFRU5fVFND
MjAwNz1tCkNPTkZJR19JTlBVVF9NSVNDPXkKQ09ORklHX0lOUFVUX1BDU1BLUj1tCkNPTkZJR19J
TlBVVF9BUEFORUw9bQpDT05GSUdfSU5QVVRfQVRMQVNfQlROUz1tCkNPTkZJR19JTlBVVF9BVElf
UkVNT1RFPW0KQ09ORklHX0lOUFVUX0FUSV9SRU1PVEUyPW0KQ09ORklHX0lOUFVUX0tFWVNQQU5f
UkVNT1RFPW0KQ09ORklHX0lOUFVUX1BPV0VSTUFURT1tCkNPTkZJR19JTlBVVF9ZRUFMSU5LPW0K
Q09ORklHX0lOUFVUX0NNMTA5PW0KQ09ORklHX0lOUFVUX1VJTlBVVD1tCiMgQ09ORklHX0lOUFVU
X1dJTkJPTkRfQ0lSIGlzIG5vdCBzZXQKCiMKIyBIYXJkd2FyZSBJL08gcG9ydHMKIwpDT05GSUdf
U0VSSU89eQpDT05GSUdfU0VSSU9fSTgwNDI9eQpDT05GSUdfU0VSSU9fU0VSUE9SVD15CiMgQ09O
RklHX1NFUklPX0NUODJDNzEwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fUEFSS0JEIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VSSU9fUENJUFMyIGlzIG5vdCBzZXQKQ09ORklHX1NFUklPX0xJQlBT
Mj15CkNPTkZJR19TRVJJT19SQVc9bQpDT05GSUdfR0FNRVBPUlQ9bQpDT05GSUdfR0FNRVBPUlRf
TlM1NTg9bQpDT05GSUdfR0FNRVBPUlRfTDQ9bQpDT05GSUdfR0FNRVBPUlRfRU1VMTBLMT1tCkNP
TkZJR19HQU1FUE9SVF9GTTgwMT1tCgojCiMgQ2hhcmFjdGVyIGRldmljZXMKIwpDT05GSUdfVlQ9
eQpDT05GSUdfQ09OU09MRV9UUkFOU0xBVElPTlM9eQpDT05GSUdfVlRfQ09OU09MRT15CkNPTkZJ
R19IV19DT05TT0xFPXkKQ09ORklHX1ZUX0hXX0NPTlNPTEVfQklORElORz15CiMgQ09ORklHX0RF
VktNRU0gaXMgbm90IHNldApDT05GSUdfU0VSSUFMX05PTlNUQU5EQVJEPXkKIyBDT05GSUdfQ09N
UFVUT05FIGlzIG5vdCBzZXQKQ09ORklHX1JPQ0tFVFBPUlQ9bQpDT05GSUdfQ1lDTEFERVM9bQoj
IENPTkZJR19DWVpfSU5UUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RJR0lFUENBIGlzIG5vdCBzZXQK
IyBDT05GSUdfTU9YQV9JTlRFTExJTyBpcyBub3Qgc2V0CiMgQ09ORklHX01PWEFfU01BUlRJTyBp
cyBub3Qgc2V0CiMgQ09ORklHX0lTSSBpcyBub3Qgc2V0CkNPTkZJR19TWU5DTElOSz1tCkNPTkZJ
R19TWU5DTElOS01QPW0KQ09ORklHX1NZTkNMSU5LX0dUPW0KQ09ORklHX05fSERMQz1tCiMgQ09O
RklHX1JJU0NPTTggaXMgbm90IHNldAojIENPTkZJR19TUEVDSUFMSVggaXMgbm90IHNldAojIENP
TkZJR19TVEFMRFJWIGlzIG5vdCBzZXQKQ09ORklHX05PWk9NST1tCgojCiMgU2VyaWFsIGRyaXZl
cnMKIwpDT05GSUdfU0VSSUFMXzgyNTA9eQpDT05GSUdfU0VSSUFMXzgyNTBfQ09OU09MRT15CkNP
TkZJR19GSVhfRUFSTFlDT05fTUVNPXkKQ09ORklHX1NFUklBTF84MjUwX1BDST15CkNPTkZJR19T
RVJJQUxfODI1MF9QTlA9eQpDT05GSUdfU0VSSUFMXzgyNTBfQ1M9bQpDT05GSUdfU0VSSUFMXzgy
NTBfTlJfVUFSVFM9MzIKQ09ORklHX1NFUklBTF84MjUwX1JVTlRJTUVfVUFSVFM9NApDT05GSUdf
U0VSSUFMXzgyNTBfRVhURU5ERUQ9eQpDT05GSUdfU0VSSUFMXzgyNTBfTUFOWV9QT1JUUz15CkNP
TkZJR19TRVJJQUxfODI1MF9TSEFSRV9JUlE9eQpDT05GSUdfU0VSSUFMXzgyNTBfREVURUNUX0lS
UT15CkNPTkZJR19TRVJJQUxfODI1MF9SU0E9eQoKIwojIE5vbi04MjUwIHNlcmlhbCBwb3J0IHN1
cHBvcnQKIwpDT05GSUdfU0VSSUFMX0NPUkU9eQpDT05GSUdfU0VSSUFMX0NPUkVfQ09OU09MRT15
CkNPTkZJR19DT05TT0xFX1BPTEw9eQpDT05GSUdfU0VSSUFMX0pTTT1tCkNPTkZJR19VTklYOThf
UFRZUz15CkNPTkZJR19ERVZQVFNfTVVMVElQTEVfSU5TVEFOQ0VTPXkKIyBDT05GSUdfTEVHQUNZ
X1BUWVMgaXMgbm90IHNldApDT05GSUdfUFJJTlRFUj1tCkNPTkZJR19MUF9DT05TT0xFPXkKQ09O
RklHX1BQREVWPW0KQ09ORklHX0hWQ19EUklWRVI9eQpDT05GSUdfSFZDX0lSUT15CkNPTkZJR19I
VkNfWEVOPXkKQ09ORklHX1ZJUlRJT19DT05TT0xFPW0KQ09ORklHX0lQTUlfSEFORExFUj1tCiMg
Q09ORklHX0lQTUlfUEFOSUNfRVZFTlQgaXMgbm90IHNldApDT05GSUdfSVBNSV9ERVZJQ0VfSU5U
RVJGQUNFPW0KQ09ORklHX0lQTUlfU0k9bQpDT05GSUdfSVBNSV9XQVRDSERPRz1tCkNPTkZJR19J
UE1JX1BPV0VST0ZGPW0KQ09ORklHX0hXX1JBTkRPTT15CkNPTkZJR19IV19SQU5ET01fVElNRVJJ
T01FTT1tCkNPTkZJR19IV19SQU5ET01fSU5URUw9bQpDT05GSUdfSFdfUkFORE9NX0FNRD1tCkNP
TkZJR19IV19SQU5ET01fVklBPW0KQ09ORklHX0hXX1JBTkRPTV9WSVJUSU89bQpDT05GSUdfTlZS
QU09eQpDT05GSUdfUjM5NjQ9bQojIENPTkZJR19BUFBMSUNPTSBpcyBub3Qgc2V0CgojCiMgUENN
Q0lBIGNoYXJhY3RlciBkZXZpY2VzCiMKIyBDT05GSUdfU1lOQ0xJTktfQ1MgaXMgbm90IHNldApD
T05GSUdfQ0FSRE1BTl80MDAwPW0KQ09ORklHX0NBUkRNQU5fNDA0MD1tCkNPTkZJR19JUFdJUkVM
RVNTPW0KQ09ORklHX01XQVZFPW0KIyBDT05GSUdfUEM4NzM2eF9HUElPIGlzIG5vdCBzZXQKQ09O
RklHX1JBV19EUklWRVI9eQpDT05GSUdfTUFYX1JBV19ERVZTPTgxOTIKQ09ORklHX0hQRVQ9eQoj
IENPTkZJR19IUEVUX01NQVAgaXMgbm90IHNldApDT05GSUdfSEFOR0NIRUNLX1RJTUVSPW0KQ09O
RklHX1RDR19UUE09eQpDT05GSUdfVENHX1RJUz15CkNPTkZJR19UQ0dfTlNDPW0KQ09ORklHX1RD
R19BVE1FTD1tCkNPTkZJR19UQ0dfSU5GSU5FT049bQpDT05GSUdfVEVMQ0xPQ0s9bQpDT05GSUdf
REVWUE9SVD15CkNPTkZJR19JMkM9bQpDT05GSUdfSTJDX0JPQVJESU5GTz15CkNPTkZJR19JMkNf
Q09NUEFUPXkKQ09ORklHX0kyQ19DSEFSREVWPW0KQ09ORklHX0kyQ19IRUxQRVJfQVVUTz15CkNP
TkZJR19JMkNfQUxHT0JJVD1tCkNPTkZJR19JMkNfQUxHT1BDQT1tCgojCiMgSTJDIEhhcmR3YXJl
IEJ1cyBzdXBwb3J0CiMKCiMKIyBQQyBTTUJ1cyBob3N0IGNvbnRyb2xsZXIgZHJpdmVycwojCiMg
Q09ORklHX0kyQ19BTEkxNTM1IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0FMSTE1NjMgaXMgbm90
IHNldAojIENPTkZJR19JMkNfQUxJMTVYMyBpcyBub3Qgc2V0CkNPTkZJR19JMkNfQU1ENzU2PW0K
Q09ORklHX0kyQ19BTUQ3NTZfUzQ4ODI9bQpDT05GSUdfSTJDX0FNRDgxMTE9bQpDT05GSUdfSTJD
X0k4MDE9bQpDT05GSUdfSTJDX0lTQ0g9bQpDT05GSUdfSTJDX1BJSVg0PW0KQ09ORklHX0kyQ19O
Rk9SQ0UyPW0KQ09ORklHX0kyQ19ORk9SQ0UyX1M0OTg1PW0KIyBDT05GSUdfSTJDX1NJUzU1OTUg
aXMgbm90IHNldAojIENPTkZJR19JMkNfU0lTNjMwIGlzIG5vdCBzZXQKQ09ORklHX0kyQ19TSVM5
Nlg9bQpDT05GSUdfSTJDX1ZJQT1tCkNPTkZJR19JMkNfVklBUFJPPW0KCiMKIyBBQ1BJIGRyaXZl
cnMKIwojIENPTkZJR19JMkNfU0NNSSBpcyBub3Qgc2V0CgojCiMgSTJDIHN5c3RlbSBidXMgZHJp
dmVycyAobW9zdGx5IGVtYmVkZGVkIC8gc3lzdGVtLW9uLWNoaXApCiMKIyBDT05GSUdfSTJDX09D
T1JFUyBpcyBub3Qgc2V0CkNPTkZJR19JMkNfU0lNVEVDPW0KCiMKIyBFeHRlcm5hbCBJMkMvU01C
dXMgYWRhcHRlciBkcml2ZXJzCiMKQ09ORklHX0kyQ19QQVJQT1JUPW0KQ09ORklHX0kyQ19QQVJQ
T1JUX0xJR0hUPW0KIyBDT05GSUdfSTJDX1RBT1NfRVZNIGlzIG5vdCBzZXQKQ09ORklHX0kyQ19U
SU5ZX1VTQj1tCgojCiMgR3JhcGhpY3MgYWRhcHRlciBJMkMvRERDIGNoYW5uZWwgZHJpdmVycwoj
CkNPTkZJR19JMkNfVk9PRE9PMz1tCgojCiMgT3RoZXIgSTJDL1NNQnVzIGJ1cyBkcml2ZXJzCiMK
Q09ORklHX0kyQ19QQ0FfUExBVEZPUk09bQpDT05GSUdfSTJDX1NUVUI9bQoKIwojIE1pc2NlbGxh
bmVvdXMgSTJDIENoaXAgc3VwcG9ydAojCiMgQ09ORklHX0RTMTY4MiBpcyBub3Qgc2V0CkNPTkZJ
R19TRU5TT1JTX1RTTDI1NTA9bQojIENPTkZJR19JMkNfREVCVUdfQ09SRSBpcyBub3Qgc2V0CiMg
Q09ORklHX0kyQ19ERUJVR19BTEdPIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVHX0JVUyBp
cyBub3Qgc2V0CiMgQ09ORklHX0kyQ19ERUJVR19DSElQIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJ
IGlzIG5vdCBzZXQKCiMKIyBQUFMgc3VwcG9ydAojCkNPTkZJR19QUFM9bQojIENPTkZJR19QUFNf
REVCVUcgaXMgbm90IHNldApDT05GSUdfQVJDSF9XQU5UX09QVElPTkFMX0dQSU9MSUI9eQojIENP
TkZJR19HUElPTElCIGlzIG5vdCBzZXQKQ09ORklHX1cxPW0KQ09ORklHX1cxX0NPTj15CgojCiMg
MS13aXJlIEJ1cyBNYXN0ZXJzCiMKIyBDT05GSUdfVzFfTUFTVEVSX01BVFJPWCBpcyBub3Qgc2V0
CkNPTkZJR19XMV9NQVNURVJfRFMyNDkwPW0KQ09ORklHX1cxX01BU1RFUl9EUzI0ODI9bQoKIwoj
IDEtd2lyZSBTbGF2ZXMKIwpDT05GSUdfVzFfU0xBVkVfVEhFUk09bQpDT05GSUdfVzFfU0xBVkVf
U01FTT1tCkNPTkZJR19XMV9TTEFWRV9EUzI0MzE9bQpDT05GSUdfVzFfU0xBVkVfRFMyNDMzPW0K
Q09ORklHX1cxX1NMQVZFX0RTMjQzM19DUkM9eQpDT05GSUdfVzFfU0xBVkVfRFMyNzYwPW0KQ09O
RklHX1cxX1NMQVZFX0JRMjcwMDA9bQpDT05GSUdfUE9XRVJfU1VQUExZPXkKIyBDT05GSUdfUE9X
RVJfU1VQUExZX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfUERBX1BPV0VSIGlzIG5vdCBzZXQK
Q09ORklHX1dNODM1MF9QT1dFUj1tCiMgQ09ORklHX0JBVFRFUllfRFMyNzYwIGlzIG5vdCBzZXQK
IyBDT05GSUdfQkFUVEVSWV9EUzI3ODIgaXMgbm90IHNldApDT05GSUdfQkFUVEVSWV9CUTI3eDAw
PW0KQ09ORklHX0JBVFRFUllfTUFYMTcwNDA9bQpDT05GSUdfSFdNT049eQpDT05GSUdfSFdNT05f
VklEPW0KIyBDT05GSUdfSFdNT05fREVCVUdfQ0hJUCBpcyBub3Qgc2V0CgojCiMgTmF0aXZlIGRy
aXZlcnMKIwpDT05GSUdfU0VOU09SU19BQklUVUdVUlU9bQpDT05GSUdfU0VOU09SU19BQklUVUdV
UlUzPW0KQ09ORklHX1NFTlNPUlNfQUQ3NDE0PW0KQ09ORklHX1NFTlNPUlNfQUQ3NDE4PW0KQ09O
RklHX1NFTlNPUlNfQURNMTAyMT1tCkNPTkZJR19TRU5TT1JTX0FETTEwMjU9bQpDT05GSUdfU0VO
U09SU19BRE0xMDI2PW0KQ09ORklHX1NFTlNPUlNfQURNMTAyOT1tCkNPTkZJR19TRU5TT1JTX0FE
TTEwMzE9bQpDT05GSUdfU0VOU09SU19BRE05MjQwPW0KQ09ORklHX1NFTlNPUlNfQURUNzQ2Mj1t
CkNPTkZJR19TRU5TT1JTX0FEVDc0NzA9bQpDT05GSUdfU0VOU09SU19BRFQ3NDczPW0KQ09ORklH
X1NFTlNPUlNfQURUNzQ3NT1tCkNPTkZJR19TRU5TT1JTX0s4VEVNUD1tCkNPTkZJR19TRU5TT1JT
X0FTQjEwMD1tCkNPTkZJR19TRU5TT1JTX0FUWFAxPW0KQ09ORklHX1NFTlNPUlNfRFMxNjIxPW0K
Q09ORklHX1NFTlNPUlNfSTVLX0FNQj1tCkNPTkZJR19TRU5TT1JTX0Y3MTgwNUY9bQpDT05GSUdf
U0VOU09SU19GNzE4ODJGRz1tCkNPTkZJR19TRU5TT1JTX0Y3NTM3NVM9bQpDT05GSUdfU0VOU09S
U19GU0NITUQ9bQpDT05GSUdfU0VOU09SU19HNzYwQT1tCkNPTkZJR19TRU5TT1JTX0dMNTE4U009
bQpDT05GSUdfU0VOU09SU19HTDUyMFNNPW0KQ09ORklHX1NFTlNPUlNfQ09SRVRFTVA9bQpDT05G
SUdfU0VOU09SU19JQk1BRU09bQpDT05GSUdfU0VOU09SU19JQk1QRVg9bQpDT05GSUdfU0VOU09S
U19JVDg3PW0KQ09ORklHX1NFTlNPUlNfTE02Mz1tCkNPTkZJR19TRU5TT1JTX0xNNzU9bQpDT05G
SUdfU0VOU09SU19MTTc3PW0KQ09ORklHX1NFTlNPUlNfTE03OD1tCkNPTkZJR19TRU5TT1JTX0xN
ODA9bQpDT05GSUdfU0VOU09SU19MTTgzPW0KQ09ORklHX1NFTlNPUlNfTE04NT1tCkNPTkZJR19T
RU5TT1JTX0xNODc9bQpDT05GSUdfU0VOU09SU19MTTkwPW0KQ09ORklHX1NFTlNPUlNfTE05Mj1t
CkNPTkZJR19TRU5TT1JTX0xNOTM9bQpDT05GSUdfU0VOU09SU19MVEM0MjE1PW0KQ09ORklHX1NF
TlNPUlNfTFRDNDI0NT1tCkNPTkZJR19TRU5TT1JTX0xNOTUyNDE9bQpDT05GSUdfU0VOU09SU19N
QVgxNjE5PW0KQ09ORklHX1NFTlNPUlNfTUFYNjY1MD1tCkNPTkZJR19TRU5TT1JTX1BDODczNjA9
bQpDT05GSUdfU0VOU09SU19QQzg3NDI3PW0KQ09ORklHX1NFTlNPUlNfUENGODU5MT1tCkNPTkZJ
R19TRU5TT1JTX1NJUzU1OTU9bQpDT05GSUdfU0VOU09SU19ETUUxNzM3PW0KQ09ORklHX1NFTlNP
UlNfU01TQzQ3TTE9bQpDT05GSUdfU0VOU09SU19TTVNDNDdNMTkyPW0KQ09ORklHX1NFTlNPUlNf
U01TQzQ3QjM5Nz1tCkNPTkZJR19TRU5TT1JTX0FEUzc4Mjg9bQpDT05GSUdfU0VOU09SU19USE1D
NTA9bQpDT05GSUdfU0VOU09SU19UTVA0MDE9bQojIENPTkZJR19TRU5TT1JTX1RNUDQyMSBpcyBu
b3Qgc2V0CkNPTkZJR19TRU5TT1JTX1ZJQTY4NkE9bQpDT05GSUdfU0VOU09SU19WVDEyMTE9bQpD
T05GSUdfU0VOU09SU19WVDgyMzE9bQpDT05GSUdfU0VOU09SU19XODM3ODFEPW0KQ09ORklHX1NF
TlNPUlNfVzgzNzkxRD1tCkNPTkZJR19TRU5TT1JTX1c4Mzc5MkQ9bQpDT05GSUdfU0VOU09SU19X
ODM3OTM9bQpDT05GSUdfU0VOU09SU19XODNMNzg1VFM9bQpDT05GSUdfU0VOU09SU19XODNMNzg2
Tkc9bQpDT05GSUdfU0VOU09SU19XODM2MjdIRj1tCkNPTkZJR19TRU5TT1JTX1c4MzYyN0VIRj1t
CiMgQ09ORklHX1NFTlNPUlNfV004MzUwIGlzIG5vdCBzZXQKQ09ORklHX1NFTlNPUlNfSERBUFM9
bQpDT05GSUdfU0VOU09SU19BUFBMRVNNQz1tCgojCiMgQUNQSSBkcml2ZXJzCiMKQ09ORklHX1NF
TlNPUlNfQVRLMDExMD1tCkNPTkZJR19TRU5TT1JTX0xJUzNMVjAyRD1tCkNPTkZJR19USEVSTUFM
PXkKQ09ORklHX1RIRVJNQUxfSFdNT049eQpDT05GSUdfV0FUQ0hET0c9eQojIENPTkZJR19XQVRD
SERPR19OT1dBWU9VVCBpcyBub3Qgc2V0CgojCiMgV2F0Y2hkb2cgRGV2aWNlIERyaXZlcnMKIwpD
T05GSUdfU09GVF9XQVRDSERPRz1tCkNPTkZJR19XTTgzNTBfV0FUQ0hET0c9bQojIENPTkZJR19B
Q1FVSVJFX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FEVkFOVEVDSF9XRFQgaXMgbm90IHNldApD
T05GSUdfQUxJTTE1MzVfV0RUPW0KQ09ORklHX0FMSU03MTAxX1dEVD1tCiMgQ09ORklHX1NDNTIw
X1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NCQ19GSVRQQzJfV0FUQ0hET0cgaXMgbm90IHNldAoj
IENPTkZJR19FVVJPVEVDSF9XRFQgaXMgbm90IHNldAojIENPTkZJR19JQjcwMF9XRFQgaXMgbm90
IHNldApDT05GSUdfSUJNQVNSPW0KIyBDT05GSUdfV0FGRVJfV0RUIGlzIG5vdCBzZXQKQ09ORklH
X0k2MzAwRVNCX1dEVD1tCkNPTkZJR19JVENPX1dEVD1tCkNPTkZJR19JVENPX1ZFTkRPUl9TVVBQ
T1JUPXkKQ09ORklHX0lUODcxMkZfV0RUPW0KQ09ORklHX0lUODdfV0RUPW0KQ09ORklHX0hQX1dB
VENIRE9HPW0KIyBDT05GSUdfU0MxMjAwX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1BDODc0MTNf
V0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfNjBYWF9XRFQgaXMgbm90IHNldAojIENPTkZJR19TQkM4
MzYwX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NQVTVfV0RUIGlzIG5vdCBzZXQKQ09ORklHX1NN
U0NfU0NIMzExWF9XRFQ9bQojIENPTkZJR19TTVNDMzdCNzg3X1dEVCBpcyBub3Qgc2V0CkNPTkZJ
R19XODM2MjdIRl9XRFQ9bQpDT05GSUdfVzgzNjk3SEZfV0RUPW0KQ09ORklHX1c4MzY5N1VHX1dE
VD1tCkNPTkZJR19XODM4NzdGX1dEVD1tCkNPTkZJR19XODM5NzdGX1dEVD1tCkNPTkZJR19NQUNI
Wl9XRFQ9bQojIENPTkZJR19TQkNfRVBYX0MzX1dBVENIRE9HIGlzIG5vdCBzZXQKCiMKIyBQQ0kt
YmFzZWQgV2F0Y2hkb2cgQ2FyZHMKIwpDT05GSUdfUENJUENXQVRDSERPRz1tCkNPTkZJR19XRFRQ
Q0k9bQoKIwojIFVTQi1iYXNlZCBXYXRjaGRvZyBDYXJkcwojCkNPTkZJR19VU0JQQ1dBVENIRE9H
PW0KQ09ORklHX1NTQl9QT1NTSUJMRT15CgojCiMgU29uaWNzIFNpbGljb24gQmFja3BsYW5lCiMK
Q09ORklHX1NTQj1tCkNPTkZJR19TU0JfU1BST009eQpDT05GSUdfU1NCX0JMT0NLSU89eQpDT05G
SUdfU1NCX1BDSUhPU1RfUE9TU0lCTEU9eQpDT05GSUdfU1NCX1BDSUhPU1Q9eQpDT05GSUdfU1NC
X0I0M19QQ0lfQlJJREdFPXkKQ09ORklHX1NTQl9QQ01DSUFIT1NUX1BPU1NJQkxFPXkKQ09ORklH
X1NTQl9QQ01DSUFIT1NUPXkKQ09ORklHX1NTQl9TRElPSE9TVF9QT1NTSUJMRT15CiMgQ09ORklH
X1NTQl9TRElPSE9TVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NTQl9ERUJVRyBpcyBub3Qgc2V0CkNP
TkZJR19TU0JfRFJJVkVSX1BDSUNPUkVfUE9TU0lCTEU9eQpDT05GSUdfU1NCX0RSSVZFUl9QQ0lD
T1JFPXkKCiMKIyBNdWx0aWZ1bmN0aW9uIGRldmljZSBkcml2ZXJzCiMKQ09ORklHX01GRF9DT1JF
PW0KQ09ORklHX01GRF9TTTUwMT1tCiMgQ09ORklHX0hUQ19QQVNJQzMgaXMgbm90IHNldAojIENP
TkZJR19NRkRfVE1JTyBpcyBub3Qgc2V0CkNPTkZJR19NRkRfV004NDAwPW0KIyBDT05GSUdfTUZE
X1dNODMxWCBpcyBub3Qgc2V0CkNPTkZJR19NRkRfV004MzUwPW0KQ09ORklHX01GRF9XTTgzNTBf
STJDPW0KIyBDT05GSUdfTUZEX1BDRjUwNjMzIGlzIG5vdCBzZXQKQ09ORklHX0FCMzEwMF9DT1JF
PW0KQ09ORklHX0FCMzEwMF9PVFA9bQpDT05GSUdfUkVHVUxBVE9SPXkKIyBDT05GSUdfUkVHVUxB
VE9SX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1JFR1VMQVRPUl9GSVhFRF9WT0xUQUdFPW0KIyBD
T05GSUdfUkVHVUxBVE9SX1ZJUlRVQUxfQ09OU1VNRVIgaXMgbm90IHNldApDT05GSUdfUkVHVUxB
VE9SX1VTRVJTUEFDRV9DT05TVU1FUj1tCkNPTkZJR19SRUdVTEFUT1JfQlEyNDAyMj1tCkNPTkZJ
R19SRUdVTEFUT1JfTUFYMTU4Nj1tCkNPTkZJR19SRUdVTEFUT1JfV004MzUwPW0KQ09ORklHX1JF
R1VMQVRPUl9XTTg0MDA9bQpDT05GSUdfUkVHVUxBVE9SX0xQMzk3MT1tCkNPTkZJR19SRUdVTEFU
T1JfQUIzMTAwPW0KIyBDT05GSUdfUkVHVUxBVE9SX1RQUzY1MDIzIGlzIG5vdCBzZXQKIyBDT05G
SUdfUkVHVUxBVE9SX1RQUzY1MDdYIGlzIG5vdCBzZXQKQ09ORklHX01FRElBX1NVUFBPUlQ9bQoK
IwojIE11bHRpbWVkaWEgY29yZSBzdXBwb3J0CiMKQ09ORklHX1ZJREVPX0RFVj1tCkNPTkZJR19W
SURFT19WNEwyX0NPTU1PTj1tCkNPTkZJR19WSURFT19BTExPV19WNEwxPXkKQ09ORklHX1ZJREVP
X1Y0TDFfQ09NUEFUPXkKQ09ORklHX0RWQl9DT1JFPW0KQ09ORklHX1ZJREVPX01FRElBPW0KCiMK
IyBNdWx0aW1lZGlhIGRyaXZlcnMKIwpDT05GSUdfVklERU9fU0FBNzE0Nj1tCkNPTkZJR19WSURF
T19TQUE3MTQ2X1ZWPW0KQ09ORklHX01FRElBX0FUVEFDSD15CkNPTkZJR19NRURJQV9UVU5FUj1t
CiMgQ09ORklHX01FRElBX1RVTkVSX0NVU1RPTUlTRSBpcyBub3Qgc2V0CkNPTkZJR19NRURJQV9U
VU5FUl9TSU1QTEU9bQpDT05GSUdfTUVESUFfVFVORVJfVERBODI5MD1tCkNPTkZJR19NRURJQV9U
VU5FUl9UREE4MjdYPW0KQ09ORklHX01FRElBX1RVTkVSX1REQTE4MjcxPW0KQ09ORklHX01FRElB
X1RVTkVSX1REQTk4ODc9bQpDT05GSUdfTUVESUFfVFVORVJfVEVBNTc2MT1tCkNPTkZJR19NRURJ
QV9UVU5FUl9URUE1NzY3PW0KQ09ORklHX01FRElBX1RVTkVSX01UMjBYWD1tCkNPTkZJR19NRURJ
QV9UVU5FUl9NVDIwNjA9bQpDT05GSUdfTUVESUFfVFVORVJfTVQyMjY2PW0KQ09ORklHX01FRElB
X1RVTkVSX01UMjEzMT1tCkNPTkZJR19NRURJQV9UVU5FUl9RVDEwMTA9bQpDT05GSUdfTUVESUFf
VFVORVJfWEMyMDI4PW0KQ09ORklHX01FRElBX1RVTkVSX1hDNTAwMD1tCkNPTkZJR19NRURJQV9U
VU5FUl9NWEw1MDA1Uz1tCkNPTkZJR19NRURJQV9UVU5FUl9NWEw1MDA3VD1tCkNPTkZJR19NRURJ
QV9UVU5FUl9NQzQ0UzgwMz1tCkNPTkZJR19WSURFT19WNEwyPW0KQ09ORklHX1ZJREVPX1Y0TDE9
bQpDT05GSUdfVklERU9CVUZfR0VOPW0KQ09ORklHX1ZJREVPQlVGX0RNQV9TRz1tCkNPTkZJR19W
SURFT0JVRl9WTUFMTE9DPW0KQ09ORklHX1ZJREVPQlVGX0RWQj1tCkNPTkZJR19WSURFT19CVENY
PW0KQ09ORklHX1ZJREVPX0lSPW0KQ09ORklHX1ZJREVPX1RWRUVQUk9NPW0KQ09ORklHX1ZJREVP
X1RVTkVSPW0KQ09ORklHX1ZJREVPX0NBUFRVUkVfRFJJVkVSUz15CiMgQ09ORklHX1ZJREVPX0FE
Vl9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0ZJWEVEX01JTk9SX1JBTkdFUyBpcyBu
b3Qgc2V0CkNPTkZJR19WSURFT19IRUxQRVJfQ0hJUFNfQVVUTz15CkNPTkZJR19WSURFT19JUl9J
MkM9bQpDT05GSUdfVklERU9fVFZBVURJTz1tCkNPTkZJR19WSURFT19UREE3NDMyPW0KQ09ORklH
X1ZJREVPX1REQTk4NDA9bQpDT05GSUdfVklERU9fVEVBNjQxNUM9bQpDT05GSUdfVklERU9fVEVB
NjQyMD1tCkNPTkZJR19WSURFT19NU1AzNDAwPW0KQ09ORklHX1ZJREVPX0NTNTM0NT1tCkNPTkZJ
R19WSURFT19DUzUzTDMyQT1tCkNPTkZJR19WSURFT19NNTI3OTA9bQpDT05GSUdfVklERU9fV004
Nzc1PW0KQ09ORklHX1ZJREVPX1dNODczOT1tCkNPTkZJR19WSURFT19WUDI3U01QWD1tCkNPTkZJ
R19WSURFT19TQUE2NTg4PW0KQ09ORklHX1ZJREVPX0JUODE5PW0KQ09ORklHX1ZJREVPX0JUODU2
PW0KQ09ORklHX1ZJREVPX0JUODY2PW0KQ09ORklHX1ZJREVPX0tTMDEyNz1tCkNPTkZJR19WSURF
T19NVDlWMDExPW0KQ09ORklHX1ZJREVPX1NBQTcxMTA9bQpDT05GSUdfVklERU9fU0FBNzExWD1t
CkNPTkZJR19WSURFT19TQUE3MTdYPW0KQ09ORklHX1ZJREVPX1RWUDUxNTA9bQpDT05GSUdfVklE
RU9fVlBYMzIyMD1tCkNPTkZJR19WSURFT19DWDI1ODQwPW0KQ09ORklHX1ZJREVPX0NYMjM0MVg9
bQpDT05GSUdfVklERU9fU0FBNzEyNz1tCkNPTkZJR19WSURFT19TQUE3MTg1PW0KQ09ORklHX1ZJ
REVPX0FEVjcxNzA9bQpDT05GSUdfVklERU9fQURWNzE3NT1tCkNPTkZJR19WSURFT19VUEQ2NDAz
MUE9bQpDT05GSUdfVklERU9fVVBENjQwODM9bQojIENPTkZJR19WSURFT19WSVZJIGlzIG5vdCBz
ZXQKQ09ORklHX1ZJREVPX0JUODQ4PW0KQ09ORklHX1ZJREVPX0JUODQ4X0RWQj15CkNPTkZJR19W
SURFT19CV1FDQU09bQpDT05GSUdfVklERU9fQ1FDQU09bQpDT05GSUdfVklERU9fVzk5NjY9bQpD
T05GSUdfVklERU9fQ1BJQT1tCkNPTkZJR19WSURFT19DUElBX1BQPW0KQ09ORklHX1ZJREVPX0NQ
SUFfVVNCPW0KQ09ORklHX1ZJREVPX0NQSUEyPW0KQ09ORklHX1ZJREVPX1NBQTUyNDZBPW0KQ09O
RklHX1ZJREVPX1NBQTUyNDk9bQpDT05GSUdfVklERU9fU1RSQURJUz1tCkNPTkZJR19WSURFT19a
T1JBTj1tCkNPTkZJR19WSURFT19aT1JBTl9EQzMwPW0KQ09ORklHX1ZJREVPX1pPUkFOX1pSMzYw
NjA9bQpDT05GSUdfVklERU9fWk9SQU5fQlVaPW0KQ09ORklHX1ZJREVPX1pPUkFOX0RDMTA9bQpD
T05GSUdfVklERU9fWk9SQU5fTE1MMzM9bQpDT05GSUdfVklERU9fWk9SQU5fTE1MMzNSMTA9bQpD
T05GSUdfVklERU9fWk9SQU5fQVZTNkVZRVM9bQpDT05GSUdfVklERU9fTUVZRT1tCkNPTkZJR19W
SURFT19TQUE3MTM0PW0KQ09ORklHX1ZJREVPX1NBQTcxMzRfQUxTQT1tCkNPTkZJR19WSURFT19T
QUE3MTM0X0RWQj1tCkNPTkZJR19WSURFT19NWEI9bQpDT05GSUdfVklERU9fSEVYSVVNX09SSU9O
PW0KQ09ORklHX1ZJREVPX0hFWElVTV9HRU1JTkk9bQpDT05GSUdfVklERU9fQ1g4OD1tCkNPTkZJ
R19WSURFT19DWDg4X0FMU0E9bQpDT05GSUdfVklERU9fQ1g4OF9CTEFDS0JJUkQ9bQpDT05GSUdf
VklERU9fQ1g4OF9EVkI9bQpDT05GSUdfVklERU9fQ1g4OF9NUEVHPW0KQ09ORklHX1ZJREVPX0NY
ODhfVlAzMDU0PW0KQ09ORklHX1ZJREVPX0NYMjM4ODU9bQpDT05GSUdfVklERU9fQVUwODI4PW0K
Q09ORklHX1ZJREVPX0lWVFY9bQpDT05GSUdfVklERU9fRkJfSVZUVj1tCkNPTkZJR19WSURFT19D
WDE4PW0KIyBDT05GSUdfVklERU9fU0FBNzE2NCBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0NB
RkVfQ0NJQyBpcyBub3Qgc2V0CkNPTkZJR19TT0NfQ0FNRVJBPW0KQ09ORklHX1NPQ19DQU1FUkFf
TVQ5TTAwMT1tCkNPTkZJR19TT0NfQ0FNRVJBX01UOU0xMTE9bQpDT05GSUdfU09DX0NBTUVSQV9N
VDlUMDMxPW0KQ09ORklHX1NPQ19DQU1FUkFfTVQ5VjAyMj1tCkNPTkZJR19TT0NfQ0FNRVJBX1RX
OTkxMD1tCkNPTkZJR19TT0NfQ0FNRVJBX1BMQVRGT1JNPW0KQ09ORklHX1NPQ19DQU1FUkFfT1Y3
NzJYPW0KQ09ORklHX1Y0TF9VU0JfRFJJVkVSUz15CkNPTkZJR19VU0JfVklERU9fQ0xBU1M9bQpD
T05GSUdfVVNCX1ZJREVPX0NMQVNTX0lOUFVUX0VWREVWPXkKQ09ORklHX1VTQl9HU1BDQT1tCkNP
TkZJR19VU0JfTTU2MDI9bQpDT05GSUdfVVNCX1NUVjA2WFg9bQojIENPTkZJR19VU0JfR0w4NjAg
aXMgbm90IHNldApDT05GSUdfVVNCX0dTUENBX0NPTkVYPW0KQ09ORklHX1VTQl9HU1BDQV9FVE9N
Uz1tCkNPTkZJR19VU0JfR1NQQ0FfRklORVBJWD1tCiMgQ09ORklHX1VTQl9HU1BDQV9KRUlMSU5K
IGlzIG5vdCBzZXQKQ09ORklHX1VTQl9HU1BDQV9NQVJTPW0KQ09ORklHX1VTQl9HU1BDQV9NUjk3
MzEwQT1tCkNPTkZJR19VU0JfR1NQQ0FfT1Y1MTk9bQpDT05GSUdfVVNCX0dTUENBX09WNTM0PW0K
Q09ORklHX1VTQl9HU1BDQV9QQUMyMDc9bQpDT05GSUdfVVNCX0dTUENBX1BBQzczMTE9bQpDT05G
SUdfVVNCX0dTUENBX1NOOUMyMFg9bQpDT05GSUdfVVNCX0dTUENBX1NOOUMyMFhfRVZERVY9eQpD
T05GSUdfVVNCX0dTUENBX1NPTklYQj1tCkNPTkZJR19VU0JfR1NQQ0FfU09OSVhKPW0KQ09ORklH
X1VTQl9HU1BDQV9TUENBNTAwPW0KQ09ORklHX1VTQl9HU1BDQV9TUENBNTAxPW0KQ09ORklHX1VT
Ql9HU1BDQV9TUENBNTA1PW0KQ09ORklHX1VTQl9HU1BDQV9TUENBNTA2PW0KQ09ORklHX1VTQl9H
U1BDQV9TUENBNTA4PW0KQ09ORklHX1VTQl9HU1BDQV9TUENBNTYxPW0KQ09ORklHX1VTQl9HU1BD
QV9TUTkwNT1tCkNPTkZJR19VU0JfR1NQQ0FfU1E5MDVDPW0KQ09ORklHX1VTQl9HU1BDQV9TVEsw
MTQ9bQpDT05GSUdfVVNCX0dTUENBX1NVTlBMVVM9bQpDT05GSUdfVVNCX0dTUENBX1Q2MTM9bQpD
T05GSUdfVVNCX0dTUENBX1RWODUzMj1tCkNPTkZJR19VU0JfR1NQQ0FfVkMwMzJYPW0KQ09ORklH
X1VTQl9HU1BDQV9aQzNYWD1tCkNPTkZJR19WSURFT19QVlJVU0IyPW0KQ09ORklHX1ZJREVPX1BW
UlVTQjJfU1lTRlM9eQpDT05GSUdfVklERU9fUFZSVVNCMl9EVkI9eQojIENPTkZJR19WSURFT19Q
VlJVU0IyX0RFQlVHSUZDIGlzIG5vdCBzZXQKQ09ORklHX1ZJREVPX0hEUFZSPW0KQ09ORklHX1ZJ
REVPX0VNMjhYWD1tCkNPTkZJR19WSURFT19FTTI4WFhfQUxTQT1tCkNPTkZJR19WSURFT19FTTI4
WFhfRFZCPW0KQ09ORklHX1ZJREVPX0NYMjMxWFg9bQpDT05GSUdfVklERU9fQ1gyMzFYWF9BTFNB
PW0KQ09ORklHX1ZJREVPX0NYMjMxWFhfRFZCPW0KQ09ORklHX1ZJREVPX1VTQlZJU0lPTj1tCkNP
TkZJR19WSURFT19VU0JWSURFTz1tCkNPTkZJR19VU0JfVklDQU09bQpDT05GSUdfVVNCX0lCTUNB
TT1tCkNPTkZJR19VU0JfS09OSUNBV0M9bQojIENPTkZJR19VU0JfUVVJQ0tDQU1fTUVTU0VOR0VS
IGlzIG5vdCBzZXQKQ09ORklHX1VTQl9FVDYxWDI1MT1tCkNPTkZJR19WSURFT19PVkNBTUNISVA9
bQpDT05GSUdfVVNCX1c5OTY4Q0Y9bQojIENPTkZJR19VU0JfT1Y1MTEgaXMgbm90IHNldApDT05G
SUdfVVNCX1NFNDAxPW0KQ09ORklHX1VTQl9TTjlDMTAyPW0KQ09ORklHX1VTQl9TVFY2ODA9bQoj
IENPTkZJR19VU0JfWkMwMzAxIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9QV0M9bQojIENPTkZJR19V
U0JfUFdDX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9QV0NfSU5QVVRfRVZERVY9eQpDT05G
SUdfVVNCX1pSMzY0WFg9bQpDT05GSUdfVVNCX1NUS1dFQkNBTT1tCkNPTkZJR19VU0JfUzIyNTU9
bQpDT05GSUdfUkFESU9fQURBUFRFUlM9eQpDT05GSUdfUkFESU9fR0VNVEVLX1BDST1tCkNPTkZJ
R19SQURJT19NQVhJUkFESU89bQpDT05GSUdfUkFESU9fTUFFU1RSTz1tCiMgQ09ORklHX0kyQ19T
STQ3MTMgaXMgbm90IHNldAojIENPTkZJR19SQURJT19TSTQ3MTMgaXMgbm90IHNldApDT05GSUdf
VVNCX0RTQlI9bQojIENPTkZJR19SQURJT19TSTQ3MFggaXMgbm90IHNldApDT05GSUdfVVNCX01S
ODAwPW0KIyBDT05GSUdfUkFESU9fVEVBNTc2NCBpcyBub3Qgc2V0CkNPTkZJR19EVkJfTUFYX0FE
QVBURVJTPTgKQ09ORklHX0RWQl9EWU5BTUlDX01JTk9SUz15CkNPTkZJR19EVkJfQ0FQVFVSRV9E
UklWRVJTPXkKCiMKIyBTdXBwb3J0ZWQgU0FBNzE0NiBiYXNlZCBQQ0kgQWRhcHRlcnMKIwpDT05G
SUdfVFRQQ0lfRUVQUk9NPW0KQ09ORklHX0RWQl9BVjcxMTA9bQpDT05GSUdfRFZCX0FWNzExMF9P
U0Q9eQpDT05GSUdfRFZCX0JVREdFVF9DT1JFPW0KQ09ORklHX0RWQl9CVURHRVQ9bQpDT05GSUdf
RFZCX0JVREdFVF9DST1tCkNPTkZJR19EVkJfQlVER0VUX0FWPW0KQ09ORklHX0RWQl9CVURHRVRf
UEFUQ0g9bQoKIwojIFN1cHBvcnRlZCBVU0IgQWRhcHRlcnMKIwpDT05GSUdfRFZCX1VTQj1tCiMg
Q09ORklHX0RWQl9VU0JfREVCVUcgaXMgbm90IHNldApDT05GSUdfRFZCX1VTQl9BODAwPW0KQ09O
RklHX0RWQl9VU0JfRElCVVNCX01CPW0KIyBDT05GSUdfRFZCX1VTQl9ESUJVU0JfTUJfRkFVTFRZ
IGlzIG5vdCBzZXQKQ09ORklHX0RWQl9VU0JfRElCVVNCX01DPW0KQ09ORklHX0RWQl9VU0JfRElC
MDcwMD1tCkNPTkZJR19EVkJfVVNCX1VNVF8wMTA9bQpDT05GSUdfRFZCX1VTQl9DWFVTQj1tCkNP
TkZJR19EVkJfVVNCX005MjBYPW0KQ09ORklHX0RWQl9VU0JfR0w4NjE9bQpDT05GSUdfRFZCX1VT
Ql9BVTY2MTA9bQpDT05GSUdfRFZCX1VTQl9ESUdJVFY9bQpDT05GSUdfRFZCX1VTQl9WUDcwNDU9
bQpDT05GSUdfRFZCX1VTQl9WUDcwMlg9bQpDT05GSUdfRFZCX1VTQl9HUDhQU0s9bQpDT05GSUdf
RFZCX1VTQl9OT1ZBX1RfVVNCMj1tCkNPTkZJR19EVkJfVVNCX1RUVVNCMj1tCkNPTkZJR19EVkJf
VVNCX0RUVDIwMFU9bQpDT05GSUdfRFZCX1VTQl9PUEVSQTE9bQpDT05GSUdfRFZCX1VTQl9BRjkw
MDU9bQpDT05GSUdfRFZCX1VTQl9BRjkwMDVfUkVNT1RFPW0KQ09ORklHX0RWQl9VU0JfRFcyMTAy
PW0KQ09ORklHX0RWQl9VU0JfQ0lORVJHWV9UMj1tCkNPTkZJR19EVkJfVVNCX0FOWVNFRT1tCkNP
TkZJR19EVkJfVVNCX0RUVjUxMDA9bQpDT05GSUdfRFZCX1VTQl9BRjkwMTU9bQpDT05GSUdfRFZC
X1VTQl9DRTYyMzA9bQojIENPTkZJR19EVkJfVVNCX0ZSSUlPIGlzIG5vdCBzZXQKQ09ORklHX0RW
Ql9UVFVTQl9CVURHRVQ9bQpDT05GSUdfRFZCX1RUVVNCX0RFQz1tCkNPTkZJR19TTVNfU0lBTk9f
TURUVj1tCgojCiMgU2lhbm8gbW9kdWxlIGNvbXBvbmVudHMKIwpDT05GSUdfU01TX1VTQl9EUlY9
bQpDT05GSUdfU01TX1NESU9fRFJWPW0KCiMKIyBTdXBwb3J0ZWQgRmxleENvcElJIChCMkMyKSBB
ZGFwdGVycwojCkNPTkZJR19EVkJfQjJDMl9GTEVYQ09QPW0KQ09ORklHX0RWQl9CMkMyX0ZMRVhD
T1BfUENJPW0KQ09ORklHX0RWQl9CMkMyX0ZMRVhDT1BfVVNCPW0KIyBDT05GSUdfRFZCX0IyQzJf
RkxFWENPUF9ERUJVRyBpcyBub3Qgc2V0CgojCiMgU3VwcG9ydGVkIEJUODc4IEFkYXB0ZXJzCiMK
Q09ORklHX0RWQl9CVDhYWD1tCgojCiMgU3VwcG9ydGVkIFBsdXRvMiBBZGFwdGVycwojCkNPTkZJ
R19EVkJfUExVVE8yPW0KCiMKIyBTdXBwb3J0ZWQgU0RNQyBETTExMDUgQWRhcHRlcnMKIwpDT05G
SUdfRFZCX0RNMTEwNT1tCgojCiMgU3VwcG9ydGVkIEVhcnRoc29mdCBQVDEgQWRhcHRlcnMKIwoj
IENPTkZJR19EVkJfUFQxIGlzIG5vdCBzZXQKCiMKIyBTdXBwb3J0ZWQgRFZCIEZyb250ZW5kcwoj
CiMgQ09ORklHX0RWQl9GRV9DVVNUT01JU0UgaXMgbm90IHNldApDT05GSUdfRFZCX1NUQjA4OTk9
bQpDT05GSUdfRFZCX1NUQjYxMDA9bQpDT05GSUdfRFZCX0NYMjQxMTA9bQpDT05GSUdfRFZCX0NY
MjQxMjM9bQpDT05GSUdfRFZCX01UMzEyPW0KQ09ORklHX0RWQl9aTDEwMDM2PW0KQ09ORklHX0RW
Ql9aTDEwMDM5PW0KQ09ORklHX0RWQl9TNUgxNDIwPW0KQ09ORklHX0RWQl9TVFYwMjg4PW0KQ09O
RklHX0RWQl9TVEI2MDAwPW0KQ09ORklHX0RWQl9TVFYwMjk5PW0KQ09ORklHX0RWQl9TVFY2MTEw
PW0KQ09ORklHX0RWQl9TVFYwOTAwPW0KQ09ORklHX0RWQl9UREE4MDgzPW0KQ09ORklHX0RWQl9U
REExMDA4Nj1tCkNPTkZJR19EVkJfVERBODI2MT1tCkNPTkZJR19EVkJfVkVTMVg5Mz1tCkNPTkZJ
R19EVkJfVFVORVJfSVREMTAwMD1tCkNPTkZJR19EVkJfVFVORVJfQ1gyNDExMz1tCkNPTkZJR19E
VkJfVERBODI2WD1tCkNPTkZJR19EVkJfVFVBNjEwMD1tCkNPTkZJR19EVkJfQ1gyNDExNj1tCkNP
TkZJR19EVkJfU0kyMVhYPW0KQ09ORklHX0RWQl9TUDg4NzA9bQpDT05GSUdfRFZCX1NQODg3WD1t
CkNPTkZJR19EVkJfQ1gyMjcwMD1tCkNPTkZJR19EVkJfQ1gyMjcwMj1tCkNPTkZJR19EVkJfTDY0
NzgxPW0KQ09ORklHX0RWQl9UREExMDA0WD1tCkNPTkZJR19EVkJfTlhUNjAwMD1tCkNPTkZJR19E
VkJfTVQzNTI9bQpDT05GSUdfRFZCX1pMMTAzNTM9bQpDT05GSUdfRFZCX0RJQjMwMDBNQj1tCkNP
TkZJR19EVkJfRElCMzAwME1DPW0KQ09ORklHX0RWQl9ESUI3MDAwTT1tCkNPTkZJR19EVkJfRElC
NzAwMFA9bQpDT05GSUdfRFZCX1REQTEwMDQ4PW0KQ09ORklHX0RWQl9BRjkwMTM9bQpDT05GSUdf
RFZCX1ZFUzE4MjA9bQpDT05GSUdfRFZCX1REQTEwMDIxPW0KQ09ORklHX0RWQl9UREExMDAyMz1t
CkNPTkZJR19EVkJfU1RWMDI5Nz1tCkNPTkZJR19EVkJfTlhUMjAwWD1tCkNPTkZJR19EVkJfT1I1
MTIxMT1tCkNPTkZJR19EVkJfT1I1MTEzMj1tCkNPTkZJR19EVkJfQkNNMzUxMD1tCkNPTkZJR19E
VkJfTEdEVDMzMFg9bQpDT05GSUdfRFZCX0xHRFQzMzA1PW0KQ09ORklHX0RWQl9TNUgxNDA5PW0K
Q09ORklHX0RWQl9BVTg1MjI9bQpDT05GSUdfRFZCX1M1SDE0MTE9bQpDT05GSUdfRFZCX0RJQjgw
MDA9bQpDT05GSUdfRFZCX1BMTD1tCkNPTkZJR19EVkJfVFVORVJfRElCMDA3MD1tCkNPTkZJR19E
VkJfTE5CUDIxPW0KQ09ORklHX0RWQl9JU0w2NDA1PW0KQ09ORklHX0RWQl9JU0w2NDIxPW0KQ09O
RklHX0RWQl9MR1M4R0w1PW0KQ09ORklHX0RBQj15CkNPTkZJR19VU0JfREFCVVNCPW0KCiMKIyBH
cmFwaGljcyBzdXBwb3J0CiMKQ09ORklHX0FHUD15CkNPTkZJR19BR1BfQU1ENjQ9eQpDT05GSUdf
QUdQX0lOVEVMPXkKQ09ORklHX0FHUF9TSVM9eQpDT05GSUdfQUdQX1ZJQT15CkNPTkZJR19WR0Ff
QVJCPXkKQ09ORklHX0RSTT1tCkNPTkZJR19EUk1fS01TX0hFTFBFUj1tCkNPTkZJR19EUk1fVFRN
PW0KQ09ORklHX0RSTV9UREZYPW0KQ09ORklHX0RSTV9SMTI4PW0KQ09ORklHX0RSTV9SQURFT049
bQpDT05GSUdfRFJNX0k4MTA9bQpDT05GSUdfRFJNX0k4MzA9bQpDT05GSUdfRFJNX0k5MTU9bQpD
T05GSUdfRFJNX0k5MTVfS01TPXkKQ09ORklHX0RSTV9NR0E9bQpDT05GSUdfRFJNX1NJUz1tCkNP
TkZJR19EUk1fVklBPW0KQ09ORklHX0RSTV9TQVZBR0U9bQpDT05GSUdfVkdBU1RBVEU9bQpDT05G
SUdfVklERU9fT1VUUFVUX0NPTlRST0w9bQpDT05GSUdfRkI9eQojIENPTkZJR19GSVJNV0FSRV9F
RElEIGlzIG5vdCBzZXQKQ09ORklHX0ZCX0REQz1tCkNPTkZJR19GQl9CT09UX1ZFU0FfU1VQUE9S
VD15CkNPTkZJR19GQl9DRkJfRklMTFJFQ1Q9eQpDT05GSUdfRkJfQ0ZCX0NPUFlBUkVBPXkKQ09O
RklHX0ZCX0NGQl9JTUFHRUJMSVQ9eQojIENPTkZJR19GQl9DRkJfUkVWX1BJWEVMU19JTl9CWVRF
IGlzIG5vdCBzZXQKQ09ORklHX0ZCX1NZU19GSUxMUkVDVD15CkNPTkZJR19GQl9TWVNfQ09QWUFS
RUE9eQpDT05GSUdfRkJfU1lTX0lNQUdFQkxJVD15CiMgQ09ORklHX0ZCX0ZPUkVJR05fRU5ESUFO
IGlzIG5vdCBzZXQKQ09ORklHX0ZCX1NZU19GT1BTPXkKQ09ORklHX0ZCX0RFRkVSUkVEX0lPPXkK
Q09ORklHX0ZCX1NWR0FMSUI9bQojIENPTkZJR19GQl9NQUNNT0RFUyBpcyBub3Qgc2V0CkNPTkZJ
R19GQl9CQUNLTElHSFQ9eQpDT05GSUdfRkJfTU9ERV9IRUxQRVJTPXkKQ09ORklHX0ZCX1RJTEVC
TElUVElORz15CgojCiMgRnJhbWUgYnVmZmVyIGhhcmR3YXJlIGRyaXZlcnMKIwpDT05GSUdfRkJf
Q0lSUlVTPW0KIyBDT05GSUdfRkJfUE0yIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQ1lCRVIyMDAw
IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQVJDIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQVNJTElB
TlQgaXMgbm90IHNldAojIENPTkZJR19GQl9JTVNUVCBpcyBub3Qgc2V0CkNPTkZJR19GQl9WR0Ex
Nj1tCiMgQ09ORklHX0ZCX1VWRVNBIGlzIG5vdCBzZXQKQ09ORklHX0ZCX1ZFU0E9eQpDT05GSUdf
RkJfRUZJPXkKIyBDT05GSUdfRkJfTjQxMSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0hHQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0ZCX1MxRDEzWFhYIGlzIG5vdCBzZXQKQ09ORklHX0ZCX05WSURJQT1t
CkNPTkZJR19GQl9OVklESUFfSTJDPXkKIyBDT05GSUdfRkJfTlZJRElBX0RFQlVHIGlzIG5vdCBz
ZXQKQ09ORklHX0ZCX05WSURJQV9CQUNLTElHSFQ9eQpDT05GSUdfRkJfUklWQT1tCiMgQ09ORklH
X0ZCX1JJVkFfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUklWQV9ERUJVRyBpcyBub3Qgc2V0
CkNPTkZJR19GQl9SSVZBX0JBQ0tMSUdIVD15CiMgQ09ORklHX0ZCX0xFODA1NzggaXMgbm90IHNl
dApDT05GSUdfRkJfTUFUUk9YPW0KQ09ORklHX0ZCX01BVFJPWF9NSUxMRU5JVU09eQpDT05GSUdf
RkJfTUFUUk9YX01ZU1RJUVVFPXkKQ09ORklHX0ZCX01BVFJPWF9HPXkKQ09ORklHX0ZCX01BVFJP
WF9JMkM9bQpDT05GSUdfRkJfTUFUUk9YX01BVkVOPW0KQ09ORklHX0ZCX1JBREVPTj1tCkNPTkZJ
R19GQl9SQURFT05fSTJDPXkKQ09ORklHX0ZCX1JBREVPTl9CQUNLTElHSFQ9eQojIENPTkZJR19G
Ql9SQURFT05fREVCVUcgaXMgbm90IHNldApDT05GSUdfRkJfQVRZMTI4PW0KQ09ORklHX0ZCX0FU
WTEyOF9CQUNLTElHSFQ9eQpDT05GSUdfRkJfQVRZPW0KQ09ORklHX0ZCX0FUWV9DVD15CkNPTkZJ
R19GQl9BVFlfR0VORVJJQ19MQ0Q9eQpDT05GSUdfRkJfQVRZX0dYPXkKQ09ORklHX0ZCX0FUWV9C
QUNLTElHSFQ9eQpDT05GSUdfRkJfUzM9bQpDT05GSUdfRkJfU0FWQUdFPW0KQ09ORklHX0ZCX1NB
VkFHRV9JMkM9eQpDT05GSUdfRkJfU0FWQUdFX0FDQ0VMPXkKIyBDT05GSUdfRkJfU0lTIGlzIG5v
dCBzZXQKQ09ORklHX0ZCX1ZJQT1tCkNPTkZJR19GQl9ORU9NQUdJQz1tCkNPTkZJR19GQl9LWVJP
PW0KQ09ORklHX0ZCXzNERlg9bQpDT05GSUdfRkJfM0RGWF9BQ0NFTD15CkNPTkZJR19GQl8zREZY
X0kyQz15CkNPTkZJR19GQl9WT09ET08xPW0KIyBDT05GSUdfRkJfVlQ4NjIzIGlzIG5vdCBzZXQK
Q09ORklHX0ZCX1RSSURFTlQ9bQojIENPTkZJR19GQl9BUksgaXMgbm90IHNldAojIENPTkZJR19G
Ql9QTTMgaXMgbm90IHNldAojIENPTkZJR19GQl9DQVJNSU5FIGlzIG5vdCBzZXQKIyBDT05GSUdf
RkJfR0VPREUgaXMgbm90IHNldAojIENPTkZJR19GQl9UTUlPIGlzIG5vdCBzZXQKQ09ORklHX0ZC
X1NNNTAxPW0KQ09ORklHX0ZCX1ZJUlRVQUw9bQpDT05GSUdfWEVOX0ZCREVWX0ZST05URU5EPXkK
Q09ORklHX0ZCX01FVFJPTk9NRT1tCkNPTkZJR19GQl9NQjg2MlhYPW0KQ09ORklHX0ZCX01CODYy
WFhfUENJX0dEQz15CiMgQ09ORklHX0ZCX0JST0FEU0hFRVQgaXMgbm90IHNldApDT05GSUdfQkFD
S0xJR0hUX0xDRF9TVVBQT1JUPXkKQ09ORklHX0xDRF9DTEFTU19ERVZJQ0U9bQojIENPTkZJR19M
Q0RfSUxJOTMyMCBpcyBub3Qgc2V0CkNPTkZJR19MQ0RfUExBVEZPUk09bQpDT05GSUdfQkFDS0xJ
R0hUX0NMQVNTX0RFVklDRT15CiMgQ09ORklHX0JBQ0tMSUdIVF9HRU5FUklDIGlzIG5vdCBzZXQK
Q09ORklHX0JBQ0tMSUdIVF9QUk9HRUFSPW0KQ09ORklHX0JBQ0tMSUdIVF9NQlBfTlZJRElBPW0K
IyBDT05GSUdfQkFDS0xJR0hUX1NBSEFSQSBpcyBub3Qgc2V0CgojCiMgRGlzcGxheSBkZXZpY2Ug
c3VwcG9ydAojCkNPTkZJR19ESVNQTEFZX1NVUFBPUlQ9bQoKIwojIERpc3BsYXkgaGFyZHdhcmUg
ZHJpdmVycwojCgojCiMgQ29uc29sZSBkaXNwbGF5IGRyaXZlciBzdXBwb3J0CiMKQ09ORklHX1ZH
QV9DT05TT0xFPXkKQ09ORklHX1ZHQUNPTl9TT0ZUX1NDUk9MTEJBQ0s9eQpDT05GSUdfVkdBQ09O
X1NPRlRfU0NST0xMQkFDS19TSVpFPTY0CkNPTkZJR19EVU1NWV9DT05TT0xFPXkKQ09ORklHX0ZS
QU1FQlVGRkVSX0NPTlNPTEU9eQpDT05GSUdfRlJBTUVCVUZGRVJfQ09OU09MRV9ERVRFQ1RfUFJJ
TUFSWT15CkNPTkZJR19GUkFNRUJVRkZFUl9DT05TT0xFX1JPVEFUSU9OPXkKIyBDT05GSUdfRk9O
VFMgaXMgbm90IHNldApDT05GSUdfRk9OVF84eDg9eQpDT05GSUdfRk9OVF84eDE2PXkKQ09ORklH
X0xPR089eQojIENPTkZJR19MT0dPX0xJTlVYX01PTk8gaXMgbm90IHNldAojIENPTkZJR19MT0dP
X0xJTlVYX1ZHQTE2IGlzIG5vdCBzZXQKQ09ORklHX0xPR09fTElOVVhfQ0xVVDIyND15CkNPTkZJ
R19TT1VORD1tCkNPTkZJR19TT1VORF9PU1NfQ09SRT15CkNPTkZJR19TT1VORF9PU1NfQ09SRV9Q
UkVDTEFJTT15CkNPTkZJR19TTkQ9bQpDT05GSUdfU05EX1RJTUVSPW0KQ09ORklHX1NORF9QQ009
bQpDT05GSUdfU05EX0hXREVQPW0KQ09ORklHX1NORF9SQVdNSURJPW0KQ09ORklHX1NORF9KQUNL
PXkKQ09ORklHX1NORF9TRVFVRU5DRVI9bQpDT05GSUdfU05EX1NFUV9EVU1NWT1tCkNPTkZJR19T
TkRfT1NTRU1VTD15CkNPTkZJR19TTkRfTUlYRVJfT1NTPW0KQ09ORklHX1NORF9QQ01fT1NTPW0K
Q09ORklHX1NORF9QQ01fT1NTX1BMVUdJTlM9eQpDT05GSUdfU05EX1NFUVVFTkNFUl9PU1M9eQpD
T05GSUdfU05EX0hSVElNRVI9bQpDT05GSUdfU05EX1NFUV9IUlRJTUVSX0RFRkFVTFQ9eQpDT05G
SUdfU05EX0RZTkFNSUNfTUlOT1JTPXkKIyBDT05GSUdfU05EX1NVUFBPUlRfT0xEX0FQSSBpcyBu
b3Qgc2V0CkNPTkZJR19TTkRfVkVSQk9TRV9QUk9DRlM9eQpDT05GSUdfU05EX1ZFUkJPU0VfUFJJ
TlRLPXkKQ09ORklHX1NORF9ERUJVRz15CiMgQ09ORklHX1NORF9ERUJVR19WRVJCT1NFIGlzIG5v
dCBzZXQKQ09ORklHX1NORF9QQ01fWFJVTl9ERUJVRz15CkNPTkZJR19TTkRfVk1BU1RFUj15CkNP
TkZJR19TTkRfRE1BX1NHQlVGPXkKQ09ORklHX1NORF9SQVdNSURJX1NFUT1tCkNPTkZJR19TTkRf
T1BMM19MSUJfU0VRPW0KIyBDT05GSUdfU05EX09QTDRfTElCX1NFUSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9TQkFXRV9TRVEgaXMgbm90IHNldApDT05GSUdfU05EX0VNVTEwSzFfU0VRPW0KQ09O
RklHX1NORF9NUFU0MDFfVUFSVD1tCkNPTkZJR19TTkRfT1BMM19MSUI9bQpDT05GSUdfU05EX1ZY
X0xJQj1tCkNPTkZJR19TTkRfQUM5N19DT0RFQz1tCkNPTkZJR19TTkRfRFJJVkVSUz15CkNPTkZJ
R19TTkRfUENTUD1tCkNPTkZJR19TTkRfRFVNTVk9bQpDT05GSUdfU05EX1ZJUk1JREk9bQpDT05G
SUdfU05EX01UUEFWPW0KQ09ORklHX1NORF9NVFM2ND1tCkNPTkZJR19TTkRfU0VSSUFMX1UxNjU1
MD1tCkNPTkZJR19TTkRfTVBVNDAxPW0KQ09ORklHX1NORF9QT1JUTUFOMlg0PW0KQ09ORklHX1NO
RF9BQzk3X1BPV0VSX1NBVkU9eQpDT05GSUdfU05EX0FDOTdfUE9XRVJfU0FWRV9ERUZBVUxUPTAK
Q09ORklHX1NORF9TQl9DT01NT049bQpDT05GSUdfU05EX1NCMTZfRFNQPW0KQ09ORklHX1NORF9Q
Q0k9eQpDT05GSUdfU05EX0FEMTg4OT1tCkNPTkZJR19TTkRfQUxTMzAwPW0KQ09ORklHX1NORF9B
TFM0MDAwPW0KQ09ORklHX1NORF9BTEk1NDUxPW0KQ09ORklHX1NORF9BVElJWFA9bQpDT05GSUdf
U05EX0FUSUlYUF9NT0RFTT1tCkNPTkZJR19TTkRfQVU4ODEwPW0KQ09ORklHX1NORF9BVTg4MjA9
bQpDT05GSUdfU05EX0FVODgzMD1tCiMgQ09ORklHX1NORF9BVzIgaXMgbm90IHNldApDT05GSUdf
U05EX0FaVDMzMjg9bQpDT05GSUdfU05EX0JUODdYPW0KIyBDT05GSUdfU05EX0JUODdYX09WRVJD
TE9DSyBpcyBub3Qgc2V0CkNPTkZJR19TTkRfQ0EwMTA2PW0KQ09ORklHX1NORF9DTUlQQ0k9bQpD
T05GSUdfU05EX09YWUdFTl9MSUI9bQpDT05GSUdfU05EX09YWUdFTj1tCkNPTkZJR19TTkRfQ1M0
MjgxPW0KQ09ORklHX1NORF9DUzQ2WFg9bQpDT05GSUdfU05EX0NTNDZYWF9ORVdfRFNQPXkKQ09O
RklHX1NORF9DUzU1MzA9bQojIENPTkZJR19TTkRfQ1M1NTM1QVVESU8gaXMgbm90IHNldApDT05G
SUdfU05EX0NUWEZJPW0KQ09ORklHX1NORF9EQVJMQTIwPW0KQ09ORklHX1NORF9HSU5BMjA9bQpD
T05GSUdfU05EX0xBWUxBMjA9bQpDT05GSUdfU05EX0RBUkxBMjQ9bQpDT05GSUdfU05EX0dJTkEy
ND1tCkNPTkZJR19TTkRfTEFZTEEyND1tCkNPTkZJR19TTkRfTU9OQT1tCkNPTkZJR19TTkRfTUlB
PW0KQ09ORklHX1NORF9FQ0hPM0c9bQpDT05GSUdfU05EX0lORElHTz1tCkNPTkZJR19TTkRfSU5E
SUdPSU89bQpDT05GSUdfU05EX0lORElHT0RKPW0KQ09ORklHX1NORF9JTkRJR09JT1g9bQpDT05G
SUdfU05EX0lORElHT0RKWD1tCkNPTkZJR19TTkRfRU1VMTBLMT1tCkNPTkZJR19TTkRfRU1VMTBL
MVg9bQpDT05GSUdfU05EX0VOUzEzNzA9bQpDT05GSUdfU05EX0VOUzEzNzE9bQpDT05GSUdfU05E
X0VTMTkzOD1tCkNPTkZJR19TTkRfRVMxOTY4PW0KQ09ORklHX1NORF9GTTgwMT1tCkNPTkZJR19T
TkRfRk04MDFfVEVBNTc1WF9CT09MPXkKQ09ORklHX1NORF9GTTgwMV9URUE1NzVYPW0KQ09ORklH
X1NORF9IREFfSU5URUw9bQpDT05GSUdfU05EX0hEQV9IV0RFUD15CkNPTkZJR19TTkRfSERBX1JF
Q09ORklHPXkKQ09ORklHX1NORF9IREFfSU5QVVRfQkVFUD15CkNPTkZJR19TTkRfSERBX0lOUFVU
X0pBQ0s9eQojIENPTkZJR19TTkRfSERBX1BBVENIX0xPQURFUiBpcyBub3Qgc2V0CkNPTkZJR19T
TkRfSERBX0NPREVDX1JFQUxURUs9eQpDT05GSUdfU05EX0hEQV9DT0RFQ19BTkFMT0c9eQpDT05G
SUdfU05EX0hEQV9DT0RFQ19TSUdNQVRFTD15CkNPTkZJR19TTkRfSERBX0NPREVDX1ZJQT15CkNP
TkZJR19TTkRfSERBX0NPREVDX0FUSUhETUk9eQpDT05GSUdfU05EX0hEQV9DT0RFQ19OVkhETUk9
eQpDT05GSUdfU05EX0hEQV9DT0RFQ19JTlRFTEhETUk9eQpDT05GSUdfU05EX0hEQV9FTEQ9eQpD
T05GSUdfU05EX0hEQV9DT0RFQ19DSVJSVVM9eQpDT05GSUdfU05EX0hEQV9DT0RFQ19DT05FWEFO
VD15CkNPTkZJR19TTkRfSERBX0NPREVDX0NBMDExMD15CkNPTkZJR19TTkRfSERBX0NPREVDX0NN
RURJQT15CkNPTkZJR19TTkRfSERBX0NPREVDX1NJMzA1ND15CkNPTkZJR19TTkRfSERBX0dFTkVS
SUM9eQpDT05GSUdfU05EX0hEQV9QT1dFUl9TQVZFPXkKQ09ORklHX1NORF9IREFfUE9XRVJfU0FW
RV9ERUZBVUxUPTUKQ09ORklHX1NORF9IRFNQPW0KQ09ORklHX1NORF9IRFNQTT1tCkNPTkZJR19T
TkRfSElGSUVSPW0KQ09ORklHX1NORF9JQ0UxNzEyPW0KQ09ORklHX1NORF9JQ0UxNzI0PW0KQ09O
RklHX1NORF9JTlRFTDhYMD1tCkNPTkZJR19TTkRfSU5URUw4WDBNPW0KQ09ORklHX1NORF9LT1JH
MTIxMj1tCkNPTkZJR19TTkRfTFg2NDY0RVM9bQpDT05GSUdfU05EX01BRVNUUk8zPW0KQ09ORklH
X1NORF9NSVhBUlQ9bQpDT05GSUdfU05EX05NMjU2PW0KQ09ORklHX1NORF9QQ1hIUj1tCkNPTkZJ
R19TTkRfUklQVElERT1tCkNPTkZJR19TTkRfUk1FMzI9bQpDT05GSUdfU05EX1JNRTk2PW0KQ09O
RklHX1NORF9STUU5NjUyPW0KQ09ORklHX1NORF9TT05JQ1ZJQkVTPW0KQ09ORklHX1NORF9UUklE
RU5UPW0KQ09ORklHX1NORF9WSUE4MlhYPW0KQ09ORklHX1NORF9WSUE4MlhYX01PREVNPW0KQ09O
RklHX1NORF9WSVJUVU9TTz1tCkNPTkZJR19TTkRfVlgyMjI9bQpDT05GSUdfU05EX1lNRlBDST1t
CkNPTkZJR19TTkRfVVNCPXkKQ09ORklHX1NORF9VU0JfQVVESU89bQpDT05GSUdfU05EX1VTQl9V
U1gyWT1tCkNPTkZJR19TTkRfVVNCX0NBSUFRPW0KQ09ORklHX1NORF9VU0JfQ0FJQVFfSU5QVVQ9
eQpDT05GSUdfU05EX1VTQl9VUzEyMkw9bQpDT05GSUdfU05EX1BDTUNJQT15CkNPTkZJR19TTkRf
VlhQT0NLRVQ9bQpDT05GSUdfU05EX1BEQVVESU9DRj1tCiMgQ09ORklHX1NORF9TT0MgaXMgbm90
IHNldAojIENPTkZJR19TT1VORF9QUklNRSBpcyBub3Qgc2V0CkNPTkZJR19BQzk3X0JVUz1tCkNP
TkZJR19ISURfU1VQUE9SVD15CkNPTkZJR19ISUQ9eQpDT05GSUdfSElEUkFXPXkKCiMKIyBVU0Ig
SW5wdXQgRGV2aWNlcwojCkNPTkZJR19VU0JfSElEPXkKQ09ORklHX0hJRF9QSUQ9eQpDT05GSUdf
VVNCX0hJRERFVj15CgojCiMgU3BlY2lhbCBISUQgZHJpdmVycwojCkNPTkZJR19ISURfQTRURUNI
PXkKQ09ORklHX0hJRF9BUFBMRT15CkNPTkZJR19ISURfQkVMS0lOPXkKQ09ORklHX0hJRF9DSEVS
Ulk9eQpDT05GSUdfSElEX0NISUNPTlk9eQpDT05GSUdfSElEX0NZUFJFU1M9eQpDT05GSUdfSElE
X0RSQUdPTlJJU0U9eQpDT05GSUdfRFJBR09OUklTRV9GRj15CkNPTkZJR19ISURfRVpLRVk9eQpD
T05GSUdfSElEX0tZRT15CkNPTkZJR19ISURfR1lSQVRJT049eQpDT05GSUdfSElEX1RXSU5IQU49
eQpDT05GSUdfSElEX0tFTlNJTkdUT049eQpDT05GSUdfSElEX0xPR0lURUNIPXkKQ09ORklHX0xP
R0lURUNIX0ZGPXkKQ09ORklHX0xPR0lSVU1CTEVQQUQyX0ZGPXkKQ09ORklHX0hJRF9NSUNST1NP
RlQ9eQpDT05GSUdfSElEX01PTlRFUkVZPXkKQ09ORklHX0hJRF9OVFJJRz15CkNPTkZJR19ISURf
UEFOVEhFUkxPUkQ9eQpDT05GSUdfUEFOVEhFUkxPUkRfRkY9eQpDT05GSUdfSElEX1BFVEFMWU5Y
PXkKQ09ORklHX0hJRF9TQU1TVU5HPXkKQ09ORklHX0hJRF9TT05ZPXkKQ09ORklHX0hJRF9TVU5Q
TFVTPXkKQ09ORklHX0hJRF9HUkVFTkFTSUE9eQpDT05GSUdfR1JFRU5BU0lBX0ZGPXkKQ09ORklH
X0hJRF9TTUFSVEpPWVBMVVM9eQpDT05GSUdfU01BUlRKT1lQTFVTX0ZGPXkKQ09ORklHX0hJRF9U
T1BTRUVEPXkKQ09ORklHX0hJRF9USFJVU1RNQVNURVI9eQpDT05GSUdfVEhSVVNUTUFTVEVSX0ZG
PXkKQ09ORklHX0hJRF9XQUNPTT1tCkNPTkZJR19ISURfWkVST1BMVVM9eQpDT05GSUdfWkVST1BM
VVNfRkY9eQpDT05GSUdfVVNCX1NVUFBPUlQ9eQpDT05GSUdfVVNCX0FSQ0hfSEFTX0hDRD15CkNP
TkZJR19VU0JfQVJDSF9IQVNfT0hDST15CkNPTkZJR19VU0JfQVJDSF9IQVNfRUhDST15CkNPTkZJ
R19VU0I9eQojIENPTkZJR19VU0JfREVCVUcgaXMgbm90IHNldApDT05GSUdfVVNCX0FOTk9VTkNF
X05FV19ERVZJQ0VTPXkKCiMKIyBNaXNjZWxsYW5lb3VzIFVTQiBvcHRpb25zCiMKQ09ORklHX1VT
Ql9ERVZJQ0VGUz15CiMgQ09ORklHX1VTQl9ERVZJQ0VfQ0xBU1MgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfRFlOQU1JQ19NSU5PUlMgaXMgbm90IHNldApDT05GSUdfVVNCX1NVU1BFTkQ9eQojIENP
TkZJR19VU0JfT1RHIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9NT049eQpDT05GSUdfVVNCX1dVU0I9
bQpDT05GSUdfVVNCX1dVU0JfQ0JBRj1tCiMgQ09ORklHX1VTQl9XVVNCX0NCQUZfREVCVUcgaXMg
bm90IHNldAoKIwojIFVTQiBIb3N0IENvbnRyb2xsZXIgRHJpdmVycwojCiMgQ09ORklHX1VTQl9D
NjdYMDBfSENEIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9YSENJX0hDRD1tCiMgQ09ORklHX1VTQl9Y
SENJX0hDRF9ERUJVR0dJTkcgaXMgbm90IHNldApDT05GSUdfVVNCX0VIQ0lfSENEPXkKQ09ORklH
X1VTQl9FSENJX1JPT1RfSFVCX1RUPXkKQ09ORklHX1VTQl9FSENJX1RUX05FV1NDSEVEPXkKIyBD
T05GSUdfVVNCX09YVTIxMEhQX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxMTZYX0hD
RCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxNzYwX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9JU1AxMzYyX0hDRCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfT0hDSV9IQ0Q9eQojIENPTkZJ
R19VU0JfT0hDSV9CSUdfRU5ESUFOX0RFU0MgaXMgbm90IHNldAojIENPTkZJR19VU0JfT0hDSV9C
SUdfRU5ESUFOX01NSU8gaXMgbm90IHNldApDT05GSUdfVVNCX09IQ0lfTElUVExFX0VORElBTj15
CkNPTkZJR19VU0JfVUhDSV9IQ0Q9eQpDT05GSUdfVVNCX1UxMzJfSENEPW0KQ09ORklHX1VTQl9T
TDgxMV9IQ0Q9bQojIENPTkZJR19VU0JfU0w4MTFfQ1MgaXMgbm90IHNldAojIENPTkZJR19VU0Jf
UjhBNjY1OTdfSENEIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9XSENJX0hDRD1tCkNPTkZJR19VU0Jf
SFdBX0hDRD1tCgojCiMgVVNCIERldmljZSBDbGFzcyBkcml2ZXJzCiMKQ09ORklHX1VTQl9BQ009
bQpDT05GSUdfVVNCX1BSSU5URVI9bQpDT05GSUdfVVNCX1dETT1tCkNPTkZJR19VU0JfVE1DPW0K
CiMKIyBOT1RFOiBVU0JfU1RPUkFHRSBkZXBlbmRzIG9uIFNDU0kgYnV0IEJMS19ERVZfU0QgbWF5
CiMKCiMKIyBhbHNvIGJlIG5lZWRlZDsgc2VlIFVTQl9TVE9SQUdFIEhlbHAgZm9yIG1vcmUgaW5m
bwojCkNPTkZJR19VU0JfU1RPUkFHRT1tCiMgQ09ORklHX1VTQl9TVE9SQUdFX0RFQlVHIGlzIG5v
dCBzZXQKQ09ORklHX1VTQl9TVE9SQUdFX0RBVEFGQUI9bQpDT05GSUdfVVNCX1NUT1JBR0VfRlJF
RUNPTT1tCkNPTkZJR19VU0JfU1RPUkFHRV9JU0QyMDA9bQpDT05GSUdfVVNCX1NUT1JBR0VfVVNC
QVQ9bQpDT05GSUdfVVNCX1NUT1JBR0VfU0REUjA5PW0KQ09ORklHX1VTQl9TVE9SQUdFX1NERFI1
NT1tCkNPTkZJR19VU0JfU1RPUkFHRV9KVU1QU0hPVD1tCkNPTkZJR19VU0JfU1RPUkFHRV9BTEFV
REE9bQpDT05GSUdfVVNCX1NUT1JBR0VfT05FVE9VQ0g9bQpDT05GSUdfVVNCX1NUT1JBR0VfS0FS
TUE9bQpDT05GSUdfVVNCX1NUT1JBR0VfQ1lQUkVTU19BVEFDQj1tCiMgQ09ORklHX1VTQl9MSUJV
U1VBTCBpcyBub3Qgc2V0CgojCiMgVVNCIEltYWdpbmcgZGV2aWNlcwojCkNPTkZJR19VU0JfTURD
ODAwPW0KQ09ORklHX1VTQl9NSUNST1RFSz1tCgojCiMgVVNCIHBvcnQgZHJpdmVycwojCkNPTkZJ
R19VU0JfVVNTNzIwPW0KQ09ORklHX1VTQl9TRVJJQUw9bQpDT05GSUdfVVNCX0VaVVNCPXkKQ09O
RklHX1VTQl9TRVJJQUxfR0VORVJJQz15CkNPTkZJR19VU0JfU0VSSUFMX0FJUkNBQkxFPW0KQ09O
RklHX1VTQl9TRVJJQUxfQVJLMzExNj1tCkNPTkZJR19VU0JfU0VSSUFMX0JFTEtJTj1tCkNPTkZJ
R19VU0JfU0VSSUFMX0NIMzQxPW0KQ09ORklHX1VTQl9TRVJJQUxfV0hJVEVIRUFUPW0KQ09ORklH
X1VTQl9TRVJJQUxfRElHSV9BQ0NFTEVQT1JUPW0KQ09ORklHX1VTQl9TRVJJQUxfQ1AyMTBYPW0K
Q09ORklHX1VTQl9TRVJJQUxfQ1lQUkVTU19NOD1tCkNPTkZJR19VU0JfU0VSSUFMX0VNUEVHPW0K
Q09ORklHX1VTQl9TRVJJQUxfRlRESV9TSU89bQpDT05GSUdfVVNCX1NFUklBTF9GVU5TT0ZUPW0K
Q09ORklHX1VTQl9TRVJJQUxfVklTT1I9bQpDT05GSUdfVVNCX1NFUklBTF9JUEFRPW0KQ09ORklH
X1VTQl9TRVJJQUxfSVI9bQpDT05GSUdfVVNCX1NFUklBTF9FREdFUE9SVD1tCkNPTkZJR19VU0Jf
U0VSSUFMX0VER0VQT1JUX1RJPW0KQ09ORklHX1VTQl9TRVJJQUxfR0FSTUlOPW0KQ09ORklHX1VT
Ql9TRVJJQUxfSVBXPW0KQ09ORklHX1VTQl9TRVJJQUxfSVVVPW0KQ09ORklHX1VTQl9TRVJJQUxf
S0VZU1BBTl9QREE9bQpDT05GSUdfVVNCX1NFUklBTF9LRVlTUEFOPW0KQ09ORklHX1VTQl9TRVJJ
QUxfS0xTST1tCkNPTkZJR19VU0JfU0VSSUFMX0tPQklMX1NDVD1tCkNPTkZJR19VU0JfU0VSSUFM
X01DVF9VMjMyPW0KQ09ORklHX1VTQl9TRVJJQUxfTU9TNzcyMD1tCkNPTkZJR19VU0JfU0VSSUFM
X01PUzc4NDA9bQpDT05GSUdfVVNCX1NFUklBTF9NT1RPUk9MQT1tCkNPTkZJR19VU0JfU0VSSUFM
X05BVk1BTj1tCkNPTkZJR19VU0JfU0VSSUFMX1BMMjMwMz1tCkNPTkZJR19VU0JfU0VSSUFMX09U
STY4NTg9bQpDT05GSUdfVVNCX1NFUklBTF9RVUFMQ09NTT1tCkNPTkZJR19VU0JfU0VSSUFMX1NQ
Q1A4WDU9bQpDT05GSUdfVVNCX1NFUklBTF9IUDRYPW0KQ09ORklHX1VTQl9TRVJJQUxfU0FGRT1t
CkNPTkZJR19VU0JfU0VSSUFMX1NBRkVfUEFEREVEPXkKQ09ORklHX1VTQl9TRVJJQUxfU0lFTUVO
U19NUEk9bQpDT05GSUdfVVNCX1NFUklBTF9TSUVSUkFXSVJFTEVTUz1tCkNPTkZJR19VU0JfU0VS
SUFMX1NZTUJPTD1tCkNPTkZJR19VU0JfU0VSSUFMX1RJPW0KQ09ORklHX1VTQl9TRVJJQUxfQ1lC
RVJKQUNLPW0KQ09ORklHX1VTQl9TRVJJQUxfWElSQ09NPW0KQ09ORklHX1VTQl9TRVJJQUxfT1BU
SU9OPW0KQ09ORklHX1VTQl9TRVJJQUxfT01OSU5FVD1tCkNPTkZJR19VU0JfU0VSSUFMX09QVElD
T049bQpDT05GSUdfVVNCX1NFUklBTF9ERUJVRz1tCgojCiMgVVNCIE1pc2NlbGxhbmVvdXMgZHJp
dmVycwojCkNPTkZJR19VU0JfRU1JNjI9bQpDT05GSUdfVVNCX0VNSTI2PW0KQ09ORklHX1VTQl9B
RFVUVVg9bQpDT05GSUdfVVNCX1NFVlNFRz1tCiMgQ09ORklHX1VTQl9SSU81MDAgaXMgbm90IHNl
dApDT05GSUdfVVNCX0xFR09UT1dFUj1tCkNPTkZJR19VU0JfTENEPW0KQ09ORklHX1VTQl9CRVJS
WV9DSEFSR0U9bQpDT05GSUdfVVNCX0xFRD1tCiMgQ09ORklHX1VTQl9DWVBSRVNTX0NZN0M2MyBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9DWVRIRVJNIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9JRE1P
VVNFPW0KQ09ORklHX1VTQl9GVERJX0VMQU49bQpDT05GSUdfVVNCX0FQUExFRElTUExBWT1tCkNP
TkZJR19VU0JfU0lTVVNCVkdBPW0KQ09ORklHX1VTQl9TSVNVU0JWR0FfQ09OPXkKQ09ORklHX1VT
Ql9MRD1tCkNPTkZJR19VU0JfVFJBTkNFVklCUkFUT1I9bQpDT05GSUdfVVNCX0lPV0FSUklPUj1t
CiMgQ09ORklHX1VTQl9URVNUIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9JU0lHSFRGVz1tCkNPTkZJ
R19VU0JfVlNUPW0KQ09ORklHX1VTQl9BVE09bQpDT05GSUdfVVNCX1NQRUVEVE9VQ0g9bQpDT05G
SUdfVVNCX0NYQUNSVT1tCkNPTkZJR19VU0JfVUVBR0xFQVRNPW0KQ09ORklHX1VTQl9YVVNCQVRN
PW0KIyBDT05GSUdfVVNCX0dBREdFVCBpcyBub3Qgc2V0CgojCiMgT1RHIGFuZCByZWxhdGVkIGlu
ZnJhc3RydWN0dXJlCiMKQ09ORklHX1VTQl9PVEdfVVRJTFM9eQpDT05GSUdfTk9QX1VTQl9YQ0VJ
Vj1tCkNPTkZJR19VV0I9bQpDT05GSUdfVVdCX0hXQT1tCkNPTkZJR19VV0JfV0hDST1tCkNPTkZJ
R19VV0JfV0xQPW0KQ09ORklHX1VXQl9JMTQ4MFU9bQpDT05GSUdfVVdCX0kxNDgwVV9XTFA9bQpD
T05GSUdfTU1DPW0KIyBDT05GSUdfTU1DX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DX1VO
U0FGRV9SRVNVTUUgaXMgbm90IHNldAoKIwojIE1NQy9TRC9TRElPIENhcmQgRHJpdmVycwojCkNP
TkZJR19NTUNfQkxPQ0s9bQpDT05GSUdfTU1DX0JMT0NLX0JPVU5DRT15CkNPTkZJR19TRElPX1VB
UlQ9bQojIENPTkZJR19NTUNfVEVTVCBpcyBub3Qgc2V0CgojCiMgTU1DL1NEL1NESU8gSG9zdCBD
b250cm9sbGVyIERyaXZlcnMKIwpDT05GSUdfTU1DX1NESENJPW0KQ09ORklHX01NQ19TREhDSV9Q
Q0k9bQpDT05GSUdfTU1DX1JJQ09IX01NQz1tCkNPTkZJR19NTUNfU0RIQ0lfUExURk09bQpDT05G
SUdfTU1DX1dCU0Q9bQojIENPTkZJR19NTUNfQVQ5MSBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19B
VE1FTE1DSSBpcyBub3Qgc2V0CkNPTkZJR19NTUNfVElGTV9TRD1tCkNPTkZJR19NTUNfU0RSSUNP
SF9DUz1tCkNPTkZJR19NTUNfQ0I3MTA9bQpDT05GSUdfTU1DX1ZJQV9TRE1NQz1tCkNPTkZJR19N
RU1TVElDSz1tCiMgQ09ORklHX01FTVNUSUNLX0RFQlVHIGlzIG5vdCBzZXQKCiMKIyBNZW1vcnlT
dGljayBkcml2ZXJzCiMKIyBDT05GSUdfTUVNU1RJQ0tfVU5TQUZFX1JFU1VNRSBpcyBub3Qgc2V0
CkNPTkZJR19NU1BST19CTE9DSz1tCgojCiMgTWVtb3J5U3RpY2sgSG9zdCBDb250cm9sbGVyIERy
aXZlcnMKIwpDT05GSUdfTUVNU1RJQ0tfVElGTV9NUz1tCkNPTkZJR19NRU1TVElDS19KTUlDUk9O
XzM4WD1tCkNPTkZJR19ORVdfTEVEUz15CkNPTkZJR19MRURTX0NMQVNTPXkKCiMKIyBMRUQgZHJp
dmVycwojCkNPTkZJR19MRURTX0FMSVgyPW0KIyBDT05GSUdfTEVEU19QQ0E5NTMyIGlzIG5vdCBz
ZXQKQ09ORklHX0xFRFNfTFAzOTQ0PW0KQ09ORklHX0xFRFNfQ0xFVk9fTUFJTD1tCiMgQ09ORklH
X0xFRFNfUENBOTU1WCBpcyBub3Qgc2V0CkNPTkZJR19MRURTX1dNODM1MD1tCiMgQ09ORklHX0xF
RFNfQkQyODAyIGlzIG5vdCBzZXQKCiMKIyBMRUQgVHJpZ2dlcnMKIwpDT05GSUdfTEVEU19UUklH
R0VSUz15CkNPTkZJR19MRURTX1RSSUdHRVJfVElNRVI9bQpDT05GSUdfTEVEU19UUklHR0VSX0hF
QVJUQkVBVD1tCkNPTkZJR19MRURTX1RSSUdHRVJfQkFDS0xJR0hUPW0KQ09ORklHX0xFRFNfVFJJ
R0dFUl9ERUZBVUxUX09OPW0KCiMKIyBpcHRhYmxlcyB0cmlnZ2VyIGlzIHVuZGVyIE5ldGZpbHRl
ciBjb25maWcgKExFRCB0YXJnZXQpCiMKQ09ORklHX0FDQ0VTU0lCSUxJVFk9eQpDT05GSUdfQTEx
WV9CUkFJTExFX0NPTlNPTEU9eQpDT05GSUdfSU5GSU5JQkFORD1tCkNPTkZJR19JTkZJTklCQU5E
X1VTRVJfTUFEPW0KQ09ORklHX0lORklOSUJBTkRfVVNFUl9BQ0NFU1M9bQpDT05GSUdfSU5GSU5J
QkFORF9VU0VSX01FTT15CkNPTkZJR19JTkZJTklCQU5EX0FERFJfVFJBTlM9eQpDT05GSUdfSU5G
SU5JQkFORF9NVEhDQT1tCkNPTkZJR19JTkZJTklCQU5EX01USENBX0RFQlVHPXkKQ09ORklHX0lO
RklOSUJBTkRfSVBBVEg9bQpDT05GSUdfSU5GSU5JQkFORF9BTVNPMTEwMD1tCiMgQ09ORklHX0lO
RklOSUJBTkRfQU1TTzExMDBfREVCVUcgaXMgbm90IHNldApDT05GSUdfSU5GSU5JQkFORF9DWEdC
Mz1tCiMgQ09ORklHX0lORklOSUJBTkRfQ1hHQjNfREVCVUcgaXMgbm90IHNldApDT05GSUdfTUxY
NF9JTkZJTklCQU5EPW0KQ09ORklHX0lORklOSUJBTkRfTkVTPW0KIyBDT05GSUdfSU5GSU5JQkFO
RF9ORVNfREVCVUcgaXMgbm90IHNldApDT05GSUdfSU5GSU5JQkFORF9JUE9JQj1tCkNPTkZJR19J
TkZJTklCQU5EX0lQT0lCX0NNPXkKQ09ORklHX0lORklOSUJBTkRfSVBPSUJfREVCVUc9eQpDT05G
SUdfSU5GSU5JQkFORF9JUE9JQl9ERUJVR19EQVRBPXkKQ09ORklHX0lORklOSUJBTkRfU1JQPW0K
Q09ORklHX0lORklOSUJBTkRfSVNFUj1tCkNPTkZJR19FREFDPXkKCiMKIyBSZXBvcnRpbmcgc3Vi
c3lzdGVtcwojCiMgQ09ORklHX0VEQUNfREVCVUcgaXMgbm90IHNldApDT05GSUdfRURBQ19ERUNP
REVfTUNFPXkKQ09ORklHX0VEQUNfTU1fRURBQz1tCkNPTkZJR19FREFDX0FNRDY0PW0KIyBDT05G
SUdfRURBQ19BTUQ2NF9FUlJPUl9JTkpFQ1RJT04gaXMgbm90IHNldApDT05GSUdfRURBQ19FNzUy
WD1tCkNPTkZJR19FREFDX0k4Mjk3NVg9bQpDT05GSUdfRURBQ19JMzAwMD1tCiMgQ09ORklHX0VE
QUNfSTMyMDAgaXMgbm90IHNldApDT05GSUdfRURBQ19YMzg9bQpDT05GSUdfRURBQ19JNTQwMD1t
CkNPTkZJR19FREFDX0k1MDAwPW0KQ09ORklHX0VEQUNfSTUxMDA9bQpDT05GSUdfUlRDX0xJQj15
CkNPTkZJR19SVENfQ0xBU1M9eQpDT05GSUdfUlRDX0hDVE9TWVM9eQpDT05GSUdfUlRDX0hDVE9T
WVNfREVWSUNFPSJydGMwIgojIENPTkZJR19SVENfREVCVUcgaXMgbm90IHNldAoKIwojIFJUQyBp
bnRlcmZhY2VzCiMKQ09ORklHX1JUQ19JTlRGX1NZU0ZTPXkKQ09ORklHX1JUQ19JTlRGX1BST0M9
eQpDT05GSUdfUlRDX0lOVEZfREVWPXkKIyBDT05GSUdfUlRDX0lOVEZfREVWX1VJRV9FTVVMIGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9URVNUIGlzIG5vdCBzZXQKCiMKIyBJMkMgUlRDIGRy
aXZlcnMKIwpDT05GSUdfUlRDX0RSVl9EUzEzMDc9bQpDT05GSUdfUlRDX0RSVl9EUzEzNzQ9bQpD
T05GSUdfUlRDX0RSVl9EUzE2NzI9bQpDT05GSUdfUlRDX0RSVl9NQVg2OTAwPW0KQ09ORklHX1JU
Q19EUlZfUlM1QzM3Mj1tCkNPTkZJR19SVENfRFJWX0lTTDEyMDg9bQpDT05GSUdfUlRDX0RSVl9Y
MTIwNT1tCkNPTkZJR19SVENfRFJWX1BDRjg1NjM9bQpDT05GSUdfUlRDX0RSVl9QQ0Y4NTgzPW0K
Q09ORklHX1JUQ19EUlZfTTQxVDgwPW0KQ09ORklHX1JUQ19EUlZfTTQxVDgwX1dEVD15CiMgQ09O
RklHX1JUQ19EUlZfUzM1MzkwQSBpcyBub3Qgc2V0CkNPTkZJR19SVENfRFJWX0ZNMzEzMD1tCkNP
TkZJR19SVENfRFJWX1JYODU4MT1tCkNPTkZJR19SVENfRFJWX1JYODAyNT1tCgojCiMgU1BJIFJU
QyBkcml2ZXJzCiMKCiMKIyBQbGF0Zm9ybSBSVEMgZHJpdmVycwojCkNPTkZJR19SVENfRFJWX0NN
T1M9eQpDT05GSUdfUlRDX0RSVl9EUzEyODY9bQpDT05GSUdfUlRDX0RSVl9EUzE1MTE9bQpDT05G
SUdfUlRDX0RSVl9EUzE1NTM9bQpDT05GSUdfUlRDX0RSVl9EUzE3NDI9bQpDT05GSUdfUlRDX0RS
Vl9TVEsxN1RBOD1tCiMgQ09ORklHX1JUQ19EUlZfTTQ4VDg2IGlzIG5vdCBzZXQKQ09ORklHX1JU
Q19EUlZfTTQ4VDM1PW0KQ09ORklHX1JUQ19EUlZfTTQ4VDU5PW0KQ09ORklHX1JUQ19EUlZfQlE0
ODAyPW0KQ09ORklHX1JUQ19EUlZfVjMwMjA9bQpDT05GSUdfUlRDX0RSVl9XTTgzNTA9bQpDT05G
SUdfUlRDX0RSVl9BQjMxMDA9bQoKIwojIG9uLUNQVSBSVEMgZHJpdmVycwojCkNPTkZJR19ETUFE
RVZJQ0VTPXkKCiMKIyBETUEgRGV2aWNlcwojCkNPTkZJR19BU1lOQ19UWF9ESVNBQkxFX0NIQU5O
RUxfU1dJVENIPXkKQ09ORklHX0lOVEVMX0lPQVRETUE9bQpDT05GSUdfRE1BX0VOR0lORT15Cgoj
CiMgRE1BIENsaWVudHMKIwpDT05GSUdfTkVUX0RNQT15CkNPTkZJR19BU1lOQ19UWF9ETUE9eQoj
IENPTkZJR19ETUFURVNUIGlzIG5vdCBzZXQKQ09ORklHX0RDQT1tCkNPTkZJR19BVVhESVNQTEFZ
PXkKQ09ORklHX0tTMDEwOD1tCkNPTkZJR19LUzAxMDhfUE9SVD0weDM3OApDT05GSUdfS1MwMTA4
X0RFTEFZPTIKQ09ORklHX0NGQUcxMjg2NEI9bQpDT05GSUdfQ0ZBRzEyODY0Ql9SQVRFPTIwCkNP
TkZJR19VSU89bQpDT05GSUdfVUlPX0NJRj1tCkNPTkZJR19VSU9fUERSVj1tCkNPTkZJR19VSU9f
UERSVl9HRU5JUlE9bQpDT05GSUdfVUlPX1NNWD1tCkNPTkZJR19VSU9fQUVDPW0KQ09ORklHX1VJ
T19TRVJDT1MzPW0KIyBDT05GSUdfVUlPX1BDSV9HRU5FUklDIGlzIG5vdCBzZXQKCiMKIyBUSSBW
TFlOUQojCkNPTkZJR19YRU5fQkFMTE9PTj15CkNPTkZJR19YRU5fU0NSVUJfUEFHRVM9eQpDT05G
SUdfWEVOX0RFVl9FVlRDSE49bQpDT05GSUdfWEVORlM9bQpDT05GSUdfWEVOX0NPTVBBVF9YRU5G
Uz15CkNPTkZJR19YRU5fU1lTX0hZUEVSVklTT1I9eQpDT05GSUdfU1RBR0lORz15CiMgQ09ORklH
X1NUQUdJTkdfRVhDTFVERV9CVUlMRCBpcyBub3Qgc2V0CiMgQ09ORklHX0VUMTMxWCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NMSUNPU1MgaXMgbm90IHNldAojIENPTkZJR19WSURFT19HTzcwMDcgaXMg
bm90IHNldAojIENPTkZJR19WSURFT19DWDI1ODIxIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lQ
X0NPTU1PTiBpcyBub3Qgc2V0CiMgQ09ORklHX1czNVVORCBpcyBub3Qgc2V0CiMgQ09ORklHX1BS
SVNNMl9VU0IgaXMgbm90IHNldAojIENPTkZJR19FQ0hPIGlzIG5vdCBzZXQKIyBDT05GSUdfUE9D
SCBpcyBub3Qgc2V0CiMgQ09ORklHX09UVVMgaXMgbm90IHNldAojIENPTkZJR19SVDI4NjAgaXMg
bm90IHNldAojIENPTkZJR19SVDI4NzAgaXMgbm90IHNldAojIENPTkZJR19SVDMwOTAgaXMgbm90
IHNldAojIENPTkZJR19DT01FREkgaXMgbm90IHNldAojIENPTkZJR19BU1VTX09MRUQgaXMgbm90
IHNldAojIENPTkZJR19QQU5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX0FMVEVSQV9QQ0lFX0NIRE1B
IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRMODE4N1NFIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRMODE5
MlNVIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRMODE5MkUgaXMgbm90IHNldAojIENPTkZJR19JTlBV
VF9NSU1JTyBpcyBub3Qgc2V0CiMgQ09ORklHX1RSQU5aUE9SVCBpcyBub3Qgc2V0CgojCiMgQW5k
cm9pZAojCgojCiMgUXVhbGNvbW0gTVNNIENhbWVyYSBBbmQgVmlkZW8KIwoKIwojIENhbWVyYSBT
ZW5zb3IgU2VsZWN0aW9uCiMKIyBDT05GSUdfSU5QVVRfR1BJTyBpcyBub3Qgc2V0CiMgQ09ORklH
X0RTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1BPSE1FTEZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQjNE
RkcgaXMgbm90IHNldAojIENPTkZJR19JREVfUEhJU09OIGlzIG5vdCBzZXQKIyBDT05GSUdfUExB
TjlBVVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfTElORTZfVVNCIGlzIG5vdCBzZXQKQ09ORklHX0RS
TV9SQURFT05fS01TPXkKIyBDT05GSUdfVVNCX1NFUklBTF9RVUFURUNIMiBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9TRVJJQUxfUVVBVEVDSF9VU0IyIGlzIG5vdCBzZXQKIyBDT05GSUdfVlQ2NjU1
IGlzIG5vdCBzZXQKIyBDT05GSUdfVlQ2NjU2IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfVURMIGlz
IG5vdCBzZXQKIyBDT05GSUdfSFlQRVJWIGlzIG5vdCBzZXQKIyBDT05GSUdfVk1FX0JVUyBpcyBu
b3Qgc2V0CgojCiMgUkFSIFJlZ2lzdGVyIERyaXZlcgojCiMgQ09ORklHX1JBUl9SRUdJU1RFUiBp
cyBub3Qgc2V0CiMgQ09ORklHX0lJTyBpcyBub3Qgc2V0CkNPTkZJR19YODZfUExBVEZPUk1fREVW
SUNFUz15CkNPTkZJR19BQ0VSX1dNST1tCkNPTkZJR19BQ0VSSERGPW0KQ09ORklHX0FTVVNfTEFQ
VE9QPW0KQ09ORklHX0RFTExfV01JPW0KQ09ORklHX0ZVSklUU1VfTEFQVE9QPW0KIyBDT05GSUdf
RlVKSVRTVV9MQVBUT1BfREVCVUcgaXMgbm90IHNldApDT05GSUdfSFBfV01JPW0KQ09ORklHX01T
SV9MQVBUT1A9bQpDT05GSUdfUEFOQVNPTklDX0xBUFRPUD1tCkNPTkZJR19DT01QQUxfTEFQVE9Q
PW0KQ09ORklHX1NPTllfTEFQVE9QPW0KQ09ORklHX1NPTllQSV9DT01QQVQ9eQpDT05GSUdfVEhJ
TktQQURfQUNQST1tCiMgQ09ORklHX1RISU5LUEFEX0FDUElfREVCVUdGQUNJTElUSUVTIGlzIG5v
dCBzZXQKIyBDT05GSUdfVEhJTktQQURfQUNQSV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1RI
SU5LUEFEX0FDUElfVU5TQUZFX0xFRFMgaXMgbm90IHNldApDT05GSUdfVEhJTktQQURfQUNQSV9W
SURFTz15CkNPTkZJR19USElOS1BBRF9BQ1BJX0hPVEtFWV9QT0xMPXkKIyBDT05GSUdfSU5URUxf
TUVOTE9XIGlzIG5vdCBzZXQKIyBDT05GSUdfRUVFUENfTEFQVE9QIGlzIG5vdCBzZXQKQ09ORklH
X0FDUElfV01JPW0KIyBDT05GSUdfQUNQSV9BU1VTIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9QU1RB
Ul9MQVBUT1AgaXMgbm90IHNldApDT05GSUdfQUNQSV9UT1NISUJBPW0KCiMKIyBGaXJtd2FyZSBE
cml2ZXJzCiMKQ09ORklHX0VERD1tCiMgQ09ORklHX0VERF9PRkYgaXMgbm90IHNldApDT05GSUdf
RklSTVdBUkVfTUVNTUFQPXkKQ09ORklHX0VGSV9WQVJTPXkKQ09ORklHX0RFTExfUkJVPW0KQ09O
RklHX0RDREJBUz1tCkNPTkZJR19ETUlJRD15CkNPTkZJR19JU0NTSV9JQkZUX0ZJTkQ9eQpDT05G
SUdfSVNDU0lfSUJGVD1tCgojCiMgRmlsZSBzeXN0ZW1zCiMKQ09ORklHX0VYVDJfRlM9bQpDT05G
SUdfRVhUMl9GU19YQVRUUj15CkNPTkZJR19FWFQyX0ZTX1BPU0lYX0FDTD15CkNPTkZJR19FWFQy
X0ZTX1NFQ1VSSVRZPXkKQ09ORklHX0VYVDJfRlNfWElQPXkKQ09ORklHX0VYVDNfRlM9eQpDT05G
SUdfRVhUM19ERUZBVUxUU19UT19PUkRFUkVEPXkKQ09ORklHX0VYVDNfRlNfWEFUVFI9eQpDT05G
SUdfRVhUM19GU19QT1NJWF9BQ0w9eQpDT05GSUdfRVhUM19GU19TRUNVUklUWT15CkNPTkZJR19F
WFQ0X0ZTPXkKQ09ORklHX0VYVDRfRlNfWEFUVFI9eQpDT05GSUdfRVhUNF9GU19QT1NJWF9BQ0w9
eQpDT05GSUdfRVhUNF9GU19TRUNVUklUWT15CiMgQ09ORklHX0VYVDRfREVCVUcgaXMgbm90IHNl
dApDT05GSUdfRlNfWElQPXkKQ09ORklHX0pCRD15CiMgQ09ORklHX0pCRF9ERUJVRyBpcyBub3Qg
c2V0CkNPTkZJR19KQkQyPXkKQ09ORklHX0pCRDJfREVCVUc9eQpDT05GSUdfRlNfTUJDQUNIRT15
CkNPTkZJR19SRUlTRVJGU19GUz1tCiMgQ09ORklHX1JFSVNFUkZTX0NIRUNLIGlzIG5vdCBzZXQK
Q09ORklHX1JFSVNFUkZTX1BST0NfSU5GTz15CkNPTkZJR19SRUlTRVJGU19GU19YQVRUUj15CkNP
TkZJR19SRUlTRVJGU19GU19QT1NJWF9BQ0w9eQpDT05GSUdfUkVJU0VSRlNfRlNfU0VDVVJJVFk9
eQpDT05GSUdfSkZTX0ZTPW0KQ09ORklHX0pGU19QT1NJWF9BQ0w9eQpDT05GSUdfSkZTX1NFQ1VS
SVRZPXkKIyBDT05GSUdfSkZTX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfSkZTX1NUQVRJU1RJ
Q1MgaXMgbm90IHNldApDT05GSUdfRlNfUE9TSVhfQUNMPXkKQ09ORklHX1hGU19GUz1tCkNPTkZJ
R19YRlNfUVVPVEE9eQpDT05GSUdfWEZTX1BPU0lYX0FDTD15CiMgQ09ORklHX1hGU19SVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1hGU19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19HRlMyX0ZTPW0KQ09O
RklHX0dGUzJfRlNfTE9DS0lOR19ETE09eQpDT05GSUdfT0NGUzJfRlM9bQpDT05GSUdfT0NGUzJf
RlNfTzJDQj1tCkNPTkZJR19PQ0ZTMl9GU19VU0VSU1BBQ0VfQ0xVU1RFUj1tCiMgQ09ORklHX09D
RlMyX0ZTX1NUQVRTIGlzIG5vdCBzZXQKIyBDT05GSUdfT0NGUzJfREVCVUdfTUFTS0xPRyBpcyBu
b3Qgc2V0CiMgQ09ORklHX09DRlMyX0RFQlVHX0ZTIGlzIG5vdCBzZXQKQ09ORklHX09DRlMyX0ZT
X1BPU0lYX0FDTD15CkNPTkZJR19CVFJGU19GUz1tCkNPTkZJR19CVFJGU19GU19QT1NJWF9BQ0w9
eQpDT05GSUdfTklMRlMyX0ZTPW0KQ09ORklHX0ZJTEVfTE9DS0lORz15CkNPTkZJR19GU05PVElG
WT15CkNPTkZJR19ETk9USUZZPXkKQ09ORklHX0lOT1RJRlk9eQpDT05GSUdfSU5PVElGWV9VU0VS
PXkKQ09ORklHX1FVT1RBPXkKQ09ORklHX1FVT1RBX05FVExJTktfSU5URVJGQUNFPXkKIyBDT05G
SUdfUFJJTlRfUVVPVEFfV0FSTklORyBpcyBub3Qgc2V0CkNPTkZJR19RVU9UQV9UUkVFPXkKIyBD
T05GSUdfUUZNVF9WMSBpcyBub3Qgc2V0CkNPTkZJR19RRk1UX1YyPXkKQ09ORklHX1FVT1RBQ1RM
PXkKIyBDT05GSUdfQVVUT0ZTX0ZTIGlzIG5vdCBzZXQKQ09ORklHX0FVVE9GUzRfRlM9bQpDT05G
SUdfRlVTRV9GUz1tCkNPTkZJR19DVVNFPW0KQ09ORklHX0dFTkVSSUNfQUNMPXkKCiMKIyBDYWNo
ZXMKIwpDT05GSUdfRlNDQUNIRT1tCkNPTkZJR19GU0NBQ0hFX1NUQVRTPXkKIyBDT05GSUdfRlND
QUNIRV9ISVNUT0dSQU0gaXMgbm90IHNldAojIENPTkZJR19GU0NBQ0hFX0RFQlVHIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRlNDQUNIRV9PQkpFQ1RfTElTVCBpcyBub3Qgc2V0CkNPTkZJR19DQUNIRUZJ
TEVTPW0KIyBDT05GSUdfQ0FDSEVGSUxFU19ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0NBQ0hF
RklMRVNfSElTVE9HUkFNIGlzIG5vdCBzZXQKCiMKIyBDRC1ST00vRFZEIEZpbGVzeXN0ZW1zCiMK
Q09ORklHX0lTTzk2NjBfRlM9eQpDT05GSUdfSk9MSUVUPXkKQ09ORklHX1pJU09GUz15CkNPTkZJ
R19VREZfRlM9bQpDT05GSUdfVURGX05MUz15CgojCiMgRE9TL0ZBVC9OVCBGaWxlc3lzdGVtcwoj
CkNPTkZJR19GQVRfRlM9bQpDT05GSUdfTVNET1NfRlM9bQpDT05GSUdfVkZBVF9GUz1tCkNPTkZJ
R19GQVRfREVGQVVMVF9DT0RFUEFHRT00MzcKQ09ORklHX0ZBVF9ERUZBVUxUX0lPQ0hBUlNFVD0i
YXNjaWkiCiMgQ09ORklHX05URlNfRlMgaXMgbm90IHNldAoKIwojIFBzZXVkbyBmaWxlc3lzdGVt
cwojCkNPTkZJR19QUk9DX0ZTPXkKQ09ORklHX1BST0NfS0NPUkU9eQpDT05GSUdfUFJPQ19WTUNP
UkU9eQpDT05GSUdfUFJPQ19TWVNDVEw9eQpDT05GSUdfUFJPQ19QQUdFX01PTklUT1I9eQpDT05G
SUdfU1lTRlM9eQpDT05GSUdfVE1QRlM9eQpDT05GSUdfVE1QRlNfUE9TSVhfQUNMPXkKQ09ORklH
X0hVR0VUTEJGUz15CkNPTkZJR19IVUdFVExCX1BBR0U9eQpDT05GSUdfQ09ORklHRlNfRlM9bQpD
T05GSUdfTUlTQ19GSUxFU1lTVEVNUz15CiMgQ09ORklHX0FERlNfRlMgaXMgbm90IHNldApDT05G
SUdfQUZGU19GUz1tCkNPTkZJR19FQ1JZUFRfRlM9bQpDT05GSUdfSEZTX0ZTPW0KQ09ORklHX0hG
U1BMVVNfRlM9bQpDT05GSUdfQkVGU19GUz1tCiMgQ09ORklHX0JFRlNfREVCVUcgaXMgbm90IHNl
dApDT05GSUdfQkZTX0ZTPW0KQ09ORklHX0VGU19GUz1tCkNPTkZJR19KRkZTMl9GUz1tCkNPTkZJ
R19KRkZTMl9GU19ERUJVRz0wCkNPTkZJR19KRkZTMl9GU19XUklURUJVRkZFUj15CiMgQ09ORklH
X0pGRlMyX0ZTX1dCVUZfVkVSSUZZIGlzIG5vdCBzZXQKQ09ORklHX0pGRlMyX1NVTU1BUlk9eQpD
T05GSUdfSkZGUzJfRlNfWEFUVFI9eQpDT05GSUdfSkZGUzJfRlNfUE9TSVhfQUNMPXkKQ09ORklH
X0pGRlMyX0ZTX1NFQ1VSSVRZPXkKIyBDT05GSUdfSkZGUzJfQ09NUFJFU1NJT05fT1BUSU9OUyBp
cyBub3Qgc2V0CkNPTkZJR19KRkZTMl9aTElCPXkKIyBDT05GSUdfSkZGUzJfTFpPIGlzIG5vdCBz
ZXQKQ09ORklHX0pGRlMyX1JUSU1FPXkKIyBDT05GSUdfSkZGUzJfUlVCSU4gaXMgbm90IHNldApD
T05GSUdfVUJJRlNfRlM9bQpDT05GSUdfVUJJRlNfRlNfWEFUVFI9eQojIENPTkZJR19VQklGU19G
U19BRFZBTkNFRF9DT01QUiBpcyBub3Qgc2V0CkNPTkZJR19VQklGU19GU19MWk89eQpDT05GSUdf
VUJJRlNfRlNfWkxJQj15CiMgQ09ORklHX1VCSUZTX0ZTX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklH
X0NSQU1GUz1tCkNPTkZJR19TUVVBU0hGUz1tCiMgQ09ORklHX1NRVUFTSEZTX0VNQkVEREVEIGlz
IG5vdCBzZXQKQ09ORklHX1NRVUFTSEZTX0ZSQUdNRU5UX0NBQ0hFX1NJWkU9MwpDT05GSUdfVlhG
U19GUz1tCkNPTkZJR19NSU5JWF9GUz1tCkNPTkZJR19PTUZTX0ZTPW0KIyBDT05GSUdfSFBGU19G
UyBpcyBub3Qgc2V0CkNPTkZJR19RTlg0RlNfRlM9bQpDT05GSUdfUk9NRlNfRlM9bQpDT05GSUdf
Uk9NRlNfQkFDS0VEX0JZX0JMT0NLPXkKIyBDT05GSUdfUk9NRlNfQkFDS0VEX0JZX01URCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JPTUZTX0JBQ0tFRF9CWV9CT1RIIGlzIG5vdCBzZXQKQ09ORklHX1JP
TUZTX09OX0JMT0NLPXkKQ09ORklHX1NZU1ZfRlM9bQpDT05GSUdfVUZTX0ZTPW0KIyBDT05GSUdf
VUZTX0ZTX1dSSVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfVUZTX0RFQlVHIGlzIG5vdCBzZXQKQ09O
RklHX0VYT0ZTX0ZTPW0KIyBDT05GSUdfRVhPRlNfREVCVUcgaXMgbm90IHNldApDT05GSUdfTkVU
V09SS19GSUxFU1lTVEVNUz15CkNPTkZJR19ORlNfRlM9bQpDT05GSUdfTkZTX1YzPXkKQ09ORklH
X05GU19WM19BQ0w9eQpDT05GSUdfTkZTX1Y0PXkKIyBDT05GSUdfTkZTX1Y0XzEgaXMgbm90IHNl
dApDT05GSUdfTkZTX0ZTQ0FDSEU9eQpDT05GSUdfTkZTRD1tCkNPTkZJR19ORlNEX1YyX0FDTD15
CkNPTkZJR19ORlNEX1YzPXkKQ09ORklHX05GU0RfVjNfQUNMPXkKQ09ORklHX05GU0RfVjQ9eQpD
T05GSUdfTE9DS0Q9bQpDT05GSUdfTE9DS0RfVjQ9eQpDT05GSUdfRVhQT1JURlM9bQpDT05GSUdf
TkZTX0FDTF9TVVBQT1JUPW0KQ09ORklHX05GU19DT01NT049eQpDT05GSUdfU1VOUlBDPW0KQ09O
RklHX1NVTlJQQ19HU1M9bQpDT05GSUdfU1VOUlBDX1hQUlRfUkRNQT1tCkNPTkZJR19SUENTRUNf
R1NTX0tSQjU9bQpDT05GSUdfUlBDU0VDX0dTU19TUEtNMz1tCiMgQ09ORklHX1NNQl9GUyBpcyBu
b3Qgc2V0CkNPTkZJR19DSUZTPW0KQ09ORklHX0NJRlNfU1RBVFM9eQojIENPTkZJR19DSUZTX1NU
QVRTMiBpcyBub3Qgc2V0CkNPTkZJR19DSUZTX1dFQUtfUFdfSEFTSD15CkNPTkZJR19DSUZTX1VQ
Q0FMTD15CkNPTkZJR19DSUZTX1hBVFRSPXkKQ09ORklHX0NJRlNfUE9TSVg9eQojIENPTkZJR19D
SUZTX0RFQlVHMiBpcyBub3Qgc2V0CkNPTkZJR19DSUZTX0RGU19VUENBTEw9eQpDT05GSUdfQ0lG
U19FWFBFUklNRU5UQUw9eQpDT05GSUdfTkNQX0ZTPW0KQ09ORklHX05DUEZTX1BBQ0tFVF9TSUdO
SU5HPXkKQ09ORklHX05DUEZTX0lPQ1RMX0xPQ0tJTkc9eQpDT05GSUdfTkNQRlNfU1RST05HPXkK
Q09ORklHX05DUEZTX05GU19OUz15CkNPTkZJR19OQ1BGU19PUzJfTlM9eQpDT05GSUdfTkNQRlNf
U01BTExET1M9eQpDT05GSUdfTkNQRlNfTkxTPXkKQ09ORklHX05DUEZTX0VYVFJBUz15CkNPTkZJ
R19DT0RBX0ZTPW0KIyBDT05GSUdfQUZTX0ZTIGlzIG5vdCBzZXQKQ09ORklHXzlQX0ZTPW0KIyBD
T05GSUdfOVBfRlNDQUNIRSBpcyBub3Qgc2V0CgojCiMgUGFydGl0aW9uIFR5cGVzCiMKQ09ORklH
X1BBUlRJVElPTl9BRFZBTkNFRD15CiMgQ09ORklHX0FDT1JOX1BBUlRJVElPTiBpcyBub3Qgc2V0
CkNPTkZJR19PU0ZfUEFSVElUSU9OPXkKQ09ORklHX0FNSUdBX1BBUlRJVElPTj15CiMgQ09ORklH
X0FUQVJJX1BBUlRJVElPTiBpcyBub3Qgc2V0CkNPTkZJR19NQUNfUEFSVElUSU9OPXkKQ09ORklH
X01TRE9TX1BBUlRJVElPTj15CkNPTkZJR19CU0RfRElTS0xBQkVMPXkKQ09ORklHX01JTklYX1NV
QlBBUlRJVElPTj15CkNPTkZJR19TT0xBUklTX1g4Nl9QQVJUSVRJT049eQpDT05GSUdfVU5JWFdB
UkVfRElTS0xBQkVMPXkKIyBDT05GSUdfTERNX1BBUlRJVElPTiBpcyBub3Qgc2V0CkNPTkZJR19T
R0lfUEFSVElUSU9OPXkKIyBDT05GSUdfVUxUUklYX1BBUlRJVElPTiBpcyBub3Qgc2V0CkNPTkZJ
R19TVU5fUEFSVElUSU9OPXkKQ09ORklHX0tBUk1BX1BBUlRJVElPTj15CkNPTkZJR19FRklfUEFS
VElUSU9OPXkKIyBDT05GSUdfU1lTVjY4X1BBUlRJVElPTiBpcyBub3Qgc2V0CkNPTkZJR19OTFM9
eQpDT05GSUdfTkxTX0RFRkFVTFQ9InV0ZjgiCkNPTkZJR19OTFNfQ09ERVBBR0VfNDM3PXkKQ09O
RklHX05MU19DT0RFUEFHRV83Mzc9bQpDT05GSUdfTkxTX0NPREVQQUdFXzc3NT1tCkNPTkZJR19O
TFNfQ09ERVBBR0VfODUwPW0KQ09ORklHX05MU19DT0RFUEFHRV84NTI9bQpDT05GSUdfTkxTX0NP
REVQQUdFXzg1NT1tCkNPTkZJR19OTFNfQ09ERVBBR0VfODU3PW0KQ09ORklHX05MU19DT0RFUEFH
RV84NjA9bQpDT05GSUdfTkxTX0NPREVQQUdFXzg2MT1tCkNPTkZJR19OTFNfQ09ERVBBR0VfODYy
PW0KQ09ORklHX05MU19DT0RFUEFHRV84NjM9bQpDT05GSUdfTkxTX0NPREVQQUdFXzg2ND1tCkNP
TkZJR19OTFNfQ09ERVBBR0VfODY1PW0KQ09ORklHX05MU19DT0RFUEFHRV84NjY9bQpDT05GSUdf
TkxTX0NPREVQQUdFXzg2OT1tCkNPTkZJR19OTFNfQ09ERVBBR0VfOTM2PW0KQ09ORklHX05MU19D
T0RFUEFHRV85NTA9bQpDT05GSUdfTkxTX0NPREVQQUdFXzkzMj1tCkNPTkZJR19OTFNfQ09ERVBB
R0VfOTQ5PW0KQ09ORklHX05MU19DT0RFUEFHRV84NzQ9bQpDT05GSUdfTkxTX0lTTzg4NTlfOD1t
CkNPTkZJR19OTFNfQ09ERVBBR0VfMTI1MD1tCkNPTkZJR19OTFNfQ09ERVBBR0VfMTI1MT1tCkNP
TkZJR19OTFNfQVNDSUk9eQpDT05GSUdfTkxTX0lTTzg4NTlfMT1tCkNPTkZJR19OTFNfSVNPODg1
OV8yPW0KQ09ORklHX05MU19JU084ODU5XzM9bQpDT05GSUdfTkxTX0lTTzg4NTlfND1tCkNPTkZJ
R19OTFNfSVNPODg1OV81PW0KQ09ORklHX05MU19JU084ODU5XzY9bQpDT05GSUdfTkxTX0lTTzg4
NTlfNz1tCkNPTkZJR19OTFNfSVNPODg1OV85PW0KQ09ORklHX05MU19JU084ODU5XzEzPW0KQ09O
RklHX05MU19JU084ODU5XzE0PW0KQ09ORklHX05MU19JU084ODU5XzE1PW0KQ09ORklHX05MU19L
T0k4X1I9bQpDT05GSUdfTkxTX0tPSThfVT1tCkNPTkZJR19OTFNfVVRGOD1tCkNPTkZJR19ETE09
bQpDT05GSUdfRExNX0RFQlVHPXkKCiMKIyBLZXJuZWwgaGFja2luZwojCkNPTkZJR19UUkFDRV9J
UlFGTEFHU19TVVBQT1JUPXkKIyBDT05GSUdfUFJJTlRLX1RJTUUgaXMgbm90IHNldAojIENPTkZJ
R19FTkFCTEVfV0FSTl9ERVBSRUNBVEVEIGlzIG5vdCBzZXQKQ09ORklHX0VOQUJMRV9NVVNUX0NI
RUNLPXkKQ09ORklHX0ZSQU1FX1dBUk49MjA0OApDT05GSUdfTUFHSUNfU1lTUlE9eQpDT05GSUdf
U1RSSVBfQVNNX1NZTVM9eQpDT05GSUdfVU5VU0VEX1NZTUJPTFM9eQpDT05GSUdfREVCVUdfRlM9
eQpDT05GSUdfSEVBREVSU19DSEVDSz15CkNPTkZJR19ERUJVR19LRVJORUw9eQpDT05GSUdfREVC
VUdfU0hJUlE9eQpDT05GSUdfREVURUNUX1NPRlRMT0NLVVA9eQojIENPTkZJR19CT09UUEFSQU1f
U09GVExPQ0tVUF9QQU5JQyBpcyBub3Qgc2V0CkNPTkZJR19CT09UUEFSQU1fU09GVExPQ0tVUF9Q
QU5JQ19WQUxVRT0wCkNPTkZJR19ERVRFQ1RfSFVOR19UQVNLPXkKIyBDT05GSUdfQk9PVFBBUkFN
X0hVTkdfVEFTS19QQU5JQyBpcyBub3Qgc2V0CkNPTkZJR19CT09UUEFSQU1fSFVOR19UQVNLX1BB
TklDX1ZBTFVFPTAKQ09ORklHX1NDSEVEX0RFQlVHPXkKQ09ORklHX1NDSEVEU1RBVFM9eQpDT05G
SUdfVElNRVJfU1RBVFM9eQojIENPTkZJR19ERUJVR19PQkpFQ1RTIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0xVQl9ERUJVR19PTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NMVUJfU1RBVFMgaXMgbm90IHNl
dAojIENPTkZJR19ERUJVR19LTUVNTEVBSyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1JUX01V
VEVYRVMgaXMgbm90IHNldAojIENPTkZJR19SVF9NVVRFWF9URVNURVIgaXMgbm90IHNldAojIENP
TkZJR19ERUJVR19TUElOTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX01VVEVYRVMgaXMg
bm90IHNldAojIENPTkZJR19ERUJVR19MT0NLX0FMTE9DIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJP
VkVfTE9DS0lORyBpcyBub3Qgc2V0CiMgQ09ORklHX0xPQ0tfU1RBVCBpcyBub3Qgc2V0CkNPTkZJ
R19ERUJVR19TUElOTE9DS19TTEVFUD15CiMgQ09ORklHX0RFQlVHX0xPQ0tJTkdfQVBJX1NFTEZU
RVNUUyBpcyBub3Qgc2V0CkNPTkZJR19TVEFDS1RSQUNFPXkKIyBDT05GSUdfREVCVUdfS09CSkVD
VCBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19CVUdWRVJCT1NFPXkKQ09ORklHX0RFQlVHX0lORk89
eQojIENPTkZJR19ERUJVR19WTSBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1ZJUlRVQUwgaXMg
bm90IHNldAojIENPTkZJR19ERUJVR19XUklURUNPVU5UIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVH
X01FTU9SWV9JTklUPXkKQ09ORklHX0RFQlVHX0xJU1Q9eQojIENPTkZJR19ERUJVR19TRyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RFQlVHX05PVElGSUVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVH
X0NSRURFTlRJQUxTIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfV0FOVF9GUkFNRV9QT0lOVEVSUz15
CkNPTkZJR19GUkFNRV9QT0lOVEVSPXkKQ09ORklHX0JPT1RfUFJJTlRLX0RFTEFZPXkKIyBDT05G
SUdfUkNVX1RPUlRVUkVfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1JDVV9DUFVfU1RBTExfREVU
RUNUT1IgaXMgbm90IHNldAojIENPTkZJR19LUFJPQkVTX1NBTklUWV9URVNUIGlzIG5vdCBzZXQK
IyBDT05GSUdfQkFDS1RSQUNFX1NFTEZfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0JM
T0NLX0VYVF9ERVZUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfRk9SQ0VfV0VBS19QRVJfQ1BV
IGlzIG5vdCBzZXQKIyBDT05GSUdfTEtEVE0gaXMgbm90IHNldAojIENPTkZJR19GQVVMVF9JTkpF
Q1RJT04gaXMgbm90IHNldApDT05GSUdfTEFURU5DWVRPUD15CiMgQ09ORklHX1NZU0NUTF9TWVND
QUxMX0NIRUNLIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfUEFHRUFMTE9DIGlzIG5vdCBzZXQK
Q09ORklHX1VTRVJfU1RBQ0tUUkFDRV9TVVBQT1JUPXkKQ09ORklHX05PUF9UUkFDRVI9eQpDT05G
SUdfSEFWRV9GVFJBQ0VfTk1JX0VOVEVSPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05fVFJBQ0VSPXkK
Q09ORklHX0hBVkVfRlVOQ1RJT05fR1JBUEhfVFJBQ0VSPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05f
R1JBUEhfRlBfVEVTVD15CkNPTkZJR19IQVZFX0ZVTkNUSU9OX1RSQUNFX01DT1VOVF9URVNUPXkK
Q09ORklHX0hBVkVfRFlOQU1JQ19GVFJBQ0U9eQpDT05GSUdfSEFWRV9GVFJBQ0VfTUNPVU5UX1JF
Q09SRD15CkNPTkZJR19IQVZFX1NZU0NBTExfVFJBQ0VQT0lOVFM9eQpDT05GSUdfVFJBQ0VSX01B
WF9UUkFDRT15CkNPTkZJR19SSU5HX0JVRkZFUj15CkNPTkZJR19GVFJBQ0VfTk1JX0VOVEVSPXkK
Q09ORklHX0VWRU5UX1RSQUNJTkc9eQpDT05GSUdfQ09OVEVYVF9TV0lUQ0hfVFJBQ0VSPXkKQ09O
RklHX1JJTkdfQlVGRkVSX0FMTE9XX1NXQVA9eQpDT05GSUdfVFJBQ0lORz15CkNPTkZJR19HRU5F
UklDX1RSQUNFUj15CkNPTkZJR19UUkFDSU5HX1NVUFBPUlQ9eQpDT05GSUdfRlRSQUNFPXkKQ09O
RklHX0ZVTkNUSU9OX1RSQUNFUj15CkNPTkZJR19GVU5DVElPTl9HUkFQSF9UUkFDRVI9eQojIENP
TkZJR19JUlFTT0ZGX1RSQUNFUiBpcyBub3Qgc2V0CkNPTkZJR19TWVNQUk9GX1RSQUNFUj15CkNP
TkZJR19TQ0hFRF9UUkFDRVI9eQpDT05GSUdfRlRSQUNFX1NZU0NBTExTPXkKIyBDT05GSUdfQk9P
VF9UUkFDRVIgaXMgbm90IHNldApDT05GSUdfQlJBTkNIX1BST0ZJTEVfTk9ORT15CiMgQ09ORklH
X1BST0ZJTEVfQU5OT1RBVEVEX0JSQU5DSEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPRklMRV9B
TExfQlJBTkNIRVMgaXMgbm90IHNldApDT05GSUdfUE9XRVJfVFJBQ0VSPXkKQ09ORklHX1NUQUNL
X1RSQUNFUj15CkNPTkZJR19LTUVNVFJBQ0U9eQpDT05GSUdfV09SS1FVRVVFX1RSQUNFUj15CkNP
TkZJR19CTEtfREVWX0lPX1RSQUNFPXkKQ09ORklHX0RZTkFNSUNfRlRSQUNFPXkKQ09ORklHX0ZV
TkNUSU9OX1BST0ZJTEVSPXkKQ09ORklHX0ZUUkFDRV9NQ09VTlRfUkVDT1JEPXkKIyBDT05GSUdf
RlRSQUNFX1NUQVJUVVBfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX01NSU9UUkFDRSBpcyBub3Qg
c2V0CkNPTkZJR19SSU5HX0JVRkZFUl9CRU5DSE1BUks9bQpDT05GSUdfUFJPVklERV9PSENJMTM5
NF9ETUFfSU5JVD15CiMgQ09ORklHX0ZJUkVXSVJFX09IQ0lfUkVNT1RFX0RNQSBpcyBub3Qgc2V0
CkNPTkZJR19CVUlMRF9ET0NTUkM9eQpDT05GSUdfRFlOQU1JQ19ERUJVRz15CiMgQ09ORklHX0RN
QV9BUElfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19TQU1QTEVTIGlzIG5vdCBzZXQKQ09ORklH
X0hBVkVfQVJDSF9LR0RCPXkKQ09ORklHX0tHREI9eQpDT05GSUdfS0dEQl9TRVJJQUxfQ09OU09M
RT15CkNPTkZJR19LR0RCX1RFU1RTPXkKIyBDT05GSUdfS0dEQl9URVNUU19PTl9CT09UIGlzIG5v
dCBzZXQKQ09ORklHX0hBVkVfQVJDSF9LTUVNQ0hFQ0s9eQpDT05GSUdfU1RSSUNUX0RFVk1FTT15
CiMgQ09ORklHX1g4Nl9WRVJCT1NFX0JPT1RVUCBpcyBub3Qgc2V0CkNPTkZJR19FQVJMWV9QUklO
VEs9eQpDT05GSUdfRUFSTFlfUFJJTlRLX0RCR1A9eQpDT05GSUdfREVCVUdfU1RBQ0tPVkVSRkxP
Vz15CiMgQ09ORklHX0RFQlVHX1NUQUNLX1VTQUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdf
UEVSX0NQVV9NQVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1BURFVNUCBpcyBub3Qgc2V0CkNP
TkZJR19ERUJVR19ST0RBVEE9eQpDT05GSUdfREVCVUdfUk9EQVRBX1RFU1Q9eQpDT05GSUdfREVC
VUdfTlhfVEVTVD1tCiMgQ09ORklHX0lPTU1VX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfSU9N
TVVfU1RSRVNTIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfTU1JT1RSQUNFX1NVUFBPUlQ9eQpDT05G
SUdfSU9fREVMQVlfVFlQRV8wWDgwPTAKQ09ORklHX0lPX0RFTEFZX1RZUEVfMFhFRD0xCkNPTkZJ
R19JT19ERUxBWV9UWVBFX1VERUxBWT0yCkNPTkZJR19JT19ERUxBWV9UWVBFX05PTkU9MwpDT05G
SUdfSU9fREVMQVlfMFg4MD15CiMgQ09ORklHX0lPX0RFTEFZXzBYRUQgaXMgbm90IHNldAojIENP
TkZJR19JT19ERUxBWV9VREVMQVkgaXMgbm90IHNldAojIENPTkZJR19JT19ERUxBWV9OT05FIGlz
IG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfSU9fREVMQVlfVFlQRT0wCkNPTkZJR19ERUJVR19CT09U
X1BBUkFNUz15CiMgQ09ORklHX0NQQV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19PUFRJTUlaRV9J
TkxJTklORz15CgojCiMgU2VjdXJpdHkgb3B0aW9ucwojCkNPTkZJR19LRVlTPXkKQ09ORklHX0tF
WVNfREVCVUdfUFJPQ19LRVlTPXkKQ09ORklHX1NFQ1VSSVRZPXkKQ09ORklHX1NFQ1VSSVRZRlM9
eQpDT05GSUdfU0VDVVJJVFlfTkVUV09SSz15CkNPTkZJR19TRUNVUklUWV9ORVRXT1JLX1hGUk09
eQojIENPTkZJR19TRUNVUklUWV9QQVRIIGlzIG5vdCBzZXQKQ09ORklHX1NFQ1VSSVRZX0ZJTEVf
Q0FQQUJJTElUSUVTPXkKIyBDT05GSUdfU0VDVVJJVFlfUk9PVFBMVUcgaXMgbm90IHNldAojIENP
TkZJR19JTlRFTF9UWFQgaXMgbm90IHNldApDT05GSUdfTFNNX01NQVBfTUlOX0FERFI9NjU1MzYK
Q09ORklHX1NFQ1VSSVRZX1NFTElOVVg9eQpDT05GSUdfU0VDVVJJVFlfU0VMSU5VWF9CT09UUEFS
QU09eQpDT05GSUdfU0VDVVJJVFlfU0VMSU5VWF9CT09UUEFSQU1fVkFMVUU9MQpDT05GSUdfU0VD
VVJJVFlfU0VMSU5VWF9ESVNBQkxFPXkKQ09ORklHX1NFQ1VSSVRZX1NFTElOVVhfREVWRUxPUD15
CkNPTkZJR19TRUNVUklUWV9TRUxJTlVYX0FWQ19TVEFUUz15CkNPTkZJR19TRUNVUklUWV9TRUxJ
TlVYX0NIRUNLUkVRUFJPVF9WQUxVRT0xCiMgQ09ORklHX1NFQ1VSSVRZX1NFTElOVVhfUE9MSUNZ
REJfVkVSU0lPTl9NQVggaXMgbm90IHNldAojIENPTkZJR19TRUNVUklUWV9TTUFDSyBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFQ1VSSVRZX1RPTU9ZTyBpcyBub3Qgc2V0CkNPTkZJR19JTUE9eQpDT05G
SUdfSU1BX01FQVNVUkVfUENSX0lEWD0xMApDT05GSUdfSU1BX0FVRElUPXkKQ09ORklHX0lNQV9M
U01fUlVMRVM9eQpDT05GSUdfWE9SX0JMT0NLUz1tCkNPTkZJR19BU1lOQ19DT1JFPW0KQ09ORklH
X0FTWU5DX01FTUNQWT1tCkNPTkZJR19BU1lOQ19YT1I9bQpDT05GSUdfQVNZTkNfUFE9bQpDT05G
SUdfQVNZTkNfUkFJRDZfUkVDT1Y9bQpDT05GSUdfQVNZTkNfVFhfRElTQUJMRV9QUV9WQUxfRE1B
PXkKQ09ORklHX0FTWU5DX1RYX0RJU0FCTEVfWE9SX1ZBTF9ETUE9eQpDT05GSUdfQ1JZUFRPPXkK
CiMKIyBDcnlwdG8gY29yZSBvciBoZWxwZXIKIwpDT05GSUdfQ1JZUFRPX0ZJUFM9eQpDT05GSUdf
Q1JZUFRPX0FMR0FQST15CkNPTkZJR19DUllQVE9fQUxHQVBJMj15CkNPTkZJR19DUllQVE9fQUVB
RD1tCkNPTkZJR19DUllQVE9fQUVBRDI9eQpDT05GSUdfQ1JZUFRPX0JMS0NJUEhFUj1tCkNPTkZJ
R19DUllQVE9fQkxLQ0lQSEVSMj15CkNPTkZJR19DUllQVE9fSEFTSD15CkNPTkZJR19DUllQVE9f
SEFTSDI9eQpDT05GSUdfQ1JZUFRPX1JORz1tCkNPTkZJR19DUllQVE9fUk5HMj15CkNPTkZJR19D
UllQVE9fUENPTVA9eQpDT05GSUdfQ1JZUFRPX01BTkFHRVI9eQpDT05GSUdfQ1JZUFRPX01BTkFH
RVIyPXkKQ09ORklHX0NSWVBUT19HRjEyOE1VTD1tCkNPTkZJR19DUllQVE9fTlVMTD1tCkNPTkZJ
R19DUllQVE9fV09SS1FVRVVFPXkKQ09ORklHX0NSWVBUT19DUllQVEQ9bQpDT05GSUdfQ1JZUFRP
X0FVVEhFTkM9bQpDT05GSUdfQ1JZUFRPX1RFU1Q9bQoKIwojIEF1dGhlbnRpY2F0ZWQgRW5jcnlw
dGlvbiB3aXRoIEFzc29jaWF0ZWQgRGF0YQojCkNPTkZJR19DUllQVE9fQ0NNPW0KQ09ORklHX0NS
WVBUT19HQ009bQpDT05GSUdfQ1JZUFRPX1NFUUlWPW0KCiMKIyBCbG9jayBtb2RlcwojCkNPTkZJ
R19DUllQVE9fQ0JDPW0KQ09ORklHX0NSWVBUT19DVFI9bQpDT05GSUdfQ1JZUFRPX0NUUz1tCkNP
TkZJR19DUllQVE9fRUNCPW0KQ09ORklHX0NSWVBUT19MUlc9bQpDT05GSUdfQ1JZUFRPX1BDQkM9
bQpDT05GSUdfQ1JZUFRPX1hUUz1tCkNPTkZJR19DUllQVE9fRlBVPW0KCiMKIyBIYXNoIG1vZGVz
CiMKQ09ORklHX0NSWVBUT19ITUFDPXkKQ09ORklHX0NSWVBUT19YQ0JDPW0KIyBDT05GSUdfQ1JZ
UFRPX1ZNQUMgaXMgbm90IHNldAoKIwojIERpZ2VzdAojCkNPTkZJR19DUllQVE9fQ1JDMzJDPXkK
Q09ORklHX0NSWVBUT19DUkMzMkNfSU5URUw9bQpDT05GSUdfQ1JZUFRPX0dIQVNIPW0KQ09ORklH
X0NSWVBUT19NRDQ9bQpDT05GSUdfQ1JZUFRPX01ENT15CkNPTkZJR19DUllQVE9fTUlDSEFFTF9N
SUM9bQpDT05GSUdfQ1JZUFRPX1JNRDEyOD1tCkNPTkZJR19DUllQVE9fUk1EMTYwPW0KQ09ORklH
X0NSWVBUT19STUQyNTY9bQpDT05GSUdfQ1JZUFRPX1JNRDMyMD1tCkNPTkZJR19DUllQVE9fU0hB
MT15CkNPTkZJR19DUllQVE9fU0hBMjU2PW0KQ09ORklHX0NSWVBUT19TSEE1MTI9bQpDT05GSUdf
Q1JZUFRPX1RHUjE5Mj1tCkNPTkZJR19DUllQVE9fV1A1MTI9bQoKIwojIENpcGhlcnMKIwpDT05G
SUdfQ1JZUFRPX0FFUz1tCkNPTkZJR19DUllQVE9fQUVTX1g4Nl82ND1tCkNPTkZJR19DUllQVE9f
QUVTX05JX0lOVEVMPW0KQ09ORklHX0NSWVBUT19BTlVCSVM9bQpDT05GSUdfQ1JZUFRPX0FSQzQ9
bQpDT05GSUdfQ1JZUFRPX0JMT1dGSVNIPW0KQ09ORklHX0NSWVBUT19DQU1FTExJQT1tCkNPTkZJ
R19DUllQVE9fQ0FTVDU9bQpDT05GSUdfQ1JZUFRPX0NBU1Q2PW0KQ09ORklHX0NSWVBUT19ERVM9
bQpDT05GSUdfQ1JZUFRPX0ZDUllQVD1tCkNPTkZJR19DUllQVE9fS0hBWkFEPW0KIyBDT05GSUdf
Q1JZUFRPX1NBTFNBMjAgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX1NBTFNBMjBfWDg2XzY0PW0K
Q09ORklHX0NSWVBUT19TRUVEPW0KQ09ORklHX0NSWVBUT19TRVJQRU5UPW0KQ09ORklHX0NSWVBU
T19URUE9bQojIENPTkZJR19DUllQVE9fVFdPRklTSCBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9f
VFdPRklTSF9DT01NT049bQpDT05GSUdfQ1JZUFRPX1RXT0ZJU0hfWDg2XzY0PW0KCiMKIyBDb21w
cmVzc2lvbgojCkNPTkZJR19DUllQVE9fREVGTEFURT1tCkNPTkZJR19DUllQVE9fWkxJQj1tCkNP
TkZJR19DUllQVE9fTFpPPW0KCiMKIyBSYW5kb20gTnVtYmVyIEdlbmVyYXRpb24KIwpDT05GSUdf
Q1JZUFRPX0FOU0lfQ1BSTkc9bQpDT05GSUdfQ1JZUFRPX0hXPXkKQ09ORklHX0NSWVBUT19ERVZf
UEFETE9DSz1tCkNPTkZJR19DUllQVE9fREVWX1BBRExPQ0tfQUVTPW0KQ09ORklHX0NSWVBUT19E
RVZfUEFETE9DS19TSEE9bQpDT05GSUdfQ1JZUFRPX0RFVl9ISUZOXzc5NVg9bQpDT05GSUdfQ1JZ
UFRPX0RFVl9ISUZOXzc5NVhfUk5HPXkKQ09ORklHX0hBVkVfS1ZNPXkKQ09ORklHX0hBVkVfS1ZN
X0lSUUNISVA9eQpDT05GSUdfSEFWRV9LVk1fRVZFTlRGRD15CkNPTkZJR19LVk1fQVBJQ19BUkNI
SVRFQ1RVUkU9eQpDT05GSUdfVklSVFVBTElaQVRJT049eQpDT05GSUdfS1ZNPW0KQ09ORklHX0tW
TV9JTlRFTD1tCkNPTkZJR19LVk1fQU1EPW0KQ09ORklHX1ZJUlRJTz1tCkNPTkZJR19WSVJUSU9f
UklORz1tCkNPTkZJR19WSVJUSU9fUENJPW0KQ09ORklHX1ZJUlRJT19CQUxMT09OPW0KQ09ORklH
X0JJTkFSWV9QUklOVEY9eQoKIwojIExpYnJhcnkgcm91dGluZXMKIwpDT05GSUdfQklUUkVWRVJT
RT15CkNPTkZJR19HRU5FUklDX0ZJTkRfRklSU1RfQklUPXkKQ09ORklHX0dFTkVSSUNfRklORF9O
RVhUX0JJVD15CkNPTkZJR19HRU5FUklDX0ZJTkRfTEFTVF9CSVQ9eQpDT05GSUdfQ1JDX0NDSVRU
PW0KQ09ORklHX0NSQzE2PXkKQ09ORklHX0NSQ19UMTBESUY9eQpDT05GSUdfQ1JDX0lUVV9UPW0K
Q09ORklHX0NSQzMyPXkKIyBDT05GSUdfQ1JDNyBpcyBub3Qgc2V0CkNPTkZJR19MSUJDUkMzMkM9
bQpDT05GSUdfWkxJQl9JTkZMQVRFPXkKQ09ORklHX1pMSUJfREVGTEFURT1tCkNPTkZJR19MWk9f
Q09NUFJFU1M9bQpDT05GSUdfTFpPX0RFQ09NUFJFU1M9bQpDT05GSUdfREVDT01QUkVTU19HWklQ
PXkKQ09ORklHX0RFQ09NUFJFU1NfQlpJUDI9eQpDT05GSUdfREVDT01QUkVTU19MWk1BPXkKQ09O
RklHX0dFTkVSSUNfQUxMT0NBVE9SPXkKQ09ORklHX1JFRURfU09MT01PTj1tCkNPTkZJR19SRUVE
X1NPTE9NT05fREVDMTY9eQpDT05GSUdfVEVYVFNFQVJDSD15CkNPTkZJR19URVhUU0VBUkNIX0tN
UD1tCkNPTkZJR19URVhUU0VBUkNIX0JNPW0KQ09ORklHX1RFWFRTRUFSQ0hfRlNNPW0KQ09ORklH
X0hBU19JT01FTT15CkNPTkZJR19IQVNfSU9QT1JUPXkKQ09ORklHX0hBU19ETUE9eQpDT05GSUdf
Q0hFQ0tfU0lHTkFUVVJFPXkKQ09ORklHX05MQVRUUj15Cg==
--0016e6d63fb43edcc7048a29ca3a--
