Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E37224AFE
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 21:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752096152; cv=none; b=OqrT2xN7z3xPU1K3ViSk1chlmGbbSPWVfrYTBGQbpMK/56WNzUTc2PjL1bljKrh9GgWPyGJh4EFJ2l+hL2NDDTWDaMMK67m5CY15CS/q6RkD/z/TEpvecYMLpJjBrWGqwBqntUpLZYyQJBvhju1uXSaRxaVZLCq9sQVGuTJ32sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752096152; c=relaxed/simple;
	bh=rLRZSayLekjpPK4LAU5+f/amaSxqYEBJUAml30c4yX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeOijVqzV4Hcdu74zW0Zzg+p47uvwRpSJO2vwf3Ai+WYOy5z35Gh4+Jf3FEU1H804NsV7TBnsRomYtc9ajx/c6oS5USGyMoNCmYZrktn/SuysD95LIHgr5mfBG0sjKi34VRVvD4e0HXkFiZcU3jidYgcL/Q5Vf74J5cl+fkuuy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CA6XhXZN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CA6XhXZN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752096150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aL54sIPg8cPhtA0mcCe14CWBI0dZilMODedXc1EluMs=;
	b=CA6XhXZNoe5FZlT/XzO6Nz3VnFQ/PJYQ6d8SLcXffJutOHKMTGaBrQZz+R2U99eX4gBGwq
	TJF1L8j0hRZOkY2O+59zzTliFWfn0tP4LxTcyTZsuHRGf6XKcnnk7SFcvQwHhE2tVcRUEa
	1/UTFiI5YRFGdExVH2CHdZWfnRgvW48=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-UBiY3ilcM0uFG4FFg0ZCdw-1; Wed,
 09 Jul 2025 17:22:26 -0400
X-MC-Unique: UBiY3ilcM0uFG4FFg0ZCdw-1
X-Mimecast-MFC-AGG-ID: UBiY3ilcM0uFG4FFg0ZCdw_1752096145
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0560218011CD;
	Wed,  9 Jul 2025 21:22:25 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.44.33.49])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4B8519560AD;
	Wed,  9 Jul 2025 21:22:19 +0000 (UTC)
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
Subject: [PATCH v8 4/8] nvme-fc: nvme_fc_fpin_rcv() callback
Date: Wed,  9 Jul 2025 17:19:15 -0400
Message-ID: <20250709211919.49100-5-bgurney@redhat.com>
In-Reply-To: <20250709211919.49100-1-bgurney@redhat.com>
References: <20250709211919.49100-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Hannes Reinecke <hare@kernel.org>

Add a callback nvme_fc_fpin_rcv() to evaluate the FPIN LI TLV
information and set the 'marginal' path status for all affected
rports.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Bryan Gurney <bgurney@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
---
 drivers/nvme/host/fc.c         | 95 ++++++++++++++++++++++++++++++++++
 include/linux/nvme-fc-driver.h |  3 ++
 2 files changed, 98 insertions(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 8787c566f939..210b6d57f76e 100644
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
2.50.0

