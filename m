From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] SCSI: fix scsi_kill_request() busy count handling
Date: Tue, 11 Apr 2006 17:27:53 +0900
Message-ID: <20060411082753.GA387@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pproxy.gmail.com ([64.233.166.182]:4071 "EHLO pproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932362AbWDKI2C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 04:28:02 -0400
Received: by pproxy.gmail.com with SMTP id i49so1317920pye
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2006 01:28:01 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

scsi_kill_request() completes requests via normal SCSI completion path
which decrements busy counts; however, requests which get passed to
scsi_kill_request() aren't holding busy counts and scsi_kill_request()
don't increment them before invoking completion path resulting in
incorrect busy counts.  Bump up busy counts before invoking completion
path.

Signed-off-by: Tejun Heo <htejun@gmail.com>

---

 drivers/scsi/scsi_lib.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

a12bf362489393691d147f93fbe1aa5d5a3a513d
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8f010a3..7b0f9a3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1479,6 +1479,8 @@ static inline int scsi_host_queue_ready(
 static void scsi_kill_request(struct request *req, request_queue_t *q)
 {
 	struct scsi_cmnd *cmd = req->special;
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *shost = sdev->host;
 
 	blkdev_dequeue_request(req);
 
@@ -1491,6 +1493,19 @@ static void scsi_kill_request(struct req
 	scsi_init_cmd_errh(cmd);
 	cmd->result = DID_NO_CONNECT << 16;
 	atomic_inc(&cmd->device->iorequest_cnt);
+
+	/*
+	 * SCSI request completion path will do scsi_device_unbusy(),
+	 * bump busy counts.  To bump the counters, we need to dance
+	 * with the locks as normal issue path does.
+	 */
+	sdev->device_busy++;
+	spin_unlock(sdev->request_queue->queue_lock);
+	spin_lock(shost->host_lock);
+	shost->host_busy++;
+	spin_unlock(shost->host_lock);
+	spin_lock(sdev->request_queue->queue_lock);
+
 	__scsi_done(cmd);
 }
 
-- 
1.2.4

