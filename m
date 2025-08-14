Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087DB2288D5
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 18:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755196168; cv=none; b=HfbitIHWU8MiWMtsSDZi7Cjqn73Sx172rlUWopMOeggQfFYQribC4AdFfdkxuvnBiu3u3mNDdgmolRrQlLGr6r4RPWmqtN1XrIdRcGLRptZIghq1jassMXYSHzPtKP2Mq2NaXPQglxyJZ6I6kbi5oe5vY2dKSlZwXqcz2F81Ih0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755196168; c=relaxed/simple;
	bh=+v3QeYKrw3fA3ywzRfBBunyksmDP6i0ioZgoXE5s6qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/X+h1o5bao42pysOb2D0VfhVmeqcqj/nWNy8aJjllSw+2YNlATM37Ruq4U4STmNcPes3o9ISe04Xmg3qxuDPxgbd4lWALh9QArD1Cf/QeeObOMKkht/InOf76n2ypN594OGqsQRYtRWf7shW+/xWX+zYIki4dvubmEsUP7iAOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T8iOWoDO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T8iOWoDO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755196166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zDpkXA37JTgHyQNMxiq/uFupiGVWpX+0Y/98blFSyS8=;
	b=T8iOWoDO+wX6PZ5nVrm4BHq9+c2STd0754na3svpHTHhuCRAjPvtmOHVVkA0UG3OAq4+qW
	2j/4YQODNCQZF/YQJSHQP1y3B8ieXvnQ8YmN+RqYQvATqnzQ/t4HLlK0VZmhde3q0vHdQy
	ONyZaXDN4a3DyX7/xNt+g8KB/u2x5dU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-10-QZ8xWDESPf6FtvTo18_MMA-1; Thu,
 14 Aug 2025 14:29:24 -0400
X-MC-Unique: QZ8xWDESPf6FtvTo18_MMA-1
X-Mimecast-MFC-AGG-ID: QZ8xWDESPf6FtvTo18_MMA_1755196163
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B2CA180036E;
	Thu, 14 Aug 2025 18:29:23 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.65.61])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8A7CD1800280;
	Thu, 14 Aug 2025 18:29:22 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com,
	dgilbert@interlog.com,
	bvanassche@acm.org
Subject: [PATCH v2 9/9] scsi: scsi_debug: Add option to suppress returned data but return good status
Date: Thu, 14 Aug 2025 14:29:07 -0400
Message-ID: <20250814182907.1501213-10-emilne@redhat.com>
In-Reply-To: <20250814182907.1501213-1-emilne@redhat.com>
References: <20250814182907.1501213-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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

