From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/10] mpt3sas: separate out _base_recovery_check()
Date: Thu, 16 Feb 2017 11:03:50 +0100
Message-ID: <4a84aa72-5a4b-510e-8eb6-e6f1c7b2a0db@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <1485854760-122683-5-git-send-email-hare@suse.de>
 <CAK=zhgpvR7KoReCHzN7uqd1KgBK0wHoeBc2yiZgniF5aQJwmwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40727 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754412AbdBPKDw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 05:03:52 -0500
In-Reply-To: <CAK=zhgpvR7KoReCHzN7uqd1KgBK0wHoeBc2yiZgniF5aQJwmwA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 02/16/2017 10:53 AM, Sreekanth Reddy wrote:
> On Tue, Jan 31, 2017 at 2:55 PM, Hannes Reinecke <hare@suse.de> wrote:
>> No functional change.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c | 23 ++++++++++++++---------
>>  1 file changed, 14 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index 120b317..dd14596 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -2366,6 +2366,19 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>>  }
>>
>>  static void
>> +_base_recovery_check(struct MPT3SAS_ADAPTER *ioc)
>> +{
>> +       /*
>> +        * See _wait_for_commands_to_complete() call with regards to this code.
>> +        */
>> +       if (ioc->shost_recovery && ioc->pending_io_count) {
>> +               if (ioc->pending_io_count == 1)
>> +                       wake_up(&ioc->reset_wq);
>> +               ioc->pending_io_count = 0;
> 
> I think here we should reduce the pending_io_count by one instead of
> assigning it to zero in-order to have same behavior as before.
> 
Ouch, indeed. My fault.

Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
