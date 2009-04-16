From: Grant Grundler <grundler@google.com>
Subject: Re: LSF Papers online?
Date: Wed, 15 Apr 2009 23:31:13 -0700
Message-ID: <da824cf30904152331r82594e5i1968471af1dbb1fa@mail.gmail.com>
References: <49E335BA.3020103@panasas.com>
	 <200904141654.24067.bzolnier@gmail.com>
	 <20090414175441.5ce1f59d@lxorguk.ukuu.org.uk>
	 <200904150009.06539.bzolnier@gmail.com>
	 <1239749357.3638.3.camel@mulgrave> <49E53AE6.4010803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49E53AE6.4010803@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 14, 2009 at 6:39 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> James Bottomley wrote:
>>
>> On a final note about the urgency of getting libata out of SCSI: Intel
>> has been worrying for a while about the fatness of the SCSI/libata
>> stack, and its effects on performance, especially command transmission
>> via SAT, so I'm hoping they'll be supporting the effort.
>
> I really don't see this as being a big driver for this move. If you look at
> the code that does the translation of SCSI commands to ATA commands, there
> really is not much there at all of any consequence to CPU usage.

It's measurable. Just need to get sufficient IO rates going. Normal JBOD/RAID
controllers don't care.

See Matthew "the Intel guy" :) Wilcox and Kristen Accardi's paper at LSF2008:
    http://iou.parisc-linux.org/lsf2008/IO-latency-Kristen-Carlson-Accardi.pdf

or just google for "Matthew Wilcox SSD perf" - first four hits I
looked at are what I expected:
    hardware.slashdot.org/article.pl?sid=09/02/13/2337258&from=rss
    markmail.org/message/w22r6y4gik7bjf2w
    https://kerneltrap.org/mailarchive/linux-scsi/2008/12/10/4388804/thread
    www.usenix.org/events/lsf08/tech/IO_Carlson_Accardi_SATA.pdf

(last one is the official location of the same paper)

> Compared to
> any kind of hardware/controller interactions I wouldn't say it's likely to
> be a significant bottleneck at all. In oprofile runs I've done with heavy
> ATA activity, the top time consumers are the interrupt handlers,

interrupts just introduce completion reporting latency. Interrupt mitigation
techinques/smarter controller can reduce this.

> command issue paths,

Hrm? Is this in the device driver?

> code that actually is poking IO registers.

Stupid controller design. NICs have been able to run without
MMIO *Reads* in the performance for more than 5 years now.
New "Enterprise" SAS/SATA controllers are better but I'm not
at liberty to discuss those. (sorry)

> The libata-scsi code
> hasn't even shown up on the radar in my experience.

It won't for normal disk IOPS rates (<1000 IOPS per disk).
Run it at 20K or 50K IOPS and see again.
NICs are pushing alot more than that.

hth,
grant
