Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C60313533
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943279; cv=none; b=Nz/+AB2k+bAib3jIpqY6bKu2g7a3qFGotntXEgCEsbqZ8Tc8KrApJHTPd0K4tEA9caWZHD2Wjb+StWGNTgwNvpPhMueWho615Qm35RXsl2fySqimLUTuwX7uhBcyodIlfNuWOA4Q0C75xtqrLpW9APKw3oSx6ZAeG/QHq0GnVIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943279; c=relaxed/simple;
	bh=C27bwPIhDqefhqcuu3geFk/5noVFS7v7QREyQ5P0viU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aU8Yiz0eiSnIAAoOLTVLiIeN5LyaJmfNRuP+9HhjCPvBdjjVk2/NJjhAGtjAXMhDqI7Gw+Os7E0ZaERF7sxsRq53YHkfndkFA0iwIIaMjAK97YwtbUf0zU8NCWYeTQnskQpxm14GIuTF1Mebvx+E2yzcgR8qlZWoDGHrQSOQ7dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xMTmgkDl; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xMTmgkDl"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytDX6Zmczm0ySQ;
	Fri, 31 Oct 2025 20:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943275; x=1764535276; bh=N3pB5
	EgdA0IymkPTyFi/7MIsQAxlZUzV5/kTprli3+I=; b=xMTmgkDl1f8QD6B94Y6RR
	+lJ6xfTk/ghfcxeCS2PaIRLbmcOX3ATjZy7qnhxoAlJ1a+rnhC2KT8++Z07JJBM7
	n6HSUxxkaG85C4KNIgwsoZukAPbxq3jpe5FJNhyK6p7Uy6WzZmgZ3+4Sgr3HXW1V
	tZVUe9YsHiyQ4bdy2ataTgvQhhH2QSn8DyzptnF3rA/DoqGinxTiwsZr/5UN8l8h
	rNOoikm4UdP+nlgNH+YLqCli1ydSVTrdvuKKY2V7II/loAUqr8aKQU/eY0UWXxhy
	vHxvy61X42z68E2ns0ArD5Vcot/z0E6zunBKGsiCD2w4lHDUC1qfNHyrig+oTDY8
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TryEds14fiU3; Fri, 31 Oct 2025 20:41:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytDR4xTkzm0pKv;
	Fri, 31 Oct 2025 20:41:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v8 06/28] scsi: core: Add scsi_{get,put}_internal_cmd() helpers
Date: Fri, 31 Oct 2025 13:39:14 -0700
Message-ID: <20251031204029.2883185-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Hannes Reinecke <hare@suse.de>

Add helper functions to allow LLDDs to allocate and free internal command=
s.

Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
[ bvanassche: changed the 'nowait' argument into a 'flags' argument. See =
also
  https://lore.kernel.org/linux-scsi/20211125151048.103910-3-hare@suse.de=
/ ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 38 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  4 ++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d4e874bbf2ea..51ad2ad07e43 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2134,6 +2134,44 @@ void scsi_mq_free_tags(struct kref *kref)
 	complete(&shost->tagset_freed);
 }
=20
+/**
+ * scsi_get_internal_cmd() - Allocate an internal SCSI command.
+ * @sdev: SCSI device from which to allocate the command
+ * @data_direction: Data direction for the allocated command
+ * @flags: request allocation flags, e.g. BLK_MQ_REQ_RESERVED or
+ *	BLK_MQ_REQ_NOWAIT.
+ *
+ * Allocates a SCSI command for internal LLDD use.
+ */
+struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
+					enum dma_data_direction data_direction,
+					blk_mq_req_flags_t flags)
+{
+	enum req_op op =3D data_direction =3D=3D DMA_TO_DEVICE ? REQ_OP_DRV_OUT=
 :
+							   REQ_OP_DRV_IN;
+	struct scsi_cmnd *scmd;
+	struct request *rq;
+
+	rq =3D scsi_alloc_request(sdev->request_queue, op, flags);
+	if (IS_ERR(rq))
+		return NULL;
+	scmd =3D blk_mq_rq_to_pdu(rq);
+	scmd->device =3D sdev;
+
+	return scmd;
+}
+EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
+
+/**
+ * scsi_put_internal_cmd() - Free an internal SCSI command.
+ * @scmd: SCSI command to be freed
+ */
+void scsi_put_internal_cmd(struct scsi_cmnd *scmd)
+{
+	blk_mq_free_request(blk_mq_rq_from_pdu(scmd));
+}
+EXPORT_SYMBOL_GPL(scsi_put_internal_cmd);
+
 /**
  * scsi_device_from_queue - return sdev associated with a request_queue
  * @q: The request queue to return the sdev from
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 918631088711..1e2e599517e9 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -558,6 +558,10 @@ int scsi_execute_cmd(struct scsi_device *sdev, const=
 unsigned char *cmd,
 		     const struct scsi_exec_args *args);
 void scsi_failures_reset_retries(struct scsi_failures *failures);
=20
+struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
+					enum dma_data_direction data_direction,
+					blk_mq_req_flags_t flags);
+void scsi_put_internal_cmd(struct scsi_cmnd *scmd);
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
