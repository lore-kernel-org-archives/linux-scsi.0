From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Fri, 1 Oct 2004 23:04:17 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0410012253460.3951@poirot.grange>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange>
 <20040904140102.A15247@infradead.org> <Pine.LNX.4.60.0409050022570.3092@poirot.grange>
 <20040904233835.A18659@infradead.org> <Pine.LNX.4.60.0409051654460.3039@poirot.grange>
 <1094398979.10977.9.camel@mulgrave> <20040905173134.A31521@infradead.org>
 <1094422949.10977.15.camel@mulgrave> <Pine.LNX.4.60.0409061042240.6252@poirot.grange>
 <Pine.LNX.4.60.0409061143020.8550@poirot.grange> <20040906110150.A4845@infradead.org>
 <Pine.LNX.4.60.0409061400560.1676@poirot.grange>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1279876653-1096664082=:3951"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:704 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S266867AbUJAWU7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2004 18:20:59 -0400
In-Reply-To: <Pine.LNX.4.60.0409061400560.1676@poirot.grange>
Content-ID: <Pine.LNX.4.60.0410012300250.3951@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1279876653-1096664082=:3951
Content-Type: TEXT/PLAIN; CHARSET=koi8-r; FORMAT=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.60.0410012300251.3951@poirot.grange>

Re-sending the long-outstanding patch.

On Mon, 6 Sep 2004, Guennadi Liakhovetski wrote:

> On Mon, 6 Sep 2004, Christoph Hellwig wrote:
>
>> Patch looks good to me.  Two hints for a possible followon patch:
>>=20
>>> @@ -1552,15 +1520,11 @@
>>>  =09    pDCB->Inquiry7 =3D ptr->Flags;
>>>=20
>>>  ckc_e:
>>=20
>> Here we still have some INQUIRY snooping, and if you look how
>> ptr is set you'll see it'll OOPS for machines with more than 1GB of=20
>> memory.
>
> Right. Will think about a fix, thanks.

Will follow in a separate patch.

>>> -=09dc390_updateDCB(pACB, pDCB);
>>> +=09if (pDCB->DevMode & SYNC_NEGO_)
>>> +=09=09pDCB->SyncMode |=3D SYNC_ENABLE;
>>> +=09else {
>>> +=09=09pDCB->SyncMode =3D 0;
>>=20
>> pDCB is memset to 0 =E5t the start of the function, so the 0 initializat=
ion
>> here isn't nessecary strictly speaking.
>
> Well, a few lines above on a multi-LUN device for LUN > 0 it will be set =
from=20
> LUN 0:
>
>                pDCB->SyncMode =3D pDCB2->SyncMode & SYNC_NEGO_DONE;
>
> so, purely theoretically it could be non-zero at that point, at least, th=
at's=20
> why I put
>
>                pDCB->SyncMode =3D 0;
>
> there. But, DevMode is set from LUN 0, so, yes, you are right.

I am not sure any more if my analysis above is correct, so, I'd retain the=
=20
explicit "=3D 0" for now.

Thanks
Guennadi
---
Guennadi Liakhovetski


Use mid-layer's decision wrt tag-support.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -u a/drivers/scsi/scsiiom.c b/drivers/scsi/scsiiom.c
--- a/drivers/scsi/scsiiom.c=0917 Aug 2004 21:16:53
+++ b/drivers/scsi/scsiiom.c=096 Sep 2004 09:32:53
@@ -8,9 +8,9 @@
  static void __inline__
  dc390_freetag (struct dc390_dcb* pDCB, struct dc390_srb* pSRB)
  {
-=09if (pSRB->TagNumber < 255) {
+=09if (pSRB->TagNumber !=3D SCSI_NO_TAG) {
  =09=09pDCB->TagMask &=3D ~(1 << pSRB->TagNumber);   /* free tag mask */
-=09=09pSRB->TagNumber =3D 255;
+=09=09pSRB->TagNumber =3D SCSI_NO_TAG;
  =09}
  }

@@ -69,7 +69,7 @@
      /* Change 99/05/31: Don't use tags when not disconnecting (BUSY) */
      if ((pDCB->SyncMode & EN_TAG_QUEUEING) && disc_allowed)
        {
-=09u8 tag_no =3D 0;
+=09s8 tag_no =3D 0;
  =09while ((1 << tag_no) & pDCB->TagMask) tag_no++;
  =09if (tag_no >=3D sizeof (pDCB->TagMask)*8 || tag_no >=3D pDCB->MaxComma=
nd) {
  =09=09printk (KERN_WARNING "DC390: Out of tags for Dev. %02x %02x\n", pDC=
B->TargetID, pDCB->TargetLUN);=20
@@ -604,7 +604,7 @@
  }

  static struct dc390_srb*
-dc390_MsgIn_QTag (struct dc390_acb* pACB, struct dc390_dcb* pDCB, u8 tag)
+dc390_MsgIn_QTag (struct dc390_acb* pACB, struct dc390_dcb* pDCB, s8 tag)
  {
    struct dc390_srb* lastSRB =3D pDCB->pGoingLast;
    struct dc390_srb* pSRB =3D pDCB->pGoingSRB;
@@ -1291,49 +1291,6 @@
      DC390_write8 (ScsiCmd, MSG_ACCEPTED_CMD);=09/* ;to release the /ACK s=
ignal */
  }

-static u8 __inline__
-dc390_tagq_blacklist (char* name)
-{
-   u8 i;
-   for(i=3D0; i<BADDEVCNT; i++)
-     if (memcmp (name, dc390_baddevname1[i], 28) =3D=3D 0)
-=09return 1;
-   return 0;
-}
-=20
-
-static void=20
-dc390_disc_tagq_set (struct dc390_dcb* pDCB, PSCSI_INQDATA ptr)
-{
-   /* Check for SCSI format (ANSI and Response data format) */
-   if ( (ptr->Vers & 0x07) >=3D 2 || (ptr->RDF & 0x0F) =3D=3D 2 )
-   {
-=09if ( (ptr->Flags & SCSI_INQ_CMDQUEUE) &&
-=09    (pDCB->DevMode & TAG_QUEUEING_) &&
-=09    /* ((pDCB->DevType =3D=3D TYPE_DISK)=20
-=09=09|| (pDCB->DevType =3D=3D TYPE_MOD)) &&*/
-=09    !dc390_tagq_blacklist (((char*)ptr)+8) )
-=09  {
-=09     if (pDCB->MaxCommand =3D=3D1) pDCB->MaxCommand =3D pDCB->pDCBACB->=
TagMaxNum;
-=09     pDCB->SyncMode |=3D EN_TAG_QUEUEING /* | EN_ATN_STOP */;
-=09     //pDCB->TagMask =3D 0;
-=09  }
-=09else
-=09     pDCB->MaxCommand =3D 1;
-     }
-}
-
-
-static void=20
-dc390_add_dev (struct dc390_acb* pACB, struct dc390_dcb* pDCB, PSCSI_INQDA=
TA ptr)
-{
-   u8 bval1 =3D ptr->DevType & SCSI_DEVTYPE;
-   pDCB->DevType =3D bval1;
-   /* if (bval1 =3D=3D TYPE_DISK || bval1 =3D=3D TYPE_MOD) */
-=09dc390_disc_tagq_set (pDCB, ptr);
-}
-
-
  static void __inline__
  dc390_RequestSense(struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct=
 dc390_srb* pSRB)
  {
@@ -1544,15 +1501,11 @@
  =09    pDCB->Inquiry7 =3D ptr->Flags;

  ckc_e:
-    if( pcmd->cmnd[0] =3D=3D INQUIRY &&=20
-=09(pcmd->result =3D=3D (DID_OK << 16) || status_byte(pcmd->result) & CHEC=
K_CONDITION) )
-     {
-=09if ((ptr->DevType & SCSI_DEVTYPE) !=3D TYPE_NODEV)
-=09  {
-=09     /* device found: add */=20
-=09     dc390_add_dev (pACB, pDCB, ptr);
-=09  }
-     }
+    if (pcmd->cmnd[0] =3D=3D INQUIRY &&=20
+=09(pcmd->result =3D=3D (DID_OK << 16) || status_byte(pcmd->result) & CHEC=
K_CONDITION) &&
+=09(ptr->DevType & SCSI_DEVTYPE) !=3D TYPE_NODEV)
+=09/* device found: add */=20
+=09pDCB->DevType =3D ptr->DevType & SCSI_DEVTYPE;

      pcmd->resid =3D pcmd->request_bufflen - pSRB->TotalXferredLen;

diff -u a/drivers/scsi/tmscsim.h b/drivers/scsi/tmscsim.h
--- a/drivers/scsi/tmscsim.h=0917 Aug 2004 21:16:53
+++ b/drivers/scsi/tmscsim.h=096 Sep 2004 09:33:08
@@ -62,7 +62,7 @@
  u8=09=09TargetStatus;

  u8=09=09ScsiPhase;
-u8=09=09TagNumber;
+s8=09=09TagNumber;
  u8=09=09SGIndex;
  u8=09=09SGcount;

diff -u a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c=093 Sep 2004 22:10:14
+++ b/drivers/scsi/tmscsim.c=096 Sep 2004 09:33:59
@@ -242,6 +242,7 @@
  #include <scsi/scsi_device.h>
  #include <scsi/scsi_host.h>
  #include <scsi/scsicam.h>
+#include <scsi/scsi_tcq.h>


  #define DC390_BANNER "Tekram DC390/AM53C974"
@@ -277,8 +278,6 @@
  static void dc390_EnableMsgOut_Abort(struct dc390_acb*, struct dc390_srb*=
);
  static irqreturn_t do_DC390_Interrupt( int, void *, struct pt_regs *);

-static void   dc390_updateDCB (struct dc390_acb* pACB, struct dc390_dcb* p=
DCB);
-
  static u32=09dc390_laststatus =3D 0;
  static u8=09dc390_adapterCnt =3D 0;

@@ -343,12 +342,6 @@
         };
  #endif

-/* Devices erroneously pretending to be able to do TagQ */
-static u8  dc390_baddevname1[2][28] =3D{
-       "SEAGATE ST3390N         9546",
-       "HP      C3323-300       4269"};
-#define BADDEVCNT=092
-
  static u8  dc390_eepromBuf[MAX_ADAPTER_NUM][EE_LEN];
  static u8  dc390_clock_period1[] =3D {4, 5, 6, 7, 8, 10, 13, 20};
  static u8  dc390_clock_speed[] =3D {100,80,67,57,50, 40, 31, 20};
@@ -648,7 +641,7 @@
  =09srb->SGToBeXferLen =3D 0;
  =09srb->ScsiPhase =3D 0;
  =09srb->EndMessage =3D 0;
-=09srb->TagNumber =3D 255;
+=09srb->TagNumber =3D SCSI_NO_TAG;

  =09if (dc390_StartSCSI(acb, dcb, srb)) {
  =09=09dc390_Waiting_insert(dcb, srb);
@@ -825,35 +818,6 @@

  #include "scsiiom.c"

-/***********************************************************************
- * Function : static void dc390_updateDCB()
- *
- * Purpose :  Set the configuration dependent DCB parameters
- ***********************************************************************/
-
-static void dc390_updateDCB (struct dc390_acb* pACB, struct dc390_dcb* pDC=
B)
-{
-  pDCB->SyncMode &=3D EN_TAG_QUEUEING | SYNC_NEGO_DONE /*| EN_ATN_STOP*/;
-  if (pDCB->DevMode & TAG_QUEUEING_) {
-=09//if (pDCB->SyncMode & EN_TAG_QUEUEING) pDCB->MaxCommand =3D pACB->TagM=
axNum;
-  } else {
-=09pDCB->SyncMode &=3D ~EN_TAG_QUEUEING;
-=09pDCB->MaxCommand =3D 1;
-  }
-
-  if( pDCB->DevMode & SYNC_NEGO_ )
-=09pDCB->SyncMode |=3D SYNC_ENABLE;
-  else {
-=09pDCB->SyncMode &=3D ~(SYNC_NEGO_DONE | SYNC_ENABLE);
-=09pDCB->SyncOffset &=3D ~0x0f;
-  }
-
-  //if (! (pDCB->DevMode & EN_DISCONNECT_)) pDCB->SyncMode &=3D ~EN_ATN_ST=
OP;=20
-
-  pDCB->CtrlR1 =3D pACB->pScsiHost->this_id;
-  if( pDCB->DevMode & PARITY_CHK_ )
-=09pDCB->CtrlR1 |=3D PARITY_ERR_REPO;
-}

  /**
   * dc390_slave_alloc - Called by the scsi mid layer to tell us about a ne=
w
@@ -894,7 +858,7 @@
  =09 */
  =09if (lun && (pDCB2 =3D dc390_findDCB(pACB, id, 0))) {
  =09=09pDCB->DevMode =3D pDCB2->DevMode;
-=09=09pDCB->SyncMode =3D pDCB2->SyncMode;
+=09=09pDCB->SyncMode =3D pDCB2->SyncMode & SYNC_NEGO_DONE;
  =09=09pDCB->SyncPeriod =3D pDCB2->SyncPeriod;
  =09=09pDCB->SyncOffset =3D pDCB2->SyncOffset;
  =09=09pDCB->NegoPeriod =3D pDCB2->NegoPeriod;
@@ -915,7 +879,16 @@
  =09=09=09pDCB->CtrlR4 |=3D NEGATE_REQACKDATA | NEGATE_REQACK;
  =09}

-=09dc390_updateDCB(pACB, pDCB);
+=09if (pDCB->DevMode & SYNC_NEGO_)
+=09=09pDCB->SyncMode |=3D SYNC_ENABLE;
+=09else {
+=09=09pDCB->SyncMode =3D 0;
+=09=09pDCB->SyncOffset &=3D ~0x0f;
+=09}
+
+=09pDCB->CtrlR1 =3D pACB->pScsiHost->this_id;
+=09if (pDCB->DevMode & PARITY_CHK_)
+=09=09pDCB->CtrlR1 |=3D PARITY_ERR_REPO;

  =09pACB->scan_devices =3D 1;
  =09scsi_device->hostdata =3D pDCB;
@@ -963,10 +936,16 @@
  =09pACB->DCBCnt--;
  }

-static int dc390_slave_configure(struct scsi_device *scsi_device)
+static int dc390_slave_configure(struct scsi_device *sdev)
  {
-=09struct dc390_acb* pACB =3D (struct dc390_acb*) scsi_device->host->hostd=
ata;
-=09pACB->scan_devices =3D 0;
+=09struct dc390_acb *acb =3D (struct dc390_acb *)sdev->host->hostdata;
+=09struct dc390_dcb *dcb =3D (struct dc390_dcb *)sdev->hostdata;
+
+=09acb->scan_devices =3D 0;
+=09if (sdev->tagged_supported && (dcb->DevMode & TAG_QUEUEING_)) {
+=09=09dcb->SyncMode |=3D EN_TAG_QUEUEING;
+=09=09dcb->MaxCommand =3D dcb->pDCBACB->TagMaxNum;
+=09}
  =09return 0;
  }

---1463811839-1279876653-1096664082=:3951--
