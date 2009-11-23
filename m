From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 1/4] block: Allow devices to indicate whether discarded
 	blocks are zeroed
Date: Mon, 23 Nov 2009 12:02:48 -0500
Message-ID: <4B0AC038.6050606@redhat.com>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com>	 <1258771524-26673-2-git-send-email-martin.petersen@oracle.com>	 <20091121101356.GA21716@infradead.org>	 <20091121195802.GC8502@parisc-linux.org> <4B08A543.909@rtr.ca>	 <4B0ABA2F.2090407@redhat.com> <87f94c370911230854v46c1dc35g417a54b8a415ba16@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <87f94c370911230854v46c1dc35g417a54b8a415ba16@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/23/2009 11:54 AM, Greg Freemyer wrote:
> On Mon, Nov 23, 2009 at 11:37 AM, Ric Wheeler<rwheeler@redhat.com>  wrote:
>> On 11/21/2009 09:43 PM, Mark Lord wrote:
>>>
>>> Matthew Wilcox wrote:
>>>>
>>>> On Sat, Nov 21, 2009 at 05:13:56AM -0500, Christoph Hellwig wrote:
>>>>>
>>>>> On Fri, Nov 20, 2009 at 09:45:21PM -0500, Martin K. Petersen wrote:
>>>>>>
>>>>>> The discard ioctl is used by mkfs utilities to clear a block device
>>>>>> prior to putting metadata down.  However, not all devices return zeroed
>>>>>> blocks after a discard.  Some drives return stale data, potentially
>>>>>> containing old superblocks.  It is therefore important to know whether
>>>>>> discarded blocks are properly zeroed.
>>>>>
>>>>> At least for mkfs.xfs we make sure to still zero the important areas
>>>>> after the TRIM ioctl anyway.
>>>>
>>>> Could you change that to zero _before_ the TRIM?
>>>
>>> ..
>>>
>>>
>>> Hopefully not for the drives that *don't* guarantee zeros after TRIM.
>>> Eg. most existing ones, including all of the Indilinx chipset drives.
>>>
>>> Cheers
>>>
>>
>> Note that writing to a block after a discard (write or trim) changes the
>> state of that block back to allocated (mapped) in the target. Basically,
>> that would seem to make the trim redundant and irrelevant.
>>
>> You can zero before the discard but that can still fail is the device
>> returns garbage for a trim'ed block I think,
>>
>> Ric
>
> I understood the mkfs process to be:
>
> - discard / trim 100% of the block device
> - write zeros to the relatively small group of blocks that the
> filesystem assumes will be zero'd.
>
> Seems like the only reasonable way to handle it.
>
> Greg

I agree - the discard of the whole device is a good idea.

I just want to make clear that "discard block X; write block X with zeroed data" 
undoes the discard in general :-)

ric

