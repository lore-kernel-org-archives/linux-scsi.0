Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276A732C923
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 06:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779949685; cv=none; b=C/keRKraqO12o4Xf3ZfnRGmRcFzCElFe2denwTE8PLCLceMX+OzhUedpsAB0wQdp10HOIk4jba9+B2+Oj5PoZmpf+RhWug4e+M/l4bZB7syAXlQvIkRhpezeNDUQPJotzm/jkLHmhs24NPDASfDuwLSUo8VNb8U4TfhLbXk9YLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779949685; c=relaxed/simple;
	bh=CybVNsiEnHskzI9STi/kobF3HCpPfYFWQg0zLD98WXU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TCshMHyHnvoTpOkVN2LZl3AhyV18mSfGOv0lp3XgWjq4Fu/TPQby0sBddBUAYW3wrStuaZD14kiJPhj2GN1lEWAAV2oRxHBU18SpQ9m1Q1rowkRsr6rOzUl06hG42foTxPeNwrdoNlHtzI3JjDiXmmUQykU3Qn6SMnsdkc+nE2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GEo9hWwJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GEo9hWwJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779949681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=j+IiqDBrGPMMITWFKRVN/DNqCjtmUObz6NDovf/ZTWo=;
	b=GEo9hWwJ14yF1ed7vcCGRjfrjZEVL9OrL+Q6Pe4mt37KMDwWBqU2cvhWS+Z+cBFoyPgyIK
	tNAeq+tiZd6UNp+DCK8OrZlfujqUdNcFCygekb7Nt/8By7BM/uH6O/W70Q426vRO8V1iIM
	lfNq9HLsZ8eLyFQbm5uueXn0oFRxJJI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-IQblN7t3M-Cy4-WkSKNm8Q-1; Thu,
 28 May 2026 02:27:57 -0400
X-MC-Unique: IQblN7t3M-Cy4-WkSKNm8Q-1
X-Mimecast-MFC-AGG-ID: IQblN7t3M-Cy4-WkSKNm8Q_1779949676
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB8E41956052;
	Thu, 28 May 2026 06:27:55 +0000 (UTC)
Received: from nprabudo-thinkpadp16vgen1.rmtin.csb (unknown [10.74.81.42])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4A7D11800465;
	Thu, 28 May 2026 06:27:52 +0000 (UTC)
From: Nimal Prabudoss I <nprabudo@redhat.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com,
	nilesh.javali@marvell.com,
	Nimal Prabudoss I <nprabudo@redhat.com>
Subject: [PATCH] scsi: qedf: use GFP_ATOMIC to prevent vmalloc allocation panic
Date: Thu, 28 May 2026 02:27:50 -0400
Message-ID: <20260528062750.20148-1-nprabudo@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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

