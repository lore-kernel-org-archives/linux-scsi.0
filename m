Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FE9C8300E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74152076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgD3NUY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:60760 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgD3NUS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 15BC2AF99;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 41/41] pm8001: use block-layer tags for ccb allocation
Date:   Thu, 30 Apr 2020 15:19:04 +0200
Message-Id: <20200430131904.5847-42-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Always allocate a command from the block layer whenever we need a
tag. With that we can drop the internal ccb bitmap and allow the
block layer control tag allocation.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/pm8001/pm8001_hwi.c  | 110 ++++++++++++++++++--------------------
 drivers/scsi/pm8001/pm8001_init.c |  30 ++++++-----
 drivers/scsi/pm8001/pm8001_sas.c  | 106 ++++++++++++++----------------------
 drivers/scsi/pm8001/pm8001_sas.h  |  13 +++--
 drivers/scsi/pm8001/pm80xx_hwi.c  | 107 +++++++++++++++++-------------------
 5 files changed, 165 insertions(+), 201 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 62208e98508c..3b0dfeee8563 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1579,11 +1579,11 @@ void pm8001_work_fn(struct work_struct *work)
 				" done with event 0x%x resp 0x%x stat 0x%x but"
 				" aborted by upper layer!\n",
 				t, pw->handler, ts->resp, ts->stat));
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free(pm8001_ha, t, ccb);
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 		} else {
 			spin_unlock_irqrestore(&t->task_state_lock, flags1);
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free(pm8001_ha, t, ccb);
 			mb();/* in order to force CPU ordering */
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			t->task_done(t);
@@ -1729,8 +1729,6 @@ int pm8001_handle_event(struct pm8001_hba_info *pm8001_ha, void *data,
 static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 		struct pm8001_device *pm8001_ha_dev)
 {
-	int res;
-	u32 ccb_tag;
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task = NULL;
 	struct task_abort_req task_abort;
@@ -1756,13 +1754,16 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 
 	task->task_done = pm8001_task_done;
 
-	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res)
+	if (task->tag == -1) {
+		sas_free_task(task);
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("cannot allocate tag\n"));
 		return;
+	}
 
-	ccb = &pm8001_ha->ccb_info[ccb_tag];
+	ccb = &pm8001_ha->ccb_info[task->tag];
 	ccb->device = pm8001_ha_dev;
-	ccb->ccb_tag = ccb_tag;
+	ccb->ccb_tag = task->tag;
 	ccb->task = task;
 
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
@@ -1770,13 +1771,12 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	memset(&task_abort, 0, sizeof(task_abort));
 	task_abort.abort_all = cpu_to_le32(1);
 	task_abort.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
-	task_abort.tag = cpu_to_le32(ccb_tag);
+	task_abort.tag = cpu_to_le32(task->tag);
 
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
 			sizeof(task_abort), 0);
 	if (ret)
-		pm8001_tag_free(pm8001_ha, ccb_tag);
-
+		sas_free_task(task);
 }
 
 static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
@@ -1784,7 +1784,6 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 {
 	struct sata_start_req sata_cmd;
 	int res;
-	u32 ccb_tag;
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task = NULL;
 	struct host_to_dev_fis fis;
@@ -1803,8 +1802,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	}
 	task->task_done = pm8001_task_done;
 
-	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res) {
+	if (task->tag == -1) {
 		sas_free_task(task);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("cannot allocate tag !!!\n"));
@@ -1814,9 +1812,9 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	task->dev = dev;
 	task->dev->lldd_dev = pm8001_ha_dev;
 
-	ccb = &pm8001_ha->ccb_info[ccb_tag];
+	ccb = &pm8001_ha->ccb_info[task->tag];
 	ccb->device = pm8001_ha_dev;
-	ccb->ccb_tag = ccb_tag;
+	ccb->ccb_tag = task->tag;
 	ccb->task = task;
 	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
 	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
@@ -1832,17 +1830,15 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	fis.lbal = 0x10;
 	fis.sector_count = 0x1;
 
-	sata_cmd.tag = cpu_to_le32(ccb_tag);
+	sata_cmd.tag = cpu_to_le32(task->tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
 	sata_cmd.ncqtag_atap_dir_m |= ((0x1 << 7) | (0x5 << 9));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
 			sizeof(sata_cmd), 0);
-	if (res) {
+	if (res)
 		sas_free_task(task);
-		pm8001_tag_free(pm8001_ha, ccb_tag);
-	}
 }
 
 /**
@@ -2103,10 +2099,10 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			" io_status 0x%x resp 0x%x "
 			"stat 0x%x but aborted by upper layer!\n",
 			t, status, ts->resp, ts->stat));
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 		mb();/* in order to force CPU ordering */
 		t->task_done(t);
 	}
@@ -2291,10 +2287,10 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			" event 0x%x resp 0x%x "
 			"stat 0x%x but aborted by upper layer!\n",
 			t, event, ts->resp, ts->stat));
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 		mb();/* in order to force CPU ordering */
 		t->task_done(t);
 	}
@@ -2423,8 +2419,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				/* clear bit for read log */
 				pm8001_dev->id = pm8001_dev->id & 0x7FFFFFFF;
 				pm8001_send_abort_all(pm8001_ha, pm8001_dev);
-				/* Free the tag */
-				pm8001_tag_free(pm8001_ha, tag);
 				sas_free_task(t);
 				return;
 			}
@@ -2534,7 +2528,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 			return;
 		}
 		break;
@@ -2550,7 +2544,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 			return;
 		}
 		break;
@@ -2574,7 +2568,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 			return;
 		}
 		break;
@@ -2637,7 +2631,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				    IO_DS_NON_OPERATIONAL);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 			return;
 		}
 		break;
@@ -2657,7 +2651,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				    IO_DS_IN_ERROR);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 			return;
 		}
 		break;
@@ -2686,10 +2680,10 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("task 0x%p done with io_status 0x%x"
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, status, ts->resp, ts->stat));
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 	}
 }
 
@@ -2798,7 +2792,7 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 			return;
 		}
 		break;
@@ -2906,10 +2900,10 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			pm8001_printk("task 0x%p done with io_status 0x%x"
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, event, ts->resp, ts->stat));
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 	}
 }
 
@@ -3108,10 +3102,10 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			" io_status 0x%x resp 0x%x "
 			"stat 0x%x but aborted by upper layer!\n",
 			t, status, ts->resp, ts->stat));
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 		mb();/* in order to force CPU ordering */
 		t->task_done(t);
 	}
@@ -3791,11 +3785,10 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
 	t->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&t->task_state_lock, flags);
-	pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+	pm8001_ccb_task_free(pm8001_ha, t, ccb);
 	mb();
 
 	if (pm8001_dev->id & NCQ_ABORT_ALL_FLAG) {
-		pm8001_tag_free(pm8001_ha, tag);
 		sas_free_task(t);
 		/* clear the flag */
 		pm8001_dev->id &= 0xBFFFFFFF;
@@ -4474,12 +4467,11 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 					pm8001_printk("task 0x%p resp 0x%x "
 					" stat 0x%x but aborted by upper layer "
 					"\n", task, ts->resp, ts->stat));
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+				pm8001_ccb_task_free(pm8001_ha, task, ccb);
 			} else {
 				spin_unlock_irqrestore(&task->task_state_lock,
 							flags);
-				pm8001_ccb_task_free_done(pm8001_ha, task,
-								ccb, tag);
+				pm8001_ccb_task_free_done(pm8001_ha, task, ccb);
 				return 0;
 			}
 		}
@@ -4570,9 +4562,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 
 	memset(&payload, 0, sizeof(payload));
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
-		return rc;
+	tag = pm8001_tag_alloc(pm8001_ha, dev);
+	if (tag == -1)
+		return -SAS_QUEUE_FULL;
 	ccb = &pm8001_ha->ccb_info[tag];
 	ccb->device = pm8001_dev;
 	ccb->ccb_tag = tag;
@@ -4606,6 +4598,8 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 		SAS_ADDR_SIZE);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
 	return rc;
 }
 
@@ -4789,10 +4783,10 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	fw_control_context->len = ioctl_payload->rd_length;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	memset(&nvmd_req, 0, sizeof(nvmd_req));
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc) {
+	tag = pm8001_tag_alloc(pm8001_ha, NULL);
+	if (tag == -1) {
 		kfree(fw_control_context);
-		return rc;
+		return -SAS_QUEUE_FULL;
 	}
 	ccb = &pm8001_ha->ccb_info[tag];
 	ccb->ccb_tag = tag;
@@ -4885,8 +4879,8 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 		&ioctl_payload->func_specific,
 		ioctl_payload->wr_length);
 	memset(&nvmd_req, 0, sizeof(nvmd_req));
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc) {
+	tag = pm8001_tag_alloc(pm8001_ha, NULL);
+	if (tag == -1) {
 		kfree(fw_control_context);
 		return -EBUSY;
 	}
@@ -5011,8 +5005,8 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
 	fw_control_context->virtAddr = buffer;
 	fw_control_context->phys_addr = phys_addr;
 	fw_control_context->len = fw_control->len;
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc) {
+	tag = pm8001_tag_alloc(pm8001_ha, NULL);
+	if (tag == -1) {
 		kfree(fw_control_context);
 		return -EBUSY;
 	}
@@ -5113,8 +5107,8 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,
 	u32 tag;
 	u32 opc = OPC_INB_SET_DEVICE_STATE;
 	memset(&payload, 0, sizeof(payload));
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	tag = pm8001_tag_alloc(pm8001_ha, pm8001_dev->sas_device);
+	if (tag == -1)
 		return -1;
 	ccb = &pm8001_ha->ccb_info[tag];
 	ccb->ccb_tag = tag;
@@ -5125,6 +5119,8 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,
 	payload.nds = cpu_to_le32(state);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
 	return rc;
 
 }
@@ -5139,8 +5135,8 @@ pm8001_chip_sas_re_initialization(struct pm8001_hba_info *pm8001_ha)
 	u32 tag;
 	u32 opc = OPC_INB_SAS_RE_INITIALIZE;
 	memset(&payload, 0, sizeof(payload));
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	tag = pm8001_tag_alloc(pm8001_ha, NULL);
+	if (tag == -1)
 		return -ENOMEM;
 	ccb = &pm8001_ha->ccb_info[tag];
 	ccb->ccb_tag = tag;
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index a8f5344fdfda..31b22169a477 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -176,7 +176,6 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 	}
 	PM8001_CHIP_DISP->chip_iounmap(pm8001_ha);
 	flush_workqueue(pm8001_wq);
-	kfree(pm8001_ha->tags);
 	kfree(pm8001_ha);
 }
 
@@ -260,11 +259,10 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha);
  *
  */
 static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
-			const struct pci_device_id *ent)
+			 const struct pci_device_id *ent)
 {
 	int i;
 	spin_lock_init(&pm8001_ha->lock);
-	spin_lock_init(&pm8001_ha->bitmap_lock);
 	PM8001_INIT_DBG(pm8001_ha,
 		pm8001_printk("pm8001_alloc: PHY:%x\n",
 				pm8001_ha->chip->n_phy));
@@ -276,9 +274,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 		INIT_LIST_HEAD(&pm8001_ha->port[i].list);
 	}
 
-	pm8001_ha->tags = kzalloc(PM8001_MAX_CCB, GFP_KERNEL);
-	if (!pm8001_ha->tags)
-		goto err_out;
 	/* MPI Memory region 1 for AAP Event Log for fw */
 	pm8001_ha->memoryMap.region[AAP1].num_elements = 1;
 	pm8001_ha->memoryMap.region[AAP1].element_size = PM8001_EVENT_LOG_SIZE;
@@ -378,7 +373,7 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 				PM8001_FAIL_DBG(pm8001_ha,
 					pm8001_printk("Mem%d alloc failed\n",
 					i));
-				goto err_out;
+				return false;
 		}
 	}
 
@@ -400,11 +395,7 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 		++pm8001_ha->tags_num;
 	}
 	pm8001_ha->flags = PM8001F_INIT_TIME;
-	/* Initialize tags */
-	pm8001_tag_init(pm8001_ha);
-	return 0;
-err_out:
-	return 1;
+	return true;
 }
 
 /**
@@ -589,7 +580,7 @@ static int pm8001_prep_sas_ha_init(struct Scsi_Host *shost,
  * @shost: scsi host which has been allocated outside
  * @chip_info: our ha struct.
  */
-static void  pm8001_post_sas_ha_init(struct Scsi_Host *shost,
+static bool  pm8001_post_sas_ha_init(struct Scsi_Host *shost,
 				     const struct pm8001_chip_info *chip_info)
 {
 	int i = 0;
@@ -610,6 +601,13 @@ static void  pm8001_post_sas_ha_init(struct Scsi_Host *shost,
 	sha->sas_addr = &pm8001_ha->sas_addr[0];
 	sha->num_phys = chip_info->n_phy;
 	sha->core.shost = shost;
+
+	pm8001_ha->host_dev = scsi_get_virtual_dev(pm8001_ha->shost, 0,
+						   PM8001_MAX_DEVICES);
+	if (!pm8001_ha->host_dev)
+		return false;
+
+	return true;
 }
 
 /**
@@ -1108,7 +1106,11 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	if (pm8001_configure_phy_settings(pm8001_ha))
 		goto err_out_shost;
 
-	pm8001_post_sas_ha_init(shost, chip);
+	if (!pm8001_post_sas_ha_init(shost, chip)) {
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
+					"pm8001_post_sas_ha_init failed\n"));
+		goto err_out_shost;
+	}
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
 	if (rc) {
 		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 6de448e07528..273cca0504b2 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -41,22 +41,6 @@
 #include <linux/slab.h>
 #include "pm8001_sas.h"
 
-/**
- * pm8001_find_tag - from sas task to find out  tag that belongs to this task
- * @task: the task sent to the LLDD
- * @tag: the found tag associated with the task
- */
-static int pm8001_find_tag(struct sas_task *task, u32 *tag)
-{
-	if (task->lldd_task) {
-		struct pm8001_ccb_info *ccb;
-		ccb = task->lldd_task;
-		*tag = ccb->ccb_tag;
-		return 1;
-	}
-	return 0;
-}
-
 /**
   * pm8001_tag_free - free the no more needed tag
   * @pm8001_ha: our hba struct
@@ -64,38 +48,33 @@ static int pm8001_find_tag(struct sas_task *task, u32 *tag)
   */
 void pm8001_tag_free(struct pm8001_hba_info *pm8001_ha, u32 tag)
 {
-	void *bitmap = pm8001_ha->tags;
-	clear_bit(tag, bitmap);
+	struct scsi_cmnd *scmd = scsi_host_find_tag(pm8001_ha->shost, tag);
+	struct sas_task *task;
+
+	if (WARN_ON(!scmd))
+		return;
+	task = (void *)scmd->host_scribble;
+	sas_free_task(task);
 }
 
 /**
   * pm8001_tag_alloc - allocate a empty tag for task used.
   * @pm8001_ha: our hba struct
-  * @tag_out: the found empty tag .
+  * @dev: device from which the tag should be allocated or NULL
   */
-inline int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)
+inline u32 pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha,
+			    struct domain_device *dev)
 {
-	unsigned int tag;
-	void *bitmap = pm8001_ha->tags;
-	unsigned long flags;
+	struct sas_task *task;
+	struct scsi_lun lun;
 
-	spin_lock_irqsave(&pm8001_ha->bitmap_lock, flags);
-	tag = find_first_zero_bit(bitmap, pm8001_ha->tags_num);
-	if (tag >= pm8001_ha->tags_num) {
-		spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
-		return -SAS_QUEUE_FULL;
-	}
-	set_bit(tag, bitmap);
-	spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
-	*tag_out = tag;
-	return 0;
-}
+	int_to_scsilun(0, &lun);
+	task = sas_alloc_slow_task(pm8001_ha->sas, dev,
+				   &lun, GFP_KERNEL);
+	if (!task)
+		return -1;
 
-void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha)
-{
-	int i;
-	for (i = 0; i < pm8001_ha->tags_num; ++i)
-		pm8001_tag_free(pm8001_ha, i);
+	return task->tag;
 }
 
  /**
@@ -386,7 +365,7 @@ static int pm8001_task_exec(struct sas_task *task,
 	struct pm8001_port *port = NULL;
 	struct sas_task *t = task;
 	struct pm8001_ccb_info *ccb;
-	u32 tag = 0xdeadbeef, rc = 0, n_elem = 0;
+	u32 rc = 0, n_elem = 0;
 	unsigned long flags = 0;
 	enum sas_protocol task_proto = t->task_proto;
 
@@ -430,10 +409,13 @@ static int pm8001_task_exec(struct sas_task *task,
 				continue;
 			}
 		}
-		rc = pm8001_tag_alloc(pm8001_ha, &tag);
-		if (rc)
+		if (task->tag == -1) {
+			dev_printk(KERN_ERR, pm8001_ha->dev,
+				"invalid sas_task tag\n");
+			rc = -EINVAL;
 			goto err_out;
-		ccb = &pm8001_ha->ccb_info[tag];
+		}
+		ccb = &pm8001_ha->ccb_info[task->tag];
 
 		if (!sas_protocol_ata(task_proto)) {
 			if (t->num_scatter) {
@@ -443,7 +425,7 @@ static int pm8001_task_exec(struct sas_task *task,
 					t->data_dir);
 				if (!n_elem) {
 					rc = -ENOMEM;
-					goto err_out_tag;
+					goto err_out;
 				}
 			}
 		} else {
@@ -452,7 +434,7 @@ static int pm8001_task_exec(struct sas_task *task,
 
 		t->lldd_task = ccb;
 		ccb->n_elem = n_elem;
-		ccb->ccb_tag = tag;
+		ccb->ccb_tag = task->tag;
 		ccb->task = t;
 		ccb->device = pm8001_dev;
 		switch (task_proto) {
@@ -480,7 +462,7 @@ static int pm8001_task_exec(struct sas_task *task,
 		if (rc) {
 			PM8001_IO_DBG(pm8001_ha,
 				pm8001_printk("rc is %x\n", rc));
-			goto err_out_tag;
+			goto err_out;
 		}
 		/* TODO: select normal or high priority */
 		spin_lock(&t->task_state_lock);
@@ -491,8 +473,6 @@ static int pm8001_task_exec(struct sas_task *task,
 	rc = 0;
 	goto out_done;
 
-err_out_tag:
-	pm8001_tag_free(pm8001_ha, tag);
 err_out:
 	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
 	if (!sas_protocol_ata(task_proto))
@@ -520,10 +500,9 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
   * @pm8001_ha: our hba card information
   * @ccb: the ccb which attached to ssp task
   * @task: the task to be free.
-  * @ccb_idx: ccb index.
   */
 void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
-	struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx)
+	struct sas_task *task, struct pm8001_ccb_info *ccb)
 {
 	if (!ccb->task)
 		return;
@@ -551,7 +530,6 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
 	ccb->open_retry = 0;
-	pm8001_tag_free(pm8001_ha, ccb_idx);
 }
 
  /**
@@ -805,7 +783,6 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 {
 	struct domain_device *dev = pm8001_dev->sas_device;
 	int res, retry;
-	u32 ccb_tag;
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task = NULL;
 
@@ -822,17 +799,17 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 		task->slow_task->timer.expires = jiffies + PM8001_TASK_TIMEOUT * HZ;
 		add_timer(&task->slow_task->timer);
 
-		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-		if (res)
-			return res;
-		ccb = &pm8001_ha->ccb_info[ccb_tag];
+		if (task->tag == -1)
+			return -SAS_QUEUE_FULL;
+
+		ccb = &pm8001_ha->ccb_info[task->tag];
 		ccb->device = pm8001_dev;
-		ccb->ccb_tag = ccb_tag;
+		ccb->ccb_tag = task->tag;
 		ccb->task = task;
 		ccb->n_elem = 0;
 
 		res = PM8001_CHIP_DISP->task_abort(pm8001_ha,
-			pm8001_dev, flag, task_tag, ccb_tag);
+			pm8001_dev, flag, task_tag, task->tag);
 
 		if (res) {
 			del_timer(&task->slow_task->timer);
@@ -973,11 +950,11 @@ void pm8001_open_reject_retry(
 				& SAS_TASK_STATE_ABORTED))) {
 			spin_unlock_irqrestore(&task->task_state_lock,
 				flags1);
-			pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+			pm8001_ccb_task_free(pm8001_ha, task, ccb);
 		} else {
 			spin_unlock_irqrestore(&task->task_state_lock,
 				flags1);
-			pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+			pm8001_ccb_task_free(pm8001_ha, task, ccb);
 			mb();/* in order to force CPU ordering */
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			task->task_done(task);
@@ -1139,7 +1116,6 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
 /* optional SAM-3 */
 int pm8001_query_task(struct sas_task *task)
 {
-	u32 tag = 0xdeadbeef;
 	int i = 0;
 	struct scsi_lun lun;
 	struct pm8001_tmf_task tmf_task;
@@ -1154,8 +1130,7 @@ int pm8001_query_task(struct sas_task *task)
 			pm8001_find_ha_by_dev(dev);
 
 		int_to_scsilun(cmnd->device->lun, &lun);
-		rc = pm8001_find_tag(task, &tag);
-		if (rc == 0) {
+		if (task->tag == -1) {
 			rc = TMF_RESP_FUNC_FAILED;
 			return rc;
 		}
@@ -1164,7 +1139,7 @@ int pm8001_query_task(struct sas_task *task)
 			printk(KERN_INFO "%02x ", cmnd->cmnd[i]);
 		printk(KERN_INFO "]\n");
 		tmf_task.tmf = TMF_QUERY_TASK;
-		tmf_task.tag_of_task_to_be_managed = tag;
+		tmf_task.tag_of_task_to_be_managed = task->tag;
 
 		rc = pm8001_exec_internal_tmf_task(dev, lun.scsi_lun, &tmf_task);
 		switch (rc) {
@@ -1205,8 +1180,7 @@ int pm8001_abort_task(struct sas_task *task)
 	pm8001_dev = dev->lldd_dev;
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	phy_id = pm8001_dev->attached_phy;
-	ret = pm8001_find_tag(task, &tag);
-	if (ret == 0) {
+	if (task->tag == -1) {
 		pm8001_printk("no tag for task:%p\n", task);
 		return TMF_RESP_FUNC_FAILED;
 	}
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index ae7ba9b3c4bc..b77fb1e1a167 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -499,7 +499,6 @@ struct pm8001_hba_info {
 	struct list_head	list;
 	unsigned long		flags;
 	spinlock_t		lock;/* host-wide lock */
-	spinlock_t		bitmap_lock;
 	struct pci_dev		*pdev;/* our device */
 	struct device		*dev;
 	struct pm8001_hba_memspace io_mem[6];
@@ -531,11 +530,11 @@ struct pm8001_hba_info {
 	u8			sas_addr[SAS_ADDR_SIZE];
 	struct sas_ha_struct	*sas;/* SCSI/SAS glue */
 	struct Scsi_Host	*shost;
+	struct scsi_device	*host_dev;
 	u32			chip_id;
 	const struct pm8001_chip_info	*chip;
 	struct completion	*nvmd_completion;
 	int			tags_num;
-	unsigned long		*tags;
 	struct pm8001_phy	phy[PM8001_MAX_PHYS];
 	struct pm8001_port	port[PM8001_MAX_PHYS];
 	u32			id;
@@ -652,11 +651,12 @@ struct fw_control_ex {
 extern struct workqueue_struct *pm8001_wq;
 
 /******************** function prototype *********************/
-int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out);
+u32 pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha,
+		     struct domain_device *dev);
 void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha);
 u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag);
 void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
-	struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx);
+	struct sas_task *task, struct pm8001_ccb_info *ccb);
 int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	void *funcdata);
 void pm8001_scan_start(struct Scsi_Host *shost);
@@ -752,10 +752,9 @@ extern struct device_attribute *pm8001_host_attrs[];
 
 static inline void
 pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
-			struct sas_task *task, struct pm8001_ccb_info *ccb,
-			u32 ccb_idx)
+			struct sas_task *task, struct pm8001_ccb_info *ccb)
 {
-	pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb_idx);
+	pm8001_ccb_task_free(pm8001_ha, task, ccb);
 	smp_mb(); /*in order to force CPU ordering*/
 	spin_unlock(&pm8001_ha->lock);
 	task->task_done(task);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 702609f10717..ad625ac9fee1 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1198,8 +1198,8 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
 	u32 page_code;
 
 	memset(&payload, 0, sizeof(struct set_ctrl_cfg_req));
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	tag = pm8001_tag_alloc(pm8001_ha, NULL);
+	if (tag == -1)
 		return -1;
 
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
@@ -1244,9 +1244,9 @@ pm80xx_set_sas_protocol_timer_config(struct pm8001_hba_info *pm8001_ha)
 	memset(&payload, 0, sizeof(struct set_ctrl_cfg_req));
 	memset(&SASConfigPage, 0, sizeof(SASProtocolTimerConfig_t));
 
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
+	tag = pm8001_tag_alloc(pm8001_ha, NULL);
 
-	if (rc)
+	if (tag == -1)
 		return -1;
 
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
@@ -1413,8 +1413,8 @@ static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
 	u32 opc = OPC_INB_KEK_MANAGEMENT;
 
 	memset(&payload, 0, sizeof(struct kek_mgmt_req));
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	tag = pm8001_tag_alloc(pm8001_ha, NULL);
+	if (tag == -1)
 		return -1;
 
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
@@ -1748,8 +1748,6 @@ pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 		struct pm8001_device *pm8001_ha_dev)
 {
-	int res;
-	u32 ccb_tag;
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task = NULL;
 	struct task_abort_req task_abort;
@@ -1775,15 +1773,16 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 
 	task->task_done = pm8001_task_done;
 
-	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res) {
+	if (task->tag == -1) {
 		sas_free_task(task);
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("invalid task tag\n"));
 		return;
 	}
 
-	ccb = &pm8001_ha->ccb_info[ccb_tag];
+	ccb = &pm8001_ha->ccb_info[task->tag];
 	ccb->device = pm8001_ha_dev;
-	ccb->ccb_tag = ccb_tag;
+	ccb->ccb_tag = task->tag;
 	ccb->task = task;
 
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
@@ -1791,16 +1790,14 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	memset(&task_abort, 0, sizeof(task_abort));
 	task_abort.abort_all = cpu_to_le32(1);
 	task_abort.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
-	task_abort.tag = cpu_to_le32(ccb_tag);
+	task_abort.tag = cpu_to_le32(task->tag);
 
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
 			sizeof(task_abort), 0);
 	PM8001_FAIL_DBG(pm8001_ha,
 		pm8001_printk("Executing abort task end\n"));
-	if (ret) {
+	if (ret)
 		sas_free_task(task);
-		pm8001_tag_free(pm8001_ha, ccb_tag);
-	}
 }
 
 static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
@@ -1808,7 +1805,6 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 {
 	struct sata_start_req sata_cmd;
 	int res;
-	u32 ccb_tag;
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task = NULL;
 	struct host_to_dev_fis fis;
@@ -1827,20 +1823,18 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	}
 	task->task_done = pm8001_task_done;
 
-	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res) {
+	if (task->tag == -1) {
 		sas_free_task(task);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("cannot allocate tag !!!\n"));
 		return;
 	}
-
 	task->dev = dev;
 	task->dev->lldd_dev = pm8001_ha_dev;
 
-	ccb = &pm8001_ha->ccb_info[ccb_tag];
+	ccb = &pm8001_ha->ccb_info[task->tag];
 	ccb->device = pm8001_ha_dev;
-	ccb->ccb_tag = ccb_tag;
+	ccb->ccb_tag = task->tag;
 	ccb->task = task;
 	ccb->n_elem = 0;
 	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
@@ -1857,7 +1851,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	fis.lbal = 0x10;
 	fis.sector_count = 0x1;
 
-	sata_cmd.tag = cpu_to_le32(ccb_tag);
+	sata_cmd.tag = cpu_to_le32(task->tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
 	sata_cmd.ncqtag_atap_dir_m_dad |= ((0x1 << 7) | (0x5 << 9));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
@@ -1865,10 +1859,8 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
 			sizeof(sata_cmd), 0);
 	PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("Executing read log end\n"));
-	if (res) {
+	if (res)
 		sas_free_task(task);
-		pm8001_tag_free(pm8001_ha, ccb_tag);
-	}
 }
 
 /**
@@ -2142,10 +2134,10 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			t, status, ts->resp, ts->stat));
 		if (t->slow_task)
 			complete(&t->slow_task->completion);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 		mb();/* in order to force CPU ordering */
 		t->task_done(t);
 	}
@@ -2339,10 +2331,10 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			"task 0x%p done with event 0x%x resp 0x%x "
 			"stat 0x%x but aborted by upper layer!\n",
 			t, event, ts->resp, ts->stat));
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 		mb();/* in order to force CPU ordering */
 		t->task_done(t);
 	}
@@ -2586,7 +2578,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 			return;
 		}
 		break;
@@ -2602,7 +2594,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 			return;
 		}
 		break;
@@ -2624,7 +2616,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 			return;
 		}
 		break;
@@ -2687,7 +2679,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 					IO_DS_NON_OPERATIONAL);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 			return;
 		}
 		break;
@@ -2707,7 +2699,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 					IO_DS_IN_ERROR);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 			return;
 		}
 		break;
@@ -2738,10 +2730,10 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			t, status, ts->resp, ts->stat));
 		if (t->slow_task)
 			complete(&t->slow_task->completion);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 	}
 }
 
@@ -2853,7 +2845,7 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 			return;
 		}
 		break;
@@ -2974,10 +2966,10 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			pm8001_printk("task 0x%p done with io_status 0x%x"
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, event, ts->resp, ts->stat));
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free_done(pm8001_ha, t, ccb);
 	}
 }
 
@@ -3198,10 +3190,10 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			"task 0x%p done with io_status 0x%x resp 0x%x"
 			"stat 0x%x but aborted by upper layer!\n",
 			t, status, ts->resp, ts->stat));
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb);
 		mb();/* in order to force CPU ordering */
 		t->task_done(t);
 	}
@@ -4794,13 +4786,12 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 					pm8001_printk("task 0x%p resp 0x%x "
 					" stat 0x%x but aborted by upper layer "
 					"\n", task, ts->resp, ts->stat));
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+				pm8001_ccb_task_free(pm8001_ha, task, ccb);
 				return 0;
 			} else {
 				spin_unlock_irqrestore(&task->task_state_lock,
 							flags);
-				pm8001_ccb_task_free_done(pm8001_ha, task,
-								ccb, tag);
+				pm8001_ccb_task_free_done(pm8001_ha, task, ccb);
 				return 0;
 			}
 		}
@@ -4897,9 +4888,9 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 
 	memset(&payload, 0, sizeof(payload));
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
-		return rc;
+	tag = pm8001_tag_alloc(pm8001_ha, NULL);
+	if (tag == -1)
+		return -1;
 	ccb = &pm8001_ha->ccb_info[tag];
 	ccb->device = pm8001_dev;
 	ccb->ccb_tag = tag;
@@ -4957,14 +4948,13 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	u32 phyId, u32 phy_op)
 {
 	u32 tag;
-	int rc;
 	struct local_phy_ctl_req payload;
 	struct inbound_queue_table *circularQ;
 	u32 opc = OPC_INB_LOCAL_PHY_CONTROL;
 	memset(&payload, 0, sizeof(payload));
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
-		return rc;
+	tag = pm8001_tag_alloc(pm8001_ha, NULL);
+	if (tag == -1)
+		return -1;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag = cpu_to_le32(tag);
 	payload.phyop_phyid =
@@ -5015,9 +5005,11 @@ void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
 	u32 opc = OPC_INB_SET_PHY_PROFILE;
 
 	memset(&payload, 0, sizeof(payload));
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	tag = pm8001_tag_alloc(pm8001_ha, NULL);
+	if (tag == -1) {
 		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("Invalid tag\n"));
+		return;
+	}
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag = cpu_to_le32(tag);
 	payload.ppc_phyid = (((operation & 0xF) << 8) | (phyid  & 0xFF));
@@ -5057,10 +5049,11 @@ void pm8001_set_phy_profile_single(struct pm8001_hba_info *pm8001_ha,
 
 	memset(&payload, 0, sizeof(payload));
 
-	rc = pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	tag = pm8001_tag_alloc(pm8001_ha, NULL);
+	if (tag == -1) {
 		PM8001_INIT_DBG(pm8001_ha, pm8001_printk("Invalid tag"));
-
+		return;
+	}
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	opc = OPC_INB_SET_PHY_PROFILE;
 
-- 
2.16.4

