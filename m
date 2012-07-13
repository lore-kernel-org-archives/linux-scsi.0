From: <kgudipat@brocade.com>
Subject: [PATCH] bfa: Fix to set correct return error codes and misc cleanup.
Date: Fri, 13 Jul 2012 16:08:22 -0700
Message-ID: <1342220902-4718-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:59365 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911Ab2GMXIf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jul 2012 19:08:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Remove unnecessary if NULL check in function bfa_fcs_vport_free().
	- Set correct return error codes in case of memory allocation failure
	  in the BSG ELS/CT passthru command handler.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    4 +---
 drivers/scsi/bfa/bfad_bsg.c      |    5 ++++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 937000d..bcc4966 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5722,9 +5722,7 @@ bfa_fcs_vport_free(struct bfa_fcs_vport_s *vport)
 	 * The memory for the bfad_vport_s is freed from the FC function
 	 * template vport_delete entry point.
 	 */
-	if (vport_drv)
-		bfad_im_port_delete(vport_drv->drv_port.bfad,
-				&vport_drv->drv_port);
+	bfad_im_port_delete(vport_drv->drv_port.bfad, &vport_drv->drv_port);
 }
 
 /*
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index e1f4b10..9c1495b 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3008,12 +3008,15 @@ bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 	 * buffer of size bsg_data->payload_len
 	 */
 	bsg_fcpt = kzalloc(bsg_data->payload_len, GFP_KERNEL);
-	if (!bsg_fcpt)
+	if (!bsg_fcpt) {
+		rc = -ENOMEM;
 		goto out;
+	}
 
 	if (copy_from_user((uint8_t *)bsg_fcpt, bsg_data->payload,
 				bsg_data->payload_len)) {
 		kfree(bsg_fcpt);
+		rc = -EIO;
 		goto out;
 	}
 
-- 
1.7.3.rc1

