From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 07/10] mpt3sas: use hi-priority queue for TMFs
Date: Thu, 16 Feb 2017 15:53:14 +0530
Message-ID: <CAK=zhgrCJ7Dzg-aF-Xbx32eEEisjDtN3ffDXXQf==suYntpdTw@mail.gmail.com>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <1485854760-122683-8-git-send-email-hare@suse.de> <CAK=zhgpVhm06-r_CYOmpLrU+uEf9QwM+WpS74OmmmHkJ0Up3Hg@mail.gmail.com>
 <1a6f0c63-8987-8523-2a00-980a461bf79a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:36820 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752820AbdBPKXP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 05:23:15 -0500
Received: by mail-qt0-f172.google.com with SMTP id k15so10074508qtg.3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2017 02:23:15 -0800 (PST)
In-Reply-To: <1a6f0c63-8987-8523-2a00-980a461bf79a@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.com>

On Thu, Feb 16, 2017 at 3:44 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 02/16/2017 11:09 AM, Sreekanth Reddy wrote:
>> On Tue, Jan 31, 2017 at 2:55 PM, Hannes Reinecke <hare@suse.de> wrote:
>>> When sending a TMF via the ioctl interface we should be using
>>> the hi-priority queue instead of the scsi queue to be consistent
>>> with overall TMF usage.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>>> ---
>>>  drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/=
mpt3sas_ctl.c
>>> index 95f0f24..e952175 100644
>>> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
>>> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
>>> @@ -720,7 +720,7 @@ enum block_state {
>>>                 }
>>>         } else {
>>>
>>> -               smid =3D mpt3sas_base_get_smid_scsiio(ioc, ioc->ctl_cb_=
idx, NULL);
>>> +               smid =3D mpt3sas_base_get_smid_hpr(ioc, ioc->ctl_cb_idx=
);
>>
>> This else part is not for TM path, It is for IO path. For the TM
>> request we are already using smid from hpr queue, as shown below
>>
>> if (mpi_request->Function =3D=3D MPI2_FUNCTION_SCSI_TASK_MGMT) {
>>                 smid =3D mpt3sas_base_get_smid_hpr(ioc, ioc->ctl_cb_idx)=
;
>>                 if (!smid) {
>>                         pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\=
n",
>>                             ioc->name, __func__);
>>                         ret =3D -EAGAIN;
>>                         goto out;
>>                 }
>>         } else {
>>
>>                 smid =3D mpt3sas_base_get_smid_scsiio(ioc, ioc->ctl_cb_i=
dx, NULL);
>>
> Yes, I know.
> But the current method of inserting a SCSI command completely goes
> against blk-mq request usage; with blk-mq the tags are managed with the
> block layer, so you need to integrate with that to get a correct tag.
>
> Is this _really_ a crucial functionality? Can't we just drop it and use
> sg/bsg for this?
> It would make my life _so_ much easier; the alternative would be to
> either implement 'real' reserved command handling or rewriting the above
> code-path in terms of 'struct request', packing and unpacking as we go.
> Neither is very appealing.

I think it is better to take out one request frame from can_queue
count and reserve it for this ioctl scsi io. Since we allow only one
ioctl command at a time.

Thanks,
Sreekanth

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
