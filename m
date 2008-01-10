From: Jeff Garzik <jeff@garzik.org>
Subject: Re: sata_nv does not function in kernel > 2.6.20.21
Date: Wed, 09 Jan 2008 23:40:47 -0500
Message-ID: <4785A1CF.7050006@garzik.org>
References: <20080110024733.GC9461@mhcomputing.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080110024733.GC9461@mhcomputing.net>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Hall <mhall@mhcomputing.net>
Cc: linux-scsi@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Matthew Hall wrote:
> ACPI: PCI Interrupt Link [LT3D] enabled at IRQ 46
> ACPI: PCI Interrupt 0000:80:07.0[A] -> Link [LT3D] -> GSI 46 (level,
> low) -> IRQ 46
> sata_nv 0000:80:07.0: Using ADMA mode
> PCI: Unable to reserve mem region #6:1000@dfefe000 for device
> 0000:80:07.0
> ACPI: PCI interrupt for device 0000:80:07.0 disabled
> sata_nv: probe of 0000:80:07.0 failed with error -16
> ACPI: PCI Interrupt Link [LT2E] enabled at IRQ 45
> ACPI: PCI Interrupt 0000:80:08.0[A] -> Link [LT2E] -> GSI 45 (level,
> low) -> IRQ 45
> sata_nv 0000:80:08.0: Using ADMA mode
> PCI: Unable to reserve mem region #6:1000@dfefd000 for device
> 0000:80:08.0
> ACPI: PCI interrupt for device 0000:80:08.0 disabled
> sata_nv: probe of 0000:80:08.0 failed with error -16

Error -16 is EBUSY, which causes the driver load to fail due to the 
"Unable to reserve mem region" message.

This means that the sata_nv driver needed to use PCI BAR 6, but was 
unable to for some reason.  Given that sata_nv uses devres like other 
libata drivers, IMO the likely cause is outside the ATA subsystem (PCI? 
ACPI?).

One workaround to try is setting sata_nv module option 'adma' to zero 
(0), in the hopes that it ignores that final region and work anyway.

	Jeff



