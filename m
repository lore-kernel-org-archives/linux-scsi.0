From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils-1.06 released
Date: Wed, 05 May 2004 22:08:53 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4098D955.5070808@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:14340 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264527AbUEEMJD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2004 08:09:03 -0400
Received: from torque.net (d-236-115.stlucia.uq.net.au [203.101.236.115])
	by bunyip.cc.uq.edu.au (8.12.10/8.12.10) with ESMTP id i45C8YL6001858
	for <linux-scsi@vger.kernel.org>; Wed, 5 May 2004 22:08:45 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Tarball and rpms can be found on http://www.torque.net/sg .
Summary of sg3_utils, sg_utils and other packages are on
this page: http://www.torque.net/sg/u_index.html
A release announcement will be sent to freshmeat.net
shortly.

This version takes advantage of the wider coverage of the SG_IO
ioctl in the lk 2.6 series. As well as being applied to sg device
names (e.g. /dev/sg3) all of these utilities can take block
device names (e.g. /dev/sda and /dev/hdc [if hdc is an ATAPI
device]). Recent version of lk 2.6 also support SG_IO on st
device names (with osst device names soon to follow).
They will not work on ATA disks (e.g. /dev/hda) except with
the sg_scan ** utility.


Changelog for sg3_utils-1.06 [20040426]
   - sg_logs: some HBAs don't like odd transfer lengths so increment
       - do INQUIRY and output product strings
       - add ASCII rendering of the Protocol specific SAS page
       - add '-v' verbose option to output cdb
   - sg_scan: optionally take device file names (e.g. /dev/hdc
         and /dev/sda)
       - only request 36 byte INQUIRY responses
   - sg_err: add sg_decode_sense() function
   - sg_inq: update output (ref: SPC-3 t10/1416-d rev 17, 28
         January 2004)
       - remove '-p' option to print out PCI address of host
       - add '-v' verbose option to output cdb
   - sginfo: allow '-u' to take hex arguments (prefixed by '0x'),
             when subpage value is 255 show multiple subpages
       - accept /dev/hd? ATAPI devices directly in lk 2.6
       - add '-t <pn>[,<spn>]' argument; like '-u' but decodes
         page if it recognizes it
       - drop '-L' argument
       - add cd/dvd, tape, SES, more disk and more SPC-3 decoded
         mode pages
       - add transport protocol decoded mode pages for SPI-4, FCP
         and SAS
   - sg_modes: print all subpages when '-subp=ff' is selected
       - do INQUIRY and output product strings
       - add '-v' verbose option to output cdb
   - Makefile: add -W compile flag and fix exposed warnings
   - .spec file: change to build on Mandrake without errors


** sg_scan first assumes a /dev/hd* device name is an ATAPI device
    and (if requested with '-i') sends a SCSI INQUIRY. If that fails
    it sends a ATA IDENTITY command. For example:

# sg_scan -i /dev/hd[a-d]
/dev/hda: ATA device
     IC25N040ATCS05-0   CLP429F4JJB7DA   CS4OA61A
/dev/hdc: scsi0 channel=0 id=0 lun=0 [em]
     HITACHI   DVD-ROM GD-S200   0034 [rmb=1 cmdq=0 pqual=0 pdev=0x5]


Doug Gilbert

