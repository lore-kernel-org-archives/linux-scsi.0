From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: Mon, 5 May 2003 08:52:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505155210.GB1567@beaverton.ibm.com>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl> <3EB619A4.5090407@torque.net> <1052144231.1888.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:23747 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S262349AbTEEPhl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 11:37:41 -0400
Content-Disposition: inline
In-Reply-To: <1052144231.1888.10.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: dougg@torque.net, Andries.Brouwer@cwi.nl, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, Patrick Mansfield <patmans@us.ibm.com>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> Here's my proposal for replacing it:
> 
> 1. Unique Name is a generic block property, not an exclusively SCSI
> property, so we need to add a mutable property file to the *block* class
> (something like uuid or unique_id---I don't care about the name).
> 
> 2. It will be mutable because it may either be set in the kernel or by
> root from user level.
> 
> 3. For SCSI, we will have a hotplug script that will navigate the
> heuristics and generate a "unique" name for the device.  How it does
> this will be entirely within the province of the scripts.
> 
> 4. The generated name will be written to the mutable block property
> file, so SCSI WWN will operate almost entirely at the user level.
> 
> The reason I think it should be done this way is that there are two main
> uses of the unique id:
> 
> 1. To find devices as they move about during bus/system reconfigurations
> 
> 2. To configure multi-pathing based on the unique id's being the same.
> 
> Neither of these problems is unique to SCSI, which is why I think the
> block layer is more appropriate place to solve them.

Mutability should not depend on how a uuid is set. It should depend on
what can change it.

Why block?

They are not unique to the block layer either. uuid's are unique to the
name space they are acquired in. Non-block storage devices can have
uuids. They can also have uuids without block based upper level drivers
loaded.

If you obtain a scsi_device uuid it should not be written in to a block
device attribute it should be attached to the struct device representing
the scsi device. If the attribute name is consistent "uuid" than cat
".../device/uuid" will function the same.

-andmike
--
Michael Anderson
andmike@us.ibm.com

