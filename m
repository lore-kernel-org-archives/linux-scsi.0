From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: 2.6.0-mm lost my CD-r (aic7xxx)
Date: Sun, 28 Dec 2003 19:56:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3719770000.1072666608@aslan.scsiguy.com>
References: <20031228110452.GA31088@magma.epfl.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.scsiguy.com ([63.229.232.106]:53010 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S262546AbTL2C4w
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Dec 2003 21:56:52 -0500
In-Reply-To: <20031228110452.GA31088@magma.epfl.ch>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Gregoire Favre <Gregoire.Favre@freesurf.ch>, linux-scsi@vger.kernel.org

[ Moved to linux-scsi since that is where SCSI issues belong ]

> Hello,
> 
> Yesterday I wanted to make a backup from an audio CD, and I got same error
> today:

...

> Dec 28 11:52:35 greg kernel: scsi1:0:2:0: Attempting to queue an ABORT message

...

These messages indicate that the timed-out command is still pending on
the CDROM drive.  Most likely, the drive had a problem reading a particular
audio sector on the disk and failed to report status before the 30 second
timeout in the sr driver expired.  Many of these drives will retry for a
full minute or more before giving up on a bad sector.

...

> Dec 28 11:52:40 greg kernel: aic7xxx_dev_reset returns 0x2003
> Dec 28 11:52:40 greg kernel: Recovery SCB completes
> Dec 28 11:52:50 greg kernel: scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 2 lun 0

The driver was asked to abort the command.  The CDROM drive accepted the
abort request, but failed to go bus free.  The mid-layer asked for a BDR,
but the driver was unable to deliver it (bus wasn't free to issue a new
command).  Lastly, a bus reset was ordered which cleared the bus and allowed
the timed-out command to complete.  Unfortunately, your cdrom drive was
taken offline since it failed two successive Test Unit Ready Attempts.
This is not uncommon with removable media devices since they will often
report two unit attentions back to back.  The first acknowledges the bus
reset.  The second indicates that the media may have changed (many drives
don't retain media information across bus resets).  Unfortunately, the Linux
mid-layer recovery code only tolerates one unit attention condition after a
bus reset, so your cdrom drive was incorrectly taken offline.

--
Justin

