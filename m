From: Douglas Gilbert <dougg@torque.net>
Subject: Re: WWN on FC LUN targets
Date: Sun, 01 Aug 2004 19:05:50 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <410CB26E.7060109@torque.net>
References: <OFD7E2C657.B39E37CA-ON88256EDF.00034E54-88256EDF.0004E839@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:58127 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S265517AbUHAJGH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Aug 2004 05:06:07 -0400
In-Reply-To: <OFD7E2C657.B39E37CA-ON88256EDF.00034E54-88256EDF.0004E839@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Rock Gordon <rockgordon@yahoo.com>, linux-scsi@vger.kernel.org

Bryan Henderson wrote:
>>I am looking at ways to find out particular WWN (world
>>wide names) for SCSI target LUNs 
> 
> 
> LUNS don't actually have fibre channel WWNs.  And neither do SCSI logical 
> units, which is probably what you meant (a LUN is a logical unit number). 
> WWNs come in two flavors - World Wide Node Name (WWNN), which identifies a 
> SCSI target, and World Wide Port Name (WWPN), which identifies a port on a 
> target.  Neither of those is what you want, since you probably have 
> multiple logical units per target.
> 
> If you're like most FC users, your LUNs aren't stable even within a 
> target, so you can't use a combination of WWNN and LUN either.
> 
> So what people use is either SCSI device serial number or SCSI device ID. 
> The latter is newer and better.  There are device IDs for targets, ports, 
> and logical units.  There are device IDs in each of various name spaces, 
> some defined by public standards.  You can read all about that in SCSI 
> specifications.  Device IDs are part of the Vital Product Data (VPD).
> 
> The basic programming interface to get that information is the SCSI 
> INQUIRY command.
> 
> People have written programs to do the INQUIRY and give you the results in 
> usable form and even create the device special files named after the 
> device IDs.  I'm afraid I can't name one at the moment, but I hope someone 
> else on the list chimes in with the specifics.
<snip>

The scsi_id program by Patrick Mansfield queries a SCSI device's
identification and serial number vital product data (VPD) pages
and produces a unique number. It is meant to be used in conjunction
with udev (a dynamic device node creation, naming and removal facility
based on the hotplug subsystem in the lk 2.6 series) to create device
(and partition) node names according to user specified rules.
Several versions can be found at this url:
    http://www-124.ibm.com/storageio/scsi_id/

The sg_inq utility in the sg3_utils package (version 1.07) has
a '-i' option that will decode all the "identification descriptors"
in the device identification VPD page (0x83) for the nominated device.
That information in conjunction with some of the explanations in
this thread may show you what identifiers, if any, are available.
The unit serial number page can be queried with
'sg_inq -o=80 /dev/sda'.
sg3_utils can be found at: http://www.torque.net/sg

SPC-3 (SCSI Primary Commands) can be found http://www.t10.org
The most recent draft is version 19 and section 7.6.4 and 7.6.11
are relevant.

Doug Gilbert
