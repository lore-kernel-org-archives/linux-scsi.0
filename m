From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [V2 PATCH 10/11] aacraid: AIF raw device remove support
Date: Thu, 26 Mar 2015 10:41:31 -0400
Message-ID: <1427380892-1978-11-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:38057 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbbCZOsw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2015 10:48:52 -0400
In-Reply-To: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Achim.Leubner@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Add AIF raw device remove support

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h |    3 +++
 drivers/scsi/aacraid/commsup.c |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 2ba158b..fe014a6 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2065,6 +2065,9 @@ extern struct aac_common aac_config;
 /* PMC NEW COMM: Request the event data */
 #define		AifReqEvent		200
 
+/* RAW device deleted */
+#define		AifRawDeviceRemove	203
+
 /*
  *	Adapter Initiated FIB command structures. Start with the adapter
  *	initiated FIBs that really come from the adapter, and get responded
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 1a3c0e0..4da5749 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -883,6 +883,39 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
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
+				device = scsi_device_lookup(
+					dev->scsi_host_ptr,
+					channel, id, lun);
+				if (device) {
+					scsi_remove_device(device);
+					scsi_device_put(device);
+				}
+			}
+			break;
 		/*
 		 *	Morph or Expand complete
 		 */
-- 
1.7.7.3

