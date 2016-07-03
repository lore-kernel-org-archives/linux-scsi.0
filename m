From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: Re: [PATCHv3] mvsas:Fix possible NULL pointer deference in mvs_dev_found_notify
Date: Sun, 03 Jul 2016 14:54:01 +0100
Message-ID: <577918F9.8050000@osg.samsung.com>
References: <1467478843-16315-1-git-send-email-xerofoify@gmail.com>	 <57780508.3030200@osg.samsung.com> <1467486317.2400.34.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45540
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbcGCNyI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jul 2016 09:54:08 -0400
In-Reply-To: <1467486317.2400.34.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Krause <xerofoify@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org, hare@suse.de, jthumshirn@suse.de, Wilfried.Weissmann@gmx.de, davispuh@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 02/07/16 20:05, James Bottomley wrote:
> On Sat, 2016-07-02 at 19:16 +0100, Luis de Bethencourt wrote:
>> On 02/07/16 18:00, Nicholas Krause wrote:
>>> This adds properly checking after the call to mvs_find_dev_mvi
>>>  due to this function being able to return a NULL pointer and
>>> if this does arise we will deference it in mvs_alloc_dev due
>>> to this function never checking if a NULL pointer is given as
>>> it's input argument. Signed-off-by: Nicholas Krause <
>>> xerofoify@gmail.com>
>>> ---
>>> v3 - Make logic simpler on error path by returning -1 directly
>>> if mvs_find_dev_mvi returns NULL.
>>> v2 - Fix NULL pointer deferenece in error path by calling 
>>> spin_unlock_irqrestore on the now NULL pointer, as returned
>>>
>>>
>>>  drivers/scsi/mvsas/mv_sas.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/scsi/mvsas/mv_sas.c
>>> b/drivers/scsi/mvsas/mv_sas.c
>>> index 5b9fcff..dffab01 100644
>>> --- a/drivers/scsi/mvsas/mv_sas.c
>>> +++ b/drivers/scsi/mvsas/mv_sas.c
>>> @@ -1194,6 +1194,8 @@ int mvs_dev_found_notify(struct domain_device
>>> *dev, int lock)
>>>  	struct mvs_device *mvi_device;
>>>  
>>>  	mvi = mvs_find_dev_mvi(dev);
>>> +	if (!mvi)
>>> +		return -1;
>>>  
>>>  	if (lock)
>>>  		spin_lock_irqsave(&mvi->lock, flags);
>>>
>>
>> This looks better :)
>>
>> Checking the value of mvi makes sense if mvs_find_dev_mvi() can
>> return NULL.
> 
> Which it can't, if you actually look at the function.  For this to
> happen, we'd have to be receiving a discovery event for a non-existent
> port on the adapter, meaning the system was so corrupted that operation
> shouldn't be continuing.
> 
> Nick is a known bogus patch submitter.  If you want to review them,
> that's your choice (and perhaps some might be useful), but it's not
> unreasonable of me to expect the review will be thorough enough to turn
> up issues like this.
> 
> James

I had my suspicions about mvfs_find_dev_mvi() returning NULL. Which is why
I said "if it can return NULL". Unfortunately I assumed the base of the patch
was properly considered, because I didn't knew about Nick.

I just searched around and now understand what you mean about his bogus
patches.

Sorry I wasn't thorough enough on my review, I know the above isn't an
excuse. Lesson learned.

In a related note, why is mvi initialized to NULL in mvfs_find_dev_mvi() if
it is going to be overwritten? Curious.

Thanks and apologies,
Luis

> 
> 
>> Reviewed-by: Luis de Bethencourt <luisbg@osg.samsung.com>
>>
>> Thanks,
>> Luis
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

