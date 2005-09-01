From: SUPPORT <SUPPORT@4bridgeworks.com>
Subject: RE: [Bugme-new] [Bug 5003] New: Problem with symbios	driver	on	re
	cent	-mm trees
Date: Thu, 1 Sep 2005 16:24:34 +0100
Message-ID: <C18BA5DDB58DD511BD0700C0DF0DD45011C503@NTSERVER4>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.digitalinterfacesltd.com ([62.69.87.37]:28169 "EHLO
	ntserver4.4bridgeworks.com") by vger.kernel.org with ESMTP
	id S1030200AbVIAPYg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Sep 2005 11:24:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'mikellp' <mikpolniak@adelphia.net>, zML Linux SCSI <linux-scsi@vger.kernel.org>

> I tired kernel-2.6.13-rc-6-mm1 which has this patch and i still get
> the speed drop due to  Domain Validation detected failure.
> 
> I am using a LSIU160/Symbios 53c1010 Ultra3 scsi adapter and 
> it works at 
> full speed (75 MB/sec) with kernel-2.6.12. And dmesg shows:
> 
> kernel:  target0:0:0: Beginning Domain Validation
> kernel:  target0:0:0: asynchronous.
> kernel: WIDTH IS 1
> kernel:  target0:0:0: wide asynchronous.
> kernel:  target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 
> ns, offset 62)
> kernel:  target0:0:0: Ending Domain Validation
> kernel: sym1: <1010-33> rev 0x1 at pci 0000:01:07.1 irq 11
> kernel: sym1: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
> kernel: sym1: open drain IRQ line driver
> kernel: sym1: using LOAD/STORE-based firmware.
> kernel: sym1: handling phase mismatch from SCRIPTS.
> kernel: sym1: SCSI BUS has been reset.
> kernel: scsi1 : sym-2.2.0
> kernel: libata version 1.11 loaded.
> 
> With kernel-2.6.13-rc6-mm1 the speed drops back to 2.70 
> MB/sec because of
> validation failure and dmesg shows:
> 
> kernel:  target0:0:0: Beginning Domain Validation
> kernel:  target0:0:0: asynchronous.
> kernel:  target0:0:0: wide asynchronous.
> kernel:  target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT IU QAS (
> kernel: sym0: unexpected disconnect
> kernel:  target0:0:0: Write Buffer failure 700ff
> kernel:  target0:0:0: Domain Validation Disabing Information units
> kernel:  0:0:0:0: phase change 6-7 11@3fb3c3a8 resid=10.
> kernel:  target0:0:0: asynchronous.
> kernel: sym0: unexpected disconnect
> target0:0:0: Write Buffer failure 700ff
> target0:0:0: Domain Validation detected failure, dropping back
> kernel:  target0:0:0: asynchronous.
> target0:0:0: Ending Domain Validation
> kernel: sym1: <1010-33> rev 0x1 at pci 0000:01:07.1 irq 11
> kernel: sym1: Symbios NVRAM, ID 7, Fast-80, SE, parity 

I get the same thing with the a qlogic controller and a fijitsu MAS3367NP

It appears to be caused by IU and QAS if you disable the ability see
attached patch, the drive will return to full speed, the issues is due to
the initiator not expecting a disconnect (or should I say is expecting a
disconnect but gets an disconnect without a disconect message), however this
is perfectly legitimate using IU and QAS.

--- drivers/scsi/scsi_transport_spi.c	31 Aug 2005 13:03:12 -0000	1.2
+++ drivers/scsi/scsi_transport_spi.c	1 Sep 2005 14:34:13 -0000	1.3
@@ -829,11 +829,13 @@
 	DV_SET(period, spi_min_period(starget));
 	/* try QAS requests; this should be harmless to set if the
 	 * target supports it */
+#if 0
 	if (scsi_device_qas(sdev))
 		DV_SET(qas, 1);
 	/* Also try IU transfers */
 	if (scsi_device_ius(sdev))
 		DV_SET(iu, 1);
+#endif
 	if (spi_min_period(starget) < 9) {
 		/* This u320 (or u640). Ignore the coupled parameters
 		 * like DT and IU, but set the optional ones */

This should not be the finaly fix but it should get your drive back to full
speed
