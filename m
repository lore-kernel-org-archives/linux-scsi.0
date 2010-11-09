From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix vulnerability in file operations of scsi target interface
Date: Tue, 9 Nov 2010 22:01:32 +0800
Message-ID: <AANLkTin+Epf5WuD9sV=kNNgVXo5No4euF=6VoSOkFK12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64227 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0KIOBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 09:01:36 -0500
Received: by wwb39 with SMTP id 39so13498wwb.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2010 06:01:34 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Ring buffers are setup for exchanging data between K and U spaces, but
they could not survive multiple open operations.

The registered misc interface is monitored and prevented from multiple
opens for fixing the vulnerability.

A typo, -BUSY, is also cleaned up.

btw, the ring buffers could be setup in a per file manner?

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_tgt_if.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_tgt_if.c	2010-11-09 21:42:48.000000000 +0800
@@ -85,7 +85,7 @@ static int tgt_uspace_send_event(u32 typ
 	if (!ev->hdr.status)
 		tgt_ring_idx_inc(ring);
 	else
-		err = -BUSY;
+		err = -EBUSY;

 	spin_unlock_irqrestore(&ring->tr_lock, flags);

@@ -319,20 +319,33 @@ static int tgt_mmap(struct file *filp, s
 	return err;
 }

+static unsigned long tgt_open_cnt = 0;
+
 static int tgt_open(struct inode *inode, struct file *file)
 {
+	if (tgt_open_cnt)
+		return -EBUSY;
+	tgt_open_cnt++;
+
 	tx_ring.tr_idx = rx_ring.tr_idx = 0;

 	cycle_kernel_lock();
 	return 0;
 }

+static int tgt_release(struct inode *inode, struct file *file)
+{
+	tgt_open_cnt--;
+	return 0;
+}
+
 static const struct file_operations tgt_fops = {
 	.owner		= THIS_MODULE,
 	.open		= tgt_open,
 	.poll		= tgt_poll,
 	.write		= tgt_write,
 	.mmap		= tgt_mmap,
+	.release	= tgt_release,
 };

 static struct miscdevice tgt_miscdev = {
