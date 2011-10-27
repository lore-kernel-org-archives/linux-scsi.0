From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb-storage: fsync() take too much time when handing
 ALLOW_MEDIUM_REMOVAL
Date: Thu, 27 Oct 2011 11:58:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1110271138300.2004-100000@iolanthe.rowland.org>
References: <CAK5veoQf=Dpss8hnzbe6rufYnADmjtnuhSmqBKFDci6vupHGDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51052 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753198Ab1J0P6J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2011 11:58:09 -0400
In-Reply-To: <CAK5veoQf=Dpss8hnzbe6rufYnADmjtnuhSmqBKFDci6vupHGDg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Yuping Luo <lypingsh@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, mina86@mina86.com, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, workgroup.linux@csr.com

On Thu, 27 Oct 2011, Yuping Luo wrote:

>     Removal of  fsg_lun_fsync_sub() can pass my test, however, I found under
> linux host (specifically ubuntu 11.10) there is no SYNCHRONIZE CACHE
> coming when ejecting the mount point, only ALLOW_MEDIUM_REMOVAL().

This sounds like a bug.  James, why doesn't sd_release() send a
SYNCHRONIZE CACHE command before calling scsi_set_medium_removal(), if 
sdkp->WCE is set?  Or why doesn't scsi_set_medium_removal() send the 
SYNCHRONIZE CACHE command itself?

Don't we want to make sure the cached data has been written out before 
the medium is ejected?

Or is this supposed to be handled somewhere else, and if so, where?

Alan Stern

