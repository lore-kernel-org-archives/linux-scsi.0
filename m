From: "Ju, Seokmann" <sju@lsil.com>
Subject: [Announce] megaraid_mbox 2.20.4.3 patch
Date: Tue, 25 Jan 2005 19:52:42 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570366262C@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63678 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262083AbVAZAwp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 19:52:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>, "Ju, Seokmann" <sju@lsil.com>

Hello,

Here is a patch for megaraid_mbox 2.20.4.3 and megaraid_mm 2.20.2.5.
The patch includes following changes/fixes
- sysfs support for drive addition/removal
- Tape drive timeout issue
- Made some code static

I am attaching and inlining the patch.

Thank you.

Seokmann
LSI Logic

---

diff -Naur linux_bk/Documentation/scsi/ChangeLog.megaraid
linux_bk.new/Documentation/scsi/ChangeLog.megaraid
--- linux_bk/Documentation/scsi/ChangeLog.megaraid=A0=A0=A0 2005-01-25
18:12:46.000000000 -0500
+++ linux_bk.new/Documentation/scsi/ChangeLog.megaraid=A0=A0=A0=A0=A0 2=
005-01-25
18:21:48.525354048 -0500
@@ -1,3 +1,77 @@
+Release Date=A0=A0=A0=A0 : Fri Jan 21 00:01:03 EST 2005 - Atul Mukker
<atulm@lsil.com>
+Current Version=A0 : 2.20.4.3 (scsi module), 2.20.2.5 (cmm module)
+Older Version=A0=A0=A0 : 2.20.4.2 (scsi module), 2.20.2.4 (cmm module)
+
+i.=A0=A0 Remove driver ioctl for logical drive to scsi address transla=
tion and
+=A0=A0=A0=A0 replace with the sysfs attribute. To remove drives and ch=
ange
+=A0=A0=A0=A0 capacity, application shall now use the device attribute =
to get the
+=A0=A0=A0=A0 logical drive number for a scsi device. For adding newly =
created
+=A0=A0=A0=A0 logical drives, class device attribute would be required =
to uniquely
+=A0=A0=A0=A0 identify each controller.
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 - Atul Mukker <atulm@lsil.com>
+
+=A0=A0=A0=A0 "James, I've been thinking about this a little more, and =
you may be on
+=A0=A0=A0=A0 to something here. Let each driver add files as such:"
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 - Matt Domsch <Matt_Domsch@dell.com>, 1=
2.15.2004
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 linux-scsi mailing list
+
+
+=A0=A0=A0=A0 "Then, if you simply publish your LD number as an extra p=
arameter of
+=A0=A0=A0=A0 the device, you can look through /sys to find it."
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 - James Bottomley <James.Bottomley@Stee=
lEye.com>, 01.03.2005
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 linux-scsi mailing list
+
+
+=A0=A0=A0=A0 "I don't see why not ... it's your driver, you can publis=
h whatever
+=A0=A0=A0=A0 extra information you need as scsi_device attributes; tha=
t was one of
+=A0=A0=A0=A0 the designs of the extensible attribute system."
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 - James Bottomley <James.Bottomley@Stee=
lEye.com>, 01.06.2005
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 linux-scsi mailing list
+
+ii.=A0 Add AMI megaraid support - Brian King <brking@charter.net>
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_ME=
GARAID3,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_VENDOR_ID_AMI, PCI_SUBSYS_ID_PERC3_=
DC,
+
+iii. Make some code static
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 - Adrian Bunk <bunk@stusta.de>, 11.15.2=
004
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 linux-scsi mailing list
+
+iv.=A0 Added NEC ROMB support - NEC MegaRAID PCI Express ROMB controll=
er
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_=
MEGARAID_NEC_ROMB_2E,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_SUBSYS_ID_NEC, PCI_SUBSYS_ID_MEGARA=
ID_NEC_ROMB_2E,
+
+v.=A0=A0 Fixed Tape drive issue : For any Direct CDB command to physic=
al device
+=A0=A0=A0=A0 including tape, timeout value set by driver was 10 minute=
s. With this
+=A0=A0=A0=A0 value, most of command will return within timeout. Howeve=
r, for those
+=A0=A0=A0=A0 command like ERASE or FORMAT, it takes more than an hour =
depends on
+=A0=A0=A0=A0 capacity of the device and the command could be terminate=
d before it
+=A0=A0=A0=A0 completes.
+=A0=A0=A0=A0 To address this issue, the 'timeout' field in the DCDB co=
mmand will
+=A0=A0=A0=A0 have NO TIMEOUT (i.e., 4) value as its timeout on DCDB co=
mmand.
+
+
+Release Date=A0=A0=A0=A0 : Thu Dec=A0 9 19:10:23 EST 2004
+=A0=A0=A0=A0 - Sreenivas Bagalkote <sreenib@lsil.com>
+
+Current Version=A0 : 2.20.4.2 (scsi module), 2.20.2.4 (cmm module)
+Older Version=A0=A0=A0 : 2.20.4.1 (scsi module), 2.20.2.3 (cmm module)
+
+i.=A0=A0 Introduced driver ioctl that returns scsi address for a given=
 ld.
+
+=A0=A0=A0=A0 "Why can't the existing sysfs interfaces be used to do th=
is?"
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 - Brian King (brking@us.ibm.com)
+
+=A0=A0=A0=A0 "I've looked into solving this another way, but I cannot =
see how
+=A0=A0=A0=A0 to get this driver-private mapping of logical drive numbe=
r-> HCTL
+=A0=A0=A0=A0 without putting code something like this into the driver.=
"
+
+=A0=A0=A0=A0 "...and by providing a mapping a function to userspace, t=
he driver
+=A0=A0=A0=A0 is free to change its mapping algorithm in the future if =
necessary .."
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 - Matt Domsch (Matt_Domsch@dell.com)
+
=A0Release Date=A0=A0=A0=A0 : Thu Dec=A0 9 19:02:14 EST 2004 - Sreeniva=
s Bagalkote
<sreenib@lsil.com>
=A0
=A0Current Version=A0 : 2.20.4.1 (scsi module), 2.20.2.3 (cmm module)
diff -Naur linux_bk/drivers/scsi/megaraid/Kconfig.megaraid
linux_bk.new/drivers/scsi/megaraid/Kconfig.megaraid
--- linux_bk/drivers/scsi/megaraid/Kconfig.megaraid=A0=A0 2005-01-25
18:13:37.000000000 -0500
+++ linux_bk.new/drivers/scsi/megaraid/Kconfig.megaraid=A0=A0=A0=A0 200=
5-01-25
18:22:19.382663024 -0500
@@ -59,6 +59,7 @@
=A0=A0=A0=A0=A0 INTEL RAID Controller SRCU51L 1000:1960:8086:0520
=A0=A0=A0=A0=A0 FSC MegaRAID PCI Express ROMB 1000:0408:1734:1065
=A0=A0=A0=A0=A0 ACER MegaRAID ROMB-2E=A0=A0=A0=A0=A0=A0=A0=A0 1000:0408=
:1025:004D
+=A0=A0=A0=A0 NEC MegaRAID PCI Express ROMB 1000:0408:1033:8287
=A0
=A0=A0=A0=A0=A0 To compile this driver as a module, choose M here: the
=A0=A0=A0=A0=A0 module will be called megaraid_mbox
diff -Naur linux_bk/drivers/scsi/megaraid/mega_common.h
linux_bk.new/drivers/scsi/megaraid/mega_common.h
--- linux_bk/drivers/scsi/megaraid/mega_common.h=A0=A0=A0=A0=A0 2005-01=
-25
18:13:37.000000000 -0500
+++ linux_bk.new/drivers/scsi/megaraid/mega_common.h=A0 2005-01-25
18:22:22.547181944 -0500
@@ -221,6 +221,9 @@
=A0#define MRAID_IS_LOGICAL(adp, scp) \
=A0=A0=A0=A0=A0 (SCP2CHANNEL(scp) =3D=3D (adp)->max_channel) ? 1 : 0
=A0
+#define MRAID_IS_LOGICAL_SDEV(adp, sdev) \
+=A0=A0=A0=A0 (sdev->channel =3D=3D (adp)->max_channel) ? 1 : 0
+
=A0#define MRAID_GET_DEVICE_MAP(adp, scp, p_chan, target, islogical)=A0=
=A0=A0=A0=A0 \
=A0=A0=A0=A0=A0 /*=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 \
=A0=A0=A0=A0=A0 =A0* Is the request coming for the virtual channel=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 \
diff -Naur linux_bk/drivers/scsi/megaraid/megaraid_ioctl.h
linux_bk.new/drivers/scsi/megaraid/megaraid_ioctl.h
--- linux_bk/drivers/scsi/megaraid/megaraid_ioctl.h=A0=A0 2005-01-25
18:13:37.000000000 -0500
+++ linux_bk.new/drivers/scsi/megaraid/megaraid_ioctl.h=A0=A0=A0=A0 200=
5-01-25
18:22:23.345060648 -0500
@@ -291,5 +291,6 @@
=A0
=A0int mraid_mm_register_adp(mraid_mmadp_t *);
=A0int mraid_mm_unregister_adp(uint32_t);
+uint32_t mraid_mm_adapter_app_handle(uint32_t);
=A0
=A0#endif /* _MEGARAID_IOCTL_H_ */
diff -Naur linux_bk/drivers/scsi/megaraid/megaraid_mbox.c
linux_bk.new/drivers/scsi/megaraid/megaraid_mbox.c
--- linux_bk/drivers/scsi/megaraid/megaraid_mbox.c=A0=A0=A0 2005-01-25
18:13:37.000000000 -0500
+++ linux_bk.new/drivers/scsi/megaraid/megaraid_mbox.c=A0=A0=A0=A0=A0 2=
005-01-25
18:22:24.359906368 -0500
@@ -10,7 +10,7 @@
=A0 *=A0=A0 =A0=A0 2 of the License, or (at your option) any later vers=
ion.
=A0 *
=A0 * FILE=A0=A0=A0=A0=A0=A0=A0=A0=A0 : megaraid_mbox.c
- * Version : v2.20.4.1 (Nov 04 2004)
+ * Version : v2.20.4.3 (Jan 21 2005)
=A0 *
=A0 * Authors:
=A0 * =A0 Atul Mukker=A0=A0=A0=A0=A0=A0 <Atul.Mukker@lsil.com>
@@ -60,12 +60,11 @@
=A0 * INTEL RAID Controller SROMBU42E 1000=A0 0408=A0 8086=A0 3499
=A0 * INTEL RAID Controller SRCU51L=A0=A0 1000=A0 1960=A0 8086=A0 0520
=A0 *
- *
=A0 * FSC=A0=A0=A0=A0 MegaRAID PCI Express ROMB=A0=A0=A0=A0 1000=A0 040=
8=A0 1734=A0 1065
=A0 *
- *
=A0 * ACER=A0=A0=A0 MegaRAID ROMB-2E=A0=A0=A0=A0=A0=A0=A0 1000=A0 0408=A0=
 1025=A0 004D
=A0 *
+ * NEC=A0=A0=A0=A0 MegaRAID PCI Express ROMB=A0=A0=A0=A0 1000=A0 0408=A0=
 1033=A0 8287
=A0 *
=A0 * For history of changes, see Documentation/ChangeLog.megaraid
=A0 */
@@ -91,6 +90,9 @@
=A0static int megaraid_mbox_setup_dma_pools(adapter_t *);
=A0static void megaraid_mbox_teardown_dma_pools(adapter_t *);
=A0
+static int megaraid_sysfs_alloc_resources(adapter_t *);
+static void megaraid_sysfs_free_resources(adapter_t *);
+
=A0static int megaraid_abort_handler(struct scsi_cmnd *);
=A0static int megaraid_reset_handler(struct scsi_cmnd *);
=A0
@@ -121,6 +123,9 @@
=A0
=A0static void megaraid_mbox_dpc(unsigned long);
=A0
+static ssize_t megaraid_sysfs_show_app_hndl(struct class_device *, cha=
r *);
+static ssize_t megaraid_sysfs_show_ldnum(struct device *, char *);
+
=A0static int megaraid_cmm_register(adapter_t *);
=A0static int megaraid_cmm_unregister(adapter_t *);
=A0static int megaraid_mbox_mm_handler(unsigned long, uioc_t *, uint32_=
t);
@@ -197,7 +202,7 @@
=A0 * ### global data ###
=A0 */
=A0static uint8_t megaraid_mbox_version[8] =3D
-=A0=A0=A0=A0 { 0x02, 0x20, 0x04, 0x00, 9, 27, 20, 4 };
+=A0=A0=A0=A0 { 0x02, 0x20, 0x04, 0x03, 1, 21, 20, 5 };
=A0
=A0
=A0/*
@@ -301,6 +306,12 @@
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_SUBSYS_ID_PERC3_SC,
=A0=A0=A0=A0=A0 },
=A0=A0=A0=A0=A0 {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_VENDOR_ID_AMI,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_DEVICE_ID_AMI_MEGARAID3,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_VENDOR_ID_AMI,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_SUBSYS_ID_PERC3_DC,
+=A0=A0=A0=A0 },
+=A0=A0=A0=A0 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_VENDOR_ID_LSI_LOGIC,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_DEVICE_ID_MEGARAID_SCSI_320_0,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_VENDOR_ID_LSI_LOGIC,
@@ -438,6 +449,12 @@
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_VENDOR_ID_AI,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_SUBSYS_ID_MEGARAID_ACER_ROMB_2E,
=A0=A0=A0=A0=A0 },
+=A0=A0=A0=A0 {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_VENDOR_ID_LSI_LOGIC,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_DEVICE_ID_MEGARAID_NEC_ROMB_2E,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_VENDOR_ID_NEC,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PCI_SUBSYS_ID_MEGARAID_NEC_ROMB_2E,
+=A0=A0=A0=A0 },
=A0=A0=A0=A0=A0 {0}=A0=A0 /* Terminating entry */
=A0};
=A0MODULE_DEVICE_TABLE(pci, pci_id_table_g);
@@ -454,6 +471,29 @@
=A0};
=A0
=A0
+
+// definitions for the device attributes for exporting logical drive n=
umber
+// for a scsi address (Host, Channel, Id, Lun)
+
+CLASS_DEVICE_ATTR(megaraid_mbox_app_hndl, S_IRUSR,
megaraid_sysfs_show_app_hndl,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 NULL);
+
+// Host template initializer for megaraid mbox sysfs device attributes
+static struct class_device_attribute *megaraid_class_device_attrs[] =3D=
 {
+=A0=A0=A0=A0 &class_device_attr_megaraid_mbox_app_hndl,
+=A0=A0=A0=A0 NULL,
+};
+
+
+DEVICE_ATTR(megaraid_mbox_ld, S_IRUSR, megaraid_sysfs_show_ldnum, NULL=
);
+
+// Host template initializer for megaraid mbox sysfs device attributes
+static struct device_attribute *megaraid_device_attrs[] =3D {
+=A0=A0=A0=A0 &dev_attr_megaraid_mbox_ld,
+=A0=A0=A0=A0 NULL,
+};
+
+
=A0/*
=A0 * Scsi host template for megaraid unified driver
=A0 */
@@ -467,6 +507,8 @@
=A0=A0=A0=A0=A0 .eh_bus_reset_handler=A0=A0=A0=A0=A0=A0=A0=A0 =3D megar=
aid_reset_handler,
=A0=A0=A0=A0=A0 .eh_host_reset_handler=A0=A0=A0=A0=A0=A0=A0 =3D megarai=
d_reset_handler,
=A0=A0=A0=A0=A0 .use_clustering=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 =3D ENABLE_CLUSTERING,
+=A0=A0=A0=A0 .sdev_attrs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D megar=
aid_device_attrs,
+=A0=A0=A0=A0 .shost_attrs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 =3D megaraid_class_device_attrs,
=A0};
=A0
=A0
@@ -953,6 +995,8 @@
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 adapter->device_ids[adapter->max_chan=
nel][adapter->init_id] =3D
=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0xFF;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 raid_dev->random_del_supported =3D 1;
=A0=A0=A0=A0=A0 }
=A0
=A0=A0=A0=A0=A0 /*
@@ -977,6 +1021,14 @@
=A0=A0=A0=A0=A0 =A0*/
=A0=A0=A0=A0=A0 adapter->cmd_per_lun =3D megaraid_cmd_per_lun;
=A0
+=A0=A0=A0=A0 /*
+=A0=A0=A0=A0 * Allocate resources required to issue FW calls, when sys=
fs is
+=A0=A0=A0=A0 * accessed
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 if (megaraid_sysfs_alloc_resources(adapter) !=3D 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out_alloc_cmds;
+=A0=A0=A0=A0 }
+
=A0=A0=A0=A0=A0 // Set the DMA mask to 64-bit. All supported controller=
s as capable of
=A0=A0=A0=A0=A0 // DMA in this range
=A0=A0=A0=A0=A0 if (pci_set_dma_mask(adapter->pdev, 0xFFFFFFFFFFFFFFFFU=
LL) !=3D 0) {
@@ -984,7 +1036,7 @@
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con_log(CL_ANN, (KERN_WARNING
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "megaraid: could no=
t set DMA mask for 64-bit.\n"));
=A0
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out_alloc_cmds;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out_free_sysfs_res;
=A0=A0=A0=A0=A0 }
=A0
=A0=A0=A0=A0=A0 // setup tasklet for DPC
@@ -996,6 +1048,8 @@
=A0
=A0=A0=A0=A0=A0 return 0;
=A0
+out_free_sysfs_res:
+=A0=A0=A0=A0 megaraid_sysfs_free_resources(adapter);
=A0out_alloc_cmds:
=A0=A0=A0=A0=A0 megaraid_free_cmd_packets(adapter);
=A0out_free_irq:
@@ -1025,6 +1079,8 @@
=A0
=A0=A0=A0=A0=A0 tasklet_kill(&adapter->dpc_h);
=A0
+=A0=A0=A0=A0 megaraid_sysfs_free_resources(adapter);
+
=A0=A0=A0=A0=A0 megaraid_free_cmd_packets(adapter);
=A0
=A0=A0=A0=A0=A0 free_irq(adapter->irq, adapter);
@@ -1559,12 +1615,14 @@
=A0
=A0=A0=A0=A0=A0 if (scb->dma_direction =3D=3D PCI_DMA_TODEVICE) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!scb->scp->use_sg) {=A0=A0=A0=A0=A0=
 // sg list not used
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pci_dma_sync_single_f=
or_device(adapter->pdev,
ccb->buf_dma_h,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pci_dma_sync_single_f=
or_device(adapter->pdev,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 ccb->buf_dma_h,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 scb->scp->request_bufflen,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 PCI_DMA_TODEVICE);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pci_dma_sync_sg_for_d=
evice(adapter->pdev,
scb->scp->request_buffer,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pci_dma_sync_sg_for_d=
evice(adapter->pdev,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scb=
->scp->request_buffer,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
cb->scp->use_sg, PCI_DMA_TODEVICE);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 }
@@ -2107,7 +2165,8 @@
=A0=A0=A0=A0=A0 channel=A0=A0=A0=A0 =3D scb->dev_channel;
=A0=A0=A0=A0=A0 target=A0=A0=A0=A0=A0 =3D scb->dev_target;
=A0
-=A0=A0=A0=A0 pthru->timeout=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 1;=A0 // 0=3D=
6sec, 1=3D60sec, 2=3D10min, 3=3D3hrs
+=A0=A0=A0=A0 // 0=3D6sec, 1=3D60sec, 2=3D10min, 3=3D3hrs, 4=3DNO timeo=
ut
+=A0=A0=A0=A0 pthru->timeout=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 4;=A0=20
=A0=A0=A0=A0=A0 pthru->ars=A0=A0=A0=A0=A0=A0=A0 =3D 1;
=A0=A0=A0=A0=A0 pthru->islogical=A0 =3D 0;
=A0=A0=A0=A0=A0 pthru->channel=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0;
@@ -2155,7 +2214,8 @@
=A0=A0=A0=A0=A0 channel=A0=A0=A0=A0 =3D scb->dev_channel;
=A0=A0=A0=A0=A0 target=A0=A0=A0=A0=A0 =3D scb->dev_target;
=A0
-=A0=A0=A0=A0 epthru->timeout=A0=A0=A0=A0=A0=A0=A0=A0 =3D 1;=A0 // 0=3D=
6sec, 1=3D60sec, 2=3D10min, 3=3D3hrs
+=A0=A0=A0=A0 // 0=3D6sec, 1=3D60sec, 2=3D10min, 3=3D3hrs, 4=3DNO timeo=
ut
+=A0=A0=A0=A0 epthru->timeout=A0=A0=A0=A0=A0=A0=A0=A0 =3D 4;=A0=20
=A0=A0=A0=A0=A0 epthru->ars=A0=A0=A0=A0=A0=A0 =3D 1;
=A0=A0=A0=A0=A0 epthru->islogical =3D 0;
=A0=A0=A0=A0=A0 epthru->channel=A0=A0=A0=A0=A0=A0=A0=A0 =3D 0;
@@ -3306,7 +3366,7 @@
=A0=A0=A0=A0=A0 memset((caddr_t)raw_mbox, 0, sizeof(mbox_t));
=A0
=A0=A0=A0=A0=A0 raw_mbox[0] =3D FC_DEL_LOGDRV;
-=A0=A0=A0=A0 raw_mbox[0] =3D OP_SUP_DEL_LOGDRV;
+=A0=A0=A0=A0 raw_mbox[2] =3D OP_SUP_DEL_LOGDRV;
=A0
=A0=A0=A0=A0=A0 // Issue the command
=A0=A0=A0=A0=A0 rval =3D 0;
@@ -3719,8 +3779,9 @@
=A0
=A0=A0=A0=A0=A0 spin_unlock_irqrestore(USER_FREE_LIST_LOCK(adapter), fl=
ags);
=A0
-=A0=A0=A0=A0 scb->state=A0 =3D SCB_ACTIVE;
-=A0=A0=A0=A0 scb->dma_type=A0=A0=A0=A0 =3D MRAID_DMA_NONE;
+=A0=A0=A0=A0 scb->state=A0=A0=A0=A0=A0=A0=A0 =3D SCB_ACTIVE;
+=A0=A0=A0=A0 scb->dma_type=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D MRAID_DMA=
_NONE;
+=A0=A0=A0=A0 scb->dma_direction=A0=A0=A0=A0=A0 =3D PCI_DMA_NONE;
=A0
=A0=A0=A0=A0=A0 ccb=A0=A0=A0=A0=A0=A0=A0=A0 =3D (mbox_ccb_t *)scb->ccb;
=A0=A0=A0=A0=A0 mbox64=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D (mbox64_t *=
)(unsigned long)kioc->cmdbuf;
@@ -3888,6 +3949,324 @@
=A0 */
=A0
=A0
+
+/**
+ * megaraid_sysfs_alloc_resources - allocate sysfs related resources
+ *
+ * Allocate packets required to issue FW calls whenever the sysfs
attributes
+ * are read. These attributes would require up-to-date information fro=
m the
+ * FW. Also set up resources for mutual exclusion to share these resou=
rces
and
+ * the wait queue.
+ *
+ * @param adapter : controller's soft state
+ *
+ * @return 0 on success
+ * @return -ERROR_CODE on failure
+ */
+static int
+megaraid_sysfs_alloc_resources(adapter_t *adapter)
+{
+=A0=A0=A0=A0 mraid_device_t=A0=A0=A0 *raid_dev =3D ADAP2RAIDDEV(adapte=
r);
+=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0 rval =3D 0;
+
+=A0=A0=A0=A0 raid_dev->sysfs_uioc =3D kmalloc(sizeof(uioc_t), GFP_KERN=
EL);
+
+=A0=A0=A0=A0 raid_dev->sysfs_mbox64 =3D kmalloc(sizeof(mbox64_t), GFP_=
KERNEL);
+
+=A0=A0=A0=A0 raid_dev->sysfs_buffer =3D pci_alloc_consistent(adapter->=
pdev,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PAGE_SIZE, &raid_dev-=
>sysfs_buffer_dma);
+
+=A0=A0=A0=A0 if (!raid_dev->sysfs_uioc || !raid_dev->sysfs_mbox64 ||
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !raid_dev->sysfs_buffer) {
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con_log(CL_ANN, (KERN_WARNING
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "megaraid: out of mem=
ory, %s %d\n", __FUNCTION__,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __LINE__));
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rval =3D -ENOMEM;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 megaraid_sysfs_free_resources(adapter);
+=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0 sema_init(&raid_dev->sysfs_sem, 1);
+
+=A0=A0=A0=A0 init_waitqueue_head(&raid_dev->sysfs_wait_q);
+
+=A0=A0=A0=A0 return rval;
+}
+
+
+/**
+ * megaraid_sysfs_free_resources - free sysfs related resources
+ *
+ * Free packets allocated for sysfs FW commands
+ *
+ * @param adapter : controller's soft state
+ */
+static void
+megaraid_sysfs_free_resources(adapter_t *adapter)
+{
+=A0=A0=A0=A0 mraid_device_t=A0=A0=A0 *raid_dev =3D ADAP2RAIDDEV(adapte=
r);
+
+=A0=A0=A0=A0 if (raid_dev->sysfs_uioc) kfree(raid_dev->sysfs_uioc);
+
+=A0=A0=A0=A0 if (raid_dev->sysfs_mbox64) kfree(raid_dev->sysfs_mbox64)=
;
+
+=A0=A0=A0=A0 if (raid_dev->sysfs_buffer) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pci_free_consistent(adapter->pdev, PAGE=
_SIZE,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 raid_dev->sysfs_buffe=
r, raid_dev->sysfs_buffer_dma);
+=A0=A0=A0=A0 }
+}
+
+
+/**
+ * megaraid_sysfs_get_ldmap_done - callback for get ldmap
+ *
+ * Callback routine called in the ISR/tasklet context for get ldmap ca=
ll
+ *
+ * @param uioc : completed packet
+ */
+static void
+megaraid_sysfs_get_ldmap_done(uioc_t *uioc)
+{
+=A0=A0=A0=A0 adapter_t=A0=A0 *adapter =3D (adapter_t *)uioc->buf_vaddr=
;
+=A0=A0=A0=A0 mraid_device_t=A0=A0=A0 *raid_dev =3D ADAP2RAIDDEV(adapte=
r);
+
+=A0=A0=A0=A0 uioc->status =3D 0;
+
+=A0=A0=A0=A0 wake_up(&raid_dev->sysfs_wait_q);
+}
+
+
+/**
+ * megaraid_sysfs_get_ldmap_timeout - timeout handling for get ldmap
+ *
+ * Timeout routine to recover and return to application, in case the
adapter
+ * has stopped responding. A timeout of 60 seconds for this command se=
em
like
+ * a good value
+ *
+ * @param uioc : timed out packet
+ */
+static void
+megaraid_sysfs_get_ldmap_timeout(unsigned long data)
+{
+=A0=A0=A0=A0 uioc_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *uioc =3D (uioc_t=
 *)data;
+=A0=A0=A0=A0 adapter_t=A0=A0 *adapter =3D (adapter_t *)uioc->buf_vaddr=
;
+=A0=A0=A0=A0 mraid_device_t=A0=A0=A0 *raid_dev =3D ADAP2RAIDDEV(adapte=
r);
+
+=A0=A0=A0=A0 uioc->status =3D -ETIME;
+
+=A0=A0=A0=A0 wake_up(&raid_dev->sysfs_wait_q);
+}
+
+
+/**
+ * megaraid_sysfs_get_ldmap - get update logical drive map
+ *
+ * This routine will be called whenever user reads the logical drive
+ * attributes, go get the current logical drive mapping table from the
+ * firmware. We use the managment API's to issue commands to the
controller.
+ *
+ * NOTE: The commands issuance functionality is not generalized and
+ * implemented in context of "get ld map" command only. If required, t=
he
+ * command issuance logical can be trivially pulled out and implemente=
d as
a
+ * standalone libary. For now, this should suffice since there is no o=
ther
+ * user of this interface.
+ *
+ * @param adapter : controller's soft state
+ *
+ * @return 0 on success
+ * @return -1 on failure
+ */
+static int
+megaraid_sysfs_get_ldmap(adapter_t *adapter)
+{
+=A0=A0=A0=A0 mraid_device_t=A0=A0=A0=A0=A0=A0=A0=A0=A0 *raid_dev =3D A=
DAP2RAIDDEV(adapter);
+=A0=A0=A0=A0 uioc_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 *uioc;
+=A0=A0=A0=A0 mbox64_t=A0=A0=A0=A0=A0=A0=A0=A0=A0 *mbox64;
+=A0=A0=A0=A0 mbox_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 *mbox;
+=A0=A0=A0=A0 char=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *raw_mbox;
+=A0=A0=A0=A0 struct timer_list sysfs_timer;
+=A0=A0=A0=A0 struct timer_list *timerp;
+=A0=A0=A0=A0 caddr_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 l=
dmap;
+=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rval =3D 0;
+
+=A0=A0=A0=A0 /*
+=A0=A0=A0=A0 * Allow only one read at a time to go through the sysfs a=
ttributes
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 down(&raid_dev->sysfs_sem);
+
+=A0=A0=A0=A0 uioc=A0 =3D raid_dev->sysfs_uioc;
+=A0=A0=A0=A0 mbox64=A0=A0=A0=A0=A0 =3D raid_dev->sysfs_mbox64;
+=A0=A0=A0=A0 ldmap =3D raid_dev->sysfs_buffer;
+
+=A0=A0=A0=A0 memset(uioc, sizeof(uioc_t), 0);
+=A0=A0=A0=A0 memset(mbox64, sizeof(mbox64_t), 0);
+=A0=A0=A0=A0 memset(ldmap, sizeof(raid_dev->curr_ldmap), 0);
+
+=A0=A0=A0=A0 mbox=A0=A0=A0=A0=A0=A0=A0 =3D &mbox64->mbox32;
+=A0=A0=A0=A0 raw_mbox=A0=A0=A0 =3D (char *)mbox;
+=A0=A0=A0=A0 uioc->cmdbuf=A0=A0=A0 =3D (uint64_t)(unsigned long)mbox64=
;
+=A0=A0=A0=A0 uioc->buf_vaddr=A0=A0 =3D (caddr_t)adapter;
+=A0=A0=A0=A0 uioc->status=A0=A0=A0=A0=A0 =3D -ENODATA;
+=A0=A0=A0=A0 uioc->done=A0 =3D megaraid_sysfs_get_ldmap_done;
+
+=A0=A0=A0=A0 /*
+=A0=A0=A0=A0 * Prepare the mailbox packet to get the current logical d=
rive mapping
+=A0=A0=A0=A0 * table
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 mbox->xferaddr =3D (uint32_t)raid_dev->sysfs_buffer_dma;
+
+=A0=A0=A0=A0 raw_mbox[0] =3D FC_DEL_LOGDRV;
+=A0=A0=A0=A0 raw_mbox[2] =3D OP_GET_LDID_MAP;
+
+=A0=A0=A0=A0 /*
+=A0=A0=A0=A0 * Setup a timer to recover from a non-responding controll=
er
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 timerp=A0=A0=A0=A0=A0 =3D &sysfs_timer;
+=A0=A0=A0=A0 init_timer(timerp);
+
+=A0=A0=A0=A0 timerp->function=A0 =3D megaraid_sysfs_get_ldmap_timeout;
+=A0=A0=A0=A0 timerp->data=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D (unsign=
ed long)uioc;
+=A0=A0=A0=A0 timerp->expires=A0=A0=A0=A0=A0=A0=A0=A0 =3D jiffies + 60 =
* HZ;
+
+=A0=A0=A0=A0 add_timer(timerp);
+
+=A0=A0=A0=A0 /*
+=A0=A0=A0=A0 * Send the command to the firmware
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 rval =3D megaraid_mbox_mm_command(adapter, uioc);
+
+=A0=A0=A0=A0 if (rval =3D=3D 0) {=A0 // command successfully issued
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 wait_event(raid_dev->sysfs_wait_q, (uio=
c->status !=3D -ENODATA));
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Check if the command timed out
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (uioc->status =3D=3D -ETIME) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con_log(CL_ANN, (KERN=
_NOTICE
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "me=
garaid: sysfs get ld map timed out\n"));
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rval =3D -ETIME;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rval =3D mbox->status=
;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (rval =3D=3D 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memcpy(raid_dev->curr=
_ldmap, ldmap,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 siz=
eof(raid_dev->curr_ldmap));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con_log(CL_ANN, (KERN=
_NOTICE
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "me=
garaid: get ld map failed with %x\n", rval));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con_log(CL_ANN, (KERN_NOTICE
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "megaraid: could not =
issue ldmap command:%x\n", rval));
+=A0=A0=A0=A0 }
+
+
+=A0=A0=A0=A0 del_timer_sync(timerp);
+
+=A0=A0=A0=A0 up(&raid_dev->sysfs_sem);
+
+=A0=A0=A0=A0 return rval;
+}
+
+
+/**
+ * megaraid_sysfs_show_app_hndl - display application handle for this
adapter
+ *
+ * Display the handle used by the applications while executing managem=
ent
+ * tasks on the adapter. We invoke a management module API to get the
adapter
+ * handle, since we do not interface with applications directly.
+ *
+ * @param cdev=A0=A0 : class device object representation for the host
+ * @param buf=A0=A0=A0 : buffer to send data to
+ */
+static ssize_t
+megaraid_sysfs_show_app_hndl(struct class_device *cdev, char *buf)
+{
+=A0=A0=A0=A0 struct Scsi_Host *shost =3D class_to_shost(cdev);
+=A0=A0=A0=A0 adapter_t=A0=A0 *adapter =3D (adapter_t *)SCSIHOST2ADAP(s=
host);
+=A0=A0=A0=A0 uint32_t=A0=A0=A0 app_hndl;
+
+=A0=A0=A0=A0 app_hndl =3D mraid_mm_adapter_app_handle(adapter->unique_=
id);
+
+=A0=A0=A0=A0 return snprintf(buf, 8, "%u\n", app_hndl);
+}
+
+
+/**
+ * megaraid_sysfs_show_ldnum - display the logical drive number for th=
is
device
+ *
+ * Display the logical drive number for the device in question, if it =
a
valid
+ * logical drive. For physical devices, "-1" is returned
+ * The logical drive number is displayed in following format
+ *
+ * <SCSI ID> <LD NUM> <LD STICKY ID> <APP ADAPTER HANDLE>
+ *=A0=A0 <int>=A0=A0=A0=A0 <int>=A0=A0=A0=A0=A0=A0 <int>=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 <int>
+ *
+ * @param dev=A0=A0=A0 : device object representation for the scsi dev=
ice
+ * @param buf=A0=A0=A0 : buffer to send data to
+ */
+static ssize_t
+megaraid_sysfs_show_ldnum(struct device *dev, char *buf)
+{
+=A0=A0=A0=A0 struct scsi_device *sdev =3D to_scsi_device(dev);
+=A0=A0=A0=A0 adapter_t=A0=A0 *adapter =3D (adapter_t *)SCSIHOST2ADAP(s=
dev->host);
+=A0=A0=A0=A0 mraid_device_t=A0=A0=A0 *raid_dev =3D ADAP2RAIDDEV(adapte=
r);
+=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0 scsi_id =3D -1;
+=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0 logical_drv =3D -1;
+=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0 ldid_map =3D -1;
+=A0=A0=A0=A0 uint32_t=A0=A0=A0 app_hndl =3D 0;
+=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0 mapped_sdev_id;
+=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0 rval;
+=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0 i;
+
+=A0=A0=A0=A0 if (raid_dev->random_del_supported &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 MRAID_IS_LOGICAL_SDEV=
(adapter, sdev)) {
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rval =3D megaraid_sysfs_get_ldmap(adapt=
er);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (rval =3D=3D 0) {
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i < MAX=
_LOGICAL_DRIVES_40LD; i++) {
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 map=
ped_sdev_id =3D sdev->id;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(sdev->id > adapter->init_id) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 mapped_sdev_id -=3D 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(raid_dev->curr_ldmap[i] =3D=3D mapped_sdev_id) {
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 scsi_id =3D sdev->id;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 logical_drv =3D i;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 ldid_map =3D raid_dev->curr_ldmap[i];
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 app_hndl =3D mraid_mm_adapter_app_handle(
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 adapter->unique_id);
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con_log(CL_ANN, (KERN=
_NOTICE
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "me=
garaid: sysfs get ld map failed: %x\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rva=
l));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0 return snprintf(buf, 36, "%d %d %d %d\n", scsi_id, logica=
l_drv,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ldid_map, app_hndl);
+}
+
+
=A0/*
=A0 * END: Mailbox Low Level Driver
=A0 */
diff -Naur linux_bk/drivers/scsi/megaraid/megaraid_mbox.h
linux_bk.new/drivers/scsi/megaraid/megaraid_mbox.h
--- linux_bk/drivers/scsi/megaraid/megaraid_mbox.h=A0=A0=A0 2005-01-25
18:13:37.000000000 -0500
+++ linux_bk.new/drivers/scsi/megaraid/megaraid_mbox.h=A0=A0=A0=A0=A0 2=
005-01-25
18:22:25.343756800 -0500
@@ -21,8 +21,8 @@
=A0#include "megaraid_ioctl.h"
=A0
=A0
-#define MEGARAID_VERSION=A0=A0=A0=A0 "2.20.4.1"
-#define MEGARAID_EXT_VERSION "(Release Date: Thu Nov=A0 4 17:44:59 EST=
 2004)"
+#define MEGARAID_VERSION=A0=A0=A0=A0 "2.20.4.3"
+#define MEGARAID_EXT_VERSION "(Release Date: Fri Jan 21 00:01:03 EST 2=
005)"
=A0
=A0
=A0/*
@@ -137,6 +137,9 @@
=A0#define PCI_SUBSYS_ID_PERC3_DC=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x0493
=A0#define PCI_SUBSYS_ID_PERC3_SC=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x0475
=A0
+#define PCI_DEVICE_ID_MEGARAID_NEC_ROMB_2E=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 0x0408
+#define PCI_SUBSYS_ID_MEGARAID_NEC_ROMB_2E=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 0x8287
+
=A0#ifndef PCI_SUBSYS_ID_FSC
=A0#define PCI_SUBSYS_ID_FSC=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0x1734
=A0#endif
@@ -216,6 +219,14 @@
=A0 * @param hw_error=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 : set if FW not res=
ponding
=A0 * @param fast_load=A0=A0=A0=A0=A0=A0=A0=A0=A0 : If set, skip physic=
al device scanning
=A0 * @channel_class=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 : channel class, =
RAID or SCSI
+ * @sysfs_sem=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 : semaphore=
 to serialize access to sysfs res.
+ * @sysfs_uioc=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 : management =
packet to issue FW calls from
sysfs
+ * @sysfs_mbox64=A0=A0=A0=A0=A0=A0 : mailbox packet to issue FW calls =
from sysfs
+ * @sysfs_buffer=A0=A0=A0=A0=A0=A0 : data buffer for FW commands issue=
d from sysfs
+ * @sysfs_buffer_dma=A0=A0=A0=A0=A0=A0=A0=A0 : DMA buffer for FW comma=
nds issued from sysfs
+ * @sysfs_wait_q=A0=A0=A0=A0=A0=A0 : wait queue for sysfs operations
+ * @random_del_supported=A0=A0=A0=A0 : set if the random deletion is s=
upported
+ * @curr_ldmap=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 : current LDI=
D map
=A0 *
=A0 * Initialization structure for mailbox controllers: memory based an=
d IO
based
=A0 * All the fields in this structure are LLD specific and may be disc=
overed
at
@@ -223,6 +234,7 @@
=A0 *
=A0 * NOTE: The fields of this structures are placed to minimize cache =
misses
=A0 */
+#define MAX_LD_EXTENDED64=A0=A0=A0 64
=A0typedef struct {
=A0=A0=A0=A0=A0 mbox64_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=
una_mbox64;
=A0=A0=A0=A0=A0 dma_addr_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 una_m=
box64_dma;
@@ -247,6 +259,14 @@
=A0=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 hw_error;
=A0=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 fast_load;
=A0=A0=A0=A0=A0 uint8_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 channel_class;
+=A0=A0=A0=A0 struct semaphore=A0=A0=A0=A0=A0=A0=A0 sysfs_sem;
+=A0=A0=A0=A0 uioc_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 *sysfs_uioc;
+=A0=A0=A0=A0 mbox64_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *sy=
sfs_mbox64;
+=A0=A0=A0=A0 caddr_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 sysfs_buffer;
+=A0=A0=A0=A0 dma_addr_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sysfs_b=
uffer_dma;
+=A0=A0=A0=A0 wait_queue_head_t=A0=A0=A0=A0=A0=A0 sysfs_wait_q;
+=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 random_del_supported;
+=A0=A0=A0=A0 uint16_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cur=
r_ldmap[MAX_LD_EXTENDED64];
=A0} mraid_device_t;
=A0
=A0// route to raid device from adapter
diff -Naur linux_bk/drivers/scsi/megaraid/megaraid_mm.c
linux_bk.new/drivers/scsi/megaraid/megaraid_mm.c
--- linux_bk/drivers/scsi/megaraid/megaraid_mm.c=A0=A0=A0=A0=A0 2005-01=
-25
18:13:37.000000000 -0500
+++ linux_bk.new/drivers/scsi/megaraid/megaraid_mm.c=A0 2005-01-25
18:22:26.421592944 -0500
@@ -10,7 +10,7 @@
=A0 *=A0=A0 =A0=A0 2 of the License, or (at your option) any later vers=
ion.
=A0 *
=A0 * FILE=A0=A0=A0=A0=A0=A0=A0=A0=A0 : megaraid_mm.c
- * Version : v2.20.2.3 (Dec 09 2004)
+ * Version : v2.20.2.5 (Jan 21 2005)
=A0 *
=A0 * Common management module
=A0 */
@@ -58,6 +58,7 @@
=A0
=A0EXPORT_SYMBOL(mraid_mm_register_adp);
=A0EXPORT_SYMBOL(mraid_mm_unregister_adp);
+EXPORT_SYMBOL(mraid_mm_adapter_app_handle);
=A0
=A0static int majorno;
=A0static uint32_t drvr_ver=A0=A0=A0=A0 =3D 0x02200201;
@@ -65,7 +66,7 @@
=A0static int adapters_count_g;
=A0static struct list_head adapters_list_g;
=A0
-wait_queue_head_t wait_q;
+static wait_queue_head_t wait_q;
=A0
=A0static struct file_operations lsi_fops =3D {
=A0=A0=A0=A0=A0 .open =3D mraid_mm_open,
@@ -1007,6 +1008,40 @@
=A0=A0=A0=A0=A0 return rval;
=A0}
=A0
+
+/**
+ * mraid_mm_adapter_app_handle - return the application handle for thi=
s
adapter
+ *
+ * For the given driver data, locate the adadpter in our global list a=
nd
+ * return the corresponding handle, which is also used by applications=
 to
+ * uniquely identify an adapter.
+ *
+ * @param unique_id : adapter unique identifier
+ *
+ * @return adapter handle if found in the list
+ * @return 0 if adapter could not be located, should never happen thou=
gh
+ */
+uint32_t
+mraid_mm_adapter_app_handle(uint32_t unique_id)
+{
+=A0=A0=A0=A0 mraid_mmadp_t=A0=A0=A0=A0 *adapter;
+=A0=A0=A0=A0 mraid_mmadp_t=A0=A0=A0=A0 *tmp;
+=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0 index =3D 0;
+
+=A0=A0=A0=A0 list_for_each_entry_safe(adapter, tmp, &adapters_list_g, =
list) {
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (adapter->unique_id =3D=3D unique_id=
) {
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return MKADAP(index);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 index++;
+=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0 return 0;
+}
+
+
=A0/**
=A0 * mraid_mm_setup_dma_pools - Set up dma buffer pools per adapter
=A0 *
diff -Naur linux_bk/drivers/scsi/megaraid/megaraid_mm.h
linux_bk.new/drivers/scsi/megaraid/megaraid_mm.h
--- linux_bk/drivers/scsi/megaraid/megaraid_mm.h=A0=A0=A0=A0=A0 2005-01=
-25
18:13:37.000000000 -0500
+++ linux_bk.new/drivers/scsi/megaraid/megaraid_mm.h=A0 2005-01-25
18:22:27.692399752 -0500
@@ -29,9 +29,9 @@
=A0#include "megaraid_ioctl.h"
=A0
=A0
-#define LSI_COMMON_MOD_VERSION=A0=A0=A0=A0 "2.20.2.3"
+#define LSI_COMMON_MOD_VERSION=A0=A0=A0=A0 "2.20.2.5"
=A0#define LSI_COMMON_MOD_EXT_VERSION \
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "(Release Date: Thu Dec=A0 9 19:02:14 E=
ST 2004)"
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "(Release Date: Fri Jan 21 00:01:03 EST=
 2005)"
=A0
=A0#define LSI_DBGLVL=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
bglevel


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
