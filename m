From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/3] libsas: modify SATA error handler
Date: Thu, 7 Aug 2014 16:54:01 -0700
Message-ID: <CAPcyv4hQxtHdAXDvj9cF1prTpH0unJ7VX1ZjA5aJq8UeVhNC2Q@mail.gmail.com>
References: <1398346047-10276-1-git-send-email-yxlraid@gmail.com>
	<CAPcyv4jZaR0x4ChMvBYCCq-sUgyvf6CraKj+Tn+qmcvUbxwezQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4jZaR0x4ChMvBYCCq-sUgyvf6CraKj+Tn+qmcvUbxwezQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Xiangliang Yu <yxlraid@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>, Todd E Brandt <todd.e.brandt@intel.com>, Lukasz Dorau <lukasz.dorau@intel.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

[ adding yuxiangl@marvell.com ]

On Tue, Jun 3, 2014 at 6:41 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Hi, some notes below:
>
> On Thu, Apr 24, 2014 at 6:27 AM, Xiangliang Yu <yxlraid@gmail.com> wrote:
>> Add support for SATA port softreset and port multiplier error
>> handling.
>
> Some more detailed notes about the approach and any caveats would be
> appreciated.
>
>>
>> Signed-off-by: Xiangliang Yu <yxlraid@gmail.com>
>> ---
>>  drivers/scsi/libsas/sas_ata.c |  226 ++++++++++++++++++++++++++++++++++++++++-
>>  include/scsi/libsas.h         |    6 +
>>  2 files changed, 231 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
>> index 766098a..29a19fd 100644
>> --- a/drivers/scsi/libsas/sas_ata.c
>> +++ b/drivers/scsi/libsas/sas_ata.c
>> @@ -442,6 +442,226 @@ static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
>>         return ret;
>>  }
>>
>> +static void sas_ata_freeze(struct ata_port *ap)
>> +{
>> +       struct domain_device *dev = ap->private_data;
>> +       struct sas_ha_struct *sas_ha = dev->port->ha;
>> +       struct Scsi_Host *host = sas_ha->core.shost;
>> +       struct sas_internal *i = to_sas_internal(host->transportt);
>> +
>> +       if (i->dft->lldd_dev_freeze)
>> +               i->dft->lldd_dev_freeze(dev);
>> +}
>> +
>> +static void sas_ata_thaw(struct ata_port *ap)
>> +{
>> +       struct domain_device *dev = ap->private_data;
>> +       struct sas_ha_struct *sas_ha = dev->port->ha;
>> +       struct Scsi_Host *host = sas_ha->core.shost;
>> +       struct sas_internal *i = to_sas_internal(host->transportt);
>> +
>> +       if (i->dft->lldd_dev_thaw)
>> +               i->dft->lldd_dev_thaw(dev);
>> +}
>> +
>> +static int sas_ata_wait_task_done(struct sas_task *task, unsigned long timeout,
>> +               int (*check_done)(struct sas_task *task))
>> +{
>
> Why do we need a custom check_done() routine?  Since we have a
> sas_task we can use the normal completion infrastructure.  See
> smp_execute_task().
>
>> +       struct ata_port *ap = task->uldd_task;
>> +       unsigned long deadline;
>> +       int done;
>> +
>> +       if (!check_done) {
>> +               SAS_DPRINTK("check function is null.\n");
>> +               return -1;
>> +       }
>> +
>> +       deadline = ata_deadline(jiffies, timeout);
>> +       done = check_done(task);
>> +
>> +       while (done && time_before(jiffies, deadline)) {
>> +               ata_msleep(ap, 1);
>> +
>> +               done = check_done(task);
>
> This can simply be:
>
> completion_done(&task->slow_task->completion)
>
>> +       }
>> +
>> +       return done;
>> +}
>> +
>> +static int sas_ata_exec_polled_cmd(struct ata_port *ap, struct ata_taskfile *tf,
>> +               int pmp, unsigned long timeout)
>> +{
>> +       struct domain_device *dev = ap->private_data;
>> +       struct sas_ha_struct *sas_ha = dev->port->ha;
>> +       struct Scsi_Host *host = sas_ha->core.shost;
>> +       struct sas_internal *i = to_sas_internal(host->transportt);
>> +       struct sas_task *task = NULL;
>> +       int ret = -1;
>> +
>> +       if (!i->dft->lldd_execute_task) {
>> +               SAS_DPRINTK("execute function is null.\n");
>> +               return ret;
>> +       }
>> +
>> +       task = sas_alloc_task(GFP_ATOMIC);
>
> I think this can be downgraded to GFP_NOIO.  We're in a sleepable context.
>
>> +       if (!task) {
>> +               SAS_DPRINTK("failed to alloc sas task.\n");
>> +               goto fail;
>> +       }
>> +
>> +       task->dev = dev;
>> +       task->task_proto = SAS_PROTOCOL_SATA;
>> +       task->uldd_task = ap;
>> +
>> +       ata_tf_to_fis(tf, pmp, 0, (u8 *)&task->ata_task.fis);
>> +       task->ata_task.retry_count = 1;
>> +       task->task_state_flags = SAS_TASK_STATE_PENDING;
>> +       task->task_state_flags |= SAS_TASK_NEED_DEV_RESET;
>> +
>> +       ret = i->dft->lldd_execute_task(task, 1, GFP_ATOMIC);
>
> Same here.
>
>> +       if (ret) {
>> +               SAS_DPRINTK("failed to send internal task.\n");
>> +               goto fail;
>> +       }
>> +
>> +       if (timeout) {
>> +               ret = sas_ata_wait_task_done(task, timeout,
>> +                               i->dft->lldd_wait_task_done);
>> +               if (ret) {
>> +                       SAS_DPRINTK("get wrong status.\n");
>> +                       goto fail;
>> +               }
>> +       }
>> +       list_del_init(&task->list);
>> +       sas_free_task(task);
>> +
>> +       return 0;
>> +fail:
>> +       if (task) {
>> +               list_del_init(&task->list);
>> +               sas_free_task(task);
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +static int sas_ata_soft_reset(struct ata_link *link, unsigned int *class,
>> +                             unsigned long deadline)
>> +{
>> +       struct ata_taskfile tf;
>> +       struct ata_port *ap = link->ap;
>> +       struct domain_device *dev = ap->private_data;
>> +       struct sas_ha_struct *sas_ha = dev->port->ha;
>> +       struct Scsi_Host *host = sas_ha->core.shost;
>> +       struct sas_internal *i = to_sas_internal(host->transportt);
>> +       struct sas_phy *phy;
>> +       unsigned long now, msecs;
>> +       unsigned int pmp;
>> +       int ret = -1;
>> +       int (*check_ready)(struct ata_link *link);
>> +
>> +       phy = sas_get_local_phy(dev);
>> +       if (scsi_is_sas_phy_local(phy))
>> +               check_ready = local_ata_check_ready;
>> +       else
>> +               check_ready = smp_ata_check_ready;
>> +       sas_put_local_phy(phy);
>
> Does this attempt to support expander attached port multiplier's?
> Last I checked expanders do not support this so we should just fail
> this for non-local phys.
>
>> +
>> +       pmp = sata_srst_pmp(link);
>> +
>> +       msecs = 0;
>> +       now = jiffies;
>> +       if (time_after(deadline, now))
>> +               msecs = jiffies_to_msecs(deadline - now);
>> +
>> +       memset(&tf, 0, sizeof(struct ata_taskfile));
>> +       tf.ctl = ATA_SRST;
>> +       tf.device = ATA_DEVICE_OBS;
>> +
>> +       if (sas_ata_exec_polled_cmd(ap, &tf, pmp, msecs)) {
>> +               ret = -EIO;
>> +               goto fail;
>> +       }
>> +
>> +       tf.ctl &= ~ATA_SRST;
>> +       sas_ata_exec_polled_cmd(ap, &tf, pmp, msecs);
>
> What about lldd's that do not know how to handle ATA_SRST?  I think we
> need preparation patches to make SRST support opt-in, or teach all
> lldds how to handle these SRST sas_tasks.
>
>> +
>> +       ret = ata_wait_after_reset(link, deadline, check_ready);
>> +       if (ret) {
>> +               SAS_DPRINTK("device is not ready.\n");
>> +               ret = -EIO;
>> +               goto fail;
>> +       } else {
>> +               if (i->dft->lldd_dev_classify)
>> +                       *class = i->dft->lldd_dev_classify(dev);
>> +       }
>> +
>> +       return 0;
>> +
>> +fail:
>> +       SAS_DPRINTK("failed to reset.\n");
>> +       return ret;
>> +}
>> +
>> +/* According sata 3.0 spec 13.15.4.2, enable the device port */
>> +static int sas_ata_pmp_hard_reset(struct ata_link *link, unsigned int *class,
>> +                             unsigned long deadline)
>> +{
>> +       struct ata_port *ap = link->ap;
>> +       struct domain_device *dev = ap->private_data;
>> +       struct sas_ha_struct *sas_ha = dev->port->ha;
>> +       struct Scsi_Host *host = sas_ha->core.shost;
>> +       struct sas_internal *i = to_sas_internal(host->transportt);
>> +       int ret = -1;
>> +       u32 scontrol = 0;
>> +
>> +       set_bit(SAS_DEV_RESET, &dev->state);
>> +
>> +       ret = sata_scr_read(link, SCR_CONTROL, &scontrol);
>
> I think a comment is needed clarifying that these reads generate
> sas_tasks to a pmp and are not trying to read/write local SCR
> registers that do not exist on a SAS hba.
>
>> +       if (ret)
>> +               goto error;
>> +
>> +       /* enable device port */
>> +       scontrol = 0x1;
>> +       ret = sata_scr_write(link, SCR_CONTROL, scontrol);
>> +       if (ret)
>> +               goto error;
>> +
>> +       ata_msleep(ap, 1);
>> +
>> +       scontrol = 0x0;
>> +       ret = sata_scr_write(link, SCR_CONTROL, scontrol);
>> +       if (ret)
>> +               goto error;
>> +
>> +       ata_msleep(ap, 10);
>> +
>> +       /* check device link status */
>> +       if (ata_link_offline(link)) {
>> +               SAS_DPRINTK("link is offline.\n");
>> +               goto error;
>> +       }
>> +
>> +       /* clear X bit */
>> +       scontrol = 0xFFFFFFFF;
>> +       ret = sata_scr_write(link, SCR_ERROR, scontrol);
>> +       if (ret)
>> +               goto error;
>> +
>> +       /* may be need to wait for device sig */
>> +       ata_msleep(ap, 3);
>> +
>> +       /* check device class */
>> +       if (i->dft->lldd_dev_classify)
>> +               *class = i->dft->lldd_dev_classify(dev);
>> +
>> +       return 0;
>> +
>> +error:
>> +       SAS_DPRINTK("failed to hard reset.\n");
>> +       return ret;
>> +}
>> +
>>  /*
>>   * notify the lldd to forget the sas_task for this internal ata command
>>   * that bypasses scsi-eh
>> @@ -551,8 +771,12 @@ void sas_ata_end_eh(struct ata_port *ap)
>>  static struct ata_port_operations sas_sata_ops = {
>>         .prereset               = ata_std_prereset,
>>         .hardreset              = sas_ata_hard_reset,
>> +       .softreset              = sas_ata_soft_reset,
>> +       .pmp_hardreset          = sas_ata_pmp_hard_reset,
>> +       .freeze                 = sas_ata_freeze,
>> +       .thaw                   = sas_ata_thaw,
>>         .postreset              = ata_std_postreset,
>> -       .error_handler          = ata_std_error_handler,
>> +       .error_handler          = sata_pmp_error_handler,
>>         .post_internal_cmd      = sas_ata_post_internal,
>>         .qc_defer               = ata_std_qc_defer,
>>         .qc_prep                = ata_noop_qc_prep,
>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
>> index ef7872c..a26466a 100644
>> --- a/include/scsi/libsas.h
>> +++ b/include/scsi/libsas.h
>> @@ -689,6 +689,12 @@ struct sas_domain_function_template {
>>         /* GPIO support */
>>         int (*lldd_write_gpio)(struct sas_ha_struct *, u8 reg_type,
>>                                u8 reg_index, u8 reg_count, u8 *write_data);
>> +
>> +       /* ATA EH functions */
>> +       void (*lldd_dev_freeze)(struct domain_device *);
>
> Why do we need to pass this all the way through to the lldd?  Can we
> get away with emulating this in sas_ata.c.
>
>> +       void (*lldd_dev_thaw)(struct domain_device *);
>
> Same note as lldd_dev_freeze
>
>> +       int (*lldd_wait_task_done)(struct sas_task *);
>
> Should not be needed.
>
>> +       int (*lldd_dev_classify)(struct domain_device *);
>
> I think this belongs in a different patch set.  If we solve device
> re-classification for soft reset we need to do the same for the
> sas_ata_hard_reset path.
