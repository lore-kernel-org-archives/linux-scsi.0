From: dann frazier <dannf@hp.com>
Subject: mptsas, msi and the dl585 g2
Date: Tue, 30 Jun 2009 12:03:00 -0600
Message-ID: <20090630180300.GA9971@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:28056 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbZF3SDD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2009 14:03:03 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: yinghai@kernel.org, kadesai@lsi.com

hey,
 I'm finding problems when booting a dl585g2 w/ an LSISAS1068
controller. In brief, this system system stopped booting once MSI
became disabled by default in mptbase. Passing the parameter
'mpt_msi_enable_sas=1' to mptbase allows it to work again (tested w/
2.6.30).

 The symptom is that the system starts up, and we see the following:

======== SNIP =========
[    6.941489] hub 3-2:1.0: USB hub found
[    6.943705] hub 3-2:1.0: 7 ports detected
[    6.992639] Copyright (c) 1999-2008 LSI Corporation
[    7.014262] Fusion MPT SAS Host driver 3.04.07
[    7.021685] mptsas 0000:42:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
[    7.026597] usb 1-6.3: new full speed USB device using ehci_hcd and address 3
[    7.071143] mptbase: ioc0: Initiating bringup
[    7.102198] usb 1-6.3: New USB device found, idVendor=0e34, idProduct=0204
[    7.119107] usb 1-6.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.128171] usb 1-6.3: Product: iPort/USB I2C Host Adapter
[    7.160994] usb 1-6.3: Manufacturer: Silicon Labs
[    7.171468] usb 1-6.3: SerialNumber: 0001248
[    7.174931] usb 1-6.3: configuration #1 chosen from 1 choice
[    7.360010] ioc0: LSISAS1068 B0: Capabilities={Initiator}
[   40.581020] mptbase: ioc0: Initiating recovery
[   71.190560] Clocksource tsc unstable (delta = 4398041105588 ns)
[   81.190160] mptbase: ioc0: Initiating recovery
======== SNIP =========

These "Initiating recovery" messages are printed periodically, and the
system never recovers.

I bisected it down to this change which went into 2.6.29-rc1:

commit e382968ba618e016ff7922dff9a6140c2f9108c8
Author: Kashyap, Desai <kashyap.desai@lsi.com>
Date:   Thu Jan 8 14:27:16 2009 +0530

    [SCSI] mpt fusion: Add separate msi enable disable for FC,SPI,SAS
    
    Added support for MSI enable/disable for different buses FC,SPI,SAS
    instead of having single MSI enable/disable feature.
    
    Signed-off-by: Kashyap Desai <kadesai@lsi.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

However, this change wasn't as innocuous as the description suggests.
The intention there was not to turn off MSI on SAS - but it did due to
a typo (it misunderstands the 3rd param to module_param, which is not
the default value).

To fix this, there were two proposed changes:
  http://lkml.org/lkml/2009/2/18/259

One was to fix the typo, leaving msi enabled by default - the other
was to force MSI off. We went with leaving it off:

commit 5ce7868e159a3ee4ddf95f8522643991fea97cf2
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Wed Feb 18 11:25:32 2009 -0800

    [SCSI] mpt: fix disable lsi sas to use msi as default
    
    Impact: fix bug
    
    the third param in module_param(,,) is perm instead of default value.
    we still need to assign default at first.  Also, the default is now
    zero not one, so fix the parameter text to reflect that.
    
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Acked-by: Kashyap Desai <kadesai@lsi.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

There was also some related discussion about adding a quirk for the
8132 Bridge (which is the bridge in the 585 G2):
  http://lkml.indiana.edu/hypermail/linux/kernel/0902.2/01050.html
This change went in - I don't really understand the relevance since
our problem looks like its because we aren't even trying to use
MSI. But, I thought I'd point it out just in case.

-- 
dann frazier
