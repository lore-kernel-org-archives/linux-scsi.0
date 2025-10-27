Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A02332900
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 23:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607458; cv=none; b=FYmLMn8YFBnMtm059XDM1s0LgoeS/9svqhxWcHtOY0Mq+MHR1BXR8nlTFNqtEVAybX34HRriYe+9h/Q5UjwojrskhNC+D9TgljxAaz67DnFD7KyjRhrcNSVJc7qNhLbnjYNNlFYEKnLrjGRu5KQTXMFeu614m7XTAQgZF4r1WKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607458; c=relaxed/simple;
	bh=YyqVxMaLxSx1P7g3vYPchFcmojYWQFtTwazLY9SVv3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jTE9jpJG0Kpy5JrwOE//uFJmxee+0CzwxKKVzlwndhF6DEabk+lZ1SulXA5Z+qcqsZlQtd2XwmuvjstW84k37lGZActeoBqW43iRD/N4MSjPsWZiN8Qst01MQREI+PBpcbF1/N3FwbrasB8qZyzAFdnQqKXhAXJKX9s2GVdyBY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k7+8FmOa; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k7+8FmOa"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b550eff972eso3557576a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 16:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761607456; x=1762212256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4W6kfCVar4+rDyptzE7f4aOEi/jvPZboeqUprxFiiWo=;
        b=k7+8FmOas3+Bp/Y96J1bmZX6k2kv1pa6ZQ3gt0W3Oy5vaahaMfv4yMA+ez7vbOFsJG
         EYiq/VlUkM0v2ZsxwfCZSnhC1RCu/4QD7xKFZluDpdu06pF2JmFjbSuX4eJHsjJkNfxT
         PJEVd7CIhu2WlqqGhYMS/itzWPdGyqRy4RiEXxtqqxXiJkvEie+JbfJgX11YHJAa6g3u
         wpGADP+p7HM5+iw6k9ySc0AGYcPxQn7ynj03zecB5XLDuCQjWBv2ZSqslXAU/niEyaE9
         sQNMwWFQ+Wk4T5tFf8EmtKe8mRz02pp/9le3752kyx88OKhe4b7PEA/pK4M3KD8TZP1N
         TNTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607456; x=1762212256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4W6kfCVar4+rDyptzE7f4aOEi/jvPZboeqUprxFiiWo=;
        b=tMBnbAkEQlLQu+mL2pN0tJoJqysfNFnnxvN1gQH9T3V+nsJnGRk9+QZM/tA6aBSfJ8
         UEMhqjtFXLMSiETqDF55FKP9EAIhYPAR5N1xcjn1XyEG7frlDhJexB7Wf4lcDcbJ5hv/
         Ox1YgZcnVW+cpU6+6V++Zbgo8DQh9oKDR/W+Pn7cbNz/ZwOis9MDvc27lUvQIwtuuuzX
         m0RaJPJqlpLrDa0bXl8IfFcn8sHBYihW2A59alAOCdOio8B2Vvqlc84Och4A/kXQ7ohb
         SI7++yas5ltltFSOcYxD2d+9ZnPXpyvPWwnr7T1YCNgxfUu4AsAhQhT4Xad/02fNGdfs
         9b5g==
X-Gm-Message-State: AOJu0Yz0moQGKOlk0YXpYhwgL4SzfgLcBx1Zyc03EGo4c1OY2hXERj6t
	hadQWE4W7SvRBFZOGZD6zk1JIqCJeSjOTtdqfFf9hCLwTGilMKYlyIS5gWOwmg==
X-Gm-Gg: ASbGnctuLYPCd47b9EQDDsB61P/VI8o3r1JQJW3Rt6PhCBQnFbSGzlT6yD7gO26mzgn
	KRvyN69+84vfMEAtsz1bpg/7OQ3pB0f8xQvKJkpx6/06Y5BLZAKyp8qoL184ojixdeHXyneDWtt
	QZUOkNgVIyknSKAaWqEiPDbl9eyVk+3wZjq+S6AmxMewDz18yIfsvMfBP2GrV61DDwtvRa7rq3q
	AXc87vziYZ4ri0Z8++G6Dlfv3phhInCJe9XA0ntMI5FT9SikRjsOaVz6aeCfQJ9xvPNXnUwzwFI
	3pgwFz48eQ0FFtKktEBnxU7bGajYs7qxITVrhtqpZv5oC0UGgWhamJtZ4uM+TaKbWVyFWGK1KRH
	MDfNDiMpjtXqzpjsC/skZEMS2T6P00dNVTTPt9b+zFt4tyXszzil8qG4TpZHMF4HTq7h7Lfy+LL
	v2DrQMhL8e4BDytUroD1v6wl+VAMOHpAV2fHObabZuYaucXcRHh9nV2OJKpws9
X-Google-Smtp-Source: AGHT+IGnDRNXon7+CUclqocLzMbmsP0678KkxwWtH5zu6UCcQGGxk+GG+PgABSSHoia1uW4ebwRkGg==
X-Received: by 2002:a17:903:18c:b0:24a:fab6:d15a with SMTP id d9443c01a7336-294cb37fbf8mr21497215ad.20.1761607456169;
        Mon, 27 Oct 2025 16:24:16 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e41159sm93805855ad.91.2025.10.27.16.24.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:24:15 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 04/11] lpfc: Ensure unregistration of rpis for received PLOGIs
Date: Mon, 27 Oct 2025 16:54:39 -0700
Message-Id: <20251027235446.77200-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251027235446.77200-1-justintee8345@gmail.com>
References: <20251027235446.77200-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unregistration of an rpi object should be done when a PLOGI is received as
PLOGI receipt implies an implicit LOGO.  Previously, the driver would
continue using the same, already registered, rpi and ACC the received
PLOGI.

Replace the ACC and early return statement with break to execute the rest
of the lpfc_rcv_plogi logic outside the switch case statement.  This
ensures unregistration and reregistration of an rpi after PLOGI_ACC
completion.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c       |  2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 17 ++++-------------
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b4aba68afb66..8552b24b45a1 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3263,7 +3263,7 @@ lpfc_reg_fab_ctrl_node(struct lpfc_vport *vport, struct lpfc_nodelist *fc_ndlp)
 		return -ENOMEM;
 	}
 	rc = lpfc_reg_rpi(phba, vport->vpi, fc_ndlp->nlp_DID,
-			  (u8 *)&vport->fc_sparam, mbox, fc_ndlp->nlp_rpi);
+			  (u8 *)&ns_ndlp->fc_sparam, mbox, fc_ndlp->nlp_rpi);
 	if (rc) {
 		rc = -EACCES;
 		goto out;
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 1e5ef93e67e3..a6da7c392405 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -452,18 +452,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 */
 		if (!(ndlp->nlp_type & NLP_FABRIC) &&
 		    !(phba->nvmet_support)) {
-			/* Clear ndlp info, since follow up PRLI may have
-			 * updated ndlp information
-			 */
-			ndlp->nlp_type &= ~(NLP_FCP_TARGET | NLP_FCP_INITIATOR);
-			ndlp->nlp_type &= ~(NLP_NVME_TARGET | NLP_NVME_INITIATOR);
-			ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
-			ndlp->nlp_nvme_info &= ~NLP_NVME_NSLER;
-			clear_bit(NLP_FIRSTBURST, &ndlp->nlp_flag);
-
-			lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb,
-					 ndlp, NULL);
-			return 1;
+			break;
 		}
 		if (nlp_portwwn != 0 &&
 		    nlp_portwwn != wwn_to_u64(sp->portName.u.wwn))
@@ -485,7 +474,9 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		break;
 	}
-
+	/* Clear ndlp info, since follow up processes may have
+	 * updated ndlp information
+	 */
 	ndlp->nlp_type &= ~(NLP_FCP_TARGET | NLP_FCP_INITIATOR);
 	ndlp->nlp_type &= ~(NLP_NVME_TARGET | NLP_NVME_INITIATOR);
 	ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
-- 
2.38.0

