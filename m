Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA32488D9F
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558466; cv=none; b=E4FSlpOSl9lvk/+e82SE0dwC+GORN/1/zqc5IEVhRwka04TSHyS3G8qKyuLGdLpobCNgb1iYbPaZXGqYry3upMMWyKvWquztejhEkV1QShS8kxpnYAO5mPSjJbvlfllGnJzF43BSMH+4LGB97CkEdNvIaV0bqQlSBZ/TNKNRIsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558466; c=relaxed/simple;
	bh=Mu0dZDZRYBGjV737bYAeXmdbHsjRLEp0W+HVs07CpOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyaSdkKn/o1qagMJaBcN5ogUSotCpjW136gQiG8nk67/XK66LMzDxuwhtB7NcuPeoEvoUdHrbJ/bNeyO64mlebSN4uuAoctgjEFJ5Ad+PRU/wPwhxnE2F7hZFhhDzj30Mjwcu50W9QcM/pEoN7YfOC1eCwcM2ymTtlCp+ALYkuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sil6I++W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sil6I++W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786558462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bZZCou7soQ7pIrWDtdlJ11V2SfEEEN4ySA1ofNj1hNQ=;
	b=Sil6I++W7VcAPvSRCKQVYHTyX/h49bKMzNOlRwZoCJAwbX7biNDqXqTblD/Z05WGkazqfB
	igE0d/wMqL32UWWwKf7F88pQTGZFKQVFrUQJj+0SY2IdLkOkuWqW6/f/EYG4pOZJ4+6f1E
	ldU3ndjp4Eh4DTCOluIV7TagtYffyCI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-571-yAMZESISO2Ks1x7xS93MgQ-1; Wed,
 12 Aug 2026 14:14:09 -0400
X-MC-Unique: yAMZESISO2Ks1x7xS93MgQ-1
X-Mimecast-MFC-AGG-ID: yAMZESISO2Ks1x7xS93MgQ_1786558442
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22DBE195605E;
	Wed, 12 Aug 2026 18:14:02 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.88.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 724E9180034F;
	Wed, 12 Aug 2026 18:13:57 +0000 (UTC)
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
	linux-block@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 09/13] nvme-fc: add nvme_fc_set_remoteport_fpin()
Date: Wed, 12 Aug 2026 14:12:56 -0400
Message-ID: <20260812181300.3712426-10-jtaubepe@redhat.com>
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

Add nvme_fc_set_remoteport_fpin() and supporting functions. This
function is called by the SCSI FC transport and driver layer to set or
clear the 'marginal' path status for a specific rport.

Co-developed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
---
V10 -> V11:
 - Remove nvme_fc_modify_rport_fpin_state
 - Use struct nvme_fc_remote_port instead of wwpn and wwnn
---
 drivers/nvme/host/fc.c         | 16 ++++++++++++++++
 include/linux/nvme-fc-driver.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index d2ca65f70a0c..4acf23ea8aea 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -895,6 +895,22 @@ nvme_fc_set_remoteport_devloss(struct nvme_fc_remote_port *portptr,
 }
 EXPORT_SYMBOL_GPL(nvme_fc_set_remoteport_devloss);
 
+void
+nvme_fc_set_remoteport_fpin(struct nvme_fc_remote_port *portptr, bool marginal)
+{
+	struct nvme_fc_rport *rport = remoteport_to_rport(portptr);
+	struct nvme_fc_ctrl *ctrl;
+
+	spin_lock_irq(&rport->lock);
+	list_for_each_entry(ctrl, &rport->ctrl_list, ctrl_list) {
+		if (marginal)
+			set_bit(NVME_CTRL_MARGINAL, &ctrl->ctrl.flags);
+		else
+			clear_bit(NVME_CTRL_MARGINAL, &ctrl->ctrl.flags);
+	}
+	spin_unlock_irq(&rport->lock);
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
2.54.0

