Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B652FB618
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 19:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853094; cv=none; b=lY0xovbvPeWPe1YK2LYp9I6ZhACdd6WnwUbbOYVDoMfYOtwayhVWlNV1CSG0EMQZVprQZpzo4VMmlPNXWuoQNobR8QTi4vlvWOFhItm7TreLEVGbUoE0U07cldbgeKJn8pD76NY+UB2dJ1UlhFVN5VkAFlkHrCEg0XoS1g6LkZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853094; c=relaxed/simple;
	bh=C27bwPIhDqefhqcuu3geFk/5noVFS7v7QREyQ5P0viU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajiP/FlLc2EU4b8eIznDPUtsK0i0KJt89AmK7jVWBkgKYoJ1/LelRWJsVyV5Vh6A++RHEEjWjYiWKKVr3IorUPCtV6p8Kw9mGMsbbwfm510W64Q0gQacIg0jt5wUQ+eRTkYKb3NfHzgFSiL59MNIsy+qEgP0PfIaotPG1QdOIrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=N5qrQgbK; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="N5qrQgbK"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cyDtC5d9qzlmm8N;
	Thu, 30 Oct 2025 19:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761853090; x=1764445091; bh=N3pB5
	EgdA0IymkPTyFi/7MIsQAxlZUzV5/kTprli3+I=; b=N5qrQgbKMXbiH9bIm3qyY
	x3jMf2orCVNwqDVvLrABBHpw7CxeYvBxY2TfFWddqBvctdKCHJM09gh9oBH1G9dx
	qTj5A/FrRBEQS8LNm8brRQxQoUkLFjRX229avW7x0tNurTDM5ISschoFjeU/hGn4
	66x3SWpPMZFkPsXBRqPfv43N9mtKHfrnpvG6LuOqX0PoBWAgH/gFCJ6trX28UPDV
	4Tidz9lqrpRAuPOX5SzC+i3FhO/6hWMKU8QCUs3sdfpHhMJtQMszhbTlLRMI/ZcY
	KSOwTLTvXP51Mbou1M8pbhmNjnV0GpdTOx8NQbu4HFicJhXt9vf+LocmCxkcD8MR
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dRO7U9CVz4RS; Thu, 30 Oct 2025 19:38:10 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cyDt555DHzlvX83;
	Thu, 30 Oct 2025 19:38:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v7 06/28] scsi: core: Add scsi_{get,put}_internal_cmd() helpers
Date: Thu, 30 Oct 2025 12:36:05 -0700
Message-ID: <20251030193720.871635-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251030193720.871635-1-bvanassche@acm.org>
References: <20251030193720.871635-1-bvanassche@acm.org>
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
