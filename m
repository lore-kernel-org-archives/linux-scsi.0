From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCHv4 09/12] mpt3sas: simplify task management functions
Date: Mon, 6 Mar 2017 10:46:24 +0530
Message-ID: <CAK=zhgo5WrsDjRVAHFotAj+CX6SWNuNjVoYgX9io-KPWfAjugQ@mail.gmail.com>
References: <1487759512-3873-1-git-send-email-hare@suse.de> <1487759512-3873-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34838 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752922AbdCFFQ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 00:16:27 -0500
Received: by mail-qk0-f177.google.com with SMTP id v125so75776385qkh.2
        for <linux-scsi@vger.kernel.org>; Sun, 05 Mar 2017 21:16:26 -0800 (PST)
In-Reply-To: <1487759512-3873-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

I feel that using these flags are not working as expected. From the
driver's prospective it should return status of the TM based on
whether it has cleared reference of the timed out IO in the driver or
not (i.e. if it is successfully able to clear the reference (i.e.
cleared from scsi lookup) of the timed out IO from driver, firmware
then return success status otherwise return failure status). It should
not check for it's above layer reference.

On Wed, Feb 22, 2017 at 4:01 PM, Hannes Reinecke <hare@suse.de> wrote:
> One can simply check 'target_busy' or 'device_busy' when figuring
> out if there are outstanding commands; no need to painstakingly
> counting them by hand.
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 88 +++---------------------------------
>  1 file changed, 7 insertions(+), 81 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 1c45fb3..e0cb35d 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -1133,74 +1133,6 @@ struct _sas_node *
>  }
>
>  /**
> - * _scsih_scsi_lookup_find_by_target - search for matching channel:id
> - * @ioc: per adapter object
> - * @id: target id
> - * @channel: channel
> - * Context: This function will acquire ioc->scsi_lookup_lock.
> - *
> - * This will search for a matching channel:id in the scsi_lookup array,
> - * returning 1 if found.
> - */
> -static u8
> -_scsih_scsi_lookup_find_by_target(struct MPT3SAS_ADAPTER *ioc, int id,
> -       int channel)
> -{
> -       u8 found;
> -       unsigned long   flags;
> -       int i;
> -
> -       spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
> -       found = 0;
> -       for (i = 0 ; i < ioc->scsiio_depth; i++) {
> -               if (ioc->scsi_lookup[i].scmd &&
> -                   (ioc->scsi_lookup[i].scmd->device->id == id &&
> -                   ioc->scsi_lookup[i].scmd->device->channel == channel)) {
> -                       found = 1;
> -                       goto out;
> -               }
> -       }
> - out:
> -       spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
> -       return found;
> -}
> -
> -/**
> - * _scsih_scsi_lookup_find_by_lun - search for matching channel:id:lun
> - * @ioc: per adapter object
> - * @id: target id
> - * @lun: lun number
> - * @channel: channel
> - * Context: This function will acquire ioc->scsi_lookup_lock.
> - *
> - * This will search for a matching channel:id:lun in the scsi_lookup array,
> - * returning 1 if found.
> - */
> -static u8
> -_scsih_scsi_lookup_find_by_lun(struct MPT3SAS_ADAPTER *ioc, int id,
> -       unsigned int lun, int channel)
> -{
> -       u8 found;
> -       unsigned long   flags;
> -       int i;
> -
> -       spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
> -       found = 0;
> -       for (i = 0 ; i < ioc->scsiio_depth; i++) {
> -               if (ioc->scsi_lookup[i].scmd &&
> -                   (ioc->scsi_lookup[i].scmd->device->id == id &&
> -                   ioc->scsi_lookup[i].scmd->device->channel == channel &&
> -                   ioc->scsi_lookup[i].scmd->device->lun == lun)) {
> -                       found = 1;
> -                       goto out;
> -               }
> -       }
> - out:
> -       spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
> -       return found;
> -}
> -
> -/**
>   * scsih_change_queue_depth - setting device queue depth
>   * @sdev: scsi device struct
>   * @qdepth: requested queue depth
> @@ -2339,19 +2271,9 @@ struct _sas_node *
>                 rc = FAILED;
>                 break;
>
> -       case MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
> -               if (_scsih_scsi_lookup_find_by_target(ioc, id, channel))
> -                       rc = FAILED;
> -               else
> -                       rc = SUCCESS;
> -               break;
>         case MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET:
>         case MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET:
> -               if (_scsih_scsi_lookup_find_by_lun(ioc, id, lun, channel))
> -                       rc = FAILED;
> -               else
> -                       rc = SUCCESS;
> -               break;
> +       case MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
>         case MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK:
>                 rc = SUCCESS;
>                 break;
> @@ -2554,7 +2476,9 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
>         r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
>             scmd->device->id, scmd->device->lun,
>             MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30);
> -
> +       /* Check for busy commands after reset */
> +       if (r == SUCCESS && atomic_read(&scmd->device->device_busy))
> +               r = FAILED;

For an experiment, I have mocked driver to return 'task abort' with
fail status even though it was able to abort the IO. I have done this
so that we can test whether device reset is working fine or not.

I have started the IO's on a drive and using lsiutil utility I have
done link reset for that drive. Then I observe that some IO's got
timedout and received task abort TM for these timedout. As I have
hard-coded task abort TM to return with failure status, so after some
time driver has received device reset TM. after processing device TM,
in the driver still we observe that 'device_busy' value is non-zero
and driver returns this TM with failure status, even though their is
no references for the timedout IO in the driver(i.e. driver has
returned the timed out IO back to SML).

Even without modifying anything in the driver. Run the IO's on one
drive and issue device reset TM using sg_util and we observe the
device_busy for this device will be non-zero (even it has aborted all
the outstanding IOs at that time for that device) and eventually
target reset TM is received by the driver.

>   out:
>         sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
>             ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> @@ -2616,7 +2540,9 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
>         r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
>             scmd->device->id, 0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
>             30);
> -
> +       /* Check for busy commands after reset */
> +       if (r == SUCCESS && atomic_read(&starget->target_busy))

I have printed this 'target_busy' variable just before issuing target
reset TM to firmware and I always observe that this variable value is
zero, as shown below,

[ +16.424120] scsi target11:0:4: attempting target reset! scmd(ffff883ede7b4a80)
[  +0.000005] sd 11:0:4:0: CDB: Test Unit Ready
[  +0.000005] scsi target11:0:4: handle(0x0015),
sas_address(0x500003956c88df5b), phy(12)
[  +0.000002] scsi target11:0:4:
enclosure_logical_id(0x500605b012345600), slot(6)
[  +0.000002] scsi target11:0:4: enclosure level(0x0000),connector name(C1  )
[  +0.000002] LSI debug.. target_busy count: 0
[  +0.000004] mpt3sas_cm1: sending tm: handle(0x0015), task_type(0x03), smid(0)
[  +0.249457] sd 11:0:4:0: [sdj] tag#294 CDB: Read(10) 28 00 08 49 9e
80 00 0a 00 00
[  +0.000002] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000001] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(295)
[  +0.000001] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(1310720)
[  +0.000000] mpt3sas_cm1:     tag(8473), transfer_count(0),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000003] sd 11:0:4:0: [sdj] tag#209 CDB: Read(10) 28 00 08 5b ec
c0 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(210)
[  +0.000001] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000000] mpt3sas_cm1:     tag(7828), transfer_count(524288),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#123 CDB: Read(10) 28 00 08 56 03
a0 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(124)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000000] mpt3sas_cm1:     tag(7106), transfer_count(524288),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#0 CDB: Read(10) 28 00 08 cc 0f 80
00 03 40 00
[  +0.000000] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000001] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(1)
[  +0.000000] mpt3sas_cm1:     request_len(425984), underflow(425984),
resid(425984)
[  +0.000001] mpt3sas_cm1:     tag(7042), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#33 CDB: Read(10) 28 00 08 cc 1e
e0 00 03 80 00
[  +0.000000] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000001] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(34)
[  +0.000001] mpt3sas_cm1:     request_len(458752), underflow(458752),
resid(458752)
[  +0.000000] mpt3sas_cm1:     tag(7026), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#221 CDB: Read(10) 28 00 08 50 cc
e0 00 01 c0 00
[  +0.000000] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000001] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(222)
[  +0.000001] mpt3sas_cm1:     request_len(229376), underflow(229376),
resid(183296)
[  +0.000000] mpt3sas_cm1:     tag(5505), transfer_count(46080),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#36 CDB: Read(10) 28 00 08 91 c3
e0 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(37)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(262144)
[  +0.000001] mpt3sas_cm1:     tag(5337), transfer_count(1048576),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#17 CDB: Read(10) 28 00 08 cc 18
a0 00 03 20 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000001] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(18)
[  +0.000000] mpt3sas_cm1:     request_len(409600), underflow(409600),
resid(409600)
[  +0.000001] mpt3sas_cm1:     tag(5129), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#191 CDB: Read(10) 28 00 08 92 19
40 00 0a 00 00
[  +0.000000] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000001] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(192)
[  +0.000001] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000000] mpt3sas_cm1:     tag(5109), transfer_count(524288),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#41 CDB: Read(10) 28 00 08 50 ce
a0 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(42)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(1310720)
[  +0.000001] mpt3sas_cm1:     tag(5086), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#199 CDB: Read(10) 28 00 08 92 da
e0 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(200)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000001] mpt3sas_cm1:     tag(5055), transfer_count(524288),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#195 CDB: Read(10) 28 00 08 5b f6
c0 00 01 c0 00
[  +0.000000] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000001] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(196)
[  +0.000001] mpt3sas_cm1:     request_len(229376), underflow(229376),
resid(229376)
[  +0.000000] mpt3sas_cm1:     tag(4755), transfer_count(0),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#108 CDB: Read(10) 28 00 08 cc 0d
40 00 02 40 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(109)
[  +0.000000] mpt3sas_cm1:     request_len(294912), underflow(294912),
resid(294912)
[  +0.000001] mpt3sas_cm1:     tag(4706), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#40 CDB: Read(10) 28 00 08 55 ef
a0 00 0a 00 00
[  +0.000000] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000001] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(41)
[  +0.000001] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000000] mpt3sas_cm1:     tag(4446), transfer_count(524288),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#219 CDB: Read(10) 28 00 08 50 c2
e0 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(220)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000001] mpt3sas_cm1:     tag(4301), transfer_count(524288),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#21 CDB: Read(10) 28 00 08 92 37
40 00 01 c0 00
[  +0.000000] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000001] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(22)
[  +0.000000] mpt3sas_cm1:     request_len(229376), underflow(229376),
resid(229376)
[  +0.000001] mpt3sas_cm1:     tag(4261), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#154 CDB: Read(10) 28 00 08 91 cf
a0 00 01 c0 00
[  +0.000000] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000001] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(155)
[  +0.000000] mpt3sas_cm1:     request_len(229376), underflow(229376),
resid(229376)
[  +0.000001] mpt3sas_cm1:     tag(4246), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#201 CDB: Read(10) 28 00 08 92 e4
e0 00 0a 00 00
[  +0.000000] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000001] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(202)
[  +0.000001] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000000] mpt3sas_cm1:     tag(4068), transfer_count(524288),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#26 CDB: Read(10) 28 00 08 cc 1b
c0 00 03 20 00
[  +0.000000] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000001] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(27)
[  +0.000001] mpt3sas_cm1:     request_len(409600), underflow(409600),
resid(409600)
[  +0.000000] mpt3sas_cm1:     tag(3989), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000002] sd 11:0:4:0: [sdj] tag#60 CDB: Read(10) 28 00 08 49 8a
80 00 0a 00 00
[  +0.000000] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000001] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(61)
[  +0.000001] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(1310720)
[  +0.000000] mpt3sas_cm1:     tag(3974), transfer_count(0),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#196 CDB: Read(10) 28 00 08 92 23
40 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(197)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000001] mpt3sas_cm1:     tag(3704), transfer_count(524288),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#179 CDB: Read(10) 28 00 08 92 ee
e0 00 01 c0 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000001] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(180)
[  +0.000000] mpt3sas_cm1:     request_len(229376), underflow(229376),
resid(229376)
[  +0.000001] mpt3sas_cm1:     tag(3491), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#37 CDB: Read(10) 28 00 08 5b d8
c0 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(38)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000000] mpt3sas_cm1:     tag(3363), transfer_count(524288),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#19 CDB: Read(10) 28 00 08 91 af
e0 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(20)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(262144)
[  +0.000000] mpt3sas_cm1:     tag(3329), transfer_count(1048576),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#32 CDB: Read(10) 28 00 08 91 b9
e0 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(33)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(262144)
[  +0.000001] mpt3sas_cm1:     tag(3075), transfer_count(1048576),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#16 CDB: Read(10) 28 00 08 cc 12
c0 00 05 e0 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000001] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(17)
[  +0.000000] mpt3sas_cm1:     request_len(770048), underflow(770048),
resid(770048)
[  +0.000001] mpt3sas_cm1:     tag(3017), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#200 CDB: Read(10) 28 00 08 56 0d
a0 00 01 c0 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(201)
[  +0.000000] mpt3sas_cm1:     request_len(229376), underflow(229376),
resid(229376)
[  +0.000001] mpt3sas_cm1:     tag(2588), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#207 CDB: Read(10) 28 00 08 5b e2
c0 00 0a 00 00
[  +0.000000] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000001] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(208)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000000] mpt3sas_cm1:     tag(2355), transfer_count(524288),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#5 CDB: Read(10) 28 00 08 cc 05 20
00 02 c0 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(6)
[  +0.000000] mpt3sas_cm1:     request_len(360448), underflow(360448),
resid(360448)
[  +0.000000] mpt3sas_cm1:     tag(2337), transfer_count(0),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#86 CDB: Read(10) 28 00 08 55 f9
a0 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(87)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000000] mpt3sas_cm1:     tag(2068), transfer_count(524288),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#13 CDB: Read(10) 28 00 08 cc 07
e0 00 05 60 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(14)
[  +0.000000] mpt3sas_cm1:     request_len(704512), underflow(704512),
resid(704512)
[  +0.000000] mpt3sas_cm1:     tag(1860), transfer_count(0),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#230 CDB: Read(10) 28 00 08 49 94
80 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(231)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(1310720)
[  +0.000000] mpt3sas_cm1:     tag(1813), transfer_count(0),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#35 CDB: Read(10) 28 00 08 92 2d
40 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(36)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(1310720)
[  +0.000001] mpt3sas_cm1:     tag(1764), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#91 CDB: Read(10) 28 00 08 49 a8
80 00 01 c0 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(92)
[  +0.000000] mpt3sas_cm1:     request_len(229376), underflow(229376),
resid(229376)
[  +0.000001] mpt3sas_cm1:     tag(1654), transfer_count(0),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#197 CDB: Read(10) 28 00 08 92 d0
e0 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(198)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000001] mpt3sas_cm1:     tag(1353), transfer_count(524288),
sc->result(0x00080000)
[  +0.000000] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000001] sd 11:0:4:0: [sdj] tag#146 CDB: Read(10) 28 00 08 50 b8
e0 00 0a 00 00
[  +0.000001] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000000] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015), ioc_status(scsi task
terminated)(0x0048), smid(147)
[  +0.000000] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(786432)
[  +0.000000] mpt3sas_cm1:     tag(1177), transfer_count(524288),
sc->result(0x00080000)
[  +0.000001] mpt3sas_cm1:     scsi_status(good)(0x00),
scsi_state(state terminated no status )(0x0c)
[  +0.000038] mpt3sas_cm1: complete tm: ioc_status(0x0000),
loginfo(0x00000000), term_count(0x00000024)
[  +0.000002] mpt3sas_cm1: response_code(0x0): task management request completed
[  +0.000007] scsi target11:0:4: target reset: SUCCESS scmd(ffff883ede7b4a80)
[  +0.000674] sd 11:0:4:0: tag#50 CDB: Test Unit Ready 00 00 00 00 00 00
[  +0.000002] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000001] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000002] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015),
ioc_status(success)(0x0000), smid(51)
[  +0.000001] mpt3sas_cm1:     request_len(0), underflow(0), resid(0)
[  +0.000002] mpt3sas_cm1:     tag(0), transfer_count(0), sc->result(0x00000000)
[  +0.000002] mpt3sas_cm1:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  +0.000003] mpt3sas_cm1:     [sense_key,asc,ascq]: [0x06,0x29,0x02], count(96)
[  +0.000003] sd 11:0:4:0: tag#50 CDB: Test Unit Ready 00 00 00 00 00 00
[  +0.000002] mpt3sas_cm1:     sas_address(0x500003956c88df5b), phy(12)
[  +0.000001] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(6)
[  +0.000001] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0015),
ioc_status(success)(0x0000), smid(51)
[  +0.000002] mpt3sas_cm1:     request_len(0), underflow(0), resid(0)
[  +0.000001] mpt3sas_cm1:     tag(0), transfer_count(0), sc->result(0x00000002)
[  +0.000002] mpt3sas_cm1:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  +0.000002] mpt3sas_cm1:     [sense_key,asc,ascq]: [0x06,0x29,0x02], count(96)
[  +0.613601] mpt3sas_cm1: Discovery: (start)

[  +0.000019] mpt3sas_cm1: discovery event: (start)

[  +0.000097] mpt3sas_cm1: SAS Topology Change List
[  +0.000004] mpt3sas_cm1: sas topology change: (responding)
[  +0.000001]     handle(0x0000), enclosure_handle(0x0001)
start_phy(12), count(1)
[  +0.000001] mpt3sas_cm1: Discovery: (stop)

[  +0.000017]     phy(12), attached_handle(0x0015): link rate change:
link rate: new(0x0b), old(0x0b)
[  +0.000001] mpt3sas_cm1: updating handles for sas_host(0x500605b012345600)
[  +0.000356] mpt3sas_cm1: discovery event: (stop)

[  +0.740157] sd 11:0:2:0: [sdh] tag#63 CDB: Read(10) 28 00 08 a9 f8
20 00 0a 00 00
[  +0.000003] mpt3sas_cm1:     sas_address(0x500003956c88df9f), phy(10)
[  +0.000000] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(5)
[  +0.000001] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0016), ioc_status(scsi data
underrun)(0x0045), smid(64)
[  +0.000001] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(12288)
[  +0.000001] mpt3sas_cm1:     tag(0), transfer_count(1298432),
sc->result(0x00000002)
[  +0.000001] mpt3sas_cm1:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  +0.000001] mpt3sas_cm1:     [sense_key,asc,ascq]: [0x0b,0x4b,0x03], count(96)
[Mar 3 16:00] sd 11:0:2:0: [sdh] tag#61 CDB: Read(10) 28 00 08 fc bd
80 00 0a 00 00
[  +0.000002] mpt3sas_cm1:     sas_address(0x500003956c88df9f), phy(10)
[  +0.000001] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(5)
[  +0.000001] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000000] mpt3sas_cm1:     handle(0x0016), ioc_status(scsi data
underrun)(0x0045), smid(62)
[  +0.000001] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(155648)
[  +0.000001] mpt3sas_cm1:     tag(0), transfer_count(1155072),
sc->result(0x00000002)
[  +0.000001] mpt3sas_cm1:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  +0.000000] mpt3sas_cm1:     [sense_key,asc,ascq]: [0x0b,0x4b,0x03], count(96)
[ +11.430447] sd 11:0:2:0: [sdh] tag#89 CDB: Read(10) 28 00 09 22 1d
80 00 0a 00 00
[  +0.000004] mpt3sas_cm1:     sas_address(0x500003956c88df9f), phy(10)
[  +0.000001] mpt3sas_cm1:     enclosure_logical_id(0x500605b012345600),slot(5)
[  +0.000001] mpt3sas_cm1:     enclosure level(0x0000), connector name( C1  )
[  +0.000001] mpt3sas_cm1:     handle(0x0016), ioc_status(scsi data
underrun)(0x0045), smid(90)
[  +0.000002] mpt3sas_cm1:     request_len(1310720),
underflow(1310720), resid(806912)
[  +0.000001] mpt3sas_cm1:     tag(0), transfer_count(503808),
sc->result(0x00000002)
[  +0.000001] mpt3sas_cm1:     scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
[  +0.000001] mpt3sas_cm1:     [sense_key,asc,ascq]: [0x0b,0x4b,0x03], count(96)


Thanks,
Sreekanth

> +               r = FAILED;
>   out:
>         starget_printk(KERN_INFO, starget, "target reset: %s scmd(%p)\n",
>             ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> --
> 1.8.5.6
>
