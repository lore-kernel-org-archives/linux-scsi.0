From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Expose shost->max_sectors via sysfs
Date: Tue, 28 Oct 2003 16:31:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031029003101.GB2029@beaverton.ibm.com>
References: <1067361445.7040.12.camel@patehci2> <Pine.LNX.4.44L0.0310281501500.6609-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:63388 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261856AbTJ2A0b
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 19:26:31 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0310281501500.6609-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Pat LaVarre <p.lavarre@ieee.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>

Alan Stern [stern@rowland.harvard.edu] wrote:
> I would like to add my voice to the complaint copied below.  Is there any
> possibility of having shost->max_sectors exposed and settable via a sysfs
> attribute file, so that data transfer sizes can be tuned by the user to
> match the capabilities of high-performance devices?
> 
> My reason for asking is that a number of USB Mass Storage devices die when
> asked to accept a transfer larger than about 128 KB.  But plenty of others
> work just fine with transfers of 1 MB or more.  It would be nice to leave
> the default limit set at the low value for interoperability but give
> people a mechanism for increasing the transfer size limit when they want.

Well we have a set of host attribute exposed today in scsi_host class.
Ideally the value would be tied to the device and not the host as these
are per queue values (e.g., max_hw_segments, max_phys_segments,
max_sectors). This would suggest that we use the host template attribute
pointers for this.

I believe this capability is what lead to the creation of the host
template shost_attrs and sdev_attrs (which you have already had
experience / cleanup issues with). IIRC while this is our current
interface James had indicated that a better infrastructure was need for
this type of attribute exposing / overriding.

-andmike
--
Michael Anderson
andmike@us.ibm.com

