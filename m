From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: qla2300 at only 1 GBit on kernel 2.6.5
Date: Wed, 5 May 2004 13:50:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD0117@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:4945 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S264806AbUEEUvB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2004 16:51:01 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jan-Frode Myklebust <janfrode@parallab.uib.no>
Cc: linux-scsi@vger.kernel.org


On Wednesday, May 05, 2004 10:47 AM, Jan-Frode Myklebust wrote:
> On Wed, May 05, 2004 at 09:27:10AM -0700, Andrew Vasquez wrote:
> > 
> > Or, as you mentioned later in the email when testing
> > the 8.x driver, did you force 2gig at the RAID box and reload the
> > 2.4 driver?
> 
> Initially I was running kernel 2.6.5  had the connection forced at
> 2Gbit from the storage device side, then I struggled for a while
> trying to understand why I didn't get link.  The qla2300 module said
> "Cable unplugged". 
> 

Ok, the firmware appears to have some problems negotiating with this
device at 2Gb.
 
> Then I set the storage device to autodetect speed, rebooted, and then
> it came up at 1 Gbit. 
> 

Negotiation problems -- ewww...  Ok, this is going to be challenging,
could I have try another driver while running 2.4.x?  Download the
following:

	ftp://ftp.qlogic.com/outgoing/linux/beta/7.x/qla2x00-v7.00.00b24-dist.tgz

tarball to /tmp.

Then perform the following steps to build the driver:

	# cd /tmp
	# mkdir 70000b24
	# cd 70000b24
	# tar xvfz ../qla2x00-v7.00.00b24-dist.tgz
	# make all
	
Unload any previously installed driver:

	# modprobe -r qla2300
	
Load the new driver:

	# insmod ./qla2300.o

Then report your results to me along with the var/log/messages file.

> > Hmm, could you go into the BIOS utility (ctrl-q during boot) and
> > check the 'Data Rate' settings for the HBA?  What is the value set
> > to -- auto/1gb/2gb?  If it is set to auto, could you set it to 2gb
> > and retry the test.
> 
> During boot it says it has no 'ROM BIOS'. Is this something I can
> install? 
> 

No, when you see the 'QLogic...." banner, just hit <ctrl-q> to start
the utility.

> BTW: here's the log I get with 2.6.6-rc3 when loading the qla2300 with
> speed=2GHz set on the infortrend:
> 
> qla2300 0000:01:05.0: Cable is unplugged...

Yep, can't negotiate with the device at 2Gb.

Regards,
Andrew Vasquez
