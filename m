From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/3] libsas: modify SATA error handler
Date: Mon, 25 Aug 2014 09:02:27 -0700
Message-ID: <CAPcyv4i6oEO7Bcz6m652SyW1HCisXfUZVX9-sWB2QWKBMnH2mw@mail.gmail.com>
References: <1398346047-10276-1-git-send-email-yxlraid@gmail.com>
	<CAPcyv4jZaR0x4ChMvBYCCq-sUgyvf6CraKj+Tn+qmcvUbxwezQ@mail.gmail.com>
	<CAPcyv4hQxtHdAXDvj9cF1prTpH0unJ7VX1ZjA5aJq8UeVhNC2Q@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D5944CE9331@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <F766E4F80769BD478052FB6533FA745D5944CE9331@SC-VEXCH4.marvell.com>
Sender: linux-ide-owner@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Xiangliang Yu <yxlraid@gmail.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>, Todd E Brandt <todd.e.brandt@intel.com>, Lukasz Dorau <lukasz.dorau@intel.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Some more comments below.

[..]
>>> +
>>> +       pmp = sata_srst_pmp(link);
>>> +
>>> +       msecs = 0;
>>> +       now = jiffies;
>>> +       if (time_after(deadline, now))
>>> +               msecs = jiffies_to_msecs(deadline - now);
>>> +
>>> +       memset(&tf, 0, sizeof(struct ata_taskfile));
>>> +       tf.ctl = ATA_SRST;
>>> +       tf.device = ATA_DEVICE_OBS;
>>> +
>>> +       if (sas_ata_exec_polled_cmd(ap, &tf, pmp, msecs)) {
>>> +               ret = -EIO;
>>> +               goto fail;
>>> +       }
>>> +
>>> +       tf.ctl &= ~ATA_SRST;
>>> +       sas_ata_exec_polled_cmd(ap, &tf, pmp, msecs);
>>
>> What about lldd's that do not know how to handle ATA_SRST?  I think we
>> need preparation patches to make SRST support opt-in, or teach all
>> lldds how to handle these SRST sas_tasks.
>
> I think lldds have different actions to handle SRST because there is no unified standard.
> But it should be easy to support it.
> Later, I'll submit a mvsas patch to show how to support it.

Right, but what about the other lldd's?  Libsas needs to check whether
the lldd supports SRST before attempting to submit.

[..]
>>> +/* According sata 3.0 spec 13.15.4.2, enable the device port */
>>> +static int sas_ata_pmp_hard_reset(struct ata_link *link, unsigned int *class,
>>> +                             unsigned long deadline) {
>>> +       struct ata_port *ap = link->ap;
>>> +       struct domain_device *dev = ap->private_data;
>>> +       struct sas_ha_struct *sas_ha = dev->port->ha;
>>> +       struct Scsi_Host *host = sas_ha->core.shost;
>>> +       struct sas_internal *i = to_sas_internal(host->transportt);
>>> +       int ret = -1;
>>> +       u32 scontrol = 0;
>>> +
>>> +       set_bit(SAS_DEV_RESET, &dev->state);
>>> +
>>> +       ret = sata_scr_read(link, SCR_CONTROL, &scontrol);
>>
>> I think a comment is needed clarifying that these reads generate
>> sas_tasks to a pmp and are not trying to read/write local SCR
>> registers that do not exist on a SAS hba.
>>
>
> I think the situation can't happen here.

Right, that's why we need a comment, because by normally libsas lldd's
do not support scr-register accesses.

>
>>> +       if (ret)
>>> +               goto error;
>>> +
>>> +       /* enable device port */
>>> +       scontrol = 0x1;
>>> +       ret = sata_scr_write(link, SCR_CONTROL, scontrol);
>>> +       if (ret)
>>> +               goto error;
>>> +
>>> +       ata_msleep(ap, 1);
>>> +
>>> +       scontrol = 0x0;
>>> +       ret = sata_scr_write(link, SCR_CONTROL, scontrol);
>>> +       if (ret)
>>> +               goto error;
>>> +
>>> +       ata_msleep(ap, 10);
>>> +
>>> +       /* check device link status */
>>> +       if (ata_link_offline(link)) {
>>> +               SAS_DPRINTK("link is offline.\n");
>>> +               goto error;
>>> +       }
>>> +
>>> +       /* clear X bit */
>>> +       scontrol = 0xFFFFFFFF;
>>> +       ret = sata_scr_write(link, SCR_ERROR, scontrol);
>>> +       if (ret)
>>> +               goto error;
>>> +
>>> +       /* may be need to wait for device sig */
>>> +       ata_msleep(ap, 3);
>>> +
>>> +       /* check device class */
>>> +       if (i->dft->lldd_dev_classify)
>>> +               *class = i->dft->lldd_dev_classify(dev);
>>> +
>>> +       return 0;
>>> +
>>> +error:
>>> +       SAS_DPRINTK("failed to hard reset.\n");
>>> +       return ret;
>>> +}
>>> +
>>>  /*
>>>   * notify the lldd to forget the sas_task for this internal ata command
>>>   * that bypasses scsi-eh
>>> @@ -551,8 +771,12 @@ void sas_ata_end_eh(struct ata_port *ap)  static
>>> struct ata_port_operations sas_sata_ops = {
>>>         .prereset               = ata_std_prereset,
>>>         .hardreset              = sas_ata_hard_reset,
>>> +       .softreset              = sas_ata_soft_reset,
>>> +       .pmp_hardreset          = sas_ata_pmp_hard_reset,
>>> +       .freeze                 = sas_ata_freeze,
>>> +       .thaw                   = sas_ata_thaw,
>>>         .postreset              = ata_std_postreset,
>>> -       .error_handler          = ata_std_error_handler,
>>> +       .error_handler          = sata_pmp_error_handler,
>>>         .post_internal_cmd      = sas_ata_post_internal,
>>>         .qc_defer               = ata_std_qc_defer,
>>>         .qc_prep                = ata_noop_qc_prep,
>>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h index
>>> ef7872c..a26466a 100644
>>> --- a/include/scsi/libsas.h
>>> +++ b/include/scsi/libsas.h
>>> @@ -689,6 +689,12 @@ struct sas_domain_function_template {
>>>         /* GPIO support */
>>>         int (*lldd_write_gpio)(struct sas_ha_struct *, u8 reg_type,
>>>                                u8 reg_index, u8 reg_count, u8
>>> *write_data);
>>> +
>>> +       /* ATA EH functions */
>>> +       void (*lldd_dev_freeze)(struct domain_device *);
>>
>> Why do we need to pass this all the way through to the lldd?  Can we
>> get away with emulating this in sas_ata.c.
>>
>
> Because SAS HBAs spec haven't a unified standard, not like AHCI.
> But I think we can delete the interface because we don't disable interrupt
> during EH now.
>

Ok.

>>> +       void (*lldd_dev_thaw)(struct domain_device *);
>>
>> Same note as lldd_dev_freeze
>>
>>> +       int (*lldd_wait_task_done)(struct sas_task *);
>>
>> Should not be needed.
>>
>>> +       int (*lldd_dev_classify)(struct domain_device *);
>>
>> I think this belongs in a different patch set.  If we solve device
>> re-classification for soft reset we need to do the same for the
>> sas_ata_hard_reset path.
>
> Could you explain more details? Thanks!

See sas_ata_hard_reset().  It currently does not perform device
re-classification in the same manner as libata.  If you want to
improve the "re-classify after reset" implementation then it should be
done in a separate patch in my opinion.  In other words, just doing it
for the SRST case is incomplete.
