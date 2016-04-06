From: Bastien Philbert <bastienphilbert@gmail.com>
Subject: Re: [PATCH] csiostor: Fix backwards locking in the function
 __csio_unreg_rnode
Date: Wed, 6 Apr 2016 09:21:38 -0400
Message-ID: <57050D62.3090802@gmail.com>
References: <1459891143-20451-1-git-send-email-bastienphilbert@gmail.com>
 <CAGRGNgXXBZb91xgRfkU_xtAF4rmCFbDFuxq8jRmQzJXU2wHb7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f67.google.com ([209.85.192.67]:36589 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbcDFNVl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2016 09:21:41 -0400
In-Reply-To: <CAGRGNgXXBZb91xgRfkU_xtAF4rmCFbDFuxq8jRmQzJXU2wHb7Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



On 2016-04-06 03:48 AM, Julian Calaby wrote:
> Hi Bastien,
> 
> On Wed, Apr 6, 2016 at 7:19 AM, Bastien Philbert
> <bastienphilbert@gmail.com> wrote:
>> This fixes backwards locking in the function __csio_unreg_rnode to
>> properly lock before the call to the function csio_unreg_rnode and
>> not unlock with spin_unlock_irq as this would not allow the proper
>> protection for concurrent access on the shared csio_hw structure
>> pointer hw. In addition switch the locking after the critical region
>> function call to properly unlock instead with spin_unlock_irq on
>>
>> Signed-off-by: Bastien Philbert <bastienphilbert@gmail.com>
>> ---
>>  drivers/scsi/csiostor/csio_rnode.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/csiostor/csio_rnode.c b/drivers/scsi/csiostor/csio_rnode.c
>> index e9c3b04..029a09e 100644
>> --- a/drivers/scsi/csiostor/csio_rnode.c
>> +++ b/drivers/scsi/csiostor/csio_rnode.c
>> @@ -580,9 +580,9 @@ __csio_unreg_rnode(struct csio_rnode *rn)
>>                 ln->last_scan_ntgts--;
>>         }
>>
>> -       spin_unlock_irq(&hw->lock);
>> -       csio_unreg_rnode(rn);
>>         spin_lock_irq(&hw->lock);
>> +       csio_unreg_rnode(rn);
>> +       spin_unlock_irq(&hw->lock);
> 
> Are you _certain_ this is correct? This construct usually appears when
> a function has a particular lock held, then needs to unlock it to call
> some other function. Are you _certain_ that this isn't the case?
> 
> Thanks,
> 
Yes I am pretty certain this is correct. I checked the paths that called this function
and it was weired that none of them gradded the spinlock before hand.
Cheers,
Bastien
