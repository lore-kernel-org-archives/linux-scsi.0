Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153D23085C7
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272966; cv=none; b=qEdd3XkJt6mtzr8Hyu0BJpFb//nBRfoJH37TQviFJQTPCXkqFBUaI/odmNg/5u3NAyendLyj7jgxC19zWx/n47nW/KgGXKNet4M+jVSn3tfE3fqNnAqseU17196CzuEr/ZoQj675/nsqoWBKAvIn6DLLr7TsVbd1doh+wXY7Ems=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272966; c=relaxed/simple;
	bh=lQhx/GQyAvXB8rzpmY2qaYPXFL5//8+un3i47QBd8mE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EM38cw7FgODklJrZ8sAvpaQlPmHFn87knJ1UX3pPs5lLVgilRREi9fM2jN1eOy8ulU8IXgzgM/VAhm1UK0O4MJWf5bNw28nMsklgOw1q7x2qKnh53HPxIKKUCUX7s0N5n5+AxApcrvCuA6bIehQv2LAy/ppNmu86d2vUStSEY/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X/wDC4qC; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X/wDC4qC"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-748ece799bdso663972b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272964; x=1750877764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CznToGtqOPBKpf9CB9vaRUX4VWDh2Fd0bnDiBWcCsoU=;
        b=X/wDC4qC705iD8Xo5DbQwfekDHsJXodtFUV5L8yTtipAXi0AMTDlyayJqjVzhTbNkt
         LPQkjth49OjcqwYAN5l5LMnXrK7TCF5XoWbFNQz/MIx7dStcA7OcSUZMY+a7IqFDgVlT
         //pVf0Pa0TM3nFfHSYf/WqvEYCoUIxtULazoHZ1i0WeTVKDi9Hi8b55RPU4S6wOrbwVi
         DfxNoIkWeDFqVxfrSedBT4fNVtnaW+aYvMfDgVgLdwr2JB1Hdbj05RaJ/P9nrZ3sgFaT
         VRKLdtwbgvNda2kdjeqRSw4XzQs12PWTguOCb2JxGz60jHYGXYA02Bi8upq2JjFEGsfK
         jJ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272964; x=1750877764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CznToGtqOPBKpf9CB9vaRUX4VWDh2Fd0bnDiBWcCsoU=;
        b=lL6ETM32YaG6M+8DHKMpAGaMUu6aW5qrsWieRWaJibILhbs5++pnYJGIKXgL6PJvMN
         +3saTqMn95cdndZG6v/nOF67FNw/d+ywNZAZ+3eWsWne8nZwqNJdphgYHY5laKb0NlC3
         WfQv06puBX+mhLl29tGYI9X1WVdXBE834aJtqzxfW7HWO4TTlajRIxuOKoyUPN/lGlfy
         yrlU7wedDjbKA4n2bAz32vQgBzXGij8/cc+FV4b4mPvJwCv6Iy6l3OaQXeLAO8yCxf63
         yxARdWVJlbjA9JiKJzEgcqRP8hULiz3CkTUBk7RQ2bWUd+B0J+icGzbFzNwZjvIOAyjr
         RSJQ==
X-Gm-Message-State: AOJu0Yx4WyIe+cS3zLP7CXvSzQPIN4bDrn25KBICrQqwB6UO/s8e8yyw
	/1egmJRam33PjTKUM+QJ42eeEPBejt4NF5jVuuh8tPT9BCivGjA9+cZOD2dljg==
X-Gm-Gg: ASbGncvJAne8JfWtmBy63Jr5glosWJvc8Fhhm1nIFhmHc6bxjAsnlMxTQ00KTGWTPHM
	Uokruqn/mFq1q/FAYQnBjoYssmodt4jPgDvOlxKHXrS/zjmenhP+lcQRierLB8reoOAtaJfMcDq
	AlRnwkYFozBh1m1FoaHazyx0lgx3zMsZukAPbcQxfeuE31pRftXvSWpqQIdKd4wGhSIormcoYKU
	snenbUMzG8cjdz3DzsWcQh5Wtl1jqIEzykgm9nTtGBCcgrLFrGNPAD6VGGNd7gskaoTS2V3NL+B
	2jNVXSveSwrfOE3x8d7uyyqlNESTl7ny34Rx80nU3xpel5URBJuBM9clL7PwD0CnxCI4nqbbyUk
	yhh4FepgY0a7GW1qk3QDnoxoIchyvDuNsA5XGugXAghLPJlp9UcrdiePTAA==
X-Google-Smtp-Source: AGHT+IE57exwsLgX5L3L1bn55sjA1gFuOEtpguxnHfpxsMQ49rNHNLruggiTdECNHl+GOzCuTTxfbQ==
X-Received: by 2002:a05:6a00:895:b0:746:3025:6576 with SMTP id d2e1a72fcca58-7489cfbb642mr25628950b3a.14.1750272964233;
        Wed, 18 Jun 2025 11:56:04 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:03 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 01/13] lpfc: Revise logging format for failed CT MIB requests
Date: Wed, 18 Jun 2025 12:21:26 -0700
Message-Id: <20250618192138.124116-2-justintee8345@gmail.com>
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

Unsupported and rejected CT MIB request log messages are changed to
KERN_WARNING level.  Also, remove extra space in log message.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 530dddd39bab..a88099b6e713 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -264,9 +264,9 @@ lpfc_ct_reject_event(struct lpfc_nodelist *ndlp,
 ct_free_mp:
 	kfree(mp);
 ct_exit:
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-			 "6440 Unsol CT: Rsp err %d Data: x%lx\n",
-			 rc, vport->fc_flag);
+	lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+		      "6440 Unsol CT: Rsp err %d Data: x%lx\n",
+		      rc, vport->fc_flag);
 }
 
 /**
@@ -313,7 +313,7 @@ lpfc_ct_handle_mibreq(struct lpfc_hba *phba, struct lpfc_iocbq *ctiocbq)
 
 	mi_cmd = be16_to_cpu(ct_req->CommandResponse.bits.CmdRsp);
 	lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
-		      "6442 MI Cmd : x%x Not Supported\n", mi_cmd);
+		      "6442 MI Cmd: x%x Not Supported\n", mi_cmd);
 	lpfc_ct_reject_event(ndlp, ct_req,
 			     bf_get(wqe_ctxt_tag,
 				    &ctiocbq->wqe.xmit_els_rsp.wqe_com),
-- 
2.38.0

