From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi sysfs update (upper 2/3)
Date: Thu, 7 Nov 2002 21:41:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108054135.GF1292@beaverton.ibm.com>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107073943.GB1390@beaverton.ibm.com> <20021107182947.B15350@sgi.com> <20021107164152.GD1292@beaverton.ibm.com> <20021108012047.A17391@infradead.org> <20021108022158.GD1292@beaverton.ibm.com> <20021108045305.A22307@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021108045305.A22307@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> On Thu, Nov 07, 2002 at 06:21:58PM -0800, Mike Anderson wrote:
> > Is the disagreement the function name, bus name, or the concept of
> > registering these drivers with sysfs?
> 
> Well, they're not really busses, and I hate misleading analogies :)
> 
> No, my real issues is that the scsi_devices should be attached to
> a bus hanging of the HBA, as that's what they physically do, not of
> some pseudo-bus for the higherlevel devices.
> 

The "bus" object and associated functions are key pieces to sysfs
integration. The kobjects that I believe the block layer and fs are
going to use are less structured, but I believe they are not intended
for device to driver relationships.

As I said previously the parent / child relationship of HBA to
scsi_device matches your requested connectivity. Though even in the
current scsi sub-system we represent targets and luns as siblings which
does not exactly match physical connectivity. This same sibling
relationship is still present in the sysfs tree. The /bus/scsi/devices
is only a logical view with links to the physical. There are other
logical view links in the tree that point to these devices also (i.e.
under /drivers/xxx/).


> > Do you see a problem with "scsi_upper_driver_register" being added now?
> 
> I'd prefer if we'd let it stay as-is for now.
> 

ok, I can remove _bus_ from all my wrapper function names, but the intent of
these new wrapper functions was to make scsi_bus_type static and control
add / removes to the device list. This was to reduce future accidents of
adding mixed types and then having someone do a container_of on a non
scsi_device object. I could leave the upper level drivers the same and
just call a function from scsi_register_device.

-andmike
--
Michael Anderson
andmike@us.ibm.com

