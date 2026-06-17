Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9CB33B6EF
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2026 18:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781720503; cv=none; b=ceVsPJBN8S5KRKz+fiygPI5tIYM2hcMh5saQ1U0FaY27UOLxDidYgEoizUoHHqItwGUZfJr9XnDKJlLcTJY3Dj8xFA4wCHjZrfKI1Q3+I9Vy0t+pCka5l5fuH5Tk9ZMVKhF2H/wQ58OO8vGfyMyWgyMnU4JSx82zdwQANNEO8ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781720503; c=relaxed/simple;
	bh=XNwyF/irvPyjNnKCbPr5vGhL7Z+UfsTTfXWN8q0I23Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UR+QXpuR9WhINQ7vdOIBf06Mm/aeegTJ0pN2kwub9jc4yzHUjoR3kBEsyzvlxmYg01pivvbrtoR83K4/LPJ2fbd7gTTi+zGBscmN7Oq7taVa4ZGRlf1Zk+Yk63F81943kmlJmyx+1Hb7D/FrWp/talb9IrP+N+I5yw3Peay6HDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cKpDxA1J; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cKpDxA1J"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-13807d2f898so117734c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2026 11:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781720501; x=1782325301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=bRVXRuL3SokNbQhryzhuBG+QpU0mVRqeo7dUwoex+3o=;
        b=cKpDxA1Jteu5Oz2zUBuAqjLmCcWvx6gfyIKgBqLNM4j+eqd+tasqGCKs0qqt98OlQt
         1KiYQSAumuJITQPgO57WdBLoK/SrCOznxsRoE5Taeem1pY+wMNOAh+FW9Fuc0aJSxAjJ
         4dxJ7oRY6ZOmfxXSvx7tnNW2PH5MQrUuatRALu/TlsBQIOuMx9Occscg8w80nNDISTw+
         Glx2ndQxsNIt4UggieqpoU+faXn523RPPHEXn/dsir5Y3H84l1RWflXOoN+peS3SMTWa
         hpqYa8ruSimCYL9LLHHhcercEJqPq6nlCyGy6Q2xklFZR7X0nI3OYghWDKL+kqgoba2P
         d88A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781720501; x=1782325301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bRVXRuL3SokNbQhryzhuBG+QpU0mVRqeo7dUwoex+3o=;
        b=eWwMjOU5szClEP8unUK+NXRi79GG3ipKBTGdhs0w5R2+VgByj/5O4Nbt4mI9SeNmFo
         NNEMBTT7gcQEVWjvZ5/SfDHFL8nwIx17qeEGGOEPY7AkzMg/00M3zCwjikYs6+7I+XI3
         +JMInVzGeqqxAn3wuk4kYTPa8uk2J9TJL/JQllDLFobrt2Tv3KTNUDoxgtEYBj9KakII
         Kg5hUmnVMvjRUFMgBmtLPYMsL3IB8YXiPlZMZ9tVBgnteLS5fBFxVFB+vgeMCa24mJjL
         o0AkwnQUMubESKv5K89xYxC8llT3Jvsq4Vgs0p74Mdk8JxSKpf/xfYymeXOkgYM+NEgJ
         mEGQ==
X-Forwarded-Encrypted: i=1; AFNElJ8dxXx6TZMPjwJ9lV32mioVWFHatQLI2uD5A92Fr+8xw98+/RbFJ+l3K6zvKUMdRAdtlxxcl6S5yG+/@vger.kernel.org
X-Gm-Message-State: AOJu0YwCWPEmsroVKhttBhc/Dl2BROs9MAxEmIkhsl9aXkOxYmIAEzFd
	fQkotsVKgkP5sxQfQY7ROzRBPxvPltbwcB/rUMoDPgo1w7BbWXm4iIVI
X-Gm-Gg: Acq92OEJ9coc3oclQEmBuweubs0Y5o+z0ARgteJp3+jm0UjD1FOkbp+npg7cVeMuJNl
	UvZDT8/aq3Mo1znPvkjXoFBOk/V85qKc569/pFwsPnsS32TipuOCxfZjHDJtJIj5ggZ1I2uEoer
	qoQhgLBhAUXnKu6s4Eci4Oh+3hyd4mhoe+E7gRnOj2wm54Eke1NlGyZlXVmsjeSFG12NeL0tcCK
	h1b+KtQSCka0xHonnWyBKxMSBRsA9tSixvUdxEGpt7gge4Yqe1zY4AgYXmYBdTpj5RunUN0BvQQ
	XT0K2eFezk+rUXSMAEgF2J1MEA7waWuq8qpclEbFrQ/b+j+xd9txTqp1ANDhkjZgrXMWQXzB4d3
	7ChCUMJbw8CTPxpN1mlHHI63pP4QfXSj5hqql8Sjj+HV5eeStb0dxE+RnVrOrHAbA5pZJNGdMgT
	b4xuW8yEG+oHXNWtXYWRtRbzU/pheh4ZJg
X-Received: by 2002:a05:7022:497:b0:138:4e43:6399 with SMTP id a92af1059eb24-1398f65477cmr1906421c88.11.1781720501367;
        Wed, 17 Jun 2026 11:21:41 -0700 (PDT)
Received: from haichao.tail057a43.ts.net ([2001:da8:e000:1206:1886:6b7a:3e78:272c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1386f20ad25sm15683154c88.0.2026.06.17.11.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 11:21:41 -0700 (PDT)
From: Ruoyu Wang <ruoyuw560@gmail.com>
To: Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	open-iscsi@googlegroups.com
Subject: [PATCH] scsi: iscsi: publish endpoints after transport setup
Date: Thu, 18 Jun 2026 02:21:33 +0800
Message-ID: <20260617182135.957230-1-ruoyuw560@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iscsi_create_endpoint() inserts a new endpoint into iscsi_ep_idr before
transport drivers have initialized their endpoint-private data. The
endpoint handle is returned only after ep_connect() completes, but handles
are allocated from a predictable IDR and iscsi_lookup_endpoint() looks
them up directly.

Reserve the endpoint ID with a NULL IDR entry, add
iscsi_register_endpoint() for the publish step, and call it from the
in-tree transport drivers after private endpoint setup has completed.
Until registration, endpoint lookup keeps returning NULL for the reserved
handle.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c    |  6 ++++++
 drivers/scsi/bnx2i/bnx2i_iscsi.c    |  4 ++++
 drivers/scsi/cxgbi/libcxgbi.c       |  6 ++++++
 drivers/scsi/qedi/qedi_iscsi.c      |  4 ++++
 drivers/scsi/qla4xxx/ql4_os.c       |  6 ++++++
 drivers/scsi/scsi_transport_iscsi.c | 24 +++++++++++++++++++++++-
 include/scsi/scsi_transport_iscsi.h |  1 +
 7 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 8d374ae863ba2..1abb2bc695923 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1188,6 +1188,12 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		goto free_ep;
 	}
 
+	ret = iscsi_register_endpoint(ep);
+	if (ret) {
+		beiscsi_ep_disconnect(ep);
+		return ERR_PTR(ret);
+	}
+
 	return ep;
 
 free_ep:
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 6c80e5b514fda..2c84b4864e240 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1914,6 +1914,10 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	if (rc)
 		goto del_active_ep;
 
+	rc = iscsi_register_endpoint(ep);
+	if (rc)
+		goto del_active_ep;
+
 	mutex_unlock(&hba->net_dev_lock);
 	return ep;
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index ea9631bfe2e23..c1b2a401ddca3 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2937,11 +2937,17 @@ check_route:
 	cep->csk = csk;
 	cep->chba = hba;
 
+	err = iscsi_register_endpoint(ep);
+	if (err)
+		goto release_ep;
+
 	log_debug(1 << CXGBI_DBG_ISCSI | 1 << CXGBI_DBG_SOCK,
 		"ep 0x%p, cep 0x%p, csk 0x%p, hba 0x%p,%s.\n",
 		ep, cep, csk, hba, hba->ndev->name);
 	return ep;
 
+release_ep:
+	iscsi_destroy_endpoint(ep);
 release_conn:
 	cxgbi_sock_put(csk);
 	cxgbi_sock_closed(csk);
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 6ab3a989d2817..60c37566f768c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1014,6 +1014,10 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		goto ep_rel_conn;
 	}
 
+	ret = iscsi_register_endpoint(ep);
+	if (ret)
+		goto ep_rel_conn;
+
 	atomic_inc(&qedi->num_offloads);
 	return ep;
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d598ab4126f80..8b30620d0e8dc 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1749,6 +1749,12 @@ qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 
 	qla_ep->host = shost;
 
+	ret = iscsi_register_endpoint(ep);
+	if (ret) {
+		iscsi_destroy_endpoint(ep);
+		return ERR_PTR(ret);
+	}
+
 	return ep;
 }
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 8aa76f813bcdb..a8c2a32c0f134 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -217,7 +217,7 @@ iscsi_create_endpoint(int dd_size)
 	 * First endpoint id should be 1 to comply with user space
 	 * applications (iscsid).
 	 */
-	id = idr_alloc(&iscsi_ep_idr, ep, 1, -1, GFP_NOIO);
+	id = idr_alloc(&iscsi_ep_idr, NULL, 1, -1, GFP_NOIO);
 	if (id < 0) {
 		mutex_unlock(&iscsi_ep_idr_mutex);
 		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
@@ -257,6 +257,28 @@ free_ep:
 }
 EXPORT_SYMBOL_GPL(iscsi_create_endpoint);
 
+int iscsi_register_endpoint(struct iscsi_endpoint *ep)
+{
+	void *old;
+	int err = 0;
+
+	mutex_lock(&iscsi_ep_idr_mutex);
+	old = idr_find(&iscsi_ep_idr, ep->id);
+	if (old) {
+		err = -EBUSY;
+		goto unlock;
+	}
+
+	old = idr_replace(&iscsi_ep_idr, ep, ep->id);
+	if (IS_ERR(old))
+		err = PTR_ERR(old);
+unlock:
+	mutex_unlock(&iscsi_ep_idr_mutex);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(iscsi_register_endpoint);
+
 void iscsi_destroy_endpoint(struct iscsi_endpoint *ep)
 {
 	sysfs_remove_group(&ep->dev.kobj, &iscsi_endpoint_group);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 76de2b662f4fb..96299d25e0f73 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -459,6 +459,7 @@ extern void iscsi_get_conn(struct iscsi_cls_conn *conn);
 extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
 extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
+int iscsi_register_endpoint(struct iscsi_endpoint *ep);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
 extern void iscsi_put_endpoint(struct iscsi_endpoint *ep);
-- 
2.51.0

