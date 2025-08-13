Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4E92FD7B0
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 20:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755115729; cv=none; b=Dcf3M6jteUdqrhzKEbLR/Lq5ySm3ztg05mcfsUVQ8RwDHD4fmuvlk98BllrdNDkOEaC6SHoD8FU04ntFx3/OgRharhtwG1i7IoG/6ai0XlY7jR8iBTto8aOz8LDcdgtpnc9ud9ArxD1gwGO0OSRRkKMhI3HeC8i/JbJLrBIoLKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755115729; c=relaxed/simple;
	bh=QthE9ARNgt2uenvF9iHbQnFcPSel3LOvmntlKR7DhkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cf4jE88n9+WpGFdTY0pgr/B273MAa02QR7X+lTHzGvGi4T+zNrde5VcXvhEZHvwwL+vFnmXAQdEn5ATc6nCy8kTLAIGYNk7VcEHRndmBUJzU63k5RPwu6DcX+srW/v/O9QMMzUHs5Ti/oAyVQJBKdGNYHRvxgro73D9rmx7SvHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q0RfRMkH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q0RfRMkH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755115727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vapy6u9IxBq28MV1zIU1731cWANnJOz35YFMaxAbU58=;
	b=Q0RfRMkHIUhXvVHi7vn/ZF4kDnIrEQ53K3Uvq50WM03O+yJ7A9YvpsHU/mIyuocCXf8570
	dw4ZBen5G6saP8LEF1VBTwDdAgQowIh7Z35IBanv1KUqHLdzgL/AZA152rg9tlHMF9kvQn
	cX9fKEhopiTdmxp+4sfLxt4j+mtjPs8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-228-rfLxZs8TPba8CWYp1KNYuQ-1; Wed,
 13 Aug 2025 16:08:43 -0400
X-MC-Unique: rfLxZs8TPba8CWYp1KNYuQ-1
X-Mimecast-MFC-AGG-ID: rfLxZs8TPba8CWYp1KNYuQ_1755115721
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C2DBC1956088;
	Wed, 13 Aug 2025 20:08:41 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.44.32.39])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B2DF318003FC;
	Wed, 13 Aug 2025 20:08:35 +0000 (UTC)
From: Bryan Gurney <bgurney@redhat.com>
To: linux-nvme@lists.infradead.org,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	axboe@kernel.dk
Cc: james.smart@broadcom.com,
	njavali@marvell.com,
	linux-scsi@vger.kernel.org,
	hare@suse.de,
	linux-hardening@vger.kernel.org,
	kees@kernel.org,
	gustavoars@kernel.org,
	bgurney@redhat.com,
	jmeneghi@redhat.com,
	emilne@redhat.com
Subject: [PATCH v9 6/9] qla2xxx: enable FPIN notification for NVMe
Date: Wed, 13 Aug 2025 16:07:41 -0400
Message-ID: <20250813200744.17975-7-bgurney@redhat.com>
In-Reply-To: <20250813200744.17975-1-bgurney@redhat.com>
References: <20250813200744.17975-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Hannes Reinecke <hare@kernel.org>

Call 'nvme_fc_fpin_rcv()' to enable FPIN notifications for NVMe.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c4c6b5c6658c..f5e40e22ad7d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -46,6 +46,9 @@ qla27xx_process_purex_fpin(struct scsi_qla_host *vha, struct purex_item *item)
 		       pkt, pkt_size);
 
 	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt, 0);
+#if (IS_ENABLED(CONFIG_NVME_FC))
+	nvme_fc_fpin_rcv(vha->nvme_local_port, pkt_size, (char *)pkt);
+#endif
 }
 
 const char *const port_state_str[] = {
-- 
2.50.1

