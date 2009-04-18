From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH 4/6] fnic: adds resource allocation, interrupt interfaces
Date: Fri, 17 Apr 2009 18:33:08 -0700
Message-ID: <20090418013303.24787.51235.stgit@feynman.nuovasystems.com>
References: <20090418012941.24787.58754.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.nuovasystems.com ([67.91.200.194]:46015 "EHLO
	feynman.nuovasystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759172AbZDRBdL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2009 21:33:11 -0400
In-Reply-To: <20090418012941.24787.58754.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, abjoglek@cisco.com, jeykholt@cisco.com

fnic_res.[h,c]: gets device config, maps PCI resources, allocates
descriptor rings, buffers

fnic_isr.c: interrupt vectors

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/fnic/fnic_isr.c |  332 +++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_res.c |  444 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_res.h |  197 +++++++++++++++++++
 3 files changed, 973 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/fnic/fnic_isr.c
 create mode 100644 drivers/scsi/fnic/fnic_res.c
 create mode 100644 drivers/scsi/fnic/fnic_res.h


diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
new file mode 100644
index 0000000..2b30648
--- /dev/null
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -0,0 +1,332 @@
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <scsi/libfc.h>
+#include <scsi/fc_frame.h>
+#include "vnic_dev.h"
+#include "vnic_intr.h"
+#include "vnic_stats.h"
+#include "fnic_io.h"
+#include "fnic.h"
+
+static irqreturn_t fnic_isr_legacy(int irq, void *data)
+{
+	struct fnic *fnic = data;
+	u32 pba;
+	unsigned long work_done = 0;
+
+	pba = vnic_intr_legacy_pba(fnic->legacy_pba);
+	if (!pba)
+		return IRQ_NONE;
+
+	if (pba & (1 << FNIC_INTX_NOTIFY)) {
+		vnic_intr_return_all_credits(&fnic->intr[FNIC_INTX_NOTIFY]);
+		fnic_handle_link_event(fnic);
+	}
+
+	if (pba & (1 << FNIC_INTX_ERR)) {
+		vnic_intr_return_all_credits(&fnic->intr[FNIC_INTX_ERR]);
+		fnic_log_q_error(fnic);
+	}
+
+	if (pba & (1 << FNIC_INTX_WQ_RQ_COPYWQ)) {
+		work_done += fnic_wq_copy_cmpl_handler(fnic, 8);
+		work_done += fnic_wq_cmpl_handler(fnic, 4);
+		work_done += fnic_rq_cmpl_handler(fnic, 4);
+
+		vnic_intr_return_credits(&fnic->intr[FNIC_INTX_WQ_RQ_COPYWQ],
+					 work_done,
+					 1 /* unmask intr */,
+					 1 /* reset intr timer */);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fnic_isr_msi(int irq, void *data)
+{
+	struct fnic *fnic = data;
+	unsigned long work_done = 0;
+
+	work_done += fnic_wq_copy_cmpl_handler(fnic, 8);
+	work_done += fnic_wq_cmpl_handler(fnic, 4);
+	work_done += fnic_rq_cmpl_handler(fnic, 4);
+
+	vnic_intr_return_credits(&fnic->intr[0],
+				 work_done,
+				 1 /* unmask intr */,
+				 1 /* reset intr timer */);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fnic_isr_msix_rq(int irq, void *data)
+{
+	struct fnic *fnic = data;
+	unsigned long rq_work_done = 0;
+
+	rq_work_done = fnic_rq_cmpl_handler(fnic, 4);
+	vnic_intr_return_credits(&fnic->intr[FNIC_MSIX_RQ],
+				 rq_work_done,
+				 1 /* unmask intr */,
+				 1 /* reset intr timer */);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fnic_isr_msix_wq(int irq, void *data)
+{
+	struct fnic *fnic = data;
+	unsigned long wq_work_done = 0;
+
+	wq_work_done = fnic_wq_cmpl_handler(fnic, 4);
+	vnic_intr_return_credits(&fnic->intr[FNIC_MSIX_WQ],
+				 wq_work_done,
+				 1 /* unmask intr */,
+				 1 /* reset intr timer */);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fnic_isr_msix_wq_copy(int irq, void *data)
+{
+	struct fnic *fnic = data;
+	unsigned long wq_copy_work_done = 0;
+
+	wq_copy_work_done = fnic_wq_copy_cmpl_handler(fnic, 8);
+	vnic_intr_return_credits(&fnic->intr[FNIC_MSIX_WQ_COPY],
+				 wq_copy_work_done,
+				 1 /* unmask intr */,
+				 1 /* reset intr timer */);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fnic_isr_msix_err_notify(int irq, void *data)
+{
+	struct fnic *fnic = data;
+
+	vnic_intr_return_all_credits(&fnic->intr[FNIC_MSIX_ERR_NOTIFY]);
+	fnic_log_q_error(fnic);
+	fnic_handle_link_event(fnic);
+
+	return IRQ_HANDLED;
+}
+
+void fnic_free_intr(struct fnic *fnic)
+{
+	int i;
+
+	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
+	case VNIC_DEV_INTR_MODE_INTX:
+	case VNIC_DEV_INTR_MODE_MSI:
+		free_irq(fnic->pdev->irq, fnic);
+		break;
+
+	case VNIC_DEV_INTR_MODE_MSIX:
+		for (i = 0; i < ARRAY_SIZE(fnic->msix); i++)
+			if (fnic->msix[i].requested)
+				free_irq(fnic->msix_entry[i].vector,
+					 fnic->msix[i].devid);
+		break;
+
+	default:
+		break;
+	}
+}
+
+int fnic_request_intr(struct fnic *fnic)
+{
+	int err = 0;
+	int i;
+
+	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
+
+	case VNIC_DEV_INTR_MODE_INTX:
+		err = request_irq(fnic->pdev->irq, &fnic_isr_legacy,
+				  IRQF_SHARED, DRV_NAME, fnic);
+		break;
+
+	case VNIC_DEV_INTR_MODE_MSI:
+		err = request_irq(fnic->pdev->irq, &fnic_isr_msi,
+				  0, fnic->name, fnic);
+		break;
+
+	case VNIC_DEV_INTR_MODE_MSIX:
+
+		sprintf(fnic->msix[FNIC_MSIX_RQ].devname,
+			"%.11s-fcs-rq", fnic->name);
+		fnic->msix[FNIC_MSIX_RQ].isr = fnic_isr_msix_rq;
+		fnic->msix[FNIC_MSIX_RQ].devid = fnic;
+
+		sprintf(fnic->msix[FNIC_MSIX_WQ].devname,
+			"%.11s-fcs-wq", fnic->name);
+		fnic->msix[FNIC_MSIX_WQ].isr = fnic_isr_msix_wq;
+		fnic->msix[FNIC_MSIX_WQ].devid = fnic;
+
+		sprintf(fnic->msix[FNIC_MSIX_WQ_COPY].devname,
+			"%.11s-scsi-wq", fnic->name);
+		fnic->msix[FNIC_MSIX_WQ_COPY].isr = fnic_isr_msix_wq_copy;
+		fnic->msix[FNIC_MSIX_WQ_COPY].devid = fnic;
+
+		sprintf(fnic->msix[FNIC_MSIX_ERR_NOTIFY].devname,
+			"%.11s-err-notify", fnic->name);
+		fnic->msix[FNIC_MSIX_ERR_NOTIFY].isr =
+			fnic_isr_msix_err_notify;
+		fnic->msix[FNIC_MSIX_ERR_NOTIFY].devid = fnic;
+
+		for (i = 0; i < ARRAY_SIZE(fnic->msix); i++) {
+			err = request_irq(fnic->msix_entry[i].vector,
+					  fnic->msix[i].isr, 0,
+					  fnic->msix[i].devname,
+					  fnic->msix[i].devid);
+			if (err) {
+				shost_printk(KERN_ERR, fnic->lport->host,
+					     "MSIX: request_irq"
+					     " failed %d\n", err);
+				fnic_free_intr(fnic);
+				break;
+			}
+			fnic->msix[i].requested = 1;
+		}
+		break;
+
+	default:
+		break;
+	}
+
+	return err;
+}
+
+int fnic_set_intr_mode(struct fnic *fnic)
+{
+	unsigned int n = ARRAY_SIZE(fnic->rq);
+	unsigned int m = ARRAY_SIZE(fnic->wq);
+	unsigned int o = ARRAY_SIZE(fnic->wq_copy);
+	unsigned int i;
+
+	/*
+	 * Set interrupt mode (INTx, MSI, MSI-X) depending
+	 * system capabilities.
+	 *
+	 * Try MSI-X first
+	 *
+	 * We need n RQs, m WQs, o Copy WQs, n+m+o CQs, and n+m+o+1 INTRs
+	 * (last INTR is used for WQ/RQ errors and notification area)
+	 */
+
+	BUG_ON(ARRAY_SIZE(fnic->msix_entry) < n + m + o + 1);
+	for (i = 0; i < n + m + o + 1; i++)
+		fnic->msix_entry[i].entry = i;
+
+	if (fnic->rq_count >= n &&
+	    fnic->raw_wq_count >= m &&
+	    fnic->wq_copy_count >= o &&
+	    fnic->cq_count >= n + m + o) {
+		if (!pci_enable_msix(fnic->pdev, fnic->msix_entry,
+				    n + m + o + 1)) {
+			fnic->rq_count = n;
+			fnic->raw_wq_count = m;
+			fnic->wq_copy_count = o;
+			fnic->wq_count = m + o;
+			fnic->cq_count = n + m + o;
+			fnic->intr_count = n + m + o + 1;
+			fnic->err_intr_offset = FNIC_MSIX_ERR_NOTIFY;
+
+			FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
+				     "Using MSI-X Interrupts\n");
+			vnic_dev_set_intr_mode(fnic->vdev,
+					       VNIC_DEV_INTR_MODE_MSIX);
+			return 0;
+		}
+	}
+
+	/*
+	 * Next try MSI
+	 * We need 1 RQ, 1 WQ, 1 WQ_COPY, 3 CQs, and 1 INTR
+	 */
+	if (fnic->rq_count >= 1 &&
+	    fnic->raw_wq_count >= 1 &&
+	    fnic->wq_copy_count >= 1 &&
+	    fnic->cq_count >= 3 &&
+	    fnic->intr_count >= 1 &&
+	    !pci_enable_msi(fnic->pdev)) {
+
+		fnic->rq_count = 1;
+		fnic->raw_wq_count = 1;
+		fnic->wq_copy_count = 1;
+		fnic->wq_count = 2;
+		fnic->cq_count = 3;
+		fnic->intr_count = 1;
+		fnic->err_intr_offset = 0;
+
+		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
+			     "Using MSI Interrupts\n");
+		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_MSI);
+
+		return 0;
+	}
+
+	/*
+	 * Next try INTx
+	 * We need 1 RQ, 1 WQ, 1 WQ_COPY, 3 CQs, and 3 INTRs
+	 * 1 INTR is used for all 3 queues, 1 INTR for queue errors
+	 * 1 INTR for notification area
+	 */
+
+	if (fnic->rq_count >= 1 &&
+	    fnic->raw_wq_count >= 1 &&
+	    fnic->wq_copy_count >= 1 &&
+	    fnic->cq_count >= 3 &&
+	    fnic->intr_count >= 3) {
+
+		fnic->rq_count = 1;
+		fnic->raw_wq_count = 1;
+		fnic->wq_copy_count = 1;
+		fnic->cq_count = 3;
+		fnic->intr_count = 3;
+
+		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
+			     "Using Legacy Interrupts\n");
+		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_INTX);
+
+		return 0;
+	}
+
+	vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_UNKNOWN);
+
+	return -EINVAL;
+}
+
+void fnic_clear_intr_mode(struct fnic *fnic)
+{
+	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
+	case VNIC_DEV_INTR_MODE_MSIX:
+		pci_disable_msix(fnic->pdev);
+		break;
+	case VNIC_DEV_INTR_MODE_MSI:
+		pci_disable_msi(fnic->pdev);
+		break;
+	default:
+		break;
+	}
+
+	vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_INTX);
+}
+
diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.c
new file mode 100644
index 0000000..7ba61ec
--- /dev/null
+++ b/drivers/scsi/fnic/fnic_res.c
@@ -0,0 +1,444 @@
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include "wq_enet_desc.h"
+#include "rq_enet_desc.h"
+#include "cq_enet_desc.h"
+#include "vnic_resource.h"
+#include "vnic_dev.h"
+#include "vnic_wq.h"
+#include "vnic_rq.h"
+#include "vnic_cq.h"
+#include "vnic_intr.h"
+#include "vnic_stats.h"
+#include "vnic_nic.h"
+#include "fnic.h"
+
+int fnic_get_vnic_config(struct fnic *fnic)
+{
+	struct vnic_fc_config *c = &fnic->config;
+	int err;
+
+#define GET_CONFIG(m) \
+	do { \
+		err = vnic_dev_spec(fnic->vdev, \
+				    offsetof(struct vnic_fc_config, m), \
+				    sizeof(c->m), &c->m); \
+		if (err) { \
+			shost_printk(KERN_ERR, fnic->lport->host, \
+				     "Error getting %s, %d\n", #m, \
+				     err); \
+			return err; \
+		} \
+	} while (0);
+
+	GET_CONFIG(node_wwn);
+	GET_CONFIG(port_wwn);
+	GET_CONFIG(wq_enet_desc_count);
+	GET_CONFIG(wq_copy_desc_count);
+	GET_CONFIG(rq_desc_count);
+	GET_CONFIG(maxdatafieldsize);
+	GET_CONFIG(ed_tov);
+	GET_CONFIG(ra_tov);
+	GET_CONFIG(intr_timer);
+	GET_CONFIG(intr_timer_type);
+	GET_CONFIG(flags);
+	GET_CONFIG(flogi_retries);
+	GET_CONFIG(flogi_timeout);
+	GET_CONFIG(plogi_retries);
+	GET_CONFIG(plogi_timeout);
+	GET_CONFIG(io_throttle_count);
+	GET_CONFIG(link_down_timeout);
+	GET_CONFIG(port_down_timeout);
+	GET_CONFIG(port_down_io_retries);
+	GET_CONFIG(luns_per_tgt);
+
+	c->wq_enet_desc_count =
+		min_t(u32, VNIC_FNIC_WQ_DESCS_MAX,
+		      max_t(u32, VNIC_FNIC_WQ_DESCS_MIN,
+			    c->wq_enet_desc_count));
+	c->wq_enet_desc_count = ALIGN(c->wq_enet_desc_count, 16);
+
+	c->wq_copy_desc_count =
+		min_t(u32, VNIC_FNIC_WQ_COPY_DESCS_MAX,
+		      max_t(u32, VNIC_FNIC_WQ_COPY_DESCS_MIN,
+			    c->wq_copy_desc_count));
+	c->wq_copy_desc_count = ALIGN(c->wq_copy_desc_count, 16);
+
+	c->rq_desc_count =
+		min_t(u32, VNIC_FNIC_RQ_DESCS_MAX,
+		      max_t(u32, VNIC_FNIC_RQ_DESCS_MIN,
+			    c->rq_desc_count));
+	c->rq_desc_count = ALIGN(c->rq_desc_count, 16);
+
+	c->maxdatafieldsize =
+		min_t(u16, VNIC_FNIC_MAXDATAFIELDSIZE_MAX,
+		      max_t(u16, VNIC_FNIC_MAXDATAFIELDSIZE_MIN,
+			    c->maxdatafieldsize));
+	c->ed_tov =
+		min_t(u32, VNIC_FNIC_EDTOV_MAX,
+		      max_t(u32, VNIC_FNIC_EDTOV_MIN,
+			    c->ed_tov));
+
+	c->ra_tov =
+		min_t(u32, VNIC_FNIC_RATOV_MAX,
+		      max_t(u32, VNIC_FNIC_RATOV_MIN,
+			    c->ra_tov));
+
+	c->flogi_retries =
+		min_t(u32, VNIC_FNIC_FLOGI_RETRIES_MAX, c->flogi_retries);
+
+	c->flogi_timeout =
+		min_t(u32, VNIC_FNIC_FLOGI_TIMEOUT_MAX,
+		      max_t(u32, VNIC_FNIC_FLOGI_TIMEOUT_MIN,
+			    c->flogi_timeout));
+
+	c->plogi_retries =
+		min_t(u32, VNIC_FNIC_PLOGI_RETRIES_MAX, c->plogi_retries);
+
+	c->plogi_timeout =
+		min_t(u32, VNIC_FNIC_PLOGI_TIMEOUT_MAX,
+		      max_t(u32, VNIC_FNIC_PLOGI_TIMEOUT_MIN,
+			    c->plogi_timeout));
+
+	c->io_throttle_count =
+		min_t(u32, VNIC_FNIC_IO_THROTTLE_COUNT_MAX,
+		      max_t(u32, VNIC_FNIC_IO_THROTTLE_COUNT_MIN,
+			    c->io_throttle_count));
+
+	c->link_down_timeout =
+		min_t(u32, VNIC_FNIC_LINK_DOWN_TIMEOUT_MAX,
+		      c->link_down_timeout);
+
+	c->port_down_timeout =
+		min_t(u32, VNIC_FNIC_PORT_DOWN_TIMEOUT_MAX,
+		      c->port_down_timeout);
+
+	c->port_down_io_retries =
+		min_t(u32, VNIC_FNIC_PORT_DOWN_IO_RETRIES_MAX,
+		      c->port_down_io_retries);
+
+	c->luns_per_tgt =
+		min_t(u32, VNIC_FNIC_LUNS_PER_TARGET_MAX,
+		      max_t(u32, VNIC_FNIC_LUNS_PER_TARGET_MIN,
+			    c->luns_per_tgt));
+
+	c->intr_timer = min_t(u16, VNIC_INTR_TIMER_MAX, c->intr_timer);
+	c->intr_timer_type = c->intr_timer_type;
+
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC MAC addr %02x:%02x:%02x:%02x:%02x:%02x "
+		     "wq/wq_copy/rq %d/%d/%d\n",
+		     fnic->mac_addr[0], fnic->mac_addr[1], fnic->mac_addr[2],
+		     fnic->mac_addr[3], fnic->mac_addr[4], fnic->mac_addr[5],
+		     c->wq_enet_desc_count, c->wq_copy_desc_count,
+		     c->rq_desc_count);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC node wwn %llx port wwn %llx\n",
+		     c->node_wwn, c->port_wwn);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC ed_tov %d ra_tov %d\n",
+		     c->ed_tov, c->ra_tov);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC mtu %d intr timer %d\n",
+		     c->maxdatafieldsize, c->intr_timer);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC flags 0x%x luns per tgt %d\n",
+		     c->flags, c->luns_per_tgt);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC flogi_retries %d flogi timeout %d\n",
+		     c->flogi_retries, c->flogi_timeout);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC plogi retries %d plogi timeout %d\n",
+		     c->plogi_retries, c->plogi_timeout);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC io throttle count %d link dn timeout %d\n",
+		     c->io_throttle_count, c->link_down_timeout);
+	shost_printk(KERN_INFO, fnic->lport->host,
+		     "vNIC port dn io retries %d port dn timeout %d\n",
+		     c->port_down_io_retries, c->port_down_timeout);
+
+	return 0;
+}
+
+int fnic_set_nic_config(struct fnic *fnic, u8 rss_default_cpu,
+			u8 rss_hash_type,
+			u8 rss_hash_bits, u8 rss_base_cpu, u8 rss_enable,
+			u8 tso_ipid_split_en, u8 ig_vlan_strip_en)
+{
+	u64 a0, a1;
+	u32 nic_cfg;
+	int wait = 1000;
+
+	vnic_set_nic_cfg(&nic_cfg, rss_default_cpu,
+		rss_hash_type, rss_hash_bits, rss_base_cpu,
+		rss_enable, tso_ipid_split_en, ig_vlan_strip_en);
+
+	a0 = nic_cfg;
+	a1 = 0;
+
+	return vnic_dev_cmd(fnic->vdev, CMD_NIC_CFG, &a0, &a1, wait);
+}
+
+void fnic_get_res_counts(struct fnic *fnic)
+{
+	fnic->wq_count = vnic_dev_get_res_count(fnic->vdev, RES_TYPE_WQ);
+	fnic->raw_wq_count = fnic->wq_count - 1;
+	fnic->wq_copy_count = fnic->wq_count - fnic->raw_wq_count;
+	fnic->rq_count = vnic_dev_get_res_count(fnic->vdev, RES_TYPE_RQ);
+	fnic->cq_count = vnic_dev_get_res_count(fnic->vdev, RES_TYPE_CQ);
+	fnic->intr_count = vnic_dev_get_res_count(fnic->vdev,
+		RES_TYPE_INTR_CTRL);
+}
+
+void fnic_free_vnic_resources(struct fnic *fnic)
+{
+	unsigned int i;
+
+	for (i = 0; i < fnic->raw_wq_count; i++)
+		vnic_wq_free(&fnic->wq[i]);
+
+	for (i = 0; i < fnic->wq_copy_count; i++)
+		vnic_wq_copy_free(&fnic->wq_copy[i]);
+
+	for (i = 0; i < fnic->rq_count; i++)
+		vnic_rq_free(&fnic->rq[i]);
+
+	for (i = 0; i < fnic->cq_count; i++)
+		vnic_cq_free(&fnic->cq[i]);
+
+	for (i = 0; i < fnic->intr_count; i++)
+		vnic_intr_free(&fnic->intr[i]);
+}
+
+int fnic_alloc_vnic_resources(struct fnic *fnic)
+{
+	enum vnic_dev_intr_mode intr_mode;
+	unsigned int mask_on_assertion;
+	unsigned int interrupt_offset;
+	unsigned int error_interrupt_enable;
+	unsigned int error_interrupt_offset;
+	unsigned int i, cq_index;
+	unsigned int wq_copy_cq_desc_count;
+	int err;
+
+	intr_mode = vnic_dev_get_intr_mode(fnic->vdev);
+
+	shost_printk(KERN_INFO, fnic->lport->host, "vNIC interrupt mode: %s\n",
+		     intr_mode == VNIC_DEV_INTR_MODE_INTX ? "legacy PCI INTx" :
+		     intr_mode == VNIC_DEV_INTR_MODE_MSI ? "MSI" :
+		     intr_mode == VNIC_DEV_INTR_MODE_MSIX ?
+		     "MSI-X" : "unknown");
+
+	shost_printk(KERN_INFO, fnic->lport->host, "vNIC resources avail: "
+		     "wq %d cp_wq %d raw_wq %d rq %d cq %d intr %d\n",
+		     fnic->wq_count, fnic->wq_copy_count, fnic->raw_wq_count,
+		     fnic->rq_count, fnic->cq_count, fnic->intr_count);
+
+	/* Allocate Raw WQ used for FCS frames */
+	for (i = 0; i < fnic->raw_wq_count; i++) {
+		err = vnic_wq_alloc(fnic->vdev, &fnic->wq[i], i,
+			fnic->config.wq_enet_desc_count,
+			sizeof(struct wq_enet_desc));
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	/* Allocate Copy WQs used for SCSI IOs */
+	for (i = 0; i < fnic->wq_copy_count; i++) {
+		err = vnic_wq_copy_alloc(fnic->vdev, &fnic->wq_copy[i],
+			(fnic->raw_wq_count + i),
+			fnic->config.wq_copy_desc_count,
+			sizeof(struct fcpio_host_req));
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	/* RQ for receiving FCS frames */
+	for (i = 0; i < fnic->rq_count; i++) {
+		err = vnic_rq_alloc(fnic->vdev, &fnic->rq[i], i,
+			fnic->config.rq_desc_count,
+			sizeof(struct rq_enet_desc));
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	/* CQ for each RQ */
+	for (i = 0; i < fnic->rq_count; i++) {
+		cq_index = i;
+		err = vnic_cq_alloc(fnic->vdev,
+			&fnic->cq[cq_index], cq_index,
+			fnic->config.rq_desc_count,
+			sizeof(struct cq_enet_rq_desc));
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	/* CQ for each WQ */
+	for (i = 0; i < fnic->raw_wq_count; i++) {
+		cq_index = fnic->rq_count + i;
+		err = vnic_cq_alloc(fnic->vdev, &fnic->cq[cq_index], cq_index,
+			fnic->config.wq_enet_desc_count,
+			sizeof(struct cq_enet_wq_desc));
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	/* CQ for each COPY WQ */
+	wq_copy_cq_desc_count = (fnic->config.wq_copy_desc_count * 3);
+	for (i = 0; i < fnic->wq_copy_count; i++) {
+		cq_index = fnic->raw_wq_count + fnic->rq_count + i;
+		err = vnic_cq_alloc(fnic->vdev, &fnic->cq[cq_index],
+			cq_index,
+			wq_copy_cq_desc_count,
+			sizeof(struct fcpio_fw_req));
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	for (i = 0; i < fnic->intr_count; i++) {
+		err = vnic_intr_alloc(fnic->vdev, &fnic->intr[i], i);
+		if (err)
+			goto err_out_cleanup;
+	}
+
+	fnic->legacy_pba = vnic_dev_get_res(fnic->vdev,
+				RES_TYPE_INTR_PBA_LEGACY, 0);
+
+	if (!fnic->legacy_pba && intr_mode == VNIC_DEV_INTR_MODE_INTX) {
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "Failed to hook legacy pba resource\n");
+		err = -ENODEV;
+		goto err_out_cleanup;
+	}
+
+	/*
+	 * Init RQ/WQ resources.
+	 *
+	 * RQ[0 to n-1] point to CQ[0 to n-1]
+	 * WQ[0 to m-1] point to CQ[n to n+m-1]
+	 * WQ_COPY[0 to k-1] points to CQ[n+m to n+m+k-1]
+	 *
+	 * Note for copy wq we always initialize with cq_index = 0
+	 *
+	 * Error interrupt is not enabled for MSI.
+	 */
+
+	switch (intr_mode) {
+	case VNIC_DEV_INTR_MODE_INTX:
+	case VNIC_DEV_INTR_MODE_MSIX:
+		error_interrupt_enable = 1;
+		error_interrupt_offset = fnic->err_intr_offset;
+		break;
+	default:
+		error_interrupt_enable = 0;
+		error_interrupt_offset = 0;
+		break;
+	}
+
+	for (i = 0; i < fnic->rq_count; i++) {
+		cq_index = i;
+		vnic_rq_init(&fnic->rq[i],
+			     cq_index,
+			     error_interrupt_enable,
+			     error_interrupt_offset);
+	}
+
+	for (i = 0; i < fnic->raw_wq_count; i++) {
+		cq_index = i + fnic->rq_count;
+		vnic_wq_init(&fnic->wq[i],
+			     cq_index,
+			     error_interrupt_enable,
+			     error_interrupt_offset);
+	}
+
+	for (i = 0; i < fnic->wq_copy_count; i++) {
+		vnic_wq_copy_init(&fnic->wq_copy[i],
+				  0 /* cq_index 0 - always */,
+				  error_interrupt_enable,
+				  error_interrupt_offset);
+	}
+
+	for (i = 0; i < fnic->cq_count; i++) {
+
+		switch (intr_mode) {
+		case VNIC_DEV_INTR_MODE_MSIX:
+			interrupt_offset = i;
+			break;
+		default:
+			interrupt_offset = 0;
+			break;
+		}
+
+		vnic_cq_init(&fnic->cq[i],
+			0 /* flow_control_enable */,
+			1 /* color_enable */,
+			0 /* cq_head */,
+			0 /* cq_tail */,
+			1 /* cq_tail_color */,
+			1 /* interrupt_enable */,
+			1 /* cq_entry_enable */,
+			0 /* cq_message_enable */,
+			interrupt_offset,
+			0 /* cq_message_addr */);
+	}
+
+	/*
+	 * Init INTR resources
+	 *
+	 * mask_on_assertion is not used for INTx due to the level-
+	 * triggered nature of INTx
+	 */
+
+	switch (intr_mode) {
+	case VNIC_DEV_INTR_MODE_MSI:
+	case VNIC_DEV_INTR_MODE_MSIX:
+		mask_on_assertion = 1;
+		break;
+	default:
+		mask_on_assertion = 0;
+		break;
+	}
+
+	for (i = 0; i < fnic->intr_count; i++) {
+		vnic_intr_init(&fnic->intr[i],
+			fnic->config.intr_timer,
+			fnic->config.intr_timer_type,
+			mask_on_assertion);
+	}
+
+	/* init the stats memory by making the first call here */
+	err = vnic_dev_stats_dump(fnic->vdev, &fnic->stats);
+	if (err) {
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "vnic_dev_stats_dump failed - x%x\n", err);
+		goto err_out_cleanup;
+	}
+
+	/* Clear LIF stats */
+	vnic_dev_stats_clear(fnic->vdev);
+
+	return 0;
+
+err_out_cleanup:
+	fnic_free_vnic_resources(fnic);
+
+	return err;
+}
diff --git a/drivers/scsi/fnic/fnic_res.h b/drivers/scsi/fnic/fnic_res.h
new file mode 100644
index 0000000..b6f3102
--- /dev/null
+++ b/drivers/scsi/fnic/fnic_res.h
@@ -0,0 +1,197 @@
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#ifndef _FNIC_RES_H_
+#define _FNIC_RES_H_
+
+#include "wq_enet_desc.h"
+#include "rq_enet_desc.h"
+#include "vnic_wq.h"
+#include "vnic_rq.h"
+#include "fnic_io.h"
+#include "fcpio.h"
+#include "vnic_wq_copy.h"
+#include "vnic_cq_copy.h"
+
+static inline void fnic_queue_wq_desc(struct vnic_wq *wq,
+				      void *os_buf, dma_addr_t dma_addr,
+				      unsigned int len, unsigned int fc_eof,
+				      int vlan_tag_insert,
+				      unsigned int vlan_tag,
+				      int cq_entry, int sop, int eop)
+{
+	struct wq_enet_desc *desc = vnic_wq_next_desc(wq);
+
+	wq_enet_desc_enc(desc,
+			 (u64)dma_addr | VNIC_PADDR_TARGET,
+			 (u16)len,
+			 0, /* mss_or_csum_offset */
+			 (u16)fc_eof,
+			 0, /* offload_mode */
+			 (u8)eop, (u8)cq_entry,
+			 1, /* fcoe_encap */
+			 (u8)vlan_tag_insert,
+			 (u16)vlan_tag,
+			 0 /* loopback */);
+
+	vnic_wq_post(wq, os_buf, dma_addr, len, sop, eop);
+}
+
+static inline void fnic_queue_wq_copy_desc_icmnd_16(struct vnic_wq_copy *wq,
+						    u32 req_id,
+						    u32 lunmap_id, u8 spl_flags,
+						    u32 sgl_cnt, u32 sense_len,
+						    u64 sgl_addr, u64 sns_addr,
+						    u8 crn, u8 pri_ta,
+						    u8 flags, u8 *scsi_cdb,
+						    u32 data_len, u8 *lun,
+						    u32 d_id, u16 mss,
+						    u32 ratov, u32 edtov)
+{
+	struct fcpio_host_req *desc = vnic_wq_copy_next_desc(wq);
+
+	desc->hdr.type = FCPIO_ICMND_16; /* enum fcpio_type */
+	desc->hdr.status = 0;            /* header status entry */
+	desc->hdr._resvd = 0;            /* reserved */
+	desc->hdr.tag.u.req_id = req_id; /* id for this request */
+
+	desc->u.icmnd_16.lunmap_id = lunmap_id; /* index into lunmap table */
+	desc->u.icmnd_16.special_req_flags = spl_flags; /* exch req flags */
+	desc->u.icmnd_16._resvd0[0] = 0;        /* reserved */
+	desc->u.icmnd_16._resvd0[1] = 0;        /* reserved */
+	desc->u.icmnd_16._resvd0[2] = 0;        /* reserved */
+	desc->u.icmnd_16.sgl_cnt = sgl_cnt;     /* scatter-gather list count */
+	desc->u.icmnd_16.sense_len = sense_len; /* sense buffer length */
+	desc->u.icmnd_16.sgl_addr = sgl_addr;   /* scatter-gather list addr */
+	desc->u.icmnd_16.sense_addr = sns_addr; /* sense buffer address */
+	desc->u.icmnd_16.crn = crn;             /* SCSI Command Reference No.*/
+	desc->u.icmnd_16.pri_ta = pri_ta; 	/* SCSI Pri & Task attribute */
+	desc->u.icmnd_16._resvd1 = 0;           /* reserved: should be 0 */
+	desc->u.icmnd_16.flags = flags;         /* command flags */
+	memcpy(desc->u.icmnd_16.scsi_cdb, scsi_cdb, CDB_16);    /* SCSI CDB */
+	desc->u.icmnd_16.data_len = data_len;   /* length of data expected */
+	memcpy(desc->u.icmnd_16.lun, lun, LUN_ADDRESS);  /* LUN address */
+	desc->u.icmnd_16._resvd2 = 0;          	/* reserved */
+	hton24(desc->u.icmnd_16.d_id, d_id);	/* FC vNIC only: Target D_ID */
+	desc->u.icmnd_16.mss = mss;            	/* FC vNIC only: max burst */
+	desc->u.icmnd_16.r_a_tov = ratov; /*FC vNIC only: Res. Alloc Timeout */
+	desc->u.icmnd_16.e_d_tov = edtov; /*FC vNIC only: Err Detect Timeout */
+
+	vnic_wq_copy_post(wq);
+}
+
+static inline void fnic_queue_wq_copy_desc_itmf(struct vnic_wq_copy *wq,
+						u32 req_id, u32 lunmap_id,
+						u32 tm_req, u32 tm_id, u8 *lun,
+						u32 d_id, u32 r_a_tov,
+						u32 e_d_tov)
+{
+	struct fcpio_host_req *desc = vnic_wq_copy_next_desc(wq);
+
+	desc->hdr.type = FCPIO_ITMF;     /* enum fcpio_type */
+	desc->hdr.status = 0;            /* header status entry */
+	desc->hdr._resvd = 0;            /* reserved */
+	desc->hdr.tag.u.req_id = req_id; /* id for this request */
+
+	desc->u.itmf.lunmap_id = lunmap_id; /* index into lunmap table */
+	desc->u.itmf.tm_req = tm_req;       /* SCSI Task Management request */
+	desc->u.itmf.t_tag = tm_id;         /* tag of fcpio to be aborted */
+	desc->u.itmf._resvd = 0;
+	memcpy(desc->u.itmf.lun, lun, LUN_ADDRESS);  /* LUN address */
+	desc->u.itmf._resvd1 = 0;
+	hton24(desc->u.itmf.d_id, d_id);    /* FC vNIC only: Target D_ID */
+	desc->u.itmf.r_a_tov = r_a_tov;     /* FC vNIC only: R_A_TOV in msec */
+	desc->u.itmf.e_d_tov = e_d_tov;     /* FC vNIC only: E_D_TOV in msec */
+
+	vnic_wq_copy_post(wq);
+}
+
+static inline void fnic_queue_wq_copy_desc_flogi_reg(struct vnic_wq_copy *wq,
+						     u32 req_id, u8 format,
+						     u32 s_id, u8 *gw_mac)
+{
+	struct fcpio_host_req *desc = vnic_wq_copy_next_desc(wq);
+
+	desc->hdr.type = FCPIO_FLOGI_REG;     /* enum fcpio_type */
+	desc->hdr.status = 0;                 /* header status entry */
+	desc->hdr._resvd = 0;                 /* reserved */
+	desc->hdr.tag.u.req_id = req_id;      /* id for this request */
+
+	desc->u.flogi_reg.format = format;
+	hton24(desc->u.flogi_reg.s_id, s_id);
+	memcpy(desc->u.flogi_reg.gateway_mac, gw_mac, ETH_ALEN);
+
+	vnic_wq_copy_post(wq);
+}
+
+static inline void fnic_queue_wq_copy_desc_fw_reset(struct vnic_wq_copy *wq,
+						    u32 req_id)
+{
+	struct fcpio_host_req *desc = vnic_wq_copy_next_desc(wq);
+
+	desc->hdr.type = FCPIO_RESET;     /* enum fcpio_type */
+	desc->hdr.status = 0;             /* header status entry */
+	desc->hdr._resvd = 0;             /* reserved */
+	desc->hdr.tag.u.req_id = req_id;  /* id for this request */
+
+	vnic_wq_copy_post(wq);
+}
+
+static inline void fnic_queue_wq_copy_desc_lunmap(struct vnic_wq_copy *wq,
+						  u32 req_id, u64 lunmap_addr,
+						  u32 lunmap_len)
+{
+	struct fcpio_host_req *desc = vnic_wq_copy_next_desc(wq);
+
+	desc->hdr.type = FCPIO_LUNMAP_REQ;	/* enum fcpio_type */
+	desc->hdr.status = 0;			/* header status entry */
+	desc->hdr._resvd = 0;			/* reserved */
+	desc->hdr.tag.u.req_id = req_id;	/* id for this request */
+
+	desc->u.lunmap_req.addr = lunmap_addr;	/* address of the buffer */
+	desc->u.lunmap_req.len = lunmap_len;	/* len of the buffer */
+
+	vnic_wq_copy_post(wq);
+}
+
+static inline void fnic_queue_rq_desc(struct vnic_rq *rq,
+				      void *os_buf, dma_addr_t dma_addr,
+				      u16 len)
+{
+	struct rq_enet_desc *desc = vnic_rq_next_desc(rq);
+
+	rq_enet_desc_enc(desc,
+		(u64)dma_addr | VNIC_PADDR_TARGET,
+		RQ_ENET_TYPE_ONLY_SOP,
+		(u16)len);
+
+	vnic_rq_post(rq, os_buf, 0, dma_addr, len);
+}
+
+
+struct fnic;
+
+int fnic_get_vnic_config(struct fnic *);
+int fnic_alloc_vnic_resources(struct fnic *);
+void fnic_free_vnic_resources(struct fnic *);
+void fnic_get_res_counts(struct fnic *);
+int fnic_set_nic_config(struct fnic *fnic, u8 rss_default_cpu,
+			u8 rss_hash_type, u8 rss_hash_bits, u8 rss_base_cpu,
+			u8 rss_enable, u8 tso_ipid_split_en,
+			u8 ig_vlan_strip_en);
+
+#endif /* _FNIC_RES_H_ */


