From: Dan Carpenter <error27@gmail.com>
Subject: [patch] scsi/qla2xxx: checking for null cleanups
Date: Sat, 22 May 2010 22:30:36 +0200
Message-ID: <20100522203036.GP22515@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49693 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab0EVUbA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2010 16:31:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

These are two cleanups to make the static checkers happy.  The "vha" is 
used as the list cursor and can never be null so I removed the check.  I 
also modified qla2x00_request_firmware() to avoid a theoretical null
dereference.  This is unlikely to happen I think, but it makes auditing
easier.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index be1a8fc..d306853 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2354,7 +2354,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	ha = base_vha->hw;
 
 	list_for_each_entry_safe(vha, temp, &ha->vp_list, list) {
-		if (vha && vha->fc_vport)
+		if (vha->fc_vport)
 			fc_vport_terminate(vha->fc_vport);
 	}
 
@@ -3689,6 +3689,8 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
 		blob = &qla_fw_blobs[FW_ISP81XX];
 	} else if (IS_QLA82XX(ha)) {
 		blob = &qla_fw_blobs[FW_ISP82XX];
+	} else {
+		return NULL;
 	}
 
 	mutex_lock(&qla_fw_lock);
