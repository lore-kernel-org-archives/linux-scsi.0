From: "Jason J. Herne" <hernejj@gmail.com>
Subject: USB enclosures seem to require read(16) with >2TB drives
Date: Fri, 9 Nov 2012 11:04:07 -0500
Message-ID: <CAJiM5Sb+=VpVNsETCjS5sfkFatGVJK9p-1ejhhng5qtV6mk8kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36083 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2KIQEI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2012 11:04:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

Hello, I've noticed Linux seems to have issues with external USB
enclosures containing drives > 2 TB.   The USB mass storage driver
apparently emulates a SCSI device and sends a read/write(10) for all
requests where the target sector is not large enough to require the
use of read(16).  The issue is that both of the enclosures I was able
to test with do not properly accept this read(10) command when a 3TB
drive (Seagate ST3000DM) is installed.  A wireshark USB trace shows
the read(10) command is sent to the drive and the drive never
responds.  The same drive/enclosure used in Windows 7 shows that
read(16) is always used to communicate with the drive and the drive
works without issue with Windows 7.

A few notable points:
1. The drive operates without issue when connected to an internal Sata
port on my computer.
2. The enclosure operates without issue with Linux (using read(10) )
when a <2TB drive is installed.
3. I have reproduced this problem on several computers, and using
several Linux kernels, including 3.7.0-rc4-next.

I first reported this to the linux-usb list thinking it was a USB
issue.  At the request of Alan Stern I am also reporting it here.

I'm not sure if I am taking the correct approach but I have written a
simple patch that resolves the problem for me.  In essence, the patch
adds a new bit to scsi_device that indicates it should favor
read/write(16) over read/write(10).  sd_prep_fn is modified to check
this bit, and use a 16 byte operations when a large capacity drive is
in use and this bit is on. Finally, the USB storage driver's scsi glue
code is modified to turn this bit on for all of its devices.  Not sure
if this is the correct fix, but it works for me.  I'm willing to
revise my fix, provide testing, and collect any debug data if
requested.

The patch will follow in a separate e-mail.

Background info:

Enclosure  #1 - Vantec NexStar CX USB 3.0/2.0
idVendor           0x174c ASMedia Technology Inc.
idProduct          0x55aa
bcdDevice        1.00
iManufacturer    2 ASMedia
iProduct            3 AS2105

Enclosure #2 - Rosewill
idVendor           0x152d JMicron Technology Corp. / JMicron USA
Technology Corp.
idProduct          0x2338 JM20337 Hi-Speed USB to SATA & PATA Combo Bridge
bcdDevice          1.00

Relevant posts to linux-usb:
http://thread.gmane.org/gmane.linux.usb.general/74275
http://thread.gmane.org/gmane.linux.usb.general/74364
