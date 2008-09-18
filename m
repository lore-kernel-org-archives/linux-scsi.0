From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] qla2xxx: fix printk format warnings
Date: Thu, 18 Sep 2008 04:09:57 +0400
Message-ID: <20080918000957.GE29966@orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:12257 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYIRAKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Sep 2008 20:10:07 -0400
Received: by ug-out-1314.google.com with SMTP id k3so585329ugf.37
        for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2008 17:10:05 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com, linux-scsi@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/scsi/qla2xxx/qla_sup.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index e2432ef..90a1321 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -894,15 +894,17 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *ha)
 		vid.node_name = wwn_to_u64(entry->node_name);
 
 		DEBUG2(qla_printk(KERN_DEBUG, ha, "NPIV[%02x]: wwpn=%llx "
-		    "wwnn=%llx vf_id=0x%x qos=0x%x.\n", cnt, vid.port_name,
-		    vid.node_name, le16_to_cpu(entry->vf_id),
-		    le16_to_cpu(entry->qos)));
+		    "wwnn=%llx vf_id=0x%x qos=0x%x.\n", cnt,
+		    (unsigned long long)vid.port_name,
+		    (unsigned long long)vid.node_name,
+		    le16_to_cpu(entry->vf_id), le16_to_cpu(entry->qos)));
 
 		vport = fc_vport_create(ha->host, 0, &vid);
 		if (!vport)
 			qla_printk(KERN_INFO, ha, "NPIV-Config: Failed to "
 			    "create vport [%02x]: wwpn=%llx wwnn=%llx.\n", cnt,
-			    vid.port_name, vid.node_name);
+			    (unsigned long long)vid.port_name,
+			    (unsigned long long)vid.node_name);
 	}
 done:
 	kfree(data);
