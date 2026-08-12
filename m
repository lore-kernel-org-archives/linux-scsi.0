Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F46B48382F
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558467; cv=none; b=DJ91TzPC0cvEgC6dNnk/v6DvR5hwBTGEQWBCLGHAr4FzQMilT33WNy+54fsVqLTj8qpN1HOC+XkF0CEOuFW5rE0uR4tv0P6WSC0FK43vI4CTvgbJX0ZL6wsTXFe6Ibl9z4s1WXIMUaXpsf9OtngAlTsRUe+X6M0LldsIJbBwyDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558467; c=relaxed/simple;
	bh=Ej/ju0eoxUDvqOyYIbXYarc0aQqfSSydX8Z1cVSU0oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JH1fnyA3Xk7qaCvyJScXREO7uPwmBUAUyT+FekUfYguf4oifU5y4m9rLEl7KFspl7JBX0vyByQlo1sgbUpEtzretiDrkTskODzNe+CP2wF3qREl2YhUCxsVrl2IMfIwFJZ6foCAkC8B1KX9Fwju8dVbq7bJ5DRzraf4sdnfFxHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DIIUDtqm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DIIUDtqm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786558464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o8Vm2d0HmZn6yHF6SDZo37n0cyZKJwfRhArj8eZSh5c=;
	b=DIIUDtqm2zp6e1JibliMkJ/ioFu/dj+xZZuQc+YKP26rpnUAChmAN3a+RnXX5WvBAlU6i0
	YKtbbxdbawrscx1it5zUyHe2ZtI1X2yq2+BT+9NfzAe92oL/kTWHBQ2br1iabvBhZolwho
	0TZlZHBDH6BpB8oICyakodW4+P1zDkg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642--1tVOwXyPkSB9oZ3Oq5F1g-1; Wed,
 12 Aug 2026 14:14:19 -0400
X-MC-Unique: -1tVOwXyPkSB9oZ3Oq5F1g-1
X-Mimecast-MFC-AGG-ID: -1tVOwXyPkSB9oZ3Oq5F1g_1786558448
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE4961954B01;
	Wed, 12 Aug 2026 18:14:07 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.88.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 69AFA18005BB;
	Wed, 12 Aug 2026 18:14:02 +0000 (UTC)
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
Subject: [PATCH 10/13] scsi: qla2xxx: enable FPIN notification for NVMe
Date: Wed, 12 Aug 2026 14:12:57 -0400
Message-ID: <20260812181300.3712426-11-jtaubepe@redhat.com>
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
V10 -> V11:
 - Rewrite
---
 drivers/scsi/qla2xxx/qla_attr.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index a4ca22024ede..92db7d584eeb 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2789,6 +2789,15 @@ qla2x00_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 					       rport->dev_loss_tmo);
 }
 
+static inline void
+qla2x00_set_rport_marginal(struct fc_rport *rport, bool marginal)
+{
+	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
+
+	if (IS_ENABLED(CONFIG_NVME_FC) && fcport && fcport->nvme_remote_port)
+		nvme_fc_set_remoteport_fpin(fcport->nvme_remote_port, marginal);
+}
+
 static void
 qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 {
@@ -3379,6 +3388,8 @@ struct fc_function_template qla2xxx_transport_functions = {
 	.set_rport_dev_loss_tmo = qla2x00_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
 
+	.set_rport_marginal = qla2x00_set_rport_marginal,
+
 	.issue_fc_host_lip = qla2x00_issue_lip,
 	.dev_loss_tmo_callbk = qla2x00_dev_loss_tmo_callbk,
 	.terminate_rport_io = qla2x00_terminate_rport_io,
@@ -3427,6 +3438,8 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 	.set_rport_dev_loss_tmo = qla2x00_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
 
+	.set_rport_marginal = qla2x00_set_rport_marginal,
+
 	.issue_fc_host_lip = qla2x00_issue_lip,
 	.dev_loss_tmo_callbk = qla2x00_dev_loss_tmo_callbk,
 	.terminate_rport_io = qla2x00_terminate_rport_io,
-- 
2.54.0

