Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23283280033
	for <linux-scsi@vger.kernel.org>; Sat, 20 Dec 2025 07:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766215056; cv=none; b=C8K0UviG/SrMPjWeRgMmJ9zp461cDWTTkv8FY4sIkHwBHVWKvUi7sR72YcurweDvHZXbTNuolHviByuudyHszIHWRTTLHTiPhBHaI7op6TEgQoWck6xCDrp2IWDa1CwIWF5098G12rts8y785Jmwk+eUPgdJV+KkeLDUULwUTuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766215056; c=relaxed/simple;
	bh=D8m9v4CQ3tce9IUCd8+yeNW/qaJrknxTuXfZxprsE4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i3G+KaFz4JChFI3eEzMrmrua54kCfRs4lltOgiTfSWyYOf/sGg4ERcgeusMjImnCG9bBdTrEBF4nBKoI8Dit+FnqOR+VawxmenZz3ofURPGZTM70RBauMqEPv3Vdroc9lVeZQNU6G3dSBXBtIHyidenGjJuH0Dgiav4zQ9FngFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ERYiPmO7; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ERYiPmO7"
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-29f1bc40b35so44329365ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 23:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766215053; x=1766819853; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=03G6R+OxRYalLG+LdqDwHh8/+vDrpg9v+bYtW21UbGI=;
        b=ERYiPmO7Z54eDMPU0IlwrM+iWboXLEtjLBIggv09Dh2TTKCq6iZJl++bIkBai8ycTi
         pJDGWuQ6rILFFGO6U6m21MFhEtdd8nBS3iYbpAFTLKU9IjZcS5MGEHF6M92AkhbOsWTP
         NUR7T5an2H8VRICqxwxRpLpWKXSbljYIOriiKW6TN3RcM6RzSplPtcjqqJ3+BMOFvtJb
         nRapO4XFBemI0wxOIagOISdYGy3M5gX3rKNSb9eTWuS9Tie2afkAnwMukr9NiLWXTozK
         PK+P+62AkehbkhbffWN2WeMXiBPMCA7wk0UWCR30+Tw8fhvYR3Sk5FUvZLX9YoEq0Sm4
         hlpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766215053; x=1766819853;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=03G6R+OxRYalLG+LdqDwHh8/+vDrpg9v+bYtW21UbGI=;
        b=p8lfTcBAl7sYzX+umFmfyXwxGnqMdPlp7IsomVT3Nu5HmyeuWInMqV1APHoMgNTxyO
         CKiZjpMso1tKX3ilpigB7Q0KpsP042hgSab5LH6lyJNYeEmVbZPi7vSWalRFgKQOVq5C
         PM5nOPwYTGYSGGwlU8qMnkATBKtPcBbLD2SlCMiBgQ0Tb9B5rjXa+uR4d7JJ7T4emrOe
         HlDOTBE/11zAjTCvrFP2xHchopnu8qAaRUvwGLCK71TUlTY1uK4luIj2i5vKdazR1WyU
         Tvf1qWo66dNCjUl6WkpExGiyGU54dfMJFpQIO2ktErqKvzLy4Wj/W5Lk2LT5FzQK97Nr
         Tpkg==
X-Gm-Message-State: AOJu0Yw3K4fvNaaH+2i5cuMO5PMVm2EIjyTx99+I2AVjaBqZkeXRpW2W
	dIEX32Ppl9R9RwFZkrKqBUVI+g0PGX/k/LY+wV+xqyzESER+KLYOXDtSRJ1fMSmVY/c=
X-Gm-Gg: AY/fxX7IcKkMIynwXs/7oadb8XLXqTvg8YDNtiwoN55jAqWcVVHugJYVEmjUsTPtCOp
	mUwakRjvQTtzyZsMSy6Al8n6ut2VWhwwNow5uMQH+76AizKAjtuW8w9X1vjHDYqqlyiG+I0tYST
	bIO/Obh6Qa6INwtNpv23s4fr2uY6YQTRuQowpj+U2lOumTcg+GCw8UkkWqqY65AuopumRrXWGQM
	Zk3yNWYMjrcZP4biooP9sben4mtFLew7X5kNY5lQbIQD+lhvwS14llVFmnDLwkEe70K6oerHB+p
	gsT/v33/gDUcFziZb/6qMRffbSLfr5eHX/PSHLqsxn7OjRYj6GiRRZfaUVaUCOxEa2lFx8HKrVI
	Sui2HuSBxQBGfs90SliUmZVix+4oGkJuuDxJq/ZQn2Ntxxpp1oyfd/lVsVD67Ly2LKby3gK+9Oc
	SPTg+w8P1S9J4QCIqHCH88bWZoeVbduxBFHBJgQ2udG4FLKEIRPZzdWnuh4MTAmsm3vuaowgqF/
	C+gMhwmdz67Hg5MoQSN6faqS/G3YVUyO2mBTIlF9tssfqm+WHwujT5s3QqkqimvntsGIpOhplfN
	k9Sv
X-Google-Smtp-Source: AGHT+IH83NKU7CQmWIRBp4DXQWMlmvcj1G+lQUf61yCjBNVMYfvq0mQ8e3FLX5Wt/5k0e5Rp4q8mew==
X-Received: by 2002:a05:7022:258d:b0:119:e56b:c754 with SMTP id a92af1059eb24-121722e310amr6625080c88.25.1766215053179;
        Fri, 19 Dec 2025 23:17:33 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254d369sm17527115c88.16.2025.12.19.23.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 23:17:32 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH v2 2/5] scsi: ibmvfc: remove function tracing macros
Date: Fri, 19 Dec 2025 23:17:13 -0800
Message-ID: <20251220071715.44296-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These function tracing macros clutter the code and provide
no value over ftrace. Remove them.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 60 +---------------------------------
 drivers/scsi/ibmvscsi/ibmvfc.h |  3 --
 2 files changed, 1 insertion(+), 62 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 228daffb286d..137f8eddd1ba 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -680,7 +680,6 @@ static void ibmvfc_link_down(struct ibmvfc_host *vhost,
 {
 	struct ibmvfc_target *tgt;
 
-	ENTER;
 	scsi_block_requests(vhost->host);
 	list_for_each_entry(tgt, &vhost->targets, queue)
 		ibmvfc_del_tgt(tgt);
@@ -688,7 +687,6 @@ static void ibmvfc_link_down(struct ibmvfc_host *vhost,
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_DEL);
 	vhost->events_to_log |= IBMVFC_AE_LINKDOWN;
 	wake_up(&vhost->work_wait_q);
-	LEAVE;
 }
 
 /**
@@ -792,7 +790,6 @@ static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
 	int i;
 	struct ibmvfc_event_pool *pool = &queue->evt_pool;
 
-	ENTER;
 	if (!queue->total_depth)
 		return 0;
 
@@ -836,7 +833,6 @@ static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
 		list_add_tail(&evt->queue_list, &queue->free);
 	}
 
-	LEAVE;
 	return 0;
 }
 
@@ -852,7 +848,6 @@ static void ibmvfc_free_event_pool(struct ibmvfc_host *vhost,
 	int i;
 	struct ibmvfc_event_pool *pool = &queue->evt_pool;
 
-	ENTER;
 	for (i = 0; i < pool->size; ++i) {
 		list_del(&pool->events[i].queue_list);
 		BUG_ON(atomic_read(&pool->events[i].free) != 1);
@@ -866,7 +861,6 @@ static void ibmvfc_free_event_pool(struct ibmvfc_host *vhost,
 	dma_free_coherent(vhost->dev,
 			  pool->size * sizeof(*pool->iu_storage),
 			  pool->iu_storage, pool->iu_token);
-	LEAVE;
 }
 
 /**
@@ -2069,7 +2063,6 @@ static int ibmvfc_bsg_timeout(struct bsg_job *job)
 	unsigned long flags;
 	int rc;
 
-	ENTER;
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	if (vhost->aborting_passthru || vhost->state != IBMVFC_ACTIVE) {
 		__ibmvfc_reset_host(vhost);
@@ -2106,7 +2099,6 @@ static int ibmvfc_bsg_timeout(struct bsg_job *job)
 
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
-	LEAVE;
 	return rc;
 }
 
@@ -2127,7 +2119,6 @@ static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
 	unsigned long flags;
 	int rc = 0, issue_login = 1;
 
-	ENTER;
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	list_for_each_entry(tgt, &vhost->targets, queue) {
 		if (tgt->scsi_id == port_id) {
@@ -2171,7 +2162,6 @@ static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
 	ibmvfc_free_event(evt);
 unlock_out:
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
-	LEAVE;
 	return rc;
 }
 
@@ -2196,7 +2186,6 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 	int rc = 0, req_seg, rsp_seg, issue_login = 0;
 	u32 fc_flags, rsp_len;
 
-	ENTER;
 	bsg_reply->reply_payload_rcv_len = 0;
 	if (rport)
 		port_id = rport->port_id;
@@ -2324,7 +2313,6 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 	dma_unmap_sg(vhost->dev, job->reply_payload.sg_list,
 		     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
 	mutex_unlock(&vhost->passthru_mutex);
-	LEAVE;
 	return rc;
 }
 
@@ -2495,7 +2483,6 @@ static int ibmvfc_wait_for_ops(struct ibmvfc_host *vhost, void *device,
 	signed long timeout = IBMVFC_ABORT_WAIT_TIMEOUT * HZ;
 	struct ibmvfc_queue *queues;
 
-	ENTER;
 	if (vhost->mq_enabled && vhost->using_channels) {
 		queues = vhost->scsi_scrqs.scrqs;
 		q_size = vhost->scsi_scrqs.active_queues;
@@ -2544,13 +2531,11 @@ static int ibmvfc_wait_for_ops(struct ibmvfc_host *vhost, void *device,
 				spin_unlock_irqrestore(vhost->host->host_lock, flags);
 				if (wait)
 					dev_err(vhost->dev, "Timed out waiting for aborted commands\n");
-				LEAVE;
 				return wait ? FAILED : SUCCESS;
 			}
 		}
 	} while (wait);
 
-	LEAVE;
 	return SUCCESS;
 }
 
@@ -2606,7 +2591,6 @@ static int ibmvfc_cancel_all_mq(struct scsi_device *sdev, int type)
 	LIST_HEAD(cancelq);
 	u16 status;
 
-	ENTER;
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	num_hwq = vhost->scsi_scrqs.active_queues;
 	for (i = 0; i < num_hwq; i++) {
@@ -2671,7 +2655,6 @@ static int ibmvfc_cancel_all_mq(struct scsi_device *sdev, int type)
 		return -EIO;
 
 	sdev_printk(KERN_INFO, sdev, "Successfully cancelled outstanding commands\n");
-	LEAVE;
 	return 0;
 }
 
@@ -2684,7 +2667,6 @@ static int ibmvfc_cancel_all_sq(struct scsi_device *sdev, int type)
 	unsigned long flags;
 	u16 status;
 
-	ENTER;
 	found_evt = NULL;
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	spin_lock(&vhost->crq.l_lock);
@@ -2937,7 +2919,6 @@ static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 	int cancel_rc, block_rc;
 	int rc = FAILED;
 
-	ENTER;
 	block_rc = fc_block_scsi_eh(cmd);
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
@@ -2952,7 +2933,6 @@ static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 	if (block_rc == FAST_IO_FAIL && rc != FAILED)
 		rc = FAST_IO_FAIL;
 
-	LEAVE;
 	return rc;
 }
 
@@ -2970,7 +2950,6 @@ static int ibmvfc_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	int cancel_rc, block_rc, reset_rc = 0;
 	int rc = FAILED;
 
-	ENTER;
 	block_rc = fc_block_scsi_eh(cmd);
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
@@ -2985,7 +2964,6 @@ static int ibmvfc_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	if (block_rc == FAST_IO_FAIL && rc != FAILED)
 		rc = FAST_IO_FAIL;
 
-	LEAVE;
 	return rc;
 }
 
@@ -3020,7 +2998,6 @@ static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
 	unsigned long cancel_rc = 0;
 	bool tgt_reset = false;
 
-	ENTER;
 	block_rc = fc_block_rport(rport);
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
@@ -3049,7 +3026,6 @@ static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
 	if (block_rc == FAST_IO_FAIL && rc != FAILED)
 		rc = FAST_IO_FAIL;
 
-	LEAVE;
 	return rc;
 }
 
@@ -3086,7 +3062,6 @@ static void ibmvfc_terminate_rport_io(struct fc_rport *rport)
 	unsigned long rc, flags;
 	unsigned int found;
 
-	ENTER;
 	shost_for_each_device(sdev, shost) {
 		dev_rport = starget_to_rport(scsi_target(sdev));
 		if (dev_rport != rport)
@@ -3119,7 +3094,6 @@ static void ibmvfc_terminate_rport_io(struct fc_rport *rport)
 	}
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	LEAVE;
 }
 
 static const struct ibmvfc_async_desc ae_desc [] = {
@@ -5800,7 +5774,6 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 	struct device *dev = vhost->dev;
 	size_t fmt_size;
 
-	ENTER;
 	spin_lock_init(&queue->_lock);
 	queue->q_lock = &queue->_lock;
 
@@ -5869,7 +5842,6 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
 	struct vio_dev *vdev = to_vio_dev(dev);
 	struct ibmvfc_queue *crq = &vhost->crq;
 
-	ENTER;
 	if (ibmvfc_alloc_queue(vhost, crq, IBMVFC_CRQ_FMT))
 		return -ENOMEM;
 
@@ -5901,7 +5873,6 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
 		goto req_irq_failed;
 	}
 
-	LEAVE;
 	return retrc;
 
 req_irq_failed:
@@ -5923,7 +5894,6 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	struct ibmvfc_queue *scrq = &channels->scrqs[index];
 	int rc = -ENOMEM;
 
-	ENTER;
 
 	rc = h_reg_sub_crq(vdev->unit_address, scrq->msg_token, PAGE_SIZE,
 			   &scrq->cookie, &scrq->hw_irq);
@@ -5971,7 +5941,6 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 	scrq->hwq_id = index;
 
-	LEAVE;
 	return 0;
 
 irq_failed:
@@ -5979,7 +5948,6 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
 	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
 reg_failed:
-	LEAVE;
 	return rc;
 }
 
@@ -5992,7 +5960,6 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 	struct ibmvfc_queue *scrq = &channels->scrqs[index];
 	long rc;
 
-	ENTER;
 
 	free_irq(scrq->irq, scrq);
 	irq_dispose_mapping(scrq->irq);
@@ -6009,8 +5976,6 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 	/* Clean out the queue */
 	memset(scrq->msgs.crq, 0, PAGE_SIZE);
 	scrq->cur = 0;
-
-	LEAVE;
 }
 
 static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
@@ -6018,7 +5983,6 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 {
 	int i, j;
 
-	ENTER;
 	if (!vhost->mq_enabled || !channels->scrqs)
 		return;
 
@@ -6030,8 +5994,6 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 			return;
 		}
 	}
-
-	LEAVE;
 }
 
 static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
@@ -6039,14 +6001,11 @@ static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
 {
 	int i;
 
-	ENTER;
 	if (!vhost->mq_enabled || !channels->scrqs)
 		return;
 
 	for (i = 0; i < channels->max_queues; i++)
 		ibmvfc_deregister_channel(vhost, channels, i);
-
-	LEAVE;
 }
 
 static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
@@ -6082,7 +6041,6 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 
 static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 {
-	ENTER;
 	if (!vhost->mq_enabled)
 		return;
 
@@ -6093,8 +6051,6 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 	}
 
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
-
-	LEAVE;
 }
 
 static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
@@ -6117,14 +6073,12 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
 
 static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
 {
-	ENTER;
 	if (!vhost->scsi_scrqs.scrqs)
 		return;
 
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
 	ibmvfc_release_channels(vhost, &vhost->scsi_scrqs);
-	LEAVE;
 }
 
 static void ibmvfc_free_disc_buf(struct device *dev, struct ibmvfc_channels *channels)
@@ -6144,7 +6098,6 @@ static void ibmvfc_free_mem(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_queue *async_q = &vhost->async_crq;
 
-	ENTER;
 	mempool_destroy(vhost->tgt_pool);
 	kfree(vhost->trace);
 	ibmvfc_free_disc_buf(vhost->dev, &vhost->scsi_scrqs);
@@ -6154,7 +6107,6 @@ static void ibmvfc_free_mem(struct ibmvfc_host *vhost)
 			  vhost->channel_setup_buf, vhost->channel_setup_dma);
 	dma_pool_destroy(vhost->sg_pool);
 	ibmvfc_free_queue(vhost, async_q);
-	LEAVE;
 }
 
 static int ibmvfc_alloc_disc_buf(struct device *dev, struct ibmvfc_channels *channels)
@@ -6184,10 +6136,9 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 	struct ibmvfc_queue *async_q = &vhost->async_crq;
 	struct device *dev = vhost->dev;
 
-	ENTER;
 	if (ibmvfc_alloc_queue(vhost, async_q, IBMVFC_ASYNC_FMT)) {
 		dev_err(dev, "Couldn't allocate/map async queue.\n");
-		goto nomem;
+		return -ENOMEM;
 	}
 
 	vhost->sg_pool = dma_pool_create(IBMVFC_NAME, dev,
@@ -6234,7 +6185,6 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 		goto free_tgt_pool;
 	}
 
-	LEAVE;
 	return 0;
 
 free_tgt_pool:
@@ -6250,8 +6200,6 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 	dma_pool_destroy(vhost->sg_pool);
 unmap_async_crq:
 	ibmvfc_free_queue(vhost, async_q);
-nomem:
-	LEAVE;
 	return -ENOMEM;
 }
 
@@ -6269,7 +6217,6 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 	unsigned long flags;
 	int did_work;
 
-	ENTER;
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	do {
 		did_work = 0;
@@ -6304,7 +6251,6 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 	if (vhost->state == IBMVFC_ACTIVE)
 		vhost->scan_complete = 1;
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
-	LEAVE;
 }
 
 /**
@@ -6324,7 +6270,6 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	unsigned int online_cpus = num_online_cpus();
 	unsigned int max_scsi_queues = min((unsigned int)IBMVFC_MAX_SCSI_QUEUES, online_cpus);
 
-	ENTER;
 	shost = scsi_host_alloc(&driver_template, sizeof(*vhost));
 	if (!shost) {
 		dev_err(dev, "Couldn't allocate host data\n");
@@ -6415,7 +6360,6 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 free_scsi_host:
 	scsi_host_put(shost);
 out:
-	LEAVE;
 	return rc;
 }
 
@@ -6432,7 +6376,6 @@ static void ibmvfc_remove(struct vio_dev *vdev)
 	LIST_HEAD(purge);
 	unsigned long flags;
 
-	ENTER;
 	ibmvfc_remove_trace_file(&vhost->host->shost_dev.kobj, &ibmvfc_trace_attr);
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
@@ -6457,7 +6400,6 @@ static void ibmvfc_remove(struct vio_dev *vdev)
 	list_del(&vhost->queue);
 	spin_unlock(&ibmvfc_driver_lock);
 	scsi_host_put(vhost->host);
-	LEAVE;
 }
 
 /**
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index c73ed2314ad0..8cb639c271fb 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -942,9 +942,6 @@ struct ibmvfc_host {
 			dev_err((vhost)->dev, ##__VA_ARGS__); \
 	} while (0)
 
-#define ENTER DBG_CMD(printk(KERN_INFO IBMVFC_NAME": Entering %s\n", __func__))
-#define LEAVE DBG_CMD(printk(KERN_INFO IBMVFC_NAME": Leaving %s\n", __func__))
-
 #ifdef CONFIG_SCSI_IBMVFC_TRACE
 #define ibmvfc_create_trace_file(kobj, attr) sysfs_create_bin_file(kobj, attr)
 #define ibmvfc_remove_trace_file(kobj, attr) sysfs_remove_bin_file(kobj, attr)
-- 
2.43.0

