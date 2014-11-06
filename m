From: worley@alum.mit.edu (Dale R. Worley)
Subject: Re: Large disk drives
Date: Thu, 6 Nov 2014 14:23:45 -0500
Message-ID: <201411061923.sA6JNjSR007673@hobgoblin.ariadne.com>
References: <1415203668.13212.2.camel@jarvis>
	 <Pine.LNX.4.44L0.1411051130470.1531-100000@iolanthe.rowland.org>
	 <20141105193045.GA13265@infradead.org> <1415269814.29907.19.camel@jarvis.quadriga.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:48196 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbaKFTXr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 14:23:47 -0500
In-reply-to: <1415269814.29907.19.camel@jarvis.quadriga.com>
	(James.Bottomley@HansenPartnership.com)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: hch@infradead.org, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> We really don't want to make the decision within the kernel of whether
> we believe the partition size or the disk capacity.   For these disk
> problems we need it to be the former, but if we choose that always,
> we'll get weird results on mispartitioned devices.
> 
> The usual rule is no policy in the kernel and which to choose is policy,
> so just export the knob (as Alan's patch does) and then let userspace
> decide.

I can see some significant advantages to setting up the hack in
user-space, above the architectural ones:

- We can get the user to confirm how big we think the disk is --
because its size is printed on the label of the disk.  And if the
partition table is unreadable in some way, the user can manually enter
the size.

- We can warn the user that the data path to his disk is deficient in
not supporting which ever SCSI request, so that he knows to upgrade
his hardware.

There is one thing that seems like it might be a problem:  We have to
ensure that the SCSI driver can read the partition tables (in the
standard locations) even if it doesn't know how big the disk is.
Which leads me to wonder what happens if one reads /dev/sdX until one
hits end-of file.  People have written that we don't want to read the
disk from locations beyond end-of-data because some disks react badly
to out-of-range reads.  But if that is so in general, there would be
problems simply copying /dev/sdX.  (Indeed, if all disks gave a proper
error for out-of-range reads, a bisection search would find the size
of the disk easily enough.)

Dale
