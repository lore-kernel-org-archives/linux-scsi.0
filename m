From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 4/4] ps3flash: updates after final review
Date: Thu, 19 Jul 2007 15:55:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707191554590.8661@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
 <20070716162206.392129000@pademelon.sonytel.be> <20070718163637.3f0e0164.akpm@linux-foundation.org>
 <Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
 <20070719021045.c0b994ca.akpm@linux-foundation.org>
 <Pine.LNX.4.62.0707191548070.8661@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1387873921-1184853320=:8661"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43807 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S938105AbXGSNzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2007 09:55:22 -0400
In-Reply-To: <Pine.LNX.4.62.0707191548070.8661@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1387873921-1184853320=:8661
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

ps3flash: updates after final review:
  o Kill confusing ps3flash_priv() macro, open code it instead
  o ps3flash_llseek(): Add missing locking (using i_mutex)
  o Replace do_div_llr() by `/' and `%'
  o ps3flash_read(): Use a common return for the error path
  o Minor coding style fixes not reported by checkpatch

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/char/ps3flash.c |   59 ++++++++++++++++++++++++++++--------------------
 1 files changed, 35 insertions(+), 24 deletions(-)

--- a/drivers/char/ps3flash.c
+++ b/drivers/char/ps3flash.c
@@ -34,7 +34,6 @@
 struct ps3flash_private {
 	struct mutex mutex;	/* Bounce buffer mutex */
 };
-#define ps3flash_priv(dev)	((dev)->sbd.core.driver_data)
 
 static struct ps3_storage_device *ps3flash_dev;
 
@@ -81,28 +80,35 @@ static ssize_t ps3flash_write_chunk(stru
 static loff_t ps3flash_llseek(struct file *file, loff_t offset, int origin)
 {
 	struct ps3_storage_device *dev = ps3flash_dev;
-	u64 size = dev->regions[dev->region_idx].size*dev->blk_size;
+	loff_t res;
 
+	mutex_lock(&file->f_mapping->host->i_mutex);
 	switch (origin) {
 	case 1:
 		offset += file->f_pos;
 		break;
 	case 2:
-		offset += size;
+		offset += dev->regions[dev->region_idx].size*dev->blk_size;
 		break;
 	}
-	if (offset < 0)
-		return -EINVAL;
+	if (offset < 0) {
+		res = -EINVAL;
+		goto out;
+	}
 
 	file->f_pos = offset;
-	return file->f_pos;
+	res = file->f_pos;
+
+out:
+	mutex_unlock(&file->f_mapping->host->i_mutex);
+	return res;
 }
 
 static ssize_t ps3flash_read(struct file *file, char __user *buf, size_t count,
 			     loff_t *pos)
 {
 	struct ps3_storage_device *dev = ps3flash_dev;
-	struct ps3flash_private *priv = ps3flash_priv(dev);
+	struct ps3flash_private *priv = dev->sbd.core.driver_data;
 	u64 size, start_sector, end_sector, offset;
 	ssize_t sectors_read;
 	size_t remaining, n;
@@ -115,15 +121,16 @@ static ssize_t ps3flash_read(struct file
 	if (*pos >= size || !count)
 		return 0;
 
-	if (*pos+count > size) {
+	if (*pos + count > size) {
 		dev_dbg(&dev->sbd.core,
 			"%s:%u Truncating count from %zu to %llu\n", __func__,
 			__LINE__, count, size - *pos);
 		count = size - *pos;
 	}
 
-	start_sector = do_div_llr(*pos, dev->blk_size, &offset);
-	end_sector = DIV_ROUND_UP(*pos+count, dev->blk_size);
+	start_sector = *pos / dev->blk_size;
+	offset = *pos % dev->blk_size;
+	end_sector = DIV_ROUND_UP(*pos + count, dev->blk_size);
 
 	remaining = count;
 	do {
@@ -134,7 +141,7 @@ static ssize_t ps3flash_read(struct file
 						     0);
 		if (sectors_read < 0) {
 			mutex_unlock(&priv->mutex);
-			return sectors_read;
+			goto fail;
 		}
 
 		n = min(remaining, sectors_read*dev->blk_size-offset);
@@ -143,7 +150,8 @@ static ssize_t ps3flash_read(struct file
 			__func__, __LINE__, n, dev->bounce_buf+offset, buf);
 		if (copy_to_user(buf, dev->bounce_buf+offset, n)) {
 			mutex_unlock(&priv->mutex);
-			return -EFAULT;
+			sectors_read = -EFAULT;
+			goto fail;
 		}
 
 		mutex_unlock(&priv->mutex);
@@ -156,13 +164,16 @@ static ssize_t ps3flash_read(struct file
 	} while (remaining > 0);
 
 	return count;
+
+fail:
+	return sectors_read;
 }
 
 static ssize_t ps3flash_write(struct file *file, const char __user *buf,
 			      size_t count, loff_t *pos)
 {
 	struct ps3_storage_device *dev = ps3flash_dev;
-	struct ps3flash_private *priv = ps3flash_priv(dev);
+	struct ps3flash_private *priv = dev->sbd.core.driver_data;
 	u64 size, chunk_sectors, start_write_sector, end_write_sector,
 	    end_read_sector, start_read_sector, head, tail, offset;
 	ssize_t res;
@@ -177,7 +188,7 @@ static ssize_t ps3flash_write(struct fil
 	if (*pos >= size || !count)
 		return 0;
 
-	if (*pos+count > size) {
+	if (*pos + count > size) {
 		dev_dbg(&dev->sbd.core,
 			"%s:%u Truncating count from %zu to %llu\n", __func__,
 			__LINE__, count, size - *pos);
@@ -186,13 +197,13 @@ static ssize_t ps3flash_write(struct fil
 
 	chunk_sectors = dev->bounce_size / dev->blk_size;
 
-	start_write_sector = do_div_llr(*pos, dev->bounce_size, &offset) *
-			     chunk_sectors;
-	end_write_sector = DIV_ROUND_UP(*pos+count, dev->bounce_size) *
+	start_write_sector = *pos / dev->bounce_size * chunk_sectors;
+	offset = *pos % dev->bounce_size;
+	end_write_sector = DIV_ROUND_UP(*pos + count, dev->bounce_size) *
 			   chunk_sectors;
 
 	end_read_sector = DIV_ROUND_UP(*pos, dev->blk_size);
-	start_read_sector = (*pos+count) / dev->blk_size;
+	start_read_sector = (*pos + count) / dev->blk_size;
 
 	/*
 	 * As we have to write in 256 KiB chunks, while we can read in blk_size
@@ -204,8 +215,8 @@ static ssize_t ps3flash_write(struct fil
 	 * All of this is complicated by using only one 256 KiB bounce buffer.
 	 */
 
-	head = end_read_sector-start_write_sector;
-	tail = end_write_sector-start_read_sector;
+	head = end_read_sector - start_write_sector;
+	tail = end_write_sector - start_read_sector;
 
 	remaining = count;
 	do {
@@ -355,7 +366,7 @@ static int __devinit ps3flash_probe(stru
 		goto fail;
 	}
 
-	ps3flash_priv(dev) = priv;
+	dev->sbd.core.driver_data = priv;
 	mutex_init(&priv->mutex);
 
 	dev->bounce_size = ps3flash_bounce_buffer.size;
@@ -381,7 +392,7 @@ fail_teardown:
 	ps3stor_teardown(dev);
 fail_free_priv:
 	kfree(priv);
-	ps3flash_priv(dev) = NULL;
+	dev->sbd.core.driver_data = NULL;
 fail:
 	ps3flash_dev = NULL;
 	return error;
@@ -393,8 +404,8 @@ static int ps3flash_remove(struct ps3_sy
 
 	misc_deregister(&ps3flash_misc);
 	ps3stor_teardown(dev);
-	kfree(ps3flash_priv(dev));
-	ps3flash_priv(dev) = NULL;
+	kfree(dev->sbd.core.driver_data);
+	dev->sbd.core.driver_data = NULL;
 	ps3flash_dev = NULL;
 	return 0;
 }

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1387873921-1184853320=:8661--
