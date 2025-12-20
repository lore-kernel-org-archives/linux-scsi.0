Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com [209.85.215.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0031F03DE
	for <linux-scsi@vger.kernel.org>; Sat, 20 Dec 2025 05:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766207783; cv=none; b=s66Bpv2uLRhntH6xOjrLdcy4RKj3XlbDZDU6dZs94oXPKKQCiGbv5rQaGfd4ipHvc8QEZG6kpJPa7645jW5ZbmwdLHhpDkVORMV9j6hPN9FMetvYUd9XRYCA48xzInoGELZRvDTQigZltGH3mJabvOXyEnxMbAIinF19TzOcVP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766207783; c=relaxed/simple;
	bh=A8KjwQdKnv/IoXHPTvjLEOHaaYmy9idNzfejmbTGRjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCQghMkBRo47FMRudxWqTrBsX3qOFMmRPSbgdj0yjLT/BXM7KfI087eYSfdN83417fRvEZC2NCUZCOjztxTh0JoAHwnaVKgXWpKJTKuD8GFrcGHsqrzNc8yNewfnSP4E/pN1rwT6iZJ1TN8qJf6JCqT8W6YzZ2eajlKY5PYHo2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jqf5G0Ll; arc=none smtp.client-ip=209.85.215.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jqf5G0Ll"
Received: by mail-pg1-f193.google.com with SMTP id 41be03b00d2f7-bf5ac50827dso1523368a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 21:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766207780; x=1766812580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MnpKh7tO9yzyKKrKu79t0wXsw26JJ66Nq5NZxmVV6xE=;
        b=Jqf5G0LlyUQ8ps10P+ySVanSJ316m3nC3h20fz21hnnbEP6nBPssv/GorSXV3s0TdY
         xIw8g0vyZxNIN3IaQq2ib9a52xwGyOK9DGigbE/NIp67VemP5XmUhWqSJuxrnvsXIMF2
         1jRSr+NyDIiJtOPDd3EE0LPXJjzxQW4a49SYR+ojM7IaqRgWglMqNICy/utV7w1fBPJX
         vn0P78dYU9quHkMwRpegNK3UZhYtZkLf4BsjNZE5wqXfQdXu89pHpZ1tqAgZpqVSDCbI
         /LicAEA2TIwkhgBYZpmm8MQFyP8PbPFf2/9/P+Qunzrw4vZ1EAm0oNtxiZ8qNk3IR8g1
         7cPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766207780; x=1766812580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MnpKh7tO9yzyKKrKu79t0wXsw26JJ66Nq5NZxmVV6xE=;
        b=gACwzInfXFz2HYH8av4UwSohNUEnhnsqDz2i3wXy6O6munOlIjIXBGujOF1wp7sACF
         FUVos9eW7/Hh1cgjZQN3pssO+ZhtBZGx4HYvU7e5j1sblP41V4/0bJOnT1ZCpaoFqRri
         AxrXmeGyD3m8PinI57lzFRYCrW0M437YYpUBl/Fp9nHBaCH+BIvjPbbZxDiTExTtyhfS
         wIb9smfo7rA00QDiP3G0YR9/WwXfb8QUQI3echcwUp5OZz9vnIEE0SwQkv5rx56VODlt
         S14FKeZCfq2FU1hFV2hLzB1u+9UvB2nLjVOzD7/g0h86d+2CAZLQMK/AUpwCr9927v0e
         NNjQ==
X-Gm-Message-State: AOJu0Yyx4I3NLxornMYI712AKkl//E64qordaF/Jc1a2XbEnl+pB0irP
	XGULDgLlo4pJ4gMRFKAuqfyJL9jjRMTiCYSvK1Cl3mkb0A4lIOPDxaJ/nLEIbxyDCTo=
X-Gm-Gg: AY/fxX53m1glxTi/92S/NXdrEAuultd35aAigAhCUK44qA0Tn9HhMTzIL5/APmDaz0M
	1MarLOG90G9sSejPgEecvSjb2GeU5fjpcsp7KEODmUXyIqOjaesKEj9ey6V72IJg9+VrCSMJOlR
	781jvSqtrowNobHISbk/gujAsAkKqcgLk7BtfjiSft7VmOMTo67+kgmYNqxR0RnH/lsxJ+AR1DI
	snGQFISDlRgC2B5BSCuz22tz8L5nT4z/BcnYRLwy6vGHKqi0JSdBEvCJ6W2bPZOfXHTjeqHO8Bd
	ki6MrG5UYwHEfPz+crPSd5VAxYF+CPQuCvExMM2rNHdGZis2ZCbSCBBNcwuZ5nGCMVbmLh4WsUe
	/hF6WDgnJlKbLGBjUKtTMzEUkM1EHMBlAkbXyvzYLjI5o4crY9MOhVcDk9h0gqJ8RroXiDobJMN
	XIpVtZlw7kgSFgxYi0b9k11Fb3zYxqWOcGCTZ0lSjVTgKqjcIhvJVE/FnWHDVKNHe3EPHon9uJl
	ebg6ChIS1vfchlIznBdMVqzMRZaSj2ji6cMgiMnPWm17udD/rYab87kr0sVU3ZOR24qE/NYnx/J
	7azSbSUJFKvVp44=
X-Google-Smtp-Source: AGHT+IHRpNjQe84pxKQosbMOTLv64CCzrWUXOWaAtlFgcrlP9ZBfhUdNQG12A0zdd8J9lxgJHk1VMg==
X-Received: by 2002:a05:7022:f302:b0:11e:3e9:3e9f with SMTP id a92af1059eb24-12172313197mr3111875c88.50.1766207780140;
        Fri, 19 Dec 2025 21:16:20 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724dd7f5sm16482269c88.5.2025.12.19.21.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 21:16:19 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH 2/5] scsi: ibmvfc: remove function tracing macros
Date: Fri, 19 Dec 2025 21:15:59 -0800
Message-ID: <20251220051602.28029-2-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251220051602.28029-1-enelsonmoore@gmail.com>
References: <20251220051602.28029-1-enelsonmoore@gmail.com>
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
 drivers/scsi/ibmvscsi/ibmvfc.c | 53 ----------------------------------
 drivers/scsi/ibmvscsi/ibmvfc.h |  3 --
 2 files changed, 56 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 228daffb286d..946d15125b43 100644
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
@@ -6010,7 +5977,6 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 	memset(scrq->msgs.crq, 0, PAGE_SIZE);
 	scrq->cur = 0;
 
-	LEAVE;
 }
 
 static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
@@ -6018,7 +5984,6 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 {
 	int i, j;
 
-	ENTER;
 	if (!vhost->mq_enabled || !channels->scrqs)
 		return;
 
@@ -6031,7 +5996,6 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
 		}
 	}
 
-	LEAVE;
 }
 
 static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
@@ -6039,14 +6003,12 @@ static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
 {
 	int i;
 
-	ENTER;
 	if (!vhost->mq_enabled || !channels->scrqs)
 		return;
 
 	for (i = 0; i < channels->max_queues; i++)
 		ibmvfc_deregister_channel(vhost, channels, i);
 
-	LEAVE;
 }
 
 static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
@@ -6082,7 +6044,6 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
 
 static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 {
-	ENTER;
 	if (!vhost->mq_enabled)
 		return;
 
@@ -6094,7 +6055,6 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
-	LEAVE;
 }
 
 static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
@@ -6117,14 +6077,12 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
 
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
@@ -6144,7 +6102,6 @@ static void ibmvfc_free_mem(struct ibmvfc_host *vhost)
 {
 	struct ibmvfc_queue *async_q = &vhost->async_crq;
 
-	ENTER;
 	mempool_destroy(vhost->tgt_pool);
 	kfree(vhost->trace);
 	ibmvfc_free_disc_buf(vhost->dev, &vhost->scsi_scrqs);
@@ -6154,7 +6111,6 @@ static void ibmvfc_free_mem(struct ibmvfc_host *vhost)
 			  vhost->channel_setup_buf, vhost->channel_setup_dma);
 	dma_pool_destroy(vhost->sg_pool);
 	ibmvfc_free_queue(vhost, async_q);
-	LEAVE;
 }
 
 static int ibmvfc_alloc_disc_buf(struct device *dev, struct ibmvfc_channels *channels)
@@ -6184,7 +6140,6 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 	struct ibmvfc_queue *async_q = &vhost->async_crq;
 	struct device *dev = vhost->dev;
 
-	ENTER;
 	if (ibmvfc_alloc_queue(vhost, async_q, IBMVFC_ASYNC_FMT)) {
 		dev_err(dev, "Couldn't allocate/map async queue.\n");
 		goto nomem;
@@ -6234,7 +6189,6 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 		goto free_tgt_pool;
 	}
 
-	LEAVE;
 	return 0;
 
 free_tgt_pool:
@@ -6251,7 +6205,6 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 unmap_async_crq:
 	ibmvfc_free_queue(vhost, async_q);
 nomem:
-	LEAVE;
 	return -ENOMEM;
 }
 
@@ -6269,7 +6222,6 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 	unsigned long flags;
 	int did_work;
 
-	ENTER;
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	do {
 		did_work = 0;
@@ -6304,7 +6256,6 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 	if (vhost->state == IBMVFC_ACTIVE)
 		vhost->scan_complete = 1;
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
-	LEAVE;
 }
 
 /**
@@ -6324,7 +6275,6 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	unsigned int online_cpus = num_online_cpus();
 	unsigned int max_scsi_queues = min((unsigned int)IBMVFC_MAX_SCSI_QUEUES, online_cpus);
 
-	ENTER;
 	shost = scsi_host_alloc(&driver_template, sizeof(*vhost));
 	if (!shost) {
 		dev_err(dev, "Couldn't allocate host data\n");
@@ -6415,7 +6365,6 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 free_scsi_host:
 	scsi_host_put(shost);
 out:
-	LEAVE;
 	return rc;
 }
 
@@ -6432,7 +6381,6 @@ static void ibmvfc_remove(struct vio_dev *vdev)
 	LIST_HEAD(purge);
 	unsigned long flags;
 
-	ENTER;
 	ibmvfc_remove_trace_file(&vhost->host->shost_dev.kobj, &ibmvfc_trace_attr);
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
@@ -6457,7 +6405,6 @@ static void ibmvfc_remove(struct vio_dev *vdev)
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

