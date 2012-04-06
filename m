From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Fri, 6 Apr 2012 12:21:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204061213010.1392-100000@iolanthe.rowland.org>
References: <578492.36106.qm@web100003.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48890 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752439Ab2DFQVZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 12:21:25 -0400
In-Reply-To: <578492.36106.qm@web100003.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 6 Apr 2012, Norman Diamond wrote:

> When sg_dd tries to read the bad block, it fails, but the bridge does not crash.
> 
> When ordinary dd tries to read a Linux-length page of 8 blocks, the bridge crashes.
> 
> I'm pretty sure Windows is reading a cluster of 4 blocks in the file and the bridge crashes at that time.  (The partition is a little under 8MB, formatted FAT12, with clusters of 4 sectors.)

What happens if you use sg_dd to try reading four or eight blocks
including the bad block?

> Nonetheless, trying to read a nonexistent sector after the last existing sector does not crash my bridge.  sg_dd reports the error correctly.  Ordinary dd doesn't try to do the read because the sector address is 2 past where Linux thinks the drive ends (which is 1 past where the drive really ends).  Existing non-defective blocks on the drive can still be accessed.  The USB cable does not beed to be unplugged and replugged.

What happens if you use sg_dd to try reading four or eight blocks
including the first nonexistent block?

By the way, Linux's SCSI disk driver no longer does this.  It is more
cautious; accesses near the end of a USB device are broken up into
single-block reads or writes.  However at the time the quirk entry was
added, the driver wasn't so careful.  If you want to see the discussion 
that led to the quirk being added, look here:

	http://marc.info/?l=linux-usb-users&m=110219110306073&w=2

Unfortunately the critical message that had the logs attached never got 
into the mailing list archive.

> With a different bridge, a Linux driver hangs for a few minutes after trying to read the bad block.  Then it resets the bridge, the reset succeeds, and good blocks on the drive can still be accessed.  Also with that different bridge, Linux knows the real size of the drive.

The firmware on a lot of these bridges is pretty buggy.

Alan Stern

