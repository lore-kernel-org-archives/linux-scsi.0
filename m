Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BD848381A
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558444; cv=none; b=Os82tylH35umoFqh5f/HrIb5vJ8kVpVrHUYNdq6mpW2T32/dJSEIjyzlIdiKqOy8IGC/TYKxIFydq6wq50XcVSboKG/89vu9kAKc5l76tIOYKilWii9gy29Nu/0AurR0cdrgxzlpCck5twumkvxaPKDZoZoS6twBNzyUQyvaB1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558444; c=relaxed/simple;
	bh=pizTKV9ynX6GILfJMYJeYpCEDVQFQ+vn/3t4N68wIWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wls8BX+20jP37+q+MlsZaM9DbFG9BjbkSQZTP2aZ9xMOCPy96OKO4eEHFiW8XUWiCqRInwXqCceyrPSYenngJtIJ1/klUqUsaV51Ko8+jz/ONvoY7OxdS9LFTbyO1rCbip6LLu3He/Z0t9JHM7oMe8TqB+5V8kblRiorur+T/B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cbRS6B+p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cbRS6B+p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786558442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B/EY5HcPxvHeK+xCdsYclzRmUx+RUOMbGT7U9T+HvrQ=;
	b=cbRS6B+p/QQiXAmPC/eSNyBR+uQJDdoua7rT/JuYP2MokBEeK1uj8q5LNFd3czaDenAdZy
	dB/KpGlFZ9L/1MEfCXflmlXOm3L6Q5OcdD1PDfbDPyWTP8fo26scm3Ia0olz9Mq2mewTnK
	iQG/zq3egbSvS5icOv3MLhsuOtg2Dao=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-320-UzlbJ97wMXCuYR0ti4JcOA-1; Wed,
 12 Aug 2026 14:13:57 -0400
X-MC-Unique: UzlbJ97wMXCuYR0ti4JcOA-1
X-Mimecast-MFC-AGG-ID: UzlbJ97wMXCuYR0ti4JcOA_1786558431
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3952D1954B0D;
	Wed, 12 Aug 2026 18:13:51 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.88.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 742CC18005BB;
	Wed, 12 Aug 2026 18:13:46 +0000 (UTC)
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
Subject: [PATCH 07/13] scsi: scsi_transport_fc: Add set_rport_marginal to fc_function_template
Date: Wed, 12 Aug 2026 14:12:54 -0400
Message-ID: <20260812181300.3712426-8-jtaubepe@redhat.com>
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

Add fc_fpin_set_marginal function to evaluate the FPIN LI TLV
information and set the 'marginal' path status for all
affected nvme rports. Then call set_rport_marginal() callback added
to fc_function_template.

The implementation of set_rport_marginal() is almost identical to
set_rport_dev_loss_tmo implementation.

Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
---
V10 -> V11:
 - New commit
 - Replaces scsi: scsi_transport_fc:
    add fc_host_fpin_set_nvme_rport_marginal()
---
 drivers/scsi/scsi_transport_fc.c | 20 ++++++++++++++++++++
 include/scsi/scsi_transport_fc.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 02c58f4591d8..df1edf3c23fa 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -737,6 +737,25 @@ fc_cn_stats_update(u16 event_type, struct fc_fpin_stats *stats)
 	}
 }
 
+static void fc_fpin_set_marginal(struct Scsi_Host *shost, struct fc_rport *rport)
+{
+	struct fc_internal *i = to_fc_internal(shost->transportt);
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	if (rport->port_state == FC_PORTSTATE_ONLINE &&
+	    rport->roles & FC_PORT_ROLE_NVME_TARGET) {
+		rport->port_state = FC_PORTSTATE_MARGINAL;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		if (i->f->set_rport_marginal)
+			i->f->set_rport_marginal(rport, true);
+		return;
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
 static void
 fc_fpin_pname_stats_update(struct Scsi_Host *shost,
 			   struct fc_rport *attach_rport, u16 event_type,
@@ -764,6 +783,7 @@ fc_fpin_pname_stats_update(struct Scsi_Host *shost,
 			if (rport == attach_rport)
 				continue;
 			stats_update(event_type, &rport->fpin_stats);
+			fc_fpin_set_marginal(shost, rport);
 		}
 	}
 }
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 9f30625aa0d3..bc7c3f832399 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -684,6 +684,7 @@ struct fc_host_attrs {
 struct fc_function_template {
 	void    (*get_rport_dev_loss_tmo)(struct fc_rport *);
 	void	(*set_rport_dev_loss_tmo)(struct fc_rport *, u32);
+	void	(*set_rport_marginal)(struct fc_rport *rport, bool marginal);
 
 	void	(*get_starget_node_name)(struct scsi_target *);
 	void	(*get_starget_port_name)(struct scsi_target *);
-- 
2.54.0

