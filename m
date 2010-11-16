From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] fix vulnerability in file operations of scsi target interface
Date: Tue, 16 Nov 2010 22:15:54 +0800
Message-ID: <AANLkTi=sLOoXb7ohqh3YLhQjac_zYL3Tkvp8Jh_z1Q4q@mail.gmail.com>
References: <AANLkTin+Epf5WuD9sV=kNNgVXo5No4euF=6VoSOkFK12@mail.gmail.com>
	<4CD98FC6.9000108@cisco.com>
	<AANLkTimN+nhY+SDApbcpJ41z9jPTu6jj0RmYjNYNyo5+@mail.gmail.com>
	<4CDC3A39.6020801@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56704 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0KPOP5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2010 09:15:57 -0500
Received: by eye27 with SMTP id 27so267001eye.19
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2010 06:15:56 -0800 (PST)
In-Reply-To: <4CDC3A39.6020801@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: linux-scsi@vger.kernel.org

This is the refined version based upon the guidance of Joe, and is safer.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_tgt_if.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/scsi_tgt_if.c	2010-11-16 22:10:20.000000000 +0800
@@ -84,7 +84,7 @@ static int tgt_uspace_send_event(u32 typ
 	if (!ev->hdr.status)
 		tgt_ring_idx_inc(ring);
 	else
-		err = -BUSY;
+		err = -EBUSY;

 	spin_unlock_irqrestore(&ring->tr_lock, flags);

@@ -318,9 +318,31 @@ static int tgt_mmap(struct file *filp, s
 	return err;
 }

+static unsigned long tgt_busy = 0;
+
 static int tgt_open(struct inode *inode, struct file *file)
 {
-	tx_ring.tr_idx = rx_ring.tr_idx = 0;
+	int err = -EBUSY;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx_ring.tr_lock, flags);
+	if (! tgt_busy) {
+		tgt_busy++;
+		tx_ring.tr_idx = rx_ring.tr_idx = 0;
+		err = 0;
+	}
+	spin_unlock_irqrestore(&tx_ring.tr_lock, flags);
+
+	return err;
+}
+
+static int tgt_release(struct inode *inode, struct file *file)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx_ring.tr_lock, flags);
+	tgt_busy = 0;
+	spin_unlock_irqrestore(&tx_ring.tr_lock, flags);

 	return 0;
 }
@@ -332,6 +354,7 @@ static const struct file_operations tgt_
 	.write		= tgt_write,
 	.mmap		= tgt_mmap,
 	.llseek		= noop_llseek,
+	.release	= tgt_release,
 };

 static struct miscdevice tgt_miscdev = {
