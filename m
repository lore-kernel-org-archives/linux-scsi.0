From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [RFC] [PATCH 5/5] bnx2fc: Broadcom FCoE offload driver
 submission - part 3
Date: Thu, 9 Dec 2010 10:53:54 -0800
Message-ID: <1291920835.5480.161.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4308 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725Ab0LISyl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2010 13:54:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Michael Chan <mchan@broadcom.com>

This patch contains code that interfaces with libfc, libfcoe
and cnic modules to create FCoE instances, send/receive
non-offload FIP/FCoE packets, listen to link events, etc.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/Kconfig              |    1 +
 drivers/scsi/Makefile             |    1 +
 drivers/scsi/bnx2fc/Kconfig       |   11 +
 drivers/scsi/bnx2fc/Makefile      |    3 +
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2320 +++++++++++++++++++++++++++++++++++++
 5 files changed, 2336 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/bnx2fc/Kconfig
 create mode 100644 drivers/scsi/bnx2fc/Makefile
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_fcoe.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 8616496..4a1f029 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -381,6 +381,7 @@ config ISCSI_BOOT_SYSFS
 
 source "drivers/scsi/cxgbi/Kconfig"
 source "drivers/scsi/bnx2i/Kconfig"
+source "drivers/scsi/bnx2fc/Kconfig"
 source "drivers/scsi/be2iscsi/Kconfig"
 
 config SGIWD93_SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 2e9a87e..b57c532 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_LIBFC)		+= libfc/
 obj-$(CONFIG_LIBFCOE)		+= fcoe/
 obj-$(CONFIG_FCOE)		+= fcoe/
 obj-$(CONFIG_FCOE_FNIC)		+= fnic/
+obj-$(CONFIG_SCSI_BNX2X_FCOE)	+= libfc/ fcoe/ bnx2fc/
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	libiscsi_tcp.o iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
 obj-$(CONFIG_ISCSI_BOOT_SYSFS)	+= iscsi_boot_sysfs.o
diff --git a/drivers/scsi/bnx2fc/Kconfig b/drivers/scsi/bnx2fc/Kconfig
new file mode 100644
index 0000000..6a38080
--- /dev/null
+++ b/drivers/scsi/bnx2fc/Kconfig
@@ -0,0 +1,11 @@
+config SCSI_BNX2X_FCOE
+	tristate "Broadcom NetXtreme II FCoE support"
+	depends on PCI
+	select NETDEVICES
+	select NETDEV_1000
+	select LIBFC
+	select LIBFCOE
+	select CNIC
+	---help---
+	This driver supports FCoE offload for the Broadcom NetXtreme II
+	devices.
diff --git a/drivers/scsi/bnx2fc/Makefile b/drivers/scsi/bnx2fc/Makefile
new file mode 100644
index 0000000..a92695a
--- /dev/null
+++ b/drivers/scsi/bnx2fc/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SCSI_BNX2X_FCOE) += bnx2fc.o
+
+bnx2fc-y := bnx2fc_els.o bnx2fc_fcoe.o bnx2fc_hwi.o bnx2fc_io.o bnx2fc_tgt.o
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
new file mode 100644
index 0000000..f2abc3a
--- /dev/null
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -0,0 +1,2320 @@
+/* bnx2fc_fcoe.c: Broadcom NetXtreme II Linux FCoE offload driver.
+ *
+ * Copyright (c) 2008 - 2010 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ *
+ * Written by: Bhanu Prakash Gollapudi (bprakash@broadcom.com)
+ */
+
+#include "bnx2fc.h"
+
+static struct list_head adapter_list;
+static u32 adapter_count;
+static DEFINE_MUTEX(bnx2fc_dev_lock);
+
+#define DRV_MODULE_NAME		"bnx2fc"
+#define DRV_MODULE_VERSION	BNX2FC_VERSION
+#define DRV_MODULE_RELDATE	"09/08/10"
+
+
+static char version[] __devinitdata =
+		"Broadcom NetXtreme II FCoE Driver " DRV_MODULE_NAME \
+		" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
+
+
+MODULE_AUTHOR("Bhanu Prakash Gollapudi <bprakash@broadcom.com>");
+MODULE_DESCRIPTION("Broadcom NetXtreme II BCM57710 FCoE Driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_MODULE_VERSION);
+
+#define FCOE_LOW_QUEUE_DEPTH	32
+#define FCOE_GW_ADDR_MODE           0x00
+#define FCOE_FCOUI_ADDR_MODE        0x01
+
+#define FCOE_WORD_TO_BYTE  4
+
+static struct scsi_transport_template	*bnx2fc_transport_template;
+static struct scsi_transport_template	*bnx2fc_vport_xport_template;
+
+struct bnx2fc_global_s bnx2fc_global;
+
+static struct cnic_ulp_ops bnx2fc_cnic_cb;
+static struct libfc_function_template bnx2fc_libfc_fcn_templ;
+static struct scsi_host_template bnx2fc_shost_template;
+static struct fc_function_template bnx2fc_transport_function;
+static struct fc_function_template bnx2fc_vport_xport_function;
+static int bnx2fc_create(const char *, struct kernel_param *);
+static int bnx2fc_destroy(const char *, struct kernel_param *);
+
+static void bnx2fc_recv_frame(struct sk_buff *skb);
+
+static u64 bnx2fc_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
+		      unsigned int scheme, unsigned int port);
+static inline int bnx2fc_start_io(struct sk_buff *skb);
+static void bnx2fc_start_disc(struct bnx2fc_hba *hba);
+static void bnx2fc_check_wait_queue(struct fc_lport *lp, struct sk_buff *skb);
+static int bnx2fc_shost_config(struct fc_lport *lp);
+static int bnx2fc_net_config(struct fc_lport *lp);
+static int bnx2fc_lport_config(struct fc_lport *lport,
+			       struct Scsi_Host *shost);
+static int bnx2fc_em_config(struct fc_lport *lport);
+static int bnx2fc_bind_adapter_devices(struct bnx2fc_hba *hba);
+static void bnx2fc_unbind_adapter_devices(struct bnx2fc_hba *hba);
+static int bnx2fc_bind_pcidev(struct bnx2fc_hba *hba);
+static void bnx2fc_unbind_pcidev(struct bnx2fc_hba *hba);
+static struct fc_lport *bnx2fc_if_create(struct bnx2fc_hba *hba,
+				  struct device *parent, int npiv);
+static void bnx2fc_destroy_work(struct work_struct *work);
+
+static struct net_device *bnx2fc_if_to_netdev(const char *buffer);
+static struct bnx2fc_hba *bnx2fc_hba_lookup(struct net_device *phys_dev);
+static struct bnx2fc_hba *bnx2fc_find_hba_for_cnic(struct cnic_dev *cnic);
+
+static void bnx2fc_port_shutdown(struct fc_lport *lport);
+static void bnx2fc_stop(struct bnx2fc_hba *hba);
+static int __init bnx2fc_mod_init(void);
+static void __exit bnx2fc_mod_exit(void);
+
+unsigned long bnx2fc_debug_level;
+module_param(bnx2fc_debug_level, long, 0644);
+module_param_call(create, bnx2fc_create, NULL, (void *)FIP_MODE_FABRIC,
+		  S_IWUSR);
+__MODULE_PARM_TYPE(create, "string");
+MODULE_PARM_DESC(create, " Creates fcoe instance on a ethernet interface");
+module_param_call(destroy, bnx2fc_destroy, NULL, NULL, S_IWUSR);
+__MODULE_PARM_TYPE(destroy, "string");
+MODULE_PARM_DESC(destroy, " Destroys fcoe instance on a ethernet interface");
+
+/*
+MODULE_PARM_DESC(bnx2fc_debug_level, "Bit mask to enable debug logging,\n\t\t"
+		"LOG_IOERR	0x00000001\n\t\t"
+		"LOG_SESS	0x00000002\n\t\t"
+		"LOG_DEV_EVT	0x00000004\n\t\t"
+		"LOG_ELS	0x00000008\n\t\t"
+		"LOG_FRAME	0x00000010\n\t\t"
+		"LOG_INIT	0x00000020\n\t\t"
+		"LOG_ALL	0xffffffff\n"
+		);
+*/
+
+#define FCOE_MAX_QUEUE_DEPTH 256
+
+static u64 bnx2fc_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
+		      unsigned int scheme, unsigned int port)
+{
+	u64 wwn;
+	u64 host_mac;
+
+	/* The MAC is in NO, so flip only the low 48 bits */
+	host_mac = ((u64) mac[0] << 40) |
+		((u64) mac[1] << 32) |
+		((u64) mac[2] << 24) |
+		((u64) mac[3] << 16) |
+		((u64) mac[4] << 8) |
+		(u64) mac[5];
+
+	WARN_ON(host_mac >= (1ULL << 48));
+	wwn = host_mac | ((u64) scheme << 60);
+	switch (scheme) {
+	case 1:
+		WARN_ON(port != 0);
+		break;
+	case 2:
+		WARN_ON(port >= 0xfff);
+		wwn |= (u64) port << 48;
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	return wwn;
+}
+static inline int bnx2fc_start_io(struct sk_buff *skb)
+{
+	struct sk_buff *nskb;
+	int rc;
+
+	nskb = skb_clone(skb, GFP_ATOMIC);
+	rc = dev_queue_xmit(nskb);
+	if (rc != 0)
+		return rc;
+	kfree_skb(skb);
+	return 0;
+}
+
+static void bnx2fc_clean_rx_queue(struct fc_lport *lp)
+{
+	struct bnx2fc_global_s *bg;
+	struct fcoe_rcv_info *fr;
+	struct sk_buff_head *list;
+	struct sk_buff *skb, *next;
+	struct sk_buff *head;
+
+	bg = &bnx2fc_global;
+	spin_lock_bh(&bg->fcoe_rx_list.lock);
+	list = &bg->fcoe_rx_list;
+	head = list->next;
+	for (skb = head; skb != (struct sk_buff *)list;
+	     skb = next) {
+		next = skb->next;
+		fr = fcoe_dev_from_skb(skb);
+		if (fr->fr_dev == lp) {
+			__skb_unlink(skb, list);
+			kfree_skb(skb);
+		}
+	}
+	spin_unlock_bh(&bg->fcoe_rx_list.lock);
+}
+
+static void bnx2fc_queue_timer(ulong lport)
+{
+	bnx2fc_check_wait_queue((struct fc_lport *) lport, NULL);
+}
+
+static void bnx2fc_clean_pending_queue(struct fc_lport *lp)
+{
+	struct bnx2fc_port *port;
+	struct sk_buff *skb;
+	port = lport_priv(lp);
+
+	spin_lock_bh(&port->fcoe_pending_queue.lock);
+	while ((skb = __skb_dequeue(&port->fcoe_pending_queue)) != NULL) {
+		spin_unlock_bh(&port->fcoe_pending_queue.lock);
+		kfree_skb(skb);
+		spin_lock_bh(&port->fcoe_pending_queue.lock);
+	}
+	spin_unlock_bh(&port->fcoe_pending_queue.lock);
+}
+
+static void bnx2fc_check_wait_queue(struct fc_lport *lp, struct sk_buff *skb)
+{
+	struct bnx2fc_port *port = lport_priv(lp);
+	int rc = 0;
+
+	spin_lock_bh(&port->fcoe_pending_queue.lock);
+
+	if (skb)
+		__skb_queue_tail(&port->fcoe_pending_queue, skb);
+
+	if (port->fcoe_pending_queue_active)
+		goto out;
+	port->fcoe_pending_queue_active = 1;
+
+	while (port->fcoe_pending_queue.qlen) {
+		/* keep qlen > 0 until bnx2fc_start_io succeeds */
+		port->fcoe_pending_queue.qlen++;
+		skb = __skb_dequeue(&port->fcoe_pending_queue);
+
+		spin_unlock_bh(&port->fcoe_pending_queue.lock);
+		rc = bnx2fc_start_io(skb);
+		spin_lock_bh(&port->fcoe_pending_queue.lock);
+
+		if (rc) {
+			__skb_queue_head(&port->fcoe_pending_queue, skb);
+			/* undo temporary increment above */
+			port->fcoe_pending_queue.qlen--;
+			break;
+		}
+		/* undo temporary increment above */
+		port->fcoe_pending_queue.qlen--;
+	}
+
+	if (port->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH)
+		lp->qfull = 0;
+	if (port->fcoe_pending_queue.qlen && !timer_pending(&port->timer))
+		mod_timer(&port->timer, jiffies + 2);
+	port->fcoe_pending_queue_active = 0;
+out:
+	if (port->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
+		lp->qfull = 1;
+	spin_unlock_bh(&port->fcoe_pending_queue.lock);
+	return;
+}
+
+u32 bnx2fc_crc(struct fc_frame *fp)
+{
+	struct sk_buff *skb = fp_skb(fp);
+	struct skb_frag_struct *frag;
+	unsigned char *data;
+	unsigned long off, len, clen;
+	u32 crc;
+	unsigned i;
+
+	crc = crc32(~0, skb->data, skb_headlen(skb));
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		frag = &skb_shinfo(skb)->frags[i];
+		off = frag->page_offset;
+		len = frag->size;
+		while (len > 0) {
+			clen = min(len, PAGE_SIZE - (off & ~PAGE_MASK));
+			data = kmap_atomic(frag->page + (off >> PAGE_SHIFT),
+					   KM_SKB_DATA_SOFTIRQ);
+			crc = crc32(crc, data + (off & ~PAGE_MASK), clen);
+			kunmap_atomic(data, KM_SKB_DATA_SOFTIRQ);
+			off += clen;
+			len -= clen;
+		}
+	}
+	return crc;
+}
+int bnx2fc_get_paged_crc_eof(struct sk_buff *skb, int tlen)
+{
+	struct bnx2fc_global_s *bg;
+	struct page *page;
+
+	bg = &bnx2fc_global;
+	page = bg->crc_eof_page;
+	if (!page) {
+		page = alloc_page(GFP_ATOMIC);
+		if (!page)
+			return -ENOMEM;
+		bg->crc_eof_page = page;
+		bg->crc_eof_offset = 0;
+	}
+
+	get_page(page);
+	skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags, page,
+			   bg->crc_eof_offset, tlen);
+	skb->len += tlen;
+	skb->data_len += tlen;
+	skb->truesize += tlen;
+	bg->crc_eof_offset += sizeof(struct fcoe_crc_eof);
+
+	if (bg->crc_eof_offset >= PAGE_SIZE) {
+		bg->crc_eof_page = NULL;
+		bg->crc_eof_offset = 0;
+		put_page(page);
+	}
+	return 0;
+}
+
+static void bnx2fc_abort_io(struct fc_lport *lport)
+{
+	bnx2fc_dbg(LOG_IOERR, "Entered bnx2fc_abort_io\n");
+
+}
+
+static void bnx2fc_cleanup(struct fc_lport *lport)
+{
+	struct bnx2fc_port *port = lport_priv(lport);
+	struct bnx2fc_hba *hba = port->hba;
+	struct bnx2fc_rport *tgt;
+	int i;
+
+	bnx2fc_dbg(LOG_IOERR, "Entered bnx2fc_cleanup\n");
+	mutex_lock(&hba->hba_mutex);
+	spin_lock_bh(&hba->hba_lock);
+	for (i = 0; i < BNX2FC_NUM_MAX_SESS; i++) {
+		tgt = hba->tgt_ofld_list[i];
+		if (tgt) {
+			/* Cleanup IOs belonging to requested vport */
+			if (tgt->port == port) {
+				spin_unlock_bh(&hba->hba_lock);
+				bnx2fc_dbg(LOG_IOERR, "flush/cleanup\n");
+				bnx2fc_flush_active_ios(tgt);
+				spin_lock_bh(&hba->hba_lock);
+			}
+		}
+	}
+	spin_unlock_bh(&hba->hba_lock);
+	mutex_unlock(&hba->hba_mutex);
+}
+
+static int bnx2fc_xmit_l2_frame(struct bnx2fc_rport *tgt,
+			     struct fc_frame *fp)
+{
+	struct fc_rport_priv *rdata = tgt->rdata;
+	struct fc_frame_header *fh;
+	int rc = 0;
+
+	fh = fc_frame_header_get(fp);
+	bnx2fc_dbg(LOG_FRAME, "Xmit L2 frame rport = 0x%x, oxid = 0x%x, "
+			"r_ctl = 0x%x\n", rdata->ids.port_id,
+			ntohs(fh->fh_ox_id), fh->fh_r_ctl);
+	if ((fh->fh_type == FC_TYPE_ELS) &&
+	    (fh->fh_r_ctl == FC_RCTL_ELS_REQ)) {
+
+		switch (fc_frame_payload_op(fp)) {
+		case ELS_ADISC:
+			rc = bnx2fc_send_adisc(tgt, fp);
+			break;
+		case ELS_LOGO:
+			rc = bnx2fc_send_logo(tgt, fp);
+			break;
+		default:
+			break;
+		}
+	} else if ((fh->fh_type ==  FC_TYPE_BLS) &&
+	    (fh->fh_r_ctl == FC_RCTL_BA_ABTS))
+		bnx2fc_dbg(LOG_FRAME, "ABTS frame\n");
+	else {
+		bnx2fc_dbg(LOG_FRAME, "Send L2 frame type 0x%x "
+				"rctl 0x%x thru non-offload path\n",
+				fh->fh_type, fh->fh_r_ctl);
+		return -ENODEV;
+	}
+	if (rc)
+		return -ENOMEM;
+	else
+		return 0;
+}
+
+/**
+ * bnx2fc_xmit - bnx2fc's FCoE frame transmit function
+ * @lport:	the associated local port
+ * @fp:	the fc_frame to be transmitted
+ */
+static int bnx2fc_xmit(struct fc_lport *lport, struct fc_frame *fp)
+{
+	struct ethhdr		*eh;
+	struct fcoe_crc_eof	*cp;
+	struct sk_buff		*skb;
+	struct fc_frame_header	*fh;
+	struct bnx2fc_hba	*hba;
+	struct bnx2fc_port	*port;
+	struct fcoe_hdr		*hp;
+	struct bnx2fc_rport	*tgt;
+	struct fcoe_dev_stats	*stats;
+	u8			sof, eof;
+	u32			crc;
+	unsigned int		hlen, tlen, elen;
+	int			wlen, rc = 0;
+
+	port = (struct bnx2fc_port *)lport_priv(lport);
+	hba = port->hba;
+
+	fh = fc_frame_header_get(fp);
+
+	skb = fp_skb(fp);
+	if (!lport->link_up) {
+		bnx2fc_dbg(LOG_FRAME, "bnx2fc_xmit link down\n");
+		kfree_skb(skb);
+		return 0;
+	}
+
+	if (unlikely(fh->fh_r_ctl == FC_RCTL_ELS_REQ)) {
+		if (!hba->ctlr.sel_fcf) {
+			bnx2fc_dbg(LOG_FRAME, "FCF not selected yet!\n");
+			kfree_skb(skb);
+			return -EINVAL;
+		}
+		if (fcoe_ctlr_els_send(&hba->ctlr, lport, skb))
+			return 0;
+	}
+
+	sof = fr_sof(fp);
+	eof = fr_eof(fp);
+
+	/*
+	 * Snoop the frame header to check if the frame is for
+	 * an offloaded session
+	 */
+	/*
+	 * tgt_ofld_list access is synchronized using
+	 * both hba mutex and hba lock. Atleast hba mutex or
+	 * hba lock needs to be held for read access.
+	 */
+
+	spin_lock_bh(&hba->hba_lock);
+	tgt = bnx2fc_tgt_lookup(port, ntoh24(fh->fh_d_id));
+	if (tgt && (test_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags))) {
+		/* This frame is for offloaded session */
+		bnx2fc_dbg(LOG_SESS, "xmit: Frame is for offloaded session "
+				"port_id = 0x%x\n", ntoh24(fh->fh_d_id));
+		spin_unlock_bh(&hba->hba_lock);
+		rc = bnx2fc_xmit_l2_frame(tgt, fp);
+		if (rc != -ENODEV) {
+			kfree_skb(skb);
+			return rc;
+		}
+	} else {
+		spin_unlock_bh(&hba->hba_lock);
+	}
+
+	elen = sizeof(struct ethhdr);
+	hlen = sizeof(struct fcoe_hdr);
+	tlen = sizeof(struct fcoe_crc_eof);
+	wlen = (skb->len - tlen + sizeof(crc)) / FCOE_WORD_TO_BYTE;
+
+	skb->ip_summed = CHECKSUM_NONE;
+	crc = bnx2fc_crc(fp);
+
+	/* copy port crc and eof to the skb buff */
+	if (skb_is_nonlinear(skb)) {
+		skb_frag_t *frag;
+		if (bnx2fc_get_paged_crc_eof(skb, tlen)) {
+			kfree_skb(skb);
+			return -ENOMEM;
+		}
+		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];
+		cp = kmap_atomic(frag->page, KM_SKB_DATA_SOFTIRQ)
+				+ frag->page_offset;
+	} else {
+		cp = (struct fcoe_crc_eof *)skb_put(skb, tlen);
+	}
+
+	memset(cp, 0, sizeof(*cp));
+	cp->fcoe_eof = eof;
+	cp->fcoe_crc32 = cpu_to_le32(~crc);
+	if (skb_is_nonlinear(skb)) {
+		kunmap_atomic(cp, KM_SKB_DATA_SOFTIRQ);
+		cp = NULL;
+	}
+
+	/* adjust skb network/transport offsets to match mac/fcoe/port */
+	skb_push(skb, elen + hlen);
+	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+	skb->mac_len = elen;
+	skb->protocol = htons(ETH_P_FCOE);
+	skb->dev = hba->netdev;
+
+	/* fill up mac and fcoe headers */
+	eh = eth_hdr(skb);
+	eh->h_proto = htons(ETH_P_FCOE);
+	if (hba->ctlr.map_dest)
+		fc_fcoe_set_mac(eh->h_dest, fh->fh_d_id);
+	else
+		/* insert GW address */
+		memcpy(eh->h_dest, hba->ctlr.dest_addr, ETH_ALEN);
+
+	if (unlikely(hba->ctlr.flogi_oxid != FC_XID_UNKNOWN))
+		memcpy(eh->h_source, hba->ctlr.ctl_src_addr, ETH_ALEN);
+	else
+		memcpy(eh->h_source, port->data_src_addr, ETH_ALEN);
+
+	hp = (struct fcoe_hdr *)(eh + 1);
+	memset(hp, 0, sizeof(*hp));
+	if (FC_FCOE_VER)
+		FC_FCOE_ENCAPS_VER(hp, FC_FCOE_VER);
+	hp->fcoe_sof = sof;
+
+	/* fcoe lso, mss is in max_payload which is non-zero for FCP data */
+	if (lport->seq_offload && fr_max_payload(fp)) {
+		skb_shinfo(skb)->gso_type = SKB_GSO_FCOE;
+		skb_shinfo(skb)->gso_size = fr_max_payload(fp);
+	} else {
+		skb_shinfo(skb)->gso_type = 0;
+		skb_shinfo(skb)->gso_size = 0;
+	}
+
+	/*update tx stats */
+	stats = per_cpu_ptr(lport->dev_stats, get_cpu());
+	stats->TxFrames++;
+	stats->TxWords += wlen;
+	put_cpu();
+
+	/* send down to lld */
+	fr_dev(fp) = lport;
+	if (port->fcoe_pending_queue.qlen)
+		bnx2fc_check_wait_queue(lport, skb);
+	else if (bnx2fc_start_io(skb))
+		bnx2fc_check_wait_queue(lport, skb);
+
+	return 0;
+}
+
+/**
+ * bnx2fc_rcv - This is bnx2fc's receive function called by NET_RX_SOFTIRQ
+ * @skb:	the receive socket buffer
+ * @dev:	associated net device
+ * @ptype:	context
+ * @olddev:	last device
+ *
+ * This function receives the packet and builds FC frame and passes it up
+ */
+static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
+		struct packet_type *ptype, struct net_device *olddev)
+{
+	struct fc_lport *lport;
+	struct bnx2fc_hba *hba;
+	struct fc_frame_header *fh;
+	struct fcoe_rcv_info *fr;
+	struct bnx2fc_global_s *bg;
+	unsigned short oxid;
+
+	hba = container_of(ptype, struct bnx2fc_hba, fcoe_packet_type);
+	lport = hba->ctlr.lp;
+
+	if (unlikely(lport == NULL)) {
+		printk(KERN_ALERT PFX "bnx2fc_rcv: lport is NULL\n");
+		goto err;
+	}
+
+	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
+		printk(KERN_ALERT PFX "bnx2fc_rcv: Wrong FC type frame\n");
+		goto err;
+	}
+
+	/*
+	 * Check for minimum frame length, and make sure required FCoE
+	 * and FC headers are pulled into the linear data area.
+	 */
+	if (unlikely((skb->len < FCOE_MIN_FRAME) ||
+	    !pskb_may_pull(skb, FCOE_HEADER_LEN)))
+		goto err;
+
+	skb_set_transport_header(skb, sizeof(struct fcoe_hdr));
+	fh = (struct fc_frame_header *) skb_transport_header(skb);
+
+	oxid = ntohs(fh->fh_ox_id);
+
+	fr = fcoe_dev_from_skb(skb);
+	fr->fr_dev = lport;
+	fr->ptype = ptype;
+
+	bg = &bnx2fc_global;
+	spin_lock_bh(&bg->fcoe_rx_list.lock);
+
+	__skb_queue_tail(&bg->fcoe_rx_list, skb);
+	if (bg->fcoe_rx_list.qlen == 1)
+		wake_up_process(bg->l2_thread);
+
+	spin_unlock_bh(&bg->fcoe_rx_list.lock);
+
+	return 0;
+err:
+	kfree_skb(skb);
+	return -1;
+}
+
+static int bnx2fc_l2_rcv_thread(void *arg)
+{
+	struct bnx2fc_global_s *bg = arg;
+	struct sk_buff *skb;
+
+	while (!kthread_should_stop()) {
+		spin_lock_bh(&bg->fcoe_rx_list.lock);
+		while ((skb = __skb_dequeue(&bg->fcoe_rx_list)) == NULL) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			spin_unlock_bh(&bg->fcoe_rx_list.lock);
+			schedule();
+			set_current_state(TASK_RUNNING);
+			if (kthread_should_stop())
+				return 0;
+			spin_lock_bh(&bg->fcoe_rx_list.lock);
+		}
+		spin_unlock_bh(&bg->fcoe_rx_list.lock);
+		bnx2fc_recv_frame(skb);
+	}
+	return 0;
+}
+
+
+static void bnx2fc_recv_frame(struct sk_buff *skb)
+{
+	u32 fr_len;
+	struct fc_lport *lport;
+	struct fcoe_rcv_info *fr;
+	struct fcoe_dev_stats *stats;
+	struct fc_frame_header *fh;
+	struct fcoe_crc_eof crc_eof;
+	struct fc_frame *fp;
+	struct fc_lport *vn_port;
+	struct bnx2fc_port *port;
+	u8 *mac = NULL;
+	u8 *dest_mac = NULL;
+	struct fcoe_hdr *hp;
+
+	fr = fcoe_dev_from_skb(skb);
+	lport = fr->fr_dev;
+	if (unlikely(lport == NULL)) {
+		printk(KERN_ALERT PFX "Invalid lport struct\n");
+		kfree_skb(skb);
+		return;
+	}
+
+	if (skb_is_nonlinear(skb))
+		skb_linearize(skb);
+	mac = eth_hdr(skb)->h_source;
+	dest_mac = eth_hdr(skb)->h_dest;
+
+	/* Pull the header */
+	hp = (struct fcoe_hdr *) skb_network_header(skb);
+	fh = (struct fc_frame_header *) skb_transport_header(skb);
+	skb_pull(skb, sizeof(struct fcoe_hdr));
+	fr_len = skb->len - sizeof(struct fcoe_crc_eof);
+
+	stats = per_cpu_ptr(lport->dev_stats, get_cpu());
+	stats->RxFrames++;
+	stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
+
+	fp = (struct fc_frame *)skb;
+	fc_frame_init(fp);
+	fr_dev(fp) = lport;
+	fr_sof(fp) = hp->fcoe_sof;
+	if (skb_copy_bits(skb, fr_len, &crc_eof, sizeof(crc_eof))) {
+		put_cpu();
+		kfree_skb(skb);
+		return;
+	}
+	fr_eof(fp) = crc_eof.fcoe_eof;
+	fr_crc(fp) = crc_eof.fcoe_crc32;
+	if (pskb_trim(skb, fr_len)) {
+		put_cpu();
+		kfree_skb(skb);
+		return;
+	}
+
+	fh = fc_frame_header_get(fp);
+
+	vn_port = fc_vport_id_lookup(lport, ntoh24(fh->fh_d_id));
+	if (vn_port) {
+		port = lport_priv(vn_port);
+		if (compare_ether_addr(port->data_src_addr, dest_mac)
+		    != 0) {
+			bnx2fc_dbg(LOG_FRAME, "fpma mismatch\n");
+			put_cpu();
+			kfree_skb(skb);
+			return;
+		}
+	}
+	if (fh->fh_r_ctl == FC_RCTL_DD_SOL_DATA &&
+	    fh->fh_type == FC_TYPE_FCP) {
+		bnx2fc_dbg(LOG_INIT, "DD_SOL_DATA\n");
+		/* Drop FCP data. We dont this in L2 path */
+		put_cpu();
+		kfree_skb(skb);
+		return;
+	}
+	if (le32_to_cpu(fr_crc(fp)) !=
+			~crc32(~0, skb->data, fr_len)) {
+		if (stats->InvalidCRCCount < 5)
+			printk(KERN_WARNING PFX "dropping frame with "
+			       "CRC error\n");
+		stats->InvalidCRCCount++;
+		put_cpu();
+		kfree_skb(skb);
+		return;
+	}
+	put_cpu();
+	fc_exch_recv(lport, fp);
+}
+
+static struct fc_host_statistics *bnx2fc_get_host_stats(struct Scsi_Host *shost)
+{
+	struct fc_host_statistics *bnx2fc_stats;
+	struct fc_lport *lport = shost_priv(shost);
+	struct bnx2fc_port *port = lport_priv(lport);
+	struct bnx2fc_hba *hba = port->hba;
+	struct fcoe_statistics_params *fw_stats;
+	int rc = 0;
+
+	fw_stats = (struct fcoe_statistics_params *)hba->stats_buffer;
+	bnx2fc_stats = fc_get_host_stats(shost);
+
+	init_completion(&hba->stat_req_done);
+	if (bnx2fc_send_stat_req(hba))
+		return bnx2fc_stats;
+	rc = wait_for_completion_timeout(&hba->stat_req_done, (2 * HZ));
+	if (!rc) {
+		bnx2fc_dbg(LOG_INIT, "FW stat req timed out\n");
+		return bnx2fc_stats;
+	}
+	bnx2fc_stats->invalid_crc_count += fw_stats->rx_stat1.fc_crc_cnt;
+	bnx2fc_stats->tx_frames += fw_stats->tx_stat.fcoe_tx_pkt_cnt;
+	bnx2fc_stats->tx_words += (fw_stats->tx_stat.fcoe_tx_byte_cnt) / 4;
+	bnx2fc_stats->rx_frames += fw_stats->rx_stat0.fcoe_rx_pkt_cnt;
+	bnx2fc_stats->rx_words += (fw_stats->rx_stat0.fcoe_rx_byte_cnt) / 4;
+	bnx2fc_stats->dumped_frames = 0;
+	bnx2fc_stats->lip_count = 0;
+	bnx2fc_stats->nos_count = 0;
+	bnx2fc_stats->loss_of_sync_count = 0;
+	bnx2fc_stats->loss_of_signal_count = 0;
+	bnx2fc_stats->prim_seq_protocol_err_count = 0;
+
+	return bnx2fc_stats;
+}
+
+static int bnx2fc_shost_config(struct fc_lport *lport)
+{
+	struct bnx2fc_port *port = lport_priv(lport);
+	struct bnx2fc_hba *hba = port->hba;
+	struct Scsi_Host *shost = lport->host;
+	int rc = 0;
+
+	shost->max_cmd_len = BNX2FC_MAX_CMD_LEN;
+	shost->max_lun = BNX2FC_MAX_LUN;
+	shost->max_id = BNX2FC_MAX_FCP_TGT;
+	shost->max_channel = 0;
+	if (lport->vport)
+		shost->transportt = bnx2fc_vport_xport_template;
+	else
+		shost->transportt = bnx2fc_transport_template;
+
+	/* Add the new host to SCSI-ml */
+	rc = scsi_add_host(lport->host, NULL);
+	if (rc) {
+		printk(KERN_ERR PFX "Error on scsi_add_host\n");
+		return rc;
+	}
+	if (!lport->vport)
+		fc_host_max_npiv_vports(lport->host) = USHRT_MAX;
+	sprintf(fc_host_symbolic_name(lport->host), "%s v%s over %s",
+		BNX2FC_NAME, BNX2FC_VERSION,
+		hba->netdev->name);
+
+	return 0;
+}
+
+static int bnx2fc_link_ok(struct fc_lport *lport)
+{
+	struct bnx2fc_port *port = lport_priv(lport);
+	struct bnx2fc_hba *hba = port->hba;
+	struct net_device *dev = hba->phys_dev;
+	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
+	int rc = 0;
+
+	if ((dev->flags & IFF_UP) && netif_carrier_ok(dev)) {
+		dev = hba->netdev;
+		if (dev->ethtool_ops->get_settings) {
+			dev->ethtool_ops->get_settings(dev, &ecmd);
+			lport->link_supported_speeds &=
+				~(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
+			if (ecmd.supported & (SUPPORTED_1000baseT_Half |
+					      SUPPORTED_1000baseT_Full))
+				lport->link_supported_speeds |=
+							FC_PORTSPEED_1GBIT;
+			if (ecmd.supported & SUPPORTED_10000baseT_Full)
+				lport->link_supported_speeds |=
+					FC_PORTSPEED_10GBIT;
+			if (ecmd.speed == SPEED_1000)
+				lport->link_speed = FC_PORTSPEED_1GBIT;
+			if (ecmd.speed == SPEED_10000)
+				lport->link_speed = FC_PORTSPEED_10GBIT;
+		}
+		clear_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state);
+	} else {
+		set_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state);
+		rc = -1;
+	}
+	return rc;
+}
+
+/**
+ * bnx2fc_get_link_state - get network link state
+ * @hba:	adapter instance pointer
+ *
+ * updates adapter structure flag based on netdev state
+ */
+void bnx2fc_get_link_state(struct bnx2fc_hba *hba)
+{
+	if (test_bit(__LINK_STATE_NOCARRIER, &hba->netdev->state))
+		set_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state);
+	else
+		clear_bit(ADAPTER_STATE_LINK_DOWN, &hba->adapter_state);
+}
+
+static int bnx2fc_net_config(struct fc_lport *lport)
+{
+	struct bnx2fc_hba *hba;
+	struct net_device *netdev;
+	struct bnx2fc_port *port;
+	u32 mfs;
+	u32 max_mfs;
+	u64 wwnn, wwpn;
+
+	port = lport_priv(lport);
+	hba = port->hba;
+	netdev = hba->netdev;
+
+	/* require support for get_pauseparam ethtool op. */
+	if (!hba->phys_dev->ethtool_ops ||
+	    !hba->phys_dev->ethtool_ops->get_pauseparam)
+		return -EOPNOTSUPP;
+
+	mfs = netdev->mtu - (sizeof(struct fcoe_hdr) +
+				sizeof(struct fcoe_crc_eof));
+	max_mfs = BNX2FC_MAX_PAYLOAD + sizeof(struct fc_frame_header);
+	bnx2fc_dbg(LOG_INIT, "mfs = %d, max_mfs = %d\n", mfs, max_mfs);
+	if (mfs > max_mfs)
+		mfs = max_mfs;
+
+	/* Adjust mfs to be a multiple of 256 bytes */
+	mfs = (((mfs - sizeof(struct fc_frame_header)) / BNX2FC_MIN_PAYLOAD) *
+			BNX2FC_MIN_PAYLOAD);
+	mfs = mfs + sizeof(struct fc_frame_header);
+
+	bnx2fc_dbg(LOG_INIT, "Set MFS = %d\n", mfs);
+	if (fc_set_mfs(lport, mfs))
+		return -EINVAL;
+
+	skb_queue_head_init(&port->fcoe_pending_queue);
+	port->fcoe_pending_queue_active = 0;
+	setup_timer(&port->timer, bnx2fc_queue_timer, (unsigned long) lport);
+
+	if (!lport->vport) {
+		wwnn = bnx2fc_wwn_from_mac(hba->ctlr.ctl_src_addr, 1, 0);
+		bnx2fc_dbg(LOG_INIT, "WWNN = 0x%llx\n", wwnn);
+		fc_set_wwnn(lport, wwnn);
+
+		wwpn = bnx2fc_wwn_from_mac(hba->ctlr.ctl_src_addr, 2, 0);
+		bnx2fc_dbg(LOG_INIT, "WWPN = 0x%llx\n", wwpn);
+		fc_set_wwpn(lport, wwpn);
+	}
+
+	return 0;
+}
+
+static void bnx2fc_destroy_timer(unsigned long data)
+{
+	struct bnx2fc_hba *hba = (struct bnx2fc_hba *)data;
+
+	bnx2fc_dbg(LOG_IOERR, "ERROR:bnx2fc_destroy_timer - "
+		   "Destroy compl not received!!\n");
+	hba->flags |= BNX2FC_FLAG_DESTROY_CMPL;
+	wake_up_interruptible(&hba->destroy_wait);
+}
+
+/**
+ * bnx2fc_indicate_netevent - Generic netdev event handler
+ *
+ * @context:	adapter structure pointer
+ * @event:	event type
+ *
+ * Handles NETDEV_UP, NETDEV_DOWN, NETDEV_GOING_DOWN,NETDEV_CHANGE and
+ * NETDEV_CHANGE_MTU events
+ */
+static void bnx2fc_indicate_netevent(void *context, unsigned long event)
+{
+	struct bnx2fc_hba *hba = (struct bnx2fc_hba *)context;
+	struct fc_lport *lport = hba->ctlr.lp;
+	struct net_device *netdev;
+	u32 link_possible = 1;
+	u32 mfs;
+	u32 max_mfs;
+
+	if (!test_bit(BNX2FC_CREATE_DONE, &hba->init_done)) {
+		bnx2fc_dbg(LOG_DEV_EVT, "driver not ready. event=%s %ld\n",
+			   hba->netdev->name, event);
+		return;
+	}
+
+	/*
+	 * ASSUMPTION:
+	 * indicate_netevent cannot be called from cnic unless bnx2fc
+	 * does register_device
+	 */
+	BUG_ON(!lport);
+
+	bnx2fc_dbg(LOG_DEV_EVT, "enter netevent handler - event=%s %ld\n",
+				hba->netdev->name, event);
+
+	switch (event) {
+	case NETDEV_UP:
+		bnx2fc_dbg(LOG_DEV_EVT, "Port up, adapter_state = %ld\n",
+			hba->adapter_state);
+		if (!test_bit(ADAPTER_STATE_UP, &hba->adapter_state))
+			printk(KERN_ERR "indicate_netevent: "\
+					"adapter is not UP!!\n");
+		break;
+	case NETDEV_DOWN:
+		bnx2fc_dbg(LOG_DEV_EVT, "Port down\n");
+		clear_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state);
+		clear_bit(ADAPTER_STATE_UP, &hba->adapter_state);
+		link_possible = 0;
+		break;
+	case NETDEV_GOING_DOWN:
+		bnx2fc_dbg(LOG_DEV_EVT, "Port going down\n");
+		set_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state);
+		link_possible = 0;
+		break;
+	case NETDEV_CHANGEMTU:
+		bnx2fc_dbg(LOG_DEV_EVT, "NETDEV_CHANGEMTU event\n");
+		netdev = hba->netdev;
+		mfs = netdev->mtu - (sizeof(struct fcoe_hdr) +
+				     sizeof(struct fcoe_crc_eof));
+		max_mfs = BNX2FC_MAX_PAYLOAD + sizeof(struct fc_frame_header);
+		bnx2fc_dbg(LOG_DEV_EVT, "change_mtu mfs = %d, max_mfs = %d\n",
+			mfs, max_mfs);
+		if (mfs > max_mfs)
+			mfs = max_mfs;
+		/* Adjust mfs to be a multiple of 256 bytes */
+		mfs = (((mfs - sizeof(struct fc_frame_header)) /
+		       BNX2FC_MIN_PAYLOAD) * BNX2FC_MIN_PAYLOAD);
+		mfs = mfs + sizeof(struct fc_frame_header);
+
+		bnx2fc_dbg(LOG_DEV_EVT, "set new MFS = %d\n", mfs);
+		fc_set_mfs(lport, mfs);
+		break;
+
+	case NETDEV_CHANGE:
+		bnx2fc_dbg(LOG_DEV_EVT, "NETDEV_CHANGE\n");
+		break;
+
+	default:
+		printk(KERN_ERR PFX "Unkonwn netevent %ld", event);
+		return;
+	}
+
+	if (link_possible && !bnx2fc_link_ok(lport)) {
+		printk(KERN_ERR "indicate_netevent: call ctlr_link_up\n");
+		fcoe_ctlr_link_up(&hba->ctlr);
+	} else {
+		printk(KERN_ERR "indicate_netevent: call ctlr_link_down\n");
+		if (fcoe_ctlr_link_down(&hba->ctlr)) {
+			clear_bit(ADAPTER_STATE_READY, &hba->adapter_state);
+			fc_host_port_type(lport->host) = FC_PORTTYPE_UNKNOWN;
+			per_cpu_ptr(lport->dev_stats,
+				    get_cpu())->LinkFailureCount++;
+			put_cpu();
+			bnx2fc_clean_pending_queue(lport);
+
+			init_waitqueue_head(&hba->shutdown_wait);
+			bnx2fc_dbg(LOG_INIT, "indicate_netevent "
+					     "num_ofld_sess = %d\n",
+				   hba->num_ofld_sess);
+			hba->wait_for_link_down = 1;
+			bnx2fc_dbg(LOG_INIT, "waiting for uploads to "
+					     "compl proc = %s\n",
+				   current->comm);
+			wait_event_interruptible(hba->shutdown_wait,
+						 (hba->num_ofld_sess == 0));
+			bnx2fc_dbg(LOG_INIT, "wakeup - num_ofld_sess = %d\n",
+				hba->num_ofld_sess);
+			hba->wait_for_link_down = 0;
+
+			if (signal_pending(current))
+				flush_signals(current);
+		}
+	}
+}
+
+static int bnx2fc_em_config(struct fc_lport *lport)
+{
+	struct bnx2fc_port *port = lport_priv(lport);
+	struct bnx2fc_hba *hba = port->hba;
+
+	if (!fc_exch_mgr_alloc(lport, FC_CLASS_3, FCOE_MIN_XID,
+				FCOE_MAX_XID, NULL)) {
+		printk(KERN_ERR PFX "em_config:fc_exch_mgr_alloc failed\n");
+		return -ENOMEM;
+	}
+
+	hba->cmd_mgr = bnx2fc_cmd_mgr_alloc(hba, BNX2FC_MIN_XID,
+					    BNX2FC_MAX_XID);
+
+	if (!hba->cmd_mgr) {
+		printk(KERN_ERR PFX "em_config:bnx2fc_cmd_mgr_alloc failed\n");
+		fc_exch_mgr_free(lport);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int bnx2fc_lport_config(struct fc_lport *lport, struct Scsi_Host *shost)
+{
+	lport->host = shost;
+	lport->link_up = 0;
+	lport->qfull = 0;
+	lport->max_retry_count = 3;
+	lport->max_rport_retry_count = 3;
+	lport->e_d_tov = 2 * 1000;
+	lport->r_a_tov = 10 * 1000;
+
+	/* REVISIT: enable when supporting tape devices
+	lport->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
+				FCP_SPPF_RETRY | FCP_SPPF_CONF_COMPL);
+	*/
+	lport->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS);
+	lport->does_npiv = 1;
+
+	memset(&lport->rnid_gen, 0, sizeof(struct fc_els_rnid_gen));
+	lport->rnid_gen.rnid_atype = BNX2FC_RNID_HBA;
+
+	/* alloc stats structure */
+	if (fc_lport_init_stats(lport))
+		return -ENOMEM;
+
+	/* Finish fc_lport configuration */
+	fc_lport_config(lport);
+
+	return 0;
+}
+
+/**
+ * bnx2fc_fip_recv - handle a received FIP frame.
+ * @skb: the received skb
+ * @dev: associated &net_device
+ * @ptype: the &packet_type structure which was used to register this handler.
+ * @orig_dev: original receive &net_device, in case @ dev is a bond.
+ *
+ * Returns: 0 for success
+ */
+static int bnx2fc_fip_recv(struct sk_buff *skb, struct net_device *dev,
+			   struct packet_type *ptype,
+			   struct net_device *orig_dev)
+{
+	struct bnx2fc_hba *hba;
+	hba = container_of(ptype, struct bnx2fc_hba, fip_packet_type);
+	fcoe_ctlr_recv(&hba->ctlr, skb);
+	return 0;
+}
+
+/**
+ * bnx2fc_update_src_mac() - Update Ethernet MAC filters.
+ * @fip: FCoE controller.
+ * @old: Unicast MAC address to delete if the MAC is non-zero.
+ * @new: Unicast MAC address to add.
+ *
+ * Remove any previously-set unicast MAC filter.
+ * Add secondary FCoE MAC address filter for our OUI.
+ */
+static void bnx2fc_update_src_mac(struct fc_lport *lport, u8 *addr)
+{
+	struct bnx2fc_port *port = lport_priv(lport);
+
+	memcpy(port->data_src_addr, addr, ETH_ALEN);
+}
+
+/**
+ * bnx2fc_get_src_mac() - return the ethernet source address for an lport
+ * @lport: libfc port
+ */
+static u8 *bnx2fc_get_src_mac(struct fc_lport *lport)
+{
+	struct bnx2fc_port *port;
+
+	port = (struct bnx2fc_port *)lport_priv(lport);
+	return port->data_src_addr;
+}
+/**
+ * bnx2fc_fip_send() - send an Ethernet-encapsulated FIP frame.
+ * @fip: FCoE controller.
+ * @skb: FIP Packet.
+ */
+static void bnx2fc_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
+{
+	skb->dev = bnx2fc_from_ctlr(fip)->netdev;
+	dev_queue_xmit(skb);
+}
+
+static int bnx2fc_vport_create(struct fc_vport *vport, bool disabled)
+{
+	struct Scsi_Host *shost = vport_to_shost(vport);
+	struct fc_lport *n_port = shost_priv(shost);
+	struct bnx2fc_port *port = lport_priv(n_port);
+	struct bnx2fc_hba *hba = port->hba;
+	struct net_device *netdev = hba->netdev;
+	struct fc_lport *vn_port;
+
+	if (!test_bit(BNX2FC_FW_INIT_DONE, &hba->init_done)) {
+		printk(KERN_ERR PFX "vn ports cannot be created on"
+			"this hba\n");
+		return -EIO;
+	}
+	mutex_lock(&bnx2fc_dev_lock);
+	vn_port = bnx2fc_if_create(hba, &vport->dev, 1);
+	mutex_unlock(&bnx2fc_dev_lock);
+
+	if (IS_ERR(vn_port)) {
+		printk(KERN_ERR PFX "bnx2fc_vport_create (%s) failed\n",
+			netdev->name);
+		return -EIO;
+	}
+
+	if (disabled) {
+		fc_vport_set_state(vport, FC_VPORT_DISABLED);
+	} else {
+		vn_port->boot_time = jiffies;
+		fc_fabric_login(vn_port);
+		fc_vport_setlink(vn_port);
+	}
+	return 0;
+}
+
+static int bnx2fc_vport_destroy(struct fc_vport *vport)
+{
+	struct Scsi_Host *shost = vport_to_shost(vport);
+	struct fc_lport *n_port = shost_priv(shost);
+	struct fc_lport *vn_port = vport->dd_data;
+	struct bnx2fc_port *port = lport_priv(vn_port);
+
+	mutex_lock(&n_port->lp_mutex);
+	list_del(&vn_port->list);
+	mutex_unlock(&n_port->lp_mutex);
+	schedule_work(&port->destroy_work);
+	return 0;
+}
+
+static int bnx2fc_vport_disable(struct fc_vport *vport, bool disable)
+{
+	struct fc_lport *lport = vport->dd_data;
+
+	if (disable) {
+		fc_vport_set_state(vport, FC_VPORT_DISABLED);
+		fc_fabric_logoff(lport);
+	} else {
+		lport->boot_time = jiffies;
+		fc_fabric_login(lport);
+		fc_vport_setlink(lport);
+	}
+	return 0;
+}
+
+
+static int bnx2fc_netdev_setup(struct bnx2fc_hba *hba)
+{
+	struct net_device *netdev = hba->netdev;
+	struct net_device *physdev = hba->phys_dev;
+	struct netdev_hw_addr *ha;
+	int sel_san_mac = 0;
+
+	/* Do not support for bonding device */
+	if ((netdev->priv_flags & IFF_MASTER_ALB) ||
+			(netdev->priv_flags & IFF_SLAVE_INACTIVE) ||
+			(netdev->priv_flags & IFF_MASTER_8023AD)) {
+		return -EOPNOTSUPP;
+	}
+
+	/* setup Source MAC Address */
+	rcu_read_lock();
+	for_each_dev_addr(physdev, ha) {
+		bnx2fc_dbg(LOG_INIT, "net_config: ha->type = %d, fip_mac = ",
+			ha->type);
+		printk(KERN_INFO "%2x:%2x:%2x:%2x:%2x:%2x\n", ha->addr[0],
+				ha->addr[1], ha->addr[2], ha->addr[3],
+				ha->addr[4], ha->addr[5]);
+
+		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
+		    (is_valid_ether_addr(ha->addr))) {
+			memcpy(hba->ctlr.ctl_src_addr, ha->addr, ETH_ALEN);
+			sel_san_mac = 1;
+			bnx2fc_dbg(LOG_INIT, "Found SAN MAC\n");
+		}
+	}
+	rcu_read_unlock();
+
+	if (!sel_san_mac)
+		return -ENODEV;
+
+	hba->fip_packet_type.func = bnx2fc_fip_recv;
+	hba->fip_packet_type.type = htons(ETH_P_FIP);
+	hba->fip_packet_type.dev = netdev;
+	dev_add_pack(&hba->fip_packet_type);
+
+	hba->fcoe_packet_type.func = bnx2fc_rcv;
+	hba->fcoe_packet_type.type = __constant_htons(ETH_P_FCOE);
+	hba->fcoe_packet_type.dev = netdev;
+	dev_add_pack(&hba->fcoe_packet_type);
+
+	return 0;
+}
+
+static int bnx2fc_attach_transport(void)
+{
+	bnx2fc_transport_template =
+		fc_attach_transport(&bnx2fc_transport_function);
+
+	if (bnx2fc_transport_template == NULL) {
+		printk(KERN_ERR PFX "Failed to attach FC transport\n");
+		return -ENODEV;
+	}
+
+	bnx2fc_vport_xport_template =
+		fc_attach_transport(&bnx2fc_vport_xport_function);
+	if (bnx2fc_vport_xport_template == NULL) {
+		printk(KERN_ERR PFX
+		       "Failed to attach FC transport for vport\n");
+		fc_release_transport(bnx2fc_transport_template);
+		bnx2fc_transport_template = NULL;
+		return -ENODEV;
+	}
+	return 0;
+}
+static void bnx2fc_release_transport(void)
+{
+	fc_release_transport(bnx2fc_transport_template);
+	fc_release_transport(bnx2fc_vport_xport_template);
+	bnx2fc_transport_template = NULL;
+	bnx2fc_vport_xport_template = NULL;
+}
+
+static void bnx2fc_interface_release(struct kref *kref)
+{
+	struct bnx2fc_hba *hba;
+	struct net_device *netdev;
+	struct net_device *phys_dev;
+
+	hba = container_of(kref, struct bnx2fc_hba, kref);
+	bnx2fc_dbg(LOG_INIT, "Interface is being released hba = 0x%p\n", hba);
+
+	netdev = hba->netdev;
+	phys_dev = hba->phys_dev;
+
+	/* tear-down FIP controller */
+	if (test_and_clear_bit(BNX2FC_CTLR_INIT_DONE, &hba->init_done))
+		fcoe_ctlr_destroy(&hba->ctlr);
+
+	/* Free the command manager */
+	if (hba->cmd_mgr) {
+		bnx2fc_cmd_mgr_free(hba->cmd_mgr);
+		hba->cmd_mgr = NULL;
+	}
+	dev_put(netdev);
+	module_put(THIS_MODULE);
+}
+
+static inline void bnx2fc_interface_get(struct bnx2fc_hba *hba)
+{
+	kref_get(&hba->kref);
+}
+
+static inline void bnx2fc_interface_put(struct bnx2fc_hba *hba)
+{
+	kref_put(&hba->kref, bnx2fc_interface_release);
+}
+static void bnx2fc_interface_destroy(struct bnx2fc_hba *hba)
+{
+	bnx2fc_unbind_pcidev(hba);
+	kfree(hba);
+}
+
+/**
+ * bnx2fc_interface_create - create a new fcoe instance
+ *
+ * @cnic:	pointer to cnic device
+ *
+ * Creates a new FCoE instance on the given device which include allocating
+ *	hba structure, scsi_host and lport structures.
+ */
+static struct bnx2fc_hba *bnx2fc_interface_create(struct cnic_dev *cnic)
+{
+	struct bnx2fc_hba *hba;
+	int rc;
+
+	hba = kzalloc(sizeof(*hba), GFP_KERNEL);
+	if (!hba) {
+		printk(KERN_ERR PFX "Unable to allocate hba structure\n");
+		return NULL;
+	}
+	spin_lock_init(&hba->hba_lock);
+	mutex_init(&hba->hba_mutex);
+
+	hba->cnic = cnic;
+	rc = bnx2fc_bind_pcidev(hba);
+	if (rc)
+		goto bind_err;
+	hba->phys_dev = cnic->netdev;
+	/* will get overwritten after we do vlan discovery */
+	hba->netdev = hba->phys_dev;
+
+	init_waitqueue_head(&hba->shutdown_wait);
+	hba->num_ofld_sess = 0;
+
+	init_waitqueue_head(&hba->destroy_wait);
+	return hba;
+bind_err:
+	printk(KERN_ERR PFX "create_interface: bind error\n");
+	kfree(hba);
+	return NULL;
+}
+
+static int bnx2fc_interface_setup(struct bnx2fc_hba *hba,
+				  enum fip_state fip_mode)
+{
+	int rc = 0;
+	struct net_device *netdev = hba->netdev;
+
+	dev_hold(netdev);
+	kref_init(&hba->kref);
+
+	/* Initialize FIP */
+	fcoe_ctlr_init(&hba->ctlr, fip_mode);
+
+	hba->ctlr.send = bnx2fc_fip_send;
+	hba->ctlr.update_mac = bnx2fc_update_src_mac;
+	hba->ctlr.get_src_addr = bnx2fc_get_src_mac;
+	set_bit(BNX2FC_CTLR_INIT_DONE, &hba->init_done);
+
+	rc = bnx2fc_netdev_setup(hba);
+	if (rc)
+		goto setup_err;
+
+	return 0;
+
+setup_err:
+	fcoe_ctlr_destroy(&hba->ctlr);
+	dev_put(netdev);
+	bnx2fc_interface_put(hba);
+	return rc;
+}
+
+/**
+ * bnx2fc_if_create() - Create FCoE instance on a given interface
+ *
+ * @hba:	FCoE interface to create a local port on
+ * @parent:	Device pointer to be the parent in sysfs for the SCSI host
+ * @npiv:	Indicates if the port is vport or not
+ *
+ * Creates a fc_lport instance and a Scsi_Host instance and configure them.
+ *
+ * Returns:	Allocated fc_lport or an error pointer
+ */
+static struct fc_lport *bnx2fc_if_create(struct bnx2fc_hba *hba,
+				  struct device *parent, int npiv)
+{
+	struct fc_lport		*lport = NULL;
+	struct bnx2fc_port	*port;
+	struct Scsi_Host	*shost;
+	struct fc_vport		*vport = dev_to_vport(parent);
+	int			rc = 0;
+
+	/* Allocate Scsi_Host structure */
+	if (!npiv) {
+		lport = libfc_host_alloc(&bnx2fc_shost_template,
+					  sizeof(struct bnx2fc_port));
+	} else {
+		lport = libfc_vport_create(vport,
+					   sizeof(struct bnx2fc_port));
+	}
+
+	if (!lport) {
+		printk(KERN_ERR PFX "could not allocate scsi host structure\n");
+		return NULL;
+	}
+	shost = lport->host;
+	port = lport_priv(lport);
+	port->lport = lport;
+	port->hba = hba;
+	INIT_WORK(&port->destroy_work, bnx2fc_destroy_work);
+
+	/* Configure bnx2fc_port */
+	rc = bnx2fc_lport_config(lport, shost);
+	if (rc)
+		goto lp_config_err;
+
+	if (npiv) {
+		vport = dev_to_vport(parent);
+		printk(KERN_ERR PFX "Setting vport names, 0x%llX 0x%llX\n",
+			vport->node_name, vport->port_name);
+		fc_set_wwnn(lport, vport->node_name);
+		fc_set_wwpn(lport, vport->port_name);
+	}
+	/* Configure netdev and networking properties of the lport */
+	rc = bnx2fc_net_config(lport);
+	if (rc) {
+		printk(KERN_ERR PFX "Error on bnx2fc_net_config\n");
+		goto lp_config_err;
+	}
+
+	rc = bnx2fc_shost_config(lport);
+	if (rc) {
+		printk(KERN_ERR PFX "Couldnt configure shost for %s\n",
+			hba->netdev->name);
+		goto lp_config_err;
+	}
+
+	/* Initialize the libfc library */
+	rc = fcoe_libfc_config(lport, &hba->ctlr, &bnx2fc_libfc_fcn_templ, 1);
+	if (rc) {
+		printk(KERN_ERR PFX "Couldnt configure libfc\n");
+		goto shost_err;
+	}
+	fc_host_port_type(lport->host) = FC_PORTTYPE_UNKNOWN;
+
+	/* Allocate exchange manager */
+	if (!npiv) {
+		rc = bnx2fc_em_config(lport);
+		if (rc) {
+			printk(KERN_ERR PFX "Error on bnx2fc_em_config\n");
+			goto shost_err;
+		}
+	}
+
+	bnx2fc_interface_get(hba);
+	return lport;
+
+shost_err:
+	scsi_remove_host(shost);
+lp_config_err:
+	scsi_host_put(lport->host);
+	return NULL;
+}
+
+static void bnx2fc_netdev_cleanup(struct bnx2fc_hba *hba)
+{
+	/* Dont listen for Ethernet packets anymore */
+	__dev_remove_pack(&hba->fcoe_packet_type);
+	__dev_remove_pack(&hba->fip_packet_type);
+	synchronize_net();
+}
+
+static void bnx2fc_if_destroy(struct fc_lport *lport)
+{
+	struct bnx2fc_port *port = lport_priv(lport);
+	struct bnx2fc_hba *hba = port->hba;
+
+	bnx2fc_dbg(LOG_INIT, "ENTERED bnx2fc_if_destroy\n");
+	/* Stop the transmit retry timer */
+	del_timer_sync(&port->timer);
+
+	/* Free existing transmit skbs */
+	bnx2fc_clean_pending_queue(lport);
+
+	bnx2fc_interface_put(hba);
+
+	/* Free queued packets for the receive thread */
+	bnx2fc_clean_rx_queue(lport);
+
+	/* Detach from scsi-ml */
+	fc_remove_host(lport->host);
+	scsi_remove_host(lport->host);
+
+	/*
+	 * Note that only the physical lport will have the exchange manager.
+	 * for vports, this function is NOP
+	 */
+	fc_exch_mgr_free(lport);
+
+	/* Free memory used by statistical counters */
+	fc_lport_free_stats(lport);
+
+	/* Release Scsi_Host */
+	scsi_host_put(lport->host);
+}
+
+/**
+ * bnx2fc_destroy() - Destroy a bnx2fc FCoE interface
+ * @buffer: The name of the Ethernet interface to be destroyed
+ * @kp:     The associated kernel parameter
+ *
+ * Called from sysfs.
+ *
+ * Returns: 0 for success
+ */
+static int bnx2fc_destroy(const char *buffer, struct kernel_param *kp)
+{
+	struct bnx2fc_hba *hba = NULL;
+	struct net_device *netdev;
+	struct net_device *phys_dev;
+	int rc = 0;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	mutex_lock(&bnx2fc_dev_lock);
+#ifdef CONFIG_SCSI_BNX2X_FCOE_MODULE
+	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
+		rc = -ENODEV;
+		goto netdev_err;
+	}
+#endif
+	netdev = bnx2fc_if_to_netdev(buffer);
+	if (!netdev) {
+		rc = -ENODEV;
+		goto netdev_err;
+	}
+
+	/* obtain physical netdev */
+	if (netdev->priv_flags & IFF_802_1Q_VLAN)
+		phys_dev = vlan_dev_real_dev(netdev);
+	else {
+		printk(KERN_ERR PFX "Not a vlan device\n");
+		rc = -ENODEV;
+		goto put_err;
+	}
+
+	hba = bnx2fc_hba_lookup(phys_dev);
+	if (!hba) {
+		rc = -ENODEV;
+		printk(KERN_ERR PFX "bnx2fc_destroy: hba not found\n");
+		goto hba_err;
+	}
+
+	if (!test_bit(BNX2FC_CREATE_DONE, &hba->init_done)) {
+		printk(KERN_ERR PFX "bnx2fc_destroy: Create not called\n");
+		goto put_err;
+	}
+
+	bnx2fc_netdev_cleanup(hba);
+
+	bnx2fc_stop(hba);
+
+	bnx2fc_if_destroy(hba->ctlr.lp);
+
+	destroy_workqueue(hba->timer_work_queue);
+
+hba_err:
+	clear_bit(BNX2FC_CREATE_DONE, &hba->init_done);
+put_err:
+	dev_put(netdev);
+netdev_err:
+	mutex_unlock(&bnx2fc_dev_lock);
+	rtnl_unlock();
+	return rc;
+}
+
+static void bnx2fc_destroy_work(struct work_struct *work)
+{
+	struct bnx2fc_port *port;
+	struct fc_lport *lport;
+
+	bnx2fc_dbg(LOG_INIT, "Entered bnx2fc_destroy_work\n");
+	port = container_of(work, struct bnx2fc_port, destroy_work);
+	lport = port->lport;
+
+	bnx2fc_port_shutdown(lport);
+	rtnl_lock();
+	mutex_lock(&bnx2fc_dev_lock);
+	bnx2fc_if_destroy(lport);
+	mutex_unlock(&bnx2fc_dev_lock);
+	rtnl_unlock();
+}
+
+static void bnx2fc_unbind_adapter_devices(struct bnx2fc_hba *hba)
+{
+	bnx2fc_dbg(LOG_INIT, "ENTERED unbind_adapter\n");
+	bnx2fc_free_fw_resc(hba);
+	bnx2fc_free_task_ctx(hba);
+}
+
+/**
+ * bnx2fc_bind_adapter_devices - binds bnx2fc adapter with the associated
+ *			pci structure
+ * @hba:		Adapter instance
+ */
+static int bnx2fc_bind_adapter_devices(struct bnx2fc_hba *hba)
+{
+	if (bnx2fc_setup_task_ctx(hba))
+		goto mem_err;
+
+	if (bnx2fc_setup_fw_resc(hba))
+		goto mem_err;
+
+	return 0;
+mem_err:
+	bnx2fc_unbind_adapter_devices(hba);
+	return -ENOMEM;
+}
+
+static int bnx2fc_bind_pcidev(struct bnx2fc_hba *hba)
+{
+	struct cnic_dev *cnic;
+
+	if (!hba->cnic) {
+		printk(KERN_ERR PFX "cnic is NULL\n");
+		return -ENODEV;
+	}
+	cnic = hba->cnic;
+	hba->pcidev = cnic->pcidev;
+	if (hba->pcidev)
+		pci_dev_get(hba->pcidev);
+
+	return 0;
+}
+
+static void bnx2fc_unbind_pcidev(struct bnx2fc_hba *hba)
+{
+	if (hba->pcidev)
+		pci_dev_put(hba->pcidev);
+	hba->pcidev = NULL;
+}
+
+/**
+ * bnx2fc_ulp_start - cnic callback to initialize & start adapter instance
+ *
+ * @handle:	transport handle pointing to adapter struture
+ *
+ * This function maps adapter structure to pcidev structure and initiates
+ *	firmware handshake to enable/initialize on-chip FCoE components.
+ *	This bnx2fc - cnic interface api callback is used after following
+ *	conditions are met -
+ *	a) underlying network interface is up (marked by event NETDEV_UP
+ *		from netdev
+ *	b) bnx2fc adatper structure is registered.
+ */
+static void bnx2fc_ulp_start(void *handle)
+{
+#define BNX2FC_INIT_POLL_TIME		(1000 / HZ)
+	struct bnx2fc_hba *hba = handle;
+	struct fc_lport *lport = hba->ctlr.lp;
+	int rc = 0;
+	int i = HZ;
+
+	bnx2fc_dbg(LOG_INIT, "Entered bnx2fc_ulp_start hba = %p\n", hba);
+	mutex_lock(&bnx2fc_dev_lock);
+
+	if (test_bit(BNX2FC_FW_INIT_DONE, &hba->init_done))
+		goto start_disc;
+
+	rc = bnx2fc_bind_adapter_devices(hba);
+	if (rc) {
+		printk(KERN_ALERT PFX
+			"bnx2fc_bind_adapter_devices failed - rc = %d\n", rc);
+		mutex_unlock(&bnx2fc_dev_lock);
+		return;
+	}
+	rc = bnx2fc_send_fw_fcoe_init_msg(hba);
+	if (rc) {
+		printk(KERN_ALERT PFX
+			"bnx2fc_send_fw_fcoe_init_msg failed - rc = %d\n", rc);
+		bnx2fc_unbind_adapter_devices(hba);
+		mutex_unlock(&bnx2fc_dev_lock);
+		return;
+	}
+	/*
+	 * Wait until the adapter init message is complete, and adapter
+	 * state is UP.
+	 */
+	while (!test_bit(ADAPTER_STATE_UP, &hba->adapter_state) && i--)
+		msleep(BNX2FC_INIT_POLL_TIME);
+
+	if (!test_bit(ADAPTER_STATE_UP, &hba->adapter_state)) {
+		printk(KERN_ERR PFX "bnx2fc_start: %s failed to initialize.  "
+			"Ignoring...\n",
+			hba->cnic->netdev->name);
+		bnx2fc_unbind_adapter_devices(hba);
+		mutex_unlock(&bnx2fc_dev_lock);
+		return;
+	}
+	/* Mark HBA to indicate that the FW INIT is done */
+	set_bit(BNX2FC_FW_INIT_DONE, &hba->init_done);
+start_disc:
+	mutex_unlock(&bnx2fc_dev_lock);
+
+	bnx2fc_dbg(LOG_INIT, "bnx2fc started.\n");
+
+	/* Kick off Fabric discovery*/
+	if (test_bit(BNX2FC_CREATE_DONE, &hba->init_done)) {
+		printk(KERN_ERR PFX "ulp_init: start discovery\n");
+		lport->tt.frame_send = bnx2fc_xmit;
+		bnx2fc_start_disc(hba);
+	}
+	return;
+}
+
+static void bnx2fc_port_shutdown(struct fc_lport *lport)
+{
+
+	bnx2fc_dbg(LOG_INIT, "ENTERED bnx2fc_port_shutdown\n");
+	fc_fabric_logoff(lport);
+	fc_lport_destroy(lport);
+}
+
+static void bnx2fc_stop(struct bnx2fc_hba *hba)
+{
+	struct fc_lport *lport;
+
+	bnx2fc_dbg(LOG_INIT, "ENTERED bnx2fc_stop - init_done = %ld\n",
+		   hba->init_done);
+	if (test_bit(BNX2FC_FW_INIT_DONE, &hba->init_done) &&
+	    test_bit(BNX2FC_CREATE_DONE, &hba->init_done)) {
+		lport = hba->ctlr.lp;
+		bnx2fc_port_shutdown(lport);
+		bnx2fc_dbg(LOG_INIT, "bnx2fc_stop: waiting for %d "
+				"offloaded sessions\n",
+				hba->num_ofld_sess);
+		wait_event_interruptible(hba->shutdown_wait,
+					 (hba->num_ofld_sess == 0));
+		mutex_lock(&hba->hba_mutex);
+		clear_bit(ADAPTER_STATE_UP, &hba->adapter_state);
+		clear_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state);
+		fc_host_port_type(lport->host) = FC_PORTTYPE_UNKNOWN;
+
+		clear_bit(ADAPTER_STATE_READY, &hba->adapter_state);
+		mutex_unlock(&hba->hba_mutex);
+	}
+}
+
+static void bnx2fc_fw_destroy(struct bnx2fc_hba *hba)
+{
+	if (test_and_clear_bit(BNX2FC_FW_INIT_DONE, &hba->init_done)) {
+		if (bnx2fc_send_fw_fcoe_destroy_msg(hba) == 0) {
+			init_timer(&hba->destroy_timer);
+			hba->destroy_timer.expires = (20 * HZ) + jiffies;
+			hba->destroy_timer.function = bnx2fc_destroy_timer;
+			hba->destroy_timer.data = (unsigned long)hba;
+			add_timer(&hba->destroy_timer);
+			wait_event_interruptible(hba->destroy_wait,
+						 (hba->flags &
+						  BNX2FC_FLAG_DESTROY_CMPL));
+			/* This should never happen */
+			bnx2fc_dbg(LOG_INIT, "hba->flags = 0x%x\n", hba->flags);
+			if (signal_pending(current))
+				flush_signals(current);
+
+			del_timer_sync(&hba->destroy_timer);
+		}
+		bnx2fc_unbind_adapter_devices(hba);
+	}
+}
+
+/**
+ * bnx2fc_ulp_stop - cnic callback to shutdown adapter instance
+ * @handle:	transport handle pointing to adapter structure
+ *
+ * Driver checks if adapter is already in shutdown mode, if not start
+ *	the shutdown process.
+ */
+static void bnx2fc_ulp_stop(void *handle)
+{
+	struct bnx2fc_hba *hba = (struct bnx2fc_hba *)handle;
+
+	printk(KERN_ERR "ULP_STOP\n");
+
+	mutex_lock(&bnx2fc_dev_lock);
+	bnx2fc_stop(hba);
+	bnx2fc_fw_destroy(hba);
+	mutex_unlock(&bnx2fc_dev_lock);
+}
+
+static void bnx2fc_start_disc(struct bnx2fc_hba *hba)
+{
+	struct fc_lport *lport;
+	int wait_cnt = 0;
+
+	printk(KERN_ERR PFX "Entered bnx2fc_start_disc\n");
+	/* Kick off FIP/FLOGI */
+	if (!test_bit(BNX2FC_FW_INIT_DONE, &hba->init_done)) {
+		printk(KERN_ERR PFX "Init not done yet\n");
+		return;
+	}
+
+	lport = hba->ctlr.lp;
+	bnx2fc_dbg(LOG_INIT, "calling fc_fabric_login\n");
+
+	if (!bnx2fc_link_ok(lport)) {
+		bnx2fc_dbg(LOG_INIT, "init_one - ctlr_link_up\n");
+		fcoe_ctlr_link_up(&hba->ctlr);
+		fc_host_port_type(lport->host) = FC_PORTTYPE_NPORT;
+		set_bit(ADAPTER_STATE_READY, &hba->adapter_state);
+	}
+
+	/* wait for the FCF to be selected before issuing FLOGI */
+	while (!hba->ctlr.sel_fcf) {
+		msleep(250);
+		/* give up after 3 secs */
+		if (++wait_cnt > 12)
+			break;
+	}
+	fc_lport_init(lport);
+	fc_fabric_login(lport);
+	return;
+}
+
+
+static struct net_device *bnx2fc_if_to_netdev(const char *buffer)
+{
+	char *cp;
+	char ifname[IFNAMSIZ + 2];
+
+	if (buffer) {
+		strlcpy(ifname, buffer, IFNAMSIZ);
+		cp = ifname + strlen(ifname);
+		while (--cp >= ifname && *cp == '\n')
+			*cp = '\0';
+		return dev_get_by_name(&init_net, ifname);
+	}
+	return NULL;
+}
+
+/**
+ * bnx2fc_ulp_init - Initialize an adapter instance
+ *
+ * @dev :	cnic device handle
+ * Called from cnic_register_driver() context to initialize all
+ *	enumerated cnic devices. This routine allocates adapter structure
+ *	and other device specific resources.
+ */
+static void bnx2fc_ulp_init(struct cnic_dev *dev)
+{
+	struct bnx2fc_hba *hba;
+	int rc = 0;
+
+	bnx2fc_dbg(LOG_INIT, "bnx2fc_ulp_init\n");
+	/* bnx2fc works only when bnx2x is loaded */
+	if (!test_bit(CNIC_F_BNX2X_CLASS, &dev->flags)) {
+		printk(KERN_ERR PFX "bnx2fc FCoE not supported on %s,"
+				    " flags: %lx\n",
+			dev->netdev->name, dev->flags);
+		return;
+	}
+
+	/* Configure FCoE interface */
+	hba = bnx2fc_interface_create(dev);
+	if (!hba) {
+		printk(KERN_ERR PFX "hba initialization failed\n");
+		return;
+	}
+
+	/* Add HBA to the adapter list */
+	mutex_lock(&bnx2fc_dev_lock);
+	list_add_tail(&hba->link, &adapter_list);
+	adapter_count++;
+	mutex_unlock(&bnx2fc_dev_lock);
+
+	clear_bit(BNX2FC_CNIC_REGISTERED, &hba->reg_with_cnic);
+	rc = dev->register_device(dev, CNIC_ULP_FCOE,
+						(void *) hba);
+	if (rc) {
+		printk(KERN_ALERT PFX "register_device failed, rc = %d\n", rc);
+		return;
+	} else {
+		set_bit(BNX2FC_CNIC_REGISTERED, &hba->reg_with_cnic);
+	}
+	return;
+}
+
+/**
+ * bnx2fc_create() - Create bnx2fc FCoE interface
+ * @buffer: The name of Ethernet interface to create on
+ * @kp:     The associated kernel param
+ *
+ * Called from sysfs.
+ *
+ * Returns: 0 for success
+ */
+static int bnx2fc_create(const char *buffer, struct kernel_param *kp)
+{
+	enum fip_state fip_mode = (enum fip_state)(long)kp->arg;
+	struct bnx2fc_hba *hba;
+	struct cnic_dev *dev;
+	struct net_device *netdev;
+	struct net_device *phys_dev;
+	struct fc_lport *lport;
+	struct ethtool_drvinfo drvinfo;
+	int rc = 0;
+	int vlan_id;
+
+	bnx2fc_dbg(LOG_INIT, "Entered bnx2fc_create\n");
+	if (!rtnl_trylock()) {
+		printk(KERN_ERR "trying for rtnl_lock\n");
+		return restart_syscall();
+	}
+	mutex_lock(&bnx2fc_dev_lock);
+
+#ifdef CONFIG_SCSI_BNX2X_FCOE_MODULE
+	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
+		rc = -ENODEV;
+		goto mod_err;
+	}
+#endif
+
+	if (!try_module_get(THIS_MODULE)) {
+		rc = -EINVAL;
+		goto mod_err;
+	}
+
+	netdev = bnx2fc_if_to_netdev(buffer);
+	if (!netdev) {
+		rc = -EINVAL;
+		goto netdev_err;
+	}
+
+	/* obtain physical netdev */
+	if (netdev->priv_flags & IFF_802_1Q_VLAN) {
+		phys_dev = vlan_dev_real_dev(netdev);
+		vlan_id = vlan_dev_vlan_id(netdev);
+	} else {
+		printk(KERN_ERR PFX "Not a vlan device\n");
+		rc = -EINVAL;
+		goto putdev_err;
+	}
+	/* verify if the physical device is a netxtreme2 device */
+	if (phys_dev->ethtool_ops && phys_dev->ethtool_ops->get_drvinfo) {
+		memset(&drvinfo, 0, sizeof(drvinfo));
+		phys_dev->ethtool_ops->get_drvinfo(phys_dev, &drvinfo);
+		if (strcmp(drvinfo.driver, "bnx2x")) {
+			printk(KERN_ERR PFX "Not a netxtreme2 device\n");
+			rc = -EINVAL;
+			goto putdev_err;
+		}
+	} else {
+		printk(KERN_ERR PFX "unable to obtain drv_info\n");
+		rc = -EINVAL;
+		goto putdev_err;
+	}
+
+	printk(KERN_ERR PFX "phys_dev is netxtreme2 device\n");
+
+	/* obtain hba and initialize rest of the structure */
+	hba = bnx2fc_hba_lookup(phys_dev);
+	if (!hba) {
+		rc = -ENODEV;
+		printk(KERN_ERR PFX "bnx2fc_create: hba not found\n");
+		goto putdev_err;
+	}
+
+	if (test_bit(BNX2FC_CREATE_DONE, &hba->init_done)) {
+		rc = -EEXIST;
+		goto putdev_err;
+	}
+
+	/* update netdev with vlan netdev */
+	hba->netdev = netdev;
+	dev = hba->cnic;
+	hba->vlan_id = vlan_id;
+	hba->vlan_enabled = 1;
+
+	rc = bnx2fc_interface_setup(hba, fip_mode);
+	if (rc) {
+		printk(KERN_ERR PFX "bnx2fc_interface_setup failed\n");
+		goto ifput_err;
+	}
+
+	hba->jiffies_at_init = jiffies;
+
+	hba->timer_work_queue =
+			create_singlethread_workqueue("bnx2fc_timer_wq");
+	if (!hba->timer_work_queue) {
+		printk(KERN_ERR PFX "ulp_init could not create timer_wq\n");
+		rc = -EINVAL;
+		goto ifput_err;
+	}
+
+	lport = bnx2fc_if_create(hba, &netdev->dev, 0);
+	if (!lport) {
+		printk(KERN_ERR PFX "Failed to create interface (%s)\n",
+			netdev->name);
+		bnx2fc_netdev_cleanup(hba);
+		rc = -EINVAL;
+		goto if_create_err;
+	}
+
+	lport->boot_time = jiffies;
+
+	/* Make this master N_port */
+	hba->ctlr.lp = lport;
+
+	set_bit(BNX2FC_CREATE_DONE, &hba->init_done);
+	printk(KERN_ERR PFX "create: START DISC\n");
+	bnx2fc_start_disc(hba);
+	/*
+	 * Release from kref_init in bnx2fc_interface_setup, on success
+	 * lport should be holding a reference taken in bnx2fc_if_create
+	 */
+	bnx2fc_interface_put(hba);
+	/* put netdev that was held while calling dev_get_by_name */
+	dev_put(netdev);
+	mutex_unlock(&bnx2fc_dev_lock);
+	rtnl_unlock();
+	return 0;
+
+if_create_err:
+	destroy_workqueue(hba->timer_work_queue);
+ifput_err:
+	bnx2fc_interface_put(hba);
+putdev_err:
+	dev_put(netdev);
+netdev_err:
+	module_put(THIS_MODULE);
+mod_err:
+	mutex_unlock(&bnx2fc_dev_lock);
+	rtnl_unlock();
+	return rc;
+}
+
+/**
+ * bnx2fc_find_hba_for_cnic - maps cnic instance to bnx2fc adapter instance
+ *
+ * @cnic:	Pointer to cnic device instance
+ *
+ **/
+static struct bnx2fc_hba *bnx2fc_find_hba_for_cnic(struct cnic_dev *cnic)
+{
+	struct list_head *list;
+	struct list_head *temp;
+	struct bnx2fc_hba *hba;
+
+	/* Called with bnx2fc_dev_lock held */
+	list_for_each_safe(list, temp, &adapter_list) {
+		hba = (struct bnx2fc_hba *)list;
+		if (hba->cnic == cnic)
+			return hba;
+	}
+	return NULL;
+}
+
+static struct bnx2fc_hba *bnx2fc_hba_lookup(struct net_device *phys_dev)
+{
+	struct list_head *list;
+	struct list_head *temp;
+	struct bnx2fc_hba *hba;
+
+	/* Called with bnx2fc_dev_lock held */
+	list_for_each_safe(list, temp, &adapter_list) {
+		hba = (struct bnx2fc_hba *)list;
+		if (hba->phys_dev == phys_dev)
+			return hba;
+	}
+	printk(KERN_ERR PFX "hba_lookup: hba NULL\n");
+	return NULL;
+}
+
+/**
+ * bnx2fc_ulp_exit - shuts down adapter instance and frees all resources
+ *
+ * @dev		cnic device handle
+ */
+static void bnx2fc_ulp_exit(struct cnic_dev *dev)
+{
+	struct bnx2fc_hba *hba;
+
+	bnx2fc_dbg(LOG_INIT, "Entered bnx2fc_ulp_exit\n");
+
+	if (!test_bit(CNIC_F_BNX2X_CLASS, &dev->flags)) {
+		printk(KERN_ERR PFX "bnx2fc port check: %s, flags: %lx\n",
+			dev->netdev->name, dev->flags);
+		return;
+	}
+
+	mutex_lock(&bnx2fc_dev_lock);
+	hba = bnx2fc_find_hba_for_cnic(dev);
+	if (!hba) {
+		printk(KERN_ERR PFX "bnx2fc_ulp_exit: hba not found, dev 0%p\n",
+		       dev);
+		mutex_unlock(&bnx2fc_dev_lock);
+		return;
+	}
+
+	bnx2fc_dbg(LOG_INIT, "removed hba 0x%p from adapter list\n", hba);
+	list_del_init(&hba->link);
+	adapter_count--;
+
+	if (test_bit(BNX2FC_CREATE_DONE, &hba->init_done)) {
+		/* destroy not called yet, move to quiesced list */
+		bnx2fc_netdev_cleanup(hba);
+		bnx2fc_if_destroy(hba->ctlr.lp);
+	}
+	mutex_unlock(&bnx2fc_dev_lock);
+
+	bnx2fc_ulp_stop(hba);
+	/* unregister cnic device */
+	if (test_and_clear_bit(BNX2FC_CNIC_REGISTERED, &hba->reg_with_cnic))
+		hba->cnic->unregister_device(hba->cnic, CNIC_ULP_FCOE);
+	bnx2fc_interface_destroy(hba);
+}
+
+/**
+ * bnx2fc_fcoe_reset() - Resets the fcoe
+ * @shost: shost the reset is from
+ *
+ * Returns: always 0
+ */
+static int bnx2fc_fcoe_reset(struct Scsi_Host *shost)
+{
+	struct fc_lport *lport = shost_priv(shost);
+	fc_lport_reset(lport);
+	return 0;
+}
+
+/**
+ * bnx2fc_mod_init - module init entry point
+ *
+ * Initialize driver wide global data structures, and register
+ * with cnic module
+ **/
+static int __init bnx2fc_mod_init(void)
+{
+	struct bnx2fc_global_s *bg;
+	struct task_struct *l2_thread;
+	int rc = 0;
+
+	printk(KERN_INFO PFX "%s", version);
+	INIT_LIST_HEAD(&adapter_list);
+	mutex_init(&bnx2fc_dev_lock);
+
+	adapter_count = 0;
+
+	/* Attach FC transport template */
+	rc = bnx2fc_attach_transport();
+	if (rc)
+		return rc;
+
+	bg = &bnx2fc_global;
+	skb_queue_head_init(&bg->fcoe_rx_list);
+	l2_thread = kthread_create(bnx2fc_l2_rcv_thread,
+				   (void *)bg,
+				   "bnx2fc_l2_thread");
+	if (IS_ERR(bg->l2_thread)) {
+		rc = PTR_ERR(l2_thread);
+		return rc;
+	}
+	wake_up_process(l2_thread);
+	spin_lock_bh(&bg->fcoe_rx_list.lock);
+	bg->l2_thread = l2_thread;
+	spin_unlock_bh(&bg->fcoe_rx_list.lock);
+
+	cnic_register_driver(CNIC_ULP_FCOE, &bnx2fc_cnic_cb);
+	return 0;
+}
+
+static void __exit bnx2fc_mod_exit(void)
+{
+	LIST_HEAD(to_be_deleted);
+	struct bnx2fc_hba *hba, *next;
+	struct bnx2fc_global_s *bg;
+	struct task_struct *l2_thread;
+	struct sk_buff *skb;
+
+	/*
+	 * NOTE: Since cnic calls register_driver routine rtnl_lock,
+	 * it will have higher precedence than bnx2fc_dev_lock.
+	 * unregister_device() cannot be called with bnx2fc_dev_lock
+	 * held.
+	 */
+	mutex_lock(&bnx2fc_dev_lock);
+	list_splice(&adapter_list, &to_be_deleted);
+	INIT_LIST_HEAD(&adapter_list);
+	adapter_count = 0;
+	mutex_unlock(&bnx2fc_dev_lock);
+
+	/* Unregister with cnic */
+	list_for_each_entry_safe(hba, next, &to_be_deleted, link) {
+		list_del_init(&hba->link);
+		printk(KERN_ERR PFX "MOD_EXIT:destroy hba = 0x%p, kref = %d\n",
+			hba, atomic_read(&hba->kref.refcount));
+		bnx2fc_ulp_stop(hba);
+		/* unregister cnic device */
+		if (test_and_clear_bit(BNX2FC_CNIC_REGISTERED,
+				       &hba->reg_with_cnic))
+			hba->cnic->unregister_device(hba->cnic, CNIC_ULP_FCOE);
+		bnx2fc_interface_destroy(hba);
+	}
+	cnic_unregister_driver(CNIC_ULP_FCOE);
+
+	/* Destroy global thread */
+	bg = &bnx2fc_global;
+	spin_lock_bh(&bg->fcoe_rx_list.lock);
+	l2_thread = bg->l2_thread;
+	bg->l2_thread = NULL;
+	while ((skb = __skb_dequeue(&bg->fcoe_rx_list)) != NULL)
+		kfree_skb(skb);
+
+	spin_unlock_bh(&bg->fcoe_rx_list.lock);
+
+	if (l2_thread)
+		kthread_stop(l2_thread);
+
+	/* flush any async interface destroy */
+	flush_scheduled_work();
+	/* flush out VN_Ports scheduled for destruction */
+	flush_scheduled_work();
+	/*
+	 * detach from scsi transport
+	 * must happen after all destroys are done
+	 */
+	bnx2fc_release_transport();
+}
+
+module_init(bnx2fc_mod_init);
+module_exit(bnx2fc_mod_exit);
+
+static struct fc_function_template bnx2fc_transport_function = {
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+	.show_host_supported_fc4s = 1,
+	.show_host_active_fc4s = 1,
+	.show_host_maxframe_size = 1,
+
+	.show_host_port_id = 1,
+	.show_host_supported_speeds = 1,
+	.get_host_speed = fc_get_host_speed,
+	.show_host_speed = 1,
+	.show_host_port_type = 1,
+	.get_host_port_state = fc_get_host_port_state,
+	.show_host_port_state = 1,
+	.show_host_symbolic_name = 1,
+
+	.dd_fcrport_size = (sizeof(struct fc_rport_libfc_priv) +
+				sizeof(struct bnx2fc_rport)),
+	.show_rport_maxframe_size = 1,
+	.show_rport_supported_classes = 1,
+
+	.show_host_fabric_name = 1,
+	.show_starget_node_name = 1,
+	.show_starget_port_name = 1,
+	.show_starget_port_id = 1,
+	.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
+	.show_rport_dev_loss_tmo = 1,
+	.get_fc_host_stats = bnx2fc_get_host_stats,
+
+	.issue_fc_host_lip = bnx2fc_fcoe_reset,
+
+	.vport_create = bnx2fc_vport_create,
+	.vport_delete = bnx2fc_vport_destroy,
+	.vport_disable = bnx2fc_vport_disable,
+};
+
+static struct fc_function_template bnx2fc_vport_xport_function = {
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+	.show_host_supported_fc4s = 1,
+	.show_host_active_fc4s = 1,
+	.show_host_maxframe_size = 1,
+
+	.show_host_port_id = 1,
+	.show_host_supported_speeds = 1,
+	.get_host_speed = fc_get_host_speed,
+	.show_host_speed = 1,
+	.show_host_port_type = 1,
+	.get_host_port_state = fc_get_host_port_state,
+	.show_host_port_state = 1,
+	.show_host_symbolic_name = 1,
+
+	.dd_fcrport_size = (sizeof(struct fc_rport_libfc_priv) +
+				sizeof(struct bnx2fc_rport)),
+	.show_rport_maxframe_size = 1,
+	.show_rport_supported_classes = 1,
+
+	.show_host_fabric_name = 1,
+	.show_starget_node_name = 1,
+	.show_starget_port_name = 1,
+	.show_starget_port_id = 1,
+	.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
+	.show_rport_dev_loss_tmo = 1,
+	.get_fc_host_stats = fc_get_host_stats,
+	.issue_fc_host_lip = bnx2fc_fcoe_reset,
+};
+
+/**
+ * scsi_host_template structure used while registering with SCSI-ml
+ */
+static struct scsi_host_template bnx2fc_shost_template = {
+	.module			= THIS_MODULE,
+	.name			= "Broadcom Offload FCoE Initiator",
+	.queuecommand		= bnx2fc_queuecommand,
+	.eh_abort_handler	= bnx2fc_eh_abort,	  /* abts */
+	.eh_device_reset_handler = bnx2fc_eh_device_reset, /* lun reset */
+	.eh_target_reset_handler = bnx2fc_eh_target_reset, /* tgt reset */
+	.eh_host_reset_handler	= fc_eh_host_reset,
+	.slave_alloc		= fc_slave_alloc,
+	.change_queue_depth	= fc_change_queue_depth,
+	.change_queue_type	= fc_change_queue_type,
+	.this_id		= -1,
+	.cmd_per_lun		= 3,
+	.can_queue		= (BNX2FC_MAX_OUTSTANDING_CMNDS/2),
+	.use_clustering		= ENABLE_CLUSTERING,
+	.sg_tablesize		= BNX2FC_MAX_BDS_PER_CMD,
+	.max_sectors		= 512,
+};
+
+static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
+	.frame_send		= bnx2fc_xmit,
+	.elsct_send		= bnx2fc_elsct_send,
+	.fcp_abort_io		= bnx2fc_abort_io,
+	.fcp_cleanup		= bnx2fc_cleanup,
+	.rport_event_callback	= bnx2fc_rport_event_handler,
+};
+
+/**
+ * bnx2fc_cnic_cb - global template of bnx2fc - cnic driver interface
+ *			structure carrying callback function pointers
+ */
+static struct cnic_ulp_ops bnx2fc_cnic_cb = {
+	.owner			= THIS_MODULE,
+	.cnic_init		= bnx2fc_ulp_init,
+	.cnic_exit		= bnx2fc_ulp_exit,
+	.cnic_start		= bnx2fc_ulp_start,
+	.cnic_stop		= bnx2fc_ulp_stop,
+	.indicate_kcqes		= bnx2fc_indicate_kcqe,
+	.indicate_netevent	= bnx2fc_indicate_netevent,
+};
-- 
1.7.0.6




