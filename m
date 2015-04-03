From: Jens Axboe <axboe@fb.com>
Subject: [PATCH 4/7] scsi: add scsi-mq helper for iterating over busy commands
Date: Fri, 3 Apr 2015 09:58:20 -0600
Message-ID: <1428076703-31014-5-git-send-email-axboe@fb.com>
References: <1428076703-31014-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46187 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753131AbbDCP6c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2015 11:58:32 -0400
In-Reply-To: <1428076703-31014-1-git-send-email-axboe@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, Jens Axboe <axboe@fb.com>

This is basically just a wrapper around blk_mq_queue_busy_iter(),
so that LLDs don't have to deal with or worry about blk-mq hardware
queues.

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 drivers/scsi/scsi_lib.c    | 25 +++++++++++++++++++++++++
 include/scsi/scsi_device.h |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 54d7a6cbb98a..87a4c53c8b48 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -648,6 +648,31 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 	}
 }
 
+struct scsi_mq_iter_data {
+	scsi_scmd_iter *fn;
+	void *priv;
+};
+
+static bool scsi_mq_iter_fn(struct blk_mq_hw_ctx *hctx, struct request *rq,
+			    void *priv, bool reserved)
+{
+	struct scsi_mq_iter_data *data = priv;
+	struct scsi_cmnd *scmd = rq->special;
+
+	return data->fn(scmd, data->priv);
+}
+
+void scsi_mq_scmd_busy_iter(struct scsi_device *sdev, scsi_scmd_iter *fn,
+			    void *priv)
+{
+	struct scsi_mq_iter_data data;
+
+	data.fn = fn;
+	data.priv = priv;
+	blk_mq_queue_busy_iter(sdev->request_queue, scsi_mq_iter_fn, &data);
+}
+EXPORT_SYMBOL(scsi_mq_scmd_busy_iter);
+
 /*
  * Function:    scsi_release_buffers()
  *
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a4c9336811d1..9250b03613f2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -536,4 +536,7 @@ static inline int scsi_device_tpgs(struct scsi_device *sdev)
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
 
+typedef bool (scsi_scmd_iter)(struct scsi_cmnd *, void *);
+void scsi_mq_scmd_busy_iter(struct scsi_device *sdev, scsi_scmd_iter *fn, void *priv);
+
 #endif /* _SCSI_SCSI_DEVICE_H */
-- 
1.9.1

