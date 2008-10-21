From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/ConfigFS]: Added initial support for file
	descriptors for se_device_t
Date: Tue, 21 Oct 2008 13:20:47 -0700
Message-ID: <1224620447.24358.27.camel__28768.928818363$1224620792$gmane$org@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:39255 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752270AbYJUUYt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 16:24:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vg>
Cc: Joel Becker <joel.becker@oracle.com>, Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, Ming Zhang <blackmagic02881@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "H. Peter Anvin" <hpa@zytor.com>, Mike Christie <mchristie@redhat.com>

Hi again Folks,

Here is the first commit using Joel's recommendations allow
target_core_mod configfs generic infrastructure to allow subsystem
plugins from target_core_mod to handle FDs passed using TYPE_DISK for
Linux/SCSI and Linux/BLOCK and TYPE_CDROM with Linux/SCSI.

Below, se_subsystem_dev_t->create_virtdevice_from_fd() method into Linux
storage subsystem APIs is added to;

/sys/kernel/config/target/core/$PLUGIN_HBA/$STORAGE_OBJECT/fd

This commit depends upon the changes to target_core_mod/IBLOCK and
target_core_mod/PSCSI:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=9c6293c1bfe82d04a215fab22a3a850ea879a137
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=bd4227278bbb6ec911a15b380f2479782cbe94ce

There are a few FIXMEs below..  Also, using target_core_mod/PSCSI with
*NON* struct block_device backed struct scsi_devices (eg: character
devices like TYPE_TAPE, TYPE_MEDIUM_CHANGER, etc) is currently not
implemented in the target_core_mod/PSCSI commit above.  If anyone can
tell me how to get struct scsi_device from /dev/st0 it would be much
appericated..

Also, the sr0 device appears to need the medium in the drive before it
can great a READ FD from /dev/sr0 initially (I have recalled seeing
something like this in the past, eg: where struct scsi_device is not
attached until the first struct scsi_cmnd come down through Linux/SCSI's
->queuecommand()..  It (Linux/SCSI with TYPE_CDROM) has worked like this
as long as I have known, is it possible to get access to TYPE_CDROM's FD
through /dev/sr0 to struct scsi_device before the medium is in the
drive..?   Should I just restrict the FD method to TYPE_DISK for
Linux/BLOCK and Linux/SCSI..?

Comments..?

--nab


>From 362d4ef391699b0282dfbef3da633a561d9cbde7 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 20 Oct 2008 23:21:43 -0700
Subject: [PATCH] [Target_Core_Mod/ConfigFS]: Added initial support for file descriptors for se_device_t

Added support for passing in file descriptors for referencing Linux storage objects
in the generic target core.  This patch adds the method to the subsystem API
 se_subsystem_api_t->create_virtdevice_from_fd()  and the configfs entries
$TARGET/$HBA_$ID/$STORAGE_OBJECT/fd.

Currently Linux/SCSI and Linux/BLOCK are supported, here are some examples:

mkdir -p $TARGET/iblock_0/lvm_test0
exec 3<>/dev/lio-test/test0 # RW
echo 3 > $TARGET/iblock_0/lvm_test0/fd
exec 3>&-

<SNIP>

Target_Core_ConfigFS: Located se_plugin: ced17090 plugin_name: iblock hba_type: 4 plugin_dep_id: 0
CORE_HBA[0] - Linux-iSCSI.org iBlock HBA Driver v3.0 on Generic Target Core Stack v3.0.0
CORE_HBA[0] - Attached iBlock HBA: 0 to Generic Target Core TCQ Depth: 512
CORE_HBA[0] - Attached HBA to Generic Target Core
IBLOCK: Allocated ib_dev for lvm_test0
Target_Core_ConfigFS: Allocated se_subsystem_dev_t: cefe6400 se_dev_su_ptr: cf9fd200
IBLOCK: Claiming struct block_device: cf63cf00
IBLOCK: Created bio_set() for major/minor: 254:2
CORE_iBLOCK[0] - Activating Device with TCQ: 0 at Major: 254 Minor 2
  Vendor: LIO-ORG   Model: IBLOCK            Revision: v3.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
T10 EVPD Unit Serial Number: 1234567890:0_254_2
T10 EVPD Device Identifier: LIO-ORG IBLOCK:1234567890:0_254_2
Target_Core_ConfigFS: Registered iblock se_dev->se_dev_ptr: cf350000 from fd

<SNIP>

mkdir -p $TARGET/pscsi_0/sdd
exec 3<>/dev/sdd # RW
echo 3 > $TARGET/pscsi_0/sdd/fd
exec 3>&-

<SNIP>

Target_Core_ConfigFS: Located se_plugin: ced17024 plugin_name: pscsi hba_type: 1 plugin_dep_id: 0
CORE_HBA[1] - Linux-iSCSI.org Parallel SCSI HBA Driver v3.0 on Generic Target Core Stack v3.0.0
CORE_HBA[1] - MPT SPI Host
CORE_HBA[1] - Attached Parallel SCSI HBA to Generic Target Core with TCQ Depth: 127 MaxSectors: 8192
CORE_HBA[1] - Attached HBA to Generic Target Core
PSCSI: Allocated pdv: cfb42800 for sdd
Target_Core_ConfigFS: Allocated se_subsystem_dev_t: cf86fe80 se_dev_su_ptr: cfb42800
PSCSI: Claiming cf87f800 Major:Minor - 8:48
CORE_PSCSI[0] - Activating Device with TCQ: 32 at Parallel SCSI Location (Channel/Target/LUN) 0/3/0
  Vendor: VMware,   Model: VMware Virtual S  Revision: 1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
Parallel SCSI Status Byte exception - ITT: 0x00000000 Task: cee6d600 CDB: 0x12 Result: 0x08000002
CORE_PSCSI[0] - Added TYPE_DISK for 0:3:0
Target_Core_ConfigFS: Registered pscsi se_dev->se_dev_ptr: ced6ec00 from fd

<SNIP>

exec 3</dev/sr0 # RO
echo 3 > $TARGET/pscsi_1/sr0/fd
exec 3>&-

<SNIP>

Target_Core_ConfigFS: Located se_plugin: ced17024 plugin_name: pscsi hba_type: 1 plugin_dep_id: 1
CORE_HBA[2] - Linux-iSCSI.org Parallel SCSI HBA Driver v3.0 on Generic Target Core Stack v3.0.0
CORE_HBA[2] - MPT SPI Host
CORE_HBA[2] - Attached Parallel SCSI HBA to Generic Target Core with TCQ Depth: 127 MaxSectors: 8192
CORE_HBA[2] - Attached HBA to Generic Target Core
PSCSI: Allocated pdv: cfb42640 for sr0
Target_Core_ConfigFS: Allocated se_subsystem_dev_t: ced70f00 se_dev_su_ptr: cfb42640
CORE_PSCSI[1] - Activating Device with TCQ: 32 at Parallel SCSI Location (Channel/Target/LUN) 0/0/0
  Vendor: VMware,   Model: Virtual CD-ROM    Revision: 1.0
  Type:   CD-ROM                             ANSI SCSI revision: 02
Parallel SCSI Status Byte exception - ITT: 0x00000000 Task: cfa79200 CDB: 0x12 Result: 0x08000002
CORE_PSCSI[1] - Added Type: CD-ROM            for 0:0:0
Target_Core_ConfigFS: Registered pscsi se_dev->se_dev_ptr: ceed1800 from fd

<SNIP>

There a few FIXMEs:

*) Determine long term status of struct gendisk->driverfs_dev for
   locating struct scsi_device from struct inode for Linux/SCSI.
*) Add support for struct scsi_device's backed by character device.
*) SCSI CDROM can only be attached through the fd method when medium
   is in the drive.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c  |   54 +++++++++++++++++++++++++++++-
 drivers/lio-core/target_core_transport.h |    4 ++
 2 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 268ab38..264dcdb 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -574,9 +574,57 @@ static struct target_core_configfs_attribute target_core_attr_dev_control = {
 	.store	= target_core_store_dev_control,
 };
 
+static ssize_t target_core_store_dev_fd (void *p, const char *page, size_t count)
+{
+	se_subsystem_dev_t *se_dev = (se_subsystem_dev_t *)p;	
+	se_device_t *dev;
+	se_hba_t *hba = se_dev->se_dev_hba;
+	se_subsystem_api_t *t;
+	int ret = 0;
+
+	if (se_dev->se_dev_ptr) {
+		printk(KERN_ERR "se_dev->se_dev_ptr already set, ignoring fd request\n");
+		return(-EEXIST);
+	}
+
+	t = (se_subsystem_api_t *)plugin_get_obj(PLUGIN_TYPE_TRANSPORT, hba->type, &ret);		
+	if (!t || (ret != 0))
+		return(-EINVAL);
+
+	if (!(t->create_virtdevice_from_fd)) {
+		printk(KERN_ERR "se_subsystem_api_t->create_virtdevice_from_fd()"
+			" NULL for: %s\n", hba->transport->name);
+		return(-EINVAL);
+	}
+	/*
+	 * The subsystem PLUGIN is responsible for calling target_core_mod
+	 * symbols to claim the underlying struct block_device for TYPE_DISK.
+	 */
+	dev = t->create_virtdevice_from_fd(se_dev, page);
+	if (!(dev) || IS_ERR(dev))
+		goto out;
+
+	se_dev->se_dev_ptr = dev;
+
+	printk("Target_Core_ConfigFS: Registered %s se_dev->se_dev_ptr: %p"
+		" from fd\n", hba->transport->name, se_dev->se_dev_ptr);
+	return(count);
+out:
+	return(-EINVAL);
+}
+
+static struct target_core_configfs_attribute target_core_attr_dev_fd = {
+	.attr	= { .ca_owner = THIS_MODULE,
+		    .ca_name = "fd",
+		    .ca_mode = S_IWUSR },
+	.show	= NULL,
+	.store	= target_core_store_dev_fd,
+};
+
 static ssize_t target_core_store_dev_enable (void *p, const char *page, size_t count)
 {
 	se_subsystem_dev_t *se_dev = (se_subsystem_dev_t *)p;
+	se_device_t *dev;
 	se_hba_t *hba = se_dev->se_dev_hba;
 	se_subsystem_api_t *t;
 	char *ptr;
@@ -598,10 +646,13 @@ static ssize_t target_core_store_dev_enable (void *p, const char *page, size_t c
 	if (t->check_configfs_dev_params(hba, se_dev) < 0)
 		return(-EINVAL);
 
-	if (!(se_dev->se_dev_ptr = t->create_virtdevice(hba, se_dev->se_dev_su_ptr)))
+	dev = t->create_virtdevice(hba, se_dev->se_dev_su_ptr);
+	if (!(dev) || IS_ERR(dev))
 		return(-EINVAL);
 
+	se_dev->se_dev_ptr = dev;
 	printk("Target_Core_ConfigFS: Registered se_dev->se_dev_ptr: %p\n", se_dev->se_dev_ptr);
+
 	return(count);
 }
 
@@ -616,6 +667,7 @@ static struct target_core_configfs_attribute target_core_attr_dev_enable = {
 static struct configfs_attribute *lio_core_dev_attrs[] = {
 	&target_core_attr_dev_info.attr,
 	&target_core_attr_dev_control.attr,
+	&target_core_attr_dev_fd.attr,
 	&target_core_attr_dev_enable.attr,
 	NULL,
 };
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index 7f96176..078750b 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -427,6 +427,10 @@ typedef struct se_subsystem_api_s {
 	 */	
 	ssize_t (*show_configfs_dev_params)(se_hba_t *, se_subsystem_dev_t *, char *);
 	/*
+	 * create_virtdevice_from-fd():
+	 */
+	se_device_t *(*create_virtdevice_from_fd)(se_subsystem_dev_t *, const char *);
+	/*
 	 * check_dev_params():
 	 */
 	int (*check_dev_params)(se_hba_t *, struct iscsi_target *, se_dev_transport_info_t *);
-- 
1.5.4.1



