From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [patch 2.5] ips driver 1/3: remove 2.2 kernel compat code
Date: Thu, 2 Jan 2003 13:14:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B037723@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2B28A.DA173460"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h02IDrj16262
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jan 2003 10:13:54 -0800 (PST)
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id KAA22802
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jan 2003 10:13:52 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2B28A.DA173460
Content-Type: text/plain;
	charset="iso-8859-1"

This rather large patch removes the old compatibility
code and ifdefs for compiling the driver against a
2.2 kernel.

The patch was made against kernel version 2.5.54.

David Jeffery

 ips.c |  668
------------------------------------------------------------------
 ips.h |   31 ---
 2 files changed, 3 insertions(+), 696 deletions(-)


------_=_NextPart_000_01C2B28A.DA173460
Content-Type: application/octet-stream;
	name="ips2.5.54.patch1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ips2.5.54.patch1"

diff -ur linux-2.5.54_p0/drivers/scsi/ips.c =
linux-2.5.54_p1/drivers/scsi/ips.c=0A=
--- linux-2.5.54_p0/drivers/scsi/ips.c	Thu Jan  2 11:23:07 2003=0A=
+++ linux-2.5.54_p1/drivers/scsi/ips.c	Thu Jan  2 11:07:27 2003=0A=
@@ -178,12 +178,8 @@=0A=
 #include <linux/stat.h>=0A=
 #include <linux/config.h>=0A=
 =0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
-  #include <linux/spinlock.h>=0A=
-  #include <linux/init.h>=0A=
-#else=0A=
-  #include <asm/spinlock.h>=0A=
-#endif=0A=
+#include <linux/spinlock.h>=0A=
+#include <linux/init.h>=0A=
 =0A=
 #include <linux/smp.h>=0A=
 =0A=
@@ -199,45 +195,10 @@=0A=
 #define IPS_VERSION_HIGH        "5.10"=0A=
 #define IPS_VERSION_LOW         ".13-BETA "=0A=
 =0A=
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,4,0)=0A=
-struct proc_dir_entry proc_scsi_ips =3D {=0A=
-   0,=0A=
-   3, "ips",=0A=
-   S_IFDIR | S_IRUGO | S_IXUGO, 2=0A=
-};=0A=
-#endif=0A=
-=0A=
 #if !defined(__i386__) && !defined(__ia64__)=0A=
    #error "This driver has only been tested on the x86/ia64 =
platforms"=0A=
 #endif=0A=
 =0A=
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,2,0)=0A=
-   #error "This driver only works with kernel 2.2.0 and later"=0A=
-#elif LINUX_VERSION_CODE <=3D LinuxVersionCode(2,3,18)=0A=
-    #define dma_addr_t uint32_t=0A=
-    =0A=
-    static inline void *pci_alloc_consistent(struct pci_dev *dev,int =
size,=0A=
-                                             dma_addr_t *dmahandle) =
{=0A=
-       void * ptr =3D kmalloc(size, GFP_ATOMIC); =0A=
-       if(ptr){     =0A=
-          *dmahandle =3D (uint32_t)virt_to_bus(ptr);=0A=
-       }=0A=
-       return ptr;=0A=
-    }=0A=
-    =0A=
-    #define pci_free_consistent(a,size,address,dmahandle) =
kfree(address)=0A=
-    =0A=
-    #define pci_map_sg(a,b,n,z)       (n)=0A=
-    #define pci_unmap_sg(a,b,c,d)     =0A=
-    #define pci_map_single(a,b,c,d)   ((uint32_t)virt_to_bus(b))=0A=
-    #define pci_unmap_single(a,b,c,d) =0A=
-    #ifndef sg_dma_address=0A=
-      #define sg_dma_address(x)         =
((uint32_t)virt_to_bus((x)->address))=0A=
-      #define sg_dma_len(x)             ((x)->length)=0A=
-    #endif=0A=
-    #define pci_unregister_driver(x)=0A=
-#endif=0A=
-=0A=
 #if LINUX_VERSION_CODE <=3D LinuxVersionCode(2,5,0)=0A=
     #define IPS_SG_ADDRESS(sg)       ((sg)->address)=0A=
     #define IPS_LOCK_SAVE(lock,flags) =
spin_lock_irqsave(&io_request_lock,flags)=0A=
@@ -289,7 +250,6 @@=0A=
 IPS_DEFINE_COMPAT_TABLE( Compatable );               /* Version =
Compatability Table      */=0A=
 =0A=
 =0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
    /* This table describes any / all ServeRAID Adapters */=0A=
    static struct  pci_device_id  ips_pci_table[]  __devinitdata =3D =
{=0A=
            { 0x1014, 0x002E, PCI_ANY_ID, PCI_ANY_ID, 0, 0 },=0A=
@@ -338,7 +298,6 @@=0A=
        .remove		=3D __devexit_p(ips_remove_device),=0A=
    };=0A=
 =0A=
-#endif=0A=
 =0A=
 /*=0A=
  * Necessary forward function protoypes=0A=
@@ -533,9 +492,7 @@=0A=
 static int ips_abort_init(ips_ha_t *ha, struct Scsi_Host *sh, int =
index);=0A=
 static int ips_init_phase2( int index );=0A=
 =0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
 static int ips_init_phase1( struct pci_dev *pci_dev, int *indexPtr =
);=0A=
-#endif=0A=
 =0A=
 =
/*----------------------------------------------------------------------=
----*/=0A=
 /* Exported Functions                                                  =
     */=0A=
@@ -550,13 +507,8 @@=0A=
 /*   setup parameters to the driver                                    =
     */=0A=
 /*                                                                     =
     */=0A=
 =
/***********************************************************************=
*****/=0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
 static int=0A=
 ips_setup(char *ips_str) {=0A=
-#else=0A=
-void=0A=
-ips_setup(char *ips_str, int *dummy) {=0A=
-#endif=0A=
 =0A=
    int        i;=0A=
    char      *key;=0A=
@@ -570,7 +522,6 @@=0A=
    };=0A=
     =0A=
    /* Don't use strtok() anymore ( if 2.4 Kernel or beyond ) */=0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
    /* Search for value */=0A=
    while ((key =3D strsep(&ips_str, ",."))) {=0A=
       if (!*key)=0A=
@@ -598,43 +549,6 @@=0A=
 =0A=
 __setup("ips=3D", ips_setup);=0A=
 =0A=
-#else=0A=
-=0A=
-  char      *p;=0A=
-   char       tokens[3] =3D {',', '.', 0};=0A=
-=0A=
-   for (key =3D strtok(ips_str, tokens); key; key =3D strtok(NULL, =
tokens)) {=0A=
-      p =3D key;=0A=
-=0A=
-      /* Search for value */=0A=
-      while ((p) && (*p !=3D ':'))=0A=
-         p++;=0A=
-=0A=
-      if (p) {=0A=
-         *p =3D '\0';=0A=
-         value =3D p+1;=0A=
-      } else=0A=
-         value =3D NULL;=0A=
-=0A=
-      /*=0A=
-       * We now have key/value pairs.=0A=
-       * Update the variables=0A=
-       */=0A=
-      for (i =3D 0; i < (sizeof(options) / sizeof(options[0])); i++) =
{=0A=
-         if (strnicmp(key, options[i].option_name, strlen(ips_str)) =
=3D=3D 0) {=0A=
-            if (value)=0A=
-               *options[i].option_flag =3D simple_strtoul(value, NULL, =
0);=0A=
-            else=0A=
-               *options[i].option_flag =3D options[i].option_value;=0A=
-=0A=
-            break;=0A=
-         }=0A=
-      }=0A=
-   }=0A=
-}=0A=
-=0A=
-#endif=0A=
-=0A=
 =
/***********************************************************************=
*****/=0A=
 /*                                                                     =
     */=0A=
 /* Routine Name: ips_detect                                            =
     */=0A=
@@ -648,42 +562,12 @@=0A=
 =
/***********************************************************************=
*****/=0A=
 int=0A=
 ips_detect(Scsi_Host_Template *SHT) {=0A=
-   struct Scsi_Host *sh;=0A=
-   ips_ha_t         *ha;=0A=
-   uint32_t          io_addr;=0A=
-   uint32_t          mem_addr;=0A=
-   uint32_t          io_len;=0A=
-   uint32_t          mem_len;=0A=
-   uint16_t          planer;=0A=
-   uint8_t           revision_id;=0A=
-   uint8_t           bus;=0A=
-   uint8_t           func;=0A=
-   uint8_t           irq;=0A=
-   uint16_t          deviceID[2];=0A=
-   uint16_t          subdevice_id;=0A=
-   int               i;=0A=
-   int               j;=0A=
-   uint32_t          count;=0A=
-   char             *ioremap_ptr;=0A=
-   char             *mem_ptr;=0A=
-   struct pci_dev   *dev[2];=0A=
-   struct pci_dev   *morpheus =3D NULL;=0A=
-   struct pci_dev   *trombone =3D NULL;=0A=
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,4,0)=0A=
-   uint32_t          currbar;=0A=
-   uint32_t          maskbar;=0A=
-   uint8_t           barnum;=0A=
-#endif=0A=
 =0A=
    METHOD_TRACE("ips_detect", 1);=0A=
 =0A=
 #ifdef MODULE=0A=
    if (ips)=0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
       ips_setup(ips);=0A=
-#else=0A=
-      ips_setup(ips, NULL);=0A=
-#endif=0A=
 #endif=0A=
 =0A=
    /* If Booting from the ServeRAID Manager CD, Allocate a large Flash =
 */=0A=
@@ -697,69 +581,8 @@=0A=
    }                                                                   =
            =0A=
 =0A=
    SHT->proc_info =3D ips_proc_info;=0A=
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,4,0)=0A=
-   SHT->proc_dir =3D &proc_scsi_ips;=0A=
-#else=0A=
    SHT->proc_name =3D "ips";=0A=
-#endif=0A=
-=0A=
-#if defined(CONFIG_PCI)=0A=
-=0A=
-   /* initalize number of controllers */=0A=
-   ips_num_controllers =3D 0;=0A=
-   ips_next_controller =3D 0;=0A=
-   ips_released_controllers =3D 0;=0A=
-=0A=
-   if (!pci_present())=0A=
-      return (0);=0A=
-=0A=
-   morpheus =3D pci_find_device(IPS_VENDORID, IPS_DEVICEID_MORPHEUS, =
morpheus);=0A=
-   trombone =3D pci_find_device(IPS_VENDORID, IPS_DEVICEID_COPPERHEAD, =
trombone);=0A=
-=0A=
-   /* determine which controller to probe first */=0A=
-   if (!morpheus) {=0A=
-      /* we only have trombone */=0A=
-      dev[0] =3D trombone;=0A=
-      dev[1] =3D NULL;=0A=
-      deviceID[0] =3D IPS_DEVICEID_COPPERHEAD;=0A=
-   } else if (!trombone) {=0A=
-      /* we only have morpheus */=0A=
-      dev[0] =3D morpheus;=0A=
-      dev[1] =3D NULL;=0A=
-      deviceID[0] =3D IPS_DEVICEID_MORPHEUS;=0A=
-   } else {=0A=
-      /* we have both in the system */=0A=
-      if (trombone->bus->number < morpheus->bus->number) {=0A=
-         dev[0] =3D trombone;=0A=
-         dev[1] =3D morpheus;=0A=
-         deviceID[0] =3D IPS_DEVICEID_COPPERHEAD;=0A=
-         deviceID[1] =3D IPS_DEVICEID_MORPHEUS;=0A=
-      } else if (trombone->bus->number > morpheus->bus->number) {=0A=
-         dev[0] =3D morpheus;=0A=
-         dev[1] =3D trombone;=0A=
-         deviceID[0] =3D IPS_DEVICEID_MORPHEUS;=0A=
-         deviceID[1] =3D IPS_DEVICEID_COPPERHEAD;=0A=
-      } else {=0A=
-         /* further detection required */=0A=
-         if (trombone->devfn < morpheus->devfn) {=0A=
-            dev[0] =3D trombone;=0A=
-            dev[1] =3D morpheus;=0A=
-            deviceID[0] =3D IPS_DEVICEID_COPPERHEAD;=0A=
-            deviceID[1] =3D IPS_DEVICEID_MORPHEUS;=0A=
-         } else {=0A=
-            dev[0] =3D morpheus;=0A=
-            dev[1] =3D trombone;=0A=
-            deviceID[0] =3D IPS_DEVICEID_MORPHEUS;=0A=
-            deviceID[1] =3D IPS_DEVICEID_COPPERHEAD;=0A=
-         }=0A=
-      }=0A=
-   }=0A=
 =0A=
-/**********************************************************************=
************/=0A=
-/* For Kernel Versions 2.4 or greater, use new PCI ( Hot Pluggable ) =
architecture */=0A=
-/**********************************************************************=
************/=0A=
-=0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
  #if LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
    spin_unlock_irq(&io_request_lock);=0A=
  #endif=0A=
@@ -779,485 +602,6 @@=0A=
       register_reboot_notifier(&ips_notifier);=0A=
 =0A=
    return (ips_num_controllers);=0A=
-#endif=0A=
-=0A=
-   /* Now scan the controllers */=0A=
-   for (i =3D 0; i < 2; i++) {=0A=
-      if (!dev[i])=0A=
-         break;=0A=
-=0A=
-      do {=0A=
-         if (ips_next_controller >=3D IPS_MAX_ADAPTERS)=0A=
-            break;=0A=
-=0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
-         if (pci_enable_device(dev[i]))=0A=
-            break;=0A=
-#endif=0A=
-=0A=
-         /* stuff that we get in dev */=0A=
-         irq =3D dev[i]->irq;=0A=
-         bus =3D dev[i]->bus->number;=0A=
-         func =3D dev[i]->devfn;=0A=
-=0A=
-         /* Init MEM/IO addresses to 0 */=0A=
-         mem_addr =3D 0;=0A=
-         io_addr =3D 0;=0A=
-         mem_len =3D 0;=0A=
-         io_len =3D 0;=0A=
-=0A=
-         for (j =3D 0; j < 2; j++) {=0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
-            if (!pci_resource_start(dev[i], j))=0A=
-               break;=0A=
-=0A=
-            if (pci_resource_flags(dev[i], j) & IORESOURCE_IO) {=0A=
-               io_addr =3D pci_resource_start(dev[i], j);=0A=
-               io_len =3D pci_resource_len(dev[i], j);=0A=
-            } else {=0A=
-               mem_addr =3D pci_resource_start(dev[i], j);=0A=
-               mem_len =3D pci_resource_len(dev[i], j);=0A=
-            }=0A=
-#else=0A=
-            if (!dev[i]->base_address[j])=0A=
-               break;=0A=
-=0A=
-            if ((dev[i]->base_address[j] & PCI_BASE_ADDRESS_SPACE) =
=3D=3D PCI_BASE_ADDRESS_SPACE_IO) {=0A=
-               barnum =3D PCI_BASE_ADDRESS_0 + (j * 4);=0A=
-               io_addr =3D dev[i]->base_address[j] & =
PCI_BASE_ADDRESS_IO_MASK;=0A=
-=0A=
-               /* Get Size */=0A=
-               pci_read_config_dword(dev[i], barnum, &currbar);=0A=
-               pci_write_config_dword(dev[i], barnum, ~0);=0A=
-               pci_read_config_dword(dev[i], barnum, &maskbar);=0A=
-               pci_write_config_dword(dev[i], barnum, currbar);=0A=
-=0A=
-               io_len =3D ~(maskbar & PCI_BASE_ADDRESS_IO_MASK) + =
1;=0A=
-            } else {=0A=
-               barnum =3D PCI_BASE_ADDRESS_0 + (j * 4);=0A=
-               mem_addr =3D dev[i]->base_address[j] & =
PCI_BASE_ADDRESS_MEM_MASK;=0A=
-=0A=
-               /* Get Size */=0A=
-               pci_read_config_dword(dev[i], barnum, &currbar);=0A=
-               pci_write_config_dword(dev[i], barnum, ~0);=0A=
-               pci_read_config_dword(dev[i], barnum, &maskbar);=0A=
-               pci_write_config_dword(dev[i], barnum, currbar);=0A=
-=0A=
-               mem_len =3D ~(maskbar & PCI_BASE_ADDRESS_MEM_MASK) + =
1;=0A=
-            }=0A=
-#endif=0A=
-         }=0A=
-=0A=
-         /* setup memory mapped area (if applicable) */=0A=
-         if (mem_addr) {=0A=
-            uint32_t base;=0A=
-            uint32_t offs;=0A=
-=0A=
-            DEBUG_VAR(1, "(%s%d) detect, Memory region %x, size: =
%d",=0A=
-                      ips_name, ips_next_controller, mem_addr, =
mem_len);=0A=
-=0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
-            if (!request_mem_region(mem_addr, mem_len, "ips")) {=0A=
-               /* Couldn't allocate io space */=0A=
-               printk(KERN_WARNING "(%s%d) couldn't allocate IO space =
%x len %d.\n",=0A=
-                      ips_name, ips_next_controller, io_addr, =
io_len);=0A=
-=0A=
-               ips_next_controller++;=0A=
-=0A=
-               continue;=0A=
-            }=0A=
-=0A=
-#endif=0A=
-=0A=
-            base =3D mem_addr & PAGE_MASK;=0A=
-            offs =3D mem_addr - base;=0A=
-=0A=
-            ioremap_ptr =3D ioremap(base, PAGE_SIZE);=0A=
-            mem_ptr =3D ioremap_ptr + offs;=0A=
-         } else {=0A=
-            ioremap_ptr =3D NULL;=0A=
-            mem_ptr =3D NULL;=0A=
-         }=0A=
-=0A=
-         /* setup I/O mapped area (if applicable) */=0A=
-         if (io_addr) {=0A=
-            DEBUG_VAR(1, "(%s%d) detect, IO region %x, size: %d",=0A=
-                      ips_name, ips_next_controller, io_addr, =
io_len);=0A=
-=0A=
-            if (!request_region(io_addr, io_len, "ips")) {=0A=
-               /* Couldn't allocate io space */=0A=
-               printk(KERN_WARNING "(%s%d) couldn't allocate IO space =
%x len %d.\n",=0A=
-                      ips_name, ips_next_controller, io_addr, =
io_len);=0A=
-=0A=
-               ips_next_controller++;=0A=
-=0A=
-               continue;=0A=
-            }=0A=
-         }=0A=
-=0A=
-         /* get planer status */=0A=
-         if (pci_read_config_word(dev[i], 0x04, &planer)) {=0A=
-            printk(KERN_WARNING "(%s%d) can't get planer =
status.\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ips_next_controller++;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-=0A=
-         /* check to see if an onboard planer controller is disabled =
*/=0A=
-         if (!(planer & 0x000C)) {=0A=
-=0A=
-            DEBUG_VAR(1, "(%s%d) detect, Onboard ServeRAID disabled by =
BIOS",=0A=
-                      ips_name, ips_next_controller);=0A=
-=0A=
-            ips_next_controller++;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-=0A=
-         DEBUG_VAR(1, "(%s%d) detect bus %d, func %x, irq %d, io %x, =
mem: %x, ptr: %p",=0A=
-                   ips_name, ips_next_controller, bus, func, irq, =
io_addr, mem_addr, mem_ptr);=0A=
-=0A=
-         /* get the revision ID */=0A=
-         if (pci_read_config_byte(dev[i], PCI_REVISION_ID, =
&revision_id)) {=0A=
-            printk(KERN_WARNING "(%s%d) can't get revision id.\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ips_next_controller++;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-=0A=
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,4,0)=0A=
-         /* get the subdevice id */=0A=
-         if (pci_read_config_word(dev[i], PCI_SUBSYSTEM_ID, =
&subdevice_id)) {=0A=
-            printk(KERN_WARNING "(%s%d) can't get subdevice id.\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ips_next_controller++;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-#else=0A=
-         subdevice_id =3D dev[i]->subsystem_device;=0A=
-#endif=0A=
-=0A=
-         /* found a controller */=0A=
-         sh =3D scsi_register(SHT, sizeof(ips_ha_t));=0A=
-=0A=
-         if (sh =3D=3D NULL) {=0A=
-            printk(KERN_WARNING "(%s%d) Unable to register controller =
with SCSI subsystem - skipping controller\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ips_next_controller++;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-=0A=
-         ha =3D IPS_HA(sh);=0A=
-         memset(ha, 0, sizeof(ips_ha_t));=0A=
-=0A=
-         ips_sh[ips_next_controller] =3D sh;=0A=
-         ips_ha[ips_next_controller] =3D ha;=0A=
-         ips_num_controllers++;=0A=
-         ha->active =3D 1;=0A=
-=0A=
-         ha->enq =3D kmalloc(sizeof(IPS_ENQ), GFP_KERNEL);=0A=
-=0A=
-         if (!ha->enq) {=0A=
-            printk(KERN_WARNING "(%s%d) Unable to allocate host =
inquiry structure - skipping contoller\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ha->active =3D 0;=0A=
-            ips_free(ha);=0A=
-            scsi_unregister(sh);=0A=
-            ips_ha[ips_next_controller] =3D 0;=0A=
-            ips_sh[ips_next_controller] =3D 0;=0A=
-            ips_next_controller++;=0A=
-            ips_num_controllers--;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-=0A=
-         ha->adapt =3D kmalloc(sizeof(IPS_ADAPTER), GFP_KERNEL);=0A=
-=0A=
-         if (!ha->adapt) {=0A=
-            printk(KERN_WARNING "(%s%d) Unable to allocate host adapt =
structure - skipping controller\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ha->active =3D 0;=0A=
-            ips_free(ha);=0A=
-            scsi_unregister(sh);=0A=
-            ips_ha[ips_next_controller] =3D 0;=0A=
-            ips_sh[ips_next_controller] =3D 0;=0A=
-            ips_next_controller++;=0A=
-            ips_num_controllers--;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-=0A=
-         ha->conf =3D kmalloc(sizeof(IPS_CONF), GFP_KERNEL);=0A=
-=0A=
-         if (!ha->conf) {=0A=
-            printk(KERN_WARNING "(%s%d) Unable to allocate host conf =
structure - skipping controller\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ha->active =3D 0;=0A=
-            ips_free(ha);=0A=
-            scsi_unregister(sh);=0A=
-            ips_ha[ips_next_controller] =3D 0;=0A=
-            ips_sh[ips_next_controller] =3D 0;=0A=
-            ips_next_controller++;=0A=
-            ips_num_controllers--;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-=0A=
-         ha->nvram =3D kmalloc(sizeof(IPS_NVRAM_P5), GFP_KERNEL);=0A=
-=0A=
-         if (!ha->nvram) {=0A=
-            printk(KERN_WARNING "(%s%d) Unable to allocate host nvram =
structure - skipping controller\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ha->active =3D 0;=0A=
-            ips_free(ha);=0A=
-            scsi_unregister(sh);=0A=
-            ips_ha[ips_next_controller] =3D 0;=0A=
-            ips_sh[ips_next_controller] =3D 0;=0A=
-            ips_next_controller++;=0A=
-            ips_num_controllers--;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-=0A=
-         ha->subsys =3D kmalloc(sizeof(IPS_SUBSYS), GFP_KERNEL);=0A=
-=0A=
-         if (!ha->subsys) {=0A=
-            printk(KERN_WARNING "(%s%d) Unable to allocate host =
subsystem structure - skipping controller\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ha->active =3D 0;=0A=
-            ips_free(ha);=0A=
-            scsi_unregister(sh);=0A=
-            ips_ha[ips_next_controller] =3D 0;=0A=
-            ips_sh[ips_next_controller] =3D 0;=0A=
-            ips_next_controller++;=0A=
-            ips_num_controllers--;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-=0A=
-         ha->dummy =3D kmalloc(sizeof(IPS_IO_CMD), GFP_KERNEL);=0A=
-=0A=
-         if (!ha->dummy) {=0A=
-            printk(KERN_WARNING "(%s%d) Unable to allocate host dummy =
structure - skipping controller\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ha->active =3D 0;=0A=
-            ips_free(ha);=0A=
-            scsi_unregister(sh);=0A=
-            ips_ha[ips_next_controller] =3D 0;=0A=
-            ips_sh[ips_next_controller] =3D 0;=0A=
-            ips_next_controller++;=0A=
-            ips_num_controllers--;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-=0A=
-         for (count =3D PAGE_SIZE, ha->ioctl_order =3D 0;=0A=
-              count < ips_ioctlsize;=0A=
-              ha->ioctl_order++, count <<=3D 1);=0A=
-=0A=
-         ha->ioctl_data =3D (char *) __get_free_pages(GFP_KERNEL, =
ha->ioctl_order);=0A=
-         ha->ioctl_datasize =3D count;=0A=
-=0A=
-         if (!ha->ioctl_data) {=0A=
-            printk(KERN_WARNING "(%s%d) Unable to allocate ioctl =
data\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ha->ioctl_data =3D NULL;=0A=
-            ha->ioctl_order =3D 0;=0A=
-            ha->ioctl_datasize =3D 0;=0A=
-         }=0A=
-=0A=
-         /* Store away needed values for later use */=0A=
-         sh->io_port =3D io_addr;=0A=
-         sh->n_io_port =3D io_addr ? 255 : 0;=0A=
-         sh->unique_id =3D (io_addr) ? io_addr : mem_addr;=0A=
-         sh->irq =3D irq;=0A=
-         //sh->select_queue_depths =3D ips_select_queue_depth;=0A=
-         sh->sg_tablesize =3D sh->hostt->sg_tablesize;=0A=
-         sh->can_queue =3D sh->hostt->can_queue;=0A=
-         sh->cmd_per_lun =3D sh->hostt->cmd_per_lun;=0A=
-         sh->unchecked_isa_dma =3D sh->hostt->unchecked_isa_dma;=0A=
-         sh->use_clustering =3D sh->hostt->use_clustering;=0A=
-=0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,7)=0A=
-         sh->max_sectors =3D 128;=0A=
-#endif                      =0A=
-=0A=
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,4,0)=0A=
-         sh->wish_block =3D FALSE;=0A=
-#endif=0A=
-=0A=
-         /* Store info in HA structure */=0A=
-         ha->irq =3D irq;=0A=
-         ha->io_addr =3D io_addr;=0A=
-         ha->io_len =3D io_len;=0A=
-         ha->mem_addr =3D mem_addr;=0A=
-         ha->mem_len =3D mem_len;=0A=
-         ha->mem_ptr =3D mem_ptr;=0A=
-         ha->ioremap_ptr =3D ioremap_ptr;=0A=
-         ha->host_num =3D ips_next_controller;=0A=
-         ha->revision_id =3D revision_id;=0A=
-         ha->slot_num =3D PCI_SLOT(dev[i]->devfn);=0A=
-         ha->device_id =3D deviceID[i];=0A=
-         ha->subdevice_id =3D subdevice_id;=0A=
-         ha->pcidev =3D dev[i];=0A=
-=0A=
-         /*=0A=
-          * Setup Functions=0A=
-          */=0A=
-         if (IPS_IS_MORPHEUS(ha)) {=0A=
-            /* morpheus */=0A=
-            ha->func.isintr =3D ips_isintr_morpheus;=0A=
-            ha->func.isinit =3D ips_isinit_morpheus;=0A=
-            ha->func.issue =3D ips_issue_i2o_memio;=0A=
-            ha->func.init =3D ips_init_morpheus;=0A=
-            ha->func.statupd =3D ips_statupd_morpheus;=0A=
-            ha->func.reset =3D ips_reset_morpheus;=0A=
-            ha->func.intr =3D ips_intr_morpheus;=0A=
-            ha->func.enableint =3D ips_enable_int_morpheus;=0A=
-         } else if (IPS_USE_MEMIO(ha)) {=0A=
-            /* copperhead w/MEMIO */=0A=
-            ha->func.isintr =3D ips_isintr_copperhead_memio;=0A=
-            ha->func.isinit =3D ips_isinit_copperhead_memio;=0A=
-            ha->func.init =3D ips_init_copperhead_memio;=0A=
-            ha->func.statupd =3D ips_statupd_copperhead_memio;=0A=
-            ha->func.statinit =3D ips_statinit_memio;=0A=
-            ha->func.reset =3D ips_reset_copperhead_memio;=0A=
-            ha->func.intr =3D ips_intr_copperhead;=0A=
-            ha->func.erasebios =3D ips_erase_bios_memio;=0A=
-            ha->func.programbios =3D ips_program_bios_memio;=0A=
-            ha->func.verifybios =3D ips_verify_bios_memio;=0A=
-            ha->func.enableint =3D ips_enable_int_copperhead_memio;=0A=
-=0A=
-            if (IPS_USE_I2O_DELIVER(ha))=0A=
-               ha->func.issue =3D ips_issue_i2o_memio;=0A=
-            else=0A=
-               ha->func.issue =3D ips_issue_copperhead_memio;=0A=
-         } else {=0A=
-            /* copperhead */=0A=
-            ha->func.isintr =3D ips_isintr_copperhead;=0A=
-            ha->func.isinit =3D ips_isinit_copperhead;=0A=
-            ha->func.init =3D ips_init_copperhead;=0A=
-            ha->func.statupd =3D ips_statupd_copperhead;=0A=
-            ha->func.statinit =3D ips_statinit;=0A=
-            ha->func.reset =3D ips_reset_copperhead;=0A=
-            ha->func.intr =3D ips_intr_copperhead;=0A=
-            ha->func.erasebios =3D ips_erase_bios;=0A=
-            ha->func.programbios =3D ips_program_bios;=0A=
-            ha->func.verifybios =3D ips_verify_bios;=0A=
-            ha->func.enableint =3D ips_enable_int_copperhead;=0A=
-=0A=
-            if (IPS_USE_I2O_DELIVER(ha))=0A=
-               ha->func.issue =3D ips_issue_i2o;=0A=
-            else=0A=
-               ha->func.issue =3D ips_issue_copperhead;=0A=
-         }=0A=
-=0A=
-         /*=0A=
-          * Initialize the card if it isn't already=0A=
-          */=0A=
-=0A=
-         if (!(*ha->func.isinit)(ha)) {=0A=
-            if (!(*ha->func.init)(ha)) {=0A=
-               /*=0A=
-                * Initialization failed=0A=
-                */=0A=
-               printk(KERN_WARNING "(%s%d) unable to initialize =
controller - skipping controller\n",=0A=
-                      ips_name, ips_next_controller);=0A=
-=0A=
-               ha->active =3D 0;=0A=
-               ips_free(ha);=0A=
-               scsi_unregister(sh);=0A=
-               ips_ha[ips_next_controller] =3D 0;=0A=
-               ips_sh[ips_next_controller] =3D 0;=0A=
-               ips_next_controller++;=0A=
-               ips_num_controllers--;=0A=
-=0A=
-               continue;=0A=
-            }=0A=
-         }=0A=
-=0A=
-         /* install the interrupt handler */=0A=
-         if (request_irq(irq, do_ipsintr, SA_SHIRQ, ips_name, ha)) =
{=0A=
-            printk(KERN_WARNING "(%s%d) unable to install interrupt =
handler - skipping controller\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ha->active =3D 0;=0A=
-            ips_free(ha);=0A=
-            scsi_unregister(sh);=0A=
-            ips_ha[ips_next_controller] =3D 0;=0A=
-            ips_sh[ips_next_controller] =3D 0;=0A=
-            ips_next_controller++;=0A=
-            ips_num_controllers--;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-=0A=
-         /*=0A=
-          * Allocate a temporary SCB for initialization=0A=
-          */=0A=
-         ha->max_cmds =3D 1;=0A=
-         if (!ips_allocatescbs(ha)) {=0A=
-            /* couldn't allocate a temp SCB */=0A=
-            printk(KERN_WARNING "(%s%d) unable to allocate CCBs - =
skipping contoller\n",=0A=
-                   ips_name, ips_next_controller);=0A=
-=0A=
-            ha->active =3D 0;=0A=
-            ips_free(ha);=0A=
-            scsi_unregister(sh);=0A=
-            ips_ha[ips_next_controller] =3D 0;=0A=
-            ips_sh[ips_next_controller] =3D 0;=0A=
-            free_irq(ha->irq, ha);=0A=
-            ips_next_controller++;=0A=
-            ips_num_controllers--;=0A=
-=0A=
-            continue;=0A=
-         }=0A=
-=0A=
-         ips_next_controller++;=0A=
-      } while ((dev[i] =3D pci_find_device(IPS_VENDORID, deviceID[i], =
dev[i])));=0A=
-   }=0A=
-=0A=
-   /*=0A=
-    * Do Phase 2 Initialization=0A=
-    * Controller init=0A=
-    */=0A=
-   for (i =3D 0; i < ips_next_controller; i++) {=0A=
-=0A=
-      if (ips_ha[i] =3D=3D 0) {=0A=
-         printk(KERN_WARNING "(%s%d) ignoring bad controller\n", =
ips_name, i);=0A=
-         continue;=0A=
-      }=0A=
-=0A=
-      if (ips_init_phase2(i) !=3D SUCCESS)=0A=
-         ips_num_controllers--;=0A=
-=0A=
-   }=0A=
-=0A=
-   if (ips_num_controllers > 0)=0A=
-      register_reboot_notifier(&ips_notifier);=0A=
-=0A=
-   return (ips_num_controllers);=0A=
-=0A=
-#else=0A=
-=0A=
-   /* No PCI -- No ServeRAID */=0A=
-   return (0);=0A=
-#endif /* CONFIG_PCI */=0A=
 }=0A=
 =0A=
 =
/***********************************************************************=
*****/=0A=
@@ -1282,9 +626,7 @@=0A=
    if (i =3D=3D IPS_MAX_ADAPTERS) {=0A=
       printk(KERN_WARNING "(%s) release, invalid Scsi_Host =
pointer.\n",=0A=
             ips_name);=0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
       BUG();=0A=
-#endif=0A=
       return (FALSE);=0A=
    }=0A=
 =0A=
@@ -4957,10 +4299,8 @@=0A=
          ha->mem_ptr =3D NULL;=0A=
       }=0A=
 =0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
       if (ha->mem_addr) =0A=
           release_mem_region(ha->mem_addr, ha->mem_len);=0A=
-#endif=0A=
       ha->mem_addr =3D 0;=0A=
 =0A=
    }=0A=
@@ -7186,10 +6526,8 @@=0A=
 =0A=
   =0A=
 =0A=
-#if defined (MODULE) || (LINUX_VERSION_CODE >=3D =
LinuxVersionCode(2,4,0))=0A=
 static Scsi_Host_Template driver_template =3D IPS;=0A=
 #include "scsi_module.c"=0A=
-#endif=0A=
 =0A=
 static int ips_abort_init(ips_ha_t *ha, struct Scsi_Host *sh, int =
index){=0A=
    ha->active =3D 0;=0A=
@@ -7200,7 +6538,6 @@=0A=
    return -1;=0A=
 }=0A=
 =0A=
-#if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,0)=0A=
 =0A=
 =
/*----------------------------------------------------------------------=
-----*/=0A=
 /*   Routine Name: ips_remove_device                                   =
      */=0A=
@@ -7542,7 +6879,6 @@=0A=
     return SUCCESS;=0A=
 }=0A=
 =0A=
-#endif=0A=
 =0A=
 =
/*----------------------------------------------------------------------=
-----*/=0A=
 /*   Routine Name: ips_init_phase2                                     =
      */=0A=
diff -ur linux-2.5.54_p0/drivers/scsi/ips.h =
linux-2.5.54_p1/drivers/scsi/ips.h=0A=
--- linux-2.5.54_p0/drivers/scsi/ips.h	Thu Jan  2 11:23:11 2003=0A=
+++ linux-2.5.54_p1/drivers/scsi/ips.h	Thu Jan  2 11:06:26 2003=0A=
@@ -406,36 +406,7 @@=0A=
    /*=0A=
     * Scsi_Host Template=0A=
     */=0A=
-#if LINUX_VERSION_CODE < LinuxVersionCode(2,4,0)=0A=
-#define IPS {	\=0A=
-	.module				=3D NULL,		\=0A=
-	.proc_info			=3D NULL,		\=0A=
-	.proc_dir			=3D NULL,		\=0A=
-	.name				=3D NULL,		\=0A=
-	.detect				=3D ips_detect,	\=0A=
-	.release			=3D ips_release,	\=0A=
-	.info				=3D ips_info,	\=0A=
-	.command			=3D NULL,		\=0A=
-	.queuecommand			=3D ips_queue,	\=0A=
-	.eh_strategy_handler		=3D NULL,		\=0A=
-	.eh_abort_handler		=3D ips_eh_abort,	\=0A=
-	.eh_device_reset_handler	=3D NULL,		\=0A=
-	.eh_bus_reset_handler		=3D NULL,		\=0A=
-	.eh_host_reset_handler		=3D ips_eh_reset,	\=0A=
-	.abort				=3D NULL,		\=0A=
-	.reset				=3D NULL,		\=0A=
-	.slave_attach			=3D NULL,		\=0A=
-	.bios_param			=3D ips_biosparam,\=0A=
-	.can_queue			=3D 0,		\=0A=
-	.this_id			=3D -1,		\=0A=
-	.sg_tablesize			=3D IPS_MAX_SG,	\=0A=
-	.cmd_per_lun			=3D 3,		\=0A=
-	.present			=3D 0,		\=0A=
-	.unchecked_isa_dma		=3D 0,		\=0A=
-	.use_clustering			=3D ENABLE_CLUSTERING,	\=0A=
-	.use_new_eh_code		=3D 1 \=0A=
-}=0A=
-#elif LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
+#if LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
 #define IPS{	\=0A=
 	.module				=3D NULL,		\=0A=
 	.proc_info			=3D NULL,		\=0A=

------_=_NextPart_000_01C2B28A.DA173460--
