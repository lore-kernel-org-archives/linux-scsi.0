Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC6A37F33D;
	Tue, 22 Sep 2026 03:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790046693; cv=none; b=Nuo1qhYdVbwar+nHmYkxpLAZYzEwtTbz0FTU6JVews6X9xlfqNKR6j9ANWbIEIVfc3KUway3iLMMDftTbzzKPnBKlqbZdpLafhUptQhbQKKU+1wHjK5ByoTsKHdwMN0JFvh5iJwWMW9pyX4LXlfP8DuzpKQqKJ6QdXRuJY5YODo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790046693; c=relaxed/simple;
	bh=lQ68GCEp0M1/8iWXnt1MdgLFrQR9b+XzPvlHTeQbjoM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XXeXsOb8pKDkdffOaLyci2X6C4ywYiw+tzaLsnmrxBPYGh5AOOrL1qALJAGxLOS1xTLQtaCSmfSWolaIgJ0tRO86gWYXc283rZToTWz4EpDEM0iHx8FDIomoSruWOeOsg12ZBRoRIm3Jq84nP+oEnBy60XirSm71WGTSa1LT1Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 453a1c78b63311f19a56ed5b684f684d-20260922
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:142be212-b367-46c9-9856-2bd415814978,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:7db8b62,CLOUDID:7d093fac6273d8700a5a3c8a794578fd,BulkI
	D:nil,BulkQuantity:0,SF:102|865|898,TC:nil,Content:0|15|50|99,EDM:5,IP:nil
	,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 453a1c78b63311f19a56ed5b684f684d-20260922
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1234149315; Tue, 22 Sep 2026 11:11:14 +0800
From: Jiayi Li <lijiayi@kylinos.cn>
To: Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Michal Pecio <michal.pecio@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org,
	Jiayi Li <lijiayi@kylinos.cn>
Subject: [PATCH v2] usb: uas: quiesce SCSI before stopping endpoints on unbind
Date: Tue, 22 Sep 2026 11:11:02 +0800
Message-Id: <20260922031102.141043-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unbinding uas while READ commands are in flight can leave the storage
device unusable after the driver is rebound.  The first post-bind
INQUIRY Data-In transfer completes with -EOVERFLOW, and SCSI error
handling eventually offlines the device:

  scsi host7: uas
  scsi 7:0:0:0: tag#4 data cmplt err -75 uas-tag 1 inflight: CMD
  scsi 7:0:0:0: tag#4 CDB: Inquiry 12 00 00 00 24 00
  scsi 7:0:0:0: tag#4 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD
  usb 2-2: reset SuperSpeed USB device number 2 using xhci_hcd
  scsi host7: uas_eh_device_reset_handler success
  ...
  scsi 7:0:0:0: tag#7 CDB: Test Unit Ready 00 00 00 00 00 00
  scsi host7: uas_eh_device_reset_handler success
  sd 7:0:0:0: Device offlined - not ready after error recovery

A command URB may already have delivered a SCSI command when usbcore
disables the interface endpoints and kills the data and status URBs
before ->disconnect.  uas_disconnect() then removes the SCSI host only
after killing its anchored URBs, so SCSI teardown cannot first quiesce
the accepted commands.  A newly bound UAS instance can encounter the
residual transport state.

The failure reproduced with a VIA Labs 2109:0715 storage bridge on both
Zhaoxin 1d17:9204 and Intel 8086:a2af xHCI controllers.  USB device reset
and xHCI unbind/rebind did not recover the device; physical reconnection
did.

Set soft_unbind so the endpoints remain available during driver unbind.
Cancel pending scanning and remove the SCSI host before setting resetting
and killing the anchored URBs.  Use the same teardown order for every
disconnect path and rely on SCSI host removal to handle a device that can
no longer communicate.

With the change, 10 of 10 zero-delay unbind/rebind iterations with 30
READ commands in flight reattached the disk and completed a post-bind
O_DIRECT read.  Unbind took 82 to 109 ms, with no UAS completion error or
command timeout after rebind.

Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>
---
Changes in v2:
- Remove the USB_STATE_NOTATTACHED-based disconnect classification.
- Use the same teardown ordering for all disconnect paths.
- Reword the commit message.

Link: https://lore.kernel.org/lkml/20260920012358.3362053-1-lijiayi@kylinos.cn/

 drivers/usb/storage/uas.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 8655edbd66b16..8752cecb45915 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1217,6 +1217,14 @@ static void uas_disconnect(struct usb_interface *intf)
 	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
 	unsigned long flags;
 
+	/*
+	 * Prevent SCSI scanning (if it hasn't started yet)
+	 * or wait for the SCSI-scanning routine to stop.
+	 */
+	cancel_work_sync(&devinfo->scan_work);
+
+	scsi_remove_host(shost);
+
 	spin_lock_irqsave(&devinfo->lock, flags);
 	devinfo->resetting = 1;
 	spin_unlock_irqrestore(&devinfo->lock, flags);
@@ -1227,13 +1235,6 @@ static void uas_disconnect(struct usb_interface *intf)
 	usb_kill_anchored_urbs(&devinfo->data_urbs);
 	uas_zap_pending(devinfo, DID_NO_CONNECT);
 
-	/*
-	 * Prevent SCSI scanning (if it hasn't started yet)
-	 * or wait for the SCSI-scanning routine to stop.
-	 */
-	cancel_work_sync(&devinfo->scan_work);
-
-	scsi_remove_host(shost);
 	uas_free_streams(devinfo);
 	scsi_host_put(shost);
 }
@@ -1267,6 +1268,7 @@ static struct usb_driver uas_driver = {
 	.suspend = uas_suspend,
 	.resume = uas_resume,
 	.reset_resume = uas_reset_resume,
+	.soft_unbind = 1,
 	.shutdown = uas_shutdown,
 	.id_table = uas_usb_ids,
 };
