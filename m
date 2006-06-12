From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 6/6] libata: Add support for SATA attachment to SAS adapters
Date: Sun, 11 Jun 2006 23:33:49 -0400
Message-ID: <448CE09D.4060104@pobox.com>
References: <200606071626.k57GQ7ZS015584@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200606071626.k57GQ7ZS015584@d01av01.pok.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Brian King wrote:
> The following patch enhances libata to allow SAS device drivers
> to utilize libata to talk to SATA devices. It introduces some
> new APIs which allow libata to be used without allocating a
> virtual scsi host.
> 
> New APIs:
> 
> ata_sas_port_alloc - Allocate an ata_port 
> ata_sas_port_init - Initialize an ata_port (probe device, etc)
> ata_sas_port_destroy - Free an ata_port allocated by ata_sas_port_alloc
> ata_sas_slave_configure - configure scsi device
> ata_sas_queuecmd - queue a scsi command, similar to ata_scsi_queuecomand
> 
> These new APIs can be used either directly by a SAS LLDD or could be used
> by the SAS transport class. 
> 
> Possible usage for a SAS LLDD would be:
> 
> scsi_scan_host
> 	target_alloc
> 		ata_sas_port_alloc
> 	slave_alloc
> 		ata_sas_port_init
> 	slave_configure
> 		ata_sas_slave_configure
> 
> Commands received by the LLDD for SATA devices would call ata_sas_queuecmd.
> 
> Device teardown would occur with:
> 
> slave_destroy
> 	port_disable
> target_destroy
> 	ata_sas_port_destroy
> 
> Signed-off-by: Brian King <brking@us.ibm.com>

Overall, I am very wary of this patch.  Not for patch content reasons, 
but because we don't yet know how aic94xx or Broadcom SAS (both 
"software stack" SAS adapters) will interface to libata.

So, this is a reluctant ACK, because I fear that this may become an 
ipr-only API.  I'll ACK it, because we won't have any other SAS support 
for a while...   but this API must be revisited with more SAS+SATA 
controllers are supported.

In particular, we may need to make this API more generic:  remove all 
mention of "SAS", and simply create a libata API that supports 
situations where ata_host_set is not the toplevel object.

	Jeff


