From: jgross@suse.com
Subject: [PATCH V4 1/4] Introduce xen-scsifront module
Date: Fri,  8 Aug 2014 09:43:57 +0200
Message-ID: <1407483840-31436-2-git-send-email-jgross@suse.com>
References: <1407483840-31436-1-git-send-email-jgross@suse.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1407483840-31436-1-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org, david.vrabel@citrix.com, JBeulich@suse.com
Cc: Juergen Gross <jgross@suse.com>
List-Id: linux-scsi@vger.kernel.org

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

Xen related parts
Acked-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/scsi/Kconfig         |    9 +
 drivers/scsi/Makefile        |    1 +
 drivers/scsi/xen-scsifront.c | 1011 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1021 insertions(+)
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
index 0000000..7c60c68
--- /dev/null
+++ b/drivers/scsi/xen-scsifront.c
@@ -0,0 +1,1011 @@
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
+#define DEBUG
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
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
+	/* command between backend and frontend */
+	unsigned char act;
+	uint16_t rqid;
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
+	int host_active;
+
+	spinlock_t shadow_lock;
+	unsigned int evtchn;
+	unsigned int irq;
+
+	grant_ref_t ring_ref;
+	struct vscsiif_front_ring ring;
+	struct vscsiif_response	ring_res;
+
+	unsigned long shadow_free;
+	struct vscsifrnt_shadow *shadow[VSCSIIF_MAX_REQS];
+
+	wait_queue_head_t wq_sync;
+	unsigned int waiting_sync:1;
+};
+
+#define DPRINTK(_f, _a...)				\
+	pr_debug("(file=%s, line=%d) " _f, __FILE__ , __LINE__ , ## _a)
+
+#define PREFIX(lvl) KERN_##lvl "scsifront: "
+
+static void scsifront_wake_up(struct vscsifrnt_info *info)
+{
+	info->waiting_sync = 0;
+	wake_up(&info->wq_sync);
+}
+
+static int scsifront_get_rqid(struct vscsifrnt_info *info)
+{
+	unsigned long flags;
+	int free;
+
+	spin_lock_irqsave(&info->shadow_lock, flags);
+
+	free = find_first_bit(&info->shadow_free, VSCSIIF_MAX_REQS);
+	info->shadow_free &= ~(1UL << free);
+
+	spin_unlock_irqrestore(&info->shadow_lock, flags);
+
+	return free;
+}
+
+static int _scsifront_put_rqid(struct vscsifrnt_info *info, uint32_t id)
+{
+	info->shadow_free |= 1UL << id;
+	info->shadow[id] = NULL;
+
+	return (info->shadow_free == 1UL << id || info->waiting_sync);
+}
+
+static void scsifront_put_rqid(struct vscsifrnt_info *info, uint32_t id)
+{
+	unsigned long flags;
+	int was_empty;
+
+	spin_lock_irqsave(&info->shadow_lock, flags);
+	was_empty = _scsifront_put_rqid(info, id);
+	spin_unlock_irqrestore(&info->shadow_lock, flags);
+
+	if (was_empty)
+		scsifront_wake_up(info);
+}
+
+static struct vscsiif_request *scsifront_pre_req(struct vscsifrnt_info *info)
+{
+	struct vscsiif_front_ring *ring = &(info->ring);
+	struct vscsiif_request *ring_req;
+	uint32_t id;
+
+	id = scsifront_get_rqid(info);	/* use id by response */
+	if (id >= VSCSIIF_MAX_REQS)
+		return NULL;
+
+	ring_req = RING_GET_REQUEST(&(info->ring), ring->req_prod_pvt);
+
+	ring->req_prod_pvt++;
+
+	ring_req->rqid = (uint16_t)id;
+
+	return ring_req;
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
+static void scsifront_gnttab_done(struct vscsifrnt_info *info, uint32_t id)
+{
+	struct vscsifrnt_shadow *s = info->shadow[id];
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
+	sc = info->shadow[id]->sc;
+
+	BUG_ON(sc == NULL);
+
+	scsifront_gnttab_done(info, id);
+	scsifront_put_rqid(info, id);
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
+	struct vscsifrnt_shadow *shadow = info->shadow[id];
+	int was_empty;
+
+	spin_lock_irqsave(&info->shadow_lock, flags);
+	shadow->wait_reset = 1;
+	switch (shadow->rslt_reset) {
+	case 0:
+		shadow->rslt_reset = ring_res->rslt;
+		break;
+	case -1:
+		was_empty = _scsifront_put_rqid(info, id);
+		spin_unlock_irqrestore(&info->shadow_lock, flags);
+		kfree(shadow);
+		if (was_empty)
+			scsifront_wake_up(info);
+		return;
+	default:
+		shost_printk(PREFIX(ERR), info->host,
+			     "bad reset state %d, possibly leaking %u\n",
+			     shadow->rslt_reset, id);
+		break;
+	}
+	spin_unlock_irqrestore(&info->shadow_lock, flags);
+
+	wake_up(&shadow->wq_reset);
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
+		if (info->shadow[ring_res->rqid]->act == VSCSIIF_ACT_SCSI_CDB)
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
+	return more_to_do;
+}
+
+static irqreturn_t scsifront_irq_fn(int irq, void *dev_id)
+{
+	struct vscsifrnt_info *info = dev_id;
+
+	while (scsifront_cmd_done(info))
+		/* Yield point for this unbounded loop. */
+		cond_resched();
+
+	return IRQ_HANDLED;
+}
+
+static int map_data_for_request(struct vscsifrnt_info *info,
+				struct scsi_cmnd *sc,
+				struct vscsiif_request *ring_req,
+				struct vscsifrnt_shadow *shadow)
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
+		shadow->sg = kcalloc(data_grants,
+			sizeof(struct scsiif_request_segment), GFP_NOIO);
+		if (!shadow->sg)
+			return -ENOMEM;
+	}
+	seg = shadow->sg ? : ring_req->seg;
+
+	err = gnttab_alloc_grant_references(seg_grants + data_grants,
+					    &gref_head);
+	if (err) {
+		kfree(shadow->sg);
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
+			shadow->gref[ref_cnt] = ref;
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
+			shadow->gref[ref_cnt] = ref;
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
+	shadow->nr_grants = ref_cnt;
+
+	return 0;
+}
+
+static struct vscsiif_request *scsifront_command2ring(
+		struct vscsifrnt_info *info, struct scsi_cmnd *sc,
+		struct vscsifrnt_shadow *shadow)
+{
+	struct vscsiif_request *ring_req;
+
+	memset(shadow, 0, sizeof(*shadow));
+
+	ring_req = scsifront_pre_req(info);
+	if (!ring_req)
+		return NULL;
+
+	info->shadow[ring_req->rqid] = shadow;
+	shadow->rqid = ring_req->rqid;
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
+	struct vscsifrnt_shadow *shadow = scsi_cmd_priv(sc);
+	unsigned long flags;
+	int err;
+	uint16_t rqid;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (RING_FULL(&info->ring))
+		goto busy;
+
+	ring_req = scsifront_command2ring(info, sc, shadow);
+	if (!ring_req)
+		goto busy;
+
+	sc->result    = 0;
+
+	rqid              = ring_req->rqid;
+	ring_req->act     = VSCSIIF_ACT_SCSI_CDB;
+
+	shadow->sc  = sc;
+	shadow->act = VSCSIIF_ACT_SCSI_CDB;
+
+	err = map_data_for_request(info, sc, ring_req, shadow);
+	if (err < 0) {
+		DPRINTK("%s: err %d\n", __func__, err);
+		scsifront_put_rqid(info, rqid);
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
+
+busy:
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	DPRINTK("%s: busy\n", __func__);
+	return SCSI_MLQUEUE_HOST_BUSY;
+}
+
+static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
+{
+	struct Scsi_Host *host = sc->device->host;
+	struct vscsifrnt_info *info = shost_priv(host);
+	struct vscsifrnt_shadow *shadow, *s = scsi_cmd_priv(sc);
+	struct vscsiif_request *ring_req;
+	int err = 0;
+
+	shadow = kmalloc(sizeof(*shadow), GFP_NOIO);
+	if (!shadow)
+		return FAILED;
+
+	for (;;) {
+		spin_lock_irq(host->host_lock);
+		if (!RING_FULL(&info->ring)) {
+			ring_req = scsifront_command2ring(info, sc, shadow);
+			if (ring_req)
+				break;
+		}
+		if (err) {
+			spin_unlock_irq(host->host_lock);
+			kfree(shadow);
+			return FAILED;
+		}
+		info->waiting_sync = 1;
+		spin_unlock_irq(host->host_lock);
+		err = wait_event_interruptible(info->wq_sync,
+					       !info->waiting_sync);
+		spin_lock_irq(host->host_lock);
+	}
+
+	ring_req->act = act;
+	ring_req->ref_rqid = s->rqid;
+
+	shadow->act = act;
+	shadow->rslt_reset = 0;
+	init_waitqueue_head(&shadow->wq_reset);
+
+	ring_req->nr_segments         = 0;
+
+	scsifront_do_request(info);
+
+	spin_unlock_irq(host->host_lock);
+	err = wait_event_interruptible(shadow->wq_reset, shadow->wait_reset);
+	spin_lock_irq(host->host_lock);
+
+	if (!err) {
+		err = shadow->rslt_reset;
+		scsifront_put_rqid(info, shadow->rqid);
+		kfree(shadow);
+	} else {
+		spin_lock(&info->shadow_lock);
+		shadow->rslt_reset = -1;
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
+	DPRINTK("%s\n", __func__);
+	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_ABORT);
+}
+
+static int scsifront_dev_reset_handler(struct scsi_cmnd *sc)
+{
+	DPRINTK("%s\n", __func__);
+	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_RESET);
+}
+
+static int scsifront_sdev_alloc(struct scsi_device *sdev)
+{
+	/* set hostdata to not NULL indicating new allocation */
+	sdev->hostdata = sdev;
+	return 0;
+}
+
+static struct scsi_host_template scsifront_sht = {
+	.module			= THIS_MODULE,
+	.name			= "Xen SCSI frontend driver",
+	.queuecommand		= scsifront_queuecommand,
+	.eh_abort_handler	= scsifront_eh_abort_handler,
+	.eh_device_reset_handler = scsifront_dev_reset_handler,
+	.slave_alloc		= scsifront_sdev_alloc,
+	.cmd_per_lun		= VSCSIIF_DEFAULT_CMD_PER_LUN,
+	.can_queue		= VSCSIIF_MAX_REQS,
+	.this_id		= -1,
+	.cmd_size		= sizeof(struct vscsifrnt_shadow),
+	.sg_tablesize		= VSCSIIF_SG_TABLESIZE,
+	.use_clustering		= DISABLE_CLUSTERING,
+	.proc_name		= "scsifront",
+};
+
+static void scsifront_free(struct vscsifrnt_info *info)
+{
+	if (info->host && info->host_active) {
+		/* Scsi_host not yet removed */
+		scsi_remove_host(info->host);
+		info->host_active = 0;
+	}
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
+	if (info->host)
+		scsi_host_put(info->host);
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
+	err = bind_evtchn_to_irq(info->evtchn);
+	if (err <= 0) {
+		xenbus_dev_fatal(dev, err, "bind_evtchn_to_irq");
+		goto free_sring;
+	}
+
+	info->irq = err;
+
+	err = request_threaded_irq(info->irq, NULL, scsifront_irq_fn,
+				   IRQF_ONESHOT, "scsifront", info);
+	if (err) {
+		xenbus_dev_fatal(dev, err, "request_threaded_irq");
+		goto free_sring;
+	}
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
+	int err = -ENOMEM;
+	char name[DEFAULT_TASK_COMM_LEN];
+
+	host = scsi_host_alloc(&scsifront_sht, sizeof(*info));
+	if (!host) {
+		xenbus_dev_fatal(dev, err, "fail to allocate scsi host");
+		return err;
+	}
+	info = (struct vscsifrnt_info *)host->hostdata;
+
+	dev_set_drvdata(&dev->dev, info);
+	info->dev  = dev;
+
+	info->shadow_free = (1UL << VSCSIIF_MAX_REQS) - 1;
+
+	err = scsifront_init_ring(info);
+	if (err) {
+		scsi_host_put(host);
+		return err;
+	}
+
+	init_waitqueue_head(&info->wq_sync);
+	spin_lock_init(&info->shadow_lock);
+
+	snprintf(name, DEFAULT_TASK_COMM_LEN, "vscsiif.%d", host->host_no);
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
+	info->host = host;
+	info->host_active = 1;
+
+	xenbus_switch_state(dev, XenbusStateInitialised);
+
+	return 0;
+
+free_sring:
+	/* free resource */
+	scsifront_free(info);
+	scsi_host_put(host);
+	return err;
+}
+
+static int scsifront_remove(struct xenbus_device *dev)
+{
+	struct vscsifrnt_info *info = dev_get_drvdata(&dev->dev);
+
+	DPRINTK("%s: %s removed\n", __func__, dev->nodename);
+
+	scsifront_free(info);
+
+	return 0;
+}
+
+static void scsifront_disconnect(struct vscsifrnt_info *info)
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
+	if (info->host_active)
+		scsi_remove_host(host);
+	info->host_active = 0;
+
+	xenbus_frontend_closed(dev);
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
+				sdev = __scsi_add_device(info->host, chn, tgt,
+							lun, NULL);
+				err = (IS_ERR(sdev) || !sdev->hostdata);
+				if (!IS_ERR(sdev)) {
+					sdev->hostdata = NULL;
+					scsi_device_put(sdev);
+				}
+
+				if (err) {
+					dev_err(&dev->dev,
+						"Device already in use.\n");
+					xenbus_printf(XBT_NIL, dev->nodename,
+						      state_str, "%d",
+						      XenbusStateClosed);
+				} else {
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
