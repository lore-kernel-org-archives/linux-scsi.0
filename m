From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips queue depths 2.5.44
Date: Mon, 28 Oct 2002 13:35:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B0376CD@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C27EB0.CA5B2530"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id g9SIZdj28840
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2002 10:35:40 -0800 (PST)
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id KAA18318
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2002 10:35:39 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C27EB0.CA5B2530
Content-Type: text/plain;
	charset="iso-8859-1"

After way to long of a delay, here's a patch for the queue depths
in the ips driver.  And this patch also shuts up the compiler
warnings.  

David Jeffery


------_=_NextPart_000_01C27EB0.CA5B2530
Content-Type: application/octet-stream;
	name="ips2.5.44"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ips2.5.44"

--- linux-2.5.44/drivers/scsi/ips.c	Mon Oct 28 11:58:09 2002=0A=
+++ linux-2.5.44_mod/drivers/scsi/ips.c	Mon Oct 28 13:02:05 2002=0A=
@@ -248,8 +248,8 @@=0A=
 #else=0A=
     #define IPS_SG_ADDRESS(sg)      (page_address((sg)->page) ? \=0A=
                                      =
page_address((sg)->page)+(sg)->offset : 0)=0A=
-    #define IPS_LOCK_SAVE(lock,flags) spin_lock(lock)=0A=
-    #define IPS_UNLOCK_RESTORE(lock,flags) spin_unlock(lock)=0A=
+    #define IPS_LOCK_SAVE(lock,flags) =
do{spin_lock(lock);(void)flags;}while(0)=0A=
+    #define IPS_UNLOCK_RESTORE(lock,flags) =
do{spin_unlock(lock);(void)flags;}while(0)=0A=
 #endif=0A=
 =0A=
 #define IPS_DMA_DIR(scb) ((!scb->scsi_cmd || =
ips_is_passthru(scb->scsi_cmd) || \=0A=
@@ -1879,9 +1879,9 @@=0A=
    int          min;=0A=
 =0A=
    ha =3D IPS_HA(SDptr->host);=0A=
-   if (SDptr->tagged_supported) {=0A=
+   if (SDptr->tagged_supported && SDptr->type =3D=3D TYPE_DISK) {=0A=
       min =3D ha->max_cmds / 2;=0A=
-      if (min <=3D 16)=0A=
+      if (ha->enq->ucLogDriveCount <=3D 2)=0A=
          min =3D ha->max_cmds - 1;=0A=
       scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, min);=0A=
    }=0A=
@@ -4761,7 +4761,7 @@=0A=
    inquiry.ResponseDataFormat =3D IPS_SCSI_INQ_RD_REV2;=0A=
    inquiry.AdditionalLength =3D 31;=0A=
    inquiry.Flags[0] =3D IPS_SCSI_INQ_Address16;=0A=
-   inquiry.Flags[1] =3D IPS_SCSI_INQ_WBus16 | IPS_SCSI_INQ_Sync;=0A=
+   inquiry.Flags[1] =3D IPS_SCSI_INQ_WBus16 | IPS_SCSI_INQ_Sync | =
IPS_SCSI_INQ_CmdQue;=0A=
    strncpy(inquiry.VendorId, "IBM     ", 8);=0A=
    strncpy(inquiry.ProductId, "SERVERAID       ", 16);=0A=
    strncpy(inquiry.ProductRevisionLevel, "1.00", 4);=0A=

------_=_NextPart_000_01C27EB0.CA5B2530--
