From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips driver 4/4: use scsi_add_host
Date: Thu, 13 Feb 2003 09:35:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B037751@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2D36D.28EF69B0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h1DEXxD27711
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2003 06:33:59 -0800 (PST)
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id GAA14545
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2003 06:33:59 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2D36D.28EF69B0
Content-Type: text/plain;
	charset="iso-8859-1"

This patch converts the driver to use the new
scsi_add_host() interface to add scsi controllers.

David Jeffery

 ips.c |   17 +++++++++++++----
 ips.h |   11 +++++++++--
 2 files changed, 22 insertions(+), 6 deletions(-)


------_=_NextPart_000_01C2D36D.28EF69B0
Content-Type: text/plain;
	name="ipspatch4.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ipspatch4.txt"

diff -ur linux-2.5.60_p3/drivers/scsi/ips.c =
linux-2.5.60_p4/drivers/scsi/ips.c=0A=
--- linux-2.5.60_p3/drivers/scsi/ips.c	Tue Feb 11 11:47:41 2003=0A=
+++ linux-2.5.60_p4/drivers/scsi/ips.c	Tue Feb 11 11:47:58 2003=0A=
@@ -195,7 +195,7 @@=0A=
  * DRIVER_VER=0A=
  */=0A=
 #define IPS_VERSION_HIGH        "5.99"=0A=
-#define IPS_VERSION_LOW         ".00-BETA"=0A=
+#define IPS_VERSION_LOW         ".01-BETA"=0A=
 =0A=
 =0A=
 #if !defined(__i386__) && !defined(__ia64__)=0A=
@@ -241,6 +241,7 @@=0A=
 static unsigned int ips_next_controller =3D 0;=0A=
 static unsigned int ips_num_controllers =3D 0;=0A=
 static unsigned int ips_released_controllers =3D 0;=0A=
+static int          ips_hotplug;=0A=
 static int          ips_cmd_timeout =3D 60;=0A=
 static int          ips_reset_timeout =3D 60 * 5;=0A=
 static int          ips_force_memio =3D 1;             /* Always use =
Memory Mapped I/O    */=0A=
@@ -572,7 +573,7 @@=0A=
          ips_free(ips_ha[i]);=0A=
          ips_released_controllers++;=0A=
    } =0A=
-=0A=
+   ips_hotplug =3D 1;=0A=
    return (ips_num_controllers);=0A=
 }=0A=
 =0A=
@@ -702,6 +703,7 @@=0A=
    /* free IRQ */=0A=
    free_irq(ha->irq, ha);=0A=
 =0A=
+   IPS_REMOVE_HOST(sh);=0A=
    scsi_unregister(sh);=0A=
 =0A=
    ips_released_controllers++;=0A=
@@ -6764,6 +6766,7 @@=0A=
 	sh->max_channel =3D ha->nbus - 1;=0A=
 	sh->can_queue =3D ha->max_cmds-1;=0A=
 =0A=
+	IPS_ADD_HOST(sh, NULL);=0A=
 	return 0;=0A=
 }=0A=
 =0A=
@@ -6804,7 +6807,7 @@=0A=
 		return -ENODEV;=0A=
 	ips_driver_template.module =3D THIS_MODULE;=0A=
 	ips_order_controllers();=0A=
-	if( scsi_register_host(&ips_driver_template) ){=0A=
+	if( IPS_REGISTER_HOSTS(&ips_driver_template) ){=0A=
 		pci_unregister_driver(&ips_pci_driver);=0A=
 		return -ENODEV;=0A=
 	}=0A=
@@ -6821,7 +6824,7 @@=0A=
 =
/***********************************************************************=
*****/=0A=
 static void __exit=0A=
 ips_module_exit(void){=0A=
-	scsi_unregister_host(&ips_driver_template);=0A=
+	IPS_UNREGISTER_HOSTS(&ips_driver_template);=0A=
 	pci_unregister_driver(&ips_pci_driver);=0A=
 	unregister_reboot_notifier(&ips_notifier);=0A=
 }=0A=
@@ -6851,6 +6854,12 @@=0A=
     if (rc =3D=3D SUCCESS)=0A=
        rc =3D ips_init_phase2(index);  =0A=
 =0A=
+    if(ips_hotplug)=0A=
+       if(ips_register_scsi(index)){=0A=
+          ips_free(ips_ha[index]);=0A=
+          rc =3D -1;=0A=
+       }=0A=
+=0A=
     if (rc =3D=3D SUCCESS)=0A=
        ips_num_controllers++;=0A=
 =0A=
diff -ur linux-2.5.60_p3/drivers/scsi/ips.h =
linux-2.5.60_p4/drivers/scsi/ips.h=0A=
--- linux-2.5.60_p3/drivers/scsi/ips.h	Tue Feb 11 11:01:33 2003=0A=
+++ linux-2.5.60_p4/drivers/scsi/ips.h	Tue Feb 11 11:04:04 2003=0A=
@@ -99,8 +99,15 @@=0A=
    #endif=0A=
 =0A=
    #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)=0A=
-      #define scsi_register_host(x)    =
scsi_register_module(MODULE_SCSI_HA,x)=0A=
-      #define scsi_unregister_host(x)  =
scsi_unregister_module(MODULE_SCSI_HA,x)=0A=
+      #define IPS_REGISTER_HOSTS(SHT)      =
scsi_register_module(MODULE_SCSI_HA,SHT)=0A=
+      #define IPS_UNREGISTER_HOSTS(SHT)    =
scsi_unregister_module(MODULE_SCSI_HA,SHT)=0A=
+      #define IPS_ADD_HOST(shost,device)=0A=
+      #define IPS_REMOVE_HOST(shost)=0A=
+   #else=0A=
+      #define IPS_REGISTER_HOSTS(SHT)      (!ips_detect(SHT))=0A=
+      #define IPS_UNREGISTER_HOSTS(SHT)=0A=
+      #define IPS_ADD_HOST(shost,device)   =
scsi_add_host(shost,device)=0A=
+      #define IPS_REMOVE_HOST(shost)       scsi_remove_host(shost)=0A=
    #endif=0A=
 =0A=
    #ifndef MDELAY=0A=

------_=_NextPart_000_01C2D36D.28EF69B0--
