From: Markus Demleitner <msdemlei@cl.uni-heidelberg.de>
Subject: sd_sync_cache spews warnings since 2.6.1x
Date: Wed, 9 Nov 2005 12:56:55 +0100
Message-ID: <20051109115655.GA8394@victor.cl.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.uni-heidelberg.de ([129.206.210.211]:22974 "EHLO
	relay2.uni-heidelberg.de") by vger.kernel.org with ESMTP
	id S1751386AbVKIL5K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Nov 2005 06:57:10 -0500
Received: from ix.urz.uni-heidelberg.de (popix.urz.uni-heidelberg.de [129.206.119.235])
	by relay2.uni-heidelberg.de (8.12.10/8.12.10) with ESMTP id jA9Bv8M0003477
	for <linux-scsi@vger.kernel.org>; Wed, 9 Nov 2005 12:57:09 +0100 (MET)
Received: from janus.cl.uni-heidelberg.de (janus.cl.uni-heidelberg.de [147.142.207.16])
	by ix.urz.uni-heidelberg.de (8.8.8/8.8.8) with ESMTP id MAA40558758
	for <linux-scsi@vger.kernel.org>; Wed, 9 Nov 2005 12:57:02 +0100
Received: from msdemlei by janus.cl.uni-heidelberg.de with local (Exim 4.50)
	id 1EZoZa-0001Ax-34
	for linux-scsi@vger.kernel.org; Wed, 09 Nov 2005 12:57:02 +0100
Received: from msdemlei by localhost.localdomain with local (Exim 4.50)
	id 1EZoZT-0002Jb-Ts
	for linux-scsi@vger.kernel.org; Wed, 09 Nov 2005 12:56:55 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Since kernel version 2.6.1something, sd.c:sd_sync_cache spews out warnings
like

FAILED 
   status = 1, message = 00, host = 0, driver = 08 
   <6>sd: Current: sense key: Illegal Request 
     Additional sense: Invalid command operation code

for an external RAID that used to work fine for the last ~6 years.

The device reports the following:

scsiinfo -i /dev/sdc

Inquiry command
---------------
Relative Address                   0
Wide bus 32                        0
Wide bus 16                        1
Synchronous neg.                   1
Linked Commands                    0
Command Queueing                   1
SftRe                              0
Device Type                        0
Peripheral Qualifier               0
Removable?                         0
Device Type Modifier               0
ISO Version                        0
ECMA Version                       0
ANSI Version                       2
AENC                               0
TrmIOP                             1
Response Data Format               2
Vendor:                    Arena   
Product:                                   
Revision level:                P

I'm not quite sure how to get a report on the commands supported by
the device without digging into the kernel.

Now, as I read this, what fails is the request to write out any disk
internal caches, and unless power fails for the raid, I probably do
not need to worry.  Still, comparing 2.6.10's sd_sync_cache and
2.6.14's I can't really see why theses warnings should suddenly crop
up.

Other info:  The device is attached through an Adaptec AHA-2940U/UW/D
PCI controller on an ICH6 Buckner board.  There's also two SATA disks in
the machine (/dev/sda and /dev/sdb for linux), the failing device
being sdc.  Furthermore, a USB2 external drive is also present as
sdd.  None of the other devices complain.  In addition to the RAID,
there is an HP tape changer on the Adaptec's bus.

Am I right in not worrying too much?  What's the smart way of getting
rid of the warnings (short of commenting out the printks)?

Cheers,

        Markus

