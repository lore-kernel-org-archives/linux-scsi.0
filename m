From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips 2.5 driver update [3/4]: misc cleanups
Date: Tue, 6 May 2003 13:34:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B0377A5@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C313F5.B7ACB450"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:58014 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S263996AbTEFRWC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 May 2003 13:22:02 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id h46HV8Z23122
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2003 10:31:08 -0700
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8p2+Sun/8.8.8) with ESMTP id KAA07701
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2003 10:34:27 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C313F5.B7ACB450
Content-Type: text/plain;
	charset="iso-8859-1"

This patch checks the return code of
pci_set_dma_mask for a 32bit mask,  adds a break
to quiet some compilers, and adds some 2.4 compat.
code.

David Jeffery

 ips.c |    8 ++++++--
 ips.h |    4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)


------_=_NextPart_000_01C313F5.B7ACB450
Content-Type: text/plain;
	name="patch3.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch3.txt"

diff -urN linux-2.5.69_p2/drivers/scsi/ips.c =
linux-2.5.69_p3/drivers/scsi/ips.c=0A=
--- linux-2.5.69_p2/drivers/scsi/ips.c	2003-05-06 13:20:52.000000000 =
-0400=0A=
+++ linux-2.5.69_p3/drivers/scsi/ips.c	2003-05-06 13:20:31.000000000 =
-0400=0A=
@@ -6684,6 +6684,7 @@=0A=
 					}=0A=
 					break;=0A=
 				default:=0A=
+					break;=0A=
 				}=0A=
 			}=0A=
 		}=0A=
@@ -6747,7 +6748,7 @@=0A=
 	kfree(oldha);=0A=
 	ips_sh[index] =3D sh;=0A=
 	ips_ha[index] =3D ha;=0A=
-	scsi_set_device(sh, &ha->pcidev->dev);=0A=
+	IPS_SCSI_SET_DEVICE(sh, ha);=0A=
 =0A=
 	/* Store away needed values for later use */=0A=
 	sh->io_port =3D ha->io_addr;=0A=
@@ -7009,7 +7010,10 @@=0A=
          !pci_set_dma_mask(ha->pcidev, (u64)0xffffffffffffffff)) {=0A=
        (ha)->flags |=3D IPS_HA_ENH_SG;=0A=
     } else {=0A=
-       pci_set_dma_mask(ha->pcidev, (u64)0xffffffff);=0A=
+       if ( pci_set_dma_mask(ha->pcidev, (u64)0xffffffff) !=3D 0 ) { =
=0A=
+          printk(KERN_WARNING "Unable to set DMA Mask\n");=0A=
+          return ips_abort_init(ha, index);=0A=
+       }=0A=
     }=0A=
 =0A=
     ha->enq =3D kmalloc(sizeof(IPS_ENQ), IPS_INIT_GFP);=0A=
diff -urN linux-2.5.69_p2/drivers/scsi/ips.h =
linux-2.5.69_p3/drivers/scsi/ips.h=0A=
--- linux-2.5.69_p2/drivers/scsi/ips.h	2003-05-06 13:20:52.000000000 =
-0400=0A=
+++ linux-2.5.69_p3/drivers/scsi/ips.h	2003-05-06 13:20:31.000000000 =
-0400=0A=
@@ -94,7 +94,7 @@=0A=
                                          sizeof(IPS_ENH_SG_LIST) : =
sizeof(IPS_STD_SG_LIST))=0A=
 =0A=
    #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,4)=0A=
-      #define pci_set_dma_mask(dev,mask) (1)=0A=
+      #define pci_set_dma_mask(dev,mask) ( mask > 0xffffffff ? 1:0 =
)=0A=
       #define scsi_set_pci_device(sh,dev) (0)=0A=
    #endif=0A=
 =0A=
@@ -107,11 +107,13 @@=0A=
       #define IPS_UNREGISTER_HOSTS(SHT)    =
scsi_unregister_module(MODULE_SCSI_HA,SHT)=0A=
       #define IPS_ADD_HOST(shost,device)=0A=
       #define IPS_REMOVE_HOST(shost)=0A=
+      #define IPS_SCSI_SET_DEVICE(sh,ha)   scsi_set_pci_device(sh, =
(ha)->pcidev)=0A=
    #else=0A=
       #define IPS_REGISTER_HOSTS(SHT)      (!ips_detect(SHT))=0A=
       #define IPS_UNREGISTER_HOSTS(SHT)=0A=
       #define IPS_ADD_HOST(shost,device)   =
scsi_add_host(shost,device)=0A=
       #define IPS_REMOVE_HOST(shost)       scsi_remove_host(shost)=0A=
+      #define IPS_SCSI_SET_DEVICE(sh,ha)   scsi_set_device(sh, =
&(ha)->pcidev->dev)=0A=
    #endif=0A=
 =0A=
    #ifndef MDELAY=0A=

------_=_NextPart_000_01C313F5.B7ACB450--
