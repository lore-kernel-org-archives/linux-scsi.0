Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E421DC075
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750442297; cv=none; b=QUoj6zKDDmE+PlVeV2aWd3nXU52UB5FGqE0wRICslfxB7yv5sg72xtqUKA6Tp283rPxImdhv1Q5iF1fI04VNY1vs98x380OzBmw5fXzqujMFwx/y4/A/o835kiiMTSqBRBtbnf+EoIvGPhGqZCdKOwvWSvJdBbMYpEq+Hbqq10w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750442297; c=relaxed/simple;
	bh=ZNJiEHngGp41O0Kl8RPjbASVoEMt9DhPV+JuWwcJaZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mEG6ir/+fz6i0ZI6jBP/mrY4v7+jDU051fIZg4zzPfl1icimSqU5uj6pB8W/VYCHCVnLj152Il7aKByhTuyDiT1dmylg/27R7FAvY8BI6PKYTq7u2fYRGXQqJ2ba1+Tj+g1DUKPXvYBuoQnEbEovB8YS8tt0v4APk/N4CETraqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AAH3e76n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AAH3e76n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750442294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Oaks/0jSVI/AymMABPEdKfpIHanqGaQ44YoIiGNmMKU=;
	b=AAH3e76ng9tEm57qdMEA898Y7E09JfgSYivNPk4LI4ehR9yPkg/hctesOjBaGYVdAantb/
	toTW/ih9W+l/596X5Tvm1TpQ/lw3AHcqMd/8+kEmeYdsB/ts9Ue7zAUSTAxfNLFD08yOVX
	oIENyg0JnnUGJvGMiiQMl99WGy6Em0Q=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-544-OEjh7aPJPCqJA52Bfqb9uw-1; Fri,
 20 Jun 2025 13:58:11 -0400
X-MC-Unique: OEjh7aPJPCqJA52Bfqb9uw-1
X-Mimecast-MFC-AGG-ID: OEjh7aPJPCqJA52Bfqb9uw_1750442289
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BE70195608B;
	Fri, 20 Jun 2025 17:58:09 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.22.80.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA05318002B5;
	Fri, 20 Jun 2025 17:58:06 +0000 (UTC)
From: Bryan Gurney <bgurney@redhat.com>
To: linux-nvme@lists.infradead.org,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	axboe@kernel.dk
Cc: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	njavali@marvell.com,
	linux-scsi@vger.kernel.org,
	hare@suse.de,
	bgurney@redhat.com,
	jmeneghi@redhat.com
Subject: [PATCH v6 5/6] qla2xxx: enable FPIN notification for NVMe
Date: Fri, 20 Jun 2025 13:58:00 -0400
Message-ID: <20250620175800.34769-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: Hannes Reinecke <hare@kernel.org>

Call 'nvme_fc_fpin_rcv()' to enable FPIN notifications for NVMe.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index fe98c76e9be3..cfe7afc905b4 100644
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
2.49.0

