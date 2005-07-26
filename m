From: Jack Hammer <jack_hammer@adaptec.com>
Subject: Updated Patch for ServeRAID V7.12.02
Date: Tue, 26 Jul 2005 10:20:33 -0400
Message-ID: <42E646B1.7080503@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:52913 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261783AbVGZOWU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 10:22:20 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j6QEMKc19770
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2005 07:22:20 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j6QEMJg14127
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2005 07:22:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I switched to Thunderbird email, so the line wrapping caused by Outlook
should be resolved here.

-------------------------------------------------------------------------------

I am resubmitting the 2.6 kernel patch for the Version 7.12.02 ips driver.
I have eliminated a couple of inappropriate changes pointed out by Arjan.

Signed-off-by: Jack Hammer <jack_hammer@adaptec.com>

--- a/drivers/scsi/ips.c	Tue Jul 19 13:15:24 2005
+++ b/drivers/scsi/ips.c	Tue Jul 19 13:12:44 2005
@@ -133,10 +133,12 @@
 /* 6.10.00  - Remove 1G Addressing Limitations                               */
 /* 6.11.xx  - Get VersionInfo buffer off the stack !              DDTS 60401 */
 /* 6.11.xx  - Make Logical Drive Info structure safe for DMA      DDTS 60639 */
-/* 7.10.xx  - Add highmem_io flag in SCSI Templete for 2.4 kernels           */
+/* 7.10.18  - Add highmem_io flag in SCSI Templete for 2.4 kernels           */
 /*          - Fix path/name for scsi_hosts.h include for 2.6 kernels         */
 /*          - Fix sort order of 7k                                           */
 /*          - Remove 3 unused "inline" functions                             */
+/* 7.12.xx  - Use STATIC functions whereever possible                        */
+/*          - Clean up deprecated MODULE_PARM calls                          */
 /*****************************************************************************/
 
 /*
@@ -207,8 +209,8 @@
 /*
  * DRIVER_VER
  */
-#define IPS_VERSION_HIGH        "7.10"
-#define IPS_VERSION_LOW         ".18 "
+#define IPS_VERSION_HIGH        "7.12"
+#define IPS_VERSION_LOW         ".02 "
 
 #if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
 #warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
--- a/drivers/scsi/ips.h	Tue Jul 19 13:15:31 2005
+++ b/drivers/scsi/ips.h	Tue Jul 19 12:49:03 2005
@@ -87,15 +87,14 @@
       #define scsi_set_pci_device(sh,dev) (0)
    #endif
 
-   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-   
-      #ifndef irqreturn_t
-         typedef void irqreturn_t;
-      #endif 
-      
+   #ifndef IRQ_NONE
+      typedef void irqreturn_t;
       #define IRQ_NONE
       #define IRQ_HANDLED
       #define IRQ_RETVAL(x)
+   #endif
+   
+   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
       #define IPS_REGISTER_HOSTS(SHT)      scsi_register_module(MODULE_SCSI_HA,SHT)
       #define IPS_UNREGISTER_HOSTS(SHT)    scsi_unregister_module(MODULE_SCSI_HA,SHT)
       #define IPS_ADD_HOST(shost,device)
@@ -123,6 +122,10 @@
    #ifndef min
       #define min(x,y) ((x) < (y) ? x : y)
    #endif
+   
+   #ifndef __iomem       /* For clean compiles in earlier kernels without __iomem annotations */
+      #define __iomem
+   #endif
 
    #define pci_dma_hi32(a)         ((a >> 16) >> 16)
    #define pci_dma_lo32(a)         (a & 0xffffffff)
@@ -1206,13 +1209,13 @@
 
 #define IPS_VER_MAJOR 7
 #define IPS_VER_MAJOR_STRING "7"
-#define IPS_VER_MINOR 10
-#define IPS_VER_MINOR_STRING "10"
-#define IPS_VER_BUILD 18
-#define IPS_VER_BUILD_STRING "18"
-#define IPS_VER_STRING "7.10.18"
+#define IPS_VER_MINOR 12
+#define IPS_VER_MINOR_STRING "12"
+#define IPS_VER_BUILD 02
+#define IPS_VER_BUILD_STRING "02"
+#define IPS_VER_STRING "7.12.02"
 #define IPS_RELEASE_ID 0x00020000
-#define IPS_BUILD_IDENT 731
+#define IPS_BUILD_IDENT 761
 #define IPS_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2002. All Rights Reserved."
 #define IPS_ADAPTECCOPYRIGHT_STRING "(c) Copyright Adaptec, Inc. 2002 to 2004. All Rights Reserved."
 #define IPS_DELLCOPYRIGHT_STRING "(c) Copyright Dell 2004. All Rights Reserved."
@@ -1223,12 +1226,12 @@
 #define IPS_VER_SERVERAID2 "2.88.13"
 #define IPS_VER_NAVAJO "2.88.13"
 #define IPS_VER_SERVERAID3 "6.10.24"
-#define IPS_VER_SERVERAID4H "7.10.11"
-#define IPS_VER_SERVERAID4MLx "7.10.18"
-#define IPS_VER_SARASOTA "7.10.18"
-#define IPS_VER_MARCO "7.10.18"
-#define IPS_VER_SEBRING "7.10.18"
-#define IPS_VER_KEYWEST "7.10.18"
+#define IPS_VER_SERVERAID4H "7.12.02"
+#define IPS_VER_SERVERAID4MLx "7.12.02"
+#define IPS_VER_SARASOTA "7.12.02"
+#define IPS_VER_MARCO "7.12.02"
+#define IPS_VER_SEBRING "7.12.02"
+#define IPS_VER_KEYWEST "7.12.02"
 
 /* Compatability IDs for various adapters */
 #define IPS_COMPAT_UNKNOWN ""
