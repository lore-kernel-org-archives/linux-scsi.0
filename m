From: Brian King <brking@us.ibm.com>
Subject: Re: Transport Attributes -- attempt#3
Date: Tue, 20 Jan 2004 14:38:27 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400D91C3.1000503@us.ibm.com>
References: <20040107185420.GA30627@localhost> <20040108131717.A9700@infradead.org> <20040114181241.GK27591@localhost> <400C7143.8010500@us.ibm.com> <20040120114910.A23223@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:29911 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265756AbUATUid (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 15:38:33 -0500
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Martin Hicks <mort@wildopensource.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> For the IPR driver -
> 
> Is the spinup delay for the entire card, not per bus? If so it should be
> a scsi_host attribute set via shost_attrs. (No one uses shost_attrs, but
> its use is the same as sdev_attrs usage in 53c700.c)

No, the spinup delay is per bus.

> And are the other values for the actual physical disks? If they are not
> visible to the host, then there is no bus visible to the host (i.e. scsi
> core can't see them). 

The other values are also for the entire scsi bus, not for individual 
targets.

> Having the physical disk show up in scsi core as drives is nice for
> managing them, but if they are ready for writing it could be confusing,
> and potentially disasterous. We could do hacks to get different behaviour
> for the disks (so only sg shows up, or so sd shows up read only), like: add
> a flag in scsi_host; modify the INQUIRY type in the ipr driver; or modify
> the MODE SENSE page 0x3f (and/or page 0) result in the ipr driver so they
> show up read only (though on failure of a MODE SENSE they would become
> writable).

Christoph has suggested I create psuedo devices for them, but not report 
them to the upper layer drivers, similar to how scsi_get_host_dev works. 
  This means they won't show up in sysfs, AFAIK. Which would then pose 
the problem you mention above of the midlayer not seeing the bus if 
there are only RAID disks on the bus. For this reason, it might be nice 
if the devices did get reported in, maybe as sg devices only? There 
should really be no reason to create an sd device, as it would only 
cause problems.

> If they were visible to scsi core, the intiator ID (this_id) would be
> found in the scsi_host, but would need to be added as a sysfs attribute.

Once again, for the adapter, the initiator ID is per bus, rather than 
per adapter. I could force them to be the same for all busses, however.

> We could add a scsi_bus class, but we first need a bus/fabric struct that
> can include the class, and that in turn requires quite a bit more work
> to get it in the right place in the driver model tree (we would want a
> bus/fabric per host:channel pair).
> 
> As noted before, we also don't have a target, and the transport attributes
> (per the patch) show up as per LUN, even though they might be per target,
> or even per bus/fabric. IMO that is fine for now.
> 
> i.e. we have a sysfs tree like this:
> 
> `-- pcifoo
>     `-- host14
>         |-- host_attrs
>         |-- 14:0:0:0
>         |   `-- sdev_attrs
>         `-- 14:0:0:1
>             `-- sdev_attrs
> 
> But we need something like this:
> 
> `-- pcifoo
>     `-- host14
>         |-- host_attrs
>         `-- 14:0
>             |-- bus_fabric_attrs
>             `-- 14:0:0
>                 |-- target_attrs
>                 |-- 14:0:0:0
>                 |   `-- sdev_attrs
>                 `-- 14:0:0:1
>                     `-- sdev_attrs
> 
> And then driver model class or bus code can be used with the above as
> needed.

That seems reasonable to me.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

