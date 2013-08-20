From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 9/9] tcm_qla2xxx: Add special case for COMPARE_AND_WRITE data_direction
Date: Tue, 20 Aug 2013 20:08:00 +0000
Message-ID: <1377029280-19144-10-git-send-email-nab@daterainc.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

Add a special case for COMPARE_AND_WRITE for the reverse data direction
mapping used for pci_map_sg() + friends.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6a93a91..4e20d51 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -508,8 +508,13 @@ static u32 tcm_qla2xxx_sess_get_index(struct se_session *se_sess)
  */
 static enum dma_data_direction tcm_qla2xxx_mapping_dir(struct se_cmd *se_cmd)
 {
-	if (se_cmd->se_cmd_flags & SCF_BIDI)
-		return DMA_BIDIRECTIONAL;
+	if (se_cmd->se_cmd_flags & SCF_BIDI) {
+		/*
+		 * Special fall-through case for COMPARE_AND_WRITE
+		 */
+		if (se_cmd->t_task_cdb[0] != COMPARE_AND_WRITE)
+			return DMA_BIDIRECTIONAL;
+	}
 
 	switch (se_cmd->data_direction) {
 	case DMA_TO_DEVICE:
-- 
1.7.10.4
