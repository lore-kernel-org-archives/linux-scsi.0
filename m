From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Large disk drives
Date: Thu, 6 Nov 2014 15:16:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1411061511450.916-100000@iolanthe.rowland.org>
References: <201411061923.sA6JNjSR007673@hobgoblin.ariadne.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34029 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751088AbaKFUQh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 15:16:37 -0500
In-Reply-To: <201411061923.sA6JNjSR007673@hobgoblin.ariadne.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dale R. Worley" <worley@alum.mit.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, hch@infradead.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Thu, 6 Nov 2014, Dale R. Worley wrote:

> There is one thing that seems like it might be a problem:  We have to
> ensure that the SCSI driver can read the partition tables (in the
> standard locations) even if it doesn't know how big the disk is.

A DOS partition table is stored in the first 512 bytes of the disk.  A
GPT partition table occupies the first 33 or so blocks.  (It also has a
copy occupying the last few blocks, but if you don't know how large the
disk is, that's not much help.)

> Which leads me to wonder what happens if one reads /dev/sdX until one
> hits end-of file.  People have written that we don't want to read the
> disk from locations beyond end-of-data because some disks react badly
> to out-of-range reads.  But if that is so in general, there would be
> problems simply copying /dev/sdX.  (Indeed, if all disks gave a proper
> error for out-of-range reads, a bisection search would find the size
> of the disk easily enough.)

Most drives will work fine if you try to read beyond the end.  You'll 
just get an appropriate error return.

But some devices (typically, cheap consumer-grade USB devices) go 
wacky.  Often enough, they crash or hang.  Some of them may get going 
again in response to a reset; others have to be powered off to recover.

Alan Stern

