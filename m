From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: Mon, 5 May 2003 09:57:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505165739.GD1567@beaverton.ibm.com>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl> <3EB619A4.5090407@torque.net> <1052144231.1888.10.camel@mulgrave> <20030505155210.GB1567@beaverton.ibm.com> <1052151252.1888.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:30862 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S263737AbTEEQnk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 12:43:40 -0400
Content-Disposition: inline
In-Reply-To: <1052151252.1888.15.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: dougg@torque.net, Andries.Brouwer@cwi.nl, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, Patrick Mansfield <patmans@us.ibm.com>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Mon, 2003-05-05 at 10:52, Mike Anderson wrote:
> > James Bottomley [James.Bottomley@steeleye.com] wrote:
> > Mutability should not depend on how a uuid is set. It should depend on
> > what can change it.
> 
> I think the sysfs write API is sufficient, so it has to be a rw-r-r file
> to allow root to write it on hotplug.
> 
> > Why block?
> 
> It's the largest available useful subset other than device itself.
> 
> > If you obtain a scsi_device uuid it should not be written in to a block
> > device attribute it should be attached to the struct device representing
> > the scsi device. If the attribute name is consistent "uuid" than cat
> > ".../device/uuid" will function the same.
> 
> by that argument, capacity, which is a property of the SCSI sd device
> should be stored in the SCSI device.  It isn't, since it's a global
> block device property, it's stored in the gendisk.
> 
> Unique identifiers are a property of SCSI devices, but they're not an
> exclusive property.

Yes I agree they are not exclusive to SCSI, but the same can be said of
the block argument. Block is large set, but is not the whole set of
possible uuid producing nodes. 

We could add it as a device default attribute (dev_default_attrs), but
it would produce the extra overhead like power does today for nodes that
have no uuid.

-andmike
--
Michael Anderson
andmike@us.ibm.com

