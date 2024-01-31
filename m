Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C873C23B1
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726253; cv=none; b=dp0ytWIpWrsWy5kXlcAqu3g8InWG0GeDiPYf377w6l96lSNLXkcrt7qNOXlg5dmCmW8hCk/M0ycE/JKs3CGsbzO4xDyx0fmzve7uavMQwltqURWDxUdmAFvfUCBLWXA2FgvugQLl/3PiJaEI8ZYhqDywan+O6ZC7/MIj771G9JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726253; c=relaxed/simple;
	bh=ZyEG7dNV7noeSjibWL/PNqSsqcqEK+UhCQ/4lRvsttE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qf8oeg49T+BgYG7JC6s2wVs/tfghxIzCeYjudyvTqjRlxup6HLk+wonoRjaHd14+T9z4UMDVRHeCGFDWC82R6+nmo4BJJzs5Kk9gOFtD9hQLb54K41Vk2mnOAZsPWmyBkZQFh5rlsleZUIo9/RYccDQFUT0GuZgGb5V+UCCOn6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CG+78LkH; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CG+78LkH"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-68155fca099so205556d6.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726250; x=1707331050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WPXnMQ35OYwNhWGkqopxVNUcuap0FITt0rduOYfQkIw=;
        b=CG+78LkHXXQt3LRgPJFwAUXApAVu1nPBYYeUDcw60kpKRbRSmy1w/DhK3hflz2/hUx
         e8TaWm4xXFOnpTeWZjHyp+vhLwS7KtCvdNe/9kagTmDlFngTG06Hwtc9lTO2BwpSKTT6
         V0oTx4c4qByKy3+WQcTy1fNuwe+xmXkDrpCtq7G1pyuxpn4Uq5tppSQMCQh3b8Y1OAW0
         I0w6qJRF8z0ZDNbZu0Km1Taf6t0dSFiVKvRWLMz2LGWPrXGN2+Qb/90zoG1i/GWVRiIu
         3vJBWnIskzP9+D0+9ZIgrBNUHdXK4To9NJgu4eZN3d7J+EfLdtH9FFfGMZBFTnHcRj6V
         HqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726250; x=1707331050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WPXnMQ35OYwNhWGkqopxVNUcuap0FITt0rduOYfQkIw=;
        b=C1FBF6mwNLmgZP72XF8GxytLCj0UhE0dNbP1YSfNLCU8cAVEwI4NRHLu1o+UBT2Xdb
         xFtL7ZbP6/j1Otq5mUiV4p/uQ9+ISlVAwKp5Ttm5tnSWM+bXyQT797KMdZvOmBbqHUoT
         mT1V+otI4NLFqGe3CTKcSXrPKkRELOJXoJ68vzfTZqutMrhYRRUGihf6BeWxGdmnPiqB
         GtBtbTmq7Zi6zqdKux9x8StsiGeMzx/CO/gFRC43hn0bvzSwxaoQlW7MkJsolsxsZRI/
         46gC2WE5ym3ut2Havro/O8kuLGf6QxUbE5fgs5OKRq/MRSNo5n4kVDeMR07etf43AZns
         2c4w==
X-Gm-Message-State: AOJu0YysaN2mLQBTVTtq9vGs1DfUCGMEFP/Auo0jv1Oj507yBWGhKZbb
	LQT4K0V41qJER1L+4iMF5S26J6jy5Ff1JjvJyORlUPblPMusb0wDsR8gT+DW
X-Google-Smtp-Source: AGHT+IE3Fym+SQVQonwMfAckZoH67GN2k8ZyIcpKXhLBGV/PsWv8Cl2yLgAJjVwCvOoBLlACcgsb6g==
X-Received: by 2002:ad4:408e:0:b0:686:9698:a9e2 with SMTP id l14-20020ad4408e000000b006869698a9e2mr289599qvp.0.1706726250196;
        Wed, 31 Jan 2024 10:37:30 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:29 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 08/17] lpfc: Add condition to delete ndlp object after sending BLS_RJT to an ABTS
Date: Wed, 31 Jan 2024 10:51:03 -0800
Message-Id: <20240131185112.149731-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The "Nodelist not empty" log message and an accompanying delay may be
observed when deleting an NPIV port or unloading the lpfc driver.  This
can occur due to receipt of an ABTS for which there is no corresponding
login context or ndlp allocated.  In such cases, the driver allocates a new
ndlp object to send a BLS_RJT after which the ndlp object unintentionally
remains in the NLP_STE_UNUSED_NODE state forever.

Add a check to conditionally remove ndlp's initial reference count when
queuing a BLS response.  If the initial reference is removed, then set
the NLP_DROPPED flag to notify other code paths.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c7a2f565e2c2..29fd2eda70d5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18933,7 +18933,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 					 "oxid:x%x SID:x%x\n", oxid, sid);
 			return;
 		}
-		/* Put ndlp onto pport node list */
+		/* Put ndlp onto vport node list */
 		lpfc_enqueue_node(vport, ndlp);
 	}
 
@@ -18953,7 +18953,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 		return;
 	}
 
-	ctiocb->vport = phba->pport;
+	ctiocb->vport = vport;
 	ctiocb->cmd_cmpl = lpfc_sli4_seq_abort_rsp_cmpl;
 	ctiocb->sli4_lxritag = NO_XRI;
 	ctiocb->sli4_xritag = NO_XRI;
@@ -19040,6 +19040,16 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 		ctiocb->ndlp = NULL;
 		lpfc_sli_release_iocbq(phba, ctiocb);
 	}
+
+	/* if only usage of this nodelist is BLS response, release initial ref
+	 * to free ndlp when transmit completes
+	 */
+	if (ndlp->nlp_state == NLP_STE_UNUSED_NODE &&
+	    !(ndlp->nlp_flag & NLP_DROPPED) &&
+	    !(ndlp->fc4_xpt_flags & (NVME_XPT_REGD | SCSI_XPT_REGD))) {
+		ndlp->nlp_flag |= NLP_DROPPED;
+		lpfc_nlp_put(ndlp);
+	}
 }
 
 /**
-- 
2.38.0

