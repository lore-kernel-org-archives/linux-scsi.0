Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882D513BC3F;
	Thu, 28 Aug 2025 04:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756356022; cv=none; b=RaG5e95lHfkJb4EzyZzkxVdYhr1GKBUTpEwJvwrwyEWe11EGCbTSeUvAvvo6mGFe0ByGhxUkhqKWnZQC4EBNNlMnPnhm12fvR9qKsQ9FPWbFgbYpmNamUKSqihsajaQn51ecwBuufliPYDt8bS1yO/c/9jWQbzIU+2PylcuWbqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756356022; c=relaxed/simple;
	bh=EprYMS7hj8izs5KOEZoOZxUbWLd46yXqkjI1puJA5/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VbS+SK0TWJ/Mxp+kf6ajnLY7iMY+Upr1YsqgqRnBU/sWPiYFZbrcM3GZJ9TYHBvUWt2pyQga0LFWkMbRan460vsvuJLddSUTNulKa4l0nMGyDlZIghfCzAS8g5v8XdULes+fPuLY6BOtyr/GczHy+o1oupVyQUo5k0CygAIks0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZaqEZNNP; arc=none smtp.client-ip=209.85.215.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZaqEZNNP"
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-b4c5467617dso551217a12.1;
        Wed, 27 Aug 2025 21:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756356020; x=1756960820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/1FbmeMJrwmv+p89A8rbgWWowNF8958qVntUHwO7+EI=;
        b=ZaqEZNNPlkCLAO4U0SXNmDV4J9/SaClNrx+m/4mYOat1waZZaAYQitv/MiJz9TDhZ/
         WCPL2kdOPAvOfR7UQPqBqsqGaoHWYr7jgeK5RLYHQQS7ex5mTUN/lEf51NBZK14pfvuW
         VEs0zchwTpNPXnJ8VRBGZyUksVAKPbs3QfxXhs4hyP2QGmwADGEuQkHegXVTGFut5DuP
         bBCsxRryigqPT1nF8wSdBJzaQrI2JZU2govOKAIFj02OxU2LBnV0yJiXNMhdAaXTzHLx
         DlsM0qNfMqDUEtVTFgt7oEi/6t5h7NH14Roz5iqjsPyQoumjEnrGD+/pIz7ruB1CN6WB
         +gAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756356020; x=1756960820;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/1FbmeMJrwmv+p89A8rbgWWowNF8958qVntUHwO7+EI=;
        b=UPoUXP6K8hVDdj4r+sBRSPTkPbXitl8WBJJch8AdcrrhhD3kFBq+MwEFJmKT6NLyaE
         akWlCkMAWIpoiGuqokYadkdsb4VKkqcAAYO+r7W4pVKmBAVjr3V+dvqwZ2S74DPLqIkx
         xT2M/xjZQtydXF0cxhYm5Nt7s0wNxx5nDj8v2sH62qZba1G8O9Ewr4TgHentBGx+E+v2
         yoRR83+3Wqi3Ij0+RkGhrgTM4+uzzWd1jSZMTIC5d9SCuljrMGxqFotrCQ3nvXmjBwpn
         j/mAAhqfb1tWv2pH2JjrVvPM/nLl89DNclYeRxIquqULmufMLgLW60AjetAKK1Ajku+Y
         HO/w==
X-Forwarded-Encrypted: i=1; AJvYcCUF4U8vPKO3QUmhSfJTmhQnjG3Bp2yyVhZdzN31ckXcjoi7PL2beurTHa401ChmzlEEnjBnuQNqwqhwoL8=@vger.kernel.org, AJvYcCVW8gzisn1KffY0rtLw5m/TSh6TPUfOhkuGNH4FiPwtiHd+TvTPAo2cAyfHq8xqGt0bmYR/JExV@vger.kernel.org
X-Gm-Message-State: AOJu0YzfhmeNEKAVKk9KvGHbcogrIMr/SRV2F4iK8B44j8bXw5YhDtEO
	7aR4vpmdUMs9eJRkvKLVKsNvr/stLSpAaCXL3zltpRCQr0UtWH5npCew
X-Gm-Gg: ASbGncuoYMidji5D37BrijQMzVd+6fgxB0m/iszvEciOc4taCvllUp33guQ//g0A5OR
	6fKSub7RH/SZTvL2m0ebzIIeH/YGAKvvE8r4KLjwSinOXTdQ3yKcugsSHSZ04KISt78nxjai2Rm
	ZjC7j+YSNSfBna+fey9KW9DC2Q2SjwCANFkrBTkscRroCZDj4nlKPe33uah+GYlzsDCwU9ltM/S
	YbqLT/gF+j9ze5F9D1SyZ7sgFMDBre93M7R5xUtc0TQYZmipepkrCKllODtOsTIpR901uRIMBip
	92cMEqPq7fUMFaX+Nt2bLsl9Iyp2g8isK6tM/k6aEfzwsNOVzFLb4LbX1wwxidkFaB7h2MDtCkA
	RDly9BSuaHrZbWXl2PCaupu/ghtZbvTnmCF47/E+6aM3E9LF/Vtl3eNaaP6LBTaROSVRSG/jPnZ
	CAdnW2zcTpow==
X-Google-Smtp-Source: AGHT+IEP1TMhgc2sfEgNwFmxmDOy/Miw4UKnS0rMvZzojwu7hGcM0OKpcNCnt1LcGiWVsu/79ksTyw==
X-Received: by 2002:a17:90b:48c5:b0:325:8f58:f4d1 with SMTP id 98e67ed59e1d1-3258f58f6f6mr18806594a91.29.1756356019741;
        Wed, 27 Aug 2025 21:40:19 -0700 (PDT)
Received: from 2045D.localdomain (56.sub-75-229-200.myvzw.com. [75.229.200.56])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3274572be3bsm3482835a91.2.2025.08.27.21.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 21:40:19 -0700 (PDT)
From: John Evans <evans1210144@gmail.com>
To: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	justintee8345@gmail.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] scsi: lpfc: Fix buffer free/clear order in deferred receive path
Date: Thu, 28 Aug 2025 12:40:08 +0800
Message-ID: <20250828044008.743-1-evans1210144@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a use-after-free window by correcting the buffer release sequence in
the deferred receive path. The code freed the RQ buffer first and only
then cleared the context pointer under the lock. Concurrent paths
(e.g., ABTS and the repost path) also inspect and release the same
pointer under the lock, so the old order could lead to double-free/UAF.

Note that the repost path already uses the correct pattern: detach the
pointer under the lock, then free it after dropping the lock. The deferred
path should do the same.

Fixes: 472e146d1cf3 ("scsi: lpfc: Correct upcalling nvmet_fc transport during io done downcall")
Cc: stable@vger.kernel.org
Signed-off-by: John Evans <evans1210144@gmail.com>
---
v2:
* Rework locking to read and clear the buffer pointer atomically, as
  suggested by Justin Tee.
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index fba2e62027b7..4cfc928bcf2d 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1243,7 +1243,7 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_target_port *tgtport,
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct lpfc_async_xchg_ctx *ctxp =
 		container_of(rsp, struct lpfc_async_xchg_ctx, hdlrctx.fcp_req);
-	struct rqb_dmabuf *nvmebuf = ctxp->rqb_buffer;
+	struct rqb_dmabuf *nvmebuf;
 	struct lpfc_hba *phba = ctxp->phba;
 	unsigned long iflag;
 
@@ -1251,13 +1251,18 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_target_port *tgtport,
 	lpfc_nvmeio_data(phba, "NVMET DEFERRCV: xri x%x sz %d CPU %02x\n",
 			 ctxp->oxid, ctxp->size, raw_smp_processor_id());
 
+	spin_lock_irqsave(&ctxp->ctxlock, iflag);
+	nvmebuf = ctxp->rqb_buffer;
 	if (!nvmebuf) {
+		spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
 		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_IOERR,
 				"6425 Defer rcv: no buffer oxid x%x: "
 				"flg %x ste %x\n",
 				ctxp->oxid, ctxp->flag, ctxp->state);
 		return;
 	}
+	ctxp->rqb_buffer = NULL;
+	spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
 
 	tgtp = phba->targetport->private;
 	if (tgtp)
@@ -1265,9 +1270,6 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_target_port *tgtport,
 
 	/* Free the nvmebuf since a new buffer already replaced it */
 	nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
-	spin_lock_irqsave(&ctxp->ctxlock, iflag);
-	ctxp->rqb_buffer = NULL;
-	spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
 }
 
 /**
-- 
2.43.0

