Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2571C8FAC
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 17:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594380; cv=none; b=SX9d7kn7lgjbS5l0ngImv9IvT/4aHU93tXndB20d8++FiVR6DyjdE8f33JMEBNI4HhQZp28E1kY3LP02QVYP80MJcGKMoBNEbgGbaWIiN0milYo0W3u3Wj6otyc9WIA9QEWHTy1r0BVTyGSRl3qXzump9T4WsvvRTTBbVY2TFYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594380; c=relaxed/simple;
	bh=7ykx966S4jtDZk/c2VAM0ZDPTRt9EE2FmtqmAWAnXV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tVHEIIHuVaklWODWl0vrkv27QxBp2bBKMZ0Ug5Zfk4cXOUyWnKPpUKzWAtIjMMxxc+QsdaKKfMr/1N1fmhiDzUkcRmCHsaOTpOPp/tDaWq1CTU5FZ4yaA9tZ6uyfddzd7leGXiPecbDQuTrAaKA+bANzswia5Ejm0iwIxo0XZ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KpvVanFT; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KpvVanFT"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7065f3de571so85957b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 10:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594379; x=1720199179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eNPSik58fOB62TXAs3PojLIEX6s0Cwz2LrR2CaqfJY0=;
        b=KpvVanFTFgz+G1EbXxnvcU5NJRszuNIS2XEdhMP8GJOUj4U1gRGmtApW6scIZpvIaa
         5vjez33YgmzVbk+IIukLsQdVDzlzbQHYGvCiIbLfEab/okOytvGW5LNC8znTcUu0842j
         Vbp95uB2aEO2zJ2DhGw9VzvhW1xNEm9ePS1XYMT5sknlu2mR96t9Pu9xrYo0qzO8Wsn9
         X9cqB/vPlWkm2wTRqJjU3eft62DJ8vuwd1/eUxC87slmkuOJB2FP4u0m9J0TMi041YlT
         qj+rryGUsoEqXhwSGNq9Ja5aHz8VTltbivoSgO8FU16ChotUG4ZwZqdmagqPxWnx+mUS
         DUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594379; x=1720199179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eNPSik58fOB62TXAs3PojLIEX6s0Cwz2LrR2CaqfJY0=;
        b=AwlYrNzs3hZiB2EjIAvkFhkw1D57JihYLxNLu2HzSZxK7F74vXi9NC+4bTBPcAMTS9
         HzoKv0a6Pgn6yv6VkETCRt7Nzn6h7PR0qit4CHRL8vzpioAs42dEgLCoWmOPckU6jFzQ
         roovNmmOzXqo+fNZ7Mh7ZqcGIO06zI67FW95ds6+K4nN2Ok3sn9Xz5aD/pHe15sCpCtl
         rNhKMjEbUn6vvVPzEsTnQZ99+FgtOl6EzJhGXbZXGXOo8tiIek/ooRlOxnPzCsXqRSgo
         snpTyAT8hURI/z1WBC7UIRQydcW3JcpFs3qnPQcAo5Nxjt8y7wH8dblz1d6watmHBQ8b
         SaQA==
X-Gm-Message-State: AOJu0YwRDrRtx608L8Y3ym1YHkhF1k7tdIVcUBN+ue3dVE09jKu4A6PU
	EnjED5Skw1Un8m97xItha9DO9/02ZcIYx3Oh5M6uUSZKXmbbYYRF4zOZYg==
X-Google-Smtp-Source: AGHT+IH44dsOA2FU0iRdIJE0V8pJKhqibcYZ7utiKjT+t+kswjJny1LyKOURwydGcgTb6+OJueBXmA==
X-Received: by 2002:a05:6a00:3119:b0:705:c0da:bdc1 with SMTP id d2e1a72fcca58-70667e29347mr18823247b3a.2.1719594378749;
        Fri, 28 Jun 2024 10:06:18 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6afb8ef1sm1524623a12.40.2024.06.28.10.06.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2024 10:06:18 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 4/8] lpfc: Fix handling of fully recovered fabric node in dev_loss callbk
Date: Fri, 28 Jun 2024 10:20:07 -0700
Message-Id: <20240628172011.25921-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240628172011.25921-1-justintee8345@gmail.com>
References: <20240628172011.25921-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In rare cases when a fabric node is recovered after a link bounce and
before dev_loss_tmo callbk is reached, the driver may leave the fabric node
in an inconsistent state with the NLP_IN_DEV_LOSS flag perpetually set.

In lpfc_dev_loss_tmo_callbk, a check is added for a recovered fabric node.
If the node is recovered, then don't queue the lpfc_dev_loss_tmo_handler
work. In lpfc_dev_loss_tmo_handler, the path taken for the recovered fabric
nodes is updated to clear the NLP_IN_DEV_LOSS flag.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 13b08c85440f..6943f6c6395c 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -214,6 +214,11 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
 		return;
 
+	/* check for recovered fabric node */
+	if (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
+	    ndlp->nlp_DID == Fabric_DID)
+		return;
+
 	if (rport->port_name != wwn_to_u64(ndlp->nlp_portname.u.wwn))
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6789 rport name %llx != node port name %llx",
@@ -546,6 +551,9 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 					 ndlp->nlp_DID, kref_read(&ndlp->kref),
 					 ndlp, ndlp->nlp_flag,
 					 vport->port_state);
+			spin_lock_irqsave(&ndlp->lock, iflags);
+			ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
 			return fcf_inuse;
 		}
 
-- 
2.38.0

