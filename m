From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] be2iscsi: check ip buffer before copying
Date: Mon, 29 Sep 2014 13:55:41 -0500
Message-ID: <1412016942-4759-2-git-send-email-michaelc@cs.wisc.edu>
References: <1412016942-4759-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42695 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaI2S4r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 14:56:47 -0400
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s8TItn1d028576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2014 13:56:46 -0500
In-Reply-To: <1412016942-4759-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

Dan Carpenter found a issue where be2iscsi would copy the ip
from userspace to the driver buffer before checking the len
of the data being copied:
http://marc.info/?l=linux-scsi&m=140982651504251&w=2

This patch just has us only copy what we the driver buffer
can support.

Tested-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

---
 drivers/scsi/be2iscsi/be_mgmt.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 8478506..681d4e8 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -943,17 +943,20 @@ mgmt_static_ip_modify(struct beiscsi_hba *phba,
 
 	if (ip_action == IP_ACTION_ADD) {
 		memcpy(req->ip_params.ip_record.ip_addr.addr, ip_param->value,
-		       ip_param->len);
+		       sizeof(req->ip_params.ip_record.ip_addr.addr));
 
 		if (subnet_param)
 			memcpy(req->ip_params.ip_record.ip_addr.subnet_mask,
-			       subnet_param->value, subnet_param->len);
+			       subnet_param->value,
+			       sizeof(req->ip_params.ip_record.ip_addr.subnet_mask));
 	} else {
 		memcpy(req->ip_params.ip_record.ip_addr.addr,
-		       if_info->ip_addr.addr, ip_param->len);
+		       if_info->ip_addr.addr,
+		       sizeof(req->ip_params.ip_record.ip_addr.addr));
 
 		memcpy(req->ip_params.ip_record.ip_addr.subnet_mask,
-		       if_info->ip_addr.subnet_mask, ip_param->len);
+		       if_info->ip_addr.subnet_mask,
+		       sizeof(req->ip_params.ip_record.ip_addr.subnet_mask));
 	}
 
 	rc = mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
@@ -981,7 +984,7 @@ static int mgmt_modify_gateway(struct beiscsi_hba *phba, uint8_t *gt_addr,
 	req->action = gtway_action;
 	req->ip_addr.ip_type = BE2_IPV4;
 
-	memcpy(req->ip_addr.addr, gt_addr, param_len);
+	memcpy(req->ip_addr.addr, gt_addr, sizeof(req->ip_addr.addr));
 
 	return mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
 }
-- 
1.7.1

