Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8E52512DD
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 20:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750796644; cv=none; b=iID1CeOC7N6juWPtH7O3A6H3K8FD4J9h+6DJA0O73Z3zR9UlcNFDGI1vQgWn7vr2TLfdeHCRUJ6RkeF78LOoVMHvTcTqO9WgqfMRR+IU7o5VVrqqqwrmzZzQgc71FtoF6hi4/IDlVNDpXfiecwSerLPF/f94SVcCmqjHnrQZBPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750796644; c=relaxed/simple;
	bh=ZNJiEHngGp41O0Kl8RPjbASVoEMt9DhPV+JuWwcJaZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbKHOlPLE16ff6Exfm4TXtrho+uN0EAgEtQWYUHA4xido2JfSpplPbDL8l9NFMOjfcxNpz7Q4ynSupB1wO1akRolWUBKuBwFraayeEsNzVWK/K+nqi2Sfpbj9L83YGB2KeLlYBLHStfom58PWtBYsqllcZvT/ri2Hmau9SupgJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MVuq7E+q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MVuq7E+q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750796641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oaks/0jSVI/AymMABPEdKfpIHanqGaQ44YoIiGNmMKU=;
	b=MVuq7E+qDd46NUMulrsGvGhS45Q3RvNgF3PVcJxRAEtnj10oQV8EBl2SKx8fYk2yiVV9iX
	IyxNrCy/I/bWtYEEmEYrPD7ZvPjNIZK02/MDkeDoz/qQ4Pns3ir/cZhy/V5qQ8i8BdsunS
	7ZTsm6DHzjj52zPBe5iCD3YAw3C5AKk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-aLQqzPXbMI-Zz69Sjz0ThQ-1; Tue,
 24 Jun 2025 16:23:58 -0400
X-MC-Unique: aLQqzPXbMI-Zz69Sjz0ThQ-1
X-Mimecast-MFC-AGG-ID: aLQqzPXbMI-Zz69Sjz0ThQ_1750796636
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89A06180028B;
	Tue, 24 Jun 2025 20:23:56 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.45.226.95])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 62186180035E;
	Tue, 24 Jun 2025 20:23:51 +0000 (UTC)
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
Subject: [PATCH v7 5/6] qla2xxx: enable FPIN notification for NVMe
Date: Tue, 24 Jun 2025 16:20:19 -0400
Message-ID: <20250624202020.42612-6-bgurney@redhat.com>
In-Reply-To: <20250624202020.42612-1-bgurney@redhat.com>
References: <20250624202020.42612-1-bgurney@redhat.com>
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

