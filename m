From: Ballabio_Dario@emc.com
Subject: RE: eata irq abuse (was: Re: Linux 2.5.60)
Date: Wed, 12 Feb 2003 07:47:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <70652A801D9E0C469C28A0F8BCF49CF9012EBA26@itmi1mx2.corp.emc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2D294.D63474F0"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: manfred@colorfullife.com, warp@mercury.d2dc.net
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2D294.D63474F0
Content-Type: text/plain;
	charset="iso-8859-1"

The enclosed patch applies to 2.5.60 and fixes the irq issue when calling
scsi_register for both eata and u14-34f drivers.
Cheers,
-db



-----Original Message-----
From: Manfred Spraul [mailto:manfred@colorfullife.com]
Sent: Tuesday, February 11, 2003 6:46 PM
To: Zephaniah E. Hull
Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
linux-eata@i-connect.net
Subject: eata irq abuse (was: Re: Linux 2.5.60)


Zephaniah wrote:

>kernel BUG at mm/slab.c:1102!

Slab notices that a function that expects enabled local interrupts is called
with disabled local interrupts.


>Call Trace:
> [<c014a3b3>] do_tune_cpucache+0x83/0x240

do_tune_cpucache:
the function call smp_call_function(), and that is only permitted with
enabled local interrupts. The complain is correct.


> [<c014a300>] do_ccpupdate_local+0x0/0x30
> [<c014a5c1>] enable_cpucache+0x51/0x80
> [<c0148ea5>] kmem_cache_create+0x4a5/0x560

Within kmem_cache_create. kmem_cache_create checks for in_interrupt(), thus
someone probably does

	spin_lock_irqsave();
	kmem_cache_create();


> [<c0285dd2>] scsi_setup_command_freelist+0xa2/0x130

calls kmem_cache_create()

> [<c02887e0>] scsi_register+0x3c0/0x660

calls scsi_setup_command_freelist


> [<c02919a1>] get_pci_dev+0x31/0x50

?? probably stale

> [<c0291df2>] port_detect+0x3c2/0xe50

Do you have an eata scsi controller?

Ugs.
eata2x_detect():
* spin_lock_irqsave();
* calls port_detect();
* * spin_unlock();
* * scsi_register.

Eata maintainers: Is that necessary?
Why do the interrupts remain disabled across scsi_register?
Is that a bug workaround, or an oversight?
I'd use

	spin_unlock_irq();
	scsi_register();
	spin_lock_irq();

--
	Manfred


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


------_=_NextPart_000_01C2D294.D63474F0
Content-Type: application/octet-stream;
	name="drivers_804.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="drivers_804.diff"

diff -u -r linux.803/drivers/scsi/eata.c =
linux.804/drivers/scsi/eata.c=0A=
--- linux.803/drivers/scsi/eata.c	Wed Feb 12 12:14:02 2003=0A=
+++ linux.804/drivers/scsi/eata.c	Wed Feb 12 11:17:25 2003=0A=
@@ -1,6 +1,9 @@=0A=
 /*=0A=
  *      eata.c - Low-level driver for EATA/DMA SCSI host adapters.=0A=
  *=0A=
+ *      12 Feb 2003 Rev. 8.04 for linux 2.5.60=0A=
+ *        + Release irq before calling scsi_register.=0A=
+ *=0A=
  *      12 Nov 2002 Rev. 8.02 for linux 2.5.47=0A=
  *        + Release driver_lock before calling scsi_register.=0A=
  *=0A=
@@ -279,7 +282,7 @@=0A=
  *          This driver is based on the CAM (Common Access Method =
Committee)=0A=
  *          EATA (Enhanced AT Bus Attachment) rev. 2.0A, using DMA =
protocol.=0A=
  *=0A=
- *  Copyright (C) 1994-2002 Dario Ballabio (ballabio_dario@emc.com)=0A=
+ *  Copyright (C) 1994-2003 Dario Ballabio (ballabio_dario@emc.com)=0A=
  *=0A=
  *  Alternate email: dario.ballabio@inwind.it, =
dario.ballabio@tiscalinet.it=0A=
  *=0A=
@@ -1193,9 +1196,9 @@=0A=
    }=0A=
 #endif=0A=
 =0A=
-   spin_unlock(&driver_lock);=0A=
+   spin_unlock_irq(&driver_lock);=0A=
    sh[j] =3D scsi_register(tpnt, sizeof(struct hostdata));=0A=
-   spin_lock(&driver_lock);=0A=
+   spin_lock_irq(&driver_lock);=0A=
 =0A=
    if (sh[j] =3D=3D NULL) {=0A=
       printk("%s: unable to register host, detaching.\n", name);=0A=
@@ -1306,7 +1309,7 @@=0A=
       tag_mode =3D TAG_ORDERED;=0A=
 =0A=
    if (j =3D=3D 0) {=0A=
-      printk("EATA/DMA 2.0x: Copyright (C) 1994-2002 Dario =
Ballabio.\n");=0A=
+      printk("EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario =
Ballabio.\n");=0A=
       printk("%s config options -> tm:%d, lc:%c, mq:%d, rs:%c, et:%c, =
"\=0A=
              "ip:%c, ep:%c, pp:%c.\n", driver_name, tag_mode,=0A=
              YESNO(linked_comm), max_queue_depth, YESNO(rev_scan),=0A=
diff -u -r linux.803/drivers/scsi/eata.h =
linux.804/drivers/scsi/eata.h=0A=
--- linux.803/drivers/scsi/eata.h	Wed Feb 12 12:14:12 2003=0A=
+++ linux.804/drivers/scsi/eata.h	Wed Feb 12 11:17:20 2003=0A=
@@ -11,7 +11,7 @@=0A=
                              sector_t, int *);=0A=
 static int eata2x_slave_configure(Scsi_Device *);=0A=
 =0A=
-#define EATA_VERSION "8.03.00"=0A=
+#define EATA_VERSION "8.04.00"=0A=
 =0A=
 #define EATA {                                                         =
      \=0A=
                 .name              =3D "EATA/DMA 2.0x rev. " =
EATA_VERSION " ",   \=0A=
diff -u -r linux.803/drivers/scsi/u14-34f.c =
linux.804/drivers/scsi/u14-34f.c=0A=
--- linux.803/drivers/scsi/u14-34f.c	Wed Feb 12 12:14:56 2003=0A=
+++ linux.804/drivers/scsi/u14-34f.c	Wed Feb 12 11:17:46 2003=0A=
@@ -1,6 +1,9 @@=0A=
 /*=0A=
  *      u14-34f.c - Low-level driver for UltraStor 14F/34F SCSI host =
adapters.=0A=
  *=0A=
+ *      12 Feb 2003 Rev. 8.04 for linux 2.5.60=0A=
+ *        + Release irq before calling scsi_register.=0A=
+ *=0A=
  *      12 Nov 2002 Rev. 8.02 for linux 2.5.47=0A=
  *        + Release driver_lock before calling scsi_register.=0A=
  *=0A=
@@ -221,7 +224,7 @@=0A=
  *=0A=
  *          Multiple U14F and/or U34F host adapters are supported.=0A=
  *=0A=
- *  Copyright (C) 1994-2002 Dario Ballabio (ballabio_dario@emc.com)=0A=
+ *  Copyright (C) 1994-2003 Dario Ballabio (ballabio_dario@emc.com)=0A=
  *=0A=
  *  Alternate email: dario.ballabio@inwind.it, =
dario.ballabio@tiscalinet.it=0A=
  *=0A=
@@ -847,9 +850,9 @@=0A=
 =0A=
    if (have_old_firmware) tpnt->use_clustering =3D =
DISABLE_CLUSTERING;=0A=
 =0A=
-   spin_unlock(&driver_lock);=0A=
+   spin_unlock_irq(&driver_lock);=0A=
    sh[j] =3D scsi_register(tpnt, sizeof(struct hostdata));=0A=
-   spin_lock(&driver_lock);=0A=
+   spin_lock_irq(&driver_lock);=0A=
 =0A=
    if (sh[j] =3D=3D NULL) {=0A=
       printk("%s: unable to register host, detaching.\n", name);=0A=
@@ -961,7 +964,7 @@=0A=
       tag_mode =3D TAG_ORDERED;=0A=
 =0A=
    if (j =3D=3D 0) {=0A=
-      printk("UltraStor 14F/34F: Copyright (C) 1994-2002 Dario =
Ballabio.\n");=0A=
+      printk("UltraStor 14F/34F: Copyright (C) 1994-2003 Dario =
Ballabio.\n");=0A=
       printk("%s config options -> of:%c, tm:%d, lc:%c, mq:%d, =
et:%c.\n",=0A=
              driver_name, YESNO(have_old_firmware), tag_mode,=0A=
              YESNO(linked_comm), max_queue_depth, YESNO(ext_tran));=0A=
diff -u -r linux.803/drivers/scsi/u14-34f.h =
linux.804/drivers/scsi/u14-34f.h=0A=
--- linux.803/drivers/scsi/u14-34f.h	Wed Feb 12 12:15:06 2003=0A=
+++ linux.804/drivers/scsi/u14-34f.h	Wed Feb 12 11:17:54 2003=0A=
@@ -11,7 +11,7 @@=0A=
                               sector_t, int *);=0A=
 static int u14_34f_slave_configure(Scsi_Device *);=0A=
 =0A=
-#define U14_34F_VERSION "8.03.00"=0A=
+#define U14_34F_VERSION "8.04.00"=0A=
 =0A=
 #define ULTRASTOR_14_34F {                                             =
      \=0A=
                 .name         =3D "UltraStor 14F/34F rev. " =
U14_34F_VERSION " ", \=0A=

------_=_NextPart_000_01C2D294.D63474F0--
