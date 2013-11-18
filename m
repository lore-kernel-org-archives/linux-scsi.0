From: "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH v2] scsi: be_iscsi: fix possible memory leak
Date: Mon, 18 Nov 2013 16:42:57 -0300
Message-ID: <1384803778-24987-1-git-send-email-geyslan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:46021 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3KRTsV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2013 14:48:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: geyslan@gmail.com
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:SERVER ENGINES 10..." <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

This patch fix memory leakage in cases 'ISCSI_NET_PARAM_VLAN_ID' and
'ISCSI_NET_PARAM_VLAN_PRIORITY'.

Note:
'if_info' will be allocated only when 'mgmt_get_if_info()' returns NULL.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index ffadbee..889066d 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -541,10 +541,8 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 		ip_type = BE2_IPV6;
 
 	len = mgmt_get_if_info(phba, ip_type, &if_info);
-	if (len) {
-		kfree(if_info);
+	if (len)
 		return len;
-	}
 
 	switch (param) {
 	case ISCSI_NET_PARAM_IPV4_ADDR:
@@ -569,7 +567,7 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 		break;
 	case ISCSI_NET_PARAM_VLAN_ID:
 		if (if_info->vlan_priority == BEISCSI_VLAN_DISABLE)
-			return -EINVAL;
+			len = -EINVAL;
 		else
 			len = sprintf(buf, "%d\n",
 				     (if_info->vlan_priority &
@@ -577,7 +575,7 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 		break;
 	case ISCSI_NET_PARAM_VLAN_PRIORITY:
 		if (if_info->vlan_priority == BEISCSI_VLAN_DISABLE)
-			return -EINVAL;
+			len = -EINVAL;
 		else
 			len = sprintf(buf, "%d\n",
 				     ((if_info->vlan_priority >> 13) &
-- 
1.8.4.2

