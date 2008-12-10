From: Grant Grundler <grundler@google.com>
Subject: Re: libata / scsi separation
Date: Tue, 9 Dec 2008 19:23:00 -0800
Message-ID: <da824cf30812091923j241f915dmbcb27245c0d0491b@mail.gmail.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	 <20081206222423.04aada70@lxorguk.ukuu.org.uk>
	 <493B022B.3050406@ru.mvista.com>
	 <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
	 <493B0867.5020700@ru.mvista.com>
	 <1228662298.3501.19.camel@localhost.localdomain>
	 <20081209222113.GU25548@parisc-linux.org> <493F2151.6010702@gmail.com>
	 <da824cf30812091829g180b3e45i843e356364bc2f9f@mail.gmail.com>
	 <493F2DA9.7040008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <493F2DA9.7040008@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,

On Tue, Dec 9, 2008 at 6:47 PM, Tejun Heo <htejun@gmail.com> wrote:
...
>> That's the whole point of SSDs (lots of small, random IO).
>
> But on many workloads, filesystems manage to colocate what belongs
> together and with little help from read ahead and block layer we
> manage to dish out decently sized requests.

True. And plenty of applications use a database which can't co-locate
the data. Read ahead for random IO just wastes BW and CPU cycles.

> It will be great to serve
> 4k requests as fast as we can but whether that should be (or rather
> how much) the focal point of optimization is a slightly different
> problem.

"How much the focal point" is a fair question. If someone can produce
a super efficient SATA or SAS storage controller, I'd think it would
matter more.

...
>> Willy presented how he measured SCSI stack at LSF2008. ISTR he was
>> advised to use oprofile in his test application so there is probably
>> an updated version of these slides:
>>     http://iou.parisc-linux.org/lsf2008/IO-latency-Kristen-Carlson-Accardi.pdf
>
> Ah... okay, with ram low level driver.

Right. that's alot faster than any SSD. But it's a convenient way to
get consistent, precise numbers for workloads that can be scaled down
to fit into RAM.

...
>> Maybe you are counting instructions and not cycles? Every cache miss
>> is 200-300 cycles (say 100ns). When running multiple threads, we will
>> miss on nearly every spinlock acquisition and probably on several data
>> accesses. 1 microsecond isn't alot when counting this way.
>
> Yeah, ata uses its own locking and the qc allocation does atomic
> bitops for each bit for no good reason which can hurt for very hi-ops
> with NCQ tags filled up.  If serving 4k requests as fast as possible
> is the goal, I'm not really sure the current SCSI or ATA commands are
> the best suited ones.  Both SCSI and ATA are focused on rotating media
> with seek latency

I think existing File Systems and block IO schedulers (except NOOP) are
tuned for rotating media and access patterns that benefit this media the most.

> and thus have SG on the host bus side in mode cases
> but never on the device side.

SG == scatter-gather? I'm not sure why that is specific to rotating media.
Or is this referring to "SCSI-generic" pass through?

In any case, only traversing one fewer layers (SCSI or libata) in
block code path would help serve 4k requests more efficiently.

> If getting the maximum random scattered
> access throughput is a must, the best way would be adding a SG r/w
> commands to ATA and adapt our storage stack accordingly.

I don't think everyone wants to throw out the entire stack.
But adding a passthrough for ATA and connecting that to FUSE might
be a performant alternative.

thanks,
grant

> Thanks.
>
> --
> tejun
>
