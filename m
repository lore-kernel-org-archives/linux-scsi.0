Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F7E4A92E4
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 20:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788379587; cv=none; b=rc2tgoHlWWAx8McMLMKrg/CS3ybWsDeffuf4jsnb4FFfQrYeASugorQzuiu0mzrcnJsSzdxw17wK7OX8+6cFvAaYmkWON89Cai6iLeE4UNgPWQxXnJBrjYbFaRxTV0CM1Yrw6+WnIb3ncnefMYPC2zYfV5jgzyPDJEpo90H92r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788379587; c=relaxed/simple;
	bh=TX/A9T7k2l7O+z/2UKblsu8QuGJl1aMR7tTvqKEq/WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWTidnYUTy9DFX35U1mw3o9VqZ//mi9P0iB2G8Luj/TOkx0lmyd0tDYvGsLrntfSMPphh/c9PvIJ0Vkp1GcBYn+e280w4RETgqr5ViOCG6SRiLRHYi6FmDzDx7TcC3FIxb1DdRF47Fi2rbbU3DMLAO3yR9bhcpeUOSXTDBc25W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VM+5h22Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VM+5h22Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788379584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XMYZkkfvLk4oMTmC0tcijBigxpVsXAU2YnaVB3q+VDM=;
	b=VM+5h22QWV6MHI4DZ0aaaJ+EaAEnruzQ9Rw49fIHtT3TSSwM8XjvIXhO43kkHQbK0DIq7b
	CbDrkdxgK7JLJCRriqlgLKSGPIw29cpbMg+8cHIFBRFgLG11XC6DVBglFu5OxIMQVwopfv
	M47lw64vE7Rq/BBrSXgSaCgLszWI8qs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-Oa_6jVWVNQewd7r_--03mw-1; Wed,
 02 Sep 2026 16:06:19 -0400
X-MC-Unique: Oa_6jVWVNQewd7r_--03mw-1
X-Mimecast-MFC-AGG-ID: Oa_6jVWVNQewd7r_--03mw_1788379575
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 691F9192DD55;
	Wed,  2 Sep 2026 20:06:15 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.17.16.153])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B12581955F02;
	Wed,  2 Sep 2026 20:06:11 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
	linux-block@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v2 6/7] nvme-fc: add nvme_fc_set_remoteport_fpin()
Date: Wed,  2 Sep 2026 16:05:46 -0400
Message-ID: <20260902200547.184734-7-jtaubepe@redhat.com>
In-Reply-To: <20260902200547.184734-1-jtaubepe@redhat.com>
References: <20260902200547.184734-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Add nvme_fc_set_remoteport_fpin() and supporting functions. This
function is called by the SCSI FC transport and driver layer to set or
clear the 'marginal' path status for a specific rport.

Co-developed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
---
V10 -> V1:
 - Remove nvme_fc_modify_rport_fpin_state
 - Use struct nvme_fc_remote_port instead of wwpn and wwnn
V1 -> V2:
 - Use nvme_ctrl_assign_marginal over set/clear_bit
---
 drivers/nvme/host/fc.c         | 13 +++++++++++++
 include/linux/nvme-fc-driver.h |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 7886c0dcc626..c4810d048b87 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -895,6 +895,19 @@ nvme_fc_set_remoteport_devloss(struct nvme_fc_remote_port *portptr,
 }
 EXPORT_SYMBOL_GPL(nvme_fc_set_remoteport_devloss);
 
+void
+nvme_fc_set_remoteport_fpin(struct nvme_fc_remote_port *portptr, bool marginal)
+{
+	struct nvme_fc_rport *rport = remoteport_to_rport(portptr);
+	struct nvme_fc_ctrl *ctrl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rport->lock, flags);
+	list_for_each_entry(ctrl, &rport->ctrl_list, ctrl_list)
+		nvme_ctrl_assign_marginal(&ctrl->ctrl, marginal);
+	spin_unlock_irqrestore(&rport->lock, flags);
+}
+EXPORT_SYMBOL_GPL(nvme_fc_set_remoteport_fpin);
 
 /* *********************** FC-NVME DMA Handling **************************** */
 
diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-driver.h
index 9f6acadfe0c8..95d79386d126 100644
--- a/include/linux/nvme-fc-driver.h
+++ b/include/linux/nvme-fc-driver.h
@@ -536,6 +536,8 @@ void nvme_fc_rescan_remoteport(struct nvme_fc_remote_port *remoteport);
 int nvme_fc_set_remoteport_devloss(struct nvme_fc_remote_port *remoteport,
 			u32 dev_loss_tmo);
 
+void nvme_fc_set_remoteport_fpin(struct nvme_fc_remote_port *portptr, bool marginal);
+
 /*
  * Routine called to pass a NVME-FC LS request, received by the lldd,
  * to the nvme-fc transport.
-- 
2.55.0

