From: jgross@suse.com
Subject: [PATCH 3/4] Introduce XEN scsiback module
Date: Fri, 27 Jun 2014 16:34:35 +0200
Message-ID: <1403879676-25431-4-git-send-email-jgross@suse.com>
References: <1403879676-25431-1-git-send-email-jgross@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbaF0Off (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 10:35:35 -0400
In-Reply-To: <1403879676-25431-1-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org
Cc: Juergen Gross <jgross@suse.com>

From: Juergen Gross <jgross@suse.com>

Introduces the XEN pvSCSI backend. With pvSCSI it is possible for a XEN domU
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
- correct minor error in scsiback_fast_flush_area
- some minor code simplifications

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/scsi/Kconfig        |    7 +
 drivers/scsi/Makefile       |    1 +
 drivers/scsi/xen-scsiback.c | 1797 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1805 insertions(+)
 create mode 100644 drivers/scsi/xen-scsiback.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 734d691..ccd8ba0 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -611,6 +611,13 @@ config VMWARE_PVSCSI
 	  To compile this driver as a module, choose M here: the
 	  module will be called vmw_pvscsi.
 
+config XEN_SCSI_BACKEND
+	tristate "XEN SCSI backend driver"
+	depends on SCSI && XEN && XEN_BACKEND
+	help
+	  The SCSI backend driver allows the kernel to export its SCSI Devices
+	  to other guests via a high-performance shared-memory interface.
+
 config XEN_SCSI_FRONTEND
 	tristate "XEN SCSI frontend driver"
 	depends on SCSI && XEN
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index a4ee9c5..4cfcc3a 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -156,6 +156,7 @@ obj-$(CONFIG_BLK_DEV_SR)	+= sr_mod.o
 obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
 obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
 obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
+obj-$(CONFIG_XEN_SCSI_BACKEND)	+= xen-scsiback.o
 
 obj-$(CONFIG_SCSI_OSD_INITIATOR) += osd/
 
diff --git a/drivers/scsi/xen-scsiback.c b/drivers/scsi/xen-scsiback.c
new file mode 100644
index 0000000..5b85e6f
--- /dev/null
+++ b/drivers/scsi/xen-scsiback.c
@@ -0,0 +1,1797 @@
+/*
+ * Xen SCSI backend driver
+ *
+ * Copyright (c) 2008, FUJITSU Limited
+ *
+ * Based on the blkback driver code.
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
+* Patched to support >2TB drives + allow tape & autoloader operations
+* 2010, Samuel Kvasnica, IMS Nanofabrication AG
+*/
+
+#include <stdarg.h>
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/blkdev.h>
+#include <linux/list.h>
+#include <linux/gfp.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
+#include <linux/vmalloc.h>
+#include <linux/spinlock.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
+
+#include <asm/hypervisor.h>
+
+#include <xen/xen.h>
+#include <xen/balloon.h>
+#include <xen/events.h>
+#include <xen/xenbus.h>
+#include <xen/grant_table.h>
+#include <xen/page.h>
+
+#include <xen/interface/grant_table.h>
+#include <xen/interface/io/vscsiif.h>
+
+#define DPRINTK(_f, _a...)			\
+	pr_debug("(file=%s, line=%d) " _f,	\
+		 __FILE__ , __LINE__ , ## _a )
+
+struct ids_tuple {
+	unsigned int hst;		/* host    */
+	unsigned int chn;		/* channel */
+	unsigned int tgt;		/* target  */
+	unsigned int lun;		/* LUN     */
+};
+
+struct v2p_entry {
+	struct ids_tuple v;		/* translate from */
+	struct scsi_device *sdev;	/* translate to   */
+	struct list_head l;
+};
+
+struct vscsibk_info {
+	struct xenbus_device *dev;
+
+	domid_t domid;
+	unsigned int evtchn;
+	unsigned int irq;
+
+	int feature;
+
+	struct vscsiif_back_ring  ring;
+
+	spinlock_t ring_lock;
+	atomic_t nr_unreplied_reqs;
+
+	spinlock_t v2p_lock;
+	struct list_head v2p_entry_lists;
+
+	struct task_struct *kthread;
+	wait_queue_head_t waiting_to_free;
+	wait_queue_head_t wq;
+	wait_queue_head_t shutdown_wq;
+	unsigned int waiting_reqs;
+	struct page **mmap_pages;
+
+};
+
+typedef struct {
+	unsigned char act;
+	struct vscsibk_info *info;
+	struct scsi_device *sdev;
+
+	uint16_t rqid;
+
+	uint16_t v_chn, v_tgt;
+
+	uint8_t nr_segments;
+	uint8_t cmnd[VSCSIIF_MAX_COMMAND_SIZE];
+	uint8_t cmd_len;
+
+	uint8_t sc_data_direction;
+	uint16_t timeout_per_command;
+
+	uint32_t request_bufflen;
+	struct scatterlist *sgl;
+	grant_ref_t gref[VSCSIIF_SG_TABLESIZE];
+
+	int32_t rslt;
+	uint32_t resid;
+	uint8_t sense_buffer[VSCSIIF_SENSE_BUFFERSIZE];
+
+	struct list_head free_list;
+} pending_req_t;
+
+struct backend_info
+{
+	struct xenbus_device *dev;
+	struct vscsibk_info *info;
+};
+
+#define scsiback_get(_b) (atomic_inc(&(_b)->nr_unreplied_reqs))
+#define scsiback_put(_b)				\
+	do {						\
+		if (atomic_dec_and_test(&(_b)->nr_unreplied_reqs))	\
+			wake_up(&(_b)->waiting_to_free);\
+	} while (0)
+
+#define VSCSIIF_TIMEOUT		(900*HZ)
+
+#define VSCSI_TYPE_HOST		1
+
+/* Following SCSI commands are not defined in scsi/scsi.h */
+#define EXTENDED_COPY		0x83	/* EXTENDED COPY command        */
+#define REPORT_ALIASES		0xa3	/* REPORT ALIASES command       */
+#define CHANGE_ALIASES		0xa4	/* CHANGE ALIASES command       */
+#define SET_PRIORITY		0xa4	/* SET PRIORITY command         */
+
+/*
+  The bitmap in order to control emulation.
+  (Bit 3 to 7 are reserved for future use.)
+*/
+#define VSCSIIF_NEED_CMD_EXEC		0x01	/* cmd exec required */
+#define VSCSIIF_NEED_EMULATE_REQBUF	0x02	/* emul reqest buff before */
+						/* cmd exec. */
+#define VSCSIIF_NEED_EMULATE_RSPBUF	0x04	/* emul resp buff after	*/
+						/* cmd exec. */
+
+/* Additional Sense Code (ASC) used */
+#define NO_ADDITIONAL_SENSE		0x0
+#define LOGICAL_UNIT_NOT_READY		0x4
+#define UNRECOVERED_READ_ERR		0x11
+#define PARAMETER_LIST_LENGTH_ERR	0x1a
+#define INVALID_OPCODE			0x20
+#define ADDR_OUT_OF_RANGE		0x21
+#define INVALID_FIELD_IN_CDB		0x24
+#define INVALID_FIELD_IN_PARAM_LIST	0x26
+#define POWERON_RESET			0x29
+#define SAVING_PARAMS_UNSUP		0x39
+#define THRESHOLD_EXCEEDED		0x5d
+#define LOW_POWER_COND_ON		0x5e
+
+/* Number os SCSI op_code	*/
+#define VSCSI_MAX_SCSI_OP_CODE		256
+static unsigned char bitmap[VSCSI_MAX_SCSI_OP_CODE];
+
+#define NO_EMULATE(cmd) \
+	bitmap[cmd] = VSCSIIF_NEED_CMD_EXEC; \
+	pre_function[cmd] = NULL; \
+	post_function[cmd] = NULL
+
+#define SCSIBACK_INVALID_HANDLE (~0)
+
+static bool log_print_stat;
+module_param(log_print_stat, bool, 0644);
+
+/*
+  Emulation routines for each SCSI op_code.
+*/
+static void (*pre_function[VSCSI_MAX_SCSI_OP_CODE])(pending_req_t *, void *);
+static void (*post_function[VSCSI_MAX_SCSI_OP_CODE])(pending_req_t *, void *);
+
+static pending_req_t *pending_reqs;
+static struct page **pending_pages;
+static grant_handle_t *pending_grant_handles;
+
+static const int check_condition_result =
+		(DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+
+struct list_head pending_free;
+DEFINE_SPINLOCK(pending_free_lock);
+DECLARE_WAIT_QUEUE_HEAD(pending_free_wq);
+
+static struct kmem_cache *scsiback_cachep;
+
+static int vaddr_pagenr(pending_req_t *req, int seg)
+{
+	return (req - pending_reqs) * VSCSIIF_SG_TABLESIZE + seg;
+}
+
+static unsigned long vaddr(pending_req_t *req, int seg)
+{
+	unsigned long pfn = page_to_pfn(pending_pages[vaddr_pagenr(req, seg)]);
+	return (unsigned long)pfn_to_kaddr(pfn);
+}
+
+static void scsiback_mk_sense_buffer(uint8_t *data, uint8_t key,
+			uint8_t asc, uint8_t asq)
+{
+	data[0] = 0x70;  /* fixed, current */
+	data[2] = key;
+	data[7] = 0xa;	  /* implies 18 byte sense buffer */
+	data[12] = asc;
+	data[13] = asq;
+}
+
+static void resp_not_supported_cmd(pending_req_t *pending_req, void *data)
+{
+	scsiback_mk_sense_buffer(pending_req->sense_buffer, ILLEGAL_REQUEST,
+		INVALID_OPCODE, 0);
+	pending_req->resid = 0;
+	pending_req->rslt  = check_condition_result;
+}
+
+static int __copy_to_sg(struct scatterlist *sgl, unsigned int nr_sg,
+	       void *buf, unsigned int buflen)
+{
+	struct scatterlist *sg;
+	void *from = buf;
+	void *to;
+	unsigned int from_rest = buflen;
+	unsigned int to_capa;
+	unsigned int copy_size = 0;
+	unsigned int i;
+	unsigned long pfn;
+
+	for_each_sg (sgl, sg, nr_sg, i) {
+		if (sg_page(sg) == NULL) {
+			pr_warning("%s: inconsistent length field in "
+				   "scatterlist\n", __FUNCTION__);
+			return -ENOMEM;
+		}
+
+		to_capa  = sg->length;
+		copy_size = min_t(unsigned int, to_capa, from_rest);
+
+		pfn = page_to_pfn(sg_page(sg));
+		to = pfn_to_kaddr(pfn) + (sg->offset);
+		memcpy(to, from, copy_size);
+
+		from_rest  -= copy_size;
+		if (from_rest == 0)
+			return 0;
+
+		from += copy_size;
+	}
+
+	pr_warning("%s: no space in scatterlist\n", __FUNCTION__);
+	return -ENOMEM;
+}
+
+static int __maybe_unused __copy_from_sg(struct scatterlist *sgl,
+					 unsigned int nr_sg, void *buf,
+					 unsigned int buflen)
+{
+	struct scatterlist *sg;
+	void *from;
+	void *to = buf;
+	unsigned int from_rest;
+	unsigned int to_capa = buflen;
+	unsigned int copy_size;
+	unsigned int i;
+	unsigned long pfn;
+
+	for_each_sg (sgl, sg, nr_sg, i) {
+		if (sg_page(sg) == NULL) {
+			pr_warning("%s: inconsistent length field in "
+				   "scatterlist\n", __FUNCTION__);
+			return -ENOMEM;
+		}
+
+		from_rest = sg->length;
+		if ((from_rest > 0) && (to_capa < from_rest)) {
+			pr_warning("%s: no space in destination buffer\n",
+				   __FUNCTION__);
+			return -ENOMEM;
+		}
+		copy_size = from_rest;
+
+		pfn = page_to_pfn(sg_page(sg));
+		from = pfn_to_kaddr(pfn) + (sg->offset);
+		memcpy(to, from, copy_size);
+
+		to_capa  -= copy_size;
+		to += copy_size;
+	}
+
+	return 0;
+}
+
+static int __nr_luns_under_host(struct vscsibk_info *info)
+{
+	struct v2p_entry *entry;
+	struct list_head *head = &(info->v2p_entry_lists);
+	unsigned long flags;
+	int lun_cnt = 0;
+
+	spin_lock_irqsave(&info->v2p_lock, flags);
+	list_for_each_entry(entry, head, l) {
+		lun_cnt++;
+	}
+	spin_unlock_irqrestore(&info->v2p_lock, flags);
+
+	return (lun_cnt);
+}
+
+/* REPORT LUNS Define*/
+#define VSCSI_REPORT_LUNS_HEADER	8
+#define VSCSI_REPORT_LUNS_RETRY		3
+
+/* quoted scsi_debug.c/resp_report_luns() */
+static void __report_luns(pending_req_t *pending_req, void *data)
+{
+	struct vscsibk_info *info = pending_req->info;
+	unsigned int nr_seg  = pending_req->nr_segments;
+	unsigned char *cmd = (unsigned char *)pending_req->cmnd;
+	unsigned char *buff = NULL;
+	unsigned char alloc_len;
+	unsigned int alloc_luns = 0;
+	unsigned int req_bufflen = 0;
+	unsigned int actual_len = 0;
+	unsigned int retry_cnt = 0;
+	int select_report = (int)cmd[2];
+	int i, lun_cnt = 0, lun, upper, err = 0;
+
+	struct v2p_entry *entry;
+	struct list_head *head = &(info->v2p_entry_lists);
+	unsigned long flags;
+
+	struct scsi_lun *one_lun;
+
+	req_bufflen = cmd[9] + (cmd[8] << 8) + (cmd[7] << 16) + (cmd[6] << 24);
+	if ((req_bufflen < 4) || (select_report != 0))
+		goto fail;
+
+	alloc_luns = __nr_luns_under_host(info);
+	alloc_len  = sizeof(struct scsi_lun) * alloc_luns
+				+ VSCSI_REPORT_LUNS_HEADER;
+retry:
+	if ((buff = kzalloc(alloc_len, GFP_KERNEL)) == NULL) {
+		pr_err("scsiback:%s kmalloc err\n", __FUNCTION__);
+		goto fail;
+	}
+
+	one_lun = (struct scsi_lun *) &buff[8];
+	spin_lock_irqsave(&info->v2p_lock, flags);
+	list_for_each_entry(entry, head, l) {
+		if ((entry->v.chn == pending_req->v_chn) &&
+		    (entry->v.tgt == pending_req->v_tgt)) {
+
+			/* check overflow */
+			if (lun_cnt >= alloc_luns) {
+				spin_unlock_irqrestore(&info->v2p_lock, flags);
+
+				if (retry_cnt < VSCSI_REPORT_LUNS_RETRY) {
+					retry_cnt++;
+					if (buff)
+						kfree(buff);
+					goto retry;
+				}
+
+				goto fail;
+			}
+
+			lun = entry->v.lun;
+			upper = (lun >> 8) & 0x3f;
+			if (upper)
+				one_lun[lun_cnt].scsi_lun[0] = upper;
+			one_lun[lun_cnt].scsi_lun[1] = lun & 0xff;
+			lun_cnt++;
+		}
+	}
+
+	spin_unlock_irqrestore(&info->v2p_lock, flags);
+
+	buff[2] = ((sizeof(struct scsi_lun) * lun_cnt) >> 8) & 0xff;
+	buff[3] = (sizeof(struct scsi_lun) * lun_cnt) & 0xff;
+
+	actual_len = lun_cnt * sizeof(struct scsi_lun)
+				+ VSCSI_REPORT_LUNS_HEADER;
+	req_bufflen = 0;
+	for (i = 0; i < nr_seg; i++)
+		req_bufflen += pending_req->sgl[i].length;
+
+	err = __copy_to_sg(pending_req->sgl, nr_seg, buff,
+				min(req_bufflen, actual_len));
+	if (err)
+		goto fail;
+
+	memset(pending_req->sense_buffer, 0, VSCSIIF_SENSE_BUFFERSIZE);
+	pending_req->rslt = 0x00;
+	pending_req->resid = req_bufflen - min(req_bufflen, actual_len);
+
+	kfree(buff);
+	return;
+
+fail:
+	scsiback_mk_sense_buffer(pending_req->sense_buffer, ILLEGAL_REQUEST,
+		INVALID_FIELD_IN_CDB, 0);
+	pending_req->rslt  = check_condition_result;
+	pending_req->resid = 0;
+	if (buff)
+		kfree(buff);
+	return;
+}
+
+int __pre_do_emulation(pending_req_t *pending_req, void *data)
+{
+	uint8_t op_code = pending_req->cmnd[0];
+
+	if ((bitmap[op_code] & VSCSIIF_NEED_EMULATE_REQBUF) &&
+	    pre_function[op_code] != NULL)
+		pre_function[op_code](pending_req, data);
+
+	/*
+	    0: no need for native driver call, so should return immediately.
+	    1: non emulation or should call native driver
+	       after modifing the request buffer.
+	*/
+	return !!(bitmap[op_code] & VSCSIIF_NEED_CMD_EXEC);
+}
+
+static void scsiback_rsp_emulation(pending_req_t *pending_req)
+{
+	uint8_t op_code = pending_req->cmnd[0];
+
+	if ((bitmap[op_code] & VSCSIIF_NEED_EMULATE_RSPBUF) &&
+	    post_function[op_code] != NULL)
+		post_function[op_code](pending_req, NULL);
+
+	return;
+}
+
+/* quoted scsi_lib.c/scsi_bi_endio */
+static void scsiback_bi_endio(struct bio *bio, int error)
+{
+	bio_put(bio);
+}
+
+/* quoted scsi_lib.c/scsi_req_map_sg . */
+static struct bio *request_map_sg(pending_req_t *pending_req)
+{
+	struct request_queue *q = pending_req->sdev->request_queue;
+	unsigned int nsegs = (unsigned int)pending_req->nr_segments;
+	unsigned int i, len, bytes, off, nr_pages, nr_vecs = 0;
+	struct scatterlist *sg;
+	struct page *page;
+	struct bio *bio = NULL, *bio_first = NULL, *bio_last = NULL;
+	int err;
+
+	for_each_sg (pending_req->sgl, sg, nsegs, i) {
+		page = sg_page(sg);
+		off = sg->offset;
+		len = sg->length;
+
+		nr_pages = (len + off + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		while (len > 0) {
+			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
+
+			if (!bio) {
+				nr_vecs = min_t(unsigned int, BIO_MAX_PAGES,
+						nr_pages);
+				nr_pages -= nr_vecs;
+				bio = bio_alloc(GFP_KERNEL, nr_vecs);
+				if (!bio) {
+					err = -ENOMEM;
+					goto free_bios;
+				}
+				bio->bi_end_io = scsiback_bi_endio;
+				if (bio_last)
+					bio_last->bi_next = bio;
+				else
+					bio_first = bio;
+				bio_last = bio;
+			}
+
+			if (bio_add_pc_page(q, bio, page, bytes, off) !=
+						bytes) {
+				err = -EINVAL;
+				goto free_bios;
+			}
+
+			if (bio->bi_vcnt >= nr_vecs) {
+				bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+				if (pending_req->sc_data_direction == WRITE)
+					bio->bi_rw |= REQ_WRITE;
+				bio = NULL;
+			}
+
+			page++;
+			len -= bytes;
+			off = 0;
+		}
+	}
+
+	return bio_first;
+
+free_bios:
+	while ((bio = bio_first) != NULL) {
+		bio_first = bio->bi_next;
+		bio_put(bio);
+	}
+
+	return ERR_PTR(err);
+}
+
+static void scsiback_print_status(char *sense_buffer, int errors,
+					pending_req_t *pending_req)
+{
+	struct scsi_device *sdev = pending_req->sdev;
+
+	pr_err("scsiback[%d:%d:%d:%d] cmnd[0]=%02x -> st=%02x msg=%02x host=%02x drv=%02x\n",
+	       sdev->host->host_no, sdev->channel, sdev->id, sdev->lun,
+	       pending_req->cmnd[0], status_byte(errors), msg_byte(errors),
+	       host_byte(errors), driver_byte(errors));
+
+	if (CHECK_CONDITION & status_byte(errors))
+		__scsi_print_sense("scsiback", sense_buffer,
+				   SCSI_SENSE_BUFFERSIZE);
+}
+
+#define pending_handle(_req, _seg) \
+	(pending_grant_handles[vaddr_pagenr(_req, _seg)])
+
+static void scsiback_fast_flush_area(pending_req_t *req)
+{
+	struct gnttab_unmap_grant_ref unmap[VSCSIIF_SG_TABLESIZE];
+	struct page *pages[VSCSIIF_SG_TABLESIZE];
+	unsigned int i, invcount = 0;
+	grant_handle_t handle;
+	int err;
+
+	if (req->nr_segments) {
+		for (i = 0; i < req->nr_segments; i++) {
+			handle = pending_handle(req, i);
+			if (handle == SCSIBACK_INVALID_HANDLE)
+				continue;
+			gnttab_set_unmap_op(&unmap[invcount], vaddr(req, i),
+					    GNTMAP_host_map, handle);
+			pending_handle(req, i) = SCSIBACK_INVALID_HANDLE;
+			pages[invcount] = pending_pages[vaddr_pagenr(req, i)];
+			invcount++;
+		}
+
+		err = gnttab_unmap_refs(unmap, NULL, pages, invcount);
+		BUG_ON(err);
+		kfree(req->sgl);
+	}
+
+	return;
+}
+
+static void free_req(pending_req_t *req)
+{
+	unsigned long flags;
+	int was_empty;
+
+	spin_lock_irqsave(&pending_free_lock, flags);
+	was_empty = list_empty(&pending_free);
+	list_add(&req->free_list, &pending_free);
+	spin_unlock_irqrestore(&pending_free_lock, flags);
+	if (was_empty)
+		wake_up(&pending_free_wq);
+}
+
+static void scsiback_do_resp_with_sense(char *sense_buffer, int32_t result,
+			uint32_t resid, pending_req_t *pending_req)
+{
+	vscsiif_response_t *ring_res;
+	struct vscsibk_info *info = pending_req->info;
+	int notify;
+	struct scsi_sense_hdr sshdr;
+	unsigned long flags;
+
+	DPRINTK("%s\n",__FUNCTION__);
+
+	spin_lock_irqsave(&info->ring_lock, flags);
+
+	ring_res = RING_GET_RESPONSE(&info->ring, info->ring.rsp_prod_pvt);
+	info->ring.rsp_prod_pvt++;
+
+	ring_res->rslt   = result;
+	ring_res->rqid   = pending_req->rqid;
+
+	if (sense_buffer != NULL) {
+		if (scsi_normalize_sense(sense_buffer,
+			sizeof(sense_buffer), &sshdr)) {
+
+			int len = 8 + sense_buffer[7];
+
+			if (len > VSCSIIF_SENSE_BUFFERSIZE)
+				len = VSCSIIF_SENSE_BUFFERSIZE;
+
+			memcpy(ring_res->sense_buffer, sense_buffer, len);
+			ring_res->sense_len = len;
+		}
+	} else {
+		ring_res->sense_len = 0;
+	}
+
+	ring_res->residual_len = resid;
+
+	RING_PUSH_RESPONSES_AND_CHECK_NOTIFY(&info->ring, notify);
+	spin_unlock_irqrestore(&info->ring_lock, flags);
+
+	if (notify)
+		notify_remote_via_irq(info->irq);
+
+	free_req(pending_req);
+}
+
+static void scsiback_cmd_done(struct request *req, int uptodate)
+{
+	pending_req_t *pending_req = req->end_io_data;
+	unsigned char *sense_buffer;
+	unsigned int resid;
+	int errors;
+
+	sense_buffer = req->sense;
+	resid        = blk_rq_bytes(req);
+	errors       = req->errors;
+
+	if (errors && log_print_stat)
+		scsiback_print_status(sense_buffer, errors, pending_req);
+
+	/* The Host mode is through as for Emulation. */
+	if (pending_req->info->feature != VSCSI_TYPE_HOST)
+		scsiback_rsp_emulation(pending_req);
+
+	scsiback_fast_flush_area(pending_req);
+	scsiback_do_resp_with_sense(sense_buffer, errors, resid, pending_req);
+	scsiback_put(pending_req->info);
+
+	__blk_put_request(req->q, req);
+}
+
+static void scsiback_cmd_exec(pending_req_t *pending_req)
+{
+	int cmd_len  = (int)pending_req->cmd_len;
+	int data_dir = (int)pending_req->sc_data_direction;
+	unsigned int timeout;
+	struct bio *bio;
+	struct request *rq;
+	int write;
+
+	DPRINTK("%s\n",__FUNCTION__);
+
+	/* because it doesn't timeout backend earlier than frontend.*/
+	if (pending_req->timeout_per_command)
+		timeout = pending_req->timeout_per_command * HZ;
+	else
+		timeout = VSCSIIF_TIMEOUT;
+
+	write = (data_dir == DMA_TO_DEVICE);
+	if (pending_req->nr_segments) {
+		bio = request_map_sg(pending_req);
+		if (IS_ERR(bio)) {
+			pr_err("scsiback: SG Request Map Error %ld\n",
+			       PTR_ERR(bio));
+			return;
+		}
+	} else {
+		bio = NULL;
+	}
+
+	if (bio) {
+		rq = blk_make_request(pending_req->sdev->request_queue, bio,
+				      GFP_KERNEL);
+		if (IS_ERR(rq)) {
+			pr_err("scsiback: Make Request Error %ld\n",
+			       PTR_ERR(rq));
+			return;
+		}
+	} else {
+		rq = blk_get_request(pending_req->sdev->request_queue, write,
+				     GFP_KERNEL);
+		if (unlikely(!rq)) {
+			pr_err("scsiback: Get Request Error\n");
+			return;
+		}
+	}
+
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_len = cmd_len;
+	memcpy(rq->cmd, pending_req->cmnd, cmd_len);
+
+	memset(pending_req->sense_buffer, 0, VSCSIIF_SENSE_BUFFERSIZE);
+	rq->sense       = pending_req->sense_buffer;
+	rq->sense_len = 0;
+
+	/* not allowed to retry in backend.                   */
+	rq->retries   = 0;
+	rq->timeout   = timeout;
+	rq->end_io_data = pending_req;
+
+	scsiback_get(pending_req->info);
+	blk_execute_rq_nowait(rq->q, NULL, rq, 1, scsiback_cmd_done);
+
+	return ;
+}
+
+static void scsiback_req_emulation_or_cmdexec(pending_req_t *pending_req)
+{
+	if (__pre_do_emulation(pending_req, NULL)) {
+		scsiback_cmd_exec(pending_req);
+	}
+	else {
+		scsiback_fast_flush_area(pending_req);
+		scsiback_do_resp_with_sense(pending_req->sense_buffer,
+		  pending_req->rslt, pending_req->resid, pending_req);
+	}
+}
+
+
+/*
+  Following are not customizable functions.
+*/
+static void scsiback_emulation_init(void)
+{
+	int i;
+
+	/* Initialize to default state */
+	for (i = 0; i < VSCSI_MAX_SCSI_OP_CODE; i++) {
+		bitmap[i] = VSCSIIF_NEED_EMULATE_REQBUF |
+			    VSCSIIF_NEED_EMULATE_RSPBUF;
+		pre_function[i] = resp_not_supported_cmd;
+		post_function[i] = NULL;
+		/* means,
+		   - no need for pre-emulation
+		   - no need for post-emulation
+		   - call native driver
+		*/
+	}
+
+	/*
+	  Register appropriate functions below as you need.
+	  (See scsi/scsi.h for definition of SCSI op_code.)
+	*/
+
+	/*
+	  Following commands do not require emulation.
+	*/
+	NO_EMULATE(TEST_UNIT_READY);       /*0x00*/ /* sd,st */
+	NO_EMULATE(REZERO_UNIT);           /*0x01*/ /* st */
+	NO_EMULATE(REQUEST_SENSE);         /*0x03*/
+	NO_EMULATE(FORMAT_UNIT);           /*0x04*/
+	NO_EMULATE(READ_BLOCK_LIMITS);     /*0x05*/ /* st */
+	/*NO_EMULATE(REASSIGN_BLOCKS);       *//*0x07*/
+	NO_EMULATE(INITIALIZE_ELEMENT_STATUS); /*0x07*/ /* ch */
+	NO_EMULATE(READ_6);                /*0x08*/ /* sd,st */
+	NO_EMULATE(WRITE_6);               /*0x0a*/ /* sd,st */
+	NO_EMULATE(SEEK_6);                /*0x0b*/
+	/*NO_EMULATE(READ_REVERSE);          *//*0x0f*/
+	NO_EMULATE(WRITE_FILEMARKS);       /*0x10*/ /* st */
+	NO_EMULATE(SPACE);                 /*0x11*/ /* st */
+	NO_EMULATE(INQUIRY);               /*0x12*/
+	/*NO_EMULATE(RECOVER_BUFFERED_DATA); *//*0x14*/
+	NO_EMULATE(MODE_SELECT);           /*0x15*/ /* st */
+	NO_EMULATE(RESERVE);               /*0x16*/
+	NO_EMULATE(RELEASE);               /*0x17*/
+	/*NO_EMULATE(COPY);                  *//*0x18*/
+	NO_EMULATE(ERASE);                 /*0x19*/ /* st */
+	NO_EMULATE(MODE_SENSE);            /*0x1a*/ /* st */
+	NO_EMULATE(START_STOP);            /*0x1b*/ /* sd,st */
+	NO_EMULATE(RECEIVE_DIAGNOSTIC);    /*0x1c*/
+	NO_EMULATE(SEND_DIAGNOSTIC);       /*0x1d*/
+	NO_EMULATE(ALLOW_MEDIUM_REMOVAL);  /*0x1e*/
+
+	/*NO_EMULATE(SET_WINDOW);            *//*0x24*/
+	NO_EMULATE(READ_CAPACITY);         /*0x25*/ /* sd */
+	NO_EMULATE(READ_10);               /*0x28*/ /* sd */
+	NO_EMULATE(WRITE_10);              /*0x2a*/ /* sd */
+	NO_EMULATE(SEEK_10);               /*0x2b*/ /* st */
+	NO_EMULATE(POSITION_TO_ELEMENT);   /*0x2b*/ /* ch */
+	/*NO_EMULATE(WRITE_VERIFY);          *//*0x2e*/
+	/*NO_EMULATE(VERIFY);                *//*0x2f*/
+	/*NO_EMULATE(SEARCH_HIGH);           *//*0x30*/
+	/*NO_EMULATE(SEARCH_EQUAL);          *//*0x31*/
+	/*NO_EMULATE(SEARCH_LOW);            *//*0x32*/
+	NO_EMULATE(SET_LIMITS);            /*0x33*/
+	NO_EMULATE(PRE_FETCH);             /*0x34*/ /* st! */
+	NO_EMULATE(READ_POSITION);          /*0x34*/ /* st */
+	NO_EMULATE(SYNCHRONIZE_CACHE);      /*0x35*/ /* sd */
+	NO_EMULATE(LOCK_UNLOCK_CACHE);     /*0x36*/
+	NO_EMULATE(READ_DEFECT_DATA);      /*0x37*/
+	NO_EMULATE(MEDIUM_SCAN);           /*0x38*/
+	/*NO_EMULATE(COMPARE);               *//*0x39*/
+	/*NO_EMULATE(COPY_VERIFY);           *//*0x3a*/
+	NO_EMULATE(WRITE_BUFFER);          /*0x3b*/
+	NO_EMULATE(READ_BUFFER);           /*0x3c*/ /* osst */
+	/*NO_EMULATE(UPDATE_BLOCK);          *//*0x3d*/
+	/*NO_EMULATE(READ_LONG);             *//*0x3e*/
+	/*NO_EMULATE(WRITE_LONG);            *//*0x3f*/
+	/*NO_EMULATE(CHANGE_DEFINITION);     *//*0x40*/
+	/*NO_EMULATE(WRITE_SAME);            *//*0x41*/
+	NO_EMULATE(READ_TOC);              /*0x43*/ /* sr */
+	NO_EMULATE(LOG_SELECT);            /*0x4c*/
+	NO_EMULATE(LOG_SENSE);             /*0x4d*/ /* st! */
+	/*NO_EMULATE(MODE_SELECT_10);        *//*0x55*/
+	/*NO_EMULATE(RESERVE_10);            *//*0x56*/
+	/*NO_EMULATE(RELEASE_10);            *//*0x57*/
+	NO_EMULATE(MODE_SENSE_10);         /*0x5a*/ /* scsi_lib */
+	/*NO_EMULATE(PERSISTENT_RESERVE_IN); *//*0x5e*/
+	/*NO_EMULATE(PERSISTENT_RESERVE_OUT); *//*0x5f*/
+	/*           REPORT_LUNS             *//*0xa0*//*Full emulaiton*/
+#ifdef MAINTENANCE_IN
+	NO_EMULATE(MAINTENANCE_IN);           /*0xa3*/ /* IFT alua */
+	NO_EMULATE(MAINTENANCE_OUT);       /*0xa4*/ /* IFT alua */
+#endif
+	NO_EMULATE(MOVE_MEDIUM);           /*0xa5*/ /* ch */
+	NO_EMULATE(EXCHANGE_MEDIUM);       /*0xa6*/ /* ch */
+	/*NO_EMULATE(READ_12);               *//*0xa8*/
+	/*NO_EMULATE(WRITE_12);              *//*0xaa*/
+	/*NO_EMULATE(WRITE_VERIFY_12);       *//*0xae*/
+	/*NO_EMULATE(SEARCH_HIGH_12);        *//*0xb0*/
+	/*NO_EMULATE(SEARCH_EQUAL_12);       *//*0xb1*/
+	/*NO_EMULATE(SEARCH_LOW_12);         *//*0xb2*/
+	NO_EMULATE(READ_ELEMENT_STATUS);   /*0xb8*/ /* ch */
+	NO_EMULATE(SEND_VOLUME_TAG);       /*0xb6*/ /* ch */
+	/*NO_EMULATE(WRITE_LONG_2);          *//*0xea*/
+	NO_EMULATE(READ_16);               /*0x88*/ /* sd >2TB */
+	NO_EMULATE(WRITE_16);              /*0x8a*/ /* sd >2TB */
+	NO_EMULATE(VERIFY_16);	           /*0x8f*/
+	NO_EMULATE(SERVICE_ACTION_IN);     /*0x9e*/ /* sd >2TB */
+
+/* st: QFA_REQUEST_BLOCK, QFA_SEEK_BLOCK might be needed ? */
+	/*
+	  Following commands require emulation.
+	*/
+	pre_function[REPORT_LUNS] = __report_luns;
+	bitmap[REPORT_LUNS] = VSCSIIF_NEED_EMULATE_REQBUF |
+			      VSCSIIF_NEED_EMULATE_RSPBUF;
+
+	return;
+}
+
+static struct vscsibk_info *vscsibk_info_alloc(domid_t domid)
+{
+	struct vscsibk_info *info;
+
+	info = kmem_cache_zalloc(scsiback_cachep, GFP_KERNEL);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	info->domid = domid;
+	spin_lock_init(&info->ring_lock);
+	atomic_set(&info->nr_unreplied_reqs, 0);
+	init_waitqueue_head(&info->wq);
+	init_waitqueue_head(&info->shutdown_wq);
+	init_waitqueue_head(&info->waiting_to_free);
+
+	return info;
+}
+
+static void scsiback_notify_work(struct vscsibk_info *info)
+{
+	info->waiting_reqs = 1;
+	wake_up(&info->wq);
+}
+
+static irqreturn_t scsiback_intr(int irq, void *dev_id)
+{
+	scsiback_notify_work((struct vscsibk_info *)dev_id);
+	return IRQ_HANDLED;
+}
+
+static int scsiback_init_sring(struct vscsibk_info *info, grant_ref_t ring_ref,
+			evtchn_port_t evtchn)
+{
+	void *area;
+	struct vscsiif_sring *sring;
+	int err;
+
+	if (info->irq) {
+		pr_err("scsiback: Already connected through?\n");
+		return -1;
+	}
+
+	err = xenbus_map_ring_valloc(info->dev, ring_ref, &area);
+	if (err)
+		return err;
+
+	sring = (struct vscsiif_sring *)area;
+	BACK_RING_INIT(&info->ring, sring, PAGE_SIZE);
+
+	err = bind_interdomain_evtchn_to_irqhandler(
+			info->domid, evtchn,
+			scsiback_intr, 0, "vscsiif-backend", info);
+
+	if (err < 0)
+		goto unmap_page;
+
+	info->irq = err;
+
+	return 0;
+
+unmap_page:
+	xenbus_unmap_ring_vfree(info->dev, area);
+
+	return err;
+}
+
+static void scsiback_disconnect(struct vscsibk_info *info)
+{
+	if (info->kthread) {
+		kthread_stop(info->kthread);
+		info->kthread = NULL;
+		wake_up(&info->shutdown_wq);
+	}
+
+	wait_event(info->waiting_to_free,
+		atomic_read(&info->nr_unreplied_reqs) == 0);
+
+	if (info->irq) {
+		unbind_from_irqhandler(info->irq, info);
+		info->irq = 0;
+	}
+
+	if (info->ring.sring) {
+		xenbus_unmap_ring_vfree(info->dev, info->ring.sring);
+		info->ring.sring = NULL;
+	}
+}
+
+static void scsiback_free(struct vscsibk_info *info)
+{
+	kmem_cache_free(scsiback_cachep, info);
+}
+
+static int __init scsiback_interface_init(void)
+{
+	scsiback_cachep = kmem_cache_create("vscsiif_cache",
+		sizeof(struct vscsibk_info), 0, 0, NULL);
+	if (!scsiback_cachep) {
+		pr_err("scsiback: can't init scsi cache\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void scsiback_interface_exit(void)
+{
+	kmem_cache_destroy(scsiback_cachep);
+}
+
+static unsigned int vscsiif_reqs = 128;
+module_param_named(reqs, vscsiif_reqs, uint, 0);
+MODULE_PARM_DESC(reqs, "Number of scsiback requests to allocate");
+
+static pending_req_t * alloc_req(struct vscsibk_info *info)
+{
+	pending_req_t *req = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pending_free_lock, flags);
+	if (!list_empty(&pending_free)) {
+		req = list_entry(pending_free.next, pending_req_t, free_list);
+		list_del(&req->free_list);
+	}
+	spin_unlock_irqrestore(&pending_free_lock, flags);
+	return req;
+}
+
+static int scsiback_gnttab_data_map(vscsiif_request_t *ring_req,
+					pending_req_t *pending_req)
+{
+	u32 flags;
+	int write;
+	int i, err = 0;
+	unsigned int data_len = 0;
+	struct gnttab_map_grant_ref map[VSCSIIF_SG_TABLESIZE];
+	struct vscsibk_info *info   = pending_req->info;
+	struct page **pg;
+	int data_dir = (int)pending_req->sc_data_direction;
+	unsigned int nr_segments = (unsigned int)pending_req->nr_segments;
+
+	write = (data_dir == DMA_TO_DEVICE);
+
+	if (nr_segments) {
+		struct scatterlist *sg;
+
+		/* free of (sgl) in fast_flush_area()*/
+		pending_req->sgl = kmalloc(sizeof(struct scatterlist) *
+					   nr_segments, GFP_KERNEL);
+		if (!pending_req->sgl) {
+			pr_err("scsiback: %s: kmalloc() error\n", __FUNCTION__);
+			return -ENOMEM;
+		}
+
+		sg_init_table(pending_req->sgl, nr_segments);
+
+		flags = GNTMAP_host_map;
+		if (write)
+			flags |= GNTMAP_readonly;
+
+		for (i = 0; i < nr_segments; i++)
+			gnttab_set_map_op(&map[i], vaddr(pending_req, i), flags,
+					  ring_req->seg[i].gref, info->domid);
+
+		pg = pending_pages + vaddr_pagenr(pending_req, 0);
+		err = gnttab_map_refs(map, NULL, pg, nr_segments);
+		BUG_ON(err);
+
+		for_each_sg (pending_req->sgl, sg, nr_segments, i) {
+
+			if (unlikely(map[i].status != GNTST_okay)) {
+				pr_err("scsiback: invalid buffer -- could not remap it\n");
+				map[i].handle = SCSIBACK_INVALID_HANDLE;
+				err |= 1;
+			}
+
+			pending_handle(pending_req, i) = map[i].handle;
+
+			if (err)
+				continue;
+
+			sg_set_page(sg, pg[i], ring_req->seg[i].length,
+				    ring_req->seg[i].offset);
+			data_len += sg->length;
+
+			barrier();
+			if (sg->offset >= PAGE_SIZE ||
+			    sg->length > PAGE_SIZE ||
+			    sg->offset + sg->length > PAGE_SIZE)
+				err |= 1;
+
+		}
+
+		if (err)
+			goto fail_flush;
+	}
+
+	pending_req->request_bufflen = data_len;
+
+	return 0;
+
+fail_flush:
+	scsiback_fast_flush_area(pending_req);
+	return -ENOMEM;
+}
+
+static void scsiback_device_reset_exec(pending_req_t *pending_req)
+{
+	struct vscsibk_info *info = pending_req->info;
+	int err;
+	struct scsi_device *sdev = pending_req->sdev;
+
+	scsiback_get(info);
+	err = scsi_reset_provider(sdev, SCSI_TRY_RESET_DEVICE);
+
+	scsiback_do_resp_with_sense(NULL, err, 0, pending_req);
+	scsiback_put(info);
+
+	return;
+}
+
+/*
+  Perform virtual to physical translation
+*/
+static struct scsi_device *scsiback_do_translation(struct vscsibk_info *info,
+			struct ids_tuple *v)
+{
+	struct v2p_entry *entry;
+	struct list_head *head = &(info->v2p_entry_lists);
+	struct scsi_device *sdev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->v2p_lock, flags);
+	list_for_each_entry(entry, head, l) {
+		if ((entry->v.chn == v->chn) &&
+		    (entry->v.tgt == v->tgt) &&
+		    (entry->v.lun == v->lun)) {
+			sdev = entry->sdev;
+			goto out;
+		}
+	}
+out:
+	spin_unlock_irqrestore(&info->v2p_lock, flags);
+	return sdev;
+}
+
+static int prepare_pending_reqs(struct vscsibk_info *info,
+		vscsiif_request_t *ring_req, pending_req_t *pending_req)
+{
+	struct scsi_device *sdev;
+	struct ids_tuple vir;
+
+	DPRINTK("%s\n",__FUNCTION__);
+
+	pending_req->rqid       = ring_req->rqid;
+	pending_req->act        = ring_req->act;
+
+	pending_req->info       = info;
+
+	pending_req->v_chn = vir.chn = ring_req->channel;
+	pending_req->v_tgt = vir.tgt = ring_req->id;
+	vir.lun = ring_req->lun;
+
+	rmb();
+	sdev = scsiback_do_translation(info, &vir);
+	if (!sdev) {
+		pending_req->sdev = NULL;
+		DPRINTK("scsiback: doesn't exist.\n");
+		return -ENODEV;
+	}
+	pending_req->sdev = sdev;
+
+	/* request range check from frontend */
+	pending_req->sc_data_direction = ring_req->sc_data_direction;
+	barrier();
+	if ((pending_req->sc_data_direction != DMA_BIDIRECTIONAL) &&
+		(pending_req->sc_data_direction != DMA_TO_DEVICE) &&
+		(pending_req->sc_data_direction != DMA_FROM_DEVICE) &&
+		(pending_req->sc_data_direction != DMA_NONE)) {
+		DPRINTK("scsiback: invalid parameter data_dir = %d\n",
+			pending_req->sc_data_direction);
+		return -EINVAL;
+	}
+
+	pending_req->nr_segments = ring_req->nr_segments;
+	barrier();
+	if (pending_req->nr_segments > VSCSIIF_SG_TABLESIZE) {
+		DPRINTK("scsiback: invalid parameter nr_seg = %d\n",
+			pending_req->nr_segments);
+		return -EINVAL;
+	}
+
+	pending_req->cmd_len = ring_req->cmd_len;
+	barrier();
+	if (pending_req->cmd_len > VSCSIIF_MAX_COMMAND_SIZE) {
+		DPRINTK("scsiback: invalid parameter cmd_len = %d\n",
+			pending_req->cmd_len);
+		return -EINVAL;
+	}
+	memcpy(pending_req->cmnd, ring_req->cmnd, pending_req->cmd_len);
+
+	pending_req->timeout_per_command = ring_req->timeout_per_command;
+
+	if(scsiback_gnttab_data_map(ring_req, pending_req)) {
+		DPRINTK("scsiback: invalid buffer\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int _scsiback_do_cmd_fn(struct vscsibk_info *info)
+{
+	struct vscsiif_back_ring *ring = &info->ring;
+	vscsiif_request_t  *ring_req;
+
+	pending_req_t *pending_req;
+	RING_IDX rc, rp;
+	int err, more_to_do = 0;
+
+	DPRINTK("%s\n",__FUNCTION__);
+
+	rc = ring->req_cons;
+	rp = ring->sring->req_prod;
+	rmb();
+
+	if (RING_REQUEST_PROD_OVERFLOW(ring, rp)) {
+		rc = ring->rsp_prod_pvt;
+		pr_warning("scsiback:"
+			" Dom%d provided bogus ring requests (%#x - %#x = %u)."
+			" Halting ring processing\n",
+			   info->domid, rp, rc, rp - rc);
+		return -EACCES;
+	}
+
+	while ((rc != rp)) {
+		if (RING_REQUEST_CONS_OVERFLOW(ring, rc))
+			break;
+		pending_req = alloc_req(info);
+		if (NULL == pending_req) {
+			more_to_do = 1;
+			break;
+		}
+
+		ring_req = RING_GET_REQUEST(ring, rc);
+		ring->req_cons = ++rc;
+
+		err = prepare_pending_reqs(info, ring_req,
+						pending_req);
+		switch (err ?: pending_req->act) {
+		case VSCSIIF_ACT_SCSI_CDB:
+			/* The Host mode is through as for Emulation. */
+			if (info->feature == VSCSI_TYPE_HOST)
+				scsiback_cmd_exec(pending_req);
+			else
+				scsiback_req_emulation_or_cmdexec(pending_req);
+			break;
+		case VSCSIIF_ACT_SCSI_RESET:
+			scsiback_device_reset_exec(pending_req);
+			break;
+		default:
+			if(!err && printk_ratelimit())
+				pr_err("scsiback: invalid request\n");
+			scsiback_do_resp_with_sense(NULL, DRIVER_ERROR << 24,
+						    0, pending_req);
+			break;
+		case -ENODEV:
+			scsiback_do_resp_with_sense(NULL, DID_NO_CONNECT << 16,
+						    0, pending_req);
+			break;
+		}
+
+		/* Yield point for this unbounded loop. */
+		cond_resched();
+	}
+
+	if (RING_HAS_UNCONSUMED_REQUESTS(ring))
+		more_to_do = 1;
+
+	return more_to_do;
+}
+
+static int scsiback_do_cmd_fn(struct vscsibk_info *info)
+{
+	int more_to_do;
+
+	do {
+		more_to_do = _scsiback_do_cmd_fn(info);
+		if (more_to_do)
+			break;
+
+		RING_FINAL_CHECK_FOR_REQUESTS(&info->ring, more_to_do);
+	} while (more_to_do);
+
+	return more_to_do;
+}
+
+static int scsiback_schedule(void *data)
+{
+	struct vscsibk_info *info = (struct vscsibk_info *)data;
+
+	DPRINTK("%s\n",__FUNCTION__);
+
+	while (!kthread_should_stop()) {
+		wait_event_interruptible(info->wq,
+			info->waiting_reqs || kthread_should_stop());
+		wait_event_interruptible(pending_free_wq,
+			!list_empty(&pending_free) || kthread_should_stop());
+
+		info->waiting_reqs = 0;
+		smp_mb();
+
+		switch (scsiback_do_cmd_fn(info)) {
+		case 1:
+			info->waiting_reqs = 1;
+		case 0:
+			break;
+		case -EACCES:
+			wait_event_interruptible(info->shutdown_wq,
+						 kthread_should_stop());
+			break;
+		default:
+			BUG();
+		}
+	}
+
+	return 0;
+}
+
+static void __vscsiif_name(struct backend_info *be, char *buf)
+{
+	struct xenbus_device *dev = be->dev;
+	unsigned int domid, id;
+
+	sscanf(dev->nodename, "backend/vscsi/%u/%u", &domid, &id);
+	snprintf(buf, TASK_COMM_LEN, "vscsi.%u.%u", be->info->domid, id);
+}
+
+static int scsiback_map(struct backend_info *be)
+{
+	struct xenbus_device *dev = be->dev;
+	unsigned int ring_ref, evtchn;
+	int err;
+	char name[TASK_COMM_LEN];
+
+	err = xenbus_gather(XBT_NIL, dev->otherend,
+			"ring-ref", "%u", &ring_ref,
+			"event-channel", "%u", &evtchn, NULL);
+	if (err) {
+		xenbus_dev_fatal(dev, err, "reading %s ring", dev->otherend);
+		return err;
+	}
+
+	err = scsiback_init_sring(be->info, ring_ref, evtchn);
+	if (err)
+		return err;
+
+	__vscsiif_name(be, name);
+
+	be->info->kthread = kthread_run(scsiback_schedule, be->info, name);
+	if (IS_ERR(be->info->kthread)) {
+		err = PTR_ERR(be->info->kthread);
+		be->info->kthread = NULL;
+		xenbus_dev_error(be->dev, err, "start vscsiif");
+		return err;
+	}
+
+	return 0;
+}
+
+struct scsi_device *scsiback_get_scsi_device(struct ids_tuple *phy)
+{
+	struct Scsi_Host *shost;
+	struct scsi_device *sdev = NULL;
+
+	shost = scsi_host_lookup(phy->hst);
+	if (!shost) {
+		pr_err("scsiback: host%d doesn't exist\n", phy->hst);
+		return NULL;
+	}
+	sdev   = scsi_device_lookup(shost, phy->chn, phy->tgt, phy->lun);
+	if (!sdev) {
+		pr_err("scsiback: %d:%d:%d:%d doesn't exist\n",
+		       phy->hst, phy->chn, phy->tgt, phy->lun);
+		scsi_host_put(shost);
+		return NULL;
+	}
+
+	scsi_host_put(shost);
+	return (sdev);
+}
+
+/*
+  Add a new translation entry
+*/
+static int scsiback_add_translation_entry(struct vscsibk_info *info,
+			struct scsi_device *sdev, struct ids_tuple *v)
+{
+	int err = 0;
+	struct v2p_entry *entry;
+	struct v2p_entry *new;
+	struct list_head *head = &(info->v2p_entry_lists);
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->v2p_lock, flags);
+
+	/* Check double assignment to identical virtual ID */
+	list_for_each_entry(entry, head, l) {
+		if ((entry->v.chn == v->chn) &&
+		    (entry->v.tgt == v->tgt) &&
+		    (entry->v.lun == v->lun)) {
+			pr_warning("scsiback: Virtual ID is already used. "
+				   "Assignment was not performed.\n");
+			err = -EEXIST;
+			goto out;
+		}
+
+	}
+
+	/* Create a new translation entry and add to the list */
+	if ((new = kmalloc(sizeof(struct v2p_entry), GFP_ATOMIC)) == NULL) {
+		pr_err("scsiback: %s: kmalloc() error\n", __FUNCTION__);
+		err = -ENOMEM;
+		goto out;
+	}
+	new->v = *v;
+	new->sdev = sdev;
+	list_add_tail(&new->l, head);
+
+out:
+	spin_unlock_irqrestore(&info->v2p_lock, flags);
+	return err;
+}
+
+/*
+  Delete the translation entry specfied
+*/
+static int scsiback_del_translation_entry(struct vscsibk_info *info,
+				struct ids_tuple *v)
+{
+	struct v2p_entry *entry;
+	struct list_head *head = &(info->v2p_entry_lists);
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->v2p_lock, flags);
+	/* Find out the translation entry specified */
+	list_for_each_entry(entry, head, l) {
+		if ((entry->v.chn == v->chn) &&
+		    (entry->v.tgt == v->tgt) &&
+		    (entry->v.lun == v->lun)) {
+			goto found;
+		}
+	}
+
+	spin_unlock_irqrestore(&info->v2p_lock, flags);
+	return 1;
+
+found:
+	/* Delete the translation entry specfied */
+	scsi_device_put(entry->sdev);
+	list_del(&entry->l);
+	kfree(entry);
+
+	spin_unlock_irqrestore(&info->v2p_lock, flags);
+	return 0;
+}
+
+static void scsiback_do_add_lun(struct backend_info *be, const char *state,
+				struct ids_tuple *phy, struct ids_tuple *vir)
+{
+	struct scsi_device *sdev;
+
+	sdev = scsiback_get_scsi_device(phy);
+	if (!sdev) {
+		xenbus_printf(XBT_NIL, be->dev->nodename, state,
+			      "%d", XenbusStateClosed);
+		return;
+	}
+	if (!scsiback_add_translation_entry(be->info, sdev, vir)) {
+		if (xenbus_printf(XBT_NIL, be->dev->nodename, state,
+				  "%d", XenbusStateInitialised)) {
+			pr_err("scsiback: xenbus_printf error %s\n", state);
+			scsiback_del_translation_entry(be->info, vir);
+		}
+	} else {
+		scsi_device_put(sdev);
+		xenbus_printf(XBT_NIL, be->dev->nodename, state,
+			      "%d", XenbusStateClosed);
+	}
+}
+
+static void scsiback_do_del_lun(struct backend_info *be, const char *state,
+				struct ids_tuple *vir)
+{
+	if (!scsiback_del_translation_entry(be->info, vir)) {
+		if (xenbus_printf(XBT_NIL, be->dev->nodename, state,
+				  "%d", XenbusStateClosed))
+			pr_err("scsiback: xenbus_printf error %s\n", state);
+	}
+}
+
+#define VSCSIBACK_OP_ADD_OR_DEL_LUN	1
+#define VSCSIBACK_OP_UPDATEDEV_STATE	2
+
+static void scsiback_do_1lun_hotplug(struct backend_info *be, int op, char *ent)
+{
+	int err;
+	struct ids_tuple phy, vir;
+	int device_state;
+	char str[64];
+	char state[64];
+	struct xenbus_device *dev = be->dev;
+
+	/* read status */
+	snprintf(state, sizeof(state), "vscsi-devs/%s/state", ent);
+	err = xenbus_scanf(XBT_NIL, dev->nodename, state, "%u", &device_state);
+	if (XENBUS_EXIST_ERR(err))
+		return;
+
+	/* physical SCSI device */
+	snprintf(str, sizeof(str), "vscsi-devs/%s/p-dev", ent);
+	err = xenbus_scanf(XBT_NIL, dev->nodename, str, "%u:%u:%u:%u",
+			   &phy.hst, &phy.chn, &phy.tgt, &phy.lun);
+	if (XENBUS_EXIST_ERR(err)) {
+		xenbus_printf(XBT_NIL, dev->nodename, state,
+			      "%d", XenbusStateClosed);
+		return;
+	}
+
+	/* virtual SCSI device */
+	snprintf(str, sizeof(str), "vscsi-devs/%s/v-dev", ent);
+	err = xenbus_scanf(XBT_NIL, dev->nodename, str, "%u:%u:%u:%u",
+			   &vir.hst, &vir.chn, &vir.tgt, &vir.lun);
+	if (XENBUS_EXIST_ERR(err)) {
+		xenbus_printf(XBT_NIL, dev->nodename, state,
+			      "%d", XenbusStateClosed);
+		return;
+	}
+
+	switch (op) {
+	case VSCSIBACK_OP_ADD_OR_DEL_LUN:
+		if (device_state == XenbusStateInitialising)
+			scsiback_do_add_lun(be, state, &phy, &vir);
+		if (device_state == XenbusStateClosing)
+			scsiback_do_del_lun(be, state, &vir);
+		break;
+
+	case VSCSIBACK_OP_UPDATEDEV_STATE:
+		if (device_state == XenbusStateInitialised) {
+			/* modify vscsi-devs/dev-x/state */
+			if (xenbus_printf(XBT_NIL, dev->nodename, state,
+					  "%d", XenbusStateConnected)) {
+				pr_err("scsiback: xenbus_printf error %s\n",
+				       str);
+				scsiback_del_translation_entry(be->info, &vir);
+				xenbus_printf(XBT_NIL, dev->nodename, state,
+					      "%d", XenbusStateClosed);
+			}
+		}
+		break;
+	/*When it is necessary, processing is added here.*/
+	default:
+		break;
+	}
+}
+
+static void scsiback_do_lun_hotplug(struct backend_info *be, int op)
+{
+	int i;
+	char **dir;
+	unsigned int ndir = 0;
+
+	dir = xenbus_directory(XBT_NIL, be->dev->nodename, "vscsi-devs", &ndir);
+	if (IS_ERR(dir))
+		return;
+
+	for (i = 0; i < ndir; i++)
+		scsiback_do_1lun_hotplug(be, op, dir[i]);
+
+	kfree(dir);
+	return ;
+}
+
+static void scsiback_frontend_changed(struct xenbus_device *dev,
+					enum xenbus_state frontend_state)
+{
+	struct backend_info *be = dev_get_drvdata(&dev->dev);
+	int err;
+
+	switch (frontend_state) {
+	case XenbusStateInitialising:
+		break;
+	case XenbusStateInitialised:
+		err = scsiback_map(be);
+		if (err)
+			break;
+
+		scsiback_do_lun_hotplug(be, VSCSIBACK_OP_ADD_OR_DEL_LUN);
+		xenbus_switch_state(dev, XenbusStateConnected);
+
+		break;
+	case XenbusStateConnected:
+
+		scsiback_do_lun_hotplug(be, VSCSIBACK_OP_UPDATEDEV_STATE);
+
+		if (dev->state == XenbusStateConnected)
+			break;
+
+		xenbus_switch_state(dev, XenbusStateConnected);
+
+		break;
+
+	case XenbusStateClosing:
+		scsiback_disconnect(be->info);
+		xenbus_switch_state(dev, XenbusStateClosing);
+		break;
+
+	case XenbusStateClosed:
+		xenbus_switch_state(dev, XenbusStateClosed);
+		if (xenbus_dev_is_online(dev))
+			break;
+		/* fall through if not online */
+	case XenbusStateUnknown:
+		device_unregister(&dev->dev);
+		break;
+
+	case XenbusStateReconfiguring:
+		scsiback_do_lun_hotplug(be, VSCSIBACK_OP_ADD_OR_DEL_LUN);
+
+		xenbus_switch_state(dev, XenbusStateReconfigured);
+
+		break;
+
+	default:
+		xenbus_dev_fatal(dev, -EINVAL, "saw state %d at frontend",
+					frontend_state);
+		break;
+	}
+}
+
+/*
+  Release the translation entry specfied
+*/
+static void scsiback_release_translation_entry(struct vscsibk_info *info)
+{
+	struct v2p_entry *entry, *tmp;
+	struct list_head *head = &(info->v2p_entry_lists);
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->v2p_lock, flags);
+	list_for_each_entry_safe(entry, tmp, head, l) {
+		scsi_device_put(entry->sdev);
+		list_del(&entry->l);
+		kfree(entry);
+	}
+
+	spin_unlock_irqrestore(&info->v2p_lock, flags);
+	return;
+
+}
+
+static int scsiback_remove(struct xenbus_device *dev)
+{
+	struct backend_info *be = dev_get_drvdata(&dev->dev);
+
+	if (be->info) {
+		scsiback_disconnect(be->info);
+		scsiback_release_translation_entry(be->info);
+		scsiback_free(be->info);
+		be->info = NULL;
+	}
+
+	kfree(be);
+	dev_set_drvdata(&dev->dev, NULL);
+
+	return 0;
+}
+
+/*
+  Initialize the translation entry list
+*/
+static void scsiback_init_translation_table(struct vscsibk_info *info)
+{
+	INIT_LIST_HEAD(&info->v2p_entry_lists);
+	spin_lock_init(&info->v2p_lock);
+}
+
+static int scsiback_probe(struct xenbus_device *dev,
+			   const struct xenbus_device_id *id)
+{
+	int err;
+	unsigned val = 0;
+
+	struct backend_info *be = kzalloc(sizeof(struct backend_info),
+					  GFP_KERNEL);
+
+	DPRINTK("%p %d\n", dev, dev->otherend_id);
+
+	if (!be) {
+		xenbus_dev_fatal(dev, -ENOMEM,
+				 "allocating backend structure");
+		return -ENOMEM;
+	}
+	be->dev = dev;
+	dev_set_drvdata(&dev->dev, be);
+
+	be->info = vscsibk_info_alloc(dev->otherend_id);
+	if (IS_ERR(be->info)) {
+		err = PTR_ERR(be->info);
+		be->info = NULL;
+		xenbus_dev_fatal(dev, err, "creating scsihost interface");
+		goto fail;
+	}
+
+	be->info->dev = dev;
+	be->info->irq = 0;
+	be->info->feature = 0;	/*default not HOSTMODE.*/
+
+	scsiback_init_translation_table(be->info);
+
+	err = xenbus_scanf(XBT_NIL, dev->nodename,
+			   "feature-host", "%d", &val);
+	if (XENBUS_EXIST_ERR(err))
+		val = 0;
+
+	if (val)
+		be->info->feature = VSCSI_TYPE_HOST;
+
+	err = xenbus_switch_state(dev, XenbusStateInitWait);
+	if (err)
+		goto fail;
+
+	return 0;
+
+fail:
+	pr_warning("scsiback: %s failed\n",__FUNCTION__);
+	scsiback_remove(dev);
+
+	return err;
+}
+
+static const struct xenbus_device_id scsiback_ids[] = {
+	{ "vscsi" },
+	{ "" }
+};
+
+static DEFINE_XENBUS_DRIVER(scsiback, ,
+	.probe			= scsiback_probe,
+	.remove			= scsiback_remove,
+	.otherend_changed	= scsiback_frontend_changed
+);
+
+static int __init scsiback_init(void)
+{
+	int i, mmap_pages;
+
+	if (!xen_domain())
+		return -ENODEV;
+
+	mmap_pages = vscsiif_reqs * VSCSIIF_SG_TABLESIZE;
+
+	pending_reqs          = kzalloc(sizeof(pending_reqs[0]) *
+					vscsiif_reqs, GFP_KERNEL);
+	pending_grant_handles = kmalloc(sizeof(pending_grant_handles[0]) *
+					mmap_pages, GFP_KERNEL);
+	pending_pages         = kcalloc(mmap_pages, sizeof(pending_pages[0]),
+					GFP_KERNEL);
+
+	if (!pending_reqs || !pending_grant_handles || !pending_pages)
+		goto out_of_memory;
+
+	if (alloc_xenballooned_pages(mmap_pages, pending_pages, 0))
+		goto out_of_memory;
+
+	for (i = 0; i < mmap_pages; i++)
+		pending_grant_handles[i] = SCSIBACK_INVALID_HANDLE;
+
+	if (scsiback_interface_init() < 0)
+		goto out_of_memory;
+
+	INIT_LIST_HEAD(&pending_free);
+
+	for (i = 0; i < vscsiif_reqs; i++)
+		list_add_tail(&pending_reqs[i].free_list, &pending_free);
+
+	if (xenbus_register_backend(&scsiback_driver))
+		goto out_interface;
+
+	scsiback_emulation_init();
+
+	return 0;
+
+out_interface:
+	scsiback_interface_exit();
+out_of_memory:
+	kfree(pending_reqs);
+	kfree(pending_grant_handles);
+	free_xenballooned_pages(mmap_pages, pending_pages);
+	kfree(pending_pages);
+	pr_err("scsiback: %s: out of memory\n", __FUNCTION__);
+	return -ENOMEM;
+}
+
+#if 0
+static void __exit scsiback_exit(void)
+{
+	xenbus_unregister_driver(&scsiback_driver);
+	scsiback_interface_exit();
+	kfree(pending_reqs);
+	kfree(pending_grant_handles);
+	free_xenballooned_pages(vscsiif_reqs * VSCSIIF_SG_TABLESIZE,
+				pending_pages);
+	kfree(pending_pages);
+}
+#endif
+
+module_init(scsiback_init);
+
+#if 0
+module_exit(scsiback_exit);
+#endif
+
+MODULE_DESCRIPTION("Xen SCSI backend driver");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_ALIAS("xen-backend:vscsi");
-- 
1.8.4.5

