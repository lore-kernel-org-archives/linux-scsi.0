From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: Blacklist entry for HP dat changer
Date: Tue, 16 May 2006 06:38:29 +0200
Message-ID: <20060516043829.GA13482@alpha.franken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:64741 "EHLO elvis.franken.de")
	by vger.kernel.org with ESMTP id S1751286AbWEPEtP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 00:49:15 -0400
Received: from uucp (helo=solo.franken.de)
	by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
	id 1FfrUg-0000IY-03
	for linux-scsi@vger.kernel.org; Tue, 16 May 2006 06:49:14 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

after upgrading our SUN E250 from 2.4 to 2.6 I'm seeing following error
when the HP DDS4 DAT changer gets probed:

scsi: host 1 channel 0 id 5 lun16777216 has a LUN larger than allowed by
the host adapter

The device is connected to a symbios 875 host. I've talked to Willy
about the problem, and he asked me to try to blacklist the device
for reportlun. I did that with the patch below and it solved the
problem. It now gets properly detected:

 target1:0:5: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
  Vendor: HP        Model: C5713A            Rev: H307
  Type:   Sequential-Access                  ANSI SCSI revision: 03
 target1:0:5: Beginning Domain Validation
 target1:0:5: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 16)
 target1:0:5: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 16)
 target1:0:5: Domain Validation skipping write tests
 target1:0:5: Ending Domain Validation
  Vendor: HP        Model: C5713A            Rev: H307
  Type:   Medium Changer                     ANSI SCSI revision: 03

Looking at the misdetected LUN number I'm still thinking there might
be an endianess problem (16777216 = 0x01000000 -> little endian 0x01).
Is this possible ?

Thomas.


--- linux-2.6.15.6/drivers/scsi/scsi_devinfo.c.orig	2006-05-15 21:44:59.000000000 +0200
+++ linux-2.6.15.6/drivers/scsi/scsi_devinfo.c	2006-03-16 18:41:59.000000000 +0100
@@ -160,6 +160,7 @@
 	{"HP", "HSV100", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
 	{"HP", "C3323-300", "4269", BLIST_NOTQ},
+	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},


Signed-Off: tsbogend@alpha.franken.de

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
