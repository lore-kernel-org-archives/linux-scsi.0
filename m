From: Paul Smith <paul@mad-scientist.net>
Subject: Re: [2.6.27.25] Hang in SCSI sync cache when a disk is removed--?
Date: Tue, 07 Jul 2009 10:33:52 -0400
Message-ID: <1246977232.14322.615.camel@homebase.localnet>
References: <1246551772.9022.7192.camel@psmith-ubeta.netezza.com>
	 <20090702174151.GA17414@linux.vnet.ibm.com>
	 <1246903453.9022.7246.camel@psmith-ubeta.netezza.com>
	 <20090707062543.GA2459@linux.vnet.ibm.com>
	 <1246975126.4522.5.camel@mulgrave.site>
Reply-To: paul@mad-scientist.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:48377 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbZGGOeC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2009 10:34:02 -0400
In-Reply-To: <1246975126.4522.5.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, "Moore, Eric" <Eric.Moore@lsi.com>

Hi James; thanks for that examination; it's very helpful.

Unfortunately Eric is on vacation until the middle of the month and we
really need to resolve this issue this week if possible.  I'm forwarding
your message to the LSI developers we've been working with.

MikeA: we're working on getting the sysrq "t" output in the meantime,
just in case it's revealing.

On Tue, 2009-07-07 at 08:58 -0500, James Bottomley wrote:
> On Mon, 2009-07-06 at 23:25 -0700, Mike Anderson wrote:
> > Paul Smith <paul@mad-scientist.net> wrote:
> > > 
> > 
> > I was expecting a little more output from the error handler thread, but
> > the log does show a few things.
> > 
> > It would be good if in the failing case you could provide a sysrq "t"
> > output so I could understand where the reset handler is waiting.
> > 
> > It appears there are a few things going on.
> > 1.) The dm deactivate calling blk_abort_queue is leading to error handler
> > activation. Similar to a previously described issue.
> > http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/8543
> > 	- This kernel does not have DID_TRANSPORT_DISRUPTED so that
> > 	  avoidance method cannot be used.
> > 2.) The task aborts are completing, but the tur is most likely being
> > failed with a response of DID_BUS_BUSY leading to continued recovery.
> > 3.) We appear to be inside mpt_HardResetHandler, but need more info to
> > understand where in the call chain.
> 
> Actually, isn't the problem much simpler?
> 
> The mptsas driver calls sas_port_delete() when the event occurs.  This
> deletes the rphy and invokes scsi_remove_target().  It looks like the
> device had a write back cache, so part of scsi_remove_target() goes to
> scsi_remove_device() which triggers sd_remove() which tries to flush the
> cache with SYNCHRONIZE CACHE.
> 
> This is the point at which the hang occurs.  It seems that the mptsas
> goes out to lunch when it sees a command to a device on a deleted port.
> The remainder of the log is error handling trying to get the attention
> of the mptsas firmware back again.
> 
> This is a pretty huge problem because any set of commands can be racing
> with surprise ejection ... there's no way we can gate it in the mid
> layer.  The behaviour we expect is that after surprise ejection, a
> driver/device will automatically error (with something like
> DID_NO_CONNECT) all commands for the ejected device.
> 
> James
> 
> 
