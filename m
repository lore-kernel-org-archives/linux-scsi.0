From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 1/1] be2iscsi: Fix for Login failure
Date: Thu, 12 Aug 2010 23:36:06 +0530
Message-ID: <20100812180547.GA8202@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:27719 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753470Ab0HLSGA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2010 14:06:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

   The current code in tree has problems with Login.
This patch fixes the Login Failure .

 This patch has been made on the latest scsi-misc tree pulled today

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    5 ++---
 drivers/scsi/be2iscsi/be_mgmt.c  |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 7d4d227..7f11f3e 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -300,8 +300,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 			   enum iscsi_host_param param, char *buf)
 {
 	struct beiscsi_hba *phba = (struct beiscsi_hba *)iscsi_host_priv(shost);
-	int len = 0;
-	int status;
+	int status = 0;
 
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_get_host_param, param= %d\n", param);
 	switch (param) {
@@ -315,7 +314,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 	default:
 		return iscsi_host_get_param(shost, param, buf);
 	}
-	return len;
+	return status;
 }
 
 int beiscsi_get_macaddr(char *buf, struct beiscsi_hba *phba)
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 26350e4..877324f 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -368,7 +368,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	memset(req, 0, sizeof(*req));
 	wrb->tag0 |= tag;
 
-	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 1);
+	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
 			   OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD,
 			   sizeof(*req));
-- 
1.6.4

