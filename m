From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: FIXED: Bogus st failures from qla1280 timeouts
Date: Wed, 10 May 2006 13:44:27 -0400
Message-ID: <F3598542BAC24B4783B7A440D45522FF04050577@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ahmler1.mail.eds.com ([192.85.154.71]:36780 "EHLO
	ahmler1.mail.eds.com") by vger.kernel.org with ESMTP
	id S932307AbWEJRpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2006 13:45:19 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jes.Sorensen@cern.ch, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Bailey, Scott" <scott.bailey@eds.com>

Absent more informed guidance, I went nuts and increased the timeout
settings in qla1280.c from 30 seconds to 15 minutes. My tape drive works
great now. The attached Debian bug report (bug 366730) summarizes the
situation. I don't know if this is something suitable for inclusion to
the kernel "as-is" or if I am overlooking some horrible side-effect that
will bite me down the road.

Any feedback?

	Scott

-----Original Message-----
From: R. Scott Bailey [mailto:scott.bailey@eds.com] 
Sent: Wednesday, May 10, 2006 1:26 PM
To: Debian Bug Tracking System
Subject: linux-source-2.6.16: bogus scsi timeouts with qla1280 driver

Package: linux-source-2.6.16
Version: 2.6.16-12
Severity: normal
Tags: patch


I have been aggravated by tape problems since upgrading to 2.6 on my 
Alphaserver using the qla1280 driver with ISP1020/1040 support enabled. 
It appears on inspection that the problem lies with the qla1280 driver 
itself, which enforces a 30-second timeout on all (?) SCSI operations it

issues. The result is that operations on my TZ89 DLT4 tape drive which 
take longer than that to complete (for example, "mt eod" or "mt fsf" in 
particular) abort and force a device reset.

The attached kludgy patch demonstrates the fix I am using, namely to 
increase the timeout to 900 seconds. This is fine because my hardware is

all solid and I'm not worried at the moment about a disk going bad and 
hanging my system for 15 minutes while the I/O times out... :-)

Probably the timeout could be reduced to perhaps 5 minutes, but I am 
erring on the side of longer since these errant "errors" really screw up

my backups and restores.

I have posted to linux-scsi on this but haven't gotten much of a 
response. I'll report this there too but figured it would be better to 
have more eyes on the problem.

Thanks,

  Scott Bailey
  scott.bailey@eds.com

--- drivers/scsi/qla1280.c	2006-03-20 00:53:29.000000000 -0500
+++ drivers/scsi/qla1280.c	2006-05-10 10:02:39.000000000 -0400
@@ -17,9 +17,11 @@
 * General Public License for more details.
 *
 
************************************************************************
******/
-#define QLA1280_VERSION      "3.26"
+#define QLA1280_VERSION      "3.26.rsb"
 
/***********************************************************************
******
     Revision History:
+    Rev  3.26.rsb, May 10, 2006 R. Scott Bailey
+	- Increase timeouts (?) from 30 to 900 sec for tape support
     Rev  3.26, January 16, 2006 Jes Sorensen
 	- Ditch all < 2.6 support
     Rev  3.25.1, February 10, 2005 Christoph Hellwig
@@ -2886,7 +2888,7 @@
 	memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));
 
 	/* Set ISP command timeout. */
-	pkt->timeout = cpu_to_le16(30);
+	pkt->timeout = cpu_to_le16(900); /* was 30 - RSB */
 
 	/* Set device target ID and LUN */
 	pkt->lun = SCSI_LUN_32(cmd);
@@ -3185,7 +3187,7 @@
 	memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));
 
 	/* Set ISP command timeout. */
-	pkt->timeout = cpu_to_le16(30);
+	pkt->timeout = cpu_to_le16(900); /* was 30 - RSB */
 
 	/* Set device target ID and LUN */
 	pkt->lun = SCSI_LUN_32(cmd);



-- System Information:
Debian Release: testing/unstable
Architecture: alpha
Shell:  /bin/sh linked to /bin/bash
Kernel: Linux 2.6.16-scsi.12
Locale: LANG=C, LC_CTYPE=C (charmap=ANSI_X3.4-1968)

Versions of packages linux-source-2.6.16 depends on:
ii  binutils             2.16.1cvs20060413-1 The GNU assembler, linker
and bina
ii  bzip2                1.0.3-2             high-quality block-sorting
file co

Versions of packages linux-source-2.6.16 recommends:
ii  gcc                           4:4.0.2-2  The GNU C compiler
ii  libc6.1-dev [libc6-dev]       2.3.6-7    GNU C Library: Development
Librari
ii  make                          3.81-1     The GNU version of the
"make" util

-- no debconf information
