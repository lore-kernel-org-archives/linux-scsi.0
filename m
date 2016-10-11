From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 15/44] qla2xxx: Use fc_bsg_jobdone()
Date: Tue, 11 Oct 2016 13:28:46 +0200
Message-ID: <912f11da5afacd90f97c36a589e36ae4f1534173.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Use fc_bsg_jobdone() directly instead of the struct bsg_job::job_done()
callback.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 44 +++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 40f7c10..1bca77b 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -20,7 +20,7 @@ qla2x00_bsg_job_done(void *data, void *ptr, int res)
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 
 	bsg_reply->result = res;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	sp->free(vha, sp);
 }
 
@@ -242,7 +242,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 	}
 exit_fcp_prio_cfg:
 	if (!ret)
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job);
 	return ret;
 }
 
@@ -939,7 +939,7 @@ done_unmap_req_sg:
 	    bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	if (!rval)
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job);
 	return rval;
 }
 
@@ -972,7 +972,7 @@ qla84xx_reset(struct fc_bsg_job *bsg_job)
 		ql_dbg(ql_dbg_user, vha, 0x7031,
 		    "Vendor request 84xx reset completed.\n");
 		bsg_reply->result = DID_OK;
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job);
 	}
 
 	return rval;
@@ -1085,7 +1085,7 @@ done_unmap_sg:
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 
 	if (!rval)
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job);
 	return rval;
 }
 
@@ -1282,7 +1282,7 @@ exit_mgmt:
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
 
 	if (!rval)
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job);
 	return rval;
 }
 
@@ -1368,7 +1368,7 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 		}
 
 		bsg_reply->result = DID_OK;
-		bsg_job->job_done(bsg_job);
+		fc_bsg_jobdone(bsg_job);
 	}
 
 	return rval;
@@ -1476,7 +1476,7 @@ qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return rval;
 }
 
@@ -1511,7 +1511,7 @@ qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return rval;
 }
 
@@ -1561,7 +1561,7 @@ dealloc:
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	return 0;
 }
@@ -1610,7 +1610,7 @@ done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = sizeof(*sr);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	return 0;
 }
@@ -1655,7 +1655,7 @@ dealloc:
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	return 0;
 }
@@ -1699,7 +1699,7 @@ dealloc:
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	return 0;
 }
@@ -1747,7 +1747,7 @@ done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = sizeof(*i2c);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	return 0;
 }
@@ -1925,7 +1925,7 @@ done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->reply_payload_rcv_len = 0;
 	bsg_reply->result = (DID_OK) << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	/* Always return success, vendor rsp carries correct status */
 	return 0;
 }
@@ -2090,7 +2090,7 @@ qla26xx_serdes_op(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return 0;
 }
 
@@ -2131,7 +2131,7 @@ qla8044_serdes_op(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return 0;
 }
 
@@ -2162,7 +2162,7 @@ qla27xx_get_flash_upd_cap(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return 0;
 }
 
@@ -2207,7 +2207,7 @@ qla27xx_set_flash_upd_cap(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return 0;
 }
 
@@ -2265,7 +2265,7 @@ done:
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 	return 0;
 }
 
@@ -2321,7 +2321,7 @@ qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(*bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
 		stats, stats_dma);
@@ -2364,7 +2364,7 @@ qla2x00_do_dport_diagnostics(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(*bsg_reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job->job_done(bsg_job);
+	fc_bsg_jobdone(bsg_job);
 
 	kfree(dd);
 
-- 
1.8.5.6
