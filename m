From: "Infante, Jon" <Jon.Infante@Emulex.Com>
Subject: RE: suspending I/Os to a device
Date: Fri, 23 Apr 2004 15:12:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8D43EFD7CCBDB24980134BE078C227E704E37A82@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:6553 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S261505AbUDWWMs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Apr 2004 18:12:48 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.206])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i3NMCkcj021882
	for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2004 15:12:46 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Reflector <linux-scsi@vger.kernel.org>


Here is the senerio I am trying to handle within our Fibre Channel driver.
In Fibre Channel, it is possible for the Target, or HBA, to be disconnected
from one port on a switch and plugged into another port on the same (or even
a different) switch. This transitition can happen with live traffic and the
scsi subsystem / driver is supposed to recover gracefully, without failing
all I/Os back up to applications that are running. In order to accomplish
this, there is a configurable timer, that tells the driver how long to wait
(at the Fibre Channel level), when a device disappears, to give it a chance
to come back. Some OEMs / environments set this to a couple seconds, some a
to couple of minutes.

The interface scsi_block_request() cannot block based on specific targets.
scsi_block_when_processing errors() does not look like a routine a HBA
driver should be calling as it is primarily used by sd / sg /st. 

Since the HBA driver is not supposed to internally queue requests / change
the scsi timeout imposed on the I/O, its needs a mechanism to tell the scsi
layer to 
1) stop / start sending I/Os to a specific Target
2) do not start any scsi timeouts on I/Os being held for the target while
I/O is suspended.

Are there any other drivers out there that require, or have implemented,
this functionality and/or is there a preferred way to accomplish this?

--
Jon Infante
Emulex


 


-----Original Message-----
From: Infante, Jon 
Sent: Friday, April 23, 2004 12:00 PM
To: Linux SCSI Reflector
Subject: suspending I/Os to a device



Is there a standard, or generally accepted way, for a driver to request the
scsi layer temporarily suspend all I/Os to a particular Target or
Target/Lun. Conversely, I would want to resume I/Os at a driver determined
time without the scsi layer timing them out. 

--
Jon Infante
Emulex
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
