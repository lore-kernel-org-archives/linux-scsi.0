From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 18/37] scsi: use get/put_endian helpers
Date: Thu, 29 May 2008 13:18:35 -0700
Message-ID: <1212092315.28403.120.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-arch <linux-arch@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/aacraid/commsup.c      |   12 ++++++------
 drivers/scsi/aacraid/dpcsup.c       |    6 +++---
 drivers/scsi/aic94xx/aic94xx_scb.c  |    4 ++--
 drivers/scsi/aic94xx/aic94xx_task.c |    8 ++++----
 drivers/scsi/stex.c                 |    2 +-
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 289304a..21a9ab0 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -839,13 +839,13 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 			if (container >= dev->maximum_num_containers)
 				break;
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
+			    get_le32((__le32 *)aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		} else for (container = 0;
 		    container < dev->maximum_num_containers; ++container) {
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
+			    get_le32((__le32 *)aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		}
@@ -979,13 +979,13 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 			if (container >= dev->maximum_num_containers)
 				break;
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
+			    get_le32((__le32 *)aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		} else for (container = 0;
 		    container < dev->maximum_num_containers; ++container) {
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
+			    get_le32((__le32 *)aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		}
@@ -1564,7 +1564,7 @@ int aac_command_thread(void *data)
 			if (aifcmd->command == cpu_to_le32(AifCmdDriverNotify)) {
 				/* Handle Driver Notify Events */
 				aac_handle_aif(dev, fib);
-				*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
+				put_le32(ST_OK, (__le32 *)hw_fib->data);
 				aac_fib_adapter_complete(fib, (u16)sizeof(u32));
 			} else {
 				/* The u32 here is important and intended. We are using
@@ -1700,7 +1700,7 @@ int aac_command_thread(void *data)
 				/*
 				 *	Set the status of this FIB
 				 */
-				*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
+				put_le32(ST_OK, (__le32 *)hw_fib->data);
 				aac_fib_adapter_complete(fib, sizeof(u32));
 				spin_unlock_irqrestore(&dev->fib_lock, flagv);
 				/* Free up the remaining resources */
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index 933f208..435f436 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -98,7 +98,7 @@ unsigned int aac_response_normal(struct aac_queue * q)
 			/*
 			 *	Doctor the fib
 			 */
-			*(__le32 *)hwfib->data = cpu_to_le32(ST_OK);
+			put_le32(ST_OK, (__le32 *)hwfib->data);
 			hwfib->header.XferState |= cpu_to_le32(AdapterProcessed);
 		}
 
@@ -210,7 +210,7 @@ unsigned int aac_command_normal(struct aac_queue *q)
 			/*
 			 *	Set the status of this FIB
 			 */
-			*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
+			put_le32(ST_OK, (__le32 *)hw_fib->data);
 			aac_fib_adapter_complete(fib, sizeof(u32));
 			spin_lock_irqsave(q->lock, flags);
 		}		
@@ -292,7 +292,7 @@ unsigned int aac_intr_normal(struct aac_dev * dev, u32 index)
 			/*
 			 *	Doctor the fib
 			 */
-			*(__le32 *)hwfib->data = cpu_to_le32(ST_OK);
+			put_le32(ST_OK, (__le32 *)hwfib->data);
 			hwfib->header.XferState |= cpu_to_le32(AdapterProcessed);
 		}
 
diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 4664331..a03ebb5 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -156,10 +156,10 @@ static void asd_get_attached_sas_addr(struct asd_phy *phy, u8 *sas_addr)
 	    && phy->sas_phy.oob_mode == SATA_OOB_MODE) {
 		struct asd_ha_struct *asd_ha = phy->sas_phy.ha->lldd_ha;
 		/* FIS device-to-host */
-		u64 addr = be64_to_cpu(*(__be64 *)phy->phy_desc->sas_addr);
+		u64 addr = get_be64((__be64 *)phy->phy_desc->sas_addr);
 
 		addr += asd_ha->hw_prof.sata_name_base + ord_phy(asd_ha, phy);
-		*(__be64 *)sas_addr = cpu_to_be64(addr);
+		put_be64(addr, (__be64 *)sas_addr);
 	} else {
 		struct sas_identify_frame *idframe =
 			(void *) phy->sas_phy.frame_rcvd;
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 326765c..f09c1bc 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -191,16 +191,16 @@ static void asd_get_response_tasklet(struct asd_ascb *ascb,
 		struct ssp_response_iu *iu =
 			r + 16 + sizeof(struct ssp_frame_hdr);
 
-		ts->residual = le32_to_cpu(*(__le32 *)r);
+		ts->residual = get_le32((__le32 *)r);
 
 		sas_ssp_task_response(&asd_ha->pcidev->dev, task, iu);
 	}  else {
 		struct ata_task_resp *resp = (void *) &ts->buf[0];
 
-		ts->residual = le32_to_cpu(*(__le32 *)r);
+		ts->residual = get_le32((__le32 *)r);
 
 		if (SAS_STATUS_BUF_SIZE >= sizeof(*resp)) {
-			resp->frame_len = le16_to_cpu(*(__le16 *)(r+6));
+			resp->frame_len = get_le16((__le16 *)(r + 6));
 			memcpy(&resp->ending_fis[0], r+16, 24);
 			ts->buf_valid_size = sizeof(*resp);
 		}
@@ -228,7 +228,7 @@ Again:
 	case TC_UNDERRUN:
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
-		ts->residual = le32_to_cpu(*(__le32 *)dl->status_block);
+		ts->residual = get_le32((__le32 *)dl->status_block);
 		break;
 	case TC_OVERRUN:
 		ts->resp = SAS_TASK_COMPLETE;
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index f308a03..8194028 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -660,7 +660,7 @@ static void stex_ys_commands(struct st_hba *hba,
 	if (ccb->cmd->cmnd[0] == MGT_CMD &&
 		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
 		scsi_set_resid(ccb->cmd, scsi_bufflen(ccb->cmd) -
-			le32_to_cpu(*(__le32 *)&resp->variable[0]));
+			get_le32((__le32 *)&resp->variable[0]));
 		return;
 	}
 
-- 
1.5.6.rc0.277.g804cf
