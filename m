Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E553B839FD
	for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 21:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714427882; cv=none; b=r/SgdczUz7VdyR2dOs4W+60sJYj0kl8Bix/s7hW7FaiutjxkdL3RlyPj29JmbxTrHhdALTA479Hz6Gg8rbmk6H4er4UkfW2bMbxyVzy2VBydi7ymTYDx2sFqfudr+zqc9NIAkdRQz3JA23AHYMrZxuvzYuzhQ3o3xy7DYbR2qLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714427882; c=relaxed/simple;
	bh=4/NGrURxs+4YuMUYWi6MmQVB/D/foYXwgS61JNoI8Us=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cboYOE03tbV8cxem1fuE6eWygNe1h0IFBCNHAgn/lCxq2Kyu33Qk4BJ8xMqF9BqaREMu8gfkFK1kxh2HJldA8zwZLiR5WW0s0Cg79dvH/XrDQGxcYkPga92+0ZyoNhsPAsqSP1ZR4WcR1BqtpWjK+10hCZB8UhBH56FKrx226BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ehIlo51u; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ehIlo51u"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-69b51bfef23so7539606d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 14:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714427880; x=1715032680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y12NMeOCJCqe07W5Gg3LowMTRozzV+tWQ3we1z13pI8=;
        b=ehIlo51uOJHEBPQIe0KUNu0BJwe5icPNkUAfjMhMAzecHizTyN6UX9MzOCwD4WEtVP
         Nw55cT3Jci5Zbw3fGFZxX8glZYoiS3KkfWVUcjTiOLX7qds4jTFso8Gxa+5l1DqUPMKG
         eRsKCGsr0aZYprr8TPCJQcKl0pytSornanGUJFvEM0DqJSOfncaJN92Yy6URioRNkQl3
         YJExBVgNPn7/H43g8fsA/2qugjv3wIVH3wNIn66aN4uHYPeTNbrv9q1MLvgWoyvn2ZsN
         q0gm+qv/HCZ/uMQaYwNceKiYjz5E4GoDVcbJ3XJimaa/SZ5qcnW2ptFtOBuWMgG7DDmP
         ovIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714427880; x=1715032680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y12NMeOCJCqe07W5Gg3LowMTRozzV+tWQ3we1z13pI8=;
        b=Vmm8504R49p05fmAs864BnzXrYvwvVbrh5+ojs78ywnsBF5gBq+62BX6ANhbWOVL2z
         dL0r4wF4/zTr0SKfUCvek8vZ3q+YyH3DocMsvf1j0kN29hkq7PmgYL96sxqt8KymQcWT
         3oZjjPGZmK6OIEjiDORD+nt99Ksn5vRyDWMata08EHgCBOYd6U7CPc4MqCDJgutOTjxT
         0MC2hJ+hHpkkIYN48mP83+oOt1cHk99qFs5ZHxFt0/+O5rbJyrVfZ9Rpcoqo2GiXrlvx
         HnFkuZ9292QEd4w1Y6KMhUCMtUawby8EkP7Il4KY92DQwLIuuvCzzgo5keW0E+15TPXD
         zPDQ==
X-Gm-Message-State: AOJu0YwdXal521oEoVXxX4nVaNB8YOLw0wC9sovAgEiai8S+Yj1DMZgd
	FRFGzIQsxGh6AgkgNCtEeM+c+UJis1AO2FaRd2vRUjuJP8NDchvDwEwh2w==
X-Google-Smtp-Source: AGHT+IG28AAHdPDANray0X7iBIqFyQJYEQeZZ+2rnlukGHDBGoiqD7+OHnfX78JPtTwMT4Dl2GqAGw==
X-Received: by 2002:ad4:5b83:0:b0:6a0:b818:bf74 with SMTP id 3-20020ad45b83000000b006a0b818bf74mr9469089qvp.0.1714427879577;
        Mon, 29 Apr 2024 14:57:59 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mh12-20020a056214564c00b006a0cc9ef675sm1528280qvb.16.2024.04.29.14.57.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2024 14:57:59 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/8] lpfc: Change default logging level for unsolicited CT MIB commands
Date: Mon, 29 Apr 2024 15:15:40 -0700
Message-Id: <20240429221547.6842-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240429221547.6842-1-justintee8345@gmail.com>
References: <20240429221547.6842-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For diagnostic purposes, it is convenient to automatically log unexpected
CT MIB events without the need to set lpfc_log_verbose flags.  So, change
lpfc_ct_handle_mibreq's logging level from KERN_INFO to KERN_WARNING.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 8cc08e58dc05..878e3fffdcea 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -291,9 +291,9 @@ lpfc_ct_handle_mibreq(struct lpfc_hba *phba, struct lpfc_iocbq *ctiocbq)
 
 	did = bf_get(els_rsp64_sid, &ctiocbq->wqe.xmit_els_rsp);
 	if (ulp_status) {
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-				 "6438 Unsol CT: status:x%x/x%x did : x%x\n",
-				 ulp_status, ulp_word4, did);
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+			      "6438 Unsol CT: status:x%x/x%x did : x%x\n",
+			      ulp_status, ulp_word4, did);
 		return;
 	}
 
@@ -303,17 +303,17 @@ lpfc_ct_handle_mibreq(struct lpfc_hba *phba, struct lpfc_iocbq *ctiocbq)
 
 	ndlp = lpfc_findnode_did(vport, did);
 	if (!ndlp) {
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-				 "6439 Unsol CT: NDLP Not Found for DID : x%x",
-				 did);
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+			      "6439 Unsol CT: NDLP Not Found for DID : x%x",
+			      did);
 		return;
 	}
 
 	ct_req = (struct lpfc_sli_ct_request *)ctiocbq->cmd_dmabuf->virt;
 
 	mi_cmd = be16_to_cpu(ct_req->CommandResponse.bits.CmdRsp);
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "6442 : MI Cmd : x%x Not Supported\n", mi_cmd);
+	lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+		      "6442 MI Cmd : x%x Not Supported\n", mi_cmd);
 	lpfc_ct_reject_event(ndlp, ct_req,
 			     bf_get(wqe_ctxt_tag,
 				    &ctiocbq->wqe.xmit_els_rsp.wqe_com),
-- 
2.38.0

