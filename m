From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <->
 LLDD reentrancy
Date: Mon, 26 Aug 2002 11:48:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208261648.g7QGm6b00427@localhost.localdomain>
References: <ARZEH@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA14877
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2002 09:48:18 -0700
In-Reply-To: Message from "Aron Zeh" <ARZEH@de.ibm.com>
   of "Mon, 26 Aug 2002 18:29:51 +0200." <OFA9BD559F.ACA1BDCD-ONC1256C21.005981BE@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Aron Zeh <ARZEH@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <luben@splentec.com>, linux-scsi <linux-scsi@vger.kernel.org>

ARZEH@de.ibm.com said:
> Does the use of driverfs-names mean that the HBA driver somehow comes
> into the discovery-loop for devices (e.g. scan_scsis somehow interacts
> with the HBA driver to determine which driverfs entry to create.)?

Well, scanning is really only for legacy.  Way into the future, I'd like to 
see hotplug notification for device attach events, so no fibre controller ever 
need be troubled by the scan.  All they'd do is send a device attach 
notification into SCSI when they detect one.  (SCSI would probably then turn 
around and ask for a REPORT_LUNS).

> Shouldn't there be some sort of rule for LUN (or unit) naming within
> at least the same hardware class? That is for: parallel, iSCSI, FC,
> etc. Will the SCSI stack automatically try to discover all devices
> behind the HBA (e.g, on the FC SAN)? Or will there be an interface to
> restrict the range, etc?

Yes, there should.  But such a rule would only be for maintaining consistency 
within driverfs, and therefore could happily become Patric Mochel's problem.  
If we go the whole hotplug route, discovery would be up to the scsi hotplug 
scripts.

> Lastly, how will you keep track of LUNs in the SCSI stack? Will the
> current LUN field disappear in favour of a generic character string? 

Internally to Scsi_Device, LUNs will be linked by pointers.  How we know 
whether such a linkage needs to occur, I'm not yet sure about.  In the worst 
case we could use driverfs matching to see if a newly discovered device's PUN 
matches an existing device, or there might be a way for the HBA driver to 
supply the information.

James


