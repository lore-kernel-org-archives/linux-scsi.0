From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Sun, 26 Nov 2006 01:02:20 +0900
Message-ID: <200611251602.kAPG2LqW023026@r-dd.iij4u.or.jp>
References: <454FAD72.6040103@torque.net>
	<20061108094705M.fujita.tomonori@lab.ntt.co.jp>
	<45637876.2050206@torque.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo00.iij4u.or.jp ([210.130.0.19]:15576 "EHLO mo00.iij4u.or.jp")
	by vger.kernel.org with ESMTP id S1757933AbWKYQC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Nov 2006 11:02:28 -0500
In-Reply-To: <45637876.2050206@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

From: Douglas Gilbert <dougg@torque.net>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Tue, 21 Nov 2006 17:06:46 -0500

> FUJITA Tomonori wrote:
> > From: Douglas Gilbert <dougg@torque.net>
> > Subject: RFC: SCSI Generic version 4 interface
> > Date: Mon, 06 Nov 2006 16:47:30 -0500
> > 
> >>                 SCSI Generic version 4 interface structure
> >>                 ==========================================
> >>                                              Version 1.1
> >>
> >> Goals:
> > 
> > (snip)
> > 
> >>   - same structure can be used for a synchronous (e.g. interruptible
> >>     ioctl) or asynchronous (e.g. ioctl()/read() ) pass through.
> > 
> > Can you provide details on "asynchronous" part?
> 
> I was trying to keep away from the implementation details
> but various people have pushed for more details ...
> 
> 
> Well as you are aware, the sg driver uses a write(),
> poll_or_signal,read() sequence to do asynchronous IO
> in version 3 (and roughly the same model in version 2).
> 
> That write() has always made me uneasy and it is accident
> prone.

I think write and read interface works nicely (though it's accident
prone as you said). They enable user-space applications to easily send
and receive sg_io_v4 structures asynchronously in batches (v3 can't in
batches). As you know, the current bsg adopts this interface.

Another possible interface that I prefer is to send and receive
sg_io_v4 structures via two ring buffers.


> > The scsi target code needs sg for:
> > 
> > - SAN gateway (like iSCSI to FC)
> 
> on the initiator side, I assume.

Just to be sure we're talking about the same thing;

I've been building a linux box forwarding SCSI commands from iSCSI
initiators to FC disk (an iSCSI-FC router).

Tgt's iSCSI driver runs in user space, so needs user-space APIs to
send SCSI commands (with attribute and tag) and TMFs to SCSI
devices. Now the iSCSI driver can forward only SCSI commands by using
bsg. It needs sg v4.

Some other tgt drivers run in kernel space so we might try to add some
tgt's kernel APIs for this later on.
