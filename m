From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2/6] libata: Report supported TRIM payload size
Date: Fri, 20 Aug 2010 13:13:31 -0400
Message-ID: <AANLkTikMkNsqS=nmCmGY4t9bKouaeDC8aAxybcykBSBF@mail.gmail.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
	<1282232941-9910-3-git-send-email-martin.petersen@oracle.com>
	<AANLkTike+4Z2Z7eHEN=NHY=N72cO5bGJUwJbXzgJAKUx@mail.gmail.com>
	<yq1fwyamq9s.fsf@sermon.lab.mkp.net>
	<4C6DA713.40601@teksavvy.com>
	<20100820085801.GB27033@lst.de>
	<4C6E88E6.7060307@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C6E88E6.7060307@teksavvy.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 20, 2010 at 9:53 AM, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-08-20 04:58 AM, Christoph Hellwig wrote:
>>
>> On Thu, Aug 19, 2010 at 05:50:11PM -0400, Mark Lord wrote:
>>>
>>> On 10-08-19 02:05 PM, Martin K. Petersen wrote:
>>>>
>>>> I'm only aware of one drive that currently
>>>> supports more than 512 bytes of payload and it also caps at 4KB.
>>>
>>> SSDs based upon the Indilinx Barefoot controller support
>>> more or less "infinite" payload for TRIM, with no cap.
>>> But it predates idword[105], so just has a zero there.
>>
>> Is there an easy way to identify them? =A0If so we could add a quirk
>> for them if it provides enough benefit.
>
>
> Each brand/model identifies itself differently.
> But we could start a whitelist on based on the model name field
> from the ATA identify data.
>
> The OCZ VERTEX drives I have here, identify themselves as "OCZ-VERTEX=
",
> and accept very very long payloads (no limit?).
>
> The OCZ VERTEX-LE drives here do have a limit, of 8 sectors,
> and identify themselves as "OCZ VERTEX-LE" in that field.
>
> That's what hdparm-9.30 uses to figure out the max TRIM payloads,
> in the absence of a value in word 105.
>
> Cheers
>

A whitelist to enable large contiguous range trims via 8 512B-block
payloads seems useful for those devices that don't support word 105.
(ie. 4KB payload)

But, I doubt there is enough observable performance advantage to
justify reworking the internal SCSI-ATA translation mechanism in the
kernel to handle larger payloads.   Especially if only one or two SSDs
will accept greater than 4KB of payload to the trim command.

Greg
