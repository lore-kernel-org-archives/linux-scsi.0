From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: FW: [PATCH] 2.4.25-pre4 SCSI fusion driver
Date: Wed, 14 Jan 2004 11:27:17 -0200 (BRST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58L.0401141125380.3535@logos.cnet>
References: <0E3FA95632D6D047BA649F95DAB60E5703A758C4@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from intra.cyclades.com ([64.186.161.6]:5533 "EHLO
	intra.cyclades.com") by vger.kernel.org with ESMTP id S266319AbUANN3c
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 08:29:32 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703A758C4@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Xose Vazquez Perez <xose@wanadoo.es>, linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>


Hi Eric,

I have a few comments:

- You change CONFIG_SMP to __SMP__. __SMP__ is deprecated, dont do it.
- You add a header file without GPL statement
- You add CONFIG_COMPAT #ifdef's. What is CONFIG_COMPAT? AFAIK it is not
present in 2.4 kernels.

On Fri, 9 Jan 2004, Moore, Eric Dean wrote:

> Here's a patch for mpt fusion version 2.5.11 driver.
> Thankyou Xose for creating the patch.
>
> - Changes For Version 02.05.11 against kernel 2.4.25-pre4
> driver(02.05.05+)
>
>    The driver now supports up 256 Luns per device Id.
>
>    The Maximum Outstanding Split Transactions (MOST) is set to
>  1 for the
>    919X and 929X chips.  This prevents a possible data corruption
>    situation when using those chips.
>
>    The ReqToChain fields are now properly set via a loop using
>  a defined
>    value rather than a memset function call during adapter structure
>    initialization. This prevents a panic situation seen on an Opteron
>    x86_64 system.
>
>    If a data underrun condition exists and the amount of data
>  transferred
>    is less than the command?s underflow amount, an error
>  status is returned
>    rather than a good status.  This prevents a false good
>  status from being
>    returned and allows the upper SCSI layer to retry the
>  command if needed.
>
>    A "for" loop replaces a "while" loop during adapter detection. This
>    prevents a possible infinite loop during initialization.
>
>    A generic compatible ioctl interface replaces a sparc
>  specific interface,
>    to allow a fuller range of systems to work with the ioctl interface.
>    The sys_ioctl linkage is now used.  The ioctl interface is
>  now properly
>    unregistered if a failure occurs during ioctl initialization. This
>    prevents a possible panic situation.
>
>    Performance enhancements were made.
>
>    Check SCSI Port Page 2 DV bits to either disable DV or limit DV to
>    Inquiry only checks.
>
>    Added sequence to allow the ID of a SAF-TE device to be stored in
>    IOC Page 4.
>
>    The driver now checks NVRAM data and performs Level 1 Domain
>    Validation only if requested.  This limitation can be set on a
>    per-device basis via the LSI Configuration Utility.
>
>    The IOC Page 4 read is now done after the SCSI Port Settings
>    and the SCSI Device Page Headers are obtained.
>
>    The return code from pci_map_sg is checked and a FAILED
>    status is returned if the return code indicates that a failure
>    occurred, as Scatter/Gather entries are being obtained.
>
>    If IOCStatus of MPI_IOCSTATUS_STATUS_RESIDUAL_MISMATCH
>    is received, an error status is returned to the SCSI layer.
>    This status is received when the Fibre Channel firmware detects
>    a CRC error during a data transfer.
>
>    If the SCSI layer request an abort or bus reset for an
>    IO that is not currently running, an error status is returned
>    and the scsi_done call is not performed.  This prevents problems
>    when the IO has completed before the abort or bus reset is received.
>
>    In a mixed device configuration (Ultra 320 and Non-Ultra
>    320 devices are present on an HBA channel), code was fixed
>  to prevent
>    negotiating for QAS on all Ultra 320 devices on that channel.
>    This keeps the Ultra 320 devices from dominating the SCSI bus,
>    preventing Non-Ultra 320 IOs from executing.
>
>    The SenseBufferLength field is properly set when an IOCTL
>    IO is processed.  This allows sense data to be obtained and returned
>    to the application if a Check Condition occurs on the IO.
>
>    Zero out unused CDB field on SCSI IO commands.
>
>
