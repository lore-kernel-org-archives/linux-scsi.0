From: Matthew Wilcox <willy@debian.org>
Subject: Re: I have modified the megaraid driver v2.00.5 from kernel 2.6 to 2 .4.22-prex-ac1
Date: Wed, 23 Jul 2003 13:18:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030723121846.GQ1485@parcelfarce.linux.theplanet.co.uk>
References: <200307230653.PAA16508@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:18150 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270219AbTGWMDp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jul 2003 08:03:45 -0400
Content-Disposition: inline
In-Reply-To: <200307230653.PAA16508@toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: atulm@lsil.com, Matt Domsch <Matt_Domsch@Dell.com>, linux-megaraid-devel@dell.com, linux-scsi@vger.kernel.org, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

On Wed, Jul 23, 2003 at 03:52:46PM +0900, Tomita, Haruo wrote:
> Dear Atul,
> 
> I have modified the megaraid driver  v2.00.5 from kernel 2.6 
> to 2.4.22-pre3-ac1 or 2.4.22-pre6-ac1.

You mean you backported the 2.6 driver to 2.4?  If so, it seems the
driver is in better state in 2.4 than 2.6 as many of these changes
are outright wrong.

> +static unsigned int max_commands = MAX_COMMANDS;
> +MODULE_PARM(max_commands, "i");
> +MODULE_PARM_DESC(max_commands, "Maximum number of commands which can be
> issued
> +to a single controller (default=MAX_COMMANDS=126)");
> +

This is bad; GCC 3 will refuse to compile string literals split across a
line like this.  And even GCC 2.x will put a literal newline in the string.
If you really can't stand the wrap do one of:

MODULE_PARM_DESC(max_commands,
"Maximum number of commands which can be issued to a single controller (default=MAX_COMMANDS=126)");

(which doesn't work for this case *anyway*)

or use string concatenation, like so:

MODULE_PARM_DESC(max_commands, "Maximum number of commands which "
	"can be issued to a single controller (default=MAX_COMMANDS=126)");

> -MODULE_PARM_DESC(max_sectors_per_io, "Maximum number of sectors per I/O
> request (default=MAX_SECTORS_PER_IO=128)");
> +MODULE_PARM_DESC(max_sectors_per_io, "Maximum number of sectors per I/O
> +request (default=MAX_SECTORS_PER_IO=128)");

same here.

> -MODULE_PARM_DESC(max_mbox_busy_wait, "Maximum wait for mailbox in
> microseconds if busy (default=MBOX_BUSY_WAIT=10)");
> +MODULE_PARM_DESC(max_mbox_busy_wait, "Maximum wait for mailbox in
> microseconds
> +if busy (default=MBOX_BUSY_WAIT=10)");

same here.

>  #define RDINDOOR(adapter)		readl((adapter)->base + 0x20)
>  #define RDOUTDOOR(adapter)		readl((adapter)->base + 0x2C)
> @@ -122,6 +129,8 @@
>  static void
>  megaraid_validate_parms(void)
>  {
> +	if( (max_commands <= 0) || (max_commands > MAX_COMMANDS) )
> +		max_commands = MAX_COMMANDS;
>  	if( (max_cmd_per_lun <= 0) || (max_cmd_per_lun > MAX_CMD_PER_LUN) )
>  		max_cmd_per_lun = MAX_CMD_PER_LUN;
>  	if( max_mbox_busy_wait > MBOX_BUSY_WAIT )
> @@ -290,6 +299,8 @@
>  		if( subsysvid && (subsysvid != AMI_SUBSYS_VID) &&
>  				(subsysvid != DELL_SUBSYS_VID) &&
>  				(subsysvid != HP_SUBSYS_VID) &&
> +				(subsysvid != 0x1111) &&
> +				(subsysvid != 0x113c) &&
>  				(subsysvid != LSI_SUBSYS_VID) ) continue;

PCI subsystem vendor IDs should use the defined constants in
include/linux/pci_ids.h

not to mention the whole test is bogus:

                subsysvid = pdev->subsystem_vendor;
                subsysid = pdev->subsystem_device;

                /*
                 * If we do not find the valid subsys vendor id, refuse to
                 * load the driver. This is part of PCI200X compliance
                 * We load the driver if subsysvid is 0.
                 */
                if( subsysvid && (subsysvid != AMI_SUBSYS_VID) &&
                                (subsysvid != DELL_SUBSYS_VID) &&
                                (subsysvid != HP_SUBSYS_VID) &&
                                (subsysvid != LSI_SUBSYS_VID) ) continue;

if we want linux to be PCI200X compliant (a dubious point of view since
it means we'd have to stop supporting hundreds of hardware devices designed
before this became mandatory), this should be done in the PCI subsystem,
not in individual drivers.

some of the other code around here needs cleaning up too; for example
you should be using pci_name() rather than printing the slot/func yourself.

btw, any plans to convert this driver to be hotplug capable?

> @@ -1799,12 +1809,15 @@
>  		}
>  		set_irq_state(adapter, byte);
>  
> +		nstatus = 0xFF;
>  		while((nstatus = (volatile u8)adapter->mbox->numstatus)
>  				== 0xFF)

this initialisation is not necessary; the assignment in the while loop
occurs before the test. (other occurrences of the same problem deleted).

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
