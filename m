Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD81D313E2B
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 06:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779949939; cv=none; b=Bc8HddibAAUP9o7aXiY/tOVvZuWnVsRIHB9rp7VrK4jUfJldxbChtDU6GpJi1L7FalZe6Z+w/R1KKTyzJXE+ZgiQqXu+cL8/o/uxcdVxOqlX1qorvTJNiY+DS7kkJ4fgybyQ1hjJKm2JBfKc2b+YCUXjVic+OKH39uC+s9bNebo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779949939; c=relaxed/simple;
	bh=wWptxQIQNdUb6dBpIYGfCmQuT1dPedNQrau8ps2k3L0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UK46P5cYttKeP2UlYd6NYbGRyekyY/vkK1y8rgKwockmA4eRJxXhXCd6fCkkxgknOVYH4q8zYcNzdywHH4Xh6o4lyq21XmLd+o4YNO92Ca4IJKY7NN5H2JD8AsGGVJ3rmf8fU5gzBNzpK5luX6qtfo64IZCkMNXrkoAyd5GBlcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gVQ9DcnK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gVQ9DcnK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779949936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ACHCWkDjRTcQR10SJPEWEm+CuSjSOBecYNDBTpTcBKs=;
	b=gVQ9DcnK4LwBZfiBzIsKPR/gyEZBqrSp+ay1BFgNz9irlF0VLkCipfLncf1ePKT5bOfKwT
	qaF9V6nqQYRmcluK+I0ciF76zAJozlXrol4uFhcE2tCGMT0g1TGVJvy0u9wtxuFiY+pL6W
	i4OEEZ/UjooKvaOzFdUF0K3Z+pg8RZQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-VvsbObhZOPKjheqNiwxTXg-1; Thu,
 28 May 2026 02:32:12 -0400
X-MC-Unique: VvsbObhZOPKjheqNiwxTXg-1
X-Mimecast-MFC-AGG-ID: VvsbObhZOPKjheqNiwxTXg_1779949931
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9659D19560B4;
	Thu, 28 May 2026 06:32:11 +0000 (UTC)
Received: from nprabudo-thinkpadp16vgen1.rmtin.csb (unknown [10.74.81.42])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DFAD41688;
	Thu, 28 May 2026 06:32:08 +0000 (UTC)
From: Nimal Prabudoss I <nprabudo@redhat.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com,
	nilesh.javali@marvell.com,
	Nimal Prabudoss I <nprabudo@redhat.com>
Subject: [PATCH v2] scsi: qedf: use GFP_ATOMIC to prevent vmalloc allocation panic
Date: Thu, 28 May 2026 02:32:04 -0400
Message-ID: <20260528063204.21708-1-nprabudo@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

The qedf driver encounters an exc_invalid_op crash in get_vm_area_node
when running under intensive I/O stress with IOMMU enabled.

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

