From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Supporting ACPI drive hotswap
Date: Sat, 24 Sep 2005 17:48:23 +0100
Message-ID: <20050924164823.GA24351@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: acpi-support@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ACPI provides a mechanism for noting which devices can be hotswapped and 
notifying the system that this has happened. Hotswappable devices are 
tagged with a _RMV token. What effectively needs to be done is this:

1) Find every device with an _RMV token, and install a notify handler 
for it. This is fairly easy.

2) On notification, check whether the device is present or absent. This 
can be done by calling the _STA method - alternatively it could 
presumably be done through the appropriate IDE or SCSI layer. I believe 
that we now have code that allows binding of ACPI devices to appropriate 
busses.

3) If a device has been added, enumerate it and do appropriate messaging
to userspace (for device node creation and so forth). This ought to be 
relatively easy?

4) If a device has been removed, we currently have problems. SATA 
hotplugging is only supported on a subset of devices. The SATA laptop I 
have here is an Intel ICH part, but uses the ata_piix driver (ahci won't 
load) which isn't supposed to support hotswap. Unregistering devices in 
the IDE layer has been broken for ages.

Is there any point in working on the first three of these points until 
point four is more reasonable? What actually needs to be done to improve 
this?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
