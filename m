Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192D7204C1C
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 19:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741115964; cv=none; b=rsXTkl0wxCu7C06tGYUWVluNNIGsCw2oWB4l1+k4D4Xdls4bXe8gydyYRasFxaBftPvpjaa5nt3X37Qnzz06LGTslRBdxVQmdiN2/bYBWtIAFQWuldOsxlV6su4Jie6ODx3s3kx1iVUPOhgsB6jWocyhSmSCQxIkDnDoozIT+Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741115964; c=relaxed/simple;
	bh=+Lr+DBpeFTgtRhOXj4LMQK0RYAaHp8DzaCbqZWsU7rc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xa8Gfz/XQq2HVAoep2zHIxpDNvV4YAYY6suksAl0pimZXnUcURWrckg90kAxV69OlMxy2EcWpXTvA4H4l1tXnMPHrAWmMVFiqaBWhmC2khbdgymtwalqdAdoLVZMu1GgGcSYatRXIcR5gbTwqHQARuNMdQfueoJJ3KRxIz4nr4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=NsnOzV+E; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NsnOzV+E"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-223785beedfso75361485ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 04 Mar 2025 11:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1741115961; x=1741720761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AfjA/5JgtVEliE7vmPsiUSKsXlh7APEUgV8FCvBuyY4=;
        b=NsnOzV+ECvAFIBel688q4eFp2TrpQHstblgdQRMFcaQwH2ksTpE6+0IQznHDtewtJS
         /dV2wpLvup+D0qNsXUGSHwjNhaX25ZZ6ImUx/bFuqeNwONNpLALiOIFfceYvs+SIY7PI
         AuEet0Hkt3oahzxdOG4DGlNbDq1hlEOX8YWTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741115961; x=1741720761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AfjA/5JgtVEliE7vmPsiUSKsXlh7APEUgV8FCvBuyY4=;
        b=Zhz5Kvn82/LZsTNpUuEVDoOBWkOwETKRfY9WJQ3BfgtXZYlvkXyVO/vJVE69RaZdq5
         gInmwbsAMxLfGZ5rqEfi/ieCulydNlQKcAWv7EpyrjqyxCopKRV8dzCIXT59aoP88Vva
         zabncYdg6Aq4+1wM7OE2cr3HxGpHYnDxO/FlOqkQ7VYTS13JvU8060HrBgzLpVs3xVjK
         j2T7YFkIh87KrIJogEtXnuqW7mRT8lAJeTLc5IVUrG5ccslEY/aFs2K6AEYx+aVciffT
         RdSRg/Fn0MBODtSweShZV7JjYyyEqk7R6iJwlmQeYwMtR4U62CoGHXdXYOVwabsMIqtx
         VxNQ==
X-Gm-Message-State: AOJu0YynDaNHm7rgpO2WJb/X9m17mA07jEEuieR7V1oo3tbb/cRDOuwq
	StGN+zZjw+/3RZA7QZInQBNsVh4fyZWP6RgK17tlAKqv3O88D5kfNBMK+61BQVq6igUOXAwDVkB
	6RUGIwF4YVD6s4a8kTKTVhi9XJEwE2ocyhknk4ReUX+sRU0Y6VngiSFmnTtPw4rbYSfcKNqC1nR
	rszxEADppIAorW7v1z6D7qci3raXTrGQ94la8fDt6E/3V4ww==
X-Gm-Gg: ASbGncuq73LcmXEwYqyfNZRm+E0N49iaHfaqNcERiXXZAtwy5MHgUPjx8f49qLvrkrE
	rKIsKJ+qun86I97dIFqI0qu+sD+lvyzimBQR/ke0eaSLIx6IRHUeXZoR3DPSJYGGg0l3BOc9S3K
	T2TMe4M3URmnSuiP9N63lFRC/a2tbgsBhU0XVbv1zuTc3dn0MsidqNamhzOCoEkE1UAxwaJnWMy
	rP9z/eWyCl//WFIFVbKg6HLH3sTMRbUuOn3pHxUvT0payiWn1I/IYqraxkhbZ++i/V6iT+eOUo/
	tI7Y4p7b4WrIuFUy/TB5zpqHBYk9tTRzinCqkbcXwE417a9uPa8soJhHyTMSNRUjl3KbgJQaeim
	GJUM0o4KUZr7DXFrBrgTO
X-Google-Smtp-Source: AGHT+IGTzVH8+64zfI7jq0vy/s75Lu8cGf3ipESLdyX7rLTPUdyOsp6/svvLEZn61LSci81lJL2Mxg==
X-Received: by 2002:a17:902:f54e:b0:215:b058:289c with SMTP id d9443c01a7336-223f1c7cf16mr4004745ad.8.1741115961180;
        Tue, 04 Mar 2025 11:19:21 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7365e74d7a3sm3799259b3a.126.2025.03.04.11.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 11:19:20 -0800 (PST)
From: Chandrakanth Patil <ranjan.kumar@broadcom.com>
X-Google-Original-From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com,
	rajsekhar.chundru@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH V2] mpi3mr: Task Abort EH Support
Date: Wed,  5 Mar 2025 00:44:53 +0530
Message-Id: <20250304191453.12994-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Task Abort support is added to handle SCSI command timeouts, ensuring
recovery and cleanup of timed-out commands. This completes the error
handling framework for mpi3mr driver, which already includes device
reset, target reset, bus reset, and host reset.

V2:

- Improved error/debug messages for better readability.
- Updated function header to clarify abort handler callback.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 99 +++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e3547ea42613..c186b892150f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3839,6 +3839,18 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
 
 	if (scmd) {
+		if (tm_type == MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
+			cmd_priv = scsi_cmd_priv(scmd);
+			if (!cmd_priv)
+				goto out_unlock;
+
+			struct op_req_qinfo *op_req_q;
+
+			op_req_q = &mrioc->req_qinfo[cmd_priv->req_q_idx];
+			tm_req.task_host_tag = cpu_to_le16(cmd_priv->host_tag);
+			tm_req.task_request_queue_id =
+				cpu_to_le16(op_req_q->qid);
+		}
 		sdev = scmd->device;
 		sdev_priv_data = sdev->hostdata;
 		scsi_tgt_priv_data = ((sdev_priv_data) ?
@@ -4387,6 +4399,92 @@ static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
 	return retval;
 }
 
+/**
+ * mpi3mr_eh_abort - Callback function for abort error handling
+ * @scmd: SCSI command reference
+ *
+ * Issues Abort Task Management if the command is in LLD scope
+ * and verifies if it is aborted successfully, and return status
+ * accordingly.
+ *
+ * Return: SUCCESS if the abort was successful, otherwise FAILED
+ */
+static int mpi3mr_eh_abort(struct scsi_cmnd *scmd)
+{
+	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
+	struct mpi3mr_stgt_priv_data *stgt_priv_data;
+	struct mpi3mr_sdev_priv_data *sdev_priv_data;
+	struct scmd_priv *cmd_priv;
+	u16 dev_handle, timeout = MPI3MR_ABORTTM_TIMEOUT;
+	u8 resp_code = 0;
+	int retval = FAILED, ret = 0;
+	struct request *rq = scsi_cmd_to_rq(scmd);
+	unsigned long scmd_age_ms = jiffies_to_msecs(jiffies - scmd->jiffies_at_alloc);
+	unsigned long scmd_age_sec = scmd_age_ms / HZ;
+
+	sdev_printk(KERN_INFO, scmd->device,
+		    "%s: attempting abort task for scmd(%p)\n", mrioc->name, scmd);
+
+	sdev_printk(KERN_INFO, scmd->device,
+		    "%s: scmd(0x%p) is outstanding for %lus %lums, timeout %us, retries %d, allowed %d\n",
+		    mrioc->name, scmd, scmd_age_sec, scmd_age_ms % HZ, rq->timeout / HZ,
+		    scmd->retries, scmd->allowed);
+
+	scsi_print_command(scmd);
+
+	sdev_priv_data = scmd->device->hostdata;
+	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
+		sdev_printk(KERN_INFO, scmd->device,
+			    "%s: Device not available, Skip issuing abort task\n",
+			    mrioc->name);
+		retval = SUCCESS;
+		goto out;
+	}
+
+	stgt_priv_data = sdev_priv_data->tgt_priv_data;
+	dev_handle = stgt_priv_data->dev_handle;
+
+	cmd_priv = scsi_cmd_priv(scmd);
+	if (!cmd_priv->in_lld_scope ||
+	    cmd_priv->host_tag == MPI3MR_HOSTTAG_INVALID) {
+		sdev_printk(KERN_INFO, scmd->device,
+			    "%s: scmd (0x%p) not in LLD scope, Skip issuing Abort Task\n",
+			    mrioc->name, scmd);
+		retval = SUCCESS;
+		goto out;
+	}
+
+	if (stgt_priv_data->dev_removed) {
+		sdev_printk(KERN_INFO, scmd->device,
+			    "%s: Device (handle = 0x%04x) removed, Skip issuing Abort Task\n",
+			    mrioc->name, dev_handle);
+		retval = FAILED;
+		goto out;
+	}
+
+	ret = mpi3mr_issue_tm(mrioc, MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
+			      dev_handle, sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
+			      timeout, &mrioc->host_tm_cmds, &resp_code, scmd);
+
+	if (ret)
+		goto out;
+
+	if (cmd_priv->in_lld_scope) {
+		sdev_printk(KERN_INFO, scmd->device,
+			    "%s: Abort task failed. scmd (0x%p) was not terminated\n",
+			    mrioc->name, scmd);
+		goto out;
+	}
+
+	retval = SUCCESS;
+out:
+	sdev_printk(KERN_INFO, scmd->device,
+		    "%s: Abort Task %s for scmd (0x%p)\n", mrioc->name,
+		    ((retval == SUCCESS) ? "SUCCEEDED" : "FAILED"), scmd);
+
+	return retval;
+}
+
 /**
  * mpi3mr_scan_start - Scan start callback handler
  * @shost: SCSI host reference
@@ -5069,6 +5167,7 @@ static const struct scsi_host_template mpi3mr_driver_template = {
 	.scan_finished			= mpi3mr_scan_finished,
 	.scan_start			= mpi3mr_scan_start,
 	.change_queue_depth		= mpi3mr_change_queue_depth,
+	.eh_abort_handler		= mpi3mr_eh_abort,
 	.eh_device_reset_handler	= mpi3mr_eh_dev_reset,
 	.eh_target_reset_handler	= mpi3mr_eh_target_reset,
 	.eh_bus_reset_handler		= mpi3mr_eh_bus_reset,
-- 
2.31.1

