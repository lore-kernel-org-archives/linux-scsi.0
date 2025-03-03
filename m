Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA501F1300
	for <linux-scsi@vger.kernel.org>; Mon,  3 Mar 2025 09:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740995086; cv=none; b=nyrlRkxlu/u+onaeWO9TZEJr0gV0CZc4ZWpY7y60IfjVdmrg3yebwtwmLSBuGIiRfnviR5BP7jTN9UKFG89qe5nQ1nAl0D3t8Cvu39whrPaB9jDxZNGZzxV6rBnoAYgvQhBz9AG0G0D6RpbGsyypIzjW02vyYZ4kdDdbNoiwLrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740995086; c=relaxed/simple;
	bh=HMxKvIVKMDs1Mj6lqvfjloEmMnlqM6yrqCvqXhpgj6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IlU1zLbJkZIBxdsmrOi3Cg0l/gLcwSnGxtycY4wo4gW61LGxj+aZCO/2HSzhWvBcRPC08Y+3bHTUL3llYtcAEzY5xsMJCw9X/0aPxWt39e215ajzsIqW96RsHYePF7Dqjnkl0ZNeUPjmwc2lTsvnk4HSwo4zxkQv5Z7nX3/DO4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hTYIOaul; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hTYIOaul"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2239c066347so19375505ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2025 01:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1740995084; x=1741599884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S81KDVB6veIZK+7vdcbMEObwbr2ytGt/Wvn0xr/h2VU=;
        b=hTYIOaulE2uBPlELgAruFKjX3RNSPxej/FSg6vr7kr3+C+2skMTxZZ7teg7wHl9brk
         OZDPJslLV3CxhzPenFY97aqs06/Cnn0GinOt5Tv//ljJExPliAjlBVU56gdn2mW8iLBe
         JhOG4p4i8tYJ03qSvRgzCVCjP8ZXdJRD6rfww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740995084; x=1741599884;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S81KDVB6veIZK+7vdcbMEObwbr2ytGt/Wvn0xr/h2VU=;
        b=As5+gorxatTacTw2xwql7nes0KaNwbj3tGFjXQLTU0cgHl9xnicVuuc/qRsj9GHZD/
         /kt/ZK9i1enULjvdlBFj2lJHg0V6E7nSYnLA5KvMvY3R1YzpiikKYdM+7uq9mbCTbiBm
         fS27U8PkJSXrROomTkVSS0evOrmahF7RfXEfqBpj+Q5EirlBhh/MwvGG9vF722L+X7oT
         AedZ97IJqadS50LMQsrooM4EkLB/c7msb/nt5vdmznAGUZxKWh/prnMFK/cgYuP+SxTI
         sFbMVCybFxz0KClTCkp5vVmZq0jrWawaBVd6hu7dSde9vs8zMDcRYwK0s1Cw+y6Ql0ci
         92Ww==
X-Gm-Message-State: AOJu0YwymryEX4S+FLAiSHbFWcTDxZ9tnMHmDygFUs+g8+XAQLC0qPl6
	+r8hjwRPwgrvsS8R+muzmTGXbYmppaBfCmH59rO5CBBFYPlXM5hUoR9a5ceBcfyU66juM0yvbW9
	GOgv+9dOioTGjsOekvopz+6oFqCjx8bRG9E4pPL/vpfdPE81Ad7hjRbue7w15OdA0IYvZN7cwg/
	EC3RnYYLBAqDp4IkzwOup1ITrfiG87Q1/sUkfn/ytRfu81hw==
X-Gm-Gg: ASbGncuCiqrnxvLPv7soswhUKbgTcwflqL4dtptICItfGcRM2pThhjmfbO7ruOzgxXP
	QxRQi39habAoGod+UP6l2Lsv5eRAZpa3rD3PPPv9H65YD+C00UW+L3p8SU+acWxOrZIYmW0f4v3
	7k+ROQw44iXulUEfEXhTRorF2lHHMz1SjcU0APQ3ZLP2QY4oKGUCBSzezFr2Xq+YrhNEg4O4yFG
	Ied0v8L2XRtVBBEoNGcltzfq3BD+Pb90AFCsKnFXj01C358O2NZ9r2Du3STW0d1UDER2E2KiAa3
	WnSH0nFm/aj/TrumkRGFz3+XU5Qpu2nHLLyB5Z0m8Rtd2iKzpYYVJtGNOezmCOxmWR2d3vwcC31
	+btbtiZ9iR26L4dREsAhC
X-Google-Smtp-Source: AGHT+IFv6zC2Em/BkvianPFDI9SVs8q1lGNmNfvu9IRE/aFQaWNNSt4ka2Ko80sn3rVpZeJECDV40g==
X-Received: by 2002:a05:6a20:918e:b0:1ee:d9bc:4b7 with SMTP id adf61e73a8af0-1f2f4d125b9mr20390808637.21.1740995083833;
        Mon, 03 Mar 2025 01:44:43 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af0fc1dab93sm5323282a12.60.2025.03.03.01.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 01:44:43 -0800 (PST)
From: Chandrakanth Patil <ranjan.kumar@broadcom.com>
X-Google-Original-From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com,
	rajsekhar.chundru@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 1/2] mpi3mr: Task Abort EH Support
Date: Mon,  3 Mar 2025 15:10:03 +0530
Message-Id: <20250303094004.93770-1-chandrakanth.patil@broadcom.com>
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

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 99 +++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e3547ea42613..6a8f3d3a5668 100644
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
+ * mpi3mr_eh_abort- Abort error handling callback
+ * @scmd: SCSI command reference
+ *
+ * Issue Abort Task Management if the command is in LLD scope
+ * and verify if it is aborted successfully and return status
+ * accordingly.
+ *
+ * Return: SUCCESS of successful abort the scmd else FAILED
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
+			    "%s: device is not available, abort task is not issued\n",
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
+			    "%s: scmd is not in LLD scope, abort task is not issued\n",
+			    mrioc->name);
+		retval = SUCCESS;
+		goto out;
+	}
+
+	if (stgt_priv_data->dev_removed) {
+		sdev_printk(KERN_INFO, scmd->device,
+			    "%s: device(handle = 0x%04x) is removed, abort task is not issued\n",
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
+			    "%s: scmd was not terminated, abort task is failed\n",
+			    mrioc->name);
+		goto out;
+	}
+
+	retval = SUCCESS;
+out:
+	sdev_printk(KERN_INFO, scmd->device,
+		    "%s: abort task is %s for scmd(%p)\n", mrioc->name,
+		    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
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

