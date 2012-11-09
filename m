From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB enclosures seem to require read(16) with >2TB drives
Date: Fri, 9 Nov 2012 11:22:12 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1211091113140.1702-100000@iolanthe.rowland.org>
References: <CAJiM5Sb+=VpVNsETCjS5sfkFatGVJK9p-1ejhhng5qtV6mk8kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55354 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753530Ab2KIQWN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2012 11:22:13 -0500
In-Reply-To: <CAJiM5Sb+=VpVNsETCjS5sfkFatGVJK9p-1ejhhng5qtV6mk8kw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jason J. Herne" <hernejj@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Fri, 9 Nov 2012, Jason J. Herne wrote:

> Hello, I've noticed Linux seems to have issues with external USB
> enclosures containing drives > 2 TB.   The USB mass storage driver
> apparently emulates a SCSI device and sends a read/write(10) for all

Actually, it's the SCSI disk driver which decides whether to use the 
10-byte or 16-byte commands.

> requests where the target sector is not large enough to require the
> use of read(16).  The issue is that both of the enclosures I was able
> to test with do not properly accept this read(10) command when a 3TB
> drive (Seagate ST3000DM) is installed.  A wireshark USB trace shows
> the read(10) command is sent to the drive and the drive never
> responds.  The same drive/enclosure used in Windows 7 shows that
> read(16) is always used to communicate with the drive and the drive
> works without issue with Windows 7.
> 
> A few notable points:
> 1. The drive operates without issue when connected to an internal Sata
> port on my computer.
> 2. The enclosure operates without issue with Linux (using read(10) )
> when a <2TB drive is installed.
> 3. I have reproduced this problem on several computers, and using
> several Linux kernels, including 3.7.0-rc4-next.
> 
> I first reported this to the linux-usb list thinking it was a USB
> issue.  At the request of Alan Stern I am also reporting it here.
> 
> I'm not sure if I am taking the correct approach but I have written a
> simple patch that resolves the problem for me.  In essence, the patch
> adds a new bit to scsi_device that indicates it should favor
> read/write(16) over read/write(10).  sd_prep_fn is modified to check
> this bit, and use a 16 byte operations when a large capacity drive is
> in use and this bit is on. Finally, the USB storage driver's scsi glue
> code is modified to turn this bit on for all of its devices.  Not sure
> if this is the correct fix, but it works for me.  I'm willing to

It's not correct, because it will break USB drives that don't recognize
the 16-byte commands.

The bit should be set only for disks that have 2^32 or more blocks, or
maybe only for disks that hold 2^41 or more bytes (and maybe only for
USB disks).  Since usb-storage doesn't know the disk's capacity, the
decision about whether to set the new bit has to be made in the SCSI
disk driver.

Alan Stern

