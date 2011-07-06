From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Wed, 6 Jul 2011 10:20:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107061013440.1995-100000@iolanthe.rowland.org>
References: <CAL1RGDXFER5v08=Wy4Pv7CX0s1RqAThJmEy_0rpDfFCP9xjTJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39379 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752581Ab1GFOUP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2011 10:20:15 -0400
In-Reply-To: <CAL1RGDXFER5v08=Wy4Pv7CX0s1RqAThJmEy_0rpDfFCP9xjTJA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Wed, 6 Jul 2011, Roland Dreier wrote:

> Alan Stern's patch looks a bit fishy -- the scsi_free_queue() is moved
> earlier than the
> 
> 	/* cause the request function to reject all I/O requests */
> 	sdev->request_queue->queuedata = NULL;
> 
> which seems to leave a small window where the use-after-free can
> happen, and it's not clear to me why the scsi_free_queue() has to move
> at all.

Looks can be deceiving.  Although the scsi_free_queue() is higher up in
the source file, it actually runs later than this code.  That's because
__scsi_remove_device() -- this code -- gets called when the device is
unregistered from the driver core, whereas
scsi_device_dev_release_usercontext() -- where the scsi_free_queue() is
moved to -- gets called when the last reference to the device is
dropped.

Now, one of the things I'm not sure about (it would nice if James would
pick up this thread again and comment) is whether queuedata should be
set to NULL at unregistration time or later on, when the device and the
queue are about to be freed.

Alan Stern

