From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 2/6] libata: Report supported TRIM payload size
Date: Fri, 20 Aug 2010 09:53:42 -0400
Message-ID: <4C6E88E6.7060307@teksavvy.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com> <1282232941-9910-3-git-send-email-martin.petersen@oracle.com> <AANLkTike+4Z2Z7eHEN=NHY=N72cO5bGJUwJbXzgJAKUx@mail.gmail.com> <yq1fwyamq9s.fsf@sermon.lab.mkp.net> <4C6DA713.40601@teksavvy.com> <20100820085801.GB27033@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100820085801.GB27033@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Freemyer <greg.freemyer@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10-08-20 04:58 AM, Christoph Hellwig wrote:
> On Thu, Aug 19, 2010 at 05:50:11PM -0400, Mark Lord wrote:
>> On 10-08-19 02:05 PM, Martin K. Petersen wrote:
>>> I'm only aware of one drive that currently
>>> supports more than 512 bytes of payload and it also caps at 4KB.
>>
>> SSDs based upon the Indilinx Barefoot controller support
>> more or less "infinite" payload for TRIM, with no cap.
>> But it predates idword[105], so just has a zero there.
>
> Is there an easy way to identify them?  If so we could add a quirk
> for them if it provides enough benefit.


Each brand/model identifies itself differently.
But we could start a whitelist on based on the model name field
from the ATA identify data.

The OCZ VERTEX drives I have here, identify themselves as "OCZ-VERTEX",
and accept very very long payloads (no limit?).

The OCZ VERTEX-LE drives here do have a limit, of 8 sectors,
and identify themselves as "OCZ VERTEX-LE" in that field.

That's what hdparm-9.30 uses to figure out the max TRIM payloads,
in the absence of a value in word 105.

Cheers

