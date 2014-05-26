From: Benoit Taine <benoit.taine@lip6.fr>
Subject: [PATCH 7/18] qla2xxx: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:16 +0200
Message-ID: <1401117687-28911-8-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: benoit.taine@lip6.fr, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/scsi/qla2xxx/qla_mbx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7f39e36..1c33a77 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1319,7 +1319,7 @@ qla2x00_get_node_name_list(scsi_qla_host_t *vha, void **out_data, int *out_len)
 
 		left = 0;
 
-		list = kzalloc(dma_size, GFP_KERNEL);
+		list = kmemdup(pmap, dma_size, GFP_KERNEL);
 		if (!list) {
 			ql_log(ql_log_warn, vha, 0x1140,
 			    "%s(%ld): failed to allocate node names list "
@@ -1328,7 +1328,6 @@ qla2x00_get_node_name_list(scsi_qla_host_t *vha, void **out_data, int *out_len)
 			goto out_free;
 		}
 
-		memcpy(list, pmap, dma_size);
 restart:
 		dma_free_coherent(&ha->pdev->dev, dma_size, pmap, pmap_dma);
 	}
