Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E287242922;
	Tue, 15 Apr 2025 09:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744710474; cv=none; b=X3vH9/I0ZXaiTB91UgAuahsiweIIsn9YKYVBJlSnVoVwcERIapUOaS9ifmxpydMEiMDnTIJaaSv+kVLk0Ho24RcnjUn+btK5YTTrylNxtkcHDR3oEoEKGyvXzZspyU774su8vExs2sj4mDiZev7GOsfRxPySFKlGtN6vwWda8GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744710474; c=relaxed/simple;
	bh=jS/+2OJPyZ3oKIEjOakuHXM2rsqbRqWQE4x118sJ64g=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=H1I0ttI2HTlMTFLyYduF5oGqYOUSoS8fUG/XpR0CFiItR2stAR1AgObprEqlX2k7FYN1pxF7RX56UdaAhxwn+97GUZUGKq3hoT3d15coBGrb4JX6xU2A249YKRqkgBb1Siem24kuhwXSVUU2DwA6JT8dcmMNjhWZ4Y9kLdZjSEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ac4c985219de11f0a216b1d71e6e1362-20250415
X-CID-CACHE: Type:Local,Time:202504151727+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:3b51f057-3b06-44d4-9b2a-22a6424bd06e,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:91d667a05389e8de83db14486b642671,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:5,IP:nil,URL
	:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SP
	R:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: ac4c985219de11f0a216b1d71e6e1362-20250415
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <liujiajia@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 992271736; Tue, 15 Apr 2025 17:47:41 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 6CBB3E000081;
	Tue, 15 Apr 2025 17:47:40 +0800 (CST)
X-ns-mid: postfix-67FE2B3B-868366657
Received: from kylin.lan (unknown [172.25.120.81])
	by mail.kylinos.cn (NSMail) with ESMTPA id 1BD9EE000F3B;
	Tue, 15 Apr 2025 17:47:37 +0800 (CST)
From: Jiajia Liu <liujiajia@kylinos.cn>
To: Jens Axboe <axboe@kernel.dk>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: fix potential USB flash loss after reboot
Date: Tue, 15 Apr 2025 17:47:37 +0800
Message-Id: <20250415094737.1394310-1-liujiajia@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

If device shutdown is blocking for a few seconds after xhci_pci_shutdown,
disk_check_events will get scheduled becase block.events_dfl_poll_msecs
is set to 2000 by user space. usb-storage can get USB access error and
then call usb_reset_device.

Some SanDisk USB flashes, 0781:5567 and 0781:5581, are lost after reboot.

This can be simulated by injecting mdelay(5000) at the end of
i915_driver_shutdown. Add event block in sd_shutdown to prevent
disk_check_events scheduled during the potential blocking.

[   27.324042][    T1] shutdown[1]: Rebooting.
[   27.548410][    T1] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[   30.060554][  T225] usb 4-4: device not accepting address 2, error -10=
8
[   32.838110][    T1] ACPI: PM: Preparing to enter system sleep state S5
[   32.851746][    T1] reboot: Restarting system
[   32.856127][    T1] reboot: machine restart

Before bd738d859e71 ("drm/i915: Prevent modesets during driver init/ shut=
down"),
plymouthd can commit modeset during i915 shutdown process, this brings
ten seconds delay.

[   36.519606][    T1] shutdown[1]: Rebooting.
[   36.763427][    T1] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[   37.229513][ T7030] i915 0000:00:02.0: drm_WARN_ON(!intel_irqs_enabled=
(dev_priv))
...
[   39.008748][ T4356] usb 4-4: device not accepting address 2, error -10=
8
[   43.116781][ T4356] usb usb4-port4: Cannot enable. Maybe the USB cable=
 is bad?
[   47.196768][  T185] usb usb4-port4: Cannot enable. Maybe the USB cable=
 is bad?
[   47.204511][  T185] usb 4-4: USB disconnect, device number 2
[   48.438385][    T1] i915 0000:00:02.0: i915 raw-wakerefs=3D6 wakelocks=
=3D6 on cleanup

Signed-off-by: Jiajia Liu <liujiajia@kylinos.cn>
---
 block/disk-events.c    | 1 +
 drivers/scsi/sd.c      | 4 ++++
 drivers/scsi/sd.h      | 1 +
 include/linux/blkdev.h | 1 +
 4 files changed, 7 insertions(+)

diff --git a/block/disk-events.c b/block/disk-events.c
index 2f697224386a..2c998fb360a5 100644
--- a/block/disk-events.c
+++ b/block/disk-events.c
@@ -94,6 +94,7 @@ void disk_block_events(struct gendisk *disk)
=20
 	mutex_unlock(&ev->block_mutex);
 }
+EXPORT_SYMBOL_GPL(disk_block_events);
=20
 static void __disk_unblock_events(struct gendisk *disk, bool check_now)
 {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 950d8c9fb884..86199991f2e3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4064,6 +4064,7 @@ static int sd_remove(struct device *dev)
=20
 	device_del(&sdkp->disk_dev);
 	del_gendisk(sdkp->disk);
+	sdkp->remove =3D 1;
 	if (!sdkp->suspended)
 		sd_shutdown(dev);
=20
@@ -4162,6 +4163,9 @@ static void sd_shutdown(struct device *dev)
 	if (!sdkp)
 		return;         /* this can happen */
=20
+	if (sdkp->device->removable && !sdkp->remove)
+		disk_block_events(sdkp->disk);
+
 	if (pm_runtime_suspended(dev))
 		return;
=20
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 36382eca941c..ff7004681267 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -156,6 +156,7 @@ struct scsi_disk {
 	unsigned	ignore_medium_access_errors : 1;
 	unsigned	rscs : 1; /* reduced stream control support */
 	unsigned	use_atomic_write_boundary : 1;
+	unsigned	remove : 1;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
=20
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e39c45bc0a97..7739713c5202 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -879,6 +879,7 @@ int __register_blkdev(unsigned int major, const char =
*name,
 void unregister_blkdev(unsigned int major, const char *name);
=20
 bool disk_check_media_change(struct gendisk *disk);
+void disk_block_events(struct gendisk *disk);
 void set_capacity(struct gendisk *disk, sector_t size);
=20
 #ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
--=20
2.25.1

