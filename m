From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] shutdown processing
Date: Thu, 16 Feb 2006 09:58:33 +0100
Message-ID: <43F43EB9.40406@s5r6.in-berlin.de>
References: <20060215114605.1568c8cc.randy_d_dunlap@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060215114605.1568c8cc.randy_d_dunlap@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Cc: scsi <linux-scsi@vger.kernel.org>, ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy_d_dunlap@linux.intel.com>
> 
> Add ability for SCSI drivers to invoke a shutdown method.
> This allows drivers to make drives safe for shutdown/poweroff,
> for example.  Some drives need this to prevent possible problems.
> 
> Signed-off-by: Randy Dunlap <randy_d_dunlap@linux.intel.com>

Why are you calling these from SCSI? Wouldn't ahci_pci_driver.remove() 
and piix_pci_driver.remove() be a proper place to perform what you are 
doing in ata_device_shutdown?

[...]
>  EXPORT_SYMBOL_GPL(ata_device_suspend);
>  EXPORT_SYMBOL_GPL(ata_device_resume);
> +EXPORT_SYMBOL_GPL(ata_device_shutdown);
>  EXPORT_SYMBOL_GPL(ata_scsi_device_suspend);
>  EXPORT_SYMBOL_GPL(ata_scsi_device_resume);
> +EXPORT_SYMBOL_GPL(ata_scsi_device_shutdown);
[...]

Side note: If you would prepare the host template in libata, you 
wouldn't need to export these and other symbols. As was AFAIR discussed 
by other people before, libata could certainly hide scsi_host_template 
from ATA drivers entirely.
-- 
Stefan Richter
-=====-=-==- --=- =----
http://arcgraph.de/sr/
