From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] Separating out libata out of SCSI (finally)
Date: Fri, 20 Jun 2008 15:28:57 -0500
Message-ID: <1213993737.3443.35.camel@localhost.localdomain>
References: <485B2CC6.6070201@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <485B2CC6.6070201@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, brking@linux.vnet.ibm.com, Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2008-06-20 at 13:06 +0900, Tejun Heo wrote:
> Hello, all.
> 
> This item was on TODO list for years now.  People all agree that it's
> necessary but it always had relatively low priority probably because
> it's a bit difficult and isn't really necessary to make disks and
> optical drives work.
> 
> Anyways, I think it's about time to take some action as SAS-ATA
> integration (Brian, sorry about staying so silent about this for long
> time, I was following the threads but couldn't really think of a quick
> solution) and other ATA specific things including link power
> management and bunch of other deferred ones due to lack of proper
> sysfs interface or high level driver (parallel probing, parallel
> resume).
> 
> Currently, my plan is...
> 
> * Move high level driver handling to request_queue.

Actually, I already did quite a lot of that here:

commit 7f9a6bc4e9d59e7fcf03ed23f60cd81ca5d80b65
Author: James Bottomley <James.Bottomley@steeleye.com>
Date:   Sat Aug 4 10:06:25 2007 -0500

    [SCSI] move ULD attachment into the prep function

But there's still more to be done.  The way I was thinking of it was
some type of protocol label (as in a ULD spits out protocols, like SCSI
or ATA) and then passes them to a LLD which uses libraries (what libata
and the scsi mid layer become) to process them.

> * Implement queue quiescing and other state management on request_queue.
> * Implement block_queue_group which...
> 	- Handles command scheduling.
> 	- Handles grouped queue quiescing and EH handling

There's the beginnings of this in Jens' unmerged block timers work

> * Move SCSI high level drivers to new infrastructure
> * Convert libata to use new command scheduling and EH infrastructure
> * Apply driver model to libata.
> * Implement ata_disk ATA high level driver.
> 
> In the process, I'm planning to remove ata_host requirement and break
> down libata EH into actions and sequencers so that SAS can use them
> easily.
> 
> The biggest problem is how to keep userland happy.  hdX -> sdX
> transition was painful enough and I have a strong feeling that
> everyone will come after and hunt down us if we try something like sdX
> -> bdX now.  :-)

In theory mounting by label or ID should have fixed a lot of this.
However, if we need to head off a revolt, the sdX allocation algorithm
can be placed into it's own module so both sd and a ULD ata driver could
use it ...

> It would be ideal if those ATA specific sysfs stuff just shows up
> without disturbing the original SCSI things which are now widely used
> for enumeration and manipulation.  I think we can get pretty close by
> modifying SCSI high level drivers a bit such that they don't register
> block devices for SCSI devices created to keep backward compatibility.
> This is an extra burden on SCSI but it's gonna be the last one.
> 
> *** Currently, sysfs nodes for a libata disk is like the following.
> 
>  /devices/DEV/hostH/targetH:C:I/H:C:I:L/
> 	 driver			-> /bus/scsi/drivers/sd
> 	 generic			-> /class/scsi_generic/sgN
> 	 block/sdX/
> 		 device		-> ../../
> 		 partitions...
>  /bus/scsi/devices/H:C:I:L	-> /devices/DEV/hostH/targetH:C:I/H:C:I:L
>  /bus/scsi/drivers/sd/H:C:I:L	-> /devices/DEV/hostH/targetH:C:I/H:C:I:L
>  /class/scsi_host/hostH/device	-> /devices/DEV/hostH
>  /class/scsi_device/H:C:I:L/device -> /devices/DEV/hostH/targetH:C:I/H:C:I:L
>  /class/scsi_disk/H:C:I:L/device -> /devices/DEV/hostH/targetH:C:I/H:C:I:L
>  /class/scsi_generic/sgN/device	-> /devices/DEV/hostH/targetH:C:I/H:C:I:L
>  /block/sda			-> /devices/DEV/hostH/targetH:C:I/H:C:I:L/block/sdX
> 
> *** After conversion, it will look something like the following.
> 
>  /devices/DEV/ata_port/P/ata_link/P:L/ata_device/P:D
> 	 driver			-> /bus/ata/drivers/ata_disk
> 	 block/sdX/
> 		 device		-> ../../
> 		 partitions...
>  C	scsi_device		-> /devices/DEV/scsi_compat/hostH/targetH:C:I/H:C:I:L
>  /bus/ata/devices/P:D		-> /devices/DEV/ata_port/P/ata_link/P:L/ata_device/P:D
>  /bus/ata/drivers/ata_disk/P:D	-> /devices/DEV/ata_port/P/ata_link/P:L/ata_device/P:D
>  /block/sda			-> /devices/DEV/ata_port/P/ata_link/P:L/ata_device/P:D/block/sdX

Could you, perhaps, make the port multipler visible in this as a new
device, a bit like we do today for SAS expanders?

>  /devices/DEV/scsi_compat/hostH/targetH:C:I/H:C:I:L/
> 	 driver			-> /bus/scsi/drivers/sd
> 	 generic			-> /class/scsi_generic/sgN
>  C	block			-> ata_port/P/ata_link/P:L/ata_device/P:D/block
>  C	ata_device		-> /devices/DEV/ata_port/P/ata_link/P:L/ata_device/P:D
> 
>  /bus/scsi/devices/H:C:I:L	-> /devices/DEV/scsi_compat/hostH/targetH:C:I/H:C:I:L
>  /bus/scsi/drivers/sd/H:C:I:L	-> /devices/DEV/scsi_compat/hostH/targetH:C:I/H:C:I:L
>  /class/scsi_host/hostH/device	-> /devices/DEV/scsi_compat/hostH
>  /class/scsi_device/H:C:I:L/device -> /devices/DEV/scsi_compat/hostH/targetH:C:I/H:C:I:L
>  /class/scsi_disk/H:C:I:L/device	-> /devices/DEV/scsi_compat/hostH/targetH:C:I/H:C:I:L
>  /class/scsi_generic/sgN/device	-> /devices/DEV/scsi_compat/hostH/targetH:C:I/H:C:I:L
> 
> The SCSI side of interface will remain as functional as now as it will
> go through the same libata SAT layer.

Actually, surely we can mostly dump the SAT layer?  libsas should be
made capable of taking ATA protocol packets straight from your ULD ATA
driver and sending them out.

I could see us still needing it as an optional component so we can send
SCSI SG_IO to ATA devices.

>   The only surprise userspace
> will see aside from the extra ata nodes is that /sys/block/sdX/device
> will lead to an ATA device node instead of SCSI device node.  Well,
> that's the whole point of the converion but I think the surprise can
> be minimized by reusing names used in SCSI device node and possibly
> making symlinks for nodes which only makes sense for SCSI device.
> 
> So, what do you guys think?

I think the devil will be in the details, but that it certainly won't be
obvious until the conversion is actually tried.

James


