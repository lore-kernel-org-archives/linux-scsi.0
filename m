From: Grant Grundler <grundler@google.com>
Subject: Re: libata / scsi separation
Date: Tue, 9 Dec 2008 18:29:34 -0800
Message-ID: <da824cf30812091829g180b3e45i843e356364bc2f9f@mail.gmail.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	 <20081206120001.3580b9e3@tuna> <200812062241.35601.bzolnier@gmail.com>
	 <20081206222423.04aada70@lxorguk.ukuu.org.uk>
	 <493B022B.3050406@ru.mvista.com>
	 <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
	 <493B0867.5020700@ru.mvista.com>
	 <1228662298.3501.19.camel@localhost.localdomain>
	 <20081209222113.GU25548@parisc-linux.org> <493F2151.6010702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <493F2151.6010702@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 9, 2008 at 5:54 PM, Tejun Heo <htejun@gmail.com> wrote:
> (cc'ing Jens)
...
> Is the command issue rate really the bottleneck?

Not directly. It's the lack of CPU leftover at high transaction rates
( > 10000 IOPS per disk). So yes, the system does bottle neck on CPU
utilization.

> It seem a bit
> unlikely unless you're issuing lots of really small IOs but then again
> those new SSDs are pretty fast.

That's the whole point of SSDs (lots of small, random IO).

The second desirable attribute SSDs have is consistent response for
reads. HDs vary from microseconds to 100's of milliseconds. Very long
tail in the read latency response.

>> (OK, I haven't measured the overhead of the *SCSI* layer, I've measured
>> the overhead of the *libata* layer.  I think the point here is that you
>> can't measure the difference at a macro level unless you're sending a
>> lot of commands.)
>
> How did you measure it?

Willy presented how he measured SCSI stack at LSF2008. ISTR he was
advised to use oprofile in his test application so there is probably
an updated version of these slides:
    http://iou.parisc-linux.org/lsf2008/IO-latency-Kristen-Carlson-Accardi.pdf

> The issue path isn't thick at all although
> command allocation logic there is a bit brain damaged and should use
> block layer tag management.  All it does is - allocate qc, interpret
> SCSI command to ATA command and write it to qc, map dma and build dma
> table and pass it over to the low level issue function.  The only
> extra step there is the translation part and I don't think that can
> take a full microsecond on modern processors.

Maybe you are counting instructions and not cycles? Every cache miss
is 200-300 cycles (say 100ns). When running multiple threads, we will
miss on nearly every spinlock acquisition and probably on several data
accesses. 1 microsecond isn't alot when counting this way.

hth,
grant
