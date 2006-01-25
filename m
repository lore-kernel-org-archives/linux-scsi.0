From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 2/3] SCSI Userspace Target: scsi tgt core functions
Date: Tue, 24 Jan 2006 20:58:07 -0600
Message-ID: <1138157887.11692.34.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:5505 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750979AbWAYC6d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 21:58:33 -0500
Received: from max (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0P2wWPK023602
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 20:58:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

SCSI Userspace Target code.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3c606cf..d09c792 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -27,6 +27,13 @@ config SCSI
 	  However, do not compile this as a module if your root file system
 	  (the one containing the directory /) is located on a SCSI device.
 
+config SCSI_TGT
+	tristate "SCSI target support"
+	depends on SCSI && EXPERIMENTAL
+	---help---
+	  If you want to use SCSI target mode drivers enable this option.
+	  If you choose M, the module will be called scsi_tgt.
+
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
 	depends on SCSI && PROC_FS
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index b9d2bb8..75cd7fc 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -21,6 +21,7 @@ CFLAGS_seagate.o =   -DARBITRATE -DPARIT
 subdir-$(CONFIG_PCMCIA)		+= pcmcia
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
+obj-$(CONFIG_SCSI_TGT)		+= scsi_tgt.o
 
 obj-$(CONFIG_RAID_ATTRS)	+= raid_class.o
 
@@ -155,6 +156,8 @@ scsi_mod-y			+= scsi.o hosts.o scsi_ioct
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 
+scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_nl.o
+
 sd_mod-objs	:= sd.o
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
new file mode 100644
index 0000000..9bc67f3
--- /dev/null
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -0,0 +1,396 @@
+/*
+ * SCSI target lib functions
+ *
+ * Copyright 2005 Mike Christie
+ * Copyright 2005 FUJITA Tomonori
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/module.h>
+#include <linux/pagemap.h>
+#include <linux/blkdev.h>
+#include <linux/elevator.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+#include "scsi_tgt_priv.h"
+
+static struct workqueue_struct *scsi_tgtd;
+
+/* set by interface */
+struct task_struct *tgtd_tsk;
+
+static void scsi_uspace_request_fn(struct request_queue *q)
+{
+	struct request *rq;
+	struct scsi_cmnd *cmd;
+
+	/*
+	 * TODO: just send everthing in the queue to userspace in
+	 * one vector instead of multiple calls
+	 */
+	while ((rq = elv_next_request(q)) != NULL) {
+		cmd = rq->special;
+
+		/* the completion code kicks us in case we hit this */
+		if (blk_queue_start_tag(q, rq))
+			break;
+
+		spin_unlock_irq(q->queue_lock);
+		if (scsi_tgt_uspace_send(cmd, scsilun_to_int(rq->end_io_data),
+					 GFP_ATOMIC) < 0)
+			goto requeue;
+		spin_lock_irq(q->queue_lock);
+	}
+
+	return;
+requeue:
+	spin_lock_irq(q->queue_lock);
+	/* need to track cnts and plug */
+	blk_requeue_request(q, rq);
+	spin_lock_irq(q->queue_lock);
+}
+
+/**
+ * scsi_tgt_alloc_queue - setup queue used for message passing
+ * shost: scsi host
+ *
+ * This should be called by the LLD after host allocation
+ **/
+int scsi_tgt_alloc_queue(struct Scsi_Host *shost)
+{
+	struct request_queue *q;
+
+	/*
+	 * uspace sets the noop scheduler for us since the others
+	 * are overkill
+	 *
+	 * Do we need to send a netlink event or should uspace
+	 * just respond to the hotplug event?
+	 */
+	q = __scsi_alloc_queue(shost, scsi_uspace_request_fn);
+	if (!q)
+		return -ENOMEM;
+
+	q->nr_requests = shost->hostt->can_queue;
+	blk_queue_init_tags(q, shost->hostt->can_queue, NULL);
+	shost->uspace_req_q = q;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_tgt_alloc_queue);
+
+/**
+ * scsi_tgt_queue_command - queue command for userspace processing
+ * @cmd:	scsi command
+ * @scsilun:	scsi lun
+ * @noblock:	set to nonzero if the command should be queued
+ **/
+void scsi_tgt_queue_command(struct scsi_cmnd *cmd, struct scsi_lun *scsilun,
+			    int noblock)
+{
+	/*
+	 * For now this just calls the request_fn from this context.
+	 * For HW llds though we do not want to execute from here so
+	 * the elevator code needs something like a REQ_TGT_CMD or
+	 * REQ_MSG_DONT_UNPLUG_IMMED_BECUASE_WE_WILL_HANDLE_IT
+	 */
+	cmd->request->end_io_data = scsilun;
+	elv_add_request(cmd->shost->uspace_req_q, cmd->request,
+			ELEVATOR_INSERT_BACK, 1);
+}
+EXPORT_SYMBOL_GPL(scsi_tgt_queue_command);
+
+/*
+ * We do not do clustering yet. We will when we convert to block layer fns
+ */
+static void scsi_unmap_user_pages(struct scsi_cmnd *cmd)
+{
+	struct scatterlist *sg = cmd->request_buffer;
+	struct page *page;
+	int i;
+
+	for (i = 0; i < cmd->use_sg; i++) {
+		page = sg[i].page;
+		if (!page)
+			break;
+		if (cmd->sc_data_direction == DMA_TO_DEVICE)
+			set_page_dirty_lock(page);
+		page_cache_release(page);
+	}
+}
+
+static void scsi_tgt_cmd_destroy(void *data)
+{
+	struct scsi_cmnd *cmd = data;
+
+	dprintk("cmd %p\n", cmd);
+
+	scsi_unmap_user_pages(cmd);
+	kfree(cmd->request_buffer);
+	scsi_tgt_uspace_send_status(cmd, GFP_KERNEL);
+	scsi_host_put_command(cmd);
+}
+
+/*
+ * This is run from a interrpt handler normally and the unmap
+ * needs process context so we must queue
+ */
+static void scsi_tgt_cmd_done(struct scsi_cmnd *cmd)
+{
+	dprintk("cmd %p\n", cmd);
+
+	INIT_WORK(&cmd->work, scsi_tgt_cmd_destroy, cmd);
+	queue_work(scsi_tgtd, &cmd->work);
+}
+
+static int __scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
+{
+	struct Scsi_Host *shost = cmd->shost;
+	int err;
+
+	dprintk("cmd %p\n", cmd);
+
+	err = shost->hostt->transfer_response(cmd, scsi_tgt_cmd_done);
+	switch (err) {
+	case SCSI_MLQUEUE_HOST_BUSY:
+	case SCSI_MLQUEUE_DEVICE_BUSY:
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static void scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
+{
+	int err;
+
+	err = __scsi_tgt_transfer_response(cmd);
+	if (!err)
+		return;
+
+	cmd->result = DID_BUS_BUSY << 16;
+	if (scsi_tgt_uspace_send_status(cmd, GFP_ATOMIC) <= 0)
+		/* the eh will have to pick this up */
+		printk(KERN_ERR "Could not send cmd %p status\n", cmd);
+}
+
+#define pgcnt(size, offset) \
+	((((size) + ((offset) & ~PAGE_CACHE_MASK)) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT)
+
+/*
+ * TODO: replace with block layer function or modify so it honors the LLD
+ * limits and can then be used by the ULDs. Or could we also have a
+ * get_user_pages() that takes a scatterlist.
+ *
+ * Instead we could create a fake /dev/sd entry for this target, and
+ * userspace could write a SG_IO command to it. The LLD queuecommand
+ * would either need to be able to handle this target command
+ * and initiator commands at the same time though (this would take some
+ * extra code).
+ */
+static int scsi_map_user_pages(struct scsi_cmnd *cmd, u64 offset, int rw)
+{
+	int i, err = -EIO, cnt;
+	struct page *page, **pages;
+	u64 poffset = offset & ~PAGE_MASK;
+	unsigned size, rest = cmd->request_bufflen;
+	struct scatterlist *sg;
+
+	cnt = pgcnt(cmd->request_bufflen, offset);
+	pages = kzalloc(cnt * sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	cmd->request_buffer = kmalloc(cnt * sizeof(struct scatterlist),
+				      GFP_KERNEL);
+	if (!cmd->request_buffer)
+		goto release_pages;
+	cmd->use_sg = cnt;
+
+	dprintk("cmd %p addr %p cnt %d\n", cmd, cmd->buffer, cnt);
+
+	down_read(&tgtd_tsk->mm->mmap_sem);
+	err = get_user_pages(tgtd_tsk, tgtd_tsk->mm, (unsigned long)cmd->buffer,
+			     cnt, rw == WRITE, 0, pages, NULL);
+	up_read(&tgtd_tsk->mm->mmap_sem);
+
+	if (err < cnt) {
+		printk(KERN_ERR "cannot get user pages %d %d\n", err, cnt);
+		err = -EIO;
+		goto free_sg;
+	}
+
+	/*
+	 * need to fix this for HW LLDs. We could do
+	 *
+	 * scsi_req_map_sg(cmd->request, tmp_sg, cnt, len, GFP_KERNEL);
+	 * blk_rq_map_sg(shost->uspace_req_q, rq, final_sg);
+	 *
+	 * but that seems like such a waste. We need to merge the rest of
+	 * SCSI ULD and blk layer scatterlist code into one nice api.
+	 * Also need to handle if we cannot get enough clustered pages
+	 * to do this in one call (need dma the command in mutliple
+	 * calls maybe??).
+	 */
+	sg = cmd->request_buffer;
+	for (i = 0; i < cnt; i++) {
+		size = min_t(u32, rest, PAGE_SIZE - poffset);
+
+		sg[i].page = pages[i];
+		sg[i].offset = poffset;
+		sg[i].length = size;
+
+		poffset = 0;
+		rest -= size;
+	}
+
+	return 0;
+
+free_sg:
+	kfree(cmd->request_buffer);
+release_pages:
+	for (i = 0; i < cnt; i++) {
+		page = pages[i];
+		if(!page)
+			break;
+		if (!err && rw == WRITE)
+			set_page_dirty_lock(page);
+		page_cache_release(page);
+	}
+	kfree(pages);
+
+	return err;
+}
+
+static void scsi_tgt_data_transfer_done(struct scsi_cmnd *cmd)
+{
+	if (!cmd->result) {
+		scsi_tgt_transfer_response(cmd);
+		return;
+	}
+
+	if (scsi_tgt_uspace_send_status(cmd, GFP_ATOMIC) <= 0)
+		/* the tgt uspace eh will have to pick this up */
+		printk(KERN_ERR "Could not send cmd %p status\n", cmd);
+}
+
+static int scsi_tgt_transfer_data(struct scsi_cmnd *cmd)
+{
+	int err;
+
+	err = cmd->shost->hostt->transfer_data(cmd, scsi_tgt_data_transfer_done);
+	switch (err) {
+		case SCSI_MLQUEUE_HOST_BUSY:
+		case SCSI_MLQUEUE_DEVICE_BUSY:
+			return -EAGAIN;
+	default:
+		return 0;
+	}
+}
+
+static int scsi_tgt_copy_sense(struct scsi_cmnd *cmd, unsigned long uaddr,
+				unsigned len)
+{
+	char __user *p = (char __user *) uaddr;
+
+	if (copy_from_user(cmd->sense_buffer, p,
+			   min_t(unsigned, SCSI_SENSE_BUFFERSIZE, len))) {
+		printk(KERN_ERR "Could not copy the sense buffer\n");
+		return -EIO;
+	}
+	return 0;
+}
+
+int scsi_tgt_kspace_exec(int host_no, u32 cid, int result, u32 len, u64 offset,
+			 unsigned long uaddr, u8 rw, u8 try_map)
+{
+	struct Scsi_Host *shost;
+	struct scsi_cmnd *cmd;
+	struct request *rq;
+	int err;
+
+	/* TODO: replace with a O(1) alg */
+	shost = scsi_host_lookup(host_no);
+	if (IS_ERR(shost)) {
+		printk(KERN_ERR "Could not find host no %d\n", host_no);
+		return -EINVAL;
+	}
+
+	rq = blk_queue_find_tag(shost->uspace_req_q, cid);
+	if (!rq) {
+		printk(KERN_ERR "Could not find cid %u\n", cid);
+		return -EINVAL;
+	}
+	cmd = rq->special;
+
+	dprintk("cmd %p result %d len %d bufflen %u\n", cmd,
+		result, len, cmd->request_bufflen);
+
+	cmd->buffer = (void *)uaddr;
+	cmd->result = result;
+	if (len)
+		cmd->request_bufflen = len;
+
+	if (!cmd->request_bufflen)
+		return __scsi_tgt_transfer_response(cmd);
+
+	/*
+	 * TODO: Do we need to handle case where request does not
+	 * align with LLD.
+	 */
+	err = scsi_map_user_pages(cmd, offset, rw);
+	if (err) {
+		eprintk("%p %d\n", cmd, err);
+		return -EAGAIN;
+	}
+
+	/* userspace failure */
+	if (cmd->result) {
+		if (status_byte(cmd->result) == CHECK_CONDITION)
+			scsi_tgt_copy_sense(cmd, uaddr, len);
+		return __scsi_tgt_transfer_response(cmd);
+	}
+	/* ask the target LLD to transfer the data to the buffer */
+	return scsi_tgt_transfer_data(cmd);
+}
+
+static int __init scsi_tgt_init(void)
+{
+	int err;
+
+	scsi_tgtd = create_workqueue("scsi_tgtd");
+	if (!scsi_tgtd)
+		return -ENOMEM;
+
+	err = scsi_tgt_nl_init();
+	if (err)
+		destroy_workqueue(scsi_tgtd);
+	return err;
+}
+
+static void __exit scsi_tgt_exit(void)
+{
+	destroy_workqueue(scsi_tgtd);
+	scsi_tgt_nl_exit();
+}
+
+module_init(scsi_tgt_init);
+module_exit(scsi_tgt_exit);
+
+MODULE_DESCRIPTION("SCSI target core");
+MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_tgt_nl.c b/drivers/scsi/scsi_tgt_nl.c
new file mode 100644
index 0000000..1bb308c
--- /dev/null
+++ b/drivers/scsi/scsi_tgt_nl.c
@@ -0,0 +1,188 @@
+/*
+ * Target Netlink Framework code
+ *
+ * (C) 2005 FUJITA Tomonori <tomof@acm.org>
+ * (C) 2005 Mike Christie <michaelc@cs.wisc.edu>
+ * This code is licenced under the GPL.
+ */
+
+#include <linux/netlink.h>
+#include <linux/blkdev.h>
+#include <net/tcp.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tgt_if.h>
+
+#include "scsi_tgt_priv.h"
+
+static int tgtd_pid;
+static struct sock *nls;
+
+int scsi_tgt_uspace_send(struct scsi_cmnd *cmd, u64 lun, gfp_t gfp_mask)
+{
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	struct tgt_event *ev;
+	char *pdu;
+	int len, err;
+
+	len = NLMSG_SPACE(sizeof(*ev) + MAX_COMMAND_SIZE);
+	/*
+	 * TODO: add MAX_COMMAND_SIZE to ev and add mempool
+	 */
+	skb = alloc_skb(NLMSG_SPACE(len), gfp_mask);
+	if (!skb)
+		return -ENOMEM;
+
+	dprintk("%p %d %Zd %d\n", cmd, len, sizeof(*ev), MAX_COMMAND_SIZE);
+	nlh = __nlmsg_put(skb, tgtd_pid, 0, TGT_KEVENT_CMD_REQ,
+			  len - sizeof(*nlh), 0);
+	ev = NLMSG_DATA(nlh);
+	memset(ev, 0, sizeof(*ev));
+
+	pdu = (char *) ev->data;
+	ev->k.cmd_req.host_no = cmd->shost->host_no;
+	ev->k.cmd_req.dev_id = lun;
+	ev->k.cmd_req.cid = cmd->request->tag;
+	ev->k.cmd_req.data_len = cmd->request_bufflen;
+	memcpy(ev->data, cmd->cmnd, MAX_COMMAND_SIZE);
+
+	err = netlink_unicast(nls, skb, tgtd_pid, 0);
+	if (err < 0)
+		printk(KERN_ERR "scsi_tgt_uspace_send: could not send skb "
+		      "to pid %d err %d\n", tgtd_pid, err);
+	return err;
+}
+
+static int send_event_res(uint16_t type, struct tgt_event *p,
+			  void *data, int dlen, gfp_t flags)
+{
+	struct tgt_event *ev;
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+	uint32_t len;
+
+	len = NLMSG_SPACE(sizeof(*ev) + dlen);
+	skb = alloc_skb(len, flags);
+	if (!skb)
+		return -ENOMEM;
+
+	nlh = __nlmsg_put(skb, tgtd_pid, 0, type, len - sizeof(*nlh), 0);
+
+	ev = NLMSG_DATA(nlh);
+	memcpy(ev, p, sizeof(*ev));
+	if (dlen)
+		memcpy(ev->data, data, dlen);
+
+	return netlink_unicast(nls, skb, tgtd_pid, 0);
+}
+
+int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+{
+	struct tgt_event ev;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.k.cmd_done.host_no = cmd->shost->host_no;
+	ev.k.cmd_done.cid = (unsigned long)cmd;
+	ev.k.cmd_done.result = cmd->result;
+
+	return send_event_res(TGT_KEVENT_CMD_DONE, &ev, NULL, 0, gfp_mask);
+}
+
+static int event_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
+{
+	struct tgt_event *ev = NLMSG_DATA(nlh);
+	int err = 0;
+
+	dprintk("%d %d %d\n", nlh->nlmsg_type,
+		nlh->nlmsg_pid, current->pid);
+
+	switch (nlh->nlmsg_type) {
+	case TGT_UEVENT_START:
+		tgtd_pid = NETLINK_CREDS(skb)->pid;
+		tgtd_tsk = current;
+		break;
+	case TGT_UEVENT_CMD_RES:
+		/* TODO: handle multiple cmds in one event */
+		err = scsi_tgt_kspace_exec(ev->u.cmd_res.host_no,
+					   ev->u.cmd_res.cid,
+					   ev->u.cmd_res.result,
+					   ev->u.cmd_res.len,
+					   ev->u.cmd_res.offset,
+					   ev->u.cmd_res.uaddr,
+					   ev->u.cmd_res.rw,
+					   ev->u.cmd_res.try_map);
+		break;
+	default:
+		eprintk("unknown type %d\n", nlh->nlmsg_type);
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+static int event_recv_skb(struct sk_buff *skb)
+{
+	int err;
+	uint32_t rlen;
+	struct nlmsghdr	*nlh;
+
+	while (skb->len >= NLMSG_SPACE(0)) {
+		nlh = (struct nlmsghdr *) skb->data;
+		if (nlh->nlmsg_len < sizeof(*nlh) || skb->len < nlh->nlmsg_len)
+			return 0;
+		rlen = NLMSG_ALIGN(nlh->nlmsg_len);
+		if (rlen > skb->len)
+			rlen = skb->len;
+		err = event_recv_msg(skb, nlh);
+
+		dprintk("%d %d\n", nlh->nlmsg_type, err);
+		/*
+		 * TODO for passthru commands the lower level should
+		 * probably handle the result or we should modify this
+		 */
+		if (nlh->nlmsg_type != TGT_UEVENT_CMD_RES) {
+			struct tgt_event ev;
+
+			memset(&ev, 0, sizeof(ev));
+			ev.k.event_res.err = err;
+			send_event_res(TGT_KEVENT_RESPONSE, &ev, NULL, 0,
+				       GFP_KERNEL | __GFP_NOFAIL);
+		}
+		skb_pull(skb, rlen);
+	}
+	return 0;
+}
+
+static void event_recv(struct sock *sk, int length)
+{
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&sk->sk_receive_queue))) {
+		if (NETLINK_CREDS(skb)->uid) {
+			skb_pull(skb, skb->len);
+			kfree_skb(skb);
+			continue;
+		}
+
+		if (event_recv_skb(skb) && skb->len)
+			skb_queue_head(&sk->sk_receive_queue, skb);
+		else
+			kfree_skb(skb);
+	}
+}
+
+void __exit scsi_tgt_nl_exit(void)
+{
+	sock_release(nls->sk_socket);
+}
+
+int __init scsi_tgt_nl_init(void)
+{
+	nls = netlink_kernel_create(NETLINK_TGT, 1, event_recv,
+				    THIS_MODULE);
+	if (!nls)
+		return -ENOMEM;
+
+	return 0;
+}
diff --git a/drivers/scsi/scsi_tgt_priv.h b/drivers/scsi/scsi_tgt_priv.h
new file mode 100644
index 0000000..23aba10
--- /dev/null
+++ b/drivers/scsi/scsi_tgt_priv.h
@@ -0,0 +1,22 @@
+struct scsi_cmnd;
+struct task_struct;
+
+/* tmp - will replace with SCSI logging stuff */
+#define dprintk(fmt, args...)					\
+do {								\
+	printk("%s(%d) " fmt, __FUNCTION__, __LINE__, ##args);	\
+} while (0)
+
+#define eprintk dprintk
+
+
+extern struct task_struct *tgtd_tsk;
+
+extern void scsi_tgt_nl_exit(void);
+extern int scsi_tgt_nl_init(void);
+
+extern int scsi_tgt_uspace_send(struct scsi_cmnd *cmd, u64 lun, gfp_t gfp_mask);
+extern int scsi_tgt_uspace_send_status(struct scsi_cmnd *cmd, gfp_t flags);
+extern int scsi_tgt_kspace_exec(int host_no, u32 cid, int result, u32 len,
+				u64 offset, unsigned long uaddr, u8 rw,
+				u8 try_map);
diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 6a2ccf7..580fb42 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -21,6 +21,7 @@
 #define NETLINK_DNRTMSG		14	/* DECnet routing messages */
 #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
 #define NETLINK_GENERIC		16
+#define NETLINK_TGT		17	/* SCSI target */
 
 #define MAX_LINKS 32		
 
diff --git a/include/scsi/scsi_tgt.h b/include/scsi/scsi_tgt.h
new file mode 100644
index 0000000..c1dc0d2
--- /dev/null
+++ b/include/scsi/scsi_tgt.h
@@ -0,0 +1,10 @@
+/*
+ * SCSI target definitions
+ */
+
+struct Scsi_Host;
+struct scsi_cmnd;
+struct scsi_lun;
+
+extern int scsi_tgt_alloc_queue(struct Scsi_Host *);
+extern void scsi_tgt_queue_command(struct scsi_cmnd *, struct scsi_lun *, int);
diff --git a/include/scsi/scsi_tgt_if.h b/include/scsi/scsi_tgt_if.h
new file mode 100644
index 0000000..fe5f0f9
--- /dev/null
+++ b/include/scsi/scsi_tgt_if.h
@@ -0,0 +1,70 @@
+/*
+ * SCSI target netlink interface
+ *
+ * (C) 2005 FUJITA Tomonori <tomof@acm.org>
+ * (C) 2005 Mike Christie <michaelc@cs.wisc.edu>
+ * This code is licenced under the GPL.
+ */
+
+#ifndef SCSI_TARGET_FRAMEWORK_IF_H
+#define SCSI_TARGET_FRAMEWORK_IF_H
+
+enum tgt_event_type {
+	/* user -> kernel */
+	TGT_UEVENT_START,
+	TGT_UEVENT_TARGET_SETUP,
+	TGT_UEVENT_CMD_RES,
+
+	/* kernel -> user */
+	TGT_KEVENT_RESPONSE,
+	TGT_KEVENT_CMD_REQ,
+	TGT_KEVENT_CMD_DONE,
+};
+
+struct tgt_event {
+	/* user-> kernel */
+	union {
+		struct {
+			int host_no;
+			int pid;
+		} setup_target;
+		struct {
+			int host_no;
+			uint32_t cid;
+			uint32_t len;
+			int result;
+			uint64_t uaddr;
+			uint64_t offset;
+			uint8_t rw;
+			uint8_t try_map;
+		} cmd_res;
+	} u;
+
+	/* kernel -> user */
+	union {
+		struct {
+			int err;
+		} event_res;
+		struct {
+			int host_no;
+			uint32_t cid;
+			uint32_t data_len;
+			uint64_t dev_id;
+		} cmd_req;
+		struct {
+			int host_no;
+			uint32_t cid;
+			int result;
+		} cmd_done;
+	} k;
+
+	/*
+	 * I think a pointer is a unsigned long but this struct
+	 * gets passed around from the kernel to userspace and
+	 * back again so to handle some ppc64 setups where userspace is
+	 * 32 bits but the kernel is 64 we do this odd thing
+	 */
+	uint64_t data[0];
+} __attribute__ ((aligned (sizeof(uint64_t))));
+
+#endif


