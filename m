Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EB11DC075
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750442246; cv=none; b=eQR8NAZ1KYaxAxJXStD20akjtCsiE3hG63wjyR08Te2ah9Yc/H407dI50qmBmN3kqRrEA8K+W/Hi2PnXJGind6Q7wtzGER1acOgz3K5HXHxsSnW1cdJoSaLG4JT+BsJnYDyS8pYqDr5YZuuGf27WJwFpD8YO1dx3oK9ucgr2uro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750442246; c=relaxed/simple;
	bh=ADneNwgWLv508uFbwpaD118x/mH0vb/2S9F+jcoBITg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CKUNlDbXP6j7pQ7U6GrTrLG5Eb4Q+1Xp61YsPWgf7+pKW5ugYwJqF/gI6x2Ls1Skz3H5YlR3TXoJYRVIoqbwwWJO/r2j/OfikPFW8pznQLtvYwItirCNoaFQdrWKrW4B02EAX3+N4Wx4TPiJbZ7eq2ohLMOb65QHCqC7+LI/clc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d8GcsMWs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d8GcsMWs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750442243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gb7VU4Yqii31Q0K4n8MvfF1xfaMxgwUGNB+6uWggDT4=;
	b=d8GcsMWsIUAdsfhSHZtOX6td4sEdo2qCKzzri5/WntBx7Z5YxziD0R9D8XT7j0fgjh3ODt
	mVlYw2hBWF6k83P2pCH2lyfRwdr5Kw0g13YDsK+8jRXyPGSPW/CxSX1FDzq6Gko600v1Dw
	A8r+dA4+mZWZqnqXoUXA/Amem4Rq7Tk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-ePyE2LCQOq6dUpt-oKVxVA-1; Fri,
 20 Jun 2025 13:57:20 -0400
X-MC-Unique: ePyE2LCQOq6dUpt-oKVxVA-1
X-Mimecast-MFC-AGG-ID: ePyE2LCQOq6dUpt-oKVxVA_1750442238
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 10C57180136B;
	Fri, 20 Jun 2025 17:57:18 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.22.80.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0CF3F18003FC;
	Fri, 20 Jun 2025 17:57:14 +0000 (UTC)
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
Subject: [PATCH v6 3/6] nvme-fc: nvme_fc_fpin_rcv() callback
Date: Fri, 20 Jun 2025 13:57:10 -0400
Message-ID: <20250620175710.34711-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Hannes Reinecke <hare@kernel.org>

Add a callback nvme_fc_fpin_rcv() to evaluate the FPIN LI TLV
information and set the 'marginal' path status for all affected
rports.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Bryan Gurney <bgurney@redhat.com>
---
 drivers/nvme/host/fc.c         | 95 ++++++++++++++++++++++++++++++++++
 include/linux/nvme-fc-driver.h |  3 ++
 2 files changed, 98 insertions(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 7e81c815bb83..71a77917a14f 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3724,6 +3724,101 @@ static struct nvmf_transport_ops nvme_fc_transport = {
 	.create_ctrl	= nvme_fc_create_ctrl,
 };
 
+static struct nvme_fc_rport *nvme_fc_rport_from_wwpn(struct nvme_fc_lport *lport,
+		u64 rport_wwpn)
+{
+	struct nvme_fc_rport *rport;
+
+	list_for_each_entry(rport, &lport->endp_list, endp_list) {
+		if (!nvme_fc_rport_get(rport))
+			continue;
+		if (rport->remoteport.port_name == rport_wwpn &&
+		    rport->remoteport.port_role & FC_PORT_ROLE_NVME_TARGET)
+			return rport;
+		nvme_fc_rport_put(rport);
+	}
+	return NULL;
+}
+
+static void
+nvme_fc_fpin_li_lport_update(struct nvme_fc_lport *lport, struct fc_fn_li_desc *li)
+{
+	unsigned int i, pname_count = be32_to_cpu(li->pname_count);
+	u64 attached_wwpn = be64_to_cpu(li->attached_wwpn);
+	struct nvme_fc_rport *attached_rport;
+
+	for (i = 0; i < pname_count; i++) {
+		struct nvme_fc_rport *rport;
+		u64 wwpn = be64_to_cpu(li->pname_list[i]);
+
+		rport = nvme_fc_rport_from_wwpn(lport, wwpn);
+		if (!rport)
+			continue;
+		if (wwpn != attached_wwpn) {
+			struct nvme_fc_ctrl *ctrl;
+
+			spin_lock_irq(&rport->lock);
+			list_for_each_entry(ctrl, &rport->ctrl_list, ctrl_list)
+				set_bit(NVME_CTRL_MARGINAL, &ctrl->ctrl.flags);
+			spin_unlock_irq(&rport->lock);
+		}
+		nvme_fc_rport_put(rport);
+	}
+
+	attached_rport = nvme_fc_rport_from_wwpn(lport, attached_wwpn);
+	if (attached_rport) {
+		struct nvme_fc_ctrl *ctrl;
+
+		spin_lock_irq(&attached_rport->lock);
+		list_for_each_entry(ctrl, &attached_rport->ctrl_list, ctrl_list)
+			set_bit(NVME_CTRL_MARGINAL, &ctrl->ctrl.flags);
+		spin_unlock_irq(&attached_rport->lock);
+		nvme_fc_rport_put(attached_rport);
+	}
+}
+
+/**
+ * fc_host_fpin_rcv() - Process a received FPIN.
+ * @localport:		local port the FPIN was received on
+ * @fpin_len:		length of FPIN payload, in bytes
+ * @fpin_buf:		pointer to FPIN payload
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+void
+nvme_fc_fpin_rcv(struct nvme_fc_local_port *localport,
+		 u32 fpin_len, char *fpin_buf)
+{
+	struct nvme_fc_lport *lport;
+	struct fc_els_fpin *fpin = (struct fc_els_fpin *)fpin_buf;
+	union fc_tlv_desc *tlv;
+	u32 bytes_remain;
+	u32 dtag;
+
+	if (!localport)
+		return;
+	lport = localport_to_lport(localport);
+	tlv = &fpin->fpin_desc[0];
+	bytes_remain = fpin_len - offsetof(struct fc_els_fpin, fpin_desc);
+	bytes_remain = min_t(u32, bytes_remain, be32_to_cpu(fpin->desc_len));
+
+	while (bytes_remain >= FC_TLV_DESC_HDR_SZ &&
+	       bytes_remain >= FC_TLV_DESC_SZ_FROM_LENGTH(tlv)) {
+		dtag = be32_to_cpu(tlv->hdr.desc_tag);
+		switch (dtag) {
+		case ELS_DTAG_LNK_INTEGRITY:
+			nvme_fc_fpin_li_lport_update(lport, &tlv->li);
+			break;
+		default:
+			break;
+		}
+
+		bytes_remain -= FC_TLV_DESC_SZ_FROM_LENGTH(tlv);
+		tlv = fc_tlv_next_desc(tlv);
+	}
+}
+EXPORT_SYMBOL(nvme_fc_fpin_rcv);
+
 /* Arbitrary successive failures max. With lots of subsystems could be high */
 #define DISCOVERY_MAX_FAIL	20
 
diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-driver.h
index 9f6acadfe0c8..bcd3b1e5a256 100644
--- a/include/linux/nvme-fc-driver.h
+++ b/include/linux/nvme-fc-driver.h
@@ -536,6 +536,9 @@ void nvme_fc_rescan_remoteport(struct nvme_fc_remote_port *remoteport);
 int nvme_fc_set_remoteport_devloss(struct nvme_fc_remote_port *remoteport,
 			u32 dev_loss_tmo);
 
+void nvme_fc_fpin_rcv(struct nvme_fc_local_port *localport,
+		      u32 fpin_len, char *fpin_buf);
+
 /*
  * Routine called to pass a NVME-FC LS request, received by the lldd,
  * to the nvme-fc transport.
-- 
2.49.0

