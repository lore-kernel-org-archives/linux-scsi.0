From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] SCSI device/adapter/bus address correlation?
Date: Fri, 3 Sep 2004 14:13:49 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409031413.49104.bjorn.helgaas@hp.com>
References: <200409021719.15267.bjorn.helgaas@hp.com> <200409030844.41174.bjorn.helgaas@hp.com> <20040903180942.GA28970@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel7.hp.com ([156.153.255.213]:60644 "EHLO atlrel7.hp.com")
	by vger.kernel.org with ESMTP id S269767AbUICUN5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2004 16:13:57 -0400
In-Reply-To: <20040903180942.GA28970@beaverton.ibm.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Friday 03 September 2004 12:09 pm, Patrick Mansfield wrote:
> > Thanks, I knew there must be a cool way.  That doesn't help if you're
> > trying to figure out the correct "root=" to boot your box, of course...
> 
> What exactly is the "root=" problem? You mean device names changing?

Walk up to a box with a number of data disks already attached.  Plug
in a new disk with a root filesystem on it.  Now try to boot the box,
using the new root filesystem.  What do you specify?  It's difficult
in general to figure it out.  

> Also lsscsi gives simple easy to read output. 
> ...
> [0:0:0:0]    enclosu IBM      EXP700           9319  -       
> [0:0:1:0]    disk    IBM-ESXS ST318453FC    F  B953  /dev/sda

That looks like it gives you the scsi unit, channel, id, lun,
which is already available in dmesg.  It doesn't tell you the
PCI bus address, which you might need if you have more than
one SCSI adapter.

My question has more to do with the situation where your box
doesn't boot because you don't know which sd<x> device has
your root filesystem.  If the PCI bus number gets printed
somewhere before the "can't mount root" panic, you at least
have a clue to solve the problem.

Olaf pointed out what sounds like a reasonable way do to this,
but of course that requires the hassle of an initrd.
