From: "David Peterson \(Eng\)" <david_peterson@cnt.com>
Subject: RE: WWN on FC LUN targets
Date: Wed, 28 Jul 2004 09:22:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <82C736F456CA3E4EA3D0DC6CC31AA5CB011B05D3@esply09.cnt.ad.cnt.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gatehider.cnt.com ([139.93.128.13]:5037 "EHLO esply07.cnt.com")
	by vger.kernel.org with ESMTP id S267168AbUG1OWj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2004 10:22:39 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>, Rock Gordon <rockgordon@yahoo.com>
Cc: linux-scsi@vger.kernel.org

If supported by the device, use the Device Identification VPD page
(0x83) to identify the Logical Unit. See SPC-3.
The preferred identifier type is NAA (which is a Worldwide_Name). Annex
D in FCP-2/FCP-3 may also be of assistance to you.

...Dave 

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Bryan Henderson
Sent: Tuesday, July 27, 2004 7:54 PM
To: Rock Gordon
Cc: linux-scsi@vger.kernel.org
Subject: Re: WWN on FC LUN targets

>I am looking at ways to find out particular WWN (world wide names) for 
>SCSI target LUNs

LUNS don't actually have fibre channel WWNs.  And neither do SCSI
logical units, which is probably what you meant (a LUN is a logical unit
number). 
WWNs come in two flavors - World Wide Node Name (WWNN), which identifies
a SCSI target, and World Wide Port Name (WWPN), which identifies a port
on a target.  Neither of those is what you want, since you probably have
multiple logical units per target.

If you're like most FC users, your LUNs aren't stable even within a
target, so you can't use a combination of WWNN and LUN either.

So what people use is either SCSI device serial number or SCSI device
ID. 
The latter is newer and better.  There are device IDs for targets,
ports, and logical units.  There are device IDs in each of various name
spaces, some defined by public standards.  You can read all about that
in SCSI specifications.  Device IDs are part of the Vital Product Data
(VPD).

The basic programming interface to get that information is the SCSI
INQUIRY command.

People have written programs to do the INQUIRY and give you the results
in usable form and even create the device special files named after the
device IDs.  I'm afraid I can't name one at the moment, but I hope
someone else on the list chimes in with the specifics.

You could do this with devfs, but you'd be happier doing it with a user
space program that just queries the devices at all the relevant
major/minor number combinations and creates the /dev files you want.
And the same for responding to hotplug events.  In Linux 2.6, that
process is even formalized in 'udev'.

This is, by the way, something people have been doing for years.  It's
only starting to become standard so that everyone doesn't have to write
his own.

>I can mount particular [logical units] from any server without worrying

>about changes in the device naming conventions.

Of course, naming conventions are the least of your problems.  When you
try to use the /dev/sda etc. names, they will change every time the
slightest thing in your system changes -- recabling, adding adapter
cards, changing adapter card brand, creating new LUs, and on and on.
And they will be different on every system.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
