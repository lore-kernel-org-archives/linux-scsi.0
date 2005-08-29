From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] fusion SAS support
Date: Mon, 29 Aug 2005 09:01:15 +0100
Message-ID: <20050829080115.GA475@infradead.org>
References: <91888D455306F94EBD4D168954A9457C03CCFF70@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:63635 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751226AbVH2IBV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 04:01:21 -0400
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C03CCFF70@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Jeremy Higdon <jeremy@sgi.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org, "Wade, Roy" <Roy.Wade@lsil.com>

On Fri, Aug 26, 2005 at 05:15:11PM -0600, Moore, Eric Dean wrote:
> I apologize its taking so long to review the patches you sent last
> week, but I have been swamped working issues for many different customers.
> I only began looking at your patches last night.   Here are some comments:
> 
> +		ioc->sas_ports[i] = sas_port_add(ioc->sh, i, attrs);
> +		if (IS_ERR(ioc->sas_ports[i])) {
> +			error = PTR_ERR(ioc->sas_ports[i]);
> +			goto out_free_ports;
> +		}
> 
> This code is only attaching ports for the direct ports.  I have
> a LSI SAS1064 - 4 ports - so it only reports four ports.  
> 
> I see:
> 
> /sys/class/sas_port/port-4:0
> /sys/class/sas_port/port-4:1
> /sys/class/sas_port/port-4:2
> /sys/class/sas_port/port-4:3
> 
> In my configuration I have SASx12 sitting on the 3rd port.
> Expander support is not there in your version of the driver.

Yes, as noted in the transport class announcement this doesn't
deal with expanders yet at all.

> How do you propose to report the expanders 12 ports that is attached to 
> /sys/class/sas_port/port-4:3 ??  Will I see all the 12 ports added
> to /sys/class/sas_port/ or should these ports be inside 
> /sys/class/sas_port/port-4:3 ??  Such as
> 
> /sys/class/sas_port/port-4:3/port-12:0
> /sys/class/sas_port/port-4:3/port-12:1
> /sys/class/sas_port/port-4:3/port-12:2
> /sys/class/sas_port/port-4:3/port-12:3
> 
> If so, then the sas_transport code needs to change.

In the /sys/class/ hierachy they will have to be flat due to the
way the generic class_device code works.  No it's still open whether
we will have a flat hierachy of class_devices or whether we'll attach
extender ports to the struct device of the "parent" port.  I'll prefer
the former because it keeps the hierachy simpler and mirrors what is
done in FibreChannel, James prefers the latter.  I'll probably prototype
both.

> +	if (*phy_counter >= ioc->num_sas_ports) {
> +		sas_add_target(ioc->sas_ports[pg0->PhysicalPort],
> +				&ioc->sas_attached[pg0->PhysicalPort],
> +				pg0->Bus, pg0->TargetID)
> 
> My expander has 7 devices attached. There is 5 SATA and 2 SAS devices.
> >From the function mptsas_probe_attached_device - this will
> call Sas Device Page 0, this containing all the devices seen in
> the domain.  The function sas_add_target() will be called
> for all seven devices, to include the SMP expander; e.g. 8 times.
> During the time it called sas_add_target() 8 times,  its sending the same
> ioc->sas_ports and ioc->sas_attached data pointers because all 8
> devices are at pg0->PhysicalPort=3.  Thus how will setup the 
> 12 ports for expander? The information regarding
> these 12 ports can be obtained via Sas Expander Page 1. 
> I guess we can add this to the function mptsas_probe_phy() so ports for
> direct attached and expanders are reported? What do you think, or 
> did you have another idea bout this?  I'm not sure about how
> calling sas_port_add() 4 times for the HBA, and 12 times
> for the exander, how that would be populating the tree.  I guess you want
> to wait till you recieve the expander to comment on this?

I think getting the NDA and docs is more important.  What I really
want to do is to call scsi_scan_target for every sas device that's a scsi
target, so that we can support multi-lun devices easily and coherently with
other SCSI transports.  Now I need to figure out how to properly get
information out of the Fusion firmware to only report attached sas devices,
not individual luns, and I need to make sure different sas devices never
get the same target id, so scsi_scan_device does the right thing.  This
could mean I need to the work I suggested to Luben in a previous mail to
make ->id meaningless for SAS and similar transports, or a scsi midlayer
to fusion target id mapping.


> Additional comments:
> 
> Loading the driver as modules - will not work because its missing
> EXPORT_SYMBOL(mptbase_sas_persist_operation) in mptbase.c

ok.

> We have Integrated RAID support for SAS - thus in my code(3.02.55) I have 
> broken out the RAID related parameters from typedef _ScsiCfgData
> into another structure called _RaidCfgData - I would suggest
> picking up these changes.

The changes have conflict with James' RAID and DV changes, so I only want
to merge them over after James' chanhes are in.

> Hot plug support - how is this going to be done. Take a look
> at mptscsih_hot_plug_worker_thread, that I sent in 3.02.55.

We'll probably have a workqueue for it in the transport class, but hotplug
support isn't on the top of my TODO list, so it'll have to wait a little.

