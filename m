From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Transport Attributes -- attempt#3
Date: Tue, 20 Jan 2004 11:49:11 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120114910.A23223@beaverton.ibm.com>
References: <20040107185420.GA30627@localhost> <20040108131717.A9700@infradead.org> <20040114181241.GK27591@localhost> <400C7143.8010500@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:56706 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265718AbUATTth (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 14:49:37 -0500
Content-Disposition: inline
In-Reply-To: <400C7143.8010500@us.ibm.com>; from brking@us.ibm.com on Mon, Jan 19, 2004 at 06:07:31PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Martin Hicks <mort@wildopensource.com>, linux-scsi@vger.kernel.org

On Mon, Jan 19, 2004 at 06:07:31PM -0600, Brian King wrote:
> I just submitted a new LLD to linux-scsi and Christoph suggested I use 
> this patch for setting SCSI bus attributes. I looked through the patches 
> and noticed that these are per device attributes. I need to be able to 
> set per SCSI bus attributes. The attributes I would like to be able to 
> set include: initiator ID, maximum bus speed, wide enabled/disabled, and 
> device spinup delay. Would it make sense to create a scsi_bus class or 
> something similar for these types of attributes?

For the IPR driver -

Is the spinup delay for the entire card, not per bus? If so it should be
a scsi_host attribute set via shost_attrs. (No one uses shost_attrs, but
its use is the same as sdev_attrs usage in 53c700.c)

And are the other values for the actual physical disks? If they are not
visible to the host, then there is no bus visible to the host (i.e. scsi
core can't see them). 

Having the physical disk show up in scsi core as drives is nice for
managing them, but if they are ready for writing it could be confusing,
and potentially disasterous. We could do hacks to get different behaviour
for the disks (so only sg shows up, or so sd shows up read only), like: add
a flag in scsi_host; modify the INQUIRY type in the ipr driver; or modify
the MODE SENSE page 0x3f (and/or page 0) result in the ipr driver so they
show up read only (though on failure of a MODE SENSE they would become
writable).

If they were visible to scsi core, the intiator ID (this_id) would be
found in the scsi_host, but would need to be added as a sysfs attribute.

We could add a scsi_bus class, but we first need a bus/fabric struct that
can include the class, and that in turn requires quite a bit more work
to get it in the right place in the driver model tree (we would want a
bus/fabric per host:channel pair).

As noted before, we also don't have a target, and the transport attributes
(per the patch) show up as per LUN, even though they might be per target,
or even per bus/fabric. IMO that is fine for now.

i.e. we have a sysfs tree like this:

`-- pcifoo
    `-- host14
        |-- host_attrs
        |-- 14:0:0:0
        |   `-- sdev_attrs
        `-- 14:0:0:1
            `-- sdev_attrs

But we need something like this:

`-- pcifoo
    `-- host14
        |-- host_attrs
        `-- 14:0
            |-- bus_fabric_attrs
            `-- 14:0:0
                |-- target_attrs
                |-- 14:0:0:0
                |   `-- sdev_attrs
                `-- 14:0:0:1
                    `-- sdev_attrs

And then driver model class or bus code can be used with the above as
needed.

-- Patrick Mansfield
