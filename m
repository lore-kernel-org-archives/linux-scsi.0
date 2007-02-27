From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: end to end error recovery musings
Date: Mon, 26 Feb 2007 18:10:57 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:54499 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161043AbXB0BMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Feb 2007 20:12:07 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ric@emc.com, Alan <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>

On Monday, February 26, 2007 9:42 AM,  Ric Wheeler wrote:
> Which brings us back to a recent discussion at the file 
> system workshop on being 
> more repair oriented in file system design so we can survive 
> situations like 
> this a bit more reliably ;-)
> 

On the second day of the workshop, there was a presentation given by
Martin K. Petersen on  Data Intergrity Feature, which is also called
EEDP(End to End Data Protection), which he presented some
ideas/suggestions of adding an API in linux for this.   I have his
presentation if anyone is interested.  One thing is scsi mid layer needs
32 byte cdbs support.

mpt fusion supports EEDP for some versions of Fibre products, and we
plan to add this for next generation sas products.   We support EEDP in
the windows driver where the driver generates its own tags.  Our Linux
driver don't.

Here is our 32 byte passthru structure for SCSI_IO, defined in
mpi_init.h, which as you may notice has some tags and flags for EEDP.


typedef struct _MSG_SCSI_IO32_REQUEST
{
    U8                          Port;                           /* 00h
*/
    U8                          Reserved1;                      /* 01h
*/
    U8                          ChainOffset;                    /* 02h
*/
    U8                          Function;                       /* 03h
*/
    U8                          CDBLength;                      /* 04h
*/
    U8                          SenseBufferLength;              /* 05h
*/
    U8                          Flags;                          /* 06h
*/
    U8                          MsgFlags;                       /* 07h
*/
    U32                         MsgContext;                     /* 08h
*/
    U8                          LUN[8];                         /* 0Ch
*/
    U32                         Control;                        /* 14h
*/
    MPI_SCSI_IO32_CDB_UNION     CDB;                            /* 18h
*/
    U32                         DataLength;                     /* 38h
*/
    U32                         BidirectionalDataLength;        /* 3Ch
*/
    U32                         SecondaryReferenceTag;          /* 40h
*/
    U16                         SecondaryApplicationTag;        /* 44h
*/
    U16                         Reserved2;                      /* 46h
*/
    U16                         EEDPFlags;                      /* 48h
*/
    U16                         ApplicationTagTranslationMask;  /* 4Ah
*/
    U32                         EEDPBlockSize;                  /* 4Ch
*/
    MPI_SCSI_IO32_ADDRESS       DeviceAddress;                  /* 50h
*/
    U8                          SGLOffset0;                     /* 58h
*/
    U8                          SGLOffset1;                     /* 59h
*/
    U8                          SGLOffset2;                     /* 5Ah
*/
    U8                          SGLOffset3;                     /* 5Bh
*/
    U32                         Reserved3;                      /* 5Ch
*/
    U32                         Reserved4;                      /* 60h
*/
    U32                         SenseBufferLowAddr;             /* 64h
*/
    SGE_IO_UNION                SGL;                            /* 68h
*/
} MSG_SCSI_IO32_REQUEST, MPI_POINTER PTR_MSG_SCSI_IO32_REQUEST,
  SCSIIO32Request_t, MPI_POINTER pSCSIIO32Request_t;
