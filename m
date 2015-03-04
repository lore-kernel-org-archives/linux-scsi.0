From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH 7/7] aacraid: AIF raw device remove support
Date: Wed, 4 Mar 2015 03:38:33 -0500
Message-ID: <1425458313-1956-8-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:42638 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932820AbbCDJP6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2015 04:15:58 -0500
In-Reply-To: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Achim.Leubner@pmcs.com, Rajinikanth.Pandurangan@pmcs.com, Rich.Bono@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Add AIF raw device remove support

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h |    3 +++
 drivers/scsi/aacraid/commsup.c |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 74a0440..5aaa9a6 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2061,6 +2061,9 @@ extern struct aac_common aac_config;
 /* PMC NEW COMM: Request the event data */
 #define		AifReqEvent		200
 
+/* RAW device deleted */
+#define		AifRawDeviceRemove	203
+
 /*
  *	Adapter Initiated FIB command structures. Start with the adapter
  *	initiated FIBs that really come from the adapter, and get responded
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 0555023..8bb9ee4 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -884,6 +884,38 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 	switch (le32_to_cpu(aifcmd->command)) {
 	case AifCmdDriverNotify:
 		switch (le32_to_cpu(((__le32 *)aifcmd->data)[0])) {
+		case AifRawDeviceRemove:
+			container = le32_to_cpu(((__le32 *)aifcmd->data)[1]);
+			if ((container >> 28)) {
+				container = (u32)-1;
+				break;
+			}
+			channel = (container >> 24) & 0xF;
+			if (channel >= dev->maximum_num_channels) {
+				container = (u32)-1;
+				break;
+			}
+			id = container & 0xFFFF;
+			if (id >= dev->maximum_num_physicals) {
+				container = (u32)-1;
+				break;
+			}
+			lun = (container >> 16) & 0xFF;
+			container = (u32)-1;
+			channel = aac_phys_to_logical(channel);
+			device_config_needed =
+			  (((__le32 *)aifcmd->data)[0] ==
+			    cpu_to_le32(AifRawDeviceRemove)) ? DELETE : ADD;
+
+			if (device_config_needed == ADD) {
+				device = scsi_device_lookup(dev->scsi_host_ptr, channel, id, lun);
+				if (device) {
+					scsi_remove_device(device);
+					scsi_device_put(device);
+				}
+			}
+			break;
+
 		/*
 		 *	Morph or Expand complete
 		 */
-- 
1.7.7.3

