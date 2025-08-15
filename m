Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56A3242D6C
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 21:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755292549; cv=none; b=FO7n/PD90mW3Ti2p10n/fNEgUW0h3QOCtl2To4NBZOOZbBTrmbPv8Tgo6E2ztEUigauS2jLVYMPuNbgOjw/huqQ9HhJZHR+FQV8dOqkyTacjh0gucrGc7fsUd9ci1UBxTuzjg+d4wlkqiMDLtEkfLdv0EAJx7XF3o/dlgtz3ngA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755292549; c=relaxed/simple;
	bh=+v3QeYKrw3fA3ywzRfBBunyksmDP6i0ioZgoXE5s6qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFuFE7r/mVbNTceBEXeWboSEKWlLTnvcRbbRxI+7ZDMiPr8VMGlnD3ZdupOZGsgNmaA4W5bBRG9E+Znf8dgxCAUCr7rXVbUEcdBZef51Tb6d7UBpeOoCuY8wJPzHs1Ay5Lvy+loMX9bcnboUL+7h4KCKPw6WyABnOvRCj5/gch0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ABDE7krg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ABDE7krg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755292546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zDpkXA37JTgHyQNMxiq/uFupiGVWpX+0Y/98blFSyS8=;
	b=ABDE7krgHR8Jmohu16SvFjmh51ctBDUkVdwQV5dBtwv2sf4fwsmtT7GyEhuBD4by97Jl+T
	vBxdIAFZPG40E50nPV241qjJI5mWJbo3kJyBTqvJddgdffoKdPsxtxhUXKPbyf7ALdDhit
	f25bfGKpdeVtKPj2wlvIVzLzJCEGpCQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-PWP5UImmOea587iPPagq8g-1; Fri,
 15 Aug 2025 17:15:42 -0400
X-MC-Unique: PWP5UImmOea587iPPagq8g-1
X-Mimecast-MFC-AGG-ID: PWP5UImmOea587iPPagq8g_1755292541
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC4FD1800286;
	Fri, 15 Aug 2025 21:15:41 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 66C7019327C0;
	Fri, 15 Aug 2025 21:15:40 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org
Subject: [PATCH v3 8/8] scsi: scsi_debug: Add option to suppress returned data but return good status
Date: Fri, 15 Aug 2025 17:15:25 -0400
Message-ID: <20250815211525.1524254-9-emilne@redhat.com>
In-Reply-To: <20250815211525.1524254-1-emilne@redhat.com>
References: <20250815211525.1524254-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This is used to test the earlier read_capacity_10()/16() retry patch.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 47 ++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 353cb60e1abe..6239783bef21 100644
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
@@ -237,7 +238,8 @@ struct tape_block {
 				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR | \
 				  SDEBUG_OPT_SHORT_TRANSFER | \
 				  SDEBUG_OPT_HOST_BUSY | \
-				  SDEBUG_OPT_CMD_ABORT)
+				  SDEBUG_OPT_CMD_ABORT | \
+				  SDEBUG_OPT_NO_DATA)
 #define SDEBUG_OPT_RECOV_DIF_DIX (SDEBUG_OPT_RECOVERED_ERR | \
 				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR)
 
@@ -1633,7 +1635,7 @@ static int make_ua(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 				int arr_len)
 {
-	int act_len;
+	int act_len, resid;
 	struct scsi_data_buffer *sdb = &scp->sdb;
 
 	if (!sdb->length)
@@ -1641,9 +1643,18 @@ static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 	if (scp->sc_data_direction != DMA_FROM_DEVICE)
 		return DID_ERROR << 16;
 
-	act_len = sg_copy_from_buffer(sdb->table.sgl, sdb->table.nents,
-				      arr, arr_len);
-	scsi_set_resid(scp, scsi_bufflen(scp) - act_len);
+	/*
+	 * Conditionally suppress DATA IN transfer and leave resid set to bufflen.
+	 */
+	if (unlikely((sdebug_opts & SDEBUG_OPT_NO_DATA) &&
+		      atomic_read(&sdeb_inject_pending))) {
+		resid = scsi_bufflen(scp);
+	} else {
+		act_len = sg_copy_from_buffer(sdb->table.sgl, sdb->table.nents,
+					      arr, arr_len);
+		resid = scsi_bufflen(scp) - act_len;
+	}
+	scsi_set_resid(scp, resid);
 
 	return 0;
 }
@@ -1656,7 +1667,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 				  int arr_len, unsigned int off_dst)
 {
-	unsigned int act_len, n;
+	unsigned int act_len, n, resid;
 	struct scsi_data_buffer *sdb = &scp->sdb;
 	off_t skip = off_dst;
 
@@ -1665,13 +1676,23 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
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
+		resid = scsi_bufflen(scp);
+	} else {
+		act_len = sg_pcopy_from_buffer(sdb->table.sgl, sdb->table.nents,
+					       arr, arr_len, skip);
+		pr_debug("%s: off_dst=%u, scsi_bufflen=%u, act_len=%u, resid=%d\n",
+			 __func__, off_dst, scsi_bufflen(scp), act_len,
+			 scsi_get_resid(scp));
+		n = scsi_bufflen(scp) - (off_dst + act_len);
+		resid = min_t(u32, scsi_get_resid(scp), n);
+	}
+	scsi_set_resid(scp, resid);
+
 	return 0;
 }
 
-- 
2.47.1

