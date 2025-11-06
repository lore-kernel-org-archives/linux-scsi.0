Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61CC23185D
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467348; cv=none; b=qjkigF1NCAIuLi37k0fzSQONSIZjhFudTcjZc2Up7dPcwqcqgOZ6cJ4BVpvjgrZs81gVXfN4ybLvzilzEP4HQb7omkWXlTi6dEI4hLzfKM8kY0BsrhVw1l6fRT3MQbKYX5y5dVWcUwXPrdzpGw+nH8pypB7QrhgJKacJ3A1TAyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467348; c=relaxed/simple;
	bh=YBE0n3VfzMMBvSL0Ms21KS0uDkCNiFb+3dgcijaNHQk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l4TuuiaUTesTrkTj7wsjiOkVOOFtOsEaZRJd3KWB91WcRpp1Gdrup4pny/X7m58f0D0vxYHXGLyd2tLfaWbpPHydBmqpElODwBkNxe7S/T6ZZgQg7PNxWmtS3AzTw973lARyIf11Bv1fITCNNXGsfVEzP7eQQxL8tP+CE/dDd7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G+kvqUMT; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+kvqUMT"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso186323b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 14:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762467346; x=1763072146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WPq9YFBJKsrnGjBVfFIxObD14+GUnIGwtTfff61Bl48=;
        b=G+kvqUMTfLKuG0TUXYmenayBEMaxYKUp6E2xmx6++YUmKAeHOXhXPRbx9jxcUkzQUJ
         Jeah56wXaUs1zx3cx4dUrf7VyzHa9CeryLBq6eDO5mw9vFkXi8RATSKFHmj/XgxH+XE1
         yIcznBhJlPrWZiM/pQpQEn9SVXzmi2ouKSf5wIavGhLCy3d7WcdCb69cgQFVFvYcQr70
         jjRM2ljxY4o6eYOgj67WAbSZuqFIKGBgDV0ZzvGVMmCVgNWKaR7sV5nMw3CcwlBUUv7h
         g1v6gH6KSYWCQYmPqxDh79Kr2XoaC9aH9DChAG4vHFUKQPR6/S5dEEn6aimjAUTfOPxi
         5xzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762467346; x=1763072146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WPq9YFBJKsrnGjBVfFIxObD14+GUnIGwtTfff61Bl48=;
        b=PqC0mOOnIw6mSK3oTMjqRsEKuwT8FdaIAGqS4jQoRs9TS1GN7D6hru23Ed4mjMulaN
         VojW25gziFITJtcpAoovQ5RI3bGIkl+0eUzpzTXKognWAsG05EGC0Gow2dWbG2xczgIk
         FJQDO4Fcii+2BdJo3YgHRkPhfduO+zcFvnaFiH7tY3So30aA9zgWdBlWS4IggpCAmatv
         go7lPxCwPhjJAd77w9ijfL+bocZyXJrrMSwbj3GrKJ4YHZw48tRKhDTGoM9z4amM4jPR
         Z0ScLSgFOHGQH51bcCnsvj97wpmren8xgRYCrlPdLGtVlWR8dQuaEzp5oOg9dkvxtsFd
         pyLg==
X-Gm-Message-State: AOJu0YwiswUTH7oQbOeZuFi6o01yC6J1jHhys3P0/dHyTrV3danWsorz
	V/doNBiMoCIN3kSXHlCSNg8AZtYbsbzax3dxikkvaPEusqSj9bN2uheNgI9+ePfP
X-Gm-Gg: ASbGncuCIGqpvWpWy04PX/qMst1VZ2AeuR0w7ygIV+nTgx/I5MAr3trNfegV+9bQMKj
	nFefi6eXrIA6RQmC/1d96yf8GfdyoCnwe553/LSk1GRLiKcLHJTTHGTlRyuEvftQenhWrBz5mn4
	BHh0zR8J72xHQEqih/YV8sTjPBkcfxNvengMK6k0Nfzpr/DK/KafgrwG2UhP+PBeuzqPhRkcee+
	Rwyp4qaJgf+EMa7k8srIDBuvTQtok3F9uXIjmMaSo3Ia0zD68fOXvx7qqyQFMkJEZrDbmJkVpgU
	PH6YZQRn8WM0EZnW7BC6ByuoDzf4+tchFMdegYnZQihBSMazwyiPQ2ab2MIUTJZQr/T8G28etCx
	fHfoO05vrdJwa9XgN7bt6LhVZnmYeMU8GIN8XOqavd1ZzFqFK1NaebFYxxOMJk6tFARDcmk9emW
	iTfMqJ8Vmvnqwb31/cpKV3YjN+MaJao/l8llyGim9nyVDdf3rT2N+gjZMwXEP4+SXiUZ8L1zk=
X-Google-Smtp-Source: AGHT+IFcwKSckd5xtOd/aKIO+Jd1yRH542pWlfq4PVzqjaaMhe17USFvKETB5pmArY0t8NhIygcMQA==
X-Received: by 2002:a05:6a21:6da4:b0:350:5b75:6959 with SMTP id adf61e73a8af0-3522ae75c45mr1321171637.32.1762467345852;
        Thu, 06 Nov 2025 14:15:45 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccc59de7sm568901b3a.65.2025.11.06.14.15.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 14:15:45 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 04/10] lpfc: Ensure unregistration of rpis for received PLOGIs
Date: Thu,  6 Nov 2025 14:46:33 -0800
Message-Id: <20251106224639.139176-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251106224639.139176-1-justintee8345@gmail.com>
References: <20251106224639.139176-1-justintee8345@gmail.com>
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

Signed-off-by: Justin Tee <justintee8345@gmail.com>
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

