From: Xinwei Kong <kong.kongxinwei@hisilicon.com>
Subject: [PATCH 1/1] scsi: usb: fix bug which some usb isn't used
Date: Tue, 12 Apr 2016 20:35:54 +0800
Message-ID: <1460464554-14116-1-git-send-email-kong.kongxinwei@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:62037 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbcDLMer (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2016 08:34:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxraid@lsi.com, James.Bottomley@HansenPartnership.com, hch@lst.de, snitzer@redhat.com
Cc: martin.petersen@oracle.com, hare@suse.de, JBottomley@Odin.com, linux-scsi@vger.kernel.org, kong.kongxinwei@hisilicon.com

some usb disk such as Manufacturer Lenovo will have some problem in
init process.

when it run "scsi_dh_find_driver" function, because this parameter of
"sdev->inquiry[5]" is 115, it will return "alua" in "scsi_dh_find_driver"
function and will have some error log (alua: Attach failed (-22)). some
usb init will fail and isn't used.

Signed-off-by: Xinwei Kong <kong.kongxinwei@hisilicon.com>
---
 drivers/scsi/scsi_dh.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 54d446c..36b3f354e 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -77,9 +77,6 @@ scsi_dh_find_driver(struct scsi_device *sdev)
 {
 	const struct scsi_dh_blist *b;
 
-	if (scsi_device_tpgs(sdev))
-		return "alua";
-
 	for (b = scsi_dh_blist; b->vendor; b++) {
 		if (!strncmp(sdev->vendor, b->vendor, strlen(b->vendor)) &&
 		    !strncmp(sdev->model, b->model, strlen(b->model))) {
-- 
2.8.0


