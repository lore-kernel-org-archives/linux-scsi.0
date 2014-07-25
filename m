From: jgross@suse.com
Subject: [PATCH V2 2/4] Introduce xen-scsifront module
Date: Fri, 25 Jul 2014 13:37:31 +0200
Message-ID: <1406288253-13293-3-git-send-email-jgross@suse.com>
References: <1406288253-13293-1-git-send-email-jgross@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbaGYLiN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2014 07:38:13 -0400
In-Reply-To: <1406288253-13293-1-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgross@suse.com, xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, target-devel@vger.kernel.org, konrad.wilk@oracle.com

From: Juergen Gross <jgross@suse.com>

Introduces the XEN pvSCSI frontend. With pvSCSI it is possible for a XEN domU
to issue SCSI commands to a SCSI LUN assigned to that domU. The SCSI commands
are passed to the pvSCSI backend in a driver domain (usually Dom0) which is
owner of the physical device. This allows e.g. to use SCSI tape drives in a
XEN domU.

The code is taken from the pvSCSI implementation in XEN done by Fujitsu based
on Linux kernel 2.6.18.

Changes from the original version are:
- port to upstream kernel
- put all code in just one source file
- move module to appropriate location in kernel tree
- adapt to Linux style guide
- some minor code simplifications
- replace constants with defines
- remove not used defines
- add support for larger SG lists by putting them in a granted page

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/scsi/Kconfig         |    9 +
 drivers/scsi/Makefile        |    1 +
 drivers/scsi/xen-scsifront.c | 1006 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1016 insertions(+)
 create mode 100644 drivers/scsi/xen-scsifront.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index baca589..e860c16 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -611,6 +611,15 @@ config VMWARE_PVSCSI
 	  To compile this driver as a module, choose M here: the
 	  module will be called vmw_pvscsi.
 
+config XEN_SCSI_FRONTEND
+	tristate "XEN SCSI frontend driver"
+	depends on SCSI && XEN
+	help
+	  The XEN SCSI frontend driver allows the kernel to access SCSI Devices
+	  within another guest OS (usually Dom0).
+	  Only needed if the kernel is running in a XEN guest and generic
+	  SCSI access to a device is needed.
+
 config HYPERV_STORAGE
 	tristate "Microsoft Hyper-V virtual storage driver"
 	depends on SCSI && HYPERV
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index e172d4f..a4ee9c5 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -144,6 +144,7 @@ obj-$(CONFIG_SCSI_ESAS2R)	+= esas2r/
 obj-$(CONFIG_SCSI_PMCRAID)	+= pmcraid.o
 obj-$(CONFIG_SCSI_VIRTIO)	+= virtio_scsi.o
 obj-$(CONFIG_VMWARE_PVSCSI)	+= vmw_pvscsi.o
+obj-$(CONFIG_XEN_SCSI_FRONTEND)	+= xen-scsifront.o
 obj-$(CONFIG_HYPERV_STORAGE)	+= hv_storvsc.o
 
 obj-$(CONFIG_ARM)		+= arm/
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
new file mode 100644
index 0000000..469fc54
--- /dev/null
+++ b/drivers/scsi/xen-scsifront.c
@@ -0,0 +1,1006 @@
+/*
+ * Xen SCSI frontend driver
+ *
+ * Copyright (c) 2008, FUJITSU Limited
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+/*
+ * Patched to support >2TB drives
+ * 2010, Samuel Kvasnica, IMS Nanofabrication AG
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/kthread.h>
+#include <linux/wait.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/blkdev.h>
+#include <linux/pfn.h>
+#include <linux/slab.h>
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+
+#include <xen/xen.h>
+#include <xen/xenbus.h>
+#include <xen/grant_table.h>
+#include <xen/events.h>
+#include <xen/page.h>
+
+#include <xen/interface/grant_table.h>
+#include <xen/interface/io/vscsiif.h>
+#include <xen/interface/io/protocols.h>
+
+#include <asm/xen/hypervisor.h>
+
+
+#define GRANT_INVALID_REF	0
+
+#define VSCSIFRONT_OP_ADD_LUN	1
+#define VSCSIFRONT_OP_DEL_LUN	2
+
+#define DEFAULT_TASK_COMM_LEN	TASK_COMM_LEN
+
+/* tuning point*/
+#define VSCSIIF_DEFAULT_CMD_PER_LUN 10
+#define VSCSIIF_MAX_TARGET          64
+#define VSCSIIF_MAX_LUN             255
+
+#define VSCSIIF_RING_SIZE	__CONST_RING_SIZE(vscsiif, PAGE_SIZE)
+#define VSCSIIF_MAX_REQS	VSCSIIF_RING_SIZE
+
+#define vscsiif_grants_sg(_sg)	(PFN_UP((_sg) *		\
+				sizeof(struct scsiif_request_segment)))
+
+struct vscsifrnt_shadow {
+	uint16_t next_free;
+
+	/* command between backend and frontend */
+	unsigned char act;
+
+	/* Number of pieces of scatter-gather */
+	unsigned int nr_grants;
+	struct scsiif_request_segment *sg;
+
+	/* do reset or abort function */
+	wait_queue_head_t wq_reset;	/* reset work queue           */
+	int wait_reset;			/* reset work queue condition */
+	int32_t rslt_reset;		/* reset response status      */
+					/* (SUCESS or FAILED)         */
+
+	/* requested struct scsi_cmnd is stored from kernel */
+	struct scsi_cmnd *sc;
+	int gref[vscsiif_grants_sg(SG_ALL) + SG_ALL];
+};
+
+struct vscsifrnt_info {
+	struct xenbus_device *dev;
+
+	struct Scsi_Host *host;
+
+	spinlock_t shadow_lock;
+	unsigned int evtchn;
+	unsigned int irq;
+
+	grant_ref_t ring_ref;
+	struct vscsiif_front_ring ring;
+	struct vscsiif_response	ring_res;
+
+	struct vscsifrnt_shadow shadow[VSCSIIF_MAX_REQS];
+	uint32_t shadow_free;
+
+	struct task_struct *kthread;
+	wait_queue_head_t wq;
+	wait_queue_head_t wq_sync;
+	unsigned int waiting_resp:1;
+	unsigned int waiting_sync:1;
+};
+
+#define DPRINTK(_f, _a...)				\
+	pr_debug("(file=%s, line=%d) " _f, __FILE__ , __LINE__ , ## _a)
+
+#define PREFIX(lvl) KERN_##lvl "scsifront: "
+
+static int get_id_from_freelist(struct vscsifrnt_info *info)
+{
+	unsigned long flags;
+	uint32_t free;
+
+	spin_lock_irqsave(&info->shadow_lock, flags);
+
+	free = info->shadow_free;
+	BUG_ON(free >= VSCSIIF_MAX_REQS);
+	info->shadow_free = info->shadow[free].next_free;
+	info->shadow[free].next_free = VSCSIIF_MAX_REQS;
+	info->shadow[free].wait_reset = 0;
+
+	spin_unlock_irqrestore(&info->shadow_lock, flags);
+
+	return free;
+}
+
+static void _add_id_to_freelist(struct vscsifrnt_info *info, uint32_t id)
+{
+	info->shadow[id].next_free = info->shadow_free;
+	info->shadow[id].sc = NULL;
+	info->shadow_free = id;
+}
+
+static void add_id_to_freelist(struct vscsifrnt_info *info, uint32_t id)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->shadow_lock, flags);
+	_add_id_to_freelist(info, id);
+	spin_unlock_irqrestore(&info->shadow_lock, flags);
+}
+
+static struct vscsiif_request *scsifront_pre_req(struct vscsifrnt_info *info)
+{
+	struct vscsiif_front_ring *ring = &(info->ring);
+	struct vscsiif_request *ring_req;
+	uint32_t id;
+
+	ring_req = RING_GET_REQUEST(&(info->ring), ring->req_prod_pvt);
+
+	ring->req_prod_pvt++;
+
+	id = get_id_from_freelist(info);	/* use id by response */
+	ring_req->rqid = (uint16_t)id;
+
+	return ring_req;
+}
+
+static void scsifront_notify_work(struct vscsifrnt_info *info)
+{
+	info->waiting_resp = 1;
+	wake_up(&info->wq);
+}
+
+static void scsifront_do_request(struct vscsifrnt_info *info)
+{
+	struct vscsiif_front_ring *ring = &(info->ring);
+	int notify;
+
+	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(ring, notify);
+	if (notify)
+		notify_remote_via_irq(info->irq);
+}
+
+static irqreturn_t scsifront_intr(int irq, void *dev_id)
+{
+	scsifront_notify_work((struct vscsifrnt_info *)dev_id);
+	return IRQ_HANDLED;
+}
+
+static void scsifront_gnttab_done(struct vscsifrnt_info *info, uint32_t id)
+{
+	struct vscsifrnt_shadow *s = &info->shadow[id];
+	int i;
+
+	if (s->sc->sc_data_direction == DMA_NONE)
+		return;
+
+	for (i = 0; i < s->nr_grants; i++) {
+		if (unlikely(gnttab_query_foreign_access(s->gref[i]) != 0)) {
+			shost_printk(PREFIX(ALERT), info->host,
+				     "grant still in use by backend\n");
+			BUG();
+		}
+		gnttab_end_foreign_access(s->gref[i], 0, 0UL);
+	}
+
+	kfree(s->sg);
+	s->sg = NULL;
+}
+
+static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
+				   struct vscsiif_response *ring_res)
+{
+	struct scsi_cmnd *sc;
+	uint32_t id;
+	uint8_t sense_len;
+
+	id = ring_res->rqid;
+	sc = info->shadow[id].sc;
+
+	BUG_ON(sc == NULL);
+
+	scsifront_gnttab_done(info, id);
+	add_id_to_freelist(info, id);
+
+	sc->result = ring_res->rslt;
+	scsi_set_resid(sc, ring_res->residual_len);
+
+	sense_len = min_t(uint8_t, VSCSIIF_SENSE_BUFFERSIZE,
+			  ring_res->sense_len);
+
+	if (sense_len)
+		memcpy(sc->sense_buffer, ring_res->sense_buffer, sense_len);
+
+	sc->scsi_done(sc);
+}
+
+static void scsifront_sync_cmd_done(struct vscsifrnt_info *info,
+				    struct vscsiif_response *ring_res)
+{
+	uint16_t id = ring_res->rqid;
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->shadow_lock, flags);
+	info->shadow[id].wait_reset = 1;
+	switch (info->shadow[id].rslt_reset) {
+	case 0:
+		info->shadow[id].rslt_reset = ring_res->rslt;
+		break;
+	case -1:
+		_add_id_to_freelist(info, id);
+		break;
+	default:
+		shost_printk(PREFIX(ERR), info->host,
+			     "bad reset state %d, possibly leaking %u\n",
+			     info->shadow[id].rslt_reset, id);
+		break;
+	}
+	spin_unlock_irqrestore(&info->shadow_lock, flags);
+
+	wake_up(&(info->shadow[id].wq_reset));
+}
+
+static int scsifront_cmd_done(struct vscsifrnt_info *info)
+{
+	struct vscsiif_response *ring_res;
+	RING_IDX i, rp;
+	int more_to_do = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(info->host->host_lock, flags);
+
+	rp = info->ring.sring->rsp_prod;
+	rmb();	/* ordering required respective to dom0 */
+	for (i = info->ring.rsp_cons; i != rp; i++) {
+
+		ring_res = RING_GET_RESPONSE(&info->ring, i);
+
+		if (info->shadow[ring_res->rqid].act == VSCSIIF_ACT_SCSI_CDB)
+			scsifront_cdb_cmd_done(info, ring_res);
+		else
+			scsifront_sync_cmd_done(info, ring_res);
+	}
+
+	info->ring.rsp_cons = i;
+
+	if (i != info->ring.req_prod_pvt)
+		RING_FINAL_CHECK_FOR_RESPONSES(&info->ring, more_to_do);
+	else
+		info->ring.sring->rsp_event = i + 1;
+
+	info->waiting_sync = 0;
+
+	spin_unlock_irqrestore(info->host->host_lock, flags);
+
+	wake_up(&info->wq_sync);
+
+	/* Yield point for this unbounded loop. */
+	cond_resched();
+
+	return more_to_do;
+}
+
+static int scsifront_schedule(void *data)
+{
+	struct vscsifrnt_info *info = (struct vscsifrnt_info *)data;
+
+	while (!kthread_should_stop()) {
+		wait_event_interruptible(info->wq,
+			info->waiting_resp || kthread_should_stop());
+
+		info->waiting_resp = 0;
+		smp_mb();	/* other thread uses waiting_resp */
+
+		if (scsifront_cmd_done(info))
+			info->waiting_resp = 1;
+	}
+
+	return 0;
+}
+
+static int map_data_for_request(struct vscsifrnt_info *info,
+				struct scsi_cmnd *sc,
+				struct vscsiif_request *ring_req,
+				uint32_t id)
+{
+	grant_ref_t gref_head;
+	struct page *page;
+	int err, ref, ref_cnt = 0;
+	int write = (sc->sc_data_direction == DMA_TO_DEVICE);
+	unsigned int i, off, len, bytes;
+	unsigned int data_len = scsi_bufflen(sc);
+	unsigned int data_grants = 0, seg_grants = 0;
+	struct scatterlist *sg;
+	unsigned long mfn;
+	struct scsiif_request_segment *seg;
+
+	ring_req->nr_segments = 0;
+	if (sc->sc_data_direction == DMA_NONE || !data_len)
+		return 0;
+
+	scsi_for_each_sg(sc, sg, scsi_sg_count(sc), i)
+		data_grants += PFN_UP(sg->offset + sg->length);
+
+	if (data_grants > VSCSIIF_SG_TABLESIZE) {
+		if (data_grants > info->host->sg_tablesize) {
+			shost_printk(PREFIX(ERR), info->host,
+			     "Unable to map request_buffer for command!\n");
+			return -E2BIG;
+		}
+		seg_grants = vscsiif_grants_sg(data_grants);
+		info->shadow[id].sg = kcalloc(data_grants,
+			sizeof(struct scsiif_request_segment), GFP_NOIO);
+		if (!info->shadow[id].sg)
+			return -ENOMEM;
+	}
+	seg = info->shadow[id].sg ? : ring_req->seg;
+
+	err = gnttab_alloc_grant_references(seg_grants + data_grants,
+					    &gref_head);
+	if (err) {
+		kfree(info->shadow[id].sg);
+		info->shadow[id].sg = NULL;
+		shost_printk(PREFIX(ERR), info->host,
+			     "gnttab_alloc_grant_references() error\n");
+		return -ENOMEM;
+	}
+
+	if (seg_grants) {
+		page = virt_to_page(seg);
+		off = (unsigned long)seg & ~PAGE_MASK;
+		len = sizeof(struct scsiif_request_segment) * data_grants;
+		while (len > 0) {
+			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
+
+			ref = gnttab_claim_grant_reference(&gref_head);
+			BUG_ON(ref == -ENOSPC);
+
+			mfn = pfn_to_mfn(page_to_pfn(page));
+			gnttab_grant_foreign_access_ref(ref,
+				info->dev->otherend_id, mfn, 1);
+			info->shadow[id].gref[ref_cnt] = ref;
+			ring_req->seg[ref_cnt].gref   = ref;
+			ring_req->seg[ref_cnt].offset = (uint16_t)off;
+			ring_req->seg[ref_cnt].length = (uint16_t)bytes;
+
+			page++;
+			len -= bytes;
+			off = 0;
+			ref_cnt++;
+		}
+		BUG_ON(seg_grants < ref_cnt);
+		seg_grants = ref_cnt;
+	}
+
+	scsi_for_each_sg(sc, sg, scsi_sg_count(sc), i) {
+		page = sg_page(sg);
+		off = sg->offset;
+		len = sg->length;
+
+		while (len > 0 && data_len > 0) {
+			/*
+			 * sg sends a scatterlist that is larger than
+			 * the data_len it wants transferred for certain
+			 * IO sizes
+			 */
+			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
+			bytes = min(bytes, data_len);
+
+			ref = gnttab_claim_grant_reference(&gref_head);
+			BUG_ON(ref == -ENOSPC);
+
+			mfn = pfn_to_mfn(page_to_pfn(page));
+			gnttab_grant_foreign_access_ref(ref,
+				info->dev->otherend_id, mfn, write);
+
+			info->shadow[id].gref[ref_cnt] = ref;
+			seg->gref   = ref;
+			seg->offset = (uint16_t)off;
+			seg->length = (uint16_t)bytes;
+
+			page++;
+			seg++;
+			len -= bytes;
+			data_len -= bytes;
+			off = 0;
+			ref_cnt++;
+		}
+	}
+
+	if (seg_grants)
+		ring_req->nr_segments = VSCSIIF_SG_GRANT | seg_grants;
+	else
+		ring_req->nr_segments = (uint8_t)ref_cnt;
+	info->shadow[id].nr_grants = ref_cnt;
+
+	return 0;
+}
+
+static struct vscsiif_request *scsifront_command2ring(
+			struct vscsifrnt_info *info, struct scsi_cmnd *sc)
+{
+	struct vscsiif_request *ring_req;
+
+	ring_req = scsifront_pre_req(info);
+
+	ring_req->id      = sc->device->id;
+	ring_req->lun     = sc->device->lun;
+	ring_req->channel = sc->device->channel;
+	ring_req->cmd_len = sc->cmd_len;
+
+	BUG_ON(sc->cmd_len > VSCSIIF_MAX_COMMAND_SIZE);
+
+	if (sc->cmd_len)
+		memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
+	else
+		memset(ring_req->cmnd, 0, VSCSIIF_MAX_COMMAND_SIZE);
+
+	ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
+	ring_req->timeout_per_command = sc->request->timeout / HZ;
+
+	return ring_req;
+}
+
+static int scsifront_queuecommand(struct Scsi_Host *shost,
+				  struct scsi_cmnd *sc)
+{
+	struct vscsifrnt_info *info = shost_priv(shost);
+	struct vscsiif_request *ring_req;
+	unsigned long flags;
+	int err;
+	uint16_t rqid;
+
+/* debug printk to identify more missing scsi commands
+	shost_printk(KERN_INFO "scsicmd: ", sc->device->host,
+		     "len=%u %#x,%#x,%#x,%#x,%#x,%#x,%#x,%#x,%#x,%#x\n",
+		     sc->cmd_len, sc->cmnd[0], sc->cmnd[1],
+		     sc->cmnd[2], sc->cmnd[3], sc->cmnd[4], sc->cmnd[5],
+		     sc->cmnd[6], sc->cmnd[7], sc->cmnd[8], sc->cmnd[9]);
+*/
+	spin_lock_irqsave(shost->host_lock, flags);
+	scsi_cmd_get_serial(shost, sc);
+	if (RING_FULL(&info->ring)) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	sc->result    = 0;
+
+	ring_req          = scsifront_command2ring(info, sc);
+	rqid              = ring_req->rqid;
+	ring_req->act     = VSCSIIF_ACT_SCSI_CDB;
+
+	info->shadow[rqid].sc  = sc;
+	info->shadow[rqid].act = VSCSIIF_ACT_SCSI_CDB;
+
+	err = map_data_for_request(info, sc, ring_req, rqid);
+	if (err < 0) {
+		add_id_to_freelist(info, rqid);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		if (err == -ENOMEM)
+			return SCSI_MLQUEUE_HOST_BUSY;
+		sc->result = DID_ERROR << 16;
+		sc->scsi_done(sc);
+		return 0;
+	}
+
+	scsifront_do_request(info);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	return 0;
+}
+
+static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
+{
+	struct Scsi_Host *host = sc->device->host;
+	struct vscsifrnt_info *info = shost_priv(host);
+	struct vscsiif_request *ring_req;
+	uint16_t rqid;
+	int err = 0;
+
+	for (;;) {
+		spin_lock_irq(host->host_lock);
+		if (!RING_FULL(&info->ring))
+			break;
+		if (err) {
+			spin_unlock_irq(host->host_lock);
+			return FAILED;
+		}
+		info->waiting_sync = 1;
+		spin_unlock_irq(host->host_lock);
+		err = wait_event_interruptible(info->wq_sync,
+					       !info->waiting_sync);
+		spin_lock_irq(host->host_lock);
+	}
+
+	ring_req      = scsifront_command2ring(info, sc);
+	rqid          = ring_req->rqid;
+	ring_req->act = act;
+
+	info->shadow[rqid].act = act;
+	info->shadow[rqid].rslt_reset = 0;
+
+	ring_req->nr_segments         = 0;
+
+	scsifront_do_request(info);
+
+	spin_unlock_irq(host->host_lock);
+	err = wait_event_interruptible(info->shadow[rqid].wq_reset,
+				       info->shadow[rqid].wait_reset);
+	spin_lock_irq(host->host_lock);
+
+	if (!err) {
+		err = info->shadow[rqid].rslt_reset;
+		add_id_to_freelist(info, rqid);
+	} else {
+		spin_lock(&info->shadow_lock);
+		info->shadow[rqid].rslt_reset = -1;
+		spin_unlock(&info->shadow_lock);
+		err = FAILED;
+	}
+
+	spin_unlock_irq(host->host_lock);
+	return err;
+}
+
+static int scsifront_eh_abort_handler(struct scsi_cmnd *sc)
+{
+	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_ABORT);
+}
+
+static int scsifront_dev_reset_handler(struct scsi_cmnd *sc)
+{
+	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_RESET);
+}
+
+static struct scsi_host_template scsifront_sht = {
+	.module			= THIS_MODULE,
+	.name			= "Xen SCSI frontend driver",
+	.queuecommand		= scsifront_queuecommand,
+	.eh_abort_handler	= scsifront_eh_abort_handler,
+	.eh_device_reset_handler = scsifront_dev_reset_handler,
+	.cmd_per_lun		= VSCSIIF_DEFAULT_CMD_PER_LUN,
+	.can_queue		= VSCSIIF_MAX_REQS,
+	.this_id		= -1,
+	.sg_tablesize		= VSCSIIF_SG_TABLESIZE,
+	.use_clustering		= DISABLE_CLUSTERING,
+	.proc_name		= "scsifront",
+};
+
+static void scsifront_free(struct vscsifrnt_info *info)
+{
+	struct Scsi_Host *host = info->host;
+
+	if (host->shost_state != SHOST_DEL)
+		scsi_remove_host(info->host);
+
+	if (info->ring_ref != GRANT_INVALID_REF) {
+		gnttab_end_foreign_access(info->ring_ref, 0,
+					  (unsigned long)info->ring.sring);
+		info->ring_ref = GRANT_INVALID_REF;
+		info->ring.sring = NULL;
+	}
+
+	if (info->irq)
+		unbind_from_irqhandler(info->irq, info);
+	info->irq = 0;
+	info->evtchn = 0;
+
+	scsi_host_put(info->host);
+}
+
+static int scsifront_alloc_ring(struct vscsifrnt_info *info)
+{
+	struct xenbus_device *dev = info->dev;
+	struct vscsiif_sring *sring;
+	int err = -ENOMEM;
+
+	info->ring_ref = GRANT_INVALID_REF;
+
+	/***** Frontend to Backend ring start *****/
+	sring = (struct vscsiif_sring *) __get_free_page(GFP_KERNEL);
+	if (!sring) {
+		xenbus_dev_fatal(dev, err,
+			"fail to allocate shared ring (Front to Back)");
+		return err;
+	}
+	SHARED_RING_INIT(sring);
+	FRONT_RING_INIT(&info->ring, sring, PAGE_SIZE);
+
+	err = xenbus_grant_ring(dev, virt_to_mfn(sring));
+	if (err < 0) {
+		free_page((unsigned long) sring);
+		info->ring.sring = NULL;
+		xenbus_dev_fatal(dev, err,
+			"fail to grant shared ring (Front to Back)");
+		goto free_sring;
+	}
+	info->ring_ref = err;
+
+	err = xenbus_alloc_evtchn(dev, &info->evtchn);
+	if (err)
+		goto free_sring;
+
+	err = bind_evtchn_to_irqhandler(info->evtchn, scsifront_intr,
+					0, "scsifront", info);
+
+	if (err <= 0) {
+		xenbus_dev_fatal(dev, err, "bind_evtchn_to_irqhandler");
+		goto free_sring;
+	}
+	info->irq = err;
+
+	return 0;
+
+/* free resource */
+free_sring:
+	scsifront_free(info);
+
+	return err;
+}
+
+static int scsifront_init_ring(struct vscsifrnt_info *info)
+{
+	struct xenbus_device *dev = info->dev;
+	struct xenbus_transaction xbt;
+	int err;
+
+	DPRINTK("%s\n", __func__);
+
+	err = scsifront_alloc_ring(info);
+	if (err)
+		return err;
+	DPRINTK("%u %u\n", info->ring_ref, info->evtchn);
+
+again:
+	err = xenbus_transaction_start(&xbt);
+	if (err)
+		xenbus_dev_fatal(dev, err, "starting transaction");
+
+	err = xenbus_printf(xbt, dev->nodename, "ring-ref", "%u",
+			    info->ring_ref);
+	if (err) {
+		xenbus_dev_fatal(dev, err, "%s", "writing ring-ref");
+		goto fail;
+	}
+
+	err = xenbus_printf(xbt, dev->nodename, "event-channel", "%u",
+			    info->evtchn);
+
+	if (err) {
+		xenbus_dev_fatal(dev, err, "%s", "writing event-channel");
+		goto fail;
+	}
+
+	err = xenbus_transaction_end(xbt, 0);
+	if (err) {
+		if (err == -EAGAIN)
+			goto again;
+		xenbus_dev_fatal(dev, err, "completing transaction");
+		goto free_sring;
+	}
+
+	return 0;
+
+fail:
+	xenbus_transaction_end(xbt, 1);
+free_sring:
+	/* free resource */
+	scsifront_free(info);
+
+	return err;
+}
+
+
+static int scsifront_probe(struct xenbus_device *dev,
+			   const struct xenbus_device_id *id)
+{
+	struct vscsifrnt_info *info;
+	struct Scsi_Host *host;
+	int i, err = -ENOMEM;
+	char name[DEFAULT_TASK_COMM_LEN];
+
+	host = scsi_host_alloc(&scsifront_sht, sizeof(*info));
+	if (!host) {
+		xenbus_dev_fatal(dev, err, "fail to allocate scsi host");
+		return err;
+	}
+	info = (struct vscsifrnt_info *) host->hostdata;
+	info->host = host;
+
+	dev_set_drvdata(&dev->dev, info);
+	info->dev  = dev;
+
+	for (i = 0; i < VSCSIIF_MAX_REQS; i++) {
+		info->shadow[i].next_free = i + 1;
+		init_waitqueue_head(&(info->shadow[i].wq_reset));
+		info->shadow[i].wait_reset = 0;
+	}
+	info->shadow_free = 0;
+
+	err = scsifront_init_ring(info);
+	if (err) {
+		scsi_host_put(host);
+		return err;
+	}
+
+	init_waitqueue_head(&info->wq);
+	init_waitqueue_head(&info->wq_sync);
+	spin_lock_init(&info->shadow_lock);
+
+	snprintf(name, DEFAULT_TASK_COMM_LEN, "vscsiif.%d",
+		 info->host->host_no);
+
+	info->kthread = kthread_run(scsifront_schedule, info, name);
+	if (IS_ERR(info->kthread)) {
+		err = PTR_ERR(info->kthread);
+		info->kthread = NULL;
+		dev_err(&dev->dev, "kthread start err %d\n", err);
+		goto free_sring;
+	}
+
+	host->max_id      = VSCSIIF_MAX_TARGET;
+	host->max_channel = 0;
+	host->max_lun     = VSCSIIF_MAX_LUN;
+	host->max_sectors = (host->sg_tablesize - 1) * PAGE_SIZE / 512;
+	host->max_cmd_len = VSCSIIF_MAX_COMMAND_SIZE;
+
+	err = scsi_add_host(host, &dev->dev);
+	if (err) {
+		dev_err(&dev->dev, "fail to add scsi host %d\n", err);
+		goto free_sring;
+	}
+
+	xenbus_switch_state(dev, XenbusStateInitialised);
+
+	return 0;
+
+free_sring:
+	/* free resource */
+	scsifront_free(info);
+	return err;
+}
+
+static int scsifront_remove(struct xenbus_device *dev)
+{
+	struct vscsifrnt_info *info = dev_get_drvdata(&dev->dev);
+
+	DPRINTK("%s: %s removed\n", __func__, dev->nodename);
+
+	if (info->kthread) {
+		kthread_stop(info->kthread);
+		info->kthread = NULL;
+	}
+
+	scsifront_free(info);
+
+	return 0;
+}
+
+static int scsifront_disconnect(struct vscsifrnt_info *info)
+{
+	struct xenbus_device *dev = info->dev;
+	struct Scsi_Host *host = info->host;
+
+	DPRINTK("%s: %s disconnect\n", __func__, dev->nodename);
+
+	/*
+	 * When this function is executed,  all devices of
+	 * Frontend have been deleted.
+	 * Therefore, it need not block I/O before remove_host.
+	 */
+
+	scsi_remove_host(host);
+	xenbus_frontend_closed(dev);
+
+	return 0;
+}
+
+static void scsifront_do_lun_hotplug(struct vscsifrnt_info *info, int op)
+{
+	struct xenbus_device *dev = info->dev;
+	int i, err = 0;
+	char str[64], state_str[64];
+	char **dir;
+	unsigned int dir_n = 0;
+	unsigned int device_state;
+	unsigned int hst, chn, tgt, lun;
+	struct scsi_device *sdev;
+
+	dir = xenbus_directory(XBT_NIL, dev->otherend, "vscsi-devs", &dir_n);
+	if (IS_ERR(dir))
+		return;
+
+	for (i = 0; i < dir_n; i++) {
+		/* read status */
+		snprintf(str, sizeof(str), "vscsi-devs/%s/state", dir[i]);
+		err = xenbus_scanf(XBT_NIL, dev->otherend, str, "%u",
+				   &device_state);
+		if (XENBUS_EXIST_ERR(err))
+			continue;
+
+		/* virtual SCSI device */
+		snprintf(str, sizeof(str), "vscsi-devs/%s/v-dev", dir[i]);
+		err = xenbus_scanf(XBT_NIL, dev->otherend, str,
+				   "%u:%u:%u:%u", &hst, &chn, &tgt, &lun);
+		if (XENBUS_EXIST_ERR(err))
+			continue;
+
+		/* front device state path */
+		snprintf(state_str, sizeof(state_str), "vscsi-devs/%s/state",
+			 dir[i]);
+
+		switch (op) {
+		case VSCSIFRONT_OP_ADD_LUN:
+			if (device_state == XenbusStateInitialised) {
+				sdev = scsi_device_lookup(info->host, chn, tgt,
+							  lun);
+				if (sdev) {
+					dev_err(&dev->dev,
+						"Device already in use.\n");
+					scsi_device_put(sdev);
+					xenbus_printf(XBT_NIL, dev->nodename,
+						      state_str, "%d",
+						      XenbusStateClosed);
+				} else {
+					scsi_add_device(info->host, chn, tgt,
+							lun);
+					xenbus_printf(XBT_NIL, dev->nodename,
+						      state_str, "%d",
+						      XenbusStateConnected);
+				}
+			}
+			break;
+		case VSCSIFRONT_OP_DEL_LUN:
+			if (device_state == XenbusStateClosing) {
+				sdev = scsi_device_lookup(info->host, chn, tgt,
+							  lun);
+				if (sdev) {
+					scsi_remove_device(sdev);
+					scsi_device_put(sdev);
+					xenbus_printf(XBT_NIL, dev->nodename,
+						      state_str, "%d",
+						      XenbusStateClosed);
+				}
+			}
+			break;
+		default:
+			break;
+		}
+	}
+
+	kfree(dir);
+}
+
+static void scsifront_read_backend_params(struct xenbus_device *dev,
+					  struct vscsifrnt_info *info)
+{
+	unsigned int sg_grant;
+	int ret;
+	struct Scsi_Host *host = info->host;
+
+	ret = xenbus_scanf(XBT_NIL, dev->otherend, "feature-sg-grant", "%u",
+			   &sg_grant);
+	if (ret == 1 && sg_grant) {
+		sg_grant = min_t(unsigned int, sg_grant, SG_ALL);
+		host->sg_tablesize = min_t(unsigned int, sg_grant,
+			VSCSIIF_SG_TABLESIZE * PAGE_SIZE /
+			sizeof(struct scsiif_request_segment));
+		dev_info(&dev->dev, "using up to %d SG entries\n",
+			 host->sg_tablesize);
+		host->max_sectors = (host->sg_tablesize - 1) * PAGE_SIZE / 512;
+	}
+}
+
+static void scsifront_backend_changed(struct xenbus_device *dev,
+				      enum xenbus_state backend_state)
+{
+	struct vscsifrnt_info *info = dev_get_drvdata(&dev->dev);
+
+	DPRINTK("%p %u %u\n", dev, dev->state, backend_state);
+
+	switch (backend_state) {
+	case XenbusStateUnknown:
+	case XenbusStateInitialising:
+	case XenbusStateInitWait:
+	case XenbusStateInitialised:
+		break;
+
+	case XenbusStateConnected:
+		scsifront_read_backend_params(dev, info);
+		if (xenbus_read_driver_state(dev->nodename) ==
+			XenbusStateInitialised) {
+			scsifront_do_lun_hotplug(info, VSCSIFRONT_OP_ADD_LUN);
+		}
+
+		if (dev->state != XenbusStateConnected)
+			xenbus_switch_state(dev, XenbusStateConnected);
+		break;
+
+	case XenbusStateClosed:
+		if (dev->state == XenbusStateClosed)
+			break;
+		/* Missed the backend's Closing state -- fallthrough */
+	case XenbusStateClosing:
+		scsifront_disconnect(info);
+		break;
+
+	case XenbusStateReconfiguring:
+		scsifront_do_lun_hotplug(info, VSCSIFRONT_OP_DEL_LUN);
+		xenbus_switch_state(dev, XenbusStateReconfiguring);
+		break;
+
+	case XenbusStateReconfigured:
+		scsifront_do_lun_hotplug(info, VSCSIFRONT_OP_ADD_LUN);
+		xenbus_switch_state(dev, XenbusStateConnected);
+		break;
+	}
+}
+
+static const struct xenbus_device_id scsifront_ids[] = {
+	{ "vscsi" },
+	{ "" }
+};
+
+static DEFINE_XENBUS_DRIVER(scsifront, ,
+	.probe			= scsifront_probe,
+	.remove			= scsifront_remove,
+/*	.resume			= scsifront_resume, */
+	.otherend_changed	= scsifront_backend_changed,
+);
+
+static int __init scsifront_init(void)
+{
+	if (!xen_domain())
+		return -ENODEV;
+
+	return xenbus_register_frontend(&scsifront_driver);
+}
+module_init(scsifront_init);
+
+static void __exit scsifront_exit(void)
+{
+	xenbus_unregister_driver(&scsifront_driver);
+}
+module_exit(scsifront_exit);
+
+MODULE_DESCRIPTION("Xen SCSI frontend driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("xen:vscsi");
-- 
1.8.4.5

