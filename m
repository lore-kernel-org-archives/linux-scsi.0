From: "Moore, Eric Dean" <emoore@lsil.com>
Subject: Re: [PATCH 2.6 ] MPT Fusion driver 3.01.02 update
Date: Wed, 17 Mar 2004 18:38:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <001201c40c89$c4fcef20$221015ac@ericmoore>
References: <0E3FA95632D6D047BA649F95DAB60E57040DB25E@exa-atlanta.se.lsil.com> <20040318020948.2f884e89.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:21733 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262281AbUCRBkJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 20:40:09 -0500
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Alexander.Stohr@gmx.de, rddunlap@osdl.org

Andi -

The fix in 3.01.02 was your request for commenting out the
"queue is full message" which you posted to the
mailing list earlier in the last week.  This has nothing to do with
with todays issue.

Regarding todays issue.  There is a work around for your
issue which I have already suggested earlier today. That is
to modify the mpt fusion Makefile, by uncommenting out
the FIFO FIX define.  This work around will set a dma mask
for less 4GB, thus we don't hit the error condition in PrimeFifo's
when the two memory allocation are on different 4gb boundaries, and
the failure displays "-3" error code as yours did in the original dmesg.

I have provided this temp fix to HP a few weeks ago.
I plan to start work soon to solve this issue by combining these three
FIFOs into one memory allocation( the third FIFO allocation is
in mptscsih.c, that is the chain buffers).

Eric Moore




----- Original Message ----- 
From: "Andi Kleen" <ak@suse.de>
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: <linux-scsi@vger.kernel.org>; <James.Bottomley@steeleye.com>;
<Alexander.Stohr@gmx.de>; <rddunlap@osdl.org>
Sent: Wednesday, March 17, 2004 6:09 PM
Subject: Re: [PATCH 2.6 ] MPT Fusion driver 3.01.02 update


> On Wed, 17 Mar 2004 14:43:21 -0500
> "Moore, Eric Dean" <Emoore@lsil.com> wrote:
>
> > This is an update for the MPT Fusion drivers 2.6 kernel.
> > Version 3.01.02.
> >
> This doesn't seem to fix the bug I'm running into all the time:
>
> you set a 64bit consistent dma mask, but assume in PrimeIocFifos
> that two calls to pci_alloc_consistent() end in the same 4GB
> segment, which cannot work.
>
> As a workaround i just reverted it to a 4GB consistent mask for now.
>
> -Andi
>
>
>

