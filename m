From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: [PATCH 1/2] ALUA check sense should retry device internal reset
 unit attention
Date: Mon, 14 Oct 2013 22:24:44 +0000
Message-ID: <8255ED565A0EAA4A960625E27D49DBF24AC14D59@SACEXCMBX04-PRD.hq.netapp.com>
References: <8255ED565A0EAA4A960625E27D49DBF24AC14D1C@SACEXCMBX04-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx11.netapp.com ([216.240.18.76]:7302 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab3JNWYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Oct 2013 18:24:46 -0400
In-Reply-To: <8255ED565A0EAA4A960625E27D49DBF24AC14D1C@SACEXCMBX04-PRD.hq.netapp.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.de" <hare@suse.de>

When the scsi_dh_alua handler issues an RTPG during initialization, if it gets 0x06/0x29/0x04 as the sense,
it will fail to attach the handler.  NetApp E-Series returns 0x29/0x00 for power on, and 0x29/0x04 for
conditions that cause the controller to reboot again.  These conditions should be treated identically within
the handler.

Signed-off-by: Sean Stewart <Sean.Stewart@netapp.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 68adb89..78205cc 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -481,6 +481,11 @@ static int alua_check_sense(struct scsi_device *sdev,
 			 * Power On, Reset, or Bus Device Reset, just retry.
 			 */
 			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x04)
+			/*
+			 * Device internal reset
+			 */
+			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
 			/*
 			 * Mode Parameters Changed
-- 
1.8.3.1

