From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Buffer I/O error after s2ram with usb storage
Date: Wed, 27 Aug 2014 10:54:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408271051160.1460-100000@iolanthe.rowland.org>
References: <20140827104059.3a4bed94@parrot.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53150 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934469AbaH0Oyz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Aug 2014 10:54:55 -0400
In-Reply-To: <20140827104059.3a4bed94@parrot.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org

On Wed, 27 Aug 2014, Matthieu CASTET wrote:

> Ping
> 
> I have got also a problem with a usb sdcard reader (without power cut
> during suspend)

> > > The usb storage driver call scsi_report_bus_reset after device reset,
> > > but because of commit dfcf7775 <4>, we don't ignore unit attention if
> > > "sshdr.asc == 0x28 && sshdr.ascq == 0x00" ("Not-ready to ready").
> > > 
> > > If dfcf7775 is reverted there is no more Buffer I/O error.
> > > 
> > > Is that possible to find a way to restore the behavior before dfcf7775
> > > commit (no Buffer I/O error after device reset) after a suspend to ram ?

Since that commit was written to fix a problem with certain cdrom
drives, maybe we would work around the issue by modifying the commit.  
Have it go back to the original behavior if the device isn't a cdrom 
drive.

That's not a complete fix (it won't help when a CD drive is attached 
via USB), but maybe it's better than nothing.

Alan Stern

