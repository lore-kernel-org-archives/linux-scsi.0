From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] mpt2sas: Adding enclosure/slot sorting logic
Date: Sun, 05 Sep 2010 13:36:29 -0300
Message-ID: <1283704589.15944.1273.camel@mulgrave.site>
References: <20100804083531.GC13442@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40508 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952Ab0IEQge (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2010 12:36:34 -0400
In-Reply-To: <20100804083531.GC13442@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Wed, 2010-08-04 at 14:05 +0530, Kashyap, Desai wrote:
> Adding sorting support to driver so that during driver load time it will
> sort devices using enclosure/slot mapping algorithm prior to reporting
> devices to OS.  This is only done when ioc page 8 says to sort
> enclosure/slot mode.  The driver will handle sorting by enclosure handle
> and slot when available. If that is not available, then it will sort by
> parent device handle and phy number. For persistent device mapping mode
> the driver will not sort.
> 
> This patch is for sorting devices. The customer desire is for devices to be
> reported to OS to be consistent manner across reboots and across multiple
> systems with similar topology. Current design in the driver is to report
> devices in the order of firmware discovery, which can change due to
> variations in device spin up time. The suggested change in the driver is to
> prepare a sorted list prior to reporting devices to the OS. This algorithm
> will be based on Enclosure/Slot order algorithm.
> 
> For this algorithm to be implemented in the controller firmware, the
> firmware needs memory space to account for several hundreds of devices
> that could potentially be supported.  This specific version of the
> controller hardware does not have the necessary memory to implement
> this logic.  Hence the logic is implemented in the driver.
> 
> Here is overview of this patch:
> 
> (a) Check IOC Page 8. If the MPI2_IOCPAGE8_FLAGS_ENCLOSURE_SLOT_MAPPING bit
> is not set in the flags field, then don't sort devices. When the flag is
> cleared, then devices are added to list in the order of controller discovery.
> 
> (b) If the Enclosure/Slot mapping bit is set, then proceed to sort devices
> as follows.
> 
> This is the Enclosure/SlotID mapping algorithm:
> 
> (1)If the list is empty, add the first device.
> 
> (2)If the new device has a Enclosure Handle set to zero, then proceed to the
> Expander /Phy Number mapping algorithm (see next section).
> 
> (3)Traverse through the list. If the Enclosure Handle is zero, loop to the
> next device. If we made it thru the entire list and didn't insert the new
> device and then proceed to the Expander /Phy Number mapping algorithm. (see
> next section)
> 
> (4)If Enclosure Handle less than the searched Enclosure Handle, then insert
> new device before the searched device.
> 
> (5)If the Enclosure Handle is the same as the searched device Enclosure
> Handle, then check the Slot ID. If the Slot ID is smaller than the searched
> Slot ID, then insert new device before the searched device.
> 
> (6)If both Enclosure Handle and Slot ID are the same as searched devices,
> then check Phy Number. If the PhyNumber is smaller than the searched device
> PhyNumber, then insert new device before the searched device.
> 
> (7)If we hit the last entry in the list, then append new device to the tail.
> 
> 
> This is the Expander /Phy Number mapping algorithm:
> 
> (1)Traverse through the list from the start. If the Parent Handle is less
> than the search Parent Handle, then insert new device before the searched
> device. Please note that the Parent Handle is parent of the attached device,
> it would be either an host controller or expander.
> 
> (2)If the Parent Handle is the same as the searched device Parent Handle,
> then check PhyNumber. If the PhyNumber is less than the searched PhyNumber,
> then insert the new device before the searched device.
> 
> (3)If we made it through the entire list without adding the new device, then
> append new device to tail of the list.

This really doesn't look like a good idea.  If you want slot mapping why
not just add a udev rule to get it (or use ses)?  Trying to wait and
sort in the driver is fragile and also a bit pointless.

James


