From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07.02 update
Date: Mon, 15 Nov 2004 17:11:08 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C3FFE19@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33746 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261726AbUKPALZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 19:11:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@suse.de>

On Monday, November 15, 2004 3:51 PM, James Bottomley wrote:

> This isn't an exercise to expose all the layers in the 
> transport, merely
> to separate them out logically when it's useful to do so.  Thus, it
> would make sense to expose the link layer separately only if something
> other than a PHY were going to be using it.  If that's not the case,
> then link transport parameters can be safely stashed in the PHY layer.

I open to debate on this.  The link info is going to be providing properties
between two phys.

> Although really, the simplest way is a protocol to allow direct
> attachment of a remote PHY (sort of like a variant of the 
> scan interface
> under the scsi_host class).
> 

Would the "scan interface" be able to call the LLD drivers
with a SAS Address?  Here is our SMP passthru struct:

typedef struct _MSG_SMP_PASSTHROUGH_REQUEST
{
    U8                      PassthroughFlags;   /* 00h */
    U8                      PhysicalPort;       /* 01h */
    U8                      ChainOffset;        /* 02h */
    U8                      Function;           /* 03h */
    U16                     RequestDataLength;  /* 04h */
    U8                      ConnectionRate;     /* 06h */
    U8                      MsgFlags;           /* 07h */
    U32                     MsgContext;         /* 08h */
    U32                     Reserved1;          /* 0Ch */
    U64                     SASAddress;         /* 10h */
    U32                     Reserved2;          /* 18h */
    U32                     Reserved3;          /* 1Ch */
    SGE_SIMPLE_UNION        SGL;                /* 20h */
} MSG_SMP_PASSTHROUGH_REQUEST, MPI_POINTER PTR_MSG_SMP_PASSTHROUGH_REQUEST,
  SmpPassthroughRequest_t, MPI_POINTER pSmpPassthroughRequest_t;


> > (3) SATA Drives in SAS topology - STP/SATA Passthru 
> Protocal need to report
> > such
> > things as SMART DATA, Identify DATA, etc.   This is address 
> by target, bus,
> > channel.
> > How SATA/IDE info be made available to upper transport layers?
> 
> surely if we have a SATA device at the end (even if we reach the end
> point traversing a SAS domain) then you simply use SG_IO to transport
> the device native commands and the HBA does the correct thing for
> encapsulation.
> 

Our firmware does the SATA to SCSI translation.  Thus to the device driver
all devices in SAS domain look like SCSI devices.  Does SG_IO have
capability in sending a SATA/IDE Task Frame encapsulated in 
a FIS to a SCSI LLD?  I believe the SG_IO would end up calling 
the sh->queuecommand entry point via scsi mid layer. The input to
the LLD is struct scsi_cmnd, passing a SCSI cdb[16].  I don't see
a FIS in struct scsi_cmnd.  I guess if that is the plan, we would
need to add FIS in this structure, and the LLDs would need to differentiate
SATA from SCSI commands.

Here is our SATA/STP passthru struct:


typedef struct _MSG_SATA_PASSTHROUGH_REQUEST
{
    U8                      TargetID;           /* 00h */
    U8                      Bus;                /* 01h */
    U8                      ChainOffset;        /* 02h */
    U8                      Function;           /* 03h */
    U16                     PassthroughFlags;   /* 04h */
    U8                      ConnectionRate;     /* 06h */
    U8                      MsgFlags;           /* 07h */
    U32                     MsgContext;         /* 08h */
    U32                     Reserved1;          /* 0Ch */
    U32                     Reserved2;          /* 10h */
    U32                     Reserved3;          /* 14h */
    U32                     DataLength;         /* 18h */
    U8                      CommandFIS[20];     /* 1Ch */
    SGE_SIMPLE_UNION        SGL;                /* 30h */
} MSG_SATA_PASSTHROUGH_REQUEST, MPI_POINTER
PTR_MSG_SATA_PASSTHROUGH_REQUEST,
  SataPassthroughRequest_t, MPI_POINTER pSataPassthroughRequest_t; 
