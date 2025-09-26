Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB72C5661
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 00:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758844967; cv=none; b=jGTyIBqekLlRhpcumAK6Vf4XsQdKutedNrkioHkHYQPKOhpW0pqM/BIr7wLn6cMM7H9616HHwDFl9smuXZjfEwUGFPPzYsBdrAuQR5ttoCcYRjZckpE6VxwkAuCmHZxaQmsDp7uoQ5WT+o8DuYlXC8eIFnyBQukJoyq/hRrPJtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758844967; c=relaxed/simple;
	bh=E6HBQAV40Lpw24fJ26UW5mCWwqPxHDVhdvu4aURos6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=qu+xDP245nTujp5LlgZX90n7sjtEAjJU5SYNe9Ey8cns83Q1RulY+a3YaqRDe5HYQbRcoBNIaFaR8m/N7S5sBWcxbkUuvBo+JaIQCIkwRKhqJ5H9qm4c//UyeXvIBVvlzzdKxm/EuWhr8MzzQTy/ZwzDLA01X3MGczwQSN7VSBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EhhMDeOE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EhhMDeOE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758844965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j447mNKgQLwSKrAVHMP3Z/CjyrDu+BpYB1bqQix1tOU=;
	b=EhhMDeOEJ1gac9jH3tanRMDkoK8cAIUfe24TAxYuKQWYkvd5I3U9mBs4ITVm1shzt/G/R4
	o+d+eyOUP5uXF15kl+tq0b3wUJXE2nxtAhaODSpGquK8jRBZyYZ6in6wQwRuNvrtmNXIqI
	FBYgAE47sgO70SGy3Y7q8I4ar4kyq5Y=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-272-D5Dnn5-MMtWs0u4j5LjOtQ-1; Thu,
 25 Sep 2025 20:02:39 -0400
X-MC-Unique: D5Dnn5-MMtWs0u4j5LjOtQ-1
X-Mimecast-MFC-AGG-ID: D5Dnn5-MMtWs0u4j5LjOtQ_1758844958
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D744319560B1;
	Fri, 26 Sep 2025 00:02:37 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen7.rmtusnh.csb (unknown [10.22.81.200])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0C54A180035E;
	Fri, 26 Sep 2025 00:02:34 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: hare@suse.de,
	kbusch@kernel.org,
	martin.petersen@oracle.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Cc: bgurney@redhat.com,
	axboe@kernel.dk,
	emilne@redhat.com,
	gustavoars@kernel.org,
	hch@lst.de,
	james.smart@broadcom.com,
	jmeneghi@redhat.com,
	kees@kernel.org,
	linux-hardening@vger.kernel.org,
	njavali@marvell.com,
	sagi@grimberg.me
Subject: [PATCH v10 09/11] scsi: qla2xxx: enable FPIN notification for NVMe
Date: Thu, 25 Sep 2025 20:01:58 -0400
Message-ID: <20250926000200.837025-10-jmeneghi@redhat.com>
In-Reply-To: <20250926000200.837025-1-jmeneghi@redhat.com>
References: <20250926000200.837025-1-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Call fc_host_fpin_set_nvme_rport_marginal() to enable FPIN notifications
for NVMe.

Co-developed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Bryan Gurney <bgurney@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c4c6b5c6658c..8ff8781dae47 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -46,6 +46,7 @@ qla27xx_process_purex_fpin(struct scsi_qla_host *vha, struct purex_item *item)
 		       pkt, pkt_size);
 
 	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt, 0);
+	fc_host_fpin_set_nvme_rport_marginal(vha->host, pkt_size, (char *)pkt);
 }
 
 const char *const port_state_str[] = {
-- 
2.51.0

