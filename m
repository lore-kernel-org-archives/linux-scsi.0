From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] 2.4.25-pre4 SCSI fusion driver
Date: Fri, 9 Jan 2004 16:59:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703A758B5@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:5331 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264485AbUAIV7r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2004 16:59:47 -0500
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose@wanadoo.es>, linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>

There is a newer driver source available for 2.4 kernel.
Its version 2.05.11, located in the usual place
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.05.11

I have not had time to create a patch against the latest 2.4.25-pre kernel.

Eric Moore

> -----Original Message-----
> From: Xose Vazquez Perez [mailto:xose@wanadoo.es]
> Sent: Friday, January 09, 2004 8:51 AM
> To: linux-scsi; Tosatti; Eric Dean Moore
> Subject: [PATCH] 2.4.25-pre4 SCSI fusion driver
> 
> 
> hi,
> 
> This driver was sent last month by its maintainer, Eric Dean
> Moore <Emoore@lsil.com>. It was not updated because James
> said that this patch should be applied to 2.6 first, but 2.6
> has a different driver. So , trying again.
> 
> yes, fusion has more bugs. But this is the first step ;-)
> 
> -thanks-
> 
> Changes since 2.05.05 release {04-14-2003}
> 
> 
> (1)     Check SCSI Port Page 2 DV bits to either
> disable DV or limit DV to Inquiry only checks.
> 
> (2)     Added sequence to allow the ID of a SAF-TE
> device to be stored in IOC Page 4.
> 
> (3)     The driver now checks NVRAM data and performs Level 1 Domain
> Validation only if requested.  This limitation can be set on a
> per-device basis via the LSI Configuration Utility.
> 
> (4)     The IOC Page 4 read is now done after the SCSI Port Settings
> and the SCSI Device Page Headers are obtained.
> 
> (5)     The return code from pci_map_sg is checked and a FAILED
> status is returned if the return code indicates that a failure
> occurred, as Scatter/Gather entries are being obtained.
> 
> (6)     If IOCStatus of MPI_IOCSTATUS_STATUS_RESIDUAL_MISMATCH
> is received, an error status is returned to the SCSI layer.
> This status is received when the Fibre Channel firmware detects
> a CRC error during a data transfer.
> 
> (7)     If the SCSI layer request an abort or bus reset for an
> IO that is not currently running, an error status is returned
> and the scsi_done call is not performed.  This prevents problems
> when the IO has completed before the abort or bus reset is received.
> 
> (8)     In a mixed device configuration (Ultra 320 and Non-Ultra
> 320 devices are present on an HBA channel), code was fixed to prevent
>  negotiating for QAS on all Ultra 320 devices on that channel.
> This keeps the Ultra 320 devices from dominating the SCSI bus,
> preventing Non-Ultra 320 IOs from executing.
> 
> (9)     The SenseBufferLength field is properly set when an IOCTL
> IO is processed.  This allows sense data to be obtained and returned
> to the application if a Check Condition occurs on the IO.
> 
> (10)    Zero out unused CDB field on SCSI IO commands.
> 
