Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2037283FCB
	for <linux-scsi@vger.kernel.org>; Thu,  2 Oct 2025 19:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759433137; cv=none; b=aLTCh6eEVcmKJmYw3D1oeKG2e4R6vLH0BX1ImZBoRystCeOLd7JUMkYrbwnqpJUs0kUkxAIx8lOXv7bWqJSNSvTnpInZBR5cbHM8R12h7eCz2NluvSuyqSOLMHzTuAOtwrcqdZ9uF7V0W6sBlHSS4Pvw5vfehrRjDbkwqAkKVRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759433137; c=relaxed/simple;
	bh=U1SdhCgA7ALbTUrYAzXFJ9BSPFfHVBMIUJIjcdBybC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQsQkLNwGYRG8eoh7yMYoYs1IP2BAi5nkMgWEe6lUS7GOfOpcpMVjNnsxZKzhuoNK4spRhIV0qBgWIobHW7dFjgtfDAusd1bPT48nJ1B10abVQ/tmEIe+knMykRuv+K45+lXbsEkCfilP6PXAvGDJNcJKyp9UNSP3/mw7WIVijQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hxiutf1x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hxiutf1x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759433134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wCnW+7XBwlvme7yYXz9G8JhZqe2/L7TNqdMf3pJOdOc=;
	b=Hxiutf1xnPqNR2ZReKFIVvfLm5FE8+YsLagZOR+1jR+nF8+u7cidGo26nbc38dXccEsahm
	xtvQg5C4132NTL9XLEn8Gtcas9JuG0AXWayY7WSb9Wzpkz/dBE6lD78rP1KRaqHa5Ri8EQ
	CMZIZthwotvnpkte884/qacqXHidld8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-424-R2ov9pAGOWqh5cCc-yFVpQ-1; Thu,
 02 Oct 2025 15:25:26 -0400
X-MC-Unique: R2ov9pAGOWqh5cCc-yFVpQ-1
X-Mimecast-MFC-AGG-ID: R2ov9pAGOWqh5cCc-yFVpQ_1759433125
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68A711800366;
	Thu,  2 Oct 2025 19:25:25 +0000 (UTC)
Received: from emilne-na.ibmlowe.csb (unknown [10.17.17.93])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 18458195419F;
	Thu,  2 Oct 2025 19:25:23 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	hare@suse.de
Subject: [PATCH v4 8/9] scsi: scsi_debug: Add option to suppress returned data but return good status
Date: Thu,  2 Oct 2025 15:25:09 -0400
Message-ID: <20251002192510.1922731-9-emilne@redhat.com>
In-Reply-To: <20251002192510.1922731-1-emilne@redhat.com>
References: <20251002192510.1922731-1-emilne@redhat.com>
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
 drivers/scsi/scsi_debug.c | 49 ++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 353cb60e1abe..2c49aadaef80 100644
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
@@ -1641,9 +1643,19 @@ static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
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
+		atomic_set(&sdeb_inject_pending, 0);
+	} else {
+		act_len = sg_copy_from_buffer(sdb->table.sgl, sdb->table.nents,
+					      arr, arr_len);
+		resid = scsi_bufflen(scp) - act_len;
+	}
+	scsi_set_resid(scp, resid);
 
 	return 0;
 }
@@ -1656,7 +1668,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 				  int arr_len, unsigned int off_dst)
 {
-	unsigned int act_len, n;
+	unsigned int act_len, n, resid;
 	struct scsi_data_buffer *sdb = &scp->sdb;
 	off_t skip = off_dst;
 
@@ -1665,13 +1677,24 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
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
+		atomic_set(&sdeb_inject_pending, 0);
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

