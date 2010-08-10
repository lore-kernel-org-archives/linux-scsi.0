From: David Milburn <dmilburn@redhat.com>
Subject: Re: [PATCH] mvsas: mvs_lu_reset iterates phy num times when releasing
 	task
Date: Tue, 10 Aug 2010 16:22:31 -0500
Message-ID: <4C61C317.8010609@redhat.com>
References: <20100806161622.GA8696@localhost.localdomain> <AANLkTink9DyvHmgRDDe8WqwTJhAVX=DFQ8_b-U6Fy+Fi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249Ab0HJVW3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2010 17:22:29 -0400
In-Reply-To: <AANLkTink9DyvHmgRDDe8WqwTJhAVX=DFQ8_b-U6Fy+Fi@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Audio Haven <audiohaven@gmail.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, sgruszka@redhat.com, satyasrinivasp@hcl.in, jeff@garzik.org

Audio Haven wrote:
> Hello David,

Hello Frederic,

> 
> Does this patch solve the Unplug Notice issues ?

No, it is not directly related to the problem you are seeing.

> 
> When copying lots of large video files in sequence to a 6 TB XFS
> filesystem on top of a 8 TB software raid6 set, I frequently see my
> copy (over samba) being stalled for a while, then the following is
> reported:
> 
> drivers/scsi/mvsas/mv_sas.c 1701:<7>mv_abort_task()
> mvi=ffff88003d1c0000 task=ffff880004285080 slot=ffff88003d1de478
> slot_idx=x1

The abort task is initiated from the error handler.

> drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 5
> drivers/scsi/mvsas/mv_sas.c 2081:port 4 ctrl sts=0x89800.
> drivers/scsi/mvsas/mv_sas.c 2083:Port 4 irq sts = 0x1001
> drivers/scsi/mvsas/mv_sas.c 2109:phy4 Unplug Notice

Here the driver read interrupt status which showed

PHYEV_POOF (phy ready from 1 -> 0) | PHYEV_RDY_CH (phy ready
changed state)

Then mvs_is_phy_ready reports phy is not ready resulting
in the "Unplug Notice".

David

> drivers/scsi/mvsas/mv_sas.c 2081:port 4 ctrl sts=0x199800.
> drivers/scsi/mvsas/mv_sas.c 2083:Port 4 irq sts = 0x1081
> drivers/scsi/mvsas/mv_sas.c 2081:port 4 ctrl sts=0x199800.
> drivers/scsi/mvsas/mv_sas.c 2083:Port 4 irq sts = 0x10000
> drivers/scsi/mvsas/mv_sas.c 2136:notify plug in on phy[4]
> drivers/scsi/mvsas/mv_sas.c 1224:port 4 attach dev info is 4
> drivers/scsi/mvsas/mv_sas.c 1226:port 4 attach sas addr is 4
> drivers/scsi/mvsas/mv_sas.c 378:phy 4 byte dmaded.
> drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[4]:rc= 0
> ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> ata13: status=0x01 { Error }
> ata13: error=0x04 { DriveStatusError }
> 
> I'm using the SuperMicro AOC-SASLP-MV8 to control 8 1TB disks, which
> are never physically unplugged. Used kernel is 2.6.35.
> Raid never breaks so no data loss occurs, but the samba copy
> frequently breaks when the above error occurs, so copying always needs
> a double check, which is quite annoying.
> 
> Best regards,
> 
> Frederic Vanden Poel
> 
> 
> On Fri, Aug 6, 2010 at 6:16 PM, David Milburn <dmilburn@redhat.com> wrote:
>> mvs_lu_reset should not call mvs_release_task phy number of times,
>> each phy is handled in mvs_release_task.
>>
>> Signed-off-by: David Milburn <dmilburn@redhat.com>
>> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
>> Cc: Srinivas <satyasrinivasp@hcl.in>
>> Cc: Andy Yan <ayan@marvell.com>
>> ---
>>  drivers/scsi/mvsas/mv_sas.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
>> index adedaa9..013ab8d 100644
>> --- a/drivers/scsi/mvsas/mv_sas.c
>> +++ b/drivers/scsi/mvsas/mv_sas.c
>> @@ -1551,7 +1551,7 @@ static int mvs_debug_I_T_nexus_reset(struct domain_device *dev)
>>  int mvs_lu_reset(struct domain_device *dev, u8 *lun)
>>  {
>>        unsigned long flags;
>> -       int i, phyno[WIDE_PORT_MAX_PHY], num , rc = TMF_RESP_FUNC_FAILED;
>> +       int rc = TMF_RESP_FUNC_FAILED;
>>        struct mvs_tmf_task tmf_task;
>>        struct mvs_device * mvi_dev = dev->lldd_dev;
>>        struct mvs_info *mvi = mvi_dev->mvi_info;
>> @@ -1560,10 +1560,8 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun)
>>        mvi_dev->dev_status = MVS_DEV_EH;
>>        rc = mvs_debug_issue_ssp_tmf(dev, lun, &tmf_task);
>>        if (rc == TMF_RESP_FUNC_COMPLETE) {
>> -               num = mvs_find_dev_phyno(dev, phyno);
>>                spin_lock_irqsave(&mvi->lock, flags);
>> -               for (i = 0; i < num; i++)
>> -                       mvs_release_task(mvi, dev);
>> +               mvs_release_task(mvi, dev);
>>                spin_unlock_irqrestore(&mvi->lock, flags);
>>        }
>>        /* If failed, fall-through I_T_Nexus reset */
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

