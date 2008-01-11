From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: sata_nv does not function in kernel > 2.6.20.21
Date: Fri, 11 Jan 2008 15:17:58 +0000
Message-ID: <20080111151758.1d702b50@lxorguk.ukuu.org.uk>
References: <20080110024733.GC9461@mhcomputing.net>
	<4785A1CF.7050006@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4785A1CF.7050006@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Hall <mhall@mhcomputing.net>, linux-scsi@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Error -16 is EBUSY, which causes the driver load to fail due to the 
> "Unable to reserve mem region" message.
> 
> This means that the sata_nv driver needed to use PCI BAR 6, but was 
> unable to for some reason.  Given that sata_nv uses devres like other 
> libata drivers, IMO the likely cause is outside the ATA subsystem (PCI? 
> ACPI?).

Actually it looks to me like there is something very odd going on here.
The sata_nv code checks each of the 6 resources exists (wrongly - it does
it before pcim_enable_device so the check is probably not valid). That
would report -ENODEV.

EBUSY implies all 6 resources were assigned but one couldn't be mapped.
