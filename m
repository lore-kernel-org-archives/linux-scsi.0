From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [v2 PATCH 5/5] bnx2fc: Broadcom FCoE Offload driver submission
 - part 3
Date: Mon, 17 Jan 2011 21:41:36 -0600
Message-ID: <4D350BF0.7040301@cs.wisc.edu>
References: <1293170556.4676.575.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39586 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab1ARDlh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jan 2011 22:41:37 -0500
In-Reply-To: <1293170556.4676.575.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org, mchan@broadcom.com

On 12/24/2010 12:02 AM, Bhanu Gollapudi wrote:
> +++ b/drivers/scsi/bnx2fc/Kconfig
> @@ -0,0 +1,11 @@
> +config SCSI_BNX2X_FCOE
> +	tristate "Broadcom NetXtreme II FCoE support"
> +	depends on PCI
> +	select NETDEVICES
> +	select NETDEV_1000


What is the NETDEV_1000 for?


> +	select LIBFC
> +	select LIBFCOE
> +	select CNIC
> +	---help---
> +	This driver supports FCoE offload for the Broadcom NetXtreme II
> +	devices.
> diff --git a/drivers/scsi/bnx2fc/Makefile b/drivers/scsi/bnx2fc/Makefile
> new file mode 100644
> index 0000000..a92695a
> --- /dev/null
> +++ b/drivers/scsi/bnx2fc/Makefile
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_SCSI_BNX2X_FCOE) += bnx2fc.o
> +
> +bnx2fc-y := bnx2fc_els.o bnx2fc_fcoe.o bnx2fc_hwi.o bnx2fc_io.o bnx2fc_tgt.o
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> new file mode 100644
> index 0000000..ea846ee
> --- /dev/null
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -0,0 +1,2423 @@
> +/* bnx2fc_fcoe.c: Broadcom NetXtreme II Linux FCoE offload driver.
> + *
> + * Copyright (c) 2008 - 2010 Broadcom Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + *
> + * Written by: Bhanu Prakash Gollapudi (bprakash@broadcom.com)
> + */
> +
> +#include "bnx2fc.h"
> +
> +static struct list_head adapter_list;
> +static u32 adapter_count;
> +static DEFINE_MUTEX(bnx2fc_dev_lock);
> +
> +#define DRV_MODULE_NAME		"bnx2fc"
> +#define DRV_MODULE_VERSION	BNX2FC_VERSION
> +#define DRV_MODULE_RELDATE	"Dec, 23 2010"
> +
> +
> +static char version[] __devinitdata =
> +		"Broadcom NetXtreme II FCoE Driver " DRV_MODULE_NAME \
> +		" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
> +
> +
> +MODULE_AUTHOR("Bhanu Prakash Gollapudi<bprakash@broadcom.com>");
> +MODULE_DESCRIPTION("Broadcom NetXtreme II BCM57710 FCoE Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(DRV_MODULE_VERSION);
> +
> +#define FCOE_LOW_QUEUE_DEPTH	32
> +#define FCOE_GW_ADDR_MODE           0x00
> +#define FCOE_FCOUI_ADDR_MODE        0x01
> +
> +#define FCOE_WORD_TO_BYTE  4


rm unused defs and rm or rename defs in other files.


> +
> +static struct scsi_transport_template	*bnx2fc_transport_template;
> +static struct scsi_transport_template	*bnx2fc_vport_xport_template;
> +
> +struct bnx2fc_global_s bnx2fc_global;
> +
> +static struct cnic_ulp_ops bnx2fc_cnic_cb;
> +static struct libfc_function_template bnx2fc_libfc_fcn_templ;
> +static struct scsi_host_template bnx2fc_shost_template;
> +static struct fc_function_template bnx2fc_transport_function;
> +static struct fc_function_template bnx2fc_vport_xport_function;
> +static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode);
> +static int bnx2fc_destroy(struct net_device *net_device);
> +static int bnx2fc_enable(struct net_device *netdev);
> +static int bnx2fc_disable(struct net_device *netdev);
> +
> +static void bnx2fc_recv_frame(struct sk_buff *skb);
> +
> +static u64 bnx2fc_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
> +		      unsigned int scheme, unsigned int port);
> +static inline int bnx2fc_start_io(struct sk_buff *skb);
> +static void bnx2fc_start_disc(struct bnx2fc_hba *hba);
> +static void bnx2fc_check_wait_queue(struct fc_lport *lp, struct sk_buff *skb);
> +static int bnx2fc_shost_config(struct fc_lport *lp);
> +static int bnx2fc_net_config(struct fc_lport *lp);
> +static int bnx2fc_lport_config(struct fc_lport *lport,
> +			       struct Scsi_Host *shost);
> +static int bnx2fc_em_config(struct fc_lport *lport);
> +static int bnx2fc_bind_adapter_devices(struct bnx2fc_hba *hba);
> +static void bnx2fc_unbind_adapter_devices(struct bnx2fc_hba *hba);
> +static int bnx2fc_bind_pcidev(struct bnx2fc_hba *hba);
> +static void bnx2fc_unbind_pcidev(struct bnx2fc_hba *hba);
> +static struct fc_lport *bnx2fc_if_create(struct bnx2fc_hba *hba,
> +				  struct device *parent, int npiv);
> +static void bnx2fc_destroy_work(struct work_struct *work);
> +
> +static struct bnx2fc_hba *bnx2fc_hba_lookup(struct net_device *phys_dev);
> +static struct bnx2fc_hba *bnx2fc_find_hba_for_cnic(struct cnic_dev *cnic);
> +
> +static void bnx2fc_port_shutdown(struct fc_lport *lport);
> +static void bnx2fc_stop(struct bnx2fc_hba *hba);
> +static int __init bnx2fc_mod_init(void);
> +static void __exit bnx2fc_mod_exit(void);
> +
> +unsigned long bnx2fc_debug_level;
> +module_param(bnx2fc_debug_level, long, 0644);
> +
> +/*
> +MODULE_PARM_DESC(bnx2fc_debug_level, "Bit mask to enable debug logging,\n\t\t"
> +		"LOG_IOERR	0x00000001\n\t\t"
> +		"LOG_SESS	0x00000002\n\t\t"
> +		"LOG_DEV_EVT	0x00000004\n\t\t"
> +		"LOG_ELS	0x00000008\n\t\t"
> +		"LOG_FRAME	0x00000010\n\t\t"
> +		"LOG_INIT	0x00000020\n\t\t"
> +		"LOG_ALL	0xffffffff\n"
> +		);
> +*/
> +

rm if not used.

> +#define FCOE_MAX_QUEUE_DEPTH 256
> +
> +static u64 bnx2fc_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
> +		      unsigned int scheme, unsigned int port)
> +{
> +	u64 wwn;
> +	u64 host_mac;
> +
> +	/* The MAC is in NO, so flip only the low 48 bits */
> +	host_mac = ((u64) mac[0]<<  40) |
> +		((u64) mac[1]<<  32) |
> +		((u64) mac[2]<<  24) |
> +		((u64) mac[3]<<  16) |
> +		((u64) mac[4]<<  8) |
> +		(u64) mac[5];
> +
> +	WARN_ON(host_mac>= (1ULL<<  48));
> +	wwn = host_mac | ((u64) scheme<<  60);
> +	switch (scheme) {
> +	case 1:
> +		WARN_ON(port != 0);
> +		break;
> +	case 2:
> +		WARN_ON(port>= 0xfff);
> +		wwn |= (u64) port<<  48;
> +		break;
> +	default:
> +		WARN_ON(1);
> +		break;
> +	}
> +
> +	return wwn;
> +}


libfcoe has this already.


> +static inline int bnx2fc_start_io(struct sk_buff *skb)
> +{
> +	struct sk_buff *nskb;
> +	int rc;
> +
> +	nskb = skb_clone(skb, GFP_ATOMIC);
> +	rc = dev_queue_xmit(nskb);
> +	if (rc != 0)
> +		return rc;
> +	kfree_skb(skb);
> +	return 0;
> +}


fcoe.c has this.


> +
> +static void bnx2fc_clean_rx_queue(struct fc_lport *lp)
> +{
> +	struct bnx2fc_global_s *bg;
> +	struct fcoe_rcv_info *fr;
> +	struct sk_buff_head *list;
> +	struct sk_buff *skb, *next;
> +	struct sk_buff *head;
> +
> +	bg =&bnx2fc_global;
> +	spin_lock_bh(&bg->fcoe_rx_list.lock);
> +	list =&bg->fcoe_rx_list;
> +	head = list->next;
> +	for (skb = head; skb != (struct sk_buff *)list;
> +	     skb = next) {
> +		next = skb->next;
> +		fr = fcoe_dev_from_skb(skb);
> +		if (fr->fr_dev == lp) {
> +			__skb_unlink(skb, list);
> +			kfree_skb(skb);
> +		}
> +	}
> +	spin_unlock_bh(&bg->fcoe_rx_list.lock);
> +}


fcoe.c has something similar (per cpu one).



> +
> +static void bnx2fc_queue_timer(ulong lport)
> +{
> +	bnx2fc_check_wait_queue((struct fc_lport *) lport, NULL);
> +}
> +

fcoe dup.

> +static void bnx2fc_clean_pending_queue(struct fc_lport *lp)
> +{
> +	struct bnx2fc_port *port;
> +	struct sk_buff *skb;
> +	port = lport_priv(lp);
> +
> +	spin_lock_bh(&port->fcoe_pending_queue.lock);
> +	while ((skb = __skb_dequeue(&port->fcoe_pending_queue)) != NULL) {
> +		spin_unlock_bh(&port->fcoe_pending_queue.lock);
> +		kfree_skb(skb);
> +		spin_lock_bh(&port->fcoe_pending_queue.lock);
> +	}
> +	spin_unlock_bh(&port->fcoe_pending_queue.lock);
> +}


dup

> +
> +static void bnx2fc_check_wait_queue(struct fc_lport *lp, struct sk_buff *skb)
> +{
> +	struct bnx2fc_port *port = lport_priv(lp);
> +	int rc = 0;
> +
> +	spin_lock_bh(&port->fcoe_pending_queue.lock);
> +
> +	if (skb)
> +		__skb_queue_tail(&port->fcoe_pending_queue, skb);
> +
> +	if (port->fcoe_pending_queue_active)
> +		goto out;
> +	port->fcoe_pending_queue_active = 1;
> +
> +	while (port->fcoe_pending_queue.qlen) {
> +		/* keep qlen>  0 until bnx2fc_start_io succeeds */
> +		port->fcoe_pending_queue.qlen++;
> +		skb = __skb_dequeue(&port->fcoe_pending_queue);
> +
> +		spin_unlock_bh(&port->fcoe_pending_queue.lock);
> +		rc = bnx2fc_start_io(skb);
> +		spin_lock_bh(&port->fcoe_pending_queue.lock);
> +
> +		if (rc) {
> +			__skb_queue_head(&port->fcoe_pending_queue, skb);
> +			/* undo temporary increment above */
> +			port->fcoe_pending_queue.qlen--;
> +			break;
> +		}
> +		/* undo temporary increment above */
> +		port->fcoe_pending_queue.qlen--;
> +	}
> +
> +	if (port->fcoe_pending_queue.qlen<  FCOE_LOW_QUEUE_DEPTH)
> +		lp->qfull = 0;
> +	if (port->fcoe_pending_queue.qlen&&  !timer_pending(&port->timer))
> +		mod_timer(&port->timer, jiffies + 2);
> +	port->fcoe_pending_queue_active = 0;
> +out:
> +	if (port->fcoe_pending_queue.qlen>  FCOE_MAX_QUEUE_DEPTH)
> +		lp->qfull = 1;
> +	spin_unlock_bh(&port->fcoe_pending_queue.lock);
> +	return;
> +}
> +

dup



> +u32 bnx2fc_crc(struct fc_frame *fp)
> +{
> +	struct sk_buff *skb = fp_skb(fp);
> +	struct skb_frag_struct *frag;
> +	unsigned char *data;
> +	unsigned long off, len, clen;
> +	u32 crc;
> +	unsigned i;
> +
> +	crc = crc32(~0, skb->data, skb_headlen(skb));
> +
> +	for (i = 0; i<  skb_shinfo(skb)->nr_frags; i++) {
> +		frag =&skb_shinfo(skb)->frags[i];
> +		off = frag->page_offset;
> +		len = frag->size;
> +		while (len>  0) {
> +			clen = min(len, PAGE_SIZE - (off&  ~PAGE_MASK));
> +			data = kmap_atomic(frag->page + (off>>  PAGE_SHIFT),
> +					   KM_SKB_DATA_SOFTIRQ);
> +			crc = crc32(crc, data + (off&  ~PAGE_MASK), clen);
> +			kunmap_atomic(data, KM_SKB_DATA_SOFTIRQ);
> +			off += clen;
> +			len -= clen;
> +		}
> +	}
> +	return crc;
> +}


dup.

> +int bnx2fc_get_paged_crc_eof(struct sk_buff *skb, int tlen)
> +{
> +	struct bnx2fc_global_s *bg;
> +	struct page *page;
> +
> +	bg =&bnx2fc_global;
> +	page = bg->crc_eof_page;
> +	if (!page) {
> +		page = alloc_page(GFP_ATOMIC);
> +		if (!page)
> +			return -ENOMEM;
> +		bg->crc_eof_page = page;
> +		bg->crc_eof_offset = 0;
> +	}
> +
> +	get_page(page);
> +	skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags, page,
> +			   bg->crc_eof_offset, tlen);
> +	skb->len += tlen;
> +	skb->data_len += tlen;
> +	skb->truesize += tlen;
> +	bg->crc_eof_offset += sizeof(struct fcoe_crc_eof);
> +
> +	if (bg->crc_eof_offset>= PAGE_SIZE) {
> +		bg->crc_eof_page = NULL;
> +		bg->crc_eof_offset = 0;
> +		put_page(page);
> +	}
> +	return 0;
> +}

dup.

I am going to stop. You know what is duplicated with fcoe/libfcoe. You 
should export that code and use it instead of copying it. Change it if 
you need to. Some things look like they need to be slightly changed. 
Like the new callouts or a change to how they are called.



> +
> +static void bnx2fc_abort_io(struct fc_lport *lport)
> +{
> +	bnx2fc_dbg(LOG_IOERR, "Entered bnx2fc_abort_io\n");
> +
> +}

delete.



> +
> +static int bnx2fc_shost_config(struct fc_lport *lport)
> +{
> +	struct bnx2fc_port *port = lport_priv(lport);
> +	struct bnx2fc_hba *hba = port->hba;
> +	struct Scsi_Host *shost = lport->host;
> +	int rc = 0;
> +
> +	shost->max_cmd_len = BNX2FC_MAX_CMD_LEN;
> +	shost->max_lun = BNX2FC_MAX_LUN;
> +	shost->max_id = BNX2FC_MAX_FCP_TGT;
> +	shost->max_channel = 0;
> +	if (lport->vport)
> +		shost->transportt = bnx2fc_vport_xport_template;
> +	else
> +		shost->transportt = bnx2fc_transport_template;
> +
> +	/* Add the new host to SCSI-ml */
> +	rc = scsi_add_host(lport->host, NULL);


For non vport calls the netdev's pdev should be passed here, so the 
scsi/block layer gets the rights dma restrictions. For vport calls the 
scsi host/vports's device should be passed.





> +
> +/**
> + * bnx2fc_fip_recv - handle a received FIP frame.


In some of your docbook comments you do

functionname -
/n
and others you do
functionname()
no newline.

You should stick to one style.

> +
> +/**
> + * bnx2fc_mod_init - module init entry point
> + *
> + * Initialize driver wide global data structures, and register
> + * with cnic module
> + **/
> +static int __init bnx2fc_mod_init(void)
> +{
> +	struct bnx2fc_global_s *bg;
> +	struct task_struct *l2_thread;
> +	int rc = 0;
> +
> +	printk(KERN_INFO PFX "%s", version);
> +
> +	/* register as a fcoe transport */
> +	rc = fcoe_transport_attach(&bnx2fc_transport);
> +	if (rc) {
> +		printk(KERN_ERR "failed to register an fcoe transport, check "
> +			"if libfcoe is loaded\n");
> +		goto out;
> +	}
> +
> +	INIT_LIST_HEAD(&adapter_list);
> +	mutex_init(&bnx2fc_dev_lock);
> +
> +	adapter_count = 0;
> +
> +	/* Attach FC transport template */
> +	rc = bnx2fc_attach_transport();
> +	if (rc)
> +		return rc;
> +
> +	bg =&bnx2fc_global;
> +	skb_queue_head_init(&bg->fcoe_rx_list);
> +	l2_thread = kthread_create(bnx2fc_l2_rcv_thread,
> +				   (void *)bg,
> +				   "bnx2fc_l2_thread");
> +	if (IS_ERR(bg->l2_thread)) {
> +		rc = PTR_ERR(l2_thread);
> +		return rc;
> +	}


It seems you are leaking int he error paths.




I did not review the host/netdev/cnic attachment/setup code, because I 
was not sure how that has changed with Yi's patches.
