Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6842321ABA3
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 19:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745609083; cv=none; b=GQtcj/oYKUTfjhbWSF47i3QHSTzk0WMuuE7sYbySOH0taTRMSQCxmWVXeBko6esmfLJbSBLeb1Nwxe7M5uMh+NOcCeJMj912th8aM1eaq//VA7vZbCi6i9jjWAw0t3AMmnDPu0t0oD8VId89SsvzWRDjA5xvrxo1JUbCrZc/H1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745609083; c=relaxed/simple;
	bh=qvhsYakX6JgB2wOaL3mli39KS2gONNnAWfe0LGCNydM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QZ71sDQmxGXKzSa402MwbIKm1vt5IArE5OR/qvaBAMYuvFDCBCd07ztUUBsYqk92ttjL+RLjL46/sAnE1KZZTkKBneVXXKeOgH4zBKGM7sLcRjLvcRDdUiQG/o7nUCdp7eyfIHvSVoGm2kDaPCtMArHfWA9dinCCYLxODvkRzOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KMb6C3Ym; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KMb6C3Ym"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-af28bc68846so2711699a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 12:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745609081; x=1746213881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lwLKbuH1u4DOJ4WgIiHlObhAF3vMim37u5MBOFqmh9E=;
        b=KMb6C3Ymk+HUdz/02uDMj0DWiwcLBjn/If4wr2Unb7E/uFA5bM+hBGqrtSkwMPt2og
         mwEHP3W4n6fLT4y8JAsn7A5jB6/fjfWkCCKDkH/YVtKb2GGxXF1hn+cTJzcJ1XmdlDpG
         pNE8Tn06/61jKaJGqvfQzKSpcfkgZ6ztCP1RNBXzsD7xSKerp8y/qfFb/2vBragCvURt
         ol4Z7s4seHaEeo9hMh8Uq9pHb46m+Y9v0pcy4m+lN1EbBOme7A4mjKKTtPzuP2/0Huv2
         +buPiHJJ60TsBaapGCUOkGTiADkB2jhOsmt0oDZMzmmE4XEgwl8sWo8z/69pgBvMfl0S
         grlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745609081; x=1746213881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lwLKbuH1u4DOJ4WgIiHlObhAF3vMim37u5MBOFqmh9E=;
        b=GkO0+cP0aH2KND5ZWuFadOUvnxwNb9eixyp50Q1OXzQdwiR2Mod4SXM9WmywpKX3N9
         AZ9mZZS8gRQV+XrykqVFd/2GRZhkg8MkfK2dv1aaDy12djMmnAkXtpnZBJZFgAEaN1HF
         FmW8YtsYu4LkaedXhEFaIRNrlTvGdiFpif8Jz65iIdVOwn+OmpvT2c9i8BA3VfduZeG+
         4Kk9ZPDGl4aYmQRg8tr0DLLyraqQlt8CEWRntSJCN8QthDzGM7L60FRUypLfE9n8lv9D
         Tkdt4qioI9Wj8KmtMyXFvg+lz99+z4J7G0UhzugTePKUlTwb2jfueF61/wP6hUrkIU8E
         ztAw==
X-Gm-Message-State: AOJu0YwriRl27fkXioZO4JZMmCKcpkOL5kPilTJ5VgNdc4w5bfatE98e
	urWfevyVyaFgdyaq21Lue4LNc9aGYXNkYnROimx3oMGIZ7VpcIWIkt8JOA==
X-Gm-Gg: ASbGncsOV0p1/IdXx7YxVz5oGd+LOjNejISwZ9oGI7JvWiJ1zq13Sk165Z0rywG9bmP
	F+Wh16O3MIst8+fCr43X3NV1oJFLP5zNPrivbNsdF20kCKBxBhs1ogrVPZLwLfGNE9Wrk99ysdm
	Mxv6Jp97nz37jtPeqLQXA+b7xddzvlGUB/xcgYjbhiRCjNvl56AOpfjKF8g2DgH87xhxjzFuZUH
	0hvz/W6cyollkwn1UWERNVFDydULixCrgnvwK94Rv11E0n5VFmzm0a8FsEW+8VYUKemCvtLl8dv
	XXLkZvGJJb+SG+40DUcH/zgMn9u114ALCqa0WSMTSh7QmS7x62TLh/1Uas8APUVf+BHqG1t26kI
	/9Eoxm+8Nj2GTAMfOvmzc/C3VUw==
X-Google-Smtp-Source: AGHT+IFD/JTewTY6S2RStQw3A/FsuJI9bqCf0p0S9M2cW4MMZtV2k3DG6EgAYKIQhaesYqriuF6hmQ==
X-Received: by 2002:a05:6a21:62c2:b0:1f5:8de8:3b27 with SMTP id adf61e73a8af0-2045b6f203amr5696040637.14.1745609081523;
        Fri, 25 Apr 2025 12:24:41 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6a649sm3667513b3a.109.2025.04.25.12.24.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Apr 2025 12:24:41 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 4/8] lpfc: Prevent failure to reregister with NVME transport after PRLI retry
Date: Fri, 25 Apr 2025 12:48:02 -0700
Message-Id: <20250425194806.3585-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250425194806.3585-1-justintee8345@gmail.com>
References: <20250425194806.3585-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A failure to unregister with the NVMe transport may occur when a PRLI is
retried.

Remove duplicate testing of NLP_NVME_TARGET flag. Add a secondary check of
the registered state based on the nrport information.  Further qualify the
ndlp reference count modification when nvme_fc_register_remoteport returns
an error.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 +---
 drivers/scsi/lpfc/lpfc_nvme.c    | 8 ++++++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index b5273cb1adbd..9e585af05bec 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4695,9 +4695,7 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if (ndlp->fc4_xpt_flags & NVME_XPT_REGD) {
 		vport->phba->nport_event_cnt++;
 		if (vport->phba->nvmet_support == 0) {
-			/* Start devloss if target. */
-			if (ndlp->nlp_type & NLP_NVME_TARGET)
-				lpfc_nvme_unregister_port(vport, ndlp);
+			lpfc_nvme_unregister_port(vport, ndlp);
 		} else {
 			/* NVMET has no upcall. */
 			lpfc_nlp_put(ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index b1adb9f59097..9d61e1251a2f 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2508,7 +2508,10 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				 "6031 RemotePort Registration failed "
 				 "err: %d, DID x%06x ref %u\n",
 				 ret, ndlp->nlp_DID, kref_read(&ndlp->kref));
-		lpfc_nlp_put(ndlp);
+
+		/* Only release reference if one was taken for this request */
+		if (!oldrport)
+			lpfc_nlp_put(ndlp);
 	}
 
 	return ret;
@@ -2614,7 +2617,8 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	 * clear any rport state until the transport calls back.
 	 */
 
-	if (ndlp->nlp_type & NLP_NVME_TARGET) {
+	if ((ndlp->nlp_type & NLP_NVME_TARGET) ||
+	    (remoteport->port_role & FC_PORT_ROLE_NVME_TARGET)) {
 		/* No concern about the role change on the nvme remoteport.
 		 * The transport will update it.
 		 */
-- 
2.38.0

