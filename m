From: Douglas Gilbert <dgilbert@interlog.com>
Subject: lsscsi and sg3_utils betas for testing 64 bit LUNs
Date: Wed, 06 Mar 2013 10:10:24 -0500
Message-ID: <51375C60.6070608@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59164 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137Ab3CFPLW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Mar 2013 10:11:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>

To facilitate testing Linux 64 bit LUNs (the kernel holds
only 32 bit LUNs internally at the moment), I have put up
beta versions of lsscsi and the sg3_utils packages, see the
top of this page: http://sg.danny.cz/sg/

lsscsi version 0.27 (beta 1) adds a --lunhex (-x) option,
here is an example of its use:

# lsscsi -gs
[0:0:0:0]    disk    ATA      INTEL SSDSC2CW12 400i  /dev/sda   /dev/sg0
[7:0:0:1]    disk    Linux    scsi_debug       0004  /dev/sdb   /dev/sg1
[7:0:0:49409]wlun    Linux    scsi_debug       0004  -          /dev/sg2

# lsscsi -g --lunhex
[0:0:0:0x0000]              disk    ATA      INTEL SSDSC2CW12 400i  /dev/sda
[7:0:0:0x0001]              disk    Linux    scsi_debug       0004  /dev/sdb
[7:0:0:0xc101]              wlun    Linux    scsi_debug       0004  -

# lsscsi -xx
[0:0:0:0x0000000000000000]  disk    ATA      INTEL SSDSC2CW12 400i  /dev/sda
[7:0:0:0x0001000000000000]  disk    Linux    scsi_debug       0004  /dev/sdb
[7:0:0:0xc101000000000000]  wlun    Linux    scsi_debug       0004  -

Additionally if sysfs offers a 64 bit (unsigned) integer in decimal
for a LUN then this version will use it (previous lsscsi versions
would have truncated the LUN to 32 bits).


In the sg3_utils beta the sg_luns utility is expanded to better
handle T10 (SAM-5) LUNs and represent them in Linux 'word
flipped' form if requested. sg_luns has an additional
--test=LUNHEX option that can be used for decoding arbitrary
T10 LUNs, for example:
# sg_luns --test=020304aa01bb00ff
Decoded LUN:
   Peripheral device addressing: bus_id=2, target=3
   >>Second level addressing:
     Peripheral device addressing: bus_id=4, target=170
   >>Third level addressing:
     Peripheral device addressing: bus_id=1, target=187
   >>Fourth level addressing:
     Peripheral device addressing: lun=255

# sg_luns --test=020304aa01bb00ff -H
Decoded LUN:
   Peripheral device addressing: bus_id=0x02, target=0x03
   >>Second level addressing:
     Peripheral device addressing: bus_id=0x04, target=0xaa
   >>Third level addressing:
     Peripheral device addressing: bus_id=0x01, target=0xbb
   >>Fourth level addressing:
     Peripheral device addressing: lun=0xff

# sg_luns --test=020304aa01bb00ffL -H
Linux 'word flipped' integer LUN representation: 0xff01bb04aa0203
Decoded LUN:
   Peripheral device addressing: bus_id=0x02, target=0x03
   >>Second level addressing:
     Peripheral device addressing: bus_id=0x04, target=0xaa
   >>Third level addressing:
     Peripheral device addressing: bus_id=0x01, target=0xbb
   >>Fourth level addressing:
     Peripheral device addressing: lun=0xff


Now I'm hoping Hannes Reinecke will issue a new set of the
"scsi: 64-bit LUN support" patches that address the issues
that have been brought up. Then the real testing can begin.

Doug Gilbert
