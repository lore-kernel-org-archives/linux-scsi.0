From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 4/7] Format the MAC_ADDR with sysfs_format_mac.
Date: Mon, 13 Aug 2012 16:00:23 +0530
Message-ID: <4fb5cd95-6fa7-4ec6-9321-302a327e2408@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:48063 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2HMKbU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2012 06:31:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 The MAC_ADDR stored in driver private structure is of
 unsigned char data type but strlcpy parameters is of
 signed char data type. This conversion of data types
 lead to change in the value.This changed value is passed
 to the upper layer and junk characters were displayed
 when "iscsiadm -m iface" command was run.

 In case of iSCSI boot, since the the MAC_ADDR was coming
 junk the boot was also not working

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 2bd4aeb..73300f1 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -792,7 +792,7 @@ int beiscsi_get_macaddr(char *buf, struct beiscsi_hba *phba)
 	int rc;
 
 	if (strlen(phba->mac_address))
-		return strlcpy(buf, phba->mac_address, PAGE_SIZE);
+		return sysfs_format_mac(buf, phba->mac_address, ETH_ALEN);
 
 	memset(&resp, 0, sizeof(resp));
 	rc = mgmt_get_nic_conf(phba, &resp);
-- 
1.7.1

