From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5/7] [SCSI] ibmvstgt: Port from tgt to SCST
Date: Mon, 20 Dec 2010 18:49:45 +0100
Message-ID: <201012201849.45490.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:51148 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab0LTSUG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2010 13:20:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, James.Bottomley@suse.de, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>

The ibmvstgt and libsrp kernel modules as included in the 2.6.37 kernel
are based on the tgt SCSI target framework. Both kernel modules need the
scsi_tgt kernel module and the tgtd user space process in order to
function properly. This patch modifies the ibmvstgt and libsrp kernel
modules such that both use the SCST storage target framework instead of
tgt. As a result, neither the scsi_tgt kernel module nor the tgtd user
space process are any more necessary when using the ibmvstgt driver.

This patch introduces one backwards-incompatible change, namely that the
path of the ibmvstgt sysfs attributes is modified. This change is
unavoidable because this patch dissociates ibmvstgt SRP sessions from a
SCSI host instance.  Since the user space STGT driver ibmvio was the only
user of these attributes this isn't an issue.

Changes in ibmvstgt:
- Increased maximum data size for a single SRP command from 128 KB to 64
  MB such that an initiator is not forced to split large transfers into
  multiple SCSI commands.
- The maximum RDMA transfer size supported by a single H_COPY_RDMA call is
  queried at driver initialization time from the open firmware tree /
  larger transfers than 128 KB are now supported too.
- If DMA mapping fails while handling a READ or WRITE command, the
  offending command is retried until the associated data has been
  transferred instead of reporting to the ibmvscsi client that the SCSI
  command failed.
- VSCSI command/response queue: one element has been reserved for
  management datagrams since these fall outside the SRP credit
  mechanism. Added a compile- time check whether the size of this queue is
  a power of two.
- Fixed a race condition which in theory could have caused the VSCSI
  receive queue to overflow: srp_iu_put() is now invoked before a response
  is sent back to the initiator instead of after.
- Moved enum iue_flags from libsrp to ibmvstgt because it is
  ibmvstgt-specific.
- Removed a variable that was modified but never read from
  ibmvstgt_rdma().
- ibmvstgt_probe(): changed the datatype of the variable "dma" from
  unsigned * into const unsigned * such that a cast could be removed.
- Fixed all compiler and sparse warnings (C=2 CF=-D__CHECK_ENDIAN__).

Changes in libsrp compared to kernel 2.6.36:
- Renamed vscsis_data_length() into srp_data_length() and exported
  this function.
- All error messages reported via printk() do now have prefix KERN_ERR.
- Modified srp_target_alloc() and srp_target_free() such that the
  driver-private data reflects whether or not target data has been
  allocated.  This change was necessary to avoid that ibmvstgt_remove()
  triggers a NULL-pointer dereference if ibmvstgt_probe() failed.
- srp_transfer_data(): All three return statements related to DMA mapping
  failure do now return -ENOMEM instead of 0, -EIO and -ENOMEM.
- srp_direct_data(): Removed the ext_desc argument since not used.
- srp_direct_data() and srp_indirect_data(): Use DMA_TO/FROM_DEVICE
  instead of DMA_BIDIRECTIONAL for the buffers mapped for transferring
  data via DMA.
- struct srp_target: eliminated the information unit linked list and also
  the V_FLYING flag since both were duplicating information managed by the
  SCST core.
- Fixed all compiler and sparse warnings (C=2 CF=-D__CHECK_ENDIAN__).

Tests performed on a backport to kernel version 2.6.18 of this driver with a
Linux initiator system:
- Verified that the kernel module ibmvstgt loads and initializes successfully
  and also that the client connects after loading.
- Verified that all virtual disks configured in scst_vdisk were discovered by
  the client after rescanning the SCSI bus.
- Verified that after unloading and reloading ibmvstgt and after client
  recovery that the initiator devices were functioning normally.
- Verified that after a client reboot ibmvscsic reconnected with the target
  and that the target devices were again usable.
- Performed IO stress testing on the device.
- Verified that SCSI task abortion works correctly.
- Performed basic I/O performance testing. With a RAM disk as target linear
  direct I/O throughput was above 2 GB/s and a random I/O test resulted in
  about 30000 IOPS for all block sizes between 512 bytes and 16 KB.
  Both initiator and target were dual core POWER6 LPAR systems.

Note: ibmvstgt is the only user of libsrp.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 Documentation/powerpc/ibmvstgt.txt |   89 ++++
 drivers/scsi/ibmvscsi/ibmvstgt.c   |  914 +++++++++++++++++++++++++-----------
 drivers/scsi/libsrp.c              |  174 ++++----
 include/scsi/libsrp.h              |   27 +-
 include/scsi/srp.h                 |    7 +
 5 files changed, 843 insertions(+), 368 deletions(-)
 create mode 100644 Documentation/powerpc/ibmvstgt.txt

diff --git a/Documentation/powerpc/ibmvstgt.txt b/Documentation/powerpc/ibmvstgt.txt
new file mode 100644
index 0000000..1ffc5ad
--- /dev/null
+++ b/Documentation/powerpc/ibmvstgt.txt
@@ -0,0 +1,89 @@
+IBM Virtual SCSI Target (ibmvstgt)
+==================================
+
+
+Introduction
+------------
+The virtual SCSI (VSCSI) protocol as defined in [2] is a protocol that allows
+one logical partition (LPAR) to access SCSI targets provided by another LPAR.
+The LPAR that provides one or more SCSI targets is called the VIO server or
+VIOS. The ibmvstgt driver is a VIOS driver that makes it possible to access
+exported target devices via the VSCSI protocol.
+
+Setup
+-----
+After having configured the LPARs, boot the LPARs and load the ibmvstgt kernel
+module in the VIOS. After the target driver has been loaded, verify that a
+message similar to the following appears in the initiator kernel log:
+
+ibmvscsi 30000028: partner initialized
+ibmvscsi 30000028: host srp version: 16.a, host partition VIOS3-P6 (40), OS 2, max io 67108864
+ibmvscsi 30000028: sent SRP login
+ibmvscsi 30000028: SRP_LOGIN succeeded
+
+In the above log messages, the number 30000028 refers to the VIOS. The last
+two digits, 0x28, refer to the VIOS partition number (0x28 = 40).
+
+The next step is to decide which SCSI devices to export. Here is an example of
+a configuration in which 16 RAM disks have been exported (see also [1] for
+more information):
+
+# ls /sys/kernel/scst_tgt/devices
+2:0:0:0 ram000  ram001  ram002  ram003  ram004  ram005  ram006  ram007
+ram008  ram009  ram010  ram011  ram012  ram013  ram014  ram015
+
+After this step a LUN has to be assigned to each exported SCSI device. Some
+non-Linux initiator operating systems only accept LUN numbes that are
+multiples of 256 and require that the LUN addressing method is used.
+Assigning LUN numbers is possible e.g. as follows:
+
+  lun=0
+  for name in ram000 ram001 ram002 ram003 ram004 ram005 ram006 ram007 \
+              ram008 ram009 ram010 ram011 ram012 ram013 ram014 ram015
+  do
+    lun=$((lun+256))
+    echo "add $name $lun" \
+      >/sys/kernel/scst_tgt/targets/ibmvstgt/ibmvstgt_target_0/luns/mgmt
+  done
+  echo 1 >/sys/kernel/scst_tgt/targets/ibmvstgt/ibmvstgt_target_0/enabled
+
+The result of the above commands will be as follows:
+
+# cat /sys/kernel/scst_tgt/targets/ibmvstgt/ibmvstgt_target_0/addr_method
+LUN
+# ls /sys/kernel/scst_tgt/targets/ibmvstgt/ibmvstgt_target_0/luns
+256  512  768  1024 1280 1536 1792 2048 2304 2560 2816 3072 3328 3584 3840 4096
+mgmt
+# cat /sys/kernel/scst_tgt/targets/ibmvstgt/ibmvstgt_target_0/enabled
+1
+
+After SCST has been configured, make the new configuration available to the
+initiator by rescanning the SCSI bus, e.g. as follows:
+
+# rescan-scsi-bus --hosts=2 --ids=0-31
+# lsscsi 2:
+[2:0:1:0]    disk    IBM      VDASD blkdev     0001  /dev/sdb
+[2:0:2:0]    disk    IBM      VDASD blkdev     0001  /dev/sdc
+[2:0:3:0]    disk    IBM      VDASD blkdev     0001  /dev/sdd
+[2:0:4:0]    disk    IBM      VDASD blkdev     0001  /dev/sde
+[2:0:5:0]    disk    IBM      VDASD blkdev     0001  /dev/sdf
+[2:0:6:0]    disk    IBM      VDASD blkdev     0001  /dev/sdg
+[2:0:7:0]    disk    IBM      VDASD blkdev     0001  /dev/sdh
+[2:0:8:0]    disk    IBM      VDASD blkdev     0001  /dev/sdi
+[2:0:9:0]    disk    IBM      VDASD blkdev     0001  /dev/sdj
+[2:0:10:0]   disk    IBM      VDASD blkdev     0001  /dev/sdk
+[2:0:11:0]   disk    IBM      VDASD blkdev     0001  /dev/sdl
+[2:0:12:0]   disk    IBM      VDASD blkdev     0001  /dev/sdm
+[2:0:13:0]   disk    IBM      VDASD blkdev     0001  /dev/sdn
+[2:0:14:0]   disk    IBM      VDASD blkdev     0001  /dev/sdo
+[2:0:15:0]   disk    IBM      VDASD blkdev     0001  /dev/sdp
+[2:0:16:0]   disk    IBM      VDASD blkdev     0001  /dev/sdq
+
+
+References
+----------
+[1] SCST Configuration Interface, Documentation/scst/README.scst.
+[2] Power.org Standard for Power Architecture Platform Requirements (PAPR)
+(Workstation, Server), Version 2.4, December 7, 2009, http://www.power.org.
+[3] Virtual I/O (VIO) and Virtualization, IBM Developerworks, 2010,
+http://www.ibm.com/developerworks/wikis/display/virtualization/VIO.
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 2256bab..9904c8c 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -5,6 +5,7 @@
  *			   Linda Xie (lxie@us.ibm.com) IBM Corp.
  *
  * Copyright (C) 2005-2006 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2010 Bart Van Assche <bvanassche@acm.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -24,28 +25,28 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_transport_srp.h>
-#include <scsi/scsi_tgt.h>
+#include <scst/scst.h>
+#include <scst/scst_debug.h>
 #include <scsi/libsrp.h>
 #include <asm/hvcall.h>
 #include <asm/iommu.h>
 #include <asm/prom.h>
 #include <asm/vio.h>
+#include <linux/of.h>
 
 #include "ibmvscsi.h"
 
-#define	INITIAL_SRP_LIMIT	16
-#define	DEFAULT_MAX_SECTORS	256
+#define	VSCSI_REQ_LIM		16
+#define	MAD_REQ_LIM		1
+#define	SRP_REQ_LIM		(VSCSI_REQ_LIM - MAD_REQ_LIM)
+/* Minimal trfr size that must be supported by a PAPR-compliant hypervisor. */
+#define	MAX_H_COPY_RDMA		(128*1024)
 
 #define	TGT_NAME	"ibmvstgt"
 
 /*
  * Hypervisor calls.
  */
-#define h_copy_rdma(l, sa, sb, da, db) \
-			plpar_hcall_norets(H_COPY_RDMA, l, sa, sb, da, db)
 #define h_send_crq(ua, l, h) \
 			plpar_hcall_norets(H_SEND_CRQ, ua, l, h)
 #define h_reg_crq(ua, tok, sz)\
@@ -56,26 +57,47 @@
 /* tmp - will replace with SCSI logging stuff */
 #define eprintk(fmt, args...)					\
 do {								\
-	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
+	printk(KERN_ERR "%s(%d) " fmt, __func__, __LINE__, ##args); \
 } while (0)
 /* #define dprintk eprintk */
 #define dprintk(fmt, args...)
 
+/* iu_entry.flags */
+enum iue_flags {
+	V_DIOVER,
+	V_WRITE,
+	V_LINKED,
+};
+
 struct vio_port {
 	struct vio_dev *dma_dev;
 
 	struct crq_queue crq_queue;
 	struct work_struct crq_work;
 
+	atomic_t req_lim_delta;
 	unsigned long liobn;
 	unsigned long riobn;
 	struct srp_target *target;
 
-	struct srp_rport *rport;
+	struct scst_session *sess;
+	struct device dev;
+	bool releasing;
+	bool enabled;
 };
 
+static atomic_t ibmvstgt_device_count;
 static struct workqueue_struct *vtgtd;
-static struct scsi_transport_template *ibmvstgt_transport_template;
+static unsigned max_vdma_size = MAX_H_COPY_RDMA;
+static struct scst_tgt_template ibmvstgt_template;
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+#define DEFAULT_IBMVSTGT_TRACE_FLAGS \
+	(TRACE_OUT_OF_MEM | TRACE_MINOR | TRACE_MGMT | TRACE_SPECIAL)
+static unsigned long trace_flag = DEFAULT_IBMVSTGT_TRACE_FLAGS;
+module_param(trace_flag, long, 0644);
+MODULE_PARM_DESC(trace_flag, "SCST trace flags.");
+#endif
 
 /*
  * These are fixed for the system and come from the Open Firmware device tree.
@@ -85,6 +107,29 @@ static char system_id[64] = "";
 static char partition_name[97] = "UNKNOWN";
 static unsigned int partition_number = -1;
 
+static long h_copy_rdma(u64 length, unsigned long siobn, dma_addr_t saddr,
+			unsigned long diobn, dma_addr_t daddr)
+{
+	u64 bytes_copied = 0;
+	long rc;
+
+	while (bytes_copied < length) {
+		u64 bytes_to_copy;
+
+		bytes_to_copy = min_t(u64, length - bytes_copied,
+				      max_vdma_size);
+		rc = plpar_hcall_norets(H_COPY_RDMA, bytes_to_copy, siobn,
+					saddr, diobn, daddr);
+		if (rc != H_SUCCESS)
+			return rc;
+
+		bytes_copied += bytes_to_copy;
+		saddr += bytes_to_copy;
+		daddr += bytes_to_copy;
+	}
+	return H_SUCCESS;
+}
+
 static struct vio_port *target_to_port(struct srp_target *target)
 {
 	return (struct vio_port *) target->ldata;
@@ -124,6 +169,8 @@ static int send_iu(struct iu_entry *iue, uint64_t length, uint8_t format)
 	else
 		crq.cooked.status = 0x00;
 
+	srp_iu_put(iue);
+
 	rc1 = h_send_crq(vport->dma_dev->unit_address, crq.raw[0], crq.raw[1]);
 
 	if (rc1) {
@@ -136,9 +183,11 @@ static int send_iu(struct iu_entry *iue, uint64_t length, uint8_t format)
 
 #define SRP_RSP_SENSE_DATA_LEN	18
 
-static int send_rsp(struct iu_entry *iue, struct scsi_cmnd *sc,
+static int send_rsp(struct iu_entry *iue, struct scst_cmd *sc,
 		    unsigned char status, unsigned char asc)
 {
+	struct srp_target *target = iue->target;
+	struct vio_port *vport = target_to_port(target);
 	union viosrp_iu *iu = vio_iu(iue);
 	uint64_t tag = iu->srp.rsp.tag;
 
@@ -148,7 +197,8 @@ static int send_rsp(struct iu_entry *iue, struct scsi_cmnd *sc,
 
 	memset(iu, 0, sizeof(struct srp_rsp));
 	iu->srp.rsp.opcode = SRP_RSP;
-	iu->srp.rsp.req_lim_delta = 1;
+	iu->srp.rsp.req_lim_delta = __constant_cpu_to_be32(1
+				    + atomic_xchg(&vport->req_lim_delta, 0));
 	iu->srp.rsp.tag = tag;
 
 	if (test_bit(V_DIOVER, &iue->flags))
@@ -165,13 +215,24 @@ static int send_rsp(struct iu_entry *iue, struct scsi_cmnd *sc,
 		uint8_t *sense = iu->srp.rsp.data;
 
 		if (sc) {
-			iu->srp.rsp.flags |= SRP_RSP_FLAG_SNSVALID;
-			iu->srp.rsp.sense_data_len = SCSI_SENSE_BUFFERSIZE;
-			memcpy(sense, sc->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+			uint8_t *sc_sense;
+			int sense_data_len;
+
+			sc_sense = scst_cmd_get_sense_buffer(sc);
+			if (SCST_SENSE_VALID(sc_sense)) {
+				sense_data_len
+					= min(scst_cmd_get_sense_buffer_len(sc),
+					      SRP_RSP_SENSE_DATA_LEN);
+				iu->srp.rsp.flags |= SRP_RSP_FLAG_SNSVALID;
+				iu->srp.rsp.sense_data_len
+					= cpu_to_be32(sense_data_len);
+				memcpy(sense, sc_sense, sense_data_len);
+			}
 		} else {
 			iu->srp.rsp.status = SAM_STAT_CHECK_CONDITION;
 			iu->srp.rsp.flags |= SRP_RSP_FLAG_SNSVALID;
-			iu->srp.rsp.sense_data_len = SRP_RSP_SENSE_DATA_LEN;
+			iu->srp.rsp.sense_data_len
+			      = __constant_cpu_to_be32(SRP_RSP_SENSE_DATA_LEN);
 
 			/* Valid bit and 'current errors' */
 			sense[0] = (0x1 << 7 | 0x70);
@@ -190,45 +251,15 @@ static int send_rsp(struct iu_entry *iue, struct scsi_cmnd *sc,
 	return 0;
 }
 
-static void handle_cmd_queue(struct srp_target *target)
-{
-	struct Scsi_Host *shost = target->shost;
-	struct srp_rport *rport = target_to_port(target)->rport;
-	struct iu_entry *iue;
-	struct srp_cmd *cmd;
-	unsigned long flags;
-	int err;
-
-retry:
-	spin_lock_irqsave(&target->lock, flags);
-
-	list_for_each_entry(iue, &target->cmd_queue, ilist) {
-		if (!test_and_set_bit(V_FLYING, &iue->flags)) {
-			spin_unlock_irqrestore(&target->lock, flags);
-			cmd = iue->sbuf->buf;
-			err = srp_cmd_queue(shost, cmd, iue,
-					    (unsigned long)rport, 0);
-			if (err) {
-				eprintk("cannot queue cmd %p %d\n", cmd, err);
-				srp_iu_put(iue);
-			}
-			goto retry;
-		}
-	}
-
-	spin_unlock_irqrestore(&target->lock, flags);
-}
-
-static int ibmvstgt_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
+static int ibmvstgt_rdma(struct scst_cmd *sc, struct scatterlist *sg, int nsg,
 			 struct srp_direct_buf *md, int nmd,
 			 enum dma_data_direction dir, unsigned int rest)
 {
-	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
+	struct iu_entry *iue = scst_cmd_get_tgt_priv(sc);
 	struct srp_target *target = iue->target;
 	struct vio_port *vport = target_to_port(target);
 	dma_addr_t token;
 	long err;
-	unsigned int done = 0;
 	int i, sidx, soff;
 
 	sidx = soff = 0;
@@ -237,22 +268,22 @@ static int ibmvstgt_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 	for (i = 0; i < nmd && rest; i++) {
 		unsigned int mdone, mlen;
 
-		mlen = min(rest, md[i].len);
+		mlen = min(rest, be32_to_cpu(md[i].len));
 		for (mdone = 0; mlen;) {
 			int slen = min(sg_dma_len(sg + sidx) - soff, mlen);
 
 			if (dir == DMA_TO_DEVICE)
 				err = h_copy_rdma(slen,
-						  vport->riobn,
-						  md[i].va + mdone,
-						  vport->liobn,
-						  token + soff);
+						vport->riobn,
+						be64_to_cpu(md[i].va) + mdone,
+						vport->liobn,
+						token + soff);
 			else
 				err = h_copy_rdma(slen,
-						  vport->liobn,
-						  token + soff,
-						  vport->riobn,
-						  md[i].va + mdone);
+						vport->liobn,
+						token + soff,
+						vport->riobn,
+						be64_to_cpu(md[i].va) + mdone);
 
 			if (err != H_SUCCESS) {
 				eprintk("rdma error %d %d %ld\n", dir, slen, err);
@@ -262,7 +293,6 @@ static int ibmvstgt_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 			mlen -= slen;
 			mdone += slen;
 			soff += slen;
-			done += slen;
 
 			if (soff == sg_dma_len(sg + sidx)) {
 				sidx++;
@@ -275,49 +305,178 @@ static int ibmvstgt_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 					return -EIO;
 				}
 			}
-		};
+		}
 
 		rest -= mlen;
 	}
 	return 0;
 }
 
-static int ibmvstgt_cmd_done(struct scsi_cmnd *sc,
-			     void (*done)(struct scsi_cmnd *))
+/**
+ * ibmvstgt_enable_target() - Allows to enable a target via sysfs.
+ */
+static int ibmvstgt_enable_target(struct scst_tgt *scst_tgt, bool enable)
 {
+	struct srp_target *target = scst_tgt_get_tgt_priv(scst_tgt);
+	struct vio_port *vport;
 	unsigned long flags;
-	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
-	struct srp_target *target = iue->target;
-	int err = 0;
 
-	dprintk("%p %p %x %u\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0],
-		scsi_sg_count(sc));
+	if (!target)
+		return -ENOENT;
 
-	if (scsi_sg_count(sc))
-		err = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvstgt_rdma, 1, 1);
+	vport = target_to_port(target);
+	TRACE_DBG("%s target %d", enable ? "Enabling" : "Disabling",
+		  vport->dma_dev->unit_address);
 
 	spin_lock_irqsave(&target->lock, flags);
-	list_del(&iue->ilist);
+	vport->enabled = enable;
 	spin_unlock_irqrestore(&target->lock, flags);
 
-	if (err|| sc->result != SAM_STAT_GOOD) {
-		eprintk("operation failed %p %d %x\n",
-			iue, sc->result, vio_iu(iue)->srp.cmd.cdb[0]);
-		send_rsp(iue, sc, HARDWARE_ERROR, 0x00);
-	} else
-		send_rsp(iue, sc, NO_SENSE, 0x00);
+	return 0;
+}
+
+/**
+ * ibmvstgt_is_target_enabled() - Allows to query a targets status via sysfs.
+ */
+static bool ibmvstgt_is_target_enabled(struct scst_tgt *scst_tgt)
+{
+	struct srp_target *target = scst_tgt_get_tgt_priv(scst_tgt);
+	struct vio_port *vport;
+	unsigned long flags;
+	bool res;
+
+	if (!target)
+		return false;
+
+	vport = target_to_port(target);
+	spin_lock_irqsave(&target->lock, flags);
+	res = vport->enabled;
+	spin_unlock_irqrestore(&target->lock, flags);
+	return res;
+}
+
+/**
+ * ibmvstgt_detect() - Returns the number of target adapters.
+ *
+ * Callback function called by the SCST core.
+ */
+static int ibmvstgt_detect(struct scst_tgt_template *tp)
+{
+	return atomic_read(&ibmvstgt_device_count);
+}
+
+/**
+ * ibmvstgt_release() - Free the resources associated with an SCST target.
+ *
+ * Callback function called by the SCST core from scst_unregister_target().
+ */
+static int ibmvstgt_release(struct scst_tgt *scst_tgt)
+{
+	unsigned long flags;
+	struct srp_target *target = scst_tgt_get_tgt_priv(scst_tgt);
+	struct vio_port *vport = target_to_port(target);
+	struct scst_session *sess = vport->sess;
+
+	spin_lock_irqsave(&target->lock, flags);
+	vport->releasing = true;
+	spin_unlock_irqrestore(&target->lock, flags);
+
+	if (sess)
+		scst_unregister_session(sess, 0, NULL);
 
-	done(sc);
-	srp_iu_put(iue);
 	return 0;
 }
 
-int send_adapter_info(struct iu_entry *iue,
+/**
+ * ibmvstgt_xmit_response() - Transmits the response to a SCSI command.
+ *
+ * Callback function called by the SCST core. Must not block. Must ensure that
+ * scst_tgt_cmd_done() will get invoked when returning SCST_TGT_RES_SUCCESS.
+ */
+static int ibmvstgt_xmit_response(struct scst_cmd *sc)
+{
+	struct iu_entry *iue = scst_cmd_get_tgt_priv(sc);
+	struct srp_target *target = iue->target;
+	struct vio_port *vport = target_to_port(target);
+	struct srp_cmd *srp_cmd;
+	int ret;
+	enum dma_data_direction dir;
+
+	if (unlikely(scst_cmd_aborted(sc))) {
+		scst_set_delivery_status(sc, SCST_CMD_DELIVERY_ABORTED);
+		atomic_inc(&vport->req_lim_delta);
+		srp_iu_put(iue);
+		goto out;
+	}
+
+	srp_cmd = &vio_iu(iue)->srp.cmd;
+	dir = srp_cmd_direction(srp_cmd);
+	WARN_ON(dir != DMA_FROM_DEVICE && dir != DMA_TO_DEVICE);
+
+	/* For read commands, transfer the data to the initiator. */
+	if (dir == DMA_FROM_DEVICE && scst_cmd_get_adjusted_resp_data_len(sc)) {
+		ret = srp_transfer_data(sc, srp_cmd, ibmvstgt_rdma, true, true);
+		if (ret == -ENOMEM)
+			return SCST_TGT_RES_QUEUE_FULL;
+		else if (ret) {
+			PRINT_ERROR("%s: tag= %llu xmit_response failed",
+				    __func__, (long long unsigned)
+				    scst_cmd_get_tag(sc));
+			scst_set_delivery_status(sc, SCST_CMD_DELIVERY_FAILED);
+		}
+	}
+
+	send_rsp(iue, sc, scst_cmd_get_status(sc), 0);
+
+out:
+	scst_tgt_cmd_done(sc, SCST_CONTEXT_SAME);
+
+	return SCST_TGT_RES_SUCCESS;
+}
+
+/**
+ * ibmvstgt_rdy_to_xfer() - Transfers data from initiator to target.
+ *
+ * Called by the SCST core to transfer data from the initiator to the target
+ * (SCST_DATA_WRITE / DMA_TO_DEVICE). Must not block.
+ */
+static int ibmvstgt_rdy_to_xfer(struct scst_cmd *sc)
+{
+	struct iu_entry *iue = scst_cmd_get_tgt_priv(sc);
+	struct srp_cmd *srp_cmd = &vio_iu(iue)->srp.cmd;
+	int ret;
+
+	WARN_ON(srp_cmd_direction(srp_cmd) != DMA_TO_DEVICE);
+
+	/* Transfer the data from the initiator to the target. */
+	ret = srp_transfer_data(sc, srp_cmd, ibmvstgt_rdma, true, true);
+	if (ret == 0)
+		scst_rx_data(sc, SCST_RX_STATUS_SUCCESS, SCST_CONTEXT_SAME);
+	else if (ret == -ENOMEM)
+		return SCST_TGT_RES_QUEUE_FULL;
+	else {
+		PRINT_ERROR("%s: tag= %llu xfer_data failed", __func__,
+			(long long unsigned)scst_cmd_get_tag(sc));
+		scst_rx_data(sc, SCST_RX_STATUS_ERROR, SCST_CONTEXT_SAME);
+	}
+
+	return SCST_TGT_RES_SUCCESS;
+}
+
+/**
+ * ibmvstgt_on_free_cmd() - Free command-private data.
+ *
+ * Called by the SCST core. May be called in IRQ context.
+ */
+static void ibmvstgt_on_free_cmd(struct scst_cmd *sc)
+{
+}
+
+static int send_adapter_info(struct iu_entry *iue,
 		      dma_addr_t remote_buffer, uint16_t length)
 {
 	struct srp_target *target = iue->target;
 	struct vio_port *vport = target_to_port(target);
-	struct Scsi_Host *shost = target->shost;
 	dma_addr_t data_token;
 	struct mad_adapter_info_data *info;
 	int err;
@@ -345,7 +504,7 @@ int send_adapter_info(struct iu_entry *iue,
 	info->partition_number = partition_number;
 	info->mad_version = 1;
 	info->os_type = 2;
-	info->port_max_txu[0] = shost->hostt->max_sectors << 9;
+	info->port_max_txu[0] = ibmvstgt_template.sg_tablesize * PAGE_SIZE;
 
 	/* Send our info to remote */
 	err = h_copy_rdma(sizeof(*info), vport->liobn, data_token,
@@ -365,83 +524,208 @@ static void process_login(struct iu_entry *iue)
 {
 	union viosrp_iu *iu = vio_iu(iue);
 	struct srp_login_rsp *rsp = &iu->srp.login_rsp;
+	struct srp_login_rej *rej = &iu->srp.login_rej;
 	uint64_t tag = iu->srp.rsp.tag;
-	struct Scsi_Host *shost = iue->target->shost;
-	struct srp_target *target = host_to_srp_target(shost);
+	struct scst_session *sess;
+	struct srp_target *target = iue->target;
 	struct vio_port *vport = target_to_port(target);
-	struct srp_rport_identifiers ids;
+	char name[16];
+
+	BUG_ON(!target);
+	BUG_ON(!target->tgt);
+	BUG_ON(!vport);
 
-	memset(&ids, 0, sizeof(ids));
-	sprintf(ids.port_id, "%x", vport->dma_dev->unit_address);
-	ids.roles = SRP_RPORT_ROLE_INITIATOR;
-	if (!vport->rport)
-		vport->rport = srp_rport_add(shost, &ids);
+	memset(iu, 0, max(sizeof *rsp, sizeof *rej));
+
+	snprintf(name, sizeof(name), "%x", vport->dma_dev->unit_address);
+
+	if (!ibmvstgt_is_target_enabled(target->tgt)) {
+		rej->reason =
+		  __constant_cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		PRINT_ERROR("rejected SRP_LOGIN_REQ because the target %s"
+			    " has not yet been enabled", name);
+		goto reject;
+	}
+
+	if (vport->sess) {
+		PRINT_INFO("Closing session %s (%p) because a new login request"
+			" has been received", name, vport->sess);
+		scst_unregister_session(vport->sess, 0, NULL);
+		vport->sess = NULL;
+	}
+
+	sess = scst_register_session(target->tgt, 0, name, vport, NULL, NULL);
+	if (!sess) {
+		rej->reason =
+		  __constant_cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		TRACE_DBG("%s", "Failed to create SCST session");
+		goto reject;
+	}
+
+	vport->sess = sess;
 
 	/* TODO handle case that requested size is wrong and
 	 * buffer format is wrong
 	 */
-	memset(iu, 0, sizeof(struct srp_login_rsp));
 	rsp->opcode = SRP_LOGIN_RSP;
-	rsp->req_lim_delta = INITIAL_SRP_LIMIT;
+	/*
+	 * Avoid BUSY conditions by limiting the number of buffers used
+	 * for the SRP protocol to the SCST SCSI command queue size.
+	 */
+	rsp->req_lim_delta = cpu_to_be32(min(SRP_REQ_LIM,
+					   scst_get_max_lun_commands(NULL, 0)));
 	rsp->tag = tag;
-	rsp->max_it_iu_len = sizeof(union srp_iu);
-	rsp->max_ti_iu_len = sizeof(union srp_iu);
+	rsp->max_it_iu_len = __constant_cpu_to_be32(sizeof(union srp_iu));
+	rsp->max_ti_iu_len = __constant_cpu_to_be32(sizeof(union srp_iu));
 	/* direct and indirect */
-	rsp->buf_fmt = SRP_BUF_FORMAT_DIRECT | SRP_BUF_FORMAT_INDIRECT;
+	rsp->buf_fmt = __constant_cpu_to_be16(SRP_BUF_FORMAT_DIRECT
+					      | SRP_BUF_FORMAT_INDIRECT);
 
 	send_iu(iue, sizeof(*rsp), VIOSRP_SRP_FORMAT);
-}
 
-static inline void queue_cmd(struct iu_entry *iue)
-{
-	struct srp_target *target = iue->target;
-	unsigned long flags;
+	return;
 
-	spin_lock_irqsave(&target->lock, flags);
-	list_add_tail(&iue->ilist, &target->cmd_queue);
-	spin_unlock_irqrestore(&target->lock, flags);
+reject:
+	rej->opcode = SRP_LOGIN_REJ;
+	rej->tag = tag;
+	rej->buf_fmt = __constant_cpu_to_be16(SRP_BUF_FORMAT_DIRECT
+					      | SRP_BUF_FORMAT_INDIRECT);
+
+	send_iu(iue, sizeof *rsp, VIOSRP_SRP_FORMAT);
 }
 
+/**
+ * struct mgmt_ctx - management command context information.
+ * @iue:  VIO SRP information unit associated with the management command.
+ * @sess: SCST session via which the management command has been received.
+ * @tag:  SCSI tag of the management command.
+ */
+struct mgmt_ctx {
+	struct iu_entry *iue;
+	struct scst_session *sess;
+};
+
 static int process_tsk_mgmt(struct iu_entry *iue)
 {
 	union viosrp_iu *iu = vio_iu(iue);
-	int fn;
+	struct srp_target *target = iue->target;
+	struct vio_port *vport = target_to_port(target);
+	struct scst_session *sess = vport->sess;
+	struct srp_tsk_mgmt *srp_tsk;
+	struct mgmt_ctx *mgmt_ctx;
+	int ret = 0;
+
+	srp_tsk = &iu->srp.tsk_mgmt;
 
-	dprintk("%p %u\n", iue, iu->srp.tsk_mgmt.tsk_mgmt_func);
+	dprintk("%p %u\n", iue, srp_tsk->tsk_mgmt_func);
 
-	switch (iu->srp.tsk_mgmt.tsk_mgmt_func) {
+	ret = SCST_MGMT_STATUS_FAILED;
+	mgmt_ctx = kmalloc(sizeof *mgmt_ctx, GFP_ATOMIC);
+	if (!mgmt_ctx)
+		goto err;
+
+	mgmt_ctx->iue = iue;
+	mgmt_ctx->sess = sess;
+	iu->srp.rsp.tag = srp_tsk->tag;
+
+	switch (srp_tsk->tsk_mgmt_func) {
 	case SRP_TSK_ABORT_TASK:
-		fn = ABORT_TASK;
+		ret = scst_rx_mgmt_fn_tag(sess, SCST_ABORT_TASK,
+					  srp_tsk->task_tag,
+					  SCST_ATOMIC, mgmt_ctx);
 		break;
 	case SRP_TSK_ABORT_TASK_SET:
-		fn = ABORT_TASK_SET;
+		ret = scst_rx_mgmt_fn_lun(sess, SCST_ABORT_TASK_SET,
+					  (u8 *) &srp_tsk->lun,
+					  sizeof srp_tsk->lun,
+					  SCST_ATOMIC, mgmt_ctx);
 		break;
 	case SRP_TSK_CLEAR_TASK_SET:
-		fn = CLEAR_TASK_SET;
+		ret = scst_rx_mgmt_fn_lun(sess, SCST_CLEAR_TASK_SET,
+					  (u8 *) &srp_tsk->lun,
+					  sizeof srp_tsk->lun,
+					  SCST_ATOMIC, mgmt_ctx);
 		break;
 	case SRP_TSK_LUN_RESET:
-		fn = LOGICAL_UNIT_RESET;
+		ret = scst_rx_mgmt_fn_lun(sess, SCST_LUN_RESET,
+					  (u8 *) &srp_tsk->lun,
+					  sizeof srp_tsk->lun,
+					  SCST_ATOMIC, mgmt_ctx);
 		break;
 	case SRP_TSK_CLEAR_ACA:
-		fn = CLEAR_ACA;
+		ret = scst_rx_mgmt_fn_lun(sess, SCST_CLEAR_ACA,
+					  (u8 *) &srp_tsk->lun,
+					  sizeof srp_tsk->lun,
+					  SCST_ATOMIC, mgmt_ctx);
 		break;
 	default:
-		fn = 0;
+		ret = SCST_MGMT_STATUS_FN_NOT_SUPPORTED;
 	}
-	if (fn)
-		scsi_tgt_tsk_mgmt_request(iue->target->shost,
-					  (unsigned long)iue->target->shost,
-					  fn,
-					  iu->srp.tsk_mgmt.task_tag,
-					  (struct scsi_lun *) &iu->srp.tsk_mgmt.lun,
-					  iue);
-	else
-		send_rsp(iue, NULL, ILLEGAL_REQUEST, 0x20);
 
-	return !fn;
+	if (ret != SCST_MGMT_STATUS_SUCCESS)
+		goto err;
+	return ret;
+
+err:
+	kfree(mgmt_ctx);
+	srp_iu_put(iue);
+	return ret;
 }
 
-static int process_mad_iu(struct iu_entry *iue)
+enum {
+	/* See also table 24 in the T10 r16a document. */
+	SRP_TSK_MGMT_SUCCESS = 0x00,
+	SRP_TSK_MGMT_FUNC_NOT_SUPP = 0x04,
+	SRP_TSK_MGMT_FAILED = 0x05,
+};
+
+static u8 scst_to_srp_tsk_mgmt_status(const int scst_mgmt_status)
+{
+	switch (scst_mgmt_status) {
+	case SCST_MGMT_STATUS_SUCCESS:
+		return SRP_TSK_MGMT_SUCCESS;
+	case SCST_MGMT_STATUS_FN_NOT_SUPPORTED:
+		return SRP_TSK_MGMT_FUNC_NOT_SUPP;
+	case SCST_MGMT_STATUS_TASK_NOT_EXIST:
+	case SCST_MGMT_STATUS_LUN_NOT_EXIST:
+	case SCST_MGMT_STATUS_REJECTED:
+	case SCST_MGMT_STATUS_FAILED:
+	default:
+		break;
+	}
+	return SRP_TSK_MGMT_FAILED;
+}
+
+static void ibmvstgt_tsk_mgmt_done(struct scst_mgmt_cmd *mcmnd)
+{
+	struct mgmt_ctx *mgmt_ctx;
+	struct scst_session *sess;
+	struct iu_entry *iue;
+	union viosrp_iu *iu;
+
+	mgmt_ctx = scst_mgmt_cmd_get_tgt_priv(mcmnd);
+	BUG_ON(!mgmt_ctx);
+
+	sess = mgmt_ctx->sess;
+	BUG_ON(!sess);
+
+	iue = mgmt_ctx->iue;
+	BUG_ON(!iue);
+
+	iu = vio_iu(iue);
+
+	TRACE_DBG("%s: tag %lld status %d",
+		  __func__, (long long unsigned)iu->srp.rsp.tag,
+		  scst_mgmt_cmd_get_status(mcmnd));
+
+	send_rsp(iue, NULL,
+		 scst_to_srp_tsk_mgmt_status(scst_mgmt_cmd_get_status(mcmnd)),
+		 0/*asc*/);
+
+	kfree(mgmt_ctx);
+}
+
+static void process_mad_iu(struct iu_entry *iue)
 {
 	union viosrp_iu *iu = vio_iu(iue);
 	struct viosrp_adapter_info *info;
@@ -450,6 +734,7 @@ static int process_mad_iu(struct iu_entry *iue)
 	switch (iu->mad.empty_iu.common.type) {
 	case VIOSRP_EMPTY_IU_TYPE:
 		eprintk("%s\n", "Unsupported EMPTY MAD IU");
+		srp_iu_put(iue);
 		break;
 	case VIOSRP_ERROR_LOG_TYPE:
 		eprintk("%s\n", "Unsupported ERROR LOG MAD IU");
@@ -469,27 +754,41 @@ static int process_mad_iu(struct iu_entry *iue)
 		break;
 	default:
 		eprintk("Unknown type %u\n", iu->srp.rsp.opcode);
+		srp_iu_put(iue);
 	}
-
-	return 1;
 }
 
-static int process_srp_iu(struct iu_entry *iue)
+static void process_srp_iu(struct iu_entry *iue)
 {
+	unsigned long flags;
 	union viosrp_iu *iu = vio_iu(iue);
-	int done = 1;
+	struct srp_target *target = iue->target;
+	struct vio_port *vport = target_to_port(target);
+	int err;
 	u8 opcode = iu->srp.rsp.opcode;
 
+	spin_lock_irqsave(&target->lock, flags);
+	if (vport->releasing) {
+		spin_unlock_irqrestore(&target->lock, flags);
+		srp_iu_put(iue);
+		return;
+	}
+	spin_unlock_irqrestore(&target->lock, flags);
+
 	switch (opcode) {
 	case SRP_LOGIN_REQ:
 		process_login(iue);
 		break;
 	case SRP_TSK_MGMT:
-		done = process_tsk_mgmt(iue);
+		process_tsk_mgmt(iue);
 		break;
 	case SRP_CMD:
-		queue_cmd(iue);
-		done = 0;
+		err = srp_cmd_queue(vport->sess, &iu->srp.cmd, iue,
+				    SCST_NON_ATOMIC);
+		if (err) {
+			eprintk("cannot queue cmd %p %d\n", &iu->srp.cmd, err);
+			srp_iu_put(iue);
+		}
 		break;
 	case SRP_LOGIN_RSP:
 	case SRP_I_LOGOUT:
@@ -500,12 +799,12 @@ static int process_srp_iu(struct iu_entry *iue)
 	case SRP_AER_REQ:
 	case SRP_AER_RSP:
 		eprintk("Unsupported type %u\n", opcode);
+		srp_iu_put(iue);
 		break;
 	default:
 		eprintk("Unknown type %u\n", opcode);
+		srp_iu_put(iue);
 	}
-
-	return done;
 }
 
 static void process_iu(struct viosrp_crq *crq, struct srp_target *target)
@@ -513,7 +812,6 @@ static void process_iu(struct viosrp_crq *crq, struct srp_target *target)
 	struct vio_port *vport = target_to_port(target);
 	struct iu_entry *iue;
 	long err;
-	int done = 1;
 
 	iue = srp_iu_get(target);
 	if (!iue) {
@@ -528,16 +826,13 @@ static void process_iu(struct viosrp_crq *crq, struct srp_target *target)
 
 	if (err != H_SUCCESS) {
 		eprintk("%ld transferring data error %p\n", err, iue);
-		goto out;
+		srp_iu_put(iue);
 	}
 
 	if (crq->format == VIOSRP_MAD_FORMAT)
-		done = process_mad_iu(iue);
+		process_mad_iu(iue);
 	else
-		done = process_srp_iu(iue);
-out:
-	if (done)
-		srp_iu_put(iue);
+		process_srp_iu(iue);
 }
 
 static irqreturn_t ibmvstgt_interrupt(int dummy, void *data)
@@ -595,7 +890,7 @@ static int crq_queue_create(struct crq_queue *queue, struct srp_target *target)
 
 	vio_enable_interrupts(vport->dma_dev);
 
-	h_send_crq(vport->dma_dev->unit_address, 0xC001000000000000, 0);
+	h_send_crq(vport->dma_dev->unit_address, 0xC001000000000000ULL, 0);
 
 	queue->cur = 0;
 	spin_lock_init(&queue->lock);
@@ -645,7 +940,7 @@ static void process_crq(struct viosrp_crq *crq,	struct srp_target *target)
 		switch (crq->format) {
 		case 0x01:
 			h_send_crq(vport->dma_dev->unit_address,
-				   0xC002000000000000, 0);
+				   0xC002000000000000ULL, 0);
 			break;
 		case 0x02:
 			break;
@@ -695,6 +990,13 @@ static inline struct viosrp_crq *next_crq(struct crq_queue *queue)
 	return crq;
 }
 
+/**
+ * handle_crq() - Process the command/response queue.
+ *
+ * Note: Although this function is not thread-safe because of how it is
+ * scheduled it is guaranteed that this function will never run concurrently
+ * with itself.
+ */
 static void handle_crq(struct work_struct *work)
 {
 	struct vio_port *vport = container_of(work, struct vio_port, crq_work);
@@ -718,67 +1020,97 @@ static void handle_crq(struct work_struct *work)
 		} else
 			done = 1;
 	}
-
-	handle_cmd_queue(target);
-}
-
-
-static int ibmvstgt_eh_abort_handler(struct scsi_cmnd *sc)
-{
-	unsigned long flags;
-	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
-	struct srp_target *target = iue->target;
-
-	dprintk("%p %p %x\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0]);
-
-	spin_lock_irqsave(&target->lock, flags);
-	list_del(&iue->ilist);
-	spin_unlock_irqrestore(&target->lock, flags);
-
-	srp_iu_put(iue);
-
-	return 0;
 }
 
-static int ibmvstgt_tsk_mgmt_response(struct Scsi_Host *shost,
-				      u64 itn_id, u64 mid, int result)
+static void ibmvstgt_get_product_id(const struct scst_tgt_dev *tgt_dev,
+				    char *buf, const int size)
 {
-	struct iu_entry *iue = (struct iu_entry *) ((void *) mid);
-	union viosrp_iu *iu = vio_iu(iue);
-	unsigned char status, asc;
+	WARN_ON(size != 16);
 
-	eprintk("%p %d\n", iue, result);
-	status = NO_SENSE;
-	asc = 0;
-
-	switch (iu->srp.tsk_mgmt.tsk_mgmt_func) {
-	case SRP_TSK_ABORT_TASK:
-		asc = 0x14;
-		if (result)
-			status = ABORTED_COMMAND;
+	/*
+	 * AIX uses hardcoded device names. The AIX SCSI initiator even won't
+	 * work unless we use the names VDASD and VOPTA.
+	 */
+	switch (tgt_dev->dev->type) {
+	case TYPE_DISK:
+		memcpy(buf, "VDASD blkdev    ", 16);
+		break;
+	case TYPE_ROM:
+		memcpy(buf, "VOPTA blkdev    ", 16);
 		break;
 	default:
+		snprintf(buf, size, "(devtype %d)     ", tgt_dev->dev->type);
 		break;
 	}
+}
 
-	send_rsp(iue, NULL, status, asc);
-	srp_iu_put(iue);
+/*
+ * Extract target, bus and LUN information from a 64-bit LUN in CPU-order.
+ */
+#define GETTARGET(x) ((((uint16_t)(x) >> 8) & 0x003f))
+#define GETBUS(x)    ((((uint16_t)(x) >> 5) & 0x0007))
+#define GETLUN(x)    ((((uint16_t)(x) >> 0) & 0x001f))
 
-	return 0;
+static int ibmvstgt_get_serial(const struct scst_tgt_dev *tgt_dev, char *buf,
+			       int size)
+{
+	struct scst_session *sess = tgt_dev->sess;
+	struct vio_port *vport = scst_sess_get_tgt_priv(sess);
+	uint64_t lun = tgt_dev->lun;
+
+	return snprintf(buf, size,
+			"IBM-VSCSI-%s-P%d-%x-%d-%d-%d\n",
+			system_id, partition_number,
+			vport->dma_dev->unit_address,
+			GETBUS(lun), GETTARGET(lun), GETLUN(lun));
 }
 
-static int ibmvstgt_it_nexus_response(struct Scsi_Host *shost, u64 itn_id,
-				      int result)
+/**
+ * ibmvstgt_get_transportid() - SCST TransportID callback function.
+ *
+ * See also SPC-3, section 7.5.4.5, TransportID for initiator ports using SRP.
+ */
+static int ibmvstgt_get_transportid(struct scst_session *sess,
+				    uint8_t **transport_id)
 {
-	struct srp_target *target = host_to_srp_target(shost);
-	struct vio_port *vport = target_to_port(target);
+	struct vio_port *vport;
+	struct spc_rdma_transport_id {
+		uint8_t protocol_identifier;
+		uint8_t reserved[7];
+		union {
+			uint8_t id8[16];
+			__be32  id32[4];
+		} i_port_id;
+	};
+	struct spc_rdma_transport_id *tr_id;
+	int res;
+
+	if (!sess) {
+		res = SCSI_TRANSPORTID_PROTOCOLID_SRP;
+		goto out;
+	}
+
+	vport = scst_sess_get_tgt_priv(sess);
+	BUG_ON(!vport);
 
-	if (result) {
-		eprintk("%p %d\n", shost, result);
-		srp_rport_del(vport->rport);
-		vport->rport = NULL;
+	BUILD_BUG_ON(sizeof(*tr_id) != 24);
+
+	res = -ENOMEM;
+	tr_id = kzalloc(sizeof(struct spc_rdma_transport_id), GFP_KERNEL);
+	if (!tr_id) {
+		PRINT_ERROR("%s", "Allocation of TransportID failed");
+		goto out;
 	}
-	return 0;
+
+	res = 0;
+	tr_id->protocol_identifier = SCSI_TRANSPORTID_PROTOCOLID_SRP;
+	memset(&tr_id->i_port_id, 0, sizeof(tr_id->i_port_id));
+	tr_id->i_port_id.id32[3] = cpu_to_be32(vport->dma_dev->unit_address);
+
+	*transport_id = (uint8_t *)tr_id;
+
+out:
+	return res;
 }
 
 static ssize_t system_id_show(struct device *dev,
@@ -796,65 +1128,91 @@ static ssize_t partition_number_show(struct device *dev,
 static ssize_t unit_address_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
-	struct Scsi_Host *shost = class_to_shost(dev);
-	struct srp_target *target = host_to_srp_target(shost);
-	struct vio_port *vport = target_to_port(target);
+	struct vio_port *vport = container_of(dev, struct vio_port, dev);
 	return snprintf(buf, PAGE_SIZE, "%x\n", vport->dma_dev->unit_address);
 }
 
-static DEVICE_ATTR(system_id, S_IRUGO, system_id_show, NULL);
-static DEVICE_ATTR(partition_number, S_IRUGO, partition_number_show, NULL);
-static DEVICE_ATTR(unit_address, S_IRUGO, unit_address_show, NULL);
+static struct class_attribute ibmvstgt_class_attrs[] = {
+	__ATTR_NULL,
+};
+
+static struct device_attribute ibmvstgt_attrs[] = {
+	__ATTR(system_id, S_IRUGO, system_id_show, NULL),
+	__ATTR(partition_number, S_IRUGO, partition_number_show, NULL),
+	__ATTR(unit_address, S_IRUGO, unit_address_show, NULL),
+	__ATTR_NULL,
+};
+
+static void ibmvstgt_dev_release(struct device *dev)
+{ }
 
-static struct device_attribute *ibmvstgt_attrs[] = {
-	&dev_attr_system_id,
-	&dev_attr_partition_number,
-	&dev_attr_unit_address,
-	NULL,
+static struct class ibmvstgt_class = {
+	.name		= "ibmvstgt",
+	.dev_release	= ibmvstgt_dev_release,
+	.class_attrs	= ibmvstgt_class_attrs,
+	.dev_attrs	= ibmvstgt_attrs,
 };
 
-static struct scsi_host_template ibmvstgt_sht = {
+static struct scst_tgt_template ibmvstgt_template = {
 	.name			= TGT_NAME,
-	.module			= THIS_MODULE,
-	.can_queue		= INITIAL_SRP_LIMIT,
-	.sg_tablesize		= SG_ALL,
-	.use_clustering		= DISABLE_CLUSTERING,
-	.max_sectors		= DEFAULT_MAX_SECTORS,
-	.transfer_response	= ibmvstgt_cmd_done,
-	.eh_abort_handler	= ibmvstgt_eh_abort_handler,
-	.shost_attrs		= ibmvstgt_attrs,
-	.proc_name		= TGT_NAME,
-	.supported_mode		= MODE_TARGET,
+	.owner			= THIS_MODULE,
+	.preferred_addr_method	= SCST_LUN_ADDR_METHOD_LUN,
+	.sg_tablesize		= SCSI_MAX_SG_SEGMENTS,
+	.vendor			= "IBM     ",
+	.revision		= "0001",
+	.fake_aca		= true,
+	.get_product_id		= ibmvstgt_get_product_id,
+	.get_serial		= ibmvstgt_get_serial,
+	.get_vend_specific	= ibmvstgt_get_serial,
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags	= DEFAULT_IBMVSTGT_TRACE_FLAGS,
+	.trace_flags		= &trace_flag,
+#endif
+	.enable_target		= ibmvstgt_enable_target,
+	.is_target_enabled	= ibmvstgt_is_target_enabled,
+	.detect			= ibmvstgt_detect,
+	.release		= ibmvstgt_release,
+	.xmit_response		= ibmvstgt_xmit_response,
+	.rdy_to_xfer		= ibmvstgt_rdy_to_xfer,
+	.on_free_cmd		= ibmvstgt_on_free_cmd,
+	.task_mgmt_fn_done	= ibmvstgt_tsk_mgmt_done,
+	.get_initiator_port_transport_id = ibmvstgt_get_transportid,
 };
 
 static int ibmvstgt_probe(struct vio_dev *dev, const struct vio_device_id *id)
 {
-	struct Scsi_Host *shost;
+	struct scst_tgt *scst_tgt;
 	struct srp_target *target;
 	struct vio_port *vport;
-	unsigned int *dma, dma_size;
+	const unsigned int *dma;
+	unsigned dma_size;
 	int err = -ENOMEM;
 
 	vport = kzalloc(sizeof(struct vio_port), GFP_KERNEL);
 	if (!vport)
 		return err;
-	shost = scsi_host_alloc(&ibmvstgt_sht, sizeof(struct srp_target));
-	if (!shost)
+
+	target = kzalloc(sizeof(struct srp_target), GFP_KERNEL);
+	if (!target)
 		goto free_vport;
-	shost->transportt = ibmvstgt_transport_template;
 
-	target = host_to_srp_target(shost);
-	target->shost = shost;
+	scst_tgt = scst_register_target(&ibmvstgt_template, NULL);
+	if (!scst_tgt)
+		goto free_target;
+
+	scst_tgt_set_tgt_priv(scst_tgt, target);
+	target->tgt = scst_tgt;
 	vport->dma_dev = dev;
 	target->ldata = vport;
 	vport->target = target;
-	err = srp_target_alloc(target, &dev->dev, INITIAL_SRP_LIMIT,
+	BUILD_BUG_ON_NOT_POWER_OF_2(VSCSI_REQ_LIM);
+	err = srp_target_alloc(target, &dev->dev, VSCSI_REQ_LIM,
 			       SRP_MAX_IU_LEN);
 	if (err)
-		goto put_host;
+		goto unregister_target;
 
-	dma = (unsigned int *) vio_get_attribute(dev, "ibm,my-dma-window",
-						 &dma_size);
+	dma = vio_get_attribute(dev, "ibm,my-dma-window", &dma_size);
 	if (!dma || dma_size != 40) {
 		eprintk("Couldn't get window property %d\n", dma_size);
 		err = -EIO;
@@ -865,27 +1223,29 @@ static int ibmvstgt_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	INIT_WORK(&vport->crq_work, handle_crq);
 
-	err = scsi_add_host(shost, target->dev);
+	err = crq_queue_create(&vport->crq_queue, target);
 	if (err)
 		goto free_srp_target;
 
-	err = scsi_tgt_alloc_queue(shost);
-	if (err)
-		goto remove_host;
+	vport->dev.class = &ibmvstgt_class;
+	vport->dev.parent = &dev->dev;
+	dev_set_name(&vport->dev, "ibmvstgt-%d",
+		     vport->dma_dev->unit_address);
+	if (device_register(&vport->dev))
+		goto destroy_crq_queue;
 
-	err = crq_queue_create(&vport->crq_queue, target);
-	if (err)
-		goto free_queue;
+	atomic_inc(&ibmvstgt_device_count);
 
 	return 0;
-free_queue:
-	scsi_tgt_free_queue(shost);
-remove_host:
-	scsi_remove_host(shost);
+
+destroy_crq_queue:
+	crq_queue_destroy(target);
 free_srp_target:
 	srp_target_free(target);
-put_host:
-	scsi_host_put(shost);
+unregister_target:
+	scst_unregister_target(scst_tgt);
+free_target:
+	kfree(target);
 free_vport:
 	kfree(vport);
 	return err;
@@ -893,17 +1253,22 @@ free_vport:
 
 static int ibmvstgt_remove(struct vio_dev *dev)
 {
-	struct srp_target *target = dev_get_drvdata(&dev->dev);
-	struct Scsi_Host *shost = target->shost;
-	struct vio_port *vport = target->ldata;
+	struct srp_target *target;
+	struct vio_port *vport;
+
+	target = dev_get_drvdata(&dev->dev);
+	if (!target)
+		return 0;
 
+	atomic_dec(&ibmvstgt_device_count);
+
+	vport = target->ldata;
+	device_unregister(&vport->dev);
 	crq_queue_destroy(target);
-	srp_remove_host(shost);
-	scsi_remove_host(shost);
-	scsi_tgt_free_queue(shost);
 	srp_target_free(target);
+	scst_unregister_target(target->tgt);
+	kfree(target);
 	kfree(vport);
-	scsi_host_put(shost);
 	return 0;
 }
 
@@ -915,9 +1280,9 @@ static struct vio_device_id ibmvstgt_device_table[] __devinitdata = {
 MODULE_DEVICE_TABLE(vio, ibmvstgt_device_table);
 
 static struct vio_driver ibmvstgt_driver = {
-	.id_table = ibmvstgt_device_table,
-	.probe = ibmvstgt_probe,
-	.remove = ibmvstgt_remove,
+	.id_table	= ibmvstgt_device_table,
+	.probe		= ibmvstgt_probe,
+	.remove		= ibmvstgt_remove,
 	.driver = {
 		.name = "ibmvscsis",
 		.owner = THIS_MODULE,
@@ -926,7 +1291,7 @@ static struct vio_driver ibmvstgt_driver = {
 
 static int get_system_info(void)
 {
-	struct device_node *rootdn;
+	struct device_node *rootdn, *vdevdn;
 	const char *id, *model, *name;
 	const unsigned int *num;
 
@@ -948,52 +1313,75 @@ static int get_system_info(void)
 		partition_number = *num;
 
 	of_node_put(rootdn);
+
+	vdevdn = of_find_node_by_path("/vdevice");
+	if (vdevdn) {
+		const unsigned *mvds;
+
+		mvds = of_get_property(vdevdn, "ibm,max-virtual-dma-size",
+				       NULL);
+		if (mvds)
+			max_vdma_size = *mvds;
+		of_node_put(vdevdn);
+	}
+
 	return 0;
 }
 
-static struct srp_function_template ibmvstgt_transport_functions = {
-	.tsk_mgmt_response = ibmvstgt_tsk_mgmt_response,
-	.it_nexus_response = ibmvstgt_it_nexus_response,
-};
-
+/**
+ * ibmvstgt_init() - Kernel module initialization.
+ *
+ * Note: Since vio_register_driver() registers callback functions, and since
+ * at least one of these callback functions (ibmvstgt_probe()) calls SCST
+ * functions, the SCST target template must be registered before
+ * vio_register_driver() is called.
+ */
 static int __init ibmvstgt_init(void)
 {
 	int err = -ENOMEM;
 
-	printk("IBM eServer i/pSeries Virtual SCSI Target Driver\n");
+	printk(KERN_INFO "IBM eServer i/pSeries Virtual SCSI Target Driver\n");
 
-	ibmvstgt_transport_template =
-		srp_attach_transport(&ibmvstgt_transport_functions);
-	if (!ibmvstgt_transport_template)
-		return err;
+	err = get_system_info();
+	if (err)
+		goto out;
 
-	vtgtd = create_workqueue("ibmvtgtd");
-	if (!vtgtd)
-		goto release_transport;
+	err = class_register(&ibmvstgt_class);
+	if (err)
+		goto out;
 
-	err = get_system_info();
+	err = scst_register_target_template(&ibmvstgt_template);
 	if (err)
-		goto destroy_wq;
+		goto unregister_class;
+
+	vtgtd = create_workqueue("ibmvtgtd");
+	if (!vtgtd)
+		goto unregister_tgt;
 
 	err = vio_register_driver(&ibmvstgt_driver);
 	if (err)
 		goto destroy_wq;
 
 	return 0;
+
 destroy_wq:
 	destroy_workqueue(vtgtd);
-release_transport:
-	srp_release_transport(ibmvstgt_transport_template);
+unregister_tgt:
+	scst_unregister_target_template(&ibmvstgt_template);
+unregister_class:
+	class_unregister(&ibmvstgt_class);
+out:
 	return err;
 }
 
 static void __exit ibmvstgt_exit(void)
 {
-	printk("Unregister IBM virtual SCSI driver\n");
+	printk(KERN_INFO "Unregister IBM virtual SCSI driver\n");
 
-	destroy_workqueue(vtgtd);
 	vio_unregister_driver(&ibmvstgt_driver);
-	srp_release_transport(ibmvstgt_transport_template);
+	destroy_workqueue(vtgtd);
+	scst_unregister_target_template(&ibmvstgt_template);
+	class_unregister(&ibmvstgt_class);
 }
 
 MODULE_DESCRIPTION("IBM Virtual SCSI Target");
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index ff6a28c..7af23db 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -2,6 +2,7 @@
  * SCSI RDMA Protocol lib functions
  *
  * Copyright (C) 2006 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2010 Bart Van Assche <bvanassche@acm.org>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -23,24 +24,13 @@
 #include <linux/kfifo.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/scsi_tgt.h>
 #include <scsi/srp.h>
 #include <scsi/libsrp.h>
 
-enum srp_task_attributes {
-	SRP_SIMPLE_TASK = 0,
-	SRP_HEAD_TASK = 1,
-	SRP_ORDERED_TASK = 2,
-	SRP_ACA_TASK = 4
-};
-
 /* tmp - will replace with SCSI logging stuff */
 #define eprintk(fmt, args...)					\
 do {								\
-	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
+	printk(KERN_ERR "%s(%d) " fmt, __func__, __LINE__, ##args); \
 } while (0)
 /* #define dprintk eprintk */
 #define dprintk(fmt, args...)
@@ -130,10 +120,8 @@ int srp_target_alloc(struct srp_target *target, struct device *dev,
 	int err;
 
 	spin_lock_init(&target->lock);
-	INIT_LIST_HEAD(&target->cmd_queue);
 
 	target->dev = dev;
-	dev_set_drvdata(target->dev, target);
 
 	target->srp_iu_size = iu_size;
 	target->rx_ring_size = nr;
@@ -143,6 +131,7 @@ int srp_target_alloc(struct srp_target *target, struct device *dev,
 	err = srp_iu_pool_alloc(&target->iu_queue, nr, target->rx_ring);
 	if (err)
 		goto free_ring;
+	dev_set_drvdata(target->dev, target);
 
 	return 0;
 
@@ -154,6 +143,7 @@ EXPORT_SYMBOL_GPL(srp_target_alloc);
 
 void srp_target_free(struct srp_target *target)
 {
+	dev_set_drvdata(target->dev, NULL);
 	srp_ring_free(target->dev, target->rx_ring, target->rx_ring_size,
 		      target->srp_iu_size);
 	srp_iu_pool_free(&target->iu_queue);
@@ -172,7 +162,6 @@ struct iu_entry *srp_iu_get(struct srp_target *target)
 	if (!iue)
 		return iue;
 	iue->target = target;
-	INIT_LIST_HEAD(&iue->ilist);
 	iue->flags = 0;
 	return iue;
 }
@@ -185,40 +174,49 @@ void srp_iu_put(struct iu_entry *iue)
 }
 EXPORT_SYMBOL_GPL(srp_iu_put);
 
-static int srp_direct_data(struct scsi_cmnd *sc, struct srp_direct_buf *md,
+static int srp_direct_data(struct scst_cmd *sc, struct srp_direct_buf *md,
 			   enum dma_data_direction dir, srp_rdma_t rdma_io,
-			   int dma_map, int ext_desc)
+			   int dma_map)
 {
 	struct iu_entry *iue = NULL;
 	struct scatterlist *sg = NULL;
-	int err, nsg = 0, len;
+	int err, nsg = 0, len, sg_cnt;
+	u32 tsize;
+	enum dma_data_direction dma_dir;
+
+	iue = scst_cmd_get_tgt_priv(sc);
+	if (dir == DMA_TO_DEVICE) {
+		scst_cmd_get_write_fields(sc, &sg, &sg_cnt);
+		tsize = scst_cmd_get_bufflen(sc);
+		dma_dir = DMA_FROM_DEVICE;
+	} else {
+		sg = scst_cmd_get_sg(sc);
+		sg_cnt = scst_cmd_get_sg_cnt(sc);
+		tsize = scst_cmd_get_adjusted_resp_data_len(sc);
+		dma_dir = DMA_TO_DEVICE;
+	}
 
-	if (dma_map) {
-		iue = (struct iu_entry *) sc->SCp.ptr;
-		sg = scsi_sglist(sc);
+	dprintk("%p %u %u %d\n", iue, tsize, be32_to_cpu(md->len), sg_cnt);
 
-		dprintk("%p %u %u %d\n", iue, scsi_bufflen(sc),
-			md->len, scsi_sg_count(sc));
+	len = min(tsize, be32_to_cpu(md->len));
 
-		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
-				 DMA_BIDIRECTIONAL);
+	if (dma_map) {
+		nsg = dma_map_sg(iue->target->dev, sg, sg_cnt, dma_dir);
 		if (!nsg) {
-			printk("fail to map %p %d\n", iue, scsi_sg_count(sc));
-			return 0;
+			eprintk(KERN_ERR "fail to map %p %d\n", iue, sg_cnt);
+			return -ENOMEM;
 		}
-		len = min(scsi_bufflen(sc), md->len);
-	} else
-		len = md->len;
+	}
 
 	err = rdma_io(sc, sg, nsg, md, 1, dir, len);
 
 	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(iue->target->dev, sg, nsg, dma_dir);
 
 	return err;
 }
 
-static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
+static int srp_indirect_data(struct scst_cmd *sc, struct srp_cmd *cmd,
 			     struct srp_indirect_buf *id,
 			     enum dma_data_direction dir, srp_rdma_t rdma_io,
 			     int dma_map, int ext_desc)
@@ -228,18 +226,29 @@ static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 	struct scatterlist dummy, *sg = NULL;
 	dma_addr_t token = 0;
 	int err = 0;
-	int nmd, nsg = 0, len;
+	int nmd, nsg = 0, len, sg_cnt = 0;
+	u32 tsize = 0;
+	enum dma_data_direction dma_dir;
+
+	iue = scst_cmd_get_tgt_priv(sc);
+	if (dir == DMA_TO_DEVICE) {
+		scst_cmd_get_write_fields(sc, &sg, &sg_cnt);
+		tsize = scst_cmd_get_bufflen(sc);
+		dma_dir = DMA_FROM_DEVICE;
+	} else {
+		sg = scst_cmd_get_sg(sc);
+		sg_cnt = scst_cmd_get_sg_cnt(sc);
+		tsize = scst_cmd_get_adjusted_resp_data_len(sc);
+		dma_dir = DMA_TO_DEVICE;
+	}
 
-	if (dma_map || ext_desc) {
-		iue = (struct iu_entry *) sc->SCp.ptr;
-		sg = scsi_sglist(sc);
+	dprintk("%p %u %u %d %d\n", iue, tsize, be32_to_cpu(id->len),
+		be32_to_cpu(cmd->data_in_desc_cnt),
+		be32_to_cpu(cmd->data_out_desc_cnt));
 
-		dprintk("%p %u %u %d %d\n",
-			iue, scsi_bufflen(sc), id->len,
-			cmd->data_in_desc_cnt, cmd->data_out_desc_cnt);
-	}
+	len = min(tsize, be32_to_cpu(id->len));
 
-	nmd = id->table_desc.len / sizeof(struct srp_direct_buf);
+	nmd = be32_to_cpu(id->table_desc.len) / sizeof(struct srp_direct_buf);
 
 	if ((dir == DMA_FROM_DEVICE && nmd == cmd->data_in_desc_cnt) ||
 	    (dir == DMA_TO_DEVICE && nmd == cmd->data_out_desc_cnt)) {
@@ -248,18 +257,19 @@ static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 	}
 
 	if (ext_desc && dma_map) {
-		md = dma_alloc_coherent(iue->target->dev, id->table_desc.len,
-				&token, GFP_KERNEL);
+		md = dma_alloc_coherent(iue->target->dev,
+					be32_to_cpu(id->table_desc.len),
+					&token, GFP_KERNEL);
 		if (!md) {
 			eprintk("Can't get dma memory %u\n", id->table_desc.len);
 			return -ENOMEM;
 		}
 
-		sg_init_one(&dummy, md, id->table_desc.len);
+		sg_init_one(&dummy, md, be32_to_cpu(id->table_desc.len));
 		sg_dma_address(&dummy) = token;
-		sg_dma_len(&dummy) = id->table_desc.len;
+		sg_dma_len(&dummy) = be32_to_cpu(id->table_desc.len);
 		err = rdma_io(sc, &dummy, 1, &id->table_desc, 1, DMA_TO_DEVICE,
-			      id->table_desc.len);
+			      be32_to_cpu(id->table_desc.len));
 		if (err) {
 			eprintk("Error copying indirect table %d\n", err);
 			goto free_mem;
@@ -271,25 +281,23 @@ static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 
 rdma:
 	if (dma_map) {
-		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
-				 DMA_BIDIRECTIONAL);
+		nsg = dma_map_sg(iue->target->dev, sg, sg_cnt, dma_dir);
 		if (!nsg) {
-			eprintk("fail to map %p %d\n", iue, scsi_sg_count(sc));
-			err = -EIO;
+			eprintk("fail to map %p %d\n", iue, sg_cnt);
+			err = -ENOMEM;
 			goto free_mem;
 		}
-		len = min(scsi_bufflen(sc), id->len);
-	} else
-		len = id->len;
+	}
 
 	err = rdma_io(sc, sg, nsg, md, nmd, dir, len);
 
 	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(iue->target->dev, sg, nsg, dma_dir);
 
 free_mem:
 	if (token && dma_map)
-		dma_free_coherent(iue->target->dev, id->table_desc.len, md, token);
+		dma_free_coherent(iue->target->dev,
+				  be32_to_cpu(id->table_desc.len), md, token);
 
 	return err;
 }
@@ -316,11 +324,7 @@ static int data_out_desc_size(struct srp_cmd *cmd)
 	return size;
 }
 
-/*
- * TODO: this can be called multiple times for a single command if it
- * has very long data.
- */
-int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
+int srp_transfer_data(struct scst_cmd *sc, struct srp_cmd *cmd,
 		      srp_rdma_t rdma_io, int dma_map, int ext_desc)
 {
 	struct srp_direct_buf *md;
@@ -346,7 +350,7 @@ int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 	case SRP_DATA_DESC_DIRECT:
 		md = (struct srp_direct_buf *)
 			(cmd->add_data + offset);
-		err = srp_direct_data(sc, md, dir, rdma_io, dma_map, ext_desc);
+		err = srp_direct_data(sc, md, dir, rdma_io, dma_map);
 		break;
 	case SRP_DATA_DESC_INDIRECT:
 		id = (struct srp_indirect_buf *)
@@ -363,7 +367,7 @@ int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 }
 EXPORT_SYMBOL_GPL(srp_transfer_data);
 
-static int vscsis_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
+int srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
 {
 	struct srp_direct_buf *md;
 	struct srp_indirect_buf *id;
@@ -382,11 +386,11 @@ static int vscsis_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
 		break;
 	case SRP_DATA_DESC_DIRECT:
 		md = (struct srp_direct_buf *) (cmd->add_data + offset);
-		len = md->len;
+		len = be32_to_cpu(md->len);
 		break;
 	case SRP_DATA_DESC_INDIRECT:
 		id = (struct srp_indirect_buf *) (cmd->add_data + offset);
-		len = id->len;
+		len = be32_to_cpu(id->len);
 		break;
 	default:
 		eprintk("invalid data format %x\n", fmt);
@@ -394,50 +398,52 @@ static int vscsis_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
 	}
 	return len;
 }
+EXPORT_SYMBOL_GPL(srp_data_length);
 
-int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
-		  u64 itn_id, u64 addr)
+int srp_cmd_queue(struct scst_session *sess, struct srp_cmd *cmd, void *info,
+		  int atomic)
 {
 	enum dma_data_direction dir;
-	struct scsi_cmnd *sc;
-	int tag, len, err;
+	struct scst_cmd *sc;
+	int tag, len;
 
 	switch (cmd->task_attr) {
 	case SRP_SIMPLE_TASK:
-		tag = MSG_SIMPLE_TAG;
+		tag = SCST_CMD_QUEUE_SIMPLE;
 		break;
 	case SRP_ORDERED_TASK:
-		tag = MSG_ORDERED_TAG;
+		tag = SCST_CMD_QUEUE_ORDERED;
 		break;
 	case SRP_HEAD_TASK:
-		tag = MSG_HEAD_TAG;
+		tag = SCST_CMD_QUEUE_HEAD_OF_QUEUE;
+		break;
+	case SRP_ACA_TASK:
+		tag = SCST_CMD_QUEUE_ACA;
 		break;
 	default:
 		eprintk("Task attribute %d not supported\n", cmd->task_attr);
-		tag = MSG_ORDERED_TAG;
+		tag = SCST_CMD_QUEUE_ORDERED;
 	}
 
 	dir = srp_cmd_direction(cmd);
-	len = vscsis_data_length(cmd, dir);
+	len = srp_data_length(cmd, dir);
 
 	dprintk("%p %x %lx %d %d %d %llx\n", info, cmd->cdb[0],
 		cmd->lun, dir, len, tag, (unsigned long long) cmd->tag);
 
-	sc = scsi_host_get_command(shost, dir, GFP_KERNEL);
+	sc = scst_rx_cmd(sess, (u8 *) &cmd->lun, sizeof(cmd->lun),
+			 cmd->cdb, sizeof(cmd->cdb), atomic);
 	if (!sc)
 		return -ENOMEM;
 
-	sc->SCp.ptr = info;
-	memcpy(sc->cmnd, cmd->cdb, MAX_COMMAND_SIZE);
-	sc->sdb.length = len;
-	sc->sdb.table.sgl = (void *) (unsigned long) addr;
-	sc->tag = tag;
-	err = scsi_tgt_queue_command(sc, itn_id, (struct scsi_lun *)&cmd->lun,
-				     cmd->tag);
-	if (err)
-		scsi_host_put_command(shost, sc);
+	scst_cmd_set_queue_type(sc, tag);
+	scst_cmd_set_tag(sc, cmd->tag);
+	scst_cmd_set_tgt_priv(sc, info);
+	scst_cmd_set_expected(sc, dir == DMA_TO_DEVICE
+			      ? SCST_DATA_WRITE : SCST_DATA_READ, len);
+	scst_cmd_init_done(sc, SCST_CONTEXT_THREAD);
 
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(srp_cmd_queue);
 
diff --git a/include/scsi/libsrp.h b/include/scsi/libsrp.h
index f4105c9..b210138 100644
--- a/include/scsi/libsrp.h
+++ b/include/scsi/libsrp.h
@@ -3,17 +3,9 @@
 
 #include <linux/list.h>
 #include <linux/kfifo.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_host.h>
+#include <scst/scst.h>
 #include <scsi/srp.h>
 
-enum iue_flags {
-	V_DIOVER,
-	V_WRITE,
-	V_LINKED,
-	V_FLYING,
-};
-
 struct srp_buf {
 	dma_addr_t dma;
 	void *buf;
@@ -27,11 +19,10 @@ struct srp_queue {
 };
 
 struct srp_target {
-	struct Scsi_Host *shost;
+	struct scst_tgt *tgt;
 	struct device *dev;
 
 	spinlock_t lock;
-	struct list_head cmd_queue;
 
 	size_t srp_iu_size;
 	struct srp_queue iu_queue;
@@ -44,14 +35,13 @@ struct srp_target {
 struct iu_entry {
 	struct srp_target *target;
 
-	struct list_head ilist;
 	dma_addr_t remote_token;
 	unsigned long flags;
 
 	struct srp_buf *sbuf;
 };
 
-typedef int (srp_rdma_t)(struct scsi_cmnd *, struct scatterlist *, int,
+typedef int (srp_rdma_t)(struct scst_cmd *, struct scatterlist *, int,
 			 struct srp_direct_buf *, int,
 			 enum dma_data_direction, unsigned int);
 extern int srp_target_alloc(struct srp_target *, struct device *, size_t, size_t);
@@ -60,16 +50,11 @@ extern void srp_target_free(struct srp_target *);
 extern struct iu_entry *srp_iu_get(struct srp_target *);
 extern void srp_iu_put(struct iu_entry *);
 
-extern int srp_cmd_queue(struct Scsi_Host *, struct srp_cmd *, void *, u64, u64);
-extern int srp_transfer_data(struct scsi_cmnd *, struct srp_cmd *,
+extern int srp_data_length(struct srp_cmd *, enum dma_data_direction);
+extern int srp_cmd_queue(struct scst_session *, struct srp_cmd *, void *, int);
+extern int srp_transfer_data(struct scst_cmd *, struct srp_cmd *,
 			     srp_rdma_t, int, int);
 
-
-static inline struct srp_target *host_to_srp_target(struct Scsi_Host *host)
-{
-	return (struct srp_target *) host->hostdata;
-}
-
 static inline int srp_cmd_direction(struct srp_cmd *cmd)
 {
 	return (cmd->buf_fmt >> 4) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
diff --git a/include/scsi/srp.h b/include/scsi/srp.h
index 1ae84db..155d4ae 100644
--- a/include/scsi/srp.h
+++ b/include/scsi/srp.h
@@ -69,6 +69,13 @@ enum {
 	SRP_DATA_DESC_INDIRECT	= 2
 };
 
+enum srp_task_attribute {
+	SRP_SIMPLE_TASK		= 0,
+	SRP_HEAD_TASK		= 1,
+	SRP_ORDERED_TASK	= 2,
+	SRP_ACA_TASK		= 4
+};
+
 enum {
 	SRP_TSK_ABORT_TASK	= 0x01,
 	SRP_TSK_ABORT_TASK_SET	= 0x02,
-- 
1.7.1

