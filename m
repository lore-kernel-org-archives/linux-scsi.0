From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Expose shost->max_sectors via sysfs
Date: Wed, 29 Oct 2003 10:04:14 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310290951110.874-100000@ida.rowland.org>
References: <20031029003101.GB2029@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3332 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261648AbTJ2PEO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 10:04:14 -0500
In-Reply-To: <20031029003101.GB2029@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>, Pat LaVarre <p.lavarre@ieee.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>

On Tue, 28 Oct 2003, Mike Anderson wrote:

> Alan Stern [stern@rowland.harvard.edu] wrote:
> > I would like to add my voice to the complaint copied below.  Is there any
> > possibility of having shost->max_sectors exposed and settable via a sysfs
> > attribute file, so that data transfer sizes can be tuned by the user to
> > match the capabilities of high-performance devices?
> > 
> > My reason for asking is that a number of USB Mass Storage devices die when
> > asked to accept a transfer larger than about 128 KB.  But plenty of others
> > work just fine with transfers of 1 MB or more.  It would be nice to leave
> > the default limit set at the low value for interoperability but give
> > people a mechanism for increasing the transfer size limit when they want.
> 
> Well we have a set of host attribute exposed today in scsi_host class.
> Ideally the value would be tied to the device and not the host as these
> are per queue values (e.g., max_hw_segments, max_phys_segments,
> max_sectors). This would suggest that we use the host template attribute
> pointers for this.
> 
> I believe this capability is what lead to the creation of the host
> template shost_attrs and sdev_attrs (which you have already had
> experience / cleanup issues with). IIRC while this is our current
> interface James had indicated that a better infrastructure was need for
> this type of attribute exposing / overriding.
> 
> -andmike

I have no objection to making max_sectors a device attribute.  The reason 
I asked about making a host attribute is because the scsi_host structure 
includes a max_sectors member but the scsi_device structure doesn't, so it 
seemed to make more sense that way.

While we could make max_sectors (also max_hw_segments and
max_phys_segments) a USB host-specific attribute, it is applicable to any
SCSI device so it ought to be centralized and available for all.  
However, if the feeling is that it should not be generally exposed, then
I'll implement it just for USB devices.

Alan Stern

