From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: WWN on FC LUN targets
Date: Tue, 27 Jul 2004 17:54:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFD7E2C657.B39E37CA-ON88256EDF.00034E54-88256EDF.0004E839@us.ibm.com>
References: <20040727205512.24414.qmail@web41403.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:46523 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266702AbUG1AzH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2004 20:55:07 -0400
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e5.ny.us.ibm.com (8.12.10/8.12.9) with ESMTP id i6S0t2jw526990
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2004 20:55:02 -0400
Received: from d01ml604.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by northrelay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i6S0uDOK106120
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2004 20:56:13 -0400
In-Reply-To: <20040727205512.24414.qmail@web41403.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Rock Gordon <rockgordon@yahoo.com>
Cc: linux-scsi@vger.kernel.org

>I am looking at ways to find out particular WWN (world
>wide names) for SCSI target LUNs 

LUNS don't actually have fibre channel WWNs.  And neither do SCSI logical 
units, which is probably what you meant (a LUN is a logical unit number). 
WWNs come in two flavors - World Wide Node Name (WWNN), which identifies a 
SCSI target, and World Wide Port Name (WWPN), which identifies a port on a 
target.  Neither of those is what you want, since you probably have 
multiple logical units per target.

If you're like most FC users, your LUNs aren't stable even within a 
target, so you can't use a combination of WWNN and LUN either.

So what people use is either SCSI device serial number or SCSI device ID. 
The latter is newer and better.  There are device IDs for targets, ports, 
and logical units.  There are device IDs in each of various name spaces, 
some defined by public standards.  You can read all about that in SCSI 
specifications.  Device IDs are part of the Vital Product Data (VPD).

The basic programming interface to get that information is the SCSI 
INQUIRY command.

People have written programs to do the INQUIRY and give you the results in 
usable form and even create the device special files named after the 
device IDs.  I'm afraid I can't name one at the moment, but I hope someone 
else on the list chimes in with the specifics.

You could do this with devfs, but you'd be happier doing it with a user 
space program that just queries the devices at all the relevant 
major/minor number combinations and creates the /dev files you want.  And 
the same for responding to hotplug events.  In Linux 2.6, that process is 
even formalized in 'udev'.

This is, by the way, something people have been doing for years.  It's 
only starting to become standard so that everyone doesn't have to write 
his own.

>I can mount particular [logical units] from any
>server without worrying about changes in the device
>naming conventions.

Of course, naming conventions are the least of your problems.  When you 
try to use the /dev/sda etc. names, they will change every time the 
slightest thing in your system changes -- recabling, adding adapter cards, 
changing adapter card brand, creating new LUs, and on and on.  And they 
will be different on every system.

