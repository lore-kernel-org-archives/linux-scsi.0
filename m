From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: Thu, 24 Oct 2002 09:25:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210241425.g9OEPCP02249@localhost.localdomain>
References: <sdake@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA18790
	for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2002 07:25:17 -0700
In-Reply-To: Message from Steven Dake <sdake@mvista.com>
   of "Wed, 23 Oct 2002 17:48:46 PDT." <3DB7436E.9060100@mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: linux-scsi@vger.kernel.org

I looked at this briefly last night.  The patch seems to come in three pieces:

1) Add list locking to manipulations of the host device list
2) Add a new filesystem type for exposing SCSI information
3) add a lot more methods for adding and removing SCSI devices.

1) seems to be something we should have

I'm dubious about 2).  Could you explain why you need a new fs interface as 
opposed to using driverfs?

3) duplicates existing functionality and the new bits it does add could be 
done using a hotplug framework.

For all the removes, if you exposed the information you're looking for (FC 
wwn) in driverfs, you could use the existing remove interface.

For the adds, all of this would be finessed by having the FC event that 
detected a new device on the fibre trigger a hotplug event.  You could then 
have the hotplug trigger the existing add device interface to make the 
component configure automatically (hotplug on fibre events like this has been 
a hot item for a while, so having a general interface would be most welcome).

If you must delay configuration and do it by wwn later, you could capture the 
wwns to host,channel,id,lun mappings in a table on the hotplug event (and not 
configure the device) and use the information for later configuration using 
the existing interfaces.

James


