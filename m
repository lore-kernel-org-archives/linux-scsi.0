From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [patch 2.5] ips driver 2/3: adapter error handling fixes
Date: Thu, 2 Jan 2003 13:15:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B037724@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2B28A.DDFE3290"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h02IE0j16273
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jan 2003 10:14:00 -0800 (PST)
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id KAA22819
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jan 2003 10:13:59 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2B28A.DDFE3290
Content-Type: text/plain;
	charset="iso-8859-1"

This patch fixes three previously fatal error
cases during card initialization.  Non-fatal
errors for a battery pic reprogram, unitialized
nvram, or an unitialized card are now correctly
handled.

There is also a one line fix where a pci_alloc
call was being given a NULL pointer instead of
the pci dev.

David Jeffery

 ips.c |   36 +++++++++++++++++++++++++++++++++---
 1 files changed, 33 insertions(+), 3 deletions(-)


------_=_NextPart_000_01C2B28A.DDFE3290
Content-Type: application/octet-stream;
	name="ips2.5.54.patch2"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ips2.5.54.patch2"

diff -ur linux-2.5.54_p1/drivers/scsi/ips.c =
linux-2.5.54_p2/drivers/scsi/ips.c=0A=
--- linux-2.5.54_p1/drivers/scsi/ips.c	Thu Jan  2 11:07:27 2003=0A=
+++ linux-2.5.54_p2/drivers/scsi/ips.c	Thu Jan  2 12:01:42 2003=0A=
@@ -4829,6 +4829,29 @@=0A=
 =0A=
    Post =3D readl(ha->mem_ptr + IPS_REG_I960_MSG0);=0A=
 =0A=
+   if (Post =3D=3D 0x4F00) {                          /* If Flashing =
the Battery PIC         */=0A=
+       printk(KERN_WARNING "Flashing Battery PIC, Please wait ...\n" =
);=0A=
+=0A=
+       /* Clear the interrupt bit */=0A=
+       Isr =3D (uint32_t) IPS_BIT_I960_MSG0I;=0A=
+       writel(Isr, ha->mem_ptr + IPS_REG_I2O_HIR);=0A=
+=0A=
+       for (i =3D 0; i < 120; i++) {                /*    Wait Up to 2 =
Min. for Completion */=0A=
+          Post =3D readl(ha->mem_ptr + IPS_REG_I960_MSG0);=0A=
+          if (Post !=3D 0x4F00)=0A=
+              break;=0A=
+          /* Delay for 1 Second */=0A=
+          MDELAY(IPS_ONE_SEC);=0A=
+       }=0A=
+=0A=
+       if (i >=3D 120) {=0A=
+          printk(KERN_WARNING "(%s%d) timeout waiting for Battery PIC =
Flash\n",=0A=
+                 ips_name, ha->host_num);=0A=
+          return (0);=0A=
+       }=0A=
+=0A=
+   }=0A=
+=0A=
    /* Clear the interrupt bit */=0A=
    Isr =3D (uint32_t) IPS_BIT_I960_MSG0I;=0A=
    writel(Isr, ha->mem_ptr + IPS_REG_I2O_HIR);=0A=
@@ -5484,8 +5507,7 @@=0A=
    if (le32_to_cpu(ha->nvram->signature) !=3D IPS_NVRAM_P5_SIG) {=0A=
       DEBUG_VAR(1, "(%s%d) NVRAM page 5 has an invalid signature: =
%X.",=0A=
                 ips_name, ha->host_num, ha->nvram->signature);=0A=
-=0A=
-      return (1);=0A=
+      ha->nvram->signature =3D IPS_NVRAM_P5_SIG;=0A=
    }=0A=
 =0A=
    DEBUG_VAR(2, "(%s%d) Ad Type: %d, Ad Slot: %d, BIOS: %c%c%c%c =
%c%c%c%c.",=0A=
@@ -6622,6 +6644,7 @@=0A=
    dma_addr_t        dma_address;=0A=
    char             *ioremap_ptr;=0A=
    char             *mem_ptr;             =0A=
+   uint32_t          IsDead;=0A=
 =0A=
    METHOD_TRACE("ips_init_phase1", 1);=0A=
    index =3D IPS_MAX_ADAPTERS;=0A=
@@ -6719,7 +6742,7 @@=0A=
        return ips_abort_init(ha, sh, index);=0A=
     }=0A=
 =0A=
-    ha->adapt =3D pci_alloc_consistent(ha->pcidev, sizeof(IPS_ADAPTER) =
+=0A=
+    ha->adapt =3D pci_alloc_consistent(pci_dev, sizeof(IPS_ADAPTER) =
+=0A=
                                      sizeof(IPS_IO_CMD), =
&dma_address);=0A=
     if (!ha->adapt) {=0A=
        printk(KERN_WARNING "Unable to allocate host adapt & dummy =
structures\n");=0A=
@@ -6845,6 +6868,13 @@=0A=
           ha->func.issue =3D ips_issue_copperhead;=0A=
     }=0A=
 =0A=
+    if ( IPS_IS_MORPHEUS( ha ) ) {=0A=
+        /* If Morpheus appears dead, reset it */=0A=
+        IsDead =3D readl( ha->mem_ptr + IPS_REG_I960_MSG1 );=0A=
+        if ( IsDead =3D=3D 0xDEADBEEF ) {=0A=
+            ips_reset_morpheus( ha );=0A=
+        }=0A=
+    }=0A=
     /*=0A=
      * Initialize the card if it isn't already=0A=
      */=0A=

------_=_NextPart_000_01C2B28A.DDFE3290--
