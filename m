From: Michael Cyr <mikecyr@us.ibm.com>
Subject: [PATCH v2 5/6] ibmvscsis: Return correct partition name/# to client
Date: Thu, 13 Oct 2016 11:02:42 -0500
Message-ID: <1476374563-13967-6-git-send-email-mikecyr@us.ibm.com>
References: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
 <1476374563-13967-1-git-send-email-mikecyr@us.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1476374563-13967-1-git-send-email-mikecyr@us.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, joe@perches.com
Cc: hch@infradead.org, bryantly@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, Michael Cyr <mikecyr@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Michael Cyr <mikecyr@us.ibm.com>
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index cd9f5c7..fe220a1 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3297,6 +3297,9 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	strncat(vscsi->eye, vdev->name, MAX_EYE);
 
 	vscsi->dds.unit_id = vdev->unit_address;
+	strncpy(vscsi->dds.partition_name, partition_name,
+		sizeof(vscsi->dds.partition_name));
+	vscsi->dds.partition_num = partition_number;
 
 	spin_lock_bh(&ibmvscsis_dev_lock);
 	list_add_tail(&vscsi->list, &ibmvscsis_dev_list);
@@ -3495,7 +3498,7 @@ static int ibmvscsis_get_system_info(void)
 
 	num = of_get_property(rootdn, "ibm,partition-no", NULL);
 	if (num)
-		partition_number = *num;
+		partition_number = of_read_number(num, 1);
 
 	of_node_put(rootdn);
 
-- 
2.5.0
