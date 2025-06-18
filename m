Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB5A2F4A1B
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272982; cv=none; b=GHVqQE5kFyWgKx7qVKRQ92/tWbUGCpbi3LhTnMEd/yrOU2HX00py5L0EizdkdcnhW6EQbl4om15qmfRbFFuwUrD8HBRBnVPKQM65fnHq8Csa5Su1nfk+hOEuEiFaAEpwJVwDv1vAKvFyOx6VEmTK0Yf7f35x32UqF8yArwxhjVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272982; c=relaxed/simple;
	bh=b6upBSWil8TlqPqaEUQFivfjO1JqUtUF2BBt4NtaVA8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Frv9vuoCc1AcBxVUVpm/353HvxB3PFm4tMbx+vbpDDvUQnc5zAduPLz9y5dQ0zLBjTlmN93+HxjeVUGhpeig2jhFsKy9+HmRSpXLc9fPDi/OpJkSFVVQ+VrusWVlNaOlQrRr5VfQChhM+O82YseqWNoJ1FOMAcOMO/u2bdl4iXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JgjAsGhy; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgjAsGhy"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b31d592bbe8so17504a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272980; x=1750877780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gfe8HMGDOV0pUwlOj8Fg6C2oGtQvtYruI6/AOBsOHzE=;
        b=JgjAsGhytTfk64RyaOP0K3wQScbbs1XkTfYQRaue98i1k6VKEw9My5TYyJZ4Q56IF9
         6T3zYXHq7Swvut3C/BmzKR3NefnVmjGoqvgrSBK0GKPTXIx28nKE+aPS3DF3fSF6+iG4
         2/s4aY68zpc4q3R7fyiaWT8dQ1hh90639VtfNLWAPc2M7nOaYLv0hQ2+Wz3cNxIiNAsM
         0PTCUq/y0Y45Q52FsEqulonvBE37uqkAfL4VgPxi0JVDWXv6FPCgqozc5VzW63yhaXOi
         mjRXNQtVoBd1hcIoxKPK4XgEQQJX7EcklHbxXPCFlyx8ZZ6Ya0eZdbiId6GIYNhp4X4P
         Xf4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272980; x=1750877780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gfe8HMGDOV0pUwlOj8Fg6C2oGtQvtYruI6/AOBsOHzE=;
        b=e5Ly0o/so+jKc5bedSjae9FxGvpOZOSBrAg+czfW1aV3vBe/dO+Rzmz2z0EfcI7Phc
         hiIMysPGngPOMHrudYxAdFr7DSbLkXVWw6DvrSNUlrDJz2/Fzmdb0yaiiXdLueHxYIFG
         OZSFeQ7iJyaqZTiTlS3ob8ViNqBdY5q4a78r4jKSpLEOw03LqztnQb1X32+49SMJ7aWI
         ke55TQT9fy6k22E6EUs1TM4LGrPx4sx4pFSdQR/ltzirgUs2NU1zEf/jwLoSwK2lvNdA
         XoIlbiAMif8UMOuMBycCcH0YW2BaOgqBhu+gB65um384V97oh+rnOWqJJGBRv6+IBTuG
         pdTw==
X-Gm-Message-State: AOJu0Yy5ZiZW4seWYxESp1FMrgU3OZ3RAgzHBO48LiEFPJxwN7RIxt/6
	fo/gawjTHKI69DDMPUFga8MAQ+Jn9q+bA5Lofk7mVBBP9YsrVos60A/LD0gCyg==
X-Gm-Gg: ASbGncsVBOAQfdZ9VzueMqVkYQQqCzoHCmKejQPGsL2vJR+Bua5YLYDHNfwwVO4fiF7
	s5N3ZljM0BAAG0yi+WU6tKzZNlME+uMT01WTiSDZJOzRnMDrZP1EqpvHnYVpdMf8NpaUkHNRMFl
	2+WJhM2d9+buYp2F+ROo3OBa3o8eG7mPV/oSAm95AaHoi0/FplzRGaSQf3QXx8n+rZr8OerNDLQ
	pAd127MT/5kQPrErt+zjXPtl+zOXb7le2MRkIBIUARu6KJ4U3rv0RJzOuu2ZwpsU1QSn3aEjaYW
	ttY0E/cKrHnEIFLiD3SGeJwQfkXp0s29IbCGRBvqCUWWYn84UsSfK2X+xaT01hoqqLX/ulEryQi
	3Tsy2/S3yxItZS1V6WcsJlkm4uhTgpVOzkWiEDaDeDDFz5lc=
X-Google-Smtp-Source: AGHT+IF+fkiFWmlD5sH5hhLaKngNO5Hpv2J8xPp2lcv1S29nWSp28SBzMXO+vMv4L0z/dWLpfKnYlQ==
X-Received: by 2002:a05:6a21:348b:b0:21f:39c9:2122 with SMTP id adf61e73a8af0-21fbd505f8cmr33818463637.2.1750272979967;
        Wed, 18 Jun 2025 11:56:19 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:19 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 10/13] lpfc: Revise CQ_CREATE_SET mailbox bitfield definitions
Date: Wed, 18 Jun 2025 12:21:35 -0700
Message-Id: <20250618192138.124116-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250618192138.124116-1-justintee8345@gmail.com>
References: <20250618192138.124116-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CQ_CREATE_SET mailbox command's bitfields are updated.  Rename the
cqe_cnt and separate high/low bitfield names to help resolve confusion
between two similar bitfield definitions.  Corresponding usages of the
newly defined bitfields are updated as well.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  | 18 ++++++++++++------
 drivers/scsi/lpfc/lpfc_sli.c  | 12 ++++++------
 drivers/scsi/lpfc/lpfc_sli4.h |  2 ++
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 2dedb273b091..dd9f170fbdc8 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1328,6 +1328,9 @@ struct cq_context {
 #define LPFC_CQ_CNT_512		0x1
 #define LPFC_CQ_CNT_1024	0x2
 #define LPFC_CQ_CNT_WORD7	0x3
+#define lpfc_cq_context_cqe_sz_SHIFT	25
+#define lpfc_cq_context_cqe_sz_MASK	0x00000003
+#define lpfc_cq_context_cqe_sz_WORD	word0
 #define lpfc_cq_context_autovalid_SHIFT 15
 #define lpfc_cq_context_autovalid_MASK  0x00000001
 #define lpfc_cq_context_autovalid_WORD  word0
@@ -1383,9 +1386,9 @@ struct lpfc_mbx_cq_create_set {
 #define lpfc_mbx_cq_create_set_valid_SHIFT	29
 #define lpfc_mbx_cq_create_set_valid_MASK	0x00000001
 #define lpfc_mbx_cq_create_set_valid_WORD	word1
-#define lpfc_mbx_cq_create_set_cqe_cnt_SHIFT	27
-#define lpfc_mbx_cq_create_set_cqe_cnt_MASK	0x00000003
-#define lpfc_mbx_cq_create_set_cqe_cnt_WORD	word1
+#define lpfc_mbx_cq_create_set_cqecnt_SHIFT	27
+#define lpfc_mbx_cq_create_set_cqecnt_MASK	0x00000003
+#define lpfc_mbx_cq_create_set_cqecnt_WORD	word1
 #define lpfc_mbx_cq_create_set_cqe_size_SHIFT	25
 #define lpfc_mbx_cq_create_set_cqe_size_MASK	0x00000003
 #define lpfc_mbx_cq_create_set_cqe_size_WORD	word1
@@ -1398,13 +1401,16 @@ struct lpfc_mbx_cq_create_set {
 #define lpfc_mbx_cq_create_set_clswm_SHIFT	12
 #define lpfc_mbx_cq_create_set_clswm_MASK	0x00000003
 #define lpfc_mbx_cq_create_set_clswm_WORD	word1
+#define lpfc_mbx_cq_create_set_cqe_cnt_hi_SHIFT	0
+#define lpfc_mbx_cq_create_set_cqe_cnt_hi_MASK	0x0000001F
+#define lpfc_mbx_cq_create_set_cqe_cnt_hi_WORD	word1
 			uint32_t word2;
 #define lpfc_mbx_cq_create_set_arm_SHIFT	31
 #define lpfc_mbx_cq_create_set_arm_MASK		0x00000001
 #define lpfc_mbx_cq_create_set_arm_WORD		word2
-#define lpfc_mbx_cq_create_set_cq_cnt_SHIFT	16
-#define lpfc_mbx_cq_create_set_cq_cnt_MASK	0x00007FFF
-#define lpfc_mbx_cq_create_set_cq_cnt_WORD	word2
+#define lpfc_mbx_cq_create_set_cqe_cnt_lo_SHIFT	16
+#define lpfc_mbx_cq_create_set_cqe_cnt_lo_MASK	0x00007FFF
+#define lpfc_mbx_cq_create_set_cqe_cnt_lo_WORD	word2
 #define lpfc_mbx_cq_create_set_num_cq_SHIFT	0
 #define lpfc_mbx_cq_create_set_num_cq_MASK	0x0000FFFF
 #define lpfc_mbx_cq_create_set_num_cq_WORD	word2
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 372907debbe0..a8fbdf7119d8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -16477,10 +16477,10 @@ lpfc_cq_create_set(struct lpfc_hba *phba, struct lpfc_queue **cqp,
 			case 4096:
 				if (phba->sli4_hba.pc_sli4_params.cqv ==
 				    LPFC_Q_CREATE_VERSION_2) {
-					bf_set(lpfc_mbx_cq_create_set_cqe_cnt,
+					bf_set(lpfc_mbx_cq_create_set_cqe_cnt_lo,
 					       &cq_set->u.request,
-						cq->entry_count);
-					bf_set(lpfc_mbx_cq_create_set_cqe_cnt,
+					       cq->entry_count);
+					bf_set(lpfc_mbx_cq_create_set_cqecnt,
 					       &cq_set->u.request,
 					       LPFC_CQ_CNT_WORD7);
 					break;
@@ -16496,15 +16496,15 @@ lpfc_cq_create_set(struct lpfc_hba *phba, struct lpfc_queue **cqp,
 				}
 				fallthrough;	/* otherwise default to smallest */
 			case 256:
-				bf_set(lpfc_mbx_cq_create_set_cqe_cnt,
+				bf_set(lpfc_mbx_cq_create_set_cqecnt,
 				       &cq_set->u.request, LPFC_CQ_CNT_256);
 				break;
 			case 512:
-				bf_set(lpfc_mbx_cq_create_set_cqe_cnt,
+				bf_set(lpfc_mbx_cq_create_set_cqecnt,
 				       &cq_set->u.request, LPFC_CQ_CNT_512);
 				break;
 			case 1024:
-				bf_set(lpfc_mbx_cq_create_set_cqe_cnt,
+				bf_set(lpfc_mbx_cq_create_set_cqecnt,
 				       &cq_set->u.request, LPFC_CQ_CNT_1024);
 				break;
 			}
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 9be3da91c923..e42b44fcc7f6 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -575,8 +575,10 @@ struct lpfc_pc_sli4_params {
 
 #define LPFC_CQ_4K_PAGE_SZ	0x1
 #define LPFC_CQ_16K_PAGE_SZ	0x4
+#define LPFC_CQ_32K_PAGE_SZ	0x8
 #define LPFC_WQ_4K_PAGE_SZ	0x1
 #define LPFC_WQ_16K_PAGE_SZ	0x4
+#define LPFC_WQ_32K_PAGE_SZ	0x8
 
 struct lpfc_iov {
 	uint32_t pf_number;
-- 
2.38.0

