From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips 2.5 driver update [1/4] irq return update
Date: Tue, 6 May 2003 13:34:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B0377A3@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C313F5.ADCD6420"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:27293 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S263986AbTEFRVm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 May 2003 13:21:42 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id h46HUmZ01735
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2003 10:30:48 -0700
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8p2+Sun/8.8.8) with ESMTP id KAA07537
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2003 10:34:07 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C313F5.ADCD6420
Content-Type: text/plain;
	charset="iso-8859-1"

This is the proper way to report if the interrupt
was from a serveraid or not.

David Jeffery

 ips.c |   29 ++++++++++++++++-------------
 ips.h |    6 +++++-
 2 files changed, 21 insertions(+), 14 deletions(-)



------_=_NextPart_000_01C313F5.ADCD6420
Content-Type: text/plain;
	name="patch1.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch1.txt"

diff -urN linux-2.5.69_p0/drivers/scsi/ips.c =
linux-2.5.69_p1/drivers/scsi/ips.c=0A=
--- linux-2.5.69_p0/drivers/scsi/ips.c	2003-05-06 12:57:14.000000000 =
-0400=0A=
+++ linux-2.5.69_p1/drivers/scsi/ips.c	2003-05-06 13:18:49.000000000 =
-0400=0A=
@@ -426,8 +426,8 @@=0A=
 static void ips_enable_int_copperhead(ips_ha_t *);=0A=
 static void ips_enable_int_copperhead_memio(ips_ha_t *);=0A=
 static void ips_enable_int_morpheus(ips_ha_t *);=0A=
-static void ips_intr_copperhead(ips_ha_t *);=0A=
-static void ips_intr_morpheus(ips_ha_t *);=0A=
+static irqreturn_t ips_intr_copperhead(ips_ha_t *);=0A=
+static irqreturn_t ips_intr_morpheus(ips_ha_t *);=0A=
 static void ips_next(ips_ha_t *, int);=0A=
 static void ipsintr_blocking(ips_ha_t *, struct ips_scb *);=0A=
 static void ipsintr_done(ips_ha_t *, struct ips_scb *);=0A=
@@ -1269,7 +1269,8 @@=0A=
    ips_ha_t         *ha;=0A=
    unsigned long     cpu_flags;=0A=
    struct Scsi_Host *host;=0A=
-=0A=
+   irqreturn_t       irqstatus;=0A=
+   =0A=
    METHOD_TRACE("do_ipsintr", 2);=0A=
 =0A=
    ha =3D (ips_ha_t *) dev_id;=0A=
@@ -1289,13 +1290,13 @@=0A=
       return IRQ_HANDLED;=0A=
    }=0A=
 =0A=
-   (*ha->func.intr)(ha);=0A=
+   irqstatus =3D (*ha->func.intr)(ha);=0A=
 =0A=
    IPS_UNLOCK_RESTORE(host->host_lock, cpu_flags);=0A=
 =0A=
    /* start the next command */=0A=
    ips_next(ha, IPS_INTR_ON);=0A=
-   return IRQ_HANDLED;=0A=
+   return IRQ_RETVAL(irqstatus);=0A=
 }=0A=
 =0A=
 =
/***********************************************************************=
*****/=0A=
@@ -1309,7 +1310,7 @@=0A=
 /*   ASSUMES interrupts are disabled                                   =
     */=0A=
 /*                                                                     =
     */=0A=
 =
/***********************************************************************=
*****/=0A=
-void=0A=
+irqreturn_t=0A=
 ips_intr_copperhead(ips_ha_t *ha) {=0A=
    ips_stat_t       *sp;=0A=
    ips_scb_t        *scb;=0A=
@@ -1319,10 +1320,10 @@=0A=
    METHOD_TRACE("ips_intr", 2);=0A=
 =0A=
    if (!ha)=0A=
-      return;=0A=
+      return IRQ_NONE;=0A=
 =0A=
    if (!ha->active)=0A=
-      return;=0A=
+      return IRQ_NONE;=0A=
 =0A=
    intrstatus =3D (*ha->func.isintr)(ha);=0A=
 =0A=
@@ -1331,7 +1332,7 @@=0A=
        * Unexpected/Shared interrupt=0A=
        */=0A=
 =0A=
-      return;=0A=
+      return IRQ_NONE;=0A=
    }=0A=
 =0A=
    while (TRUE) {=0A=
@@ -1358,6 +1359,7 @@=0A=
        */=0A=
       (*scb->callback) (ha, scb);=0A=
    } /* end while */=0A=
+   return IRQ_HANDLED;=0A=
 }=0A=
 =0A=
 =
/***********************************************************************=
*****/=0A=
@@ -1371,7 +1373,7 @@=0A=
 /*   ASSUMES interrupts are disabled                                   =
     */=0A=
 /*                                                                     =
     */=0A=
 =
/***********************************************************************=
*****/=0A=
-void=0A=
+irqreturn_t=0A=
 ips_intr_morpheus(ips_ha_t *ha) {=0A=
    ips_stat_t       *sp;=0A=
    ips_scb_t        *scb;=0A=
@@ -1381,10 +1383,10 @@=0A=
    METHOD_TRACE("ips_intr_morpheus", 2);=0A=
 =0A=
    if (!ha)=0A=
-      return;=0A=
+      return IRQ_NONE;=0A=
 =0A=
    if (!ha->active)=0A=
-      return;=0A=
+      return IRQ_NONE;=0A=
 =0A=
    intrstatus =3D (*ha->func.isintr)(ha);=0A=
 =0A=
@@ -1393,7 +1395,7 @@=0A=
        * Unexpected/Shared interrupt=0A=
        */=0A=
 =0A=
-      return;=0A=
+      return IRQ_NONE;=0A=
    }=0A=
 =0A=
    while (TRUE) {=0A=
@@ -1426,6 +1428,7 @@=0A=
        */=0A=
       (*scb->callback) (ha, scb);=0A=
    } /* end while */=0A=
+   return IRQ_HANDLED;=0A=
 }=0A=
 =0A=
 =
/***********************************************************************=
*****/=0A=
diff -urN linux-2.5.69_p0/drivers/scsi/ips.h =
linux-2.5.69_p1/drivers/scsi/ips.h=0A=
--- linux-2.5.69_p0/drivers/scsi/ips.h	2003-05-06 12:57:14.000000000 =
-0400=0A=
+++ linux-2.5.69_p1/drivers/scsi/ips.h	2003-05-06 12:58:22.000000000 =
-0400=0A=
@@ -99,6 +99,10 @@=0A=
    #endif=0A=
 =0A=
    #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)=0A=
+      typedef void irqreturn_t;=0A=
+      #define IRQ_NONE=0A=
+      #define IRQ_HANDLED=0A=
+      #define IRQ_RETVAL(x)=0A=
       #define IPS_REGISTER_HOSTS(SHT)      =
scsi_register_module(MODULE_SCSI_HA,SHT)=0A=
       #define IPS_UNREGISTER_HOSTS(SHT)    =
scsi_unregister_module(MODULE_SCSI_HA,SHT)=0A=
       #define IPS_ADD_HOST(shost,device)=0A=
@@ -1092,7 +1096,7 @@=0A=
    int       (*programbios)(struct ips_ha *, char *, uint32_t, =
uint32_t);=0A=
    int       (*verifybios)(struct ips_ha *, char *, uint32_t, =
uint32_t);=0A=
    void      (*statinit)(struct ips_ha *);=0A=
-   void      (*intr)(struct ips_ha *);=0A=
+   irqreturn_t  (*intr)(struct ips_ha *);=0A=
    void      (*enableint)(struct ips_ha *);=0A=
    uint32_t (*statupd)(struct ips_ha *);=0A=
 } ips_hw_func_t;=0A=

------_=_NextPart_000_01C313F5.ADCD6420--
