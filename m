From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv4 11/12] mpt3sas: simplify
 _wait_for_commands_to_complete()
Date: Fri, 3 Mar 2017 14:53:37 +0100
Message-ID: <1b240787-bc0d-4d97-fcda-238b6d93106c@suse.de>
References: <1487759512-3873-1-git-send-email-hare@suse.de>
 <1487759512-3873-12-git-send-email-hare@suse.de>
 <CAK=zhgrMzWYNznHr+5aVTC_D+mrSRX-raBK=OpU0x+3O0B9otg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52352 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752237AbdCCOM6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Mar 2017 09:12:58 -0500
In-Reply-To: <CAK=zhgrMzWYNznHr+5aVTC_D+mrSRX-raBK=OpU0x+3O0B9otg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 03/03/2017 12:57 PM, Sreekanth Reddy wrote:
> On Wed, Feb 22, 2017 at 4:01 PM, Hannes Reinecke <hare@suse.de> wrote:
>> Use 'host_busy' instead of counting outstanding commands by hand.
>>
>> Suggested-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c | 14 ++++----------
>>  1 file changed, 4 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index e6aafa5..169d185 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -2408,9 +2408,9 @@ struct scsiio_tracker *
>>          * See _wait_for_commands_to_complete() call with regards to this code.
>>          */
>>         if (ioc->shost_recovery && ioc->pending_io_count) {
>> -               if (ioc->pending_io_count == 1)
>> +               ioc->pending_io_count = atomic_read(&ioc->shost->host_busy);
>
> This won't consider the scsi IO issued from ioctl path. If that scsi
> io is still outstanding then here we will return without waiting for
> it to complete.
>
True. Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
