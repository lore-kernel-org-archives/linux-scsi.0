From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07.02 update
Date: Mon, 15 Nov 2004 19:42:21 -0500
Message-ID: <41994CED.4080204@pobox.com>
References: <91888D455306F94EBD4D168954A9457C3FFE19@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:48014 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261675AbUKPAmj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 19:42:39 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C3FFE19@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

Moore, Eric Dean wrote:
> On Monday, November 15, 2004 3:51 PM, James Bottomley wrote:
> 
> 
>>This isn't an exercise to expose all the layers in the 
>>transport, merely
>>to separate them out logically when it's useful to do so.  Thus, it
>>would make sense to expose the link layer separately only if something
>>other than a PHY were going to be using it.  If that's not the case,
>>then link transport parameters can be safely stashed in the PHY layer.
> 
> 
> I open to debate on this.  The link info is going to be providing properties
> between two phys.
> 
> 
>>Although really, the simplest way is a protocol to allow direct
>>attachment of a remote PHY (sort of like a variant of the 
>>scan interface
>>under the scsi_host class).
>>
> 
> 
> Would the "scan interface" be able to call the LLD drivers
> with a SAS Address?  Here is our SMP passthru struct:
> 
> typedef struct _MSG_SMP_PASSTHROUGH_REQUEST
> {
>     U8                      PassthroughFlags;   /* 00h */
>     U8                      PhysicalPort;       /* 01h */
>     U8                      ChainOffset;        /* 02h */
>     U8                      Function;           /* 03h */
>     U16                     RequestDataLength;  /* 04h */
>     U8                      ConnectionRate;     /* 06h */
>     U8                      MsgFlags;           /* 07h */
>     U32                     MsgContext;         /* 08h */
>     U32                     Reserved1;          /* 0Ch */
>     U64                     SASAddress;         /* 10h */
>     U32                     Reserved2;          /* 18h */
>     U32                     Reserved3;          /* 1Ch */
>     SGE_SIMPLE_UNION        SGL;                /* 20h */
> } MSG_SMP_PASSTHROUGH_REQUEST, MPI_POINTER PTR_MSG_SMP_PASSTHROUGH_REQUEST,
>   SmpPassthroughRequest_t, MPI_POINTER pSmpPassthroughRequest_t;


Overall, what is needed is 'host control', which can include device 
topology manipulation.


> Our firmware does the SATA to SCSI translation.  Thus to the device driver
> all devices in SAS domain look like SCSI devices.  Does SG_IO have
> capability in sending a SATA/IDE Task Frame encapsulated in 
> a FIS to a SCSI LLD?  I believe the SG_IO would end up calling 
> the sh->queuecommand entry point via scsi mid layer. The input to
> the LLD is struct scsi_cmnd, passing a SCSI cdb[16].  I don't see
> a FIS in struct scsi_cmnd.  I guess if that is the plan, we would
> need to add FIS in this structure, and the LLDs would need to differentiate
> SATA from SCSI commands.

ATA passthru CDB is specified in
http://www.t10.org/ftp/t10/document.04/04-262r6.pdf

This is what libata uses.

	Jeff


