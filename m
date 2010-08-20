From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 2/6] libata: Report supported TRIM payload size
Date: Fri, 20 Aug 2010 14:28:34 -0400
Message-ID: <4C6EC952.4010706@teksavvy.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>	<1282232941-9910-3-git-send-email-martin.petersen@oracle.com>	<AANLkTike+4Z2Z7eHEN=NHY=N72cO5bGJUwJbXzgJAKUx@mail.gmail.com>	<yq1fwyamq9s.fsf@sermon.lab.mkp.net>	<4C6DA713.40601@teksavvy.com>	<20100820085801.GB27033@lst.de>	<4C6E88E6.7060307@teksavvy.com> <AANLkTikMkNsqS=nmCmGY4t9bKouaeDC8aAxybcykBSBF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <AANLkTikMkNsqS=nmCmGY4t9bKouaeDC8aAxybcykBSBF@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10-08-20 01:13 PM, Greg Freemyer wrote:
> On Fri, Aug 20, 2010 at 9:53 AM, Mark Lord<kernel@teksavvy.com>  wrote:
>> On 10-08-20 04:58 AM, Christoph Hellwig wrote:
>>>
>>> On Thu, Aug 19, 2010 at 05:50:11PM -0400, Mark Lord wrote:
>>>>
>>>> On 10-08-19 02:05 PM, Martin K. Petersen wrote:
>>>>>
>>>>> I'm only aware of one drive that currently
>>>>> supports more than 512 bytes of payload and it also caps at 4KB.
>>>>
>>>> SSDs based upon the Indilinx Barefoot controller support
>>>> more or less "infinite" payload for TRIM, with no cap.
>>>> But it predates idword[105], so just has a zero there.
>>>
>>> Is there an easy way to identify them?  If so we could add a quirk
>>> for them if it provides enough benefit.
..
> A whitelist to enable large contiguous range trims via 8 512B-block
> payloads seems useful for those devices that don't support word 105.
> (ie. 4KB payload)
>
> But, I doubt there is enough observable performance advantage to
> justify reworking the internal SCSI-ATA translation mechanism in the
> kernel to handle larger payloads.   Especially if only one or two SSDs
> will accept greater than 4KB of payload to the trim command.
..

Actually, for in-kernel uses, even just a single 512-byte long list
would likely be adequate.  The biggest gains will come from simply
having more than one range per TRIM command issued.

Once we get that, it's diminishing returns for larger and larger lists,
and in-kernel code is unlikely to ever be able to generate lists that long.

But getting started should be easier than folks are making it out to be.
The first step is to have "file deletion" issue multi-range trims for
all extents of the file at once, rather than one range at a time as at present.

That'll be the biggest gain, and shouldn't be too complex to implement.
Especially not after Christoph/Tejun's current barrier rework stuff is in place.
