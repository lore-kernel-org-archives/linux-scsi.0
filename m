Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB22488DAD
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558467; cv=none; b=jGS4vE/rkG/1oEQqT+b37Ii+TnqOq/nrUC9pKf+COJ9FYVY0DyqyRFe9V4f1n+RCDKrpfqx+mjycfnQj0q52OdEN1to75aOvVxnmNWFy0kvQKsB+LMf64fsm0BcmbmaZ/cjfcGnJgeXN+NR56CgcDhv1Xp7Qvg1c+TXGPJIuokU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558467; c=relaxed/simple;
	bh=EL7ZsU4nhSz7U7K66ArlbistoNCGHNGrlvoJ8RVm2I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHSxlSRuThNrOVHDaSWoROHdXuf9znpfAg9hn319zL/YSwCNqhmYGEBNjYbWEclKSeF3xctqy1zg0LoP1dKr8Nkn/fWpPI2LD5iUpFxw3yHnuCfhq3EbofUJpzdb/YilDAKes78YquKwYR2McaQH/N2yiQAhJDCp9MQTm3DazoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F7RRWrTP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F7RRWrTP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786558465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H0zxaeAVSjXTNhTujVd3ws3OMZKb9NKMAq0h549TWrQ=;
	b=F7RRWrTPj2Yb8yGfGSiexojbR+A7Czpwn3i+HOcMpWsJLylNkvahczUgfF+9beYQOYphMH
	e7NaNrFS/tnOsT8JBQNuPCTZFEd5mKr1ICB2GZg+RRIBl/bMqo1x47rPPXDd7iQirYZiHh
	FXaKJRXeF7OS8E9AUFBEGfSSp0jlgww=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-261-5ZS0RTWTP72E3Tbr9Bx9aA-1; Wed,
 12 Aug 2026 14:14:17 -0400
X-MC-Unique: 5ZS0RTWTP72E3Tbr9Bx9aA-1
X-Mimecast-MFC-AGG-ID: 5ZS0RTWTP72E3Tbr9Bx9aA_1786558453
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E13F18002F8;
	Wed, 12 Aug 2026 18:14:13 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.88.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 17B07180034C;
	Wed, 12 Aug 2026 18:14:07 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Hannes Reinecke <hare@suse.de>,
	Jesse Taube <jtaubepe@redhat.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Chris Leech <cleech@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>,
	shinichiro.kawasaki@wdc.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org
Subject: [PATCH 11/13] scsi: lpfc: enable FPIN notification for NVMe
Date: Wed, 12 Aug 2026 14:12:58 -0400
Message-ID: <20260812181300.3712426-12-jtaubepe@redhat.com>
In-Reply-To: <20260812181300.3712426-1-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Implement set_rport_marginal callback using
nvme_fc_set_remoteport_fpin() to enable FPIN notifications for NVMe.

Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
---
V10 -> V11
 - Rewrite
---
 drivers/scsi/lpfc/lpfc_attr.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f4e8164b94ab..d54899cceed9 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -7134,6 +7134,30 @@ lpfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 #endif
 }
 
+static void
+lpfc_set_rport_marginal(struct fc_rport *rport, bool marginal)
+{
+	struct lpfc_rport_data *rdata = rport->dd_data;
+	struct lpfc_nodelist *ndlp = rdata->pnode;
+	struct lpfc_nvme_rport *nrport = NULL;
+
+	/* Break early if NVME_FC is not enabled */
+	if (!IS_ENABLED(CONFIG_NVME_FC))
+		return;
+
+	if (!ndlp) {
+		dev_info(&rport->dev, "Cannot find remote node to ");
+		dev_info(&rport->dev, "set rport marginal, port_id x%x\n",
+			 rport->port_id);
+		return;
+	}
+
+	nrport = lpfc_ndlp_get_nrport(ndlp);
+
+	if (nrport && nrport->remoteport)
+		nvme_fc_set_remoteport_fpin(nrport->remoteport, marginal);
+}
+
 /*
  * lpfc_rport_show_function - Return rport target information
  *
@@ -7244,6 +7268,8 @@ struct fc_function_template lpfc_transport_functions = {
 	.set_rport_dev_loss_tmo = lpfc_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
 
+	.set_rport_marginal = lpfc_set_rport_marginal,
+
 	.get_starget_port_id  = lpfc_get_starget_port_id,
 	.show_starget_port_id = 1,
 
@@ -7315,6 +7341,8 @@ struct fc_function_template lpfc_vport_transport_functions = {
 	.set_rport_dev_loss_tmo = lpfc_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
 
+	.set_rport_marginal = lpfc_set_rport_marginal,
+
 	.get_starget_port_id  = lpfc_get_starget_port_id,
 	.show_starget_port_id = 1,
 
-- 
2.54.0

