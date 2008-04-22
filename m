From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: MPTSAS: ("activate status led" | "find disc") in external enclosure
Date: Tue, 22 Apr 2008 09:44:32 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229FFECC9@NAMAIL2.ad.lsil.com>
References: <20080422091837.12790125.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:38409 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787AbYDVPos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Apr 2008 11:44:48 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080422091837.12790125.taeuber@bbaw.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday, April 22, 2008 1:19 AM, Lars T=E4uber wrote: =20

> So this will never work for the SATA discs in our enclosure,=20
> right? Or is there a chance with asking LSI to do something=20
> in their firmware?
>=20
> Seems I have no chance to get to know which slot contains the=20
> failed drive without a shutdown. Bad luck.
>=20

If you want to upgrade your controller fw, I need the contents of all t=
he attributes in /sys/class/scsi_host/host#.  Just yesterday we got War=
ner Wakko upgraded, and I believe it might of solved his problems.   I'=
m not sure what problems your experiencing, as this thread has been har=
d to follow.

I would like to point out there is a firmware request for sending SEP r=
equest, for instance setting LEDS.   Here is a copy of the structure.  =
We call this function to set LED when there is SMART errors (for non-ra=
id devices).  For RAID, the firmware handles it.   Is this what your lo=
oking for?

=46unction =3D MPI_FUNCTION_SCSI_ENCLOSURE_PROCESSOR:

typedef struct _MSG_SEP_REQUEST
{
    U8                      TargetID;           /* 00h */
    U8                      Bus;                /* 01h */
    U8                      ChainOffset;        /* 02h */
    U8                      Function;           /* 03h */
    U8                      Action;             /* 04h */
    U8                      Flags;              /* 05h */
    U8                      Reserved1;          /* 06h */
    U8                      MsgFlags;           /* 07h */
    U32                     MsgContext;         /* 08h */
    U32                     SlotStatus;         /* 0Ch */
    U32                     Reserved2;          /* 10h */
    U32                     Reserved3;          /* 14h */
    U32                     Reserved4;          /* 18h */
    U16                     Slot;               /* 1Ch */
    U16                     EnclosureHandle;    /* 1Eh */
} MSG_SEP_REQUEST, MPI_POINTER PTR_MSG_SEP_REQUEST,
  SEPRequest_t, MPI_POINTER pSEPRequest_t;

/* Action defines */
#define MPI_SEP_REQ_ACTION_WRITE_STATUS                 (0x00)
#define MPI_SEP_REQ_ACTION_READ_STATUS                  (0x01)

/* Flags defines */
#define MPI_SEP_REQ_FLAGS_ENCLOSURE_SLOT_ADDRESS        (0x01)
#define MPI_SEP_REQ_FLAGS_BUS_TARGETID_ADDRESS          (0x00)

/* SlotStatus bits for MSG_SEP_REQUEST */
#define MPI_SEP_REQ_SLOTSTATUS_NO_ERROR                 (0x00000001)
#define MPI_SEP_REQ_SLOTSTATUS_DEV_FAULTY               (0x00000002)
#define MPI_SEP_REQ_SLOTSTATUS_DEV_REBUILDING           (0x00000004)
#define MPI_SEP_REQ_SLOTSTATUS_IN_FAILED_ARRAY          (0x00000008)
#define MPI_SEP_REQ_SLOTSTATUS_IN_CRITICAL_ARRAY        (0x00000010)
#define MPI_SEP_REQ_SLOTSTATUS_PARITY_CHECK             (0x00000020)
#define MPI_SEP_REQ_SLOTSTATUS_PREDICTED_FAULT          (0x00000040)
#define MPI_SEP_REQ_SLOTSTATUS_UNCONFIGURED             (0x00000080)
#define MPI_SEP_REQ_SLOTSTATUS_HOT_SPARE                (0x00000100)
#define MPI_SEP_REQ_SLOTSTATUS_REBUILD_STOPPED          (0x00000200)
#define MPI_SEP_REQ_SLOTSTATUS_REQ_CONSISTENCY_CHECK    (0x00001000)
#define MPI_SEP_REQ_SLOTSTATUS_DISABLE                  (0x00002000)
#define MPI_SEP_REQ_SLOTSTATUS_REQ_RESERVED_DEVICE      (0x00004000)
#define MPI_SEP_REQ_SLOTSTATUS_IDENTIFY_REQUEST         (0x00020000)
#define MPI_SEP_REQ_SLOTSTATUS_REQUEST_REMOVE           (0x00040000)
#define MPI_SEP_REQ_SLOTSTATUS_REQUEST_INSERT           (0x00080000)
#define MPI_SEP_REQ_SLOTSTATUS_DO_NOT_MOVE              (0x00400000)
#define MPI_SEP_REQ_SLOTSTATUS_ACTIVE                   (0x00800000)
#define MPI_SEP_REQ_SLOTSTATUS_B_ENABLE_BYPASS          (0x04000000)
#define MPI_SEP_REQ_SLOTSTATUS_A_ENABLE_BYPASS          (0x08000000)
#define MPI_SEP_REQ_SLOTSTATUS_DEV_OFF                  (0x10000000)
#define MPI_SEP_REQ_SLOTSTATUS_SWAP_RESET               (0x80000000)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
