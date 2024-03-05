Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF325C619
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668156; cv=none; b=q1sL5THmnxWLTgMCbc4T+eho6R2Odz92PZ/gIULDFEPKap+u53RPsLXrwuGZPjIvYH07Hk39aqmIfI+1iLVL3navWV3E9U0MOEMnLpJBlifQLtjTWPldd9HmutbjTWYprwUIBLVz/s3wHLSjFEElAevbXSxM4K+n1G3n45wqCOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668156; c=relaxed/simple;
	bh=Q07MdBdKVlbXJ86h7SfnZqBGlLoVo5nTMXLB67kNfdw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=icpqsPIDRZXivmJhBxJt3/DdQDhUyVpL7eeDO+bQwLnDjIQb+Sk2tlpDZaELqfQqXUcDOOToYmuBicYH2vTmztQEj4DTRPUBIwhOu6UN+uoaR+eWhTJ5iybQ10FvsD4VCrRWSNp2qEPeMYDiR7vtL0X8IePn19nMPel7jBVIS6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fmdXz3Hn; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fmdXz3Hn"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-788251ac2f5so16309285a.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668154; x=1710272954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6is7PSVKtUCYDKW89JTJS1r+ufWKPOZqQX0DmMUwnCg=;
        b=fmdXz3Hni/F5wgW4idhDFMjKd/dWbaQG5HjvzRwnGH0MvxfJI5kVWmcMI5Xb1t8p3p
         2wpIrFbbSPxVvMhuj9MnyIcMe7irw16EGgG4xicVlCMYN4WvXiEmGOsB1fzkUdU/kmLc
         TFnU4O1p7hNjnCyliq6QWucnwwu1Ii2SgPQegLYT5ygnbWml4WHhX1NwVzh/gxIeym/6
         s7FdkSTROhHq3rsJ0v+W6gEKuLIBqc6Kd8X4TA7RdlnisxxOk++Y9DGpAnopcE6DwrwC
         tLNrFAdCf9ZtLSvynjVH6EDDdyvGTkuRODSybu72DTjOvKyDapeJQmADfEBqMVnnqCVX
         CIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668154; x=1710272954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6is7PSVKtUCYDKW89JTJS1r+ufWKPOZqQX0DmMUwnCg=;
        b=DPVpPeH1a+4qMpruCKQKwoKkyOPyF3Z1kNIdfsPAvOERiKp9YfCfj5GrbOwF4+f+kk
         6GKkEeGe2Myx4en1Lyg2JnetPhdpEkUI3Ym1Y1/H6n6gkhXtqhyol7AmbDOrwQsG0dVM
         CPBSnWmIMTWdrLbPnrr7PjgMJ/oqjKy+JpP5teYhEmCxRRm7WeHWae+oTR2ggGoH7Zq2
         KnaehgB0mtsjIeSP7XlCdLHXPV2Wj/jY1ED8em3hiUleXw6Yo1va16DxW9w+FRn9Stoj
         K3kQ4CovgOOmXgxdnbF2dS+J6XO/SzYtkrHDYKSSjWdTU5h2U9haCzPRZlu2BmMn2TbB
         kTZw==
X-Gm-Message-State: AOJu0Yz9ctim/NuJTRG+ACndBz+pDoQsm59SfIQnpvEIn0gmjkQ9G3su
	ynxxzGV//XNkvfbVs0w4JTHwIc2oF6xtWwt2HdGNIaRR4CZtlGXUU6Y+wdt2
X-Google-Smtp-Source: AGHT+IFhS0Pt1jV+AeoEcDawrjqU6/olzLdQdTjalfk1Rj71WSzSas2AjrIUZKG999qlzTMIzO9H0A==
X-Received: by 2002:a05:620a:17a4:b0:788:3c9c:53ee with SMTP id ay36-20020a05620a17a400b007883c9c53eemr331697qkb.6.1709668153973;
        Tue, 05 Mar 2024 11:49:13 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:13 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/12] lpfc: Replace hbalock with ndlp lock in lpfc_nvme_unregister_port
Date: Tue,  5 Mar 2024 12:04:56 -0800
Message-Id: <20240305200503.57317-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240305200503.57317-1-justintee8345@gmail.com>
References: <20240305200503.57317-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ndlp object update in lpfc_nvme_unregister_port should be protected by
the ndlp lock rather than hbalock.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 09c53b85bcb8..c5792eaf3f64 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2616,9 +2616,9 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		/* No concern about the role change on the nvme remoteport.
 		 * The transport will update it.
 		 */
-		spin_lock_irq(&vport->phba->hbalock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->fc4_xpt_flags |= NVME_XPT_UNREG_WAIT;
-		spin_unlock_irq(&vport->phba->hbalock);
+		spin_unlock_irq(&ndlp->lock);
 
 		/* Don't let the host nvme transport keep sending keep-alives
 		 * on this remoteport. Vport is unloading, no recovery. The
-- 
2.38.0

