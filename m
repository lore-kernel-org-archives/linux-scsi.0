From: Tejun Heo <htejun@gmail.com>
Subject: Re: libata / scsi separation
Date: Wed, 10 Dec 2008 10:54:25 +0900
Message-ID: <493F2151.6010702@gmail.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp> <200812061551.08525.bzolnier@gmail.com> <20081206120001.3580b9e3@tuna> <200812062241.35601.bzolnier@gmail.com> <20081206222423.04aada70@lxorguk.ukuu.org.uk> <493B022B.3050406@ru.mvista.com> <20081206230227.07b00e2f@lxorguk.ukuu.org.uk> <493B0867.5020700@ru.mvista.com> <1228662298.3501.19.camel@localhost.localdomain> <20081209222113.GU25548@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081209222113.GU25548@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(cc'ing Jens)
Hello,

Matthew Wilcox wrote:
> On Sun, Dec 07, 2008 at 09:04:58AM -0600, James Bottomley wrote:
>> Originally I'd been promised that libata would be out of SCSI within a
>> year (that was when it went in).  The slight problem is that having all
>> the features it needed, SCSI became a very comfortable host. Getting
>> libata out of SCSI was also made difficult by the fact that few people
>> cared enough to help.  The only significant external problem is the size
>> of the stack and the slight performance penalty for SATA disks going
>> over SAT.  Unfortunately for the latter, slight turns out to be pretty
>> unmeasurable, so the only hope became people who cared about
>> footprint ... and there don't seem to be any of those.
> 
> The performance penalty is certainly measurable.  It's about 1 microsecond
> per request extra to go from userspace -> scsi -> libata -> driver
> than it is to go from userspace -> scsi -> driver.  If you issue 400
> commands per second (as you might do with a 15k RPM SCSI drive), that's
> 400 microseconds.  If you issue 10,000 commands per second (as you might
> do with an SSD), that's 10ms of additional CPU time spent in the kernel
> per second (or 1%).
>
> So it's insignificant overhead ... unless you have an SSD.  I have asked
> Tejun if there's anything he wants help with to move the libata-scsi
> separation along, but he's not come up with anything yet.

I'm working on it and will keep one or two patchsets in flight toward
Jens' direction (one is already in Jens' mailbox, I'm working on
another one and yet another got nacked and waiting for update).
Making libata independent of SCSI basically means move non-SCSI
specific parts of SCSI midlayer into block layer and make libata a
direct customer of block layer once everything is in place.  It's a
slow process (for me, especially with upcoming SLES11 release) but
we're getting there bit by bit.

It's kind of difficult for me to say which direction we should go at
this point as the decision doesn't really fall on me and I doubt
anyone has complete picture of it either, so anything which moves
stuff from SCSI midlayer to block layer will be helpful like the
recent timeout changes.

> Right now, I'm investigating a technique that may significantly
> increase the number of requests we can do per second without
> rewriting the whole thing.

Is the command issue rate really the bottleneck?  It seem a bit
unlikely unless you're issuing lots of really small IOs but then again
those new SSDs are pretty fast.

> (OK, I haven't measured the overhead of the *SCSI* layer, I've measured
> the overhead of the *libata* layer.  I think the point here is that you
> can't measure the difference at a macro level unless you're sending a
> lot of commands.)

How did you measure it?  The issue path isn't thick at all although
command allocation logic there is a bit brain damaged and should use
block layer tag management.  All it does is - allocate qc, interpret
SCSI command to ATA command and write it to qc, map dma and build dma
table and pass it over to the low level issue function.  The only
extra step there is the translation part and I don't think that can
take a full microsecond on modern processors.

Thanks.

-- 
tejun
