From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH ver3 4/4] qla4xxx: improve symmetry in buffer codepaths
Date: Sat, 05 Aug 2006 17:52:38 -0500
Message-ID: <20060805225237.9557.33531.stgit@bebe.enoyolf.org>
References: <20060805225156.9557.99072.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:4253 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1751421AbWHEWy5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Aug 2006 18:54:57 -0400
In-Reply-To: <20060805225156.9557.99072.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

In qla4xxx_send_command_to_isp(), pci_map_*() is used.  At the other
end, in qla4xxx_srb_free_dma(), dma_unmap_*() is used.  Replace the call
with the symmetrical call to pci_unmap_*().

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d88c84f..5e10f30 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -382,10 +382,10 @@ static void qla4xxx_srb_free_dma(struct 
 
 	if (srb->flags & SRB_DMA_VALID) {
 		if (cmd->use_sg) {
-			dma_unmap_sg(&ha->pdev->dev, cmd->request_buffer,
+			pci_unmap_sg(ha->pdev, cmd->request_buffer,
 				     cmd->use_sg, cmd->sc_data_direction);
 		} else if (cmd->request_bufflen) {
-			dma_unmap_single(&ha->pdev->dev, srb->dma_handle,
+			pci_unmap_single(ha->pdev, srb->dma_handle,
 					 cmd->request_bufflen,
 					 cmd->sc_data_direction);
 		}
