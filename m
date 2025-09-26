Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9282CBA45
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 00:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758844959; cv=none; b=NVmBIj1ddEvIt42P4bnFDmGoJkQ7hwt8RmhNC77SKXNitOfPWbZjUwcSqcDE6AtRfS6LwLVkzhOQ3rsZ3rF7IXEU0moCWvkMmU8ftCPJP+8ZFid96agoeZ3kVH+8vZzBD/8m4V3K79sxYK4PYOgQyaizQtm7KBK1vI6+zL2Bpig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758844959; c=relaxed/simple;
	bh=JWdlbySms9Qc2oUd7PtIjt3pdby8pfYpIQ1fKHsCwPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Ic2fDPI0nG4pO92TbMYLC+IZz8ueo6mQz1mr0jyIiynOUbNPNYsFSpRw73Rp+6v1VIK3qMNAQHWFN8SBC9uBG/9mLm+J2aR+gI2OwaXSydNVf1mRL7oQizPuHlnnjdGE28wvnhtVPiC7xuwmgd6zf5uBiaXvDzEkwwTe2DRsPO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=InbclDTo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="InbclDTo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758844956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TDkjAoRJBdXUxgTMVSMDYIqRM8/eOAky5X5DLVa6mDc=;
	b=InbclDToDfkK9TOJeqoeWRIKWjNth9ikV9+xI7nyyQefc6nGFGXWi0eJ+A6XEc/iEPR5vx
	ItqzBhjqljoLFsmksYJu6VFYctetDLxwMNK/uIVSWwelUuYgIvLm75ivXV6yJLe0q1JCO0
	2dScEMH6WtD/aWWat9irtqORvlpMX04=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-1rVTFlLwNQ-VSrBvwAPVMg-1; Thu,
 25 Sep 2025 20:02:33 -0400
X-MC-Unique: 1rVTFlLwNQ-VSrBvwAPVMg-1
X-Mimecast-MFC-AGG-ID: 1rVTFlLwNQ-VSrBvwAPVMg_1758844951
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AABB19560B8;
	Fri, 26 Sep 2025 00:02:31 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen7.rmtusnh.csb (unknown [10.22.81.200])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 99E391800579;
	Fri, 26 Sep 2025 00:02:28 +0000 (UTC)
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
Subject: [PATCH v10 07/11] scsi: scsi_transport_fc: add fc_host_fpin_set_nvme_rport_marginal()
Date: Thu, 25 Sep 2025 20:01:56 -0400
Message-ID: <20250926000200.837025-8-jmeneghi@redhat.com>
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

Add fc_host_fpin_set_nvme_rport_marginal() function to
evaluate the FPIN LI TLV information and set the 'marginal'
path status for all affected nvme rports.

Co-developed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Bryan Gurney <bgurney@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/scsi_transport_fc.c | 81 ++++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_fc.h |  1 +
 2 files changed, 82 insertions(+)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index f31fdc840191..4dc03cbaf3e2 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -25,6 +25,10 @@
 #include <uapi/scsi/fc/fc_els.h>
 #include "scsi_priv.h"
 
+#if (IS_ENABLED(CONFIG_NVME_FC))
+void nvme_fc_modify_rport_fpin_state(u64 local_wwpn, u64 remote_wwpn, bool marginal);
+#endif
+
 static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
 static void fc_vport_sched_delete(struct work_struct *work);
 static int fc_vport_setup(struct Scsi_Host *shost, int channel,
@@ -873,6 +877,83 @@ fc_fpin_congn_stats_update(struct Scsi_Host *shost,
 			   &fc_host->fpin_stats);
 }
 
+/**
+ * fc_host_fpin_set_nvme_rport_marginal
+ * - Set FC_PORTSTATE_MARGINAL for nvme rports in FPIN
+ * @shost:		host the FPIN was received on
+ * @fpin_len:		length of FPIN payload, in bytes
+ * @fpin_buf:		pointer to FPIN payload
+ *
+ * This function processes a received FPIN and sets FC_PORTSTATE_MARGINAL on
+ * all remote ports that have FC_PORT_ROLE_NVME_TARGET set identified in the
+ * FPIN descriptors.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+void
+fc_host_fpin_set_nvme_rport_marginal(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
+{
+	struct fc_els_fpin *fpin = (struct fc_els_fpin *)fpin_buf;
+	struct fc_rport *rport;
+	union fc_tlv_desc *tlv;
+	u64 local_wwpn = fc_host_port_name(shost);
+	u64 wwpn, attached_wwpn;
+	u32 bytes_remain;
+	u32 dtag;
+	u8 i;
+	unsigned long flags;
+
+	/* Parse FPIN descriptors */
+	tlv = &fpin->fpin_desc[0];
+	bytes_remain = fpin_len - offsetof(struct fc_els_fpin, fpin_desc);
+	bytes_remain = min_t(u32, bytes_remain, be32_to_cpu(fpin->desc_len));
+
+	while (bytes_remain >= FC_TLV_DESC_HDR_SZ &&
+	       bytes_remain >= FC_TLV_DESC_SZ_FROM_LENGTH(tlv)) {
+		dtag = be32_to_cpu(tlv->hdr.desc_tag);
+		switch (dtag) {
+		case ELS_DTAG_LNK_INTEGRITY:
+			struct fc_fn_li_desc *li_desc = &tlv->li;
+
+			attached_wwpn = be64_to_cpu(li_desc->attached_wwpn);
+
+			/* Set marginal state for WWPNs in pname_list */
+			if (be32_to_cpu(li_desc->pname_count) > 0) {
+				for (i = 0; i < be32_to_cpu(li_desc->pname_count); i++) {
+					wwpn = be64_to_cpu(li_desc->pname_list[i]);
+					if (wwpn == attached_wwpn)
+						continue;
+
+					rport = fc_find_rport_by_wwpn(shost, wwpn);
+					if (!rport)
+						continue;
+
+					spin_lock_irqsave(shost->host_lock, flags);
+
+					if (rport->port_state == FC_PORTSTATE_ONLINE &&
+							rport->roles & FC_PORT_ROLE_NVME_TARGET) {
+						rport->port_state = FC_PORTSTATE_MARGINAL;
+						spin_unlock_irqrestore(shost->host_lock, flags);
+#if (IS_ENABLED(CONFIG_NVME_FC))
+						nvme_fc_modify_rport_fpin_state(local_wwpn,
+								wwpn, true);
+#endif
+					} else
+						spin_unlock_irqrestore(shost->host_lock, flags);
+
+				}
+			}
+			break;
+		default:
+			break;
+		}
+		bytes_remain -= FC_TLV_DESC_SZ_FROM_LENGTH(tlv);
+		tlv = fc_tlv_next_desc(tlv);
+	}
+}
+EXPORT_SYMBOL(fc_host_fpin_set_nvme_rport_marginal);
+
 /**
  * fc_host_fpin_rcv - routine to process a received FPIN.
  * @shost:		host the FPIN was received on
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index b908aacfef48..e8d46b71bada 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -852,6 +852,7 @@ void fc_host_post_fc_event(struct Scsi_Host *shost, u32 event_number,
 	 */
 void fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf,
 		u8 event_acknowledge);
+void fc_host_fpin_set_nvme_rport_marginal(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf);
 struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
-- 
2.51.0

