From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: Need help with libata error handling in libsas
Date: Mon, 25 Feb 2008 10:34:29 -0600
Message-ID: <47C2EE15.3060105@linux.vnet.ibm.com>
References: <1203886936.3135.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1203886936.3135.75.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> I keep hearing that we need to convert libsas to use libata's new error
> handling.  Unfortunately, I have very little conception of what that
> means.  Right at the moment, libsas doesn't use any error handling
> functions of libata at all.
> 
> I've looked through the libata-eh functions, and I find them frankly
> incomprehensible.
> 
> Firstly, let me say what SAS error handling actually does:

Let me chime in with what ipr error handling does/can do. The ipr firmware
provides two basic SATA error handling methods with some modifiers to each.

Cancel All - This cancels all outstanding commands to the device. When issued
to an ATA device, this gets escalated by the firmware to an SRST. When issued
to an ATAPI device, an ATA NOOP is issued.

Reset Device - This command has modifiers to indicate either a soft reset
or a hard reset.

Currently, the only SATA devices that ipr officially attaches are ATAPI
DVD devices. In our testing we've come to the conclusion that trying to
use anything but a hard reset for ERP is generally more trouble than it
is worth.

> All of this leads me to conclude, that all libsas needs is to plumb in
> the ATA equivalent of abort, junk the task query for libata devices and
> simply proceed, as if the task is held at the target, along the
> escalating reset path.

The new libata-eh is used for more than just EH. It is used for device
probing, device revalidation, and power management. It is also woken for
all command failures and is where the request sense for ATAPI devices is
issued. Device revalidation following reset is also critical for ATA and
ATAPI devices. One example of this is some SATA/PATA converter chips
lose their DMA xfer settings following a reset and default to PIO mode
only. Any DMA transfer that is attempted simply hangs.

The other issue is PMP support. The more that gets pushed into libsas,
the more libsas needs to know about things such as PMP.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center



