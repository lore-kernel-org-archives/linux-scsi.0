From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Tue, 6 May 2003 10:23:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030506172312.GA1697@beaverton.ibm.com>
References: <20030505083315.GB8416@beaverton.ibm.com> <1052238508.1819.42.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:17855 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263997AbTEFRIY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 May 2003 13:08:24 -0400
Content-Disposition: inline
In-Reply-To: <1052238508.1819.42.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> On Mon, 2003-05-05 at 03:33, Mike Anderson wrote:
> > Example tree:
> > 
> > # tree /sys/class/scsi_host
> > /sys/class/scsi_host
> > |-- host0
> > |   |-- cmd_per_lun
> > |   |-- device -> ../../../devices/pci0/00:09.0/host0
> > |   |-- host_busy
> > |   |-- sg_tablesize
> > |   |-- unchecked_isa_dma
> > |   `-- unique_id
> 
> Could you elaborate a bit more on why the host properties are under the
> class tree, but the scsi_device properties are under the device tree.
> 
> I think this could be my misunderstanding of the class concept:  I
> thought it was going to be a unifying abstraction, e.g. a class for all
> tape devices (be they SCSI, ide or the oddball qic ones) that would
> export a unifying interface that all tapes could use.  Therefore, you
> have a device with a set of intrinsic properties exposed in the device
> tree plus a set of classes whose interfaces it chooses to export.
> 
> I could see us adding a scsi_device class and moving all the device
> properties under there too, I suppose.
> 
> What I think I'm looking for is clarification of what is a "class
> property" vs what is a "device property"
> 

Patrick can probably give a better clarification, but from the a past
driver model document:
"A device class describes a function that a device performs, regardless
of the bus on which a particular device resides"

The old class support was tied to drivers and devices where added to
a class when a driver bound to a device. This would as limited creating
a class scsi_device as the attributes would have existed without a upper
level driver binding to it.

A Scsi_Host seems to meet the previous description. The class container
also reduces the effort in locating Scsi_Host attributes which could be
located anywhere in the bus / legacy tree.

One could create a scsi_device class though it is already unified by the
constraint the only one type of "object" can exist on a "bus/devices"
list. It does make the lookup of attributes asymmetric and a class
"scsi_device" could be created to add uniformity.

Other classes to consider:
	(scsi_tape or tape), (scsi_disk or disk), (scsi_gen).
I believe Greg KH mentioned something to me about why we would select
scsi_tape over tape, but I have forgot the reason.

-andmike
--
Michael Anderson
andmike@us.ibm.com

