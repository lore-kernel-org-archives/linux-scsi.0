Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P2Ztz4Y2"
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02751728
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 14:28:33 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-286bbaa517eso360098a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 14:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701988113; x=1702592913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2dw/OzqGwZkjysrGeEhCwtSMfNOH+tyZrFZAsyHYBFQ=;
        b=P2Ztz4Y2vKrueSjVfTwQMxbj70z1TVA4orsLCV8dA4/9RNJpqzOU0/Z5/fFjHmSB89
         wpqBeLaRrfJJF2PAXo4rkALETnNefuMqG8rgJyNV8NYKqQTnrd2CPk+MCMZsPjfCvm2o
         3nb9jBPlA9vi0yK8GxElvVXfhU+YsdUO9Z5/EDibeg3i1n+N+BqeHPhzuDFXSkG0JSme
         zQ1viz08FatIQC7vcbiRVlFXg1WP0EjRYQb2jV3T4lO1Oaj66ZfP1wXfWM3nioxsQyF4
         xp13IqO6EzpnMFrbmoUUQx3pCyUq2ePSivgAKqGNE19Vba5w4IcITC8p5GUBsEUMdxGT
         7Puw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701988113; x=1702592913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2dw/OzqGwZkjysrGeEhCwtSMfNOH+tyZrFZAsyHYBFQ=;
        b=AaOGi6uJ3azYVGirgarh210htJbMFLALQ7L0CuFE3uz5oQFJP5jywspWRBMfKPcyHO
         wgc/YqOdUSmwOaPSMQycEmh7/HdTqpPAzy5bQGXRBMgnyIW5Z5PyjP44D6v8t0kgv9ZQ
         B9q2PtMuOIRUsfUJyjBevoDv3xMQmvhR46+9O2rKmFovZ6BBmN5DJdQo2d0/Y68+kFAG
         GxWZdwJETJrujQi1hbIkITuuH+dmnsHa+Z79/nvmGxcAo5lFuN4hUKRc4L0a6zmHQRHh
         Sl74VIdo2vQAoh9BHyc4zej2sDxL86SUTbEIZeqhCqHhjIJk6Eo11FQirzZJSzv+ut7K
         Vjbg==
X-Gm-Message-State: AOJu0YwjnRF9q+BWcVmw456MpOWreEdwQdwePPAZEtgg1Ayw2Pww+Jy6
	0C/4iVTtk7unNwzVCywDUJI5qtj9GZd/+A==
X-Google-Smtp-Source: AGHT+IGnAym9tEcXYJ4RIitEnLMCwfd0N7tddx0qh3j7d1Jb/eOGypUhRdfS+pS+UYqxjYDWnFSxrg==
X-Received: by 2002:a17:90b:1d8e:b0:286:5987:f74c with SMTP id pf14-20020a17090b1d8e00b002865987f74cmr6392278pjb.4.1701988112873;
        Thu, 07 Dec 2023 14:28:32 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j18-20020a170902c3d200b001cc3a6813f8sm312417plj.154.2023.12.07.14.28.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Dec 2023 14:28:32 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 3/4] lpfc: Move determination of vmid_flag after VMID reinitialization completes
Date: Thu,  7 Dec 2023 14:40:38 -0800
Message-Id: <20231207224039.35466-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231207224039.35466-1-justintee8345@gmail.com>
References: <20231207224039.35466-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If priority tagging is set in the service parameters of a FLOGI cmpl, then
we update the vmid_flag.  In the current logic, if a follow up FLOGI cmpl
updates its service parameters such that priority tagging is no longer set,
then the vmid_flag ends up keeping stale data.

Fix by ensuring we clear the vmid_flag member during lpfc_reinit_vmid, and
check the priority tagging service parameter after reinitialization of the
vmid data structures.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c  | 6 +++---
 drivers/scsi/lpfc/lpfc_vmid.c | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3b7ed8bca01a..4d723200690a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1130,12 +1130,12 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 vport->port_state, vport->fc_flag,
 			 sp->cmn.priority_tagging, kref_read(&ndlp->kref));
 
-	if (sp->cmn.priority_tagging)
-		vport->phba->pport->vmid_flag |= (LPFC_VMID_ISSUE_QFPA |
-						  LPFC_VMID_TYPE_PRIO);
 	/* reinitialize the VMID datastructure before returning */
 	if (lpfc_is_vmid_enabled(phba))
 		lpfc_reinit_vmid(vport);
+	if (sp->cmn.priority_tagging)
+		vport->phba->pport->vmid_flag |= (LPFC_VMID_ISSUE_QFPA |
+						  LPFC_VMID_TYPE_PRIO);
 
 	/*
 	 * Address a timing race with dev_loss.  If dev_loss is active on
diff --git a/drivers/scsi/lpfc/lpfc_vmid.c b/drivers/scsi/lpfc/lpfc_vmid.c
index cf8ba840d0ea..773e02ae20c3 100644
--- a/drivers/scsi/lpfc/lpfc_vmid.c
+++ b/drivers/scsi/lpfc/lpfc_vmid.c
@@ -321,5 +321,6 @@ lpfc_reinit_vmid(struct lpfc_vport *vport)
 	if (!hash_empty(vport->hash_table))
 		hash_for_each_safe(vport->hash_table, bucket, tmp, cur, hnode)
 			hash_del(&cur->hnode);
+	vport->vmid_flag = 0;
 	write_unlock(&vport->vmid_lock);
 }
-- 
2.38.0

