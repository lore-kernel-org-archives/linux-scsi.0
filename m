From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Re: [PATCH RFC] move scsi parts of dm hw handlerst
	o	scsi layer
Date: Fri, 21 Jul 2006 23:21:58 -0400
Message-ID: <44C199D6.3020302@cs.wisc.edu>
References: <6CCEAEDF4D06984A83F427424F47D6E41491BF@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E41491BF@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

egoggin@emc.com wrote:
>> -----Original Message-----
>> From: dm-devel-bounces@redhat.com 
>> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Mike Christie
>> Sent: Friday, July 21, 2006 7:50 AM
>> To: device-mapper development
>> Cc: linux-scsi@vger.kernel.org; agk@redhat.com
>> Subject: Re: [dm-devel] Re: [PATCH RFC] move scsi parts of dm 
>> hw handlersto scsi layer
>>
>> Hannes Reinecke wrote:
>>>> The patch below begins to push the scsi hw handler code down to the
>>>> scsi
>>>> layer. I only began to covert dm-emc.c and it only hooks in at the
>>>> sense
>>>> decoding in scsi_error.c. I wanted to make sure I was 
>> going about the
>>>> module loading and binding correctly. With a new target 
>> bus we could
>>>> do
>>>> some driver model stuff instead, but I was not sure if that was
>>>> appropriate for this?
>>>>
>>> Why don't we use scsi_devinfo for this?
>> I was adding my fields when I noticed this comment:
>>
>>
>>  * Do not add to this list, use the command line or proc 
>> interface to add
>>  * to the scsi_dev_info_list. This table will eventually go away.
>>
>>
>>> We have to have some sort of device table anyway as these 
>> handlers are
>>> far from being generic, so any sense code which triggers 
>> action on one
>>> device might be perfectly ok for others.
>> When I was looking for the history of that commet, I thought 
>> I read that
>> we are supposed to be moving to some userspace approach that 
>> pushes that
>> info down via some magic interface.
>>
>>> Easiest way would be to have one BLIST flag for each 
>> hardware handler
>>> and merge the respective hardware handler into that target if the
>>> blacklist entry matches.
>>>
>>>> Next up would be to get Jens's cmd type tree and work on 
>> the message
>>>> passing code.
>>>>
>>>> And this patch currently does not work since I do not have 
>> a Clariion
>>>> box and I do not know what to match for the {vendor, 
>> model} tuple. I
>>>> think it was something like DCG or DGC and the model had different
>>>> RAID
>>>> strings depending on how it was setup and could have some 
>> other string
>>>> if it did not use RAID. If you have a Clariion or you work 
>> for EMC and
>>>> happen to know this info could you pass those strings to me?
>>>>
>>> IIRC this is
>>>
>>> 'DGC' 'DISK'
>>> 'DGC' 'RAID 10'
>>> 'DGC' 'RAID 5'
>> Thanks.
>>
>>> Hrmph. There is one bit which doesn't quite work out.
>>> While the hardware handler knows how to handle error codes 
>> and how to
>>> switch
>>> paths for a specific device, it doesn't know _when_ to switch it.
>>> I don't think it's a clever idea to switch paths whenever 
>> you encounter
>>> an
>>> passive path. Seems like you could do a nice ping-pong that way ...
>>
>> This is what we talked about at the bof. It is what the 
>> message passing
>> cmd type stuff is for.
> 
> How would this work?
> 
>> The reason I could not do it yet is 
>> that I could
>> not get Jens's git tree from my hotel.
>>
>> dm-multipath still decide when to switch like before, but scsi hw
>> handlers will execute the low level details now.
> 
> Seems like there is no way to pass to other modules any information
> learned by the sense parsing code in the scsi hw handler.  Any code
> which must act upon the contents of the sense hdr must be located
> in the scsi hw handler.  This can't be desirable.


So we talked about this in person, but for the list I will write it
here. This patch is not meant to cover that. It was just meant to lay
down the scsi code as I thought it might be useful for other things.

We need something to get passed up to multipath with or without my patch.

> 
> What about parsing the sense errors into generic error classes and
> having the end request stuff making these error classes available
> via struct request?

Hey fine by me :)


> 
> We do need to be more clever about when to activate a target
> ... and I think doing so requires multipath specific knowledge which
> may be better placed in a dm-multipath hw handler than a generic scsi hw
> handler.  This code would need to be able to be able to discern a
> failure from a retry-later (bypass) case.

Yeah, so that is a problem with this approach. Just to be clear,
dm-multipath decides when to initiate the failover like before, but when
decoding the error values the scsi level hw handler can we just decode
the sense and translate that to some block layer code. When dm gets this
it can then check the bypass bit and decide what to do based on the
block layer error code it just got and the dm-mpath group state? I have
to see your patches to see what needs to be done, but I agree this is a
draw back to this approach currently.
