Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF403CAA5F
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 14:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805248; cv=none; b=hUG4wfVF1dcb9AadHXRTH4G5RWeH/DtsLKVpFZYl1gJe6WBJAT1QZJ6GdZ7hLj/xCkXjzatgTfL/L0ZPlf186tTaDpTZGJlWoptRg/Hr1fLlroCF7OJQPtxU26e9wJATT1UHEk974fmgzlt10Rdzr0Z+isysYFWLVMBDt85zqBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805248; c=relaxed/simple;
	bh=CybVNsiEnHskzI9STi/kobF3HCpPfYFWQg0zLD98WXU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GzKNyBP5RgsNw4xDYeGHIZSLjMZl0kiPGU3YfYu3F9bKnatAQrjj9oARYdVzkboh2n/1c330G9t2GrUXTpx2ffQF9New45AwLMefpMyXcqxkN/Gcp872z8fQqxRwBwUVgXFek4zZCQNveWUN6yUFNbWXv4/XSgTX//Z5+MjpyDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dg0siUqC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dg0siUqC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779805245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=j+IiqDBrGPMMITWFKRVN/DNqCjtmUObz6NDovf/ZTWo=;
	b=dg0siUqC/r+2Jv39GP3xfWfm+yJWEWhCWOhr4QCPp5iIipNN/Vs4g+ObWNGjWGndXBnSrl
	ss57UVQwDk512fYqHeU4gM3ViMK2w48NU5KNIbvgU53t8BobZ/QsAdX2LlAPJnJd3QMneJ
	3Vyv/9ZwL4D8uZKqxEXJD/QBKDvVn4o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-147-lvHeRDwbNHiVJDLwnjHREw-1; Tue,
 26 May 2026 10:20:42 -0400
X-MC-Unique: lvHeRDwbNHiVJDLwnjHREw-1
X-Mimecast-MFC-AGG-ID: lvHeRDwbNHiVJDLwnjHREw_1779805241
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D6E61184544E;
	Tue, 26 May 2026 14:19:42 +0000 (UTC)
Received: from nprabudo-thinkpadp16vgen1.rmtin.csb (unknown [10.74.80.96])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 69FA018004A3;
	Tue, 26 May 2026 14:19:39 +0000 (UTC)
From: Nimal Prabudoss I <nprabudo@redhat.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com,
	nilesh.javali@marvell.com,
	Nimal Prabudoss I <nprabudo@redhat.com>
Subject: [PATCH] scsi: qedf: use GFP_ATOMIC to prevent vmalloc allocation panic
Date: Tue, 26 May 2026 10:19:32 -0400
Message-ID: <20260526141932.18372-1-nprabudo@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The qedf driver encounters an exc_invalid_op crash in get_vm_area_node
when running under intensive I/O stress with IOMMU enabled.

Link: https://issues.redhat.com/browse/RHEL-75146
Signed-off-by: Nimal Prabudoss I <nprabudo@redhat.com>
---
 drivers/scsi/qedf/qedf_io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index a120f0e37a64..6883aaf683bd 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2059,7 +2059,7 @@ int qedf_init_mp_req(struct qedf_ioreq *io_req)
 		mp_req->req_len = io_req->data_xfer_len;
 
 	mp_req->req_buf = dma_alloc_coherent(&qedf->pdev->dev, QEDF_PAGE_SIZE,
-	    &mp_req->req_buf_dma, GFP_KERNEL);
+	    &mp_req->req_buf_dma, GFP_ATOMIC);
 	if (!mp_req->req_buf) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Unable to alloc MP req buffer\n");
 		qedf_free_mp_resc(io_req);
@@ -2067,7 +2067,7 @@ int qedf_init_mp_req(struct qedf_ioreq *io_req)
 	}
 
 	mp_req->resp_buf = dma_alloc_coherent(&qedf->pdev->dev,
-	    QEDF_PAGE_SIZE, &mp_req->resp_buf_dma, GFP_KERNEL);
+	    QEDF_PAGE_SIZE, &mp_req->resp_buf_dma, GFP_ATOMIC);
 	if (!mp_req->resp_buf) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Unable to alloc TM resp "
 			  "buffer\n");
@@ -2078,7 +2078,7 @@ int qedf_init_mp_req(struct qedf_ioreq *io_req)
 	/* Allocate and map mp_req_bd and mp_resp_bd */
 	sz = sizeof(struct scsi_sge);
 	mp_req->mp_req_bd = dma_alloc_coherent(&qedf->pdev->dev, sz,
-	    &mp_req->mp_req_bd_dma, GFP_KERNEL);
+	    &mp_req->mp_req_bd_dma, GFP_ATOMIC);
 	if (!mp_req->mp_req_bd) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Unable to alloc MP req bd\n");
 		qedf_free_mp_resc(io_req);
@@ -2086,7 +2086,7 @@ int qedf_init_mp_req(struct qedf_ioreq *io_req)
 	}
 
 	mp_req->mp_resp_bd = dma_alloc_coherent(&qedf->pdev->dev, sz,
-	    &mp_req->mp_resp_bd_dma, GFP_KERNEL);
+	    &mp_req->mp_resp_bd_dma, GFP_ATOMIC);
 	if (!mp_req->mp_resp_bd) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Unable to alloc MP resp bd\n");
 		qedf_free_mp_resc(io_req);
-- 
2.54.0

