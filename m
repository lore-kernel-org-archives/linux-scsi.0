From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] shutdown processing
Date: Fri, 17 Feb 2006 20:15:28 +0100
Message-ID: <43F620D0.7050502@s5r6.in-berlin.de>
References: <20060215114605.1568c8cc.randy_d_dunlap@linux.intel.com>	<43F43EB9.40406@s5r6.in-berlin.de>	<20060216104007.67cf613f.randy_d_dunlap@linux.intel.com>	<43F4CAF4.1070004@s5r6.in-berlin.de> <20060216111208.2367829b.randy_d_dunlap@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060216111208.2367829b.randy_d_dunlap@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Randy Dunlap <randy_d_dunlap@linux.intel.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 16 Feb 2006 19:56:52 +0100
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
...
>>Note that roughly as long a scsi_device exists, SCSI high-level drivers 
>>expect to be able to send commands to them.
...
> OK, now it seems like you just told me why I shouldn't use
> the pci_driver.remove() interface.

:-) Really? Depends on what you are trying to solve. From what I 
understood, the function you require does not interact with a scsi_device.

You could also have a look into scsi_host_template.slave_destroy. This 
is called from SCSI core when a scsi_device is being removed. In 
particular, it is called _after_ the upper SCSI layers finished all 
their business with your device.

BTW, ata_scsi_release looks suspicious WRT what I said above. I see

	ap->ops->port_disable(ap);
	ata_host_remove(ap, 0);

there. Since libata apparently never uses scsi_remove_device, 
ata_host_remove's call to scsi_remove_host will call scsi_remove_device 
which will cause SCSI high-level drivers to run their shutdown methods. 
It looks wrong to me to place something like ata_port_disable before 
that, judging from what the comment at the definition of 
ata_port_disable says.

Another suspicious code: ahci_remove_one calls free_irq before 
ata_scsi_release.

I never looked at this code before, never even used it --- am I missing 
something fundamental?
-- 
Stefan Richter
-=====-=-==- --=- =---=
http://arcgraph.de/sr/
