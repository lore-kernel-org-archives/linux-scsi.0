From: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Subject: Re: [PATCH] shutdown processing
Date: Thu, 16 Feb 2006 11:12:08 -0800
Message-ID: <20060216111208.2367829b.randy_d_dunlap@linux.intel.com>
References: <20060215114605.1568c8cc.randy_d_dunlap@linux.intel.com>
	<43F43EB9.40406@s5r6.in-berlin.de>
	<20060216104007.67cf613f.randy_d_dunlap@linux.intel.com>
	<43F4CAF4.1070004@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43F4CAF4.1070004@s5r6.in-berlin.de>
Sender: linux-ide-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 16 Feb 2006 19:56:52 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Randy Dunlap wrote:
> > On Thu, 16 Feb 2006 09:58:33 +0100
> > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >>Why are you calling these from SCSI? Wouldn't ahci_pci_driver.remove() 
> >>and piix_pci_driver.remove() be a proper place to perform what you are 
> >>doing in ata_device_shutdown?
> > 
> > Mostly to have the scsi_device pointers available.
> 
> Note that roughly as long a scsi_device exists, SCSI high-level drivers 
> expect to be able to send commands to them. In particular, when 
> scsi_remove_device is called, (or scsi_remove_host, which calls 
> scsi_remove_device for all still existing devices of a host), the SCSI 
> high-level drivers' shutdwon methods get executed. Some of them send 
> SCSI commands. The upshot is, a SCSI low-level driver has to be able to 
> handle newly enqueued command while it is calling 
> scsi_remove_{device,host}. Moreover it must not block a SCSI host at 
> this moment.
> 
> IOW the most natural order for layers to shut down would be first SCSI, 
> then ATA. (But then, I don't really comprehend whether your shutdown 
> code would actually collide with that of the SCSI subsystem at all.)

OK, now it seems like you just told me why I shouldn't use
the pci_driver.remove() interface.  But thanks for your comments,
I do appreciate them and will dig deeper [into a twisty maze :].

anyone else care to comment on this?

---
~Randy
