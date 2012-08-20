From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 4/7] be2iscsi: Format the MAC_ADDR with sysfs_format_mac.
Date: Mon, 20 Aug 2012 23:00:31 +0530
Message-ID: <3968ed7b-1958-4849-b34d-4befdec570b0@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:21660 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2HTRbc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2012 13:31:32 -0400
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
index 41b1fb7..8efdd8e 100644
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

