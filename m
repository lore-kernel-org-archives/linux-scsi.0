From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH] ibmvscsis: Fix max transfer length
Date: Wed, 11 Jan 2017 13:51:03 -0600
Message-ID: <1484164263-66447-1-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1484163851.2619.21.camel@sandisk.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1484163851.2619.21.camel@sandisk.com>
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
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 8fb5c54..3b4d36b 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -46,6 +46,7 @@
 
 #define	INITIAL_SRP_LIMIT	800
 #define	DEFAULT_MAX_SECTORS	256
+#define MAX_TXU			1024
 
 static uint max_vdma_size = MAX_H_COPY_RDMA;
 
@@ -1443,7 +1444,7 @@ static long ibmvscsis_adapter_info(struct scsi_info *vscsi,
 	info->mad_version = cpu_to_be32(MAD_VERSION_1);
 	info->os_type = cpu_to_be32(LINUX);
 	memset(&info->port_max_txu[0], 0, sizeof(info->port_max_txu));
-	info->port_max_txu[0] = cpu_to_be32(128 * PAGE_SIZE);
+	info->port_max_txu[0] = cpu_to_be32(MAX_TXU);
 
 	dma_wmb();
 	rc = h_copy_rdma(sizeof(*info), vscsi->dds.window[LOCAL].liobn,
-- 
2.5.4 (Apple Git-61)
