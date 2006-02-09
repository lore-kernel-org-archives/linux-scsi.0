From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 09/15] libata: Improved ata_exec_internal timeout handling
Date: Thu, 09 Feb 2006 02:21:21 -0500
Message-ID: <43EAED71.5080405@pobox.com>
References: <200602061542.k16FgYf0002182@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200602061542.k16FgYf0002182@d01av01.pok.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: brking@us.ibm.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

brking@us.ibm.com wrote:
> Currently ata_exec_internal does very minimal cleanup if
> the executing command times out. This works for most usage
> scenarios, but can cause problems for hosts that set
> ATA_FLAG_PIO_DMA. For these users, the DMA buffer gets unmapped
> while the timed out out command is still active, which has
> the potential to cause PCI DMA errors if the command is
> still in progress. The following patch modifies ata_exec_internal
> to invoke eng_timeout on a timeout to allow for the timed out
> command to be cleaned up better before proceeding further.
> This patch is also in preparation for SAS attached SATA devices.
> 
> Signed-off-by: Brian King <brking@us.ibm.com>

Really this sort of thing is definitely changing an area that Tejun is 
also changing pretty heavily...

	Jeff



