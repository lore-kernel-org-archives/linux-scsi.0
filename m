From: Hiral Shah <hishah@cisco.com>
Subject: [PATCH 2/5] [SCSI] Fnic: Memcopy only mimumum of data or trace buffer [SCSI] Fnic: Memcopy only mimumum of data or trace buffer
Date: Mon, 10 Nov 2014 12:54:33 -0800
Message-ID: <1415652876-24570-2-git-send-email-hishah@cisco.com>
References: <1415652876-24570-1-git-send-email-hishah@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-6.cisco.com ([173.37.142.93]:3852 "EHLO
	alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaKJVCp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 16:02:45 -0500
In-Reply-To: <1415652876-24570-1-git-send-email-hishah@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hiral Shah <hishah@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Anil Chintalapati <achintal@cisco.com>

In case of receive path, we do not have eth header or fcoe header available when
we take a trace so we fill the fc trace buffer with 0xff for both values. We copy only
mimimum of received data or trace buffer size - fc header - eth and fcoe header

- Increment fnic version from 1.6.0.12 to 1.6.0.13

Signed-off-by: Hiral Shah <hishah@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Anil Chintalapati <achintal@cisco.com>
---
 drivers/scsi/fnic/fnic.h       | 2 +-
 drivers/scsi/fnic/fnic_trace.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 69dee68..dbc69ad 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.12"
+#define DRV_VERSION		"1.6.0.13"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index acf1f95..65a9bde 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -624,12 +624,12 @@ int fnic_fc_trace_set_data(u32 host_no, u8 frame_type,
 	if (frame_type == FNIC_FC_RECV) {
 		eth_fcoe_hdr_len = sizeof(struct ethhdr) +
 					sizeof(struct fcoe_hdr);
-		fc_trc_frame_len = fc_trc_frame_len + eth_fcoe_hdr_len;
 		memset((char *)fc_trace, 0xff, eth_fcoe_hdr_len);
 		/* Copy the rest of data frame */
 		memcpy((char *)(fc_trace + eth_fcoe_hdr_len), (void *)frame,
 		min_t(u8, fc_trc_frame_len,
-			(u8)(FC_TRC_SIZE_BYTES - FC_TRC_HEADER_SIZE)));
+			(u8)(FC_TRC_SIZE_BYTES - FC_TRC_HEADER_SIZE
+						- eth_fcoe_hdr_len)));
 	} else {
 		memcpy((char *)fc_trace, (void *)frame,
 		min_t(u8, fc_trc_frame_len,
-- 
1.8.5.4

