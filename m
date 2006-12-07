From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Thu, 07 Dec 2006 17:01:54 +0900
Message-ID: <20061207170154G.fujita.tomonori@lab.ntt.co.jp>
References: <20061108094705M.fujita.tomonori@lab.ntt.co.jp>
	<45637876.2050206@torque.net>
	<200611251602.kAPG2LqW023026@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:43970 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031818AbWLGIBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2006 03:01:47 -0500
In-Reply-To: <200611251602.kAPG2LqW023026@r-dd.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Sun, 26 Nov 2006 01:02:20 +0900

> From: Douglas Gilbert <dougg@torque.net>
> Subject: Re: RFC: SCSI Generic version 4 interface
> Date: Tue, 21 Nov 2006 17:06:46 -0500
> 
> > FUJITA Tomonori wrote:
> > > From: Douglas Gilbert <dougg@torque.net>
> > > Subject: RFC: SCSI Generic version 4 interface
> > > Date: Mon, 06 Nov 2006 16:47:30 -0500
> > > 
> > >>                 SCSI Generic version 4 interface structure
> > >>                 ==========================================
> > >>                                              Version 1.1
> > >>
> > >> Goals:
> > > 
> > > (snip)
> > > 
> > >>   - same structure can be used for a synchronous (e.g. interruptible
> > >>     ioctl) or asynchronous (e.g. ioctl()/read() ) pass through.
> > > 
> > > Can you provide details on "asynchronous" part?
> > 
> > I was trying to keep away from the implementation details
> > but various people have pushed for more details ...
> > 
> > 
> > Well as you are aware, the sg driver uses a write(),
> > poll_or_signal,read() sequence to do asynchronous IO
> > in version 3 (and roughly the same model in version 2).
> > 
> > That write() has always made me uneasy and it is accident
> > prone.
> 
> I think write and read interface works nicely (though it's accident
> prone as you said). They enable user-space applications to easily send
> and receive sg_io_v4 structures asynchronously in batches (v3 can't in
> batches). As you know, the current bsg adopts this interface.
> 
> Another possible interface that I prefer is to send and receive
> sg_io_v4 structures via two ring buffers.

One problem about using non ioctl interfaces (read/write, ring buffer,
whatever) is iovec compat issue. If sg4 still supports iovec for data
transfer, it needs compat stuff (like sg_build_iovec). And non ioctl
interfaces with iovec need to do more nasty compat stuff (like
drivrs/input/evdev.c does).

So I think that it's great for sg v4 not to support the old
data-transfer interfaces (iovec, dio, and indirect io).
