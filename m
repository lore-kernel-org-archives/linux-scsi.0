From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [RFC][PATCH]SCSI signal(I/O) failure causes no response
Date: Wed, 14 Apr 2004 11:56:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570442C1B2@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23250 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263663AbUDNP4Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Apr 2004 11:56:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

For this particular issue, Mr Masao Fukuchi has a
scsi bus test analyzer, in which he set the C/D signal 
to low during read operation.  The MPT firmware
returned MPI_IOCSTATUS_SCSI_PROTOCAL_ERROR, which from
the mpt manual means " An unrecoverable bus protocal error
as terminated the SCSI I/O" and the driver will 
return DID_RESET.

Here are some of the other cases which return
DID_RESET, however I doubt were returned with 
Mr Masao Fukuchi's test anaylzer:

MPI_IOCSTATUS_SCSI_TASK_TERMINATED
MPI_IOCSTATUS_SCSI_IOC_TERMINATED
MPI_IOCSTATUS_SCSI_EXT_TERMINATED



On Wednesday, April 14, 2004 9:28 AM, James Bottomley wrote:

> 
> 
> On Tue, 2004-04-13 at 20:07, Masao Fukuchi wrote:
> > 1.Fusion MPT driver issues read command to its firmware.
> >   (our server has LSI53C1030 as SCSI adapter)
> >   Then the firmware returns protocol error for the command.
> >   Fusion MPT driver makes DID_RESET status by protocol error 
> >   and sends it to SCSI midlayer.
> > 
> > 2.SCSI midlayer analyzes the status from LLD.
> >   SCSI midlayer schedules command retry because the status is just
> >   DID_RESET status.
> >   (When the status has DID_RESET plus some sense code, the retry
> >    sequence depends on the sense code. But when the status has only
> >    DID_RESET, SCSI midlayer schedules command retry)
> > 
> > Sequence 1. and 2. are repeated infinitely and it causes no 
> response.
> > 
> > To prevent this problem, I proposed Eric Moore to change 
> the DID_RESET
> > status to DID_SOFT_ERROR in fusion MPT driver.
> > But he suggested me to change SCSI midlayer to prevent 
> infinite loop.
> 
> Well, there clearly is a problem, because we can't retry no-rety
> commands that return DID_RESET (like tape commands or fastfail).
> 
> However, DID_RESET is supposed to be returned for events where it was
> determined that the command was lost because the bus or 
> device was reset
> (either as part of error handling or because an external entity issued
> the reset).  Since these events, if they originate externally, can be
> beyond the control of the device, making retryable commands subject to
> the retry limit would be asking for unnecessary I/O errors because of
> something we couldn't do anything about.
> 
> Why is the LSI driver returning DID_RESET for the problem (i.e. is it
> some type of external bus reset, or is something else going on)?
> 
> James
> 
> 
