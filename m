From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <->
 LLDD reentrancy
Date: Mon, 26 Aug 2002 12:15:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208261715.g7QHFkX00637@localhost.localdomain>
References: <ARZEH@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA22058
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2002 10:15:49 -0700
In-Reply-To: Message from "Aron Zeh" <ARZEH@de.ibm.com>
   of "Mon, 26 Aug 2002 19:01:55 +0200." <OF7CB8B7A6.7888F8DC-ONC1256C21.005CA55A@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Aron Zeh <ARZEH@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <luben@splentec.com>, linux-scsi <linux-scsi@vger.kernel.org>

ARZEH@de.ibm.com said:
> If you say scanning is legacy only does that mean you expect it to be
> gone by kernel 2.6? 

Not unless someone else is working on it...We currently don't have any of the 
replacement infrastructure in place.  It also depends on projects outside SCSI 
(hotplug, driverfs, initramfs etc.).

> I currently don't know of a way that SCSI devices (LUNs) generate
> hotplug notifications by. (FC sends RSCNs and other nasty stuff for
> ports, which are one level higher up. I don't think reconfiguring the
> LUNs behind a port would generate any message, would it?) Even of
> messages are generated, they'd probably differ according to the
> underlying hardware. Would HBA drivers have to catch them and use more
> generic callbacks to tell the SCSI stack? 

There would have to be a generic notify mechanism implemented within SCSI.  
Probably via a skeleton Scsi_Device with attached driverfs entry passed up.  
These would then trigger the hotplug events so we get hotplug event 
consistency.

The idea is that this would occur at the PUN (device) level, not the LUN (you 
don't want 65,535 notifications for a large array...).  Once the device has 
been noticed, it's up to the hotplug system to do something (or even if it 
chooses, nothing) about the device (like probe its LUNs, etc.).

James


