From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH] ibmvscsis: Fix max transfer length
Date: Wed, 11 Jan 2017 12:02:39 -0600
Message-ID: <1484157759-61200-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Bart.VanAssche@sandisk.com
Cc: nab@linux-iscsi.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Current code incorrectly calculates the max transfer length, since
it is assuming a 4k page table, but ppc64 all run on 64k page tables.

Cc: stable@vger.kernel.org
Reported-by: Steven Royer <seroyer@linux.vnet.ibm.com>
Tested-by: Steven Royer <seroyer@linux.vnet.ibm.com>
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 8fb5c54..792a8bd 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1443,7 +1443,7 @@ static long ibmvscsis_adapter_info(struct scsi_info *vscsi,
 	info->mad_version = cpu_to_be32(MAD_VERSION_1);
 	info->os_type = cpu_to_be32(LINUX);
 	memset(&info->port_max_txu[0], 0, sizeof(info->port_max_txu));
-	info->port_max_txu[0] = cpu_to_be32(128 * PAGE_SIZE);
+	info->port_max_txu[0] = cpu_to_be32(16 * PAGE_SIZE);
 
 	dma_wmb();
 	rc = h_copy_rdma(sizeof(*info), vscsi->dds.window[LOCAL].liobn,
-- 
2.5.4 (Apple Git-61)
