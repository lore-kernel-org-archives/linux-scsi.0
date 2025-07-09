Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CC1224AFE
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 21:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752096238; cv=none; b=QIa/qTOPIDxWE2JKYLUgLY7W9DIw3QlbTxLTHbdEPWI6xFq4TTquKA/VMrjwuBpd2Ok/ZZoYbVZBYtPc6srg1Exm5z5riJvHF4njbyGZmdLgD9Z8h7qzyk7hoVIyaf97xMbQmyYMdtfyNO8w6KbWItXX8hIbNsX2rcT2Da6mLXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752096238; c=relaxed/simple;
	bh=DfTa4cHYvUpg/fm5qSrgm/2mIBOnBdC8o1pvguXORH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXhdCSOMyA2A0LbhofXqYJieyGtE/Z8nZSUB5guCQVu0L9TJY43UCRwx1PGyMUeLuXCZi2uDgbM2m2vPYlkFLNf24LpubH5NlB0McnCU9au7NUX0t3taYNrjLUt0uVhz+7DIb7AlozQ9tUjNl+NgNWgy35mf2OJGInoGxLtLyRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FrBvdpiA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FrBvdpiA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752096235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p6ksLkA79cvhY+qyHntZSZe03SZlsNVKDsYlZZAFkQ4=;
	b=FrBvdpiAfqQ38BzsSSpgLPr62cnHy+nt+gepiXOqr9tc1Fv5OrnGRVwTPCUfR5KXFLXniz
	1w4IkJdRWuUCnmJMib9EMHusG1cxm9n1KED+mM50zOWRktsxrZy4Tc8pO9W3UleXUJbv31
	D5eJRLxU61UbWWo6hPbe1W4m6YhSCEE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-112-6Nq63D71Pp6fMwb14MqNIQ-1; Wed,
 09 Jul 2025 17:23:50 -0400
X-MC-Unique: 6Nq63D71Pp6fMwb14MqNIQ-1
X-Mimecast-MFC-AGG-ID: 6Nq63D71Pp6fMwb14MqNIQ_1752096227
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9562119560B4;
	Wed,  9 Jul 2025 21:23:47 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.44.33.49])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B3E730001B1;
	Wed,  9 Jul 2025 21:23:41 +0000 (UTC)
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
Subject: [PATCH v8 6/8] qla2xxx: enable FPIN notification for NVMe
Date: Wed,  9 Jul 2025 17:19:17 -0400
Message-ID: <20250709211919.49100-7-bgurney@redhat.com>
In-Reply-To: <20250709211919.49100-1-bgurney@redhat.com>
References: <20250709211919.49100-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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
2.50.0

