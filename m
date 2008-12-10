From: Tejun Heo <htejun@gmail.com>
Subject: Re: libata / scsi separation
Date: Wed, 10 Dec 2008 12:44:51 +0900
Message-ID: <493F3B33.8010607@gmail.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>	 <20081206222423.04aada70@lxorguk.ukuu.org.uk>	 <493B022B.3050406@ru.mvista.com>	 <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>	 <493B0867.5020700@ru.mvista.com>	 <1228662298.3501.19.camel@localhost.localdomain>	 <20081209222113.GU25548@parisc-linux.org> <493F2151.6010702@gmail.com>	 <da824cf30812091829g180b3e45i843e356364bc2f9f@mail.gmail.com>	 <493F2DA9.7040008@gmail.com> <da824cf30812091923j241f915dmbcb27245c0d0491b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:21587 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbYLJDo6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2008 22:44:58 -0500
Received: by ti-out-0910.google.com with SMTP id b6so131924tic.23
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2008 19:44:57 -0800 (PST)
In-Reply-To: <da824cf30812091923j241f915dmbcb27245c0d0491b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello,

Grant Grundler wrote:
>>> Maybe you are counting instructions and not cycles? Every cache miss
>>> is 200-300 cycles (say 100ns). When running multiple threads, we will
>>> miss on nearly every spinlock acquisition and probably on several data
>>> accesses. 1 microsecond isn't alot when counting this way.
>> Yeah, ata uses its own locking and the qc allocation does atomic
>> bitops for each bit for no good reason which can hurt for very hi-ops
>> with NCQ tags filled up.  If serving 4k requests as fast as possible
>> is the goal, I'm not really sure the current SCSI or ATA commands are
>> the best suited ones.  Both SCSI and ATA are focused on rotating media
>> with seek latency
> 
> I think existing File Systems and block IO schedulers (except NOOP) are
> tuned for rotating media and access patterns that benefit this media the most.

Acutally, the whole stack is optimized toward IO devices with seek
latency, from the hardware to our drivers and the whole block layer
itself.

>> and thus have SG on the host bus side in mode cases
>> but never on the device side.
> 
> SG == scatter-gather? I'm not sure why that is specific to rotating media.
> Or is this referring to "SCSI-generic" pass through?

I was talking about scatter-gather.  All the IO commands are about one
continuous extent of data on the device and the whole stack from the
bio is built that way and the overhead of libata is minute compared to
the whole thing including emitting single command and receiving
completion for each 4k transfer.

> In any case, only traversing one fewer layers (SCSI or libata) in
> block code path would help serve 4k requests more efficiently.

Yes, no doubt.

>> If getting the maximum random scattered
>> access throughput is a must, the best way would be adding a SG r/w
>> commands to ATA and adapt our storage stack accordingly.
> 
> I don't think everyone wants to throw out the entire stack.
> But adding a passthrough for ATA and connecting that to FUSE might
> be a performant alternative.

Don't know how FUSE would come into play but if the device can receive
list of IOs to perform in a single command and reply accordingly, the
block layer (possibly bio interface too?) can be modified to merge
random IOs into a single request and things will be really fast and
whether we grab one more spinlock or not at the bottom of the stack
wouldn't really matter.

Thanks.

-- 
tejun
