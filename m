From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: 05 May 2003 09:17:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052144231.1888.10.camel@mulgrave>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl>
	<3EB619A4.5090407@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:59143 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262131AbTEEOFY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 10:05:24 -0400
In-Reply-To: <3EB619A4.5090407@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Andries.Brouwer@cwi.nl, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, Patrick Mansfield <patmans@us.ibm.com>

On Mon, 2003-05-05 at 02:58, Douglas Gilbert wrote:
> Andries.Brouwer@cwi.nl wrote:
> >>Remove the scsi EVPD code.
> > 
> > 
> > Good! That simplifies many things.
> 
> Good?? Just because there are millions of brain damaged
> devices that can't implement rule 0 of a protocol,
> Patrick removes one of the best features added to
> the scsi subsystem in the 2.5 development series.
> 
> Patrick's patch is now in lk 2.5.69 .
> 
> So we are back to all the fun games of opening/
> querying/closing likely looking device nodes in
> the /dev space (and I speak from experience).
> What a joy.
> 
> Surely there is a better way. Why not do the VPD=0x83
> query on devices that claim to be SCSI-3 compliant
> or better. The scsi mid level driver (and/or the
> usb-storage + sbp2 LLDs) could have a sysfs parameter
> such as "simple_scan". The filters discussion
> showed more promise than this blunt approach.
> 
> I have contemplated putting the VPD=0x83 code in
> lsscsi but it won't be pretty (e.g. requiring root
> privilege, side effects including locking up
> certain USB storage devices :-) ).

Well, this is one of those debates where you have to weigh what you get
vs the problems caused.  EVPD inquiry was causing too many problems. 
Its use was to get a unique name for the SCSI device.  It did this by
falling back through about three levels of heuristics (ending up with
the serial number).

The heuristics employed weren't complex enough to generate a unique name
for all devices, and no-one was using them anyway.  The problems they
caused seemed to be quite real.

Here's my proposal for replacing it:

1. Unique Name is a generic block property, not an exclusively SCSI
property, so we need to add a mutable property file to the *block* class
(something like uuid or unique_id---I don't care about the name).

2. It will be mutable because it may either be set in the kernel or by
root from user level.

3. For SCSI, we will have a hotplug script that will navigate the
heuristics and generate a "unique" name for the device.  How it does
this will be entirely within the province of the scripts.

4. The generated name will be written to the mutable block property
file, so SCSI WWN will operate almost entirely at the user level.

The reason I think it should be done this way is that there are two main
uses of the unique id:

1. To find devices as they move about during bus/system reconfigurations

2. To configure multi-pathing based on the unique id's being the same.

Neither of these problems is unique to SCSI, which is why I think the
block layer is more appropriate place to solve them.

James


