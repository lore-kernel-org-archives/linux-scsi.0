Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792672484;
	b=SHPv8vSQQN/izN+coaHeckripRUMjujOJQp5XjK6JC5f3Mr3JzlDndhgoKMhCSLn41DF
	 Nj8Ub/NIFrFTxmLCJ88Z2uMP4Vo9iew6rx+w9yZ1LkMmspaolq9SixvT1kzU3Mzay2yLQ
	 LDqVxrv8LOgsuQjLBfNsk1GqrYoZejUwA7JazMCSQ3GEeDiqcyp2jO3M2KPdBVwubaTkc
	 i+czrmyXr64WYVRI4O3gP/fLKrVDPWjXfEk8JezRsYoV/EJIAJM6htR6cQJKcf7R1MpzJ
	 oZkJlVAjwF2JyREK3dm+EitabndgfRYaavrv3/KG1aqWY80zGyviTbzuRAApYHTwKTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792672484;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VxTZnnG66pwJ9HY2lI8ifKVWqHAeCYrvLO5TVkcU4YI=;
	b=dnJ1BVXIjSt2kiTIw7+SB7PNBZtC/xYjV0Ql6O3bVRCuW/ebRizqBIR9X8u3WBU8Xezt
	 Bs2nEzPcxugDdbYxfAO0oFnO4QiNRfTT1dH13Bo/WpbubvnJPBgR3q8cqOfcksHmZU7QZ
	 uM5UO/guiGOrqH31NWdFACipUOp+PYLBsZLR+Cn9Svs5D7PNiM4yFq5Fwi3nd/yGL+J2e
	 rzPTwY2YXkOE5iqVHPK4KO5jbsZMLOxXQKew9wDQ5OKo00z0cdDjseNnbO+UzvHSTA224
	 ybrPC2Q1gd3ItfpCUJpHcbxJ5sedbUZxiLXr/SfbS8ehbapRqoOjEmZKCw2bGzBh4wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49717606A319;
	Thu, 22 Oct 2026 12:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49717606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ede30ec2ce1411f19a56ed5b684f684d-20261022
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:7b9ccc3a-1805-460e-bbb8-a3ece45eacc6,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:a6f73f7be717ca63da50b71566187043,BulkI
	D:nil,BulkQuantity:0,SF:102|865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ede30ec2ce1411f19a56ed5b684f684d-20261022
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1085046884; Thu, 22 Oct 2026 20:34:31 +0800
From: Jiayi Li <lijiayi@kylinos.cn>
To: Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Michal Pecio <michal.pecio@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH] usb: uas: wait for pending commands before unbinding
Date: Thu, 22 Oct 2026 20:34:01 +0800
Message-Id: <20261022123401.319479-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

USB core normally disables interface endpoints before calling
uas_disconnect(). This cancels pending URBs while the device may still
be processing the associated commands. Some storage bridges then stop
responding after a driver rebind and need a disconnect and reconnect
to recover.

Enable soft unbinding and block new SCSI requests before waiting for
pending commands to finish. This keeps the endpoints available until
the wait completes. Stop waiting when USB core marks the device as
not attached, and continue with the existing cleanup on timeout.

Keep requests blocked when leaving the preparation step, including on
timeout. Set resetting before unblocking the host so that queued
requests cannot submit new URBs during teardown.

---
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 2651629..58a67d7 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/module.h>
@@ -1211,16 +1212,55 @@ static int uas_reset_resume(struct usb_interface *intf)
 	return 0;
 }
 
+static void uas_pre_disconnect(struct usb_interface *intf)
+{
+	struct Scsi_Host *shost = usb_get_intfdata(intf);
+	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
+	unsigned long flags, start_time;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	scsi_block_requests(shost);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	start_time = jiffies;
+	for (;;) {
+		if (READ_ONCE(devinfo->udev->state) == USB_STATE_NOTATTACHED)
+			return;
+
+		flush_work(&devinfo->work);
+
+		if (!usb_wait_anchor_empty_timeout(&devinfo->sense_urbs, 5000))
+			break;
+
+		if (!usb_wait_anchor_empty_timeout(&devinfo->data_urbs, 500))
+			break;
+
+		if (time_after(jiffies, start_time + 5 * HZ))
+			break;
+		if (uas_cmnd_list_empty(devinfo))
+			return;
+
+		msleep(20);
+	}
+
+	shost_printk(KERN_ERR, shost, "%s: timed out\n", __func__);
+}
+
 static void uas_disconnect(struct usb_interface *intf)
 {
 	struct Scsi_Host *shost = usb_get_intfdata(intf);
 	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
 	unsigned long flags;
 
+	uas_pre_disconnect(intf);
+
 	spin_lock_irqsave(&devinfo->lock, flags);
 	devinfo->resetting = 1;
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 
+	if (shost->host_self_blocked)
+		scsi_unblock_requests(shost);
+
 	cancel_work_sync(&devinfo->work);
 	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
 	usb_kill_anchored_urbs(&devinfo->sense_urbs);
@@ -1260,6 +1300,7 @@ static void uas_shutdown(struct usb_interface *intf)
 
 static struct usb_driver uas_driver = {
 	.name = "uas",
+	.soft_unbind = 1,
 	.probe = uas_probe,
 	.disconnect = uas_disconnect,
 	.pre_reset = uas_pre_reset,
