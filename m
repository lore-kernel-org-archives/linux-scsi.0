Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA83B84A3E
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 18:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752691729; cv=none; b=Qwg8Vdm1FEjTRI2E5m4Lm1lFmtg4Nl4/tHwGDXbKCM9vq2qsLpKKU/RwnP281STQ7d3/nzrSwdGTY8P877HRQqzSUh04M58t5ShHHQ8rDLKgVKZ528Omf3NNOKayDxoOiA6PUuX6lW5e4f/gpn1RJxTfhkA+js1DOsakUca0OEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752691729; c=relaxed/simple;
	bh=NOwuj16+U3pdIz4atdsnz39GFKja1CGxk40F9FOn5E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsTRDtAQEpu958Xs3ko1PeNe/wPrg5C9BDsPwldDQez7ccwBdEA2+SaReMK+53kixYiK/6XDu4FTQ1LmLGlZVA5zWTgLt8+awP6CJ+pfAMNIQ/51YmhD9WmrsEIyIy279WNjZfsh44d5uXPIlae+icOvFxLTrDCAuVdAT939ZC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f3KZIQRt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f3KZIQRt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752691726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVnWXc3SdScP29Smj1JJRtsWCCE93HW6lSVuNexQ3N4=;
	b=f3KZIQRt3AWv91QMVPNm9KC3y6D0rzeyz4+MDk3Wg7L9QnRCxlKcWvj/hX2lJSM6qd5prO
	Q/rFM0WkAeslHHcgbqX92SMHSMrGNAQylmwFfZWXNzTzwZz7g5jV91xMnzgF1oHPMWULGj
	dkKDREDfOaHXi7Y1lr/mUR7dNwDwhGU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-543-wdvsygyBPRyRksPky1hqvA-1; Wed,
 16 Jul 2025 14:48:43 -0400
X-MC-Unique: wdvsygyBPRyRksPky1hqvA-1
X-Mimecast-MFC-AGG-ID: wdvsygyBPRyRksPky1hqvA_1752691722
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A2471956080;
	Wed, 16 Jul 2025 18:48:42 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.88.244])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2943018002AF;
	Wed, 16 Jul 2025 18:48:40 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com
Subject: [PATCH 5/5] scsi: scsi_debug: Add option to suppress returned data but return good status
Date: Wed, 16 Jul 2025 14:48:33 -0400
Message-ID: <20250716184833.67055-6-emilne@redhat.com>
In-Reply-To: <20250716184833.67055-1-emilne@redhat.com>
References: <20250716184833.67055-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

This is used to test the earlier read_capacity_10()/16() retry patch.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index aef33d1e346a..a8ec653d4795 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -230,6 +230,7 @@ struct tape_block {
 #define SDEBUG_OPT_NO_CDB_NOISE		0x4000
 #define SDEBUG_OPT_HOST_BUSY		0x8000
 #define SDEBUG_OPT_CMD_ABORT		0x10000
+#define SDEBUG_OPT_NO_DATA		0x20000
 #define SDEBUG_OPT_ALL_NOISE (SDEBUG_OPT_NOISE | SDEBUG_OPT_Q_NOISE | \
 			      SDEBUG_OPT_RESET_NOISE)
 #define SDEBUG_OPT_ALL_INJECTING (SDEBUG_OPT_RECOVERED_ERR | \
@@ -1641,10 +1642,17 @@ static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 	if (scp->sc_data_direction != DMA_FROM_DEVICE)
 		return DID_ERROR << 16;
 
-	act_len = sg_copy_from_buffer(sdb->table.sgl, sdb->table.nents,
-				      arr, arr_len);
-	scsi_set_resid(scp, scsi_bufflen(scp) - act_len);
-
+	/*
+	 * Conditionally suppress DATA IN transfer and leave resid set to bufflen.
+	 */
+	if (unlikely((sdebug_opts & SDEBUG_OPT_NO_DATA) &&
+		      atomic_read(&sdeb_inject_pending))) {
+		scsi_set_resid(scp, scsi_bufflen(scp));
+	} else {
+		act_len = sg_copy_from_buffer(sdb->table.sgl, sdb->table.nents,
+					      arr, arr_len);
+		scsi_set_resid(scp, scsi_bufflen(scp) - act_len);
+	}
 	return 0;
 }
 
@@ -1665,13 +1673,21 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 	if (scp->sc_data_direction != DMA_FROM_DEVICE)
 		return DID_ERROR << 16;
 
-	act_len = sg_pcopy_from_buffer(sdb->table.sgl, sdb->table.nents,
-				       arr, arr_len, skip);
-	pr_debug("%s: off_dst=%u, scsi_bufflen=%u, act_len=%u, resid=%d\n",
-		 __func__, off_dst, scsi_bufflen(scp), act_len,
-		 scsi_get_resid(scp));
-	n = scsi_bufflen(scp) - (off_dst + act_len);
-	scsi_set_resid(scp, min_t(u32, scsi_get_resid(scp), n));
+	/*
+	 * Conditionally suppress DATA IN transfer and leave resid set to bufflen.
+	 */
+	if (unlikely((sdebug_opts & SDEBUG_OPT_NO_DATA) &&
+		      atomic_read(&sdeb_inject_pending))) {
+		scsi_set_resid(scp, scsi_bufflen(scp));
+	} else {
+		act_len = sg_pcopy_from_buffer(sdb->table.sgl, sdb->table.nents,
+					       arr, arr_len, skip);
+		pr_debug("%s: off_dst=%u, scsi_bufflen=%u, act_len=%u, resid=%d\n",
+			 __func__, off_dst, scsi_bufflen(scp), act_len,
+			 scsi_get_resid(scp));
+		n = scsi_bufflen(scp) - (off_dst + act_len);
+		scsi_set_resid(scp, min_t(u32, scsi_get_resid(scp), n));
+	}
 	return 0;
 }
 
-- 
2.47.1

