From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: 05 May 2003 11:14:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052151252.1888.15.camel@mulgrave>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl>
	<3EB619A4.5090407@torque.net> <1052144231.1888.10.camel@mulgrave>
	<20030505155210.GB1567@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:39173 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262473AbTEEQCZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 12:02:25 -0400
In-Reply-To: <20030505155210.GB1567@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: dougg@torque.net, Andries.Brouwer@cwi.nl, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, Patrick Mansfield <patmans@us.ibm.com>

On Mon, 2003-05-05 at 10:52, Mike Anderson wrote:
> James Bottomley [James.Bottomley@steeleye.com] wrote:
> Mutability should not depend on how a uuid is set. It should depend on
> what can change it.

I think the sysfs write API is sufficient, so it has to be a rw-r-r file
to allow root to write it on hotplug.

> Why block?

It's the largest available useful subset other than device itself.

> They are not unique to the block layer either. uuid's are unique to the
> name space they are acquired in. Non-block storage devices can have
> uuids. They can also have uuids without block based upper level drivers
> loaded.

True.

> If you obtain a scsi_device uuid it should not be written in to a block
> device attribute it should be attached to the struct device representing
> the scsi device. If the attribute name is consistent "uuid" than cat
> ".../device/uuid" will function the same.

by that argument, capacity, which is a property of the SCSI sd device
should be stored in the SCSI device.  It isn't, since it's a global
block device property, it's stored in the gendisk.

Unique identifiers are a property of SCSI devices, but they're not an
exclusive property.

James


