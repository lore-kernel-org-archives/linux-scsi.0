From: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Tue, 13 Dec 2005 11:07:27 -0800
Message-ID: <20051213110727.2bef7d80.randy_d_dunlap@linux.intel.com>
References: <20051208030242.GA19923@srcf.ucam.org>
	<20051213101417.13fdb14c.randy_d_dunlap@linux.intel.com>
	<20051213182651.GA14645@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030191AbVLMTEK@vger.kernel.org>
In-Reply-To: <20051213182651.GA14645@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Tue, 13 Dec 2005 18:26:51 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Tue, Dec 13, 2005 at 10:14:17AM -0800, Randy Dunlap wrote:
> 
> > 7.  Most important:  What good does the ACPI interface do/add?
> >     What I mean is that acpi_get_child() in scsi_acpi_find_channel()
> >     always returns a handle value of 0, so it doesn't get us
> >     any closer to determining the ACPI address (_ADR) of the SATA
> >     devices.  The acpi_get_devices() technique in my patch (basically
> >     walking the ACPI namespace, looking at all "devices") is the
> >     only way that I know of doing this, but I would certainly
> >     like to find a better way.
> 
> When the PCI bus is registered, acpi walks it and finds the appropriate 
> acpi handle for each PCI device. This is shoved in the 
> firmware_data field of the device structure. Later on, we register the 
> scsi bus. As each item on the bus is added, the acpi callback gets 
> called. If it's not an endpoint, scsi_acpi_find_channel gets called. 
> We're worried about the host case. The host number will correspond to 
> the appropriate _ADR underneath the PCI device that the host is on, so 
> we simply get the handle of the PCI device and then ask for the child 
> with the appropriate _ADR. That gives us the handle for the device, and 
> returning that sticks it back in the child's firmware_data field.
> 
> At least, that's how it works here. If acpi_get_child always returns 0 
> for you, then it sounds like something's going horribly wrong. Do you 
> have a copy of the DSDT?

Thanks for the explanation.
The 136 KB DSDT is at:
  http://www.xenotime.net/linux/SATA/acpitbl.out .

---
~Randy
