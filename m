From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Question] Calling request_firmware under the spinlocks in file
 advansys.c
Date: Tue, 27 Sep 2016 17:16:11 +0200
Message-ID: <8ec2185d-203e-71fa-c274-65faf338820f@suse.de>
References: <57D7C470.5070505@oracle.com> <57EA5769.1080807@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57EA5769.1080807@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vaishali Thakkar <vaishali.thakkar@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/27/2016 01:26 PM, Vaishali Thakkar wrote:
> 
> 
> On Tuesday 13 September 2016 02:48 PM, Vaishali Thakkar wrote:
>> Hi,
>>
>> In the file drivers/scsi/advansys.c we are calling function AdvISR at 2 instances
>> [in the function advansys_reset and advansys_interrupt] while holding spinlock.
>> Function AdvISR eventually calls request_firmware following this sequence of
>> routines: 
>>
>> AdvISR -> adv_async_callback -> AdvResetChipAndSB -> AdvInitAsc3550Driver ->
>> request_firmware
>>
>> According to the definition of request_firmware it should be called from user
>> context where sleeping is allowed. And usually sleeping under the spin lock is
>> not allowed. Is it really necessary to call AdvISR under spinlocks here? Are
>> we taking care of sleeping related concern of request_firmware or am I
>> overlooking something here?
> 
> Hi,
> 
> Any comments on this?
> 
AdvISR is the main interrupt handling routine, for which we definitely
will want to have interupts disabled. Plus the SCSI parallel drivers
(ab-) use the interrupt routine to do all sorts of things, and are
thereby well versed to keep interrupts disabled for an extented amount
of time.
However, we don't really have a good way of handling a request firmware
here; we probably would need to implement a workqueue to handle this
properly ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
