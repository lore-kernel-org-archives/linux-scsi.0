Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559E5C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2758B613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhDTALa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:30 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:46874 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbhDTALA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:11:00 -0400
Received: by mail-pj1-f50.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so14625938pja.5
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P2k74Ka+PcTFL8Qv/6wNu7ShS5u4wde3qFhZkFq7Dlw=;
        b=YkLF/3biS3JZIUz51LR4PFJ4/JQRX105skVxN/Ekm2NeXqv2CMpsgEqsY4P5VkVskW
         eF5BrasBhONshAM1js8c8EMFvxkRBdJpozKRGr6/TPS5DHvaQqEthUsgbYfDVlIFjryz
         EwruEGghb7QOZNwpcaTGBlA6rC4F4eZK2q62QRA9fL3CFQprpvsuOrRSWOg8An91Fzxn
         JVGzEY5nzporXWU0AqSu2e1EPECBgxVjWg2FB48vNvwwifLkBCn2ZtZg7HUJyZYXdPct
         9KimfXopnNvpxN1DVGuAaBgys1fwPZdBj8gBr/mN+DUgRtYKxxyeWWn3p8Ydv8FzmSKG
         dysQ==
X-Gm-Message-State: AOAM533SiVePXiKO6Y8tMKCe/+2vVS5YmYt/dx5wygTFnkCNYy2XXraN
        FgBOREXqeaPpTqbVHR58Lg4=
X-Google-Smtp-Source: ABdhPJyjTkLu0xW+eScuLOb/ROsN1coWs/VDUAf0QAsNkv9ZFVezAkNN2ibguJj8Mt8YpuCmheJBoQ==
X-Received: by 2002:a17:902:dacd:b029:e5:cf71:3901 with SMTP id q13-20020a170902dacdb02900e5cf713901mr25024255plx.23.1618877429939;
        Mon, 19 Apr 2021 17:10:29 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH 085/117] qla2xxx: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:13 -0700
Message-Id: <20210420000845.25873-86-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c  | 148 ++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_iocb.c |   4 +-
 drivers/scsi/qla2xxx/qla_isr.c  |  14 +--
 drivers/scsi/qla2xxx/qla_mr.c   |   6 +-
 drivers/scsi/qla2xxx/qla_os.c   |  26 +++---
 5 files changed, 99 insertions(+), 99 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index d42b2ad84049..83a2f7c2aac1 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -27,8 +27,8 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
 
 	sp->free(sp);
 
-	bsg_reply->result = res;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = res;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 }
 
@@ -156,10 +156,10 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 			ha->fcp_prio_cfg->attributes &=
 				~FCP_PRIO_ATTR_ENABLE;
 			qla24xx_update_all_fcp_prio(vha);
-			bsg_reply->result = DID_OK;
+			bsg_reply->status.combined = DID_OK;
 		} else {
 			ret = -EINVAL;
-			bsg_reply->result = (DID_ERROR << 16);
+			bsg_reply->status.combined = (DID_ERROR << 16);
 			goto exit_fcp_prio_cfg;
 		}
 		break;
@@ -171,10 +171,10 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 				ha->fcp_prio_cfg->attributes |=
 				    FCP_PRIO_ATTR_ENABLE;
 				qla24xx_update_all_fcp_prio(vha);
-				bsg_reply->result = DID_OK;
+				bsg_reply->status.combined = DID_OK;
 			} else {
 				ret = -EINVAL;
-				bsg_reply->result = (DID_ERROR << 16);
+				bsg_reply->status.combined = (DID_ERROR << 16);
 				goto exit_fcp_prio_cfg;
 			}
 		}
@@ -184,11 +184,11 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 		len = bsg_job->reply_payload.payload_len;
 		if (!len || len > FCP_PRIO_CFG_SIZE) {
 			ret = -EINVAL;
-			bsg_reply->result = (DID_ERROR << 16);
+			bsg_reply->status.combined = (DID_ERROR << 16);
 			goto exit_fcp_prio_cfg;
 		}
 
-		bsg_reply->result = DID_OK;
+		bsg_reply->status.combined = DID_OK;
 		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(
 			bsg_job->reply_payload.sg_list,
@@ -200,7 +200,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 	case QLFC_FCP_PRIO_SET_CONFIG:
 		len = bsg_job->request_payload.payload_len;
 		if (!len || len > FCP_PRIO_CFG_SIZE) {
-			bsg_reply->result = (DID_ERROR << 16);
+			bsg_reply->status.combined = (DID_ERROR << 16);
 			ret = -EINVAL;
 			goto exit_fcp_prio_cfg;
 		}
@@ -211,7 +211,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 				ql_log(ql_log_warn, vha, 0x7050,
 				    "Unable to allocate memory for fcp prio "
 				    "config data (%x).\n", FCP_PRIO_CFG_SIZE);
-				bsg_reply->result = (DID_ERROR << 16);
+				bsg_reply->status.combined = (DID_ERROR << 16);
 				ret = -ENOMEM;
 				goto exit_fcp_prio_cfg;
 			}
@@ -225,7 +225,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 		/* validate fcp priority data */
 
 		if (!qla24xx_fcp_prio_cfg_valid(vha, ha->fcp_prio_cfg, 1)) {
-			bsg_reply->result = (DID_ERROR << 16);
+			bsg_reply->status.combined = (DID_ERROR << 16);
 			ret = -EINVAL;
 			/* If buffer was invalidatic int
 			 * fcp_prio_cfg is of no use
@@ -239,7 +239,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 		if (ha->fcp_prio_cfg->attributes & FCP_PRIO_ATTR_ENABLE)
 			ha->flags.fcp_prio_enabled = 1;
 		qla24xx_update_all_fcp_prio(vha);
-		bsg_reply->result = DID_OK;
+		bsg_reply->status.combined = DID_OK;
 		break;
 	default:
 		ret = -EINVAL;
@@ -247,7 +247,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 	}
 exit_fcp_prio_cfg:
 	if (!ret)
-		bsg_job_done(bsg_job, bsg_reply->result,
+		bsg_job_done(bsg_job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	return ret;
 }
@@ -917,12 +917,12 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 		    "Vendor request %s failed.\n", type);
 
 		rval = 0;
-		bsg_reply->result = (DID_ERROR << 16);
+		bsg_reply->status.combined = (DID_ERROR << 16);
 		bsg_reply->reply_payload_rcv_len = 0;
 	} else {
 		ql_dbg(ql_dbg_user, vha, 0x702d,
 		    "Vendor request %s completed.\n", type);
-		bsg_reply->result = (DID_OK << 16);
+		bsg_reply->status.combined = (DID_OK << 16);
 		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 			bsg_job->reply_payload.sg_cnt, rsp_data,
 			rsp_data_len);
@@ -951,7 +951,7 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 	    bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	if (!rval)
-		bsg_job_done(bsg_job, bsg_reply->result,
+		bsg_job_done(bsg_job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
@@ -984,8 +984,8 @@ qla84xx_reset(struct bsg_job *bsg_job)
 	} else {
 		ql_dbg(ql_dbg_user, vha, 0x7031,
 		    "Vendor request 84xx reset completed.\n");
-		bsg_reply->result = DID_OK;
-		bsg_job_done(bsg_job, bsg_reply->result,
+		bsg_reply->status.combined = DID_OK;
+		bsg_job_done(bsg_job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 
@@ -1084,7 +1084,7 @@ qla84xx_updatefw(struct bsg_job *bsg_job)
 		    "Vendor request 84xx updatefw completed.\n");
 
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-		bsg_reply->result = DID_OK;
+		bsg_reply->status.combined = DID_OK;
 	}
 
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
@@ -1097,7 +1097,7 @@ qla84xx_updatefw(struct bsg_job *bsg_job)
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 
 	if (!rval)
-		bsg_job_done(bsg_job, bsg_reply->result,
+		bsg_job_done(bsg_job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
@@ -1265,7 +1265,7 @@ qla84xx_mgmt_cmd(struct bsg_job *bsg_job)
 		    "Vendor request 84xx mgmt completed.\n");
 
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-		bsg_reply->result = DID_OK;
+		bsg_reply->status.combined = DID_OK;
 
 		if ((ql84_mgmt->mgmt.cmd == QLA84_MGMT_READ_MEM) ||
 			(ql84_mgmt->mgmt.cmd == QLA84_MGMT_GET_INFO)) {
@@ -1293,7 +1293,7 @@ qla84xx_mgmt_cmd(struct bsg_job *bsg_job)
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
 
 	if (!rval)
-		bsg_job_done(bsg_job, bsg_reply->result,
+		bsg_job_done(bsg_job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
@@ -1379,8 +1379,8 @@ qla24xx_iidma(struct bsg_job *bsg_job)
 				sizeof(struct qla_port_param));
 		}
 
-		bsg_reply->result = DID_OK;
-		bsg_job_done(bsg_job, bsg_reply->result,
+		bsg_reply->status.combined = DID_OK;
+		bsg_job_done(bsg_job, bsg_reply->status.combined,
 			       bsg_reply->reply_payload_rcv_len);
 	}
 
@@ -1484,12 +1484,12 @@ qla2x00_read_optrom(struct bsg_job *bsg_job)
 	    ha->optrom_region_size);
 
 	bsg_reply->reply_payload_rcv_len = ha->optrom_region_size;
-	bsg_reply->result = DID_OK;
+	bsg_reply->status.combined = DID_OK;
 	vfree(ha->optrom_buffer);
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
@@ -1521,16 +1521,16 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
 	    ha->optrom_region_start, ha->optrom_region_size);
 
 	if (rval) {
-		bsg_reply->result = -EINVAL;
+		bsg_reply->status.combined = -EINVAL;
 		rval = -EINVAL;
 	} else {
-		bsg_reply->result = DID_OK;
+		bsg_reply->status.combined = DID_OK;
 	}
 	vfree(ha->optrom_buffer);
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
@@ -1581,8 +1581,8 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
@@ -1632,8 +1632,8 @@ qla2x00_read_fru_status(struct bsg_job *bsg_job)
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = sizeof(*sr);
-	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
@@ -1679,8 +1679,8 @@ qla2x00_write_fru_status(struct bsg_job *bsg_job)
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
@@ -1725,8 +1725,8 @@ qla2x00_write_i2c(struct bsg_job *bsg_job)
 
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
@@ -1775,8 +1775,8 @@ qla2x00_read_i2c(struct bsg_job *bsg_job)
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = sizeof(*i2c);
-	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 
 	return 0;
@@ -1953,8 +1953,8 @@ qla24xx_process_bidir_cmd(struct bsg_job *bsg_job)
 	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = 0;
-	bsg_reply->result = (DID_OK) << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = (DID_OK) << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	/* Always return success, vendor rsp carries correct status */
 	return 0;
@@ -2119,8 +2119,8 @@ qla26xx_serdes_op(struct bsg_job *bsg_job)
 	    rval ? EXT_STATUS_MAILBOX : 0;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
@@ -2161,8 +2161,8 @@ qla8044_serdes_op(struct bsg_job *bsg_job)
 	    rval ? EXT_STATUS_MAILBOX : 0;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
@@ -2193,8 +2193,8 @@ qla27xx_get_flash_upd_cap(struct bsg_job *bsg_job)
 	    EXT_STATUS_OK;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
@@ -2239,8 +2239,8 @@ qla27xx_set_flash_upd_cap(struct bsg_job *bsg_job)
 	    EXT_STATUS_OK;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
@@ -2298,8 +2298,8 @@ qla27xx_get_bbcr_data(struct bsg_job *bsg_job)
 	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	return 0;
 }
@@ -2353,8 +2353,8 @@ qla2x00_get_priv_stats(struct bsg_job *bsg_job)
 	    rval ? EXT_STATUS_MAILBOX : EXT_STATUS_OK;
 
 	bsg_job->reply_len = sizeof(*bsg_reply);
-	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 
 	dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
@@ -2398,8 +2398,8 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	    rval ? EXT_STATUS_MAILBOX : EXT_STATUS_OK;
 
 	bsg_job->reply_len = sizeof(*bsg_reply);
-	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 
 	kfree(dd);
@@ -2438,10 +2438,10 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
 
 	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
 	bsg_reply->reply_payload_rcv_len = sizeof(regions);
-	bsg_reply->result = DID_OK << 16;
+	bsg_reply->status.combined = DID_OK << 16;
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
-	bsg_job_done(bsg_job, bsg_reply->result,
-	    bsg_reply->reply_payload_rcv_len);
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
+		     bsg_reply->reply_payload_rcv_len);
 
 	return 0;
 }
@@ -2508,8 +2508,8 @@ qla2x00_manage_host_stats(struct bsg_job *bsg_job)
 				    &rsp_data,
 				    sizeof(struct ql_vnd_mng_host_stats_resp));
 
-	bsg_reply->result = DID_OK;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 
 	return ret;
@@ -2577,8 +2577,8 @@ qla2x00_get_host_stats(struct bsg_job *bsg_job)
 					    bsg_job->reply_payload.sg_cnt, &rsp_data,
 					    sizeof(struct ql_vnd_mng_host_stats_resp));
 
-		bsg_reply->result = DID_OK;
-		bsg_job_done(bsg_job, bsg_reply->result,
+		bsg_reply->status.combined = DID_OK;
+		bsg_job_done(bsg_job, bsg_reply->status.combined,
 			     bsg_reply->reply_payload_rcv_len);
 		goto host_stat_out;
 	}
@@ -2598,8 +2598,8 @@ qla2x00_get_host_stats(struct bsg_job *bsg_job)
 	bsg_reply->reply_payload_rcv_len = sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 							       bsg_job->reply_payload.sg_cnt,
 							       data, response_len);
-	bsg_reply->result = DID_OK;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 
 	kfree(data);
@@ -2675,8 +2675,8 @@ qla2x00_get_tgt_stats(struct bsg_job *bsg_job)
 					    bsg_job->reply_payload.sg_cnt, data,
 					    sizeof(struct ql_vnd_tgt_stats_resp));
 
-		bsg_reply->result = DID_OK;
-		bsg_job_done(bsg_job, bsg_reply->result,
+		bsg_reply->status.combined = DID_OK;
+		bsg_job_done(bsg_job, bsg_reply->status.combined,
 			     bsg_reply->reply_payload_rcv_len);
 		goto tgt_stat_out;
 	}
@@ -2698,8 +2698,8 @@ qla2x00_get_tgt_stats(struct bsg_job *bsg_job)
 		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 				    bsg_job->reply_payload.sg_cnt, data,
 				    response_len);
-	bsg_reply->result = DID_OK;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 
 tgt_stat_out:
@@ -2760,8 +2760,8 @@ qla2x00_manage_host_port(struct bsg_job *bsg_job)
 		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 				    bsg_job->reply_payload.sg_cnt, &rsp_data,
 				    sizeof(struct ql_vnd_mng_host_port_resp));
-	bsg_reply->result = DID_OK;
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_reply->status.combined = DID_OK;
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 
 	return ret;
@@ -2888,7 +2888,7 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
 		goto skip_chip_chk;
 
 	if (vha->hw->flags.port_isolated) {
-		bsg_reply->result = DID_ERROR;
+		bsg_reply->status.combined = DID_ERROR;
 		/* operation not permitted */
 		return -EPERM;
 	}
@@ -2956,12 +2956,12 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 						ql_log(ql_log_warn, vha, 0x7089,
 						    "mbx abort_command "
 						    "failed.\n");
-						bsg_reply->result = -EIO;
+						bsg_reply->status.combined = -EIO;
 					} else {
 						ql_dbg(ql_dbg_user, vha, 0x708a,
 						    "mbx abort_command "
 						    "success.\n");
-						bsg_reply->result = 0;
+						bsg_reply->status.combined = 0;
 					}
 					spin_lock_irqsave(&ha->hardware_lock, flags);
 					goto done;
@@ -2971,7 +2971,7 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
-	bsg_reply->result = -ENXIO;
+	bsg_reply->status.combined = -ENXIO;
 	return 0;
 
 done:
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 38b5bdde2405..e194437e5b0b 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2123,13 +2123,13 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 
 	/* Check for host side state */
 	if (!qpair->online) {
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		return QLA_INTERFACE_ERROR;
 	}
 
 	if (!qpair->difdix_supported &&
 		scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		return QLA_INTERFACE_ERROR;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 67229af4c142..301390c603d4 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2578,7 +2578,7 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 
 	if (track_sense_len != 0) {
 		rsp->status_srb = sp;
-		cp->result = res;
+		cp->status.combined = res;
 	}
 
 	if (sense_len) {
@@ -2653,7 +2653,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 		    cmd->device->sector_size);
 
 		scsi_set_resid(cmd, resid);
-		cmd->result = DID_OK << 16;
+		cmd->status.combined = DID_OK << 16;
 
 		/* Update protection tag */
 		if (scsi_prot_sg_count(cmd)) {
@@ -2698,7 +2698,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 		    0x10, 0x1);
 		set_driver_byte(cmd, DRIVER_SENSE);
 		set_host_byte(cmd, DID_ABORT);
-		cmd->result |= SAM_STAT_CHECK_CONDITION;
+		cmd->status.combined |= SAM_STAT_CHECK_CONDITION;
 		return 1;
 	}
 
@@ -2708,7 +2708,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 		    0x10, 0x3);
 		set_driver_byte(cmd, DRIVER_SENSE);
 		set_host_byte(cmd, DID_ABORT);
-		cmd->result |= SAM_STAT_CHECK_CONDITION;
+		cmd->status.combined |= SAM_STAT_CHECK_CONDITION;
 		return 1;
 	}
 
@@ -2718,7 +2718,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 		    0x10, 0x2);
 		set_driver_byte(cmd, DRIVER_SENSE);
 		set_host_byte(cmd, DID_ABORT);
-		cmd->result |= SAM_STAT_CHECK_CONDITION;
+		cmd->status.combined |= SAM_STAT_CHECK_CONDITION;
 		return 1;
 	}
 
@@ -3216,7 +3216,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	case CS_DIF_ERROR:
 		logit = qla2x00_handle_dif_error(sp, sts24);
-		res = cp->result;
+		res = cp->status.combined;
 		break;
 
 	case CS_TRANSPORT:
@@ -3317,7 +3317,7 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 	/* Place command on done queue. */
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
-		sp->done(sp, cp->result);
+		sp->done(sp, cp->status.combined);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 6e920da64863..80ec24c5dcd0 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2154,7 +2154,7 @@ qlafx00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 	    sense_len, par_sense_len, track_sense_len);
 	if (GET_FW_SENSE_LEN(sp) > 0) {
 		rsp->status_srb = sp;
-		cp->result = res;
+		cp->status.combined = res;
 	}
 
 	if (sense_len) {
@@ -2255,7 +2255,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    sp->vha, 0x5074,
 		    fw_sts_ptr, sizeof(fstatus));
 
-		res = bsg_reply->result = DID_OK << 16;
+		res = bsg_reply->status.combined = DID_OK << 16;
 		bsg_reply->reply_payload_rcv_len =
 		    bsg_job->reply_payload.payload_len;
 	}
@@ -2612,7 +2612,7 @@ qlafx00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 	/* Place command on done queue. */
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
-		sp->done(sp, cp->result);
+		sp->done(sp, cp->status.combined);
 	} else {
 		WARN_ON_ONCE(true);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d74c32f84ef5..9a8129de0032 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -729,7 +729,7 @@ void qla2x00_sp_compl(srb_t *sp, int res)
 	struct completion *comp = sp->comp;
 
 	sp->free(sp);
-	cmd->result = res;
+	cmd->status.combined = res;
 	CMD_SP(cmd) = NULL;
 	cmd->scsi_done(cmd);
 	if (comp)
@@ -820,7 +820,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
 	struct completion *comp = sp->comp;
 
 	sp->free(sp);
-	cmd->result = res;
+	cmd->status.combined = res;
 	CMD_SP(cmd) = NULL;
 	cmd->scsi_done(cmd);
 	if (comp)
@@ -840,7 +840,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	if (unlikely(test_bit(UNLOADING, &base_vha->dpc_flags)) ||
 	    WARN_ON_ONCE(!rport)) {
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		goto qc24_fail_command;
 	}
 
@@ -862,18 +862,18 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 			ql_dbg(ql_dbg_aer, vha, 0x9010,
 			    "PCI Channel IO permanent failure, exiting "
 			    "cmd=%p.\n", cmd);
-			cmd->result = DID_NO_CONNECT << 16;
+			cmd->status.combined = DID_NO_CONNECT << 16;
 		} else {
 			ql_dbg(ql_dbg_aer, vha, 0x9011,
 			    "EEH_Busy, Requeuing the cmd=%p.\n", cmd);
-			cmd->result = DID_REQUEUE << 16;
+			cmd->status.combined = DID_REQUEUE << 16;
 		}
 		goto qc24_fail_command;
 	}
 
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
-		cmd->result = rval;
+		cmd->status.combined = rval;
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3003,
 		    "fc_remote_port_chkready failed for cmd=%p, rval=0x%x.\n",
 		    cmd, rval);
@@ -885,12 +885,12 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 			ql_dbg(ql_dbg_io, vha, 0x3004,
 			    "DIF Cap not reg, fail DIF capable cmd's:%p.\n",
 			    cmd);
-			cmd->result = DID_NO_CONNECT << 16;
+			cmd->status.combined = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
 	}
 
 	if (!fcport || fcport->deleted) {
-		cmd->result = DID_IMM_RETRY << 16;
+		cmd->status.combined = DID_IMM_RETRY << 16;
 		goto qc24_fail_command;
 	}
 
@@ -901,7 +901,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 			    "Returning DNC, fcport_state=%d loop_state=%d.\n",
 			    atomic_read(&fcport->state),
 			    atomic_read(&base_vha->loop_state));
-			cmd->result = DID_NO_CONNECT << 16;
+			cmd->status.combined = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
 		}
 		goto qc24_target_busy;
@@ -964,7 +964,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 
 	rval = rport ? fc_remote_port_chkready(rport) : (DID_NO_CONNECT << 16);
 	if (rval) {
-		cmd->result = rval;
+		cmd->status.combined = rval;
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3076,
 		    "fc_remote_port_chkready failed for cmd=%p, rval=0x%x.\n",
 		    cmd, rval);
@@ -974,12 +974,12 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 	if (!qpair->online) {
 		ql_dbg(ql_dbg_io, vha, 0x3077,
 		       "qpair not online. eeh_busy=%d.\n", ha->flags.eeh_busy);
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		goto qc24_fail_command;
 	}
 
 	if (!fcport || fcport->deleted) {
-		cmd->result = DID_IMM_RETRY << 16;
+		cmd->status.combined = DID_IMM_RETRY << 16;
 		goto qc24_fail_command;
 	}
 
@@ -990,7 +990,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 			    "Returning DNC, fcport_state=%d loop_state=%d.\n",
 			    atomic_read(&fcport->state),
 			    atomic_read(&base_vha->loop_state));
-			cmd->result = DID_NO_CONNECT << 16;
+			cmd->status.combined = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
 		}
 		goto qc24_target_busy;
