From: Liran Schour <LIRANS@il.ibm.com>
Subject: Re: SCSI commands order when using scsi_do_req
Date: Mon, 6 Jun 2005 11:32:45 +0300
Message-ID: <OFDF05D602.08E5F1FA-ONC2257018.002E3CA5-C2257018.002EF1DD@il.ibm.com>
References: <429F9E38.4070700@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:58871 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S261220AbVFFIg4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2005 04:36:56 -0400
In-Reply-To: <429F9E38.4070700@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org






linux-scsi-owner@vger.kernel.org wrote on 03/06/2005 03:03:04:

> James Bottomley wrote:
> > On Thu, 2005-06-02 at 20:31 +0300, Liran Schour wrote:
> >
> >>I am developing a new SCSI upper layer driver. (Object based SCSI
device)
> >>I noticed that scsi_do_req execute commands in LIFO order (add new
commands
> >>to the head of the Q).
> >>This behavior can cause a starvation of commands (or at least long
delays).
> >>What is the proper solution to this?
> >
> >
> > Well, to use the proper interfaces.
> >
> > scsi_do_req is deprecated, so don't use it.  scsi_wait_req is its
> > replacement.
>
> James,
> scsi_wait_req() doesn't look like a replacement of
> scsi_do_req() to me. The "wait" call is synchronous
> while scsi_do_req() is asynchronous with a done()
> callback.
>
>   Note: they're only really intended to allow ULDs to
> > execute commands that are necessary for controlling the device (that's
> > why they go at the head of the queue).
>
> The "char" ULDs use scsi_do_req() exclusively for
> SCSI command injection. The sg driver could be sharing
> the device with sd driver, but then again it could
> be talking to a SES target. The block layer SG_IO ioctl
> is the only use in "mixed" mode (e.g. smartmontools
> usage). However the block layer SG_IO is not being
> used in "mixed" mode when a CD/DVD is being burnt.
> IMO the mid level should not arbitrarily adopt LIFO
> order.
>
>    Block commands are executed in
> > order using ULD init_command() (or REQ_BLOCK_PC).
>
> OSDs break the UNIX block paradigm. Perhaps
> it's time to start thinking about how to properly
> support them.
>
> Doug Gilbert

In order to run our OSD SCSI initiator on top of the Linux SCSI layer
we have needed to do the following changes to the SCSI code:
1. Redefine MAX_COMMAND_SIZE to 256 byte.
2. Define a new scatter gather structures that includes two virtual buffers
   on for data out and one for data in. (implementing bidirectional
commands)
   The SCSI middle layer doesn't now this new structure (only ULD and LLD).
3. The problem above - define a new scsi_do_req that inserts our commands
to
   the tail of the Q.

We intend to release our code as an open source project soon.

- Liran

