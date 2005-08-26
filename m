From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 0/2] fusion SAS support
Date: Fri, 26 Aug 2005 17:15:11 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C03CCFF70@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:37064 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965090AbVHZXPx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 19:15:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeremy Higdon <jeremy@sgi.com>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org, "Wade, Roy" <Roy.Wade@lsil.com>

On Wednesday, August 24, 2005 3:14 AM, Christoph Hellwig wrote:
> On Wed, Aug 24, 2005 at 02:10:14AM -0700, Jeremy Higdon wrote:
> > However, after updating firmware on the 1064, this latter problem
> > seems to be fixed (still doesn't discover devices on the expander
> > at driver init).
> 
> As mentioned expanders aren't tested at all yet, I'll fix it as soon
> as I have an expander and hopefully soon the fusion specs 
> (still waiting
> for lsi to contact me about the nda)
>

I will ship you a SASx12 Expander on Monday. My manager is working
on NDA's for both you and James, and hopefully they will be completed
very soon.  I sent you two SAS HBA, perhaps one of those you could
send to James Bottomley.

I apologize its taking so long to review the patches you sent last
week, but I have been swamped working issues for many different customers.
I only began looking at your patches last night.   Here are some comments:

+		ioc->sas_ports[i] = sas_port_add(ioc->sh, i, attrs);
+		if (IS_ERR(ioc->sas_ports[i])) {
+			error = PTR_ERR(ioc->sas_ports[i]);
+			goto out_free_ports;
+		}

This code is only attaching ports for the direct ports.  I have
a LSI SAS1064 - 4 ports - so it only reports four ports.  

I see:

/sys/class/sas_port/port-4:0
/sys/class/sas_port/port-4:1
/sys/class/sas_port/port-4:2
/sys/class/sas_port/port-4:3

In my configuration I have SASx12 sitting on the 3rd port.
Expander support is not there in your version of the driver.
How do you propose to report the expanders 12 ports that is attached to 
/sys/class/sas_port/port-4:3 ??  Will I see all the 12 ports added
to /sys/class/sas_port/ or should these ports be inside 
/sys/class/sas_port/port-4:3 ??  Such as

/sys/class/sas_port/port-4:3/port-12:0
/sys/class/sas_port/port-4:3/port-12:1
/sys/class/sas_port/port-4:3/port-12:2
/sys/class/sas_port/port-4:3/port-12:3

If so, then the sas_transport code needs to change.


+	if (*phy_counter >= ioc->num_sas_ports) {
+		sas_add_target(ioc->sas_ports[pg0->PhysicalPort],
+				&ioc->sas_attached[pg0->PhysicalPort],
+				pg0->Bus, pg0->TargetID)

My expander has 7 devices attached. There is 5 SATA and 2 SAS devices.
>From the function mptsas_probe_attached_device - this will
call Sas Device Page 0, this containing all the devices seen in
the domain.  The function sas_add_target() will be called
for all seven devices, to include the SMP expander; e.g. 8 times.
During the time it called sas_add_target() 8 times,  its sending the same
ioc->sas_ports and ioc->sas_attached data pointers because all 8
devices are at pg0->PhysicalPort=3.  Thus how will setup the 
12 ports for expander? The information regarding
these 12 ports can be obtained via Sas Expander Page 1. 
I guess we can add this to the function mptsas_probe_phy() so ports for
direct attached and expanders are reported? What do you think, or 
did you have another idea bout this?  I'm not sure about how
calling sas_port_add() 4 times for the HBA, and 12 times
for the exander, how that would be populating the tree.  I guess you want
to wait till you recieve the expander to comment on this?

Additional comments:

Loading the driver as modules - will not work because its missing
EXPORT_SYMBOL(mptbase_sas_persist_operation) in mptbase.c

We have Integrated RAID support for SAS - thus in my code(3.02.55) I have 
broken out the RAID related parameters from typedef _ScsiCfgData
into another structure called _RaidCfgData - I would suggest
picking up these changes.

Hot plug support - how is this going to be done. Take a look
at mptscsih_hot_plug_worker_thread, that I sent in 3.02.55.

There are other minor items left out in your port, which I would like
added.  I will go ahead make those changes and send across a patch for that.


Eric Moore
LSI Logic



