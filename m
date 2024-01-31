Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CD0363
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660512; cv=none; b=nYovH+gi1GmsY3xXOh1U81T91q6Ksk8MJGI6GWkS4XjOSAukFfptmxHYSSTHw9DoqlQcxq56ZRsjr5kG0zJfgIpfhEYpJGsiL/+CaEA5h0Gac1G9K3BxqNcx5VbsZ/PAdT1UFWIcZ9E5ixvB7RxJXru8EfstFqxi7JLVxBy5B/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660512; c=relaxed/simple;
	bh=27ez7l46OQ5EDPuSrVLB/podSPCjXJKMhlYt1vMOryc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RBBKQ0EEJcd9GfuFV2Jn3TUav/II4OAFkuVUhMVAxlBJUPberMuBRS7IP3ZvZnZ539xs9zIy9J2uoyA+W7c/8rDb+Z39NqM+uci4z5ZSFTkA1IjOdjJ3zwnqIgHJblSQlZuxtYyoxaXprN6MUaRURTBI031QPfiK6ILEzJwp3LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OF7U8rsq; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OF7U8rsq"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4280f3ec702so13104641cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660510; x=1707265310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5YkMNKhf89ZQKnipc+gTJjo6GDA+oFnGwlqZm3Y8nZ4=;
        b=OF7U8rsqfU66lXxMuV8o9iPV6rIXbCOHP5zRu8xEvHM1A8L6S7tSTxXuLBFrPeVN9S
         d/wCQl2QtDIViH9QH5Lxt/nNFvcm/x8y4x4UXC2do2u13Dxdd+cmI+HWwk+Gkffya1jT
         i21+NbhehZidmK3FmrZ6hB5VX7BYh8WmPzNgp8mK49wuJCjkMoiBcOJgg5asDFnyAwEN
         IpSQDL/UKzp49ovw+iFiVDVRSmSuMlToId6l5xrEoCGfbsDzLyNKXhFxeWleYvY9h+gc
         LbCX10en/obh3ZeOwIqWUFRtKiN3UPX4XXc/V8Yznpx9rsKBJuXB5ox3PLSDpTiMgabh
         ZyWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660510; x=1707265310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5YkMNKhf89ZQKnipc+gTJjo6GDA+oFnGwlqZm3Y8nZ4=;
        b=lk5UulcMywjW/cyxEW+zWgXULYlI19Zof3WxxB53LQn9oetFGrYi/nQlznR/hEo7gN
         Svh3f8P9ttR/ewXDCetYeV2a7IgSqhCaoENWJo9pjW9gGxo3cBa+aT9Atlt11yFumj+f
         6JhRzEN2v3I+qcFbCXKlngUcvTEi8ENw+CmHoGz1ZTSU9eQ5oP8erKKfiP8NzT4tyGxB
         kfubCMA0KOxnzxjwwJmRQRZ729rfZZbxQ1fV34CdmAdHcetNKH9jEXxpqiY/ex1rOGC4
         edh0ivUHel+oc62IIHgA0k5KpLtBWDD7VNHcHYnQ1wGggU0RlODCMlQDpm+9fhVs8kXT
         2BbQ==
X-Gm-Message-State: AOJu0YxbgxTt5CPfslvoJOEkxMREHL70Xb44ydFFwu1q8ESOHueHZ/gq
	1wF9WfsHvennFxF6pQFqNWhv0vIgDMqWPmoVq6lieN3VAxj/sq1rG5M9KBsQ
X-Google-Smtp-Source: AGHT+IHlER4Z1Cw3A+nSwo+r0ct7DPiEOeasYhh7Z39awVAXdIrOe7y0xMvhKugQiUDjFPv7gh3o9g==
X-Received: by 2002:a05:6214:3289:b0:68c:6d75:eb1c with SMTP id mu9-20020a056214328900b0068c6d75eb1cmr85798qvb.0.1706660509891;
        Tue, 30 Jan 2024 16:21:49 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.21.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:21:49 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/17] lpfc: Remove NLP_RCV_PLOGI early return during RSCN processing for ndlps
Date: Tue, 30 Jan 2024 16:35:38 -0800
Message-Id: <20240131003549.147784-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131003549.147784-1-justintee8345@gmail.com>
References: <20240131003549.147784-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upon first RSCN receipt of a target server's remote port that is
initially acting as an initiator function, the driver marks the
ndlp->nlp_type as an initiator role.  Then later, when processing an RSCN
for a target function role switch, that ndlp remote port is permanently
stuck as an initiator role and can never transition to be discovered as an
updated target role function.

Remove the NLP_RCV_PLOGI early return if statement clause so that the
NLP_NPR_2B_DISC flag gets set.  This allows for role change detections.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f80bbc315f4c..35ea67431239 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5774,14 +5774,6 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			if (vport->phba->nvmet_support)
 				return ndlp;
 
-			/* If we've already received a PLOGI from this NPort
-			 * we don't need to try to discover it again.
-			 */
-			if (ndlp->nlp_flag & NLP_RCV_PLOGI &&
-			    !(ndlp->nlp_type &
-			     (NLP_FCP_TARGET | NLP_NVME_TARGET)))
-				return NULL;
-
 			if (ndlp->nlp_state > NLP_STE_UNUSED_NODE &&
 			    ndlp->nlp_state < NLP_STE_PRLI_ISSUE) {
 				lpfc_disc_state_machine(vport, ndlp, NULL,
-- 
2.38.0

