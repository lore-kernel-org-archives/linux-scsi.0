From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] scsi: storvsc: make INQUIRY response SPC-compliant
Date: Wed,  1 Jul 2015 11:04:08 +0200
Message-ID: <1435741448-29070-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbbGAJEM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jul 2015 05:04:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Long Li <longli@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org

SPC-2/3/4 specs state that "The standard INQUIRY data (see table ...)
shall contain at least 36 bytes". Hyper-V host doesn't always honor this
requirement, e.g. when there is no physical device present at a particular
LUN host sets Peripheral qualifier to 011b and Additional length to 0
(thus making the reply 5-bytes long). Upper level SCSI stack complains
with 'INQUIRY result too short (5), using 36'. Fix the issue by mangling
Additional length field in host's reply at the driver level.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
This is a hack, the proper fix should probably be done in Hyper-V.
---
 drivers/scsi/storvsc_drv.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3c6584f..bca31af 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1153,6 +1153,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
 {
 	struct storvsc_device *stor_device;
 	struct vstor_packet *stor_pkt;
+	struct vmbus_packet_mpb_array *payload = request->payload;
 
 	stor_device = hv_get_drvdata(device);
 	stor_pkt = &request->vstor_packet;
@@ -1174,6 +1175,24 @@ static void storvsc_on_io_completion(struct hv_device *device,
 		vstor_packet->vm_srb.srb_status = SRB_STATUS_SUCCESS;
 	}
 
+	/*
+	 * When there is no physical device attached to a LUN Hyper-V host
+	 * sets Peripheral qualifier to 011b and Additional length to 0. SPC
+	 * spec, however, says that "The standard INQUIRY data ... shall
+	 * contain at least 36 bytes". Upper level SCSI stack complains with
+	 * 'INQUIRY result too short (5), using 36'. Mangle host's reply here.
+	 */
+	if (stor_pkt->vm_srb.cdb[0] == INQUIRY && payload) {
+		u8 *buf, per_qual, data_len;
+		int range_len = payload->range.len;
+
+		buf = phys_to_virt(payload->range.pfn_array[0] << PAGE_SHIFT) +
+			payload->range.offset;
+		per_qual = (buf[0] >> 5) & 7;
+		data_len = buf[4] + 5;
+		if (per_qual == 3 && data_len < min(range_len, 36))
+			buf[4] = min(range_len, 36) - 5;
+	}
 
 	/* Copy over the status...etc */
 	stor_pkt->vm_srb.scsi_status = vstor_packet->vm_srb.scsi_status;
-- 
2.4.3

