From: Andries Brouwer <Andries.Brouwer@cwi.nl>
Subject: Re: [usb-storage] Re: Handling erroneous READ CAPACITY response in sd.c
Date: Fri, 5 Nov 2004 19:44:02 +0100
Message-ID: <20041105184402.GB10912@apps.cwi.nl>
References: <41765CD1.8060108@adaptec.com> <Pine.LNX.4.44L0.0411051059540.834-100000@ida.rowland.org> <20041105180611.GA23104@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:16620 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S261155AbUKESoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2004 13:44:12 -0500
Content-Disposition: inline
In-Reply-To: <20041105180611.GA23104@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>


> On the other hand, the adjustment of the READ CAPACITY value should still 
> be moved to sd.c from usb-storage.  This can be implemented easily enough 
> by adding a bitflag to the scsi_device structure; the flag could be set 
> either by a SCSI blist entry or by usb-storage in its slave_configure 
> routine.  The flag would tell sd_read_capacity to decrement the number of 
> sectors it receives from the device.

I have not been following the discussion but happen to see this
fragment. Probably the below is irrelevant.

We used to have entries in unusual_devices - the above sounds
as if it is proposed to move such entries to a SCSI blist.
I don't see why that is progress.

Concerning the size of a disk: if one claims that the disk is one
sector shorter than it really is, in most cases no great harm is done.
However, certain partition tables and RAID configuration info
lives on the last sector or the last cylinder of a disk.
Even worse, sometimes this information is read or written by
the hardware.
Thus, there exist situations where it is really bad when
the last sector of a disk disappears from sight.

Andries
