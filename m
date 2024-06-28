Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825471CD15
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 17:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594366; cv=none; b=KOYw+aaWycWuMvjSh4ZCAmZnCec3XDreS7D+rLcftJIGLSVmDbc3EJRvnpFuRp5f95VbYBud470KvNRbB0UBA+NVGjE+axsXNuGOWK8/aplKFtH41DAnyuJHcBqvv0Wv6ZR7MntlOQYzl/YEw+otLFCwr1J2rPE9oWJX/RBpy5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594366; c=relaxed/simple;
	bh=5lq12J1JAYDsWtjhQDsizdKH3WTVHcLRzHZ73XrM1Xw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NzZS+LYC5UO+P9L/3iH7/AQm8Dh1V+rL7imF2nFQuJ2Dx76uGABbB8u9gJQjji+Ne6QgRKSzDi1M5pntYV1y6k/oiNsoGy3lzJtP1Vu3JEb1xx8URw2ct+bOgQCXLrlOWampMHYNx4sghlVsj4F7skdvGeqotRsrEbTo4/8qtZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FnueQUT5; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FnueQUT5"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7068ca5a807so52525b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 10:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594365; x=1720199165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBmm7sUowrfiMJzmU75UiXhzErerzQHyId7DyLqnbdo=;
        b=FnueQUT5yjRxsgsa//nX0Mi9MwQBJ3I4uG4696d/gagVA+CSGdTuLPXrm9s58jWEet
         e8VORzubHlTHeP5U1sHdT6pEhWRTXYT5MxIeEyXyGMRaz37d4ILR0QpZ31vkpjMTt4ye
         0UYzble+rBgoj6MxQz2oxNZzSsudm/PNXh4lxNDkw5poJzMnR1o4JIDElweuIb1j8DUP
         tXXaOU0GoPaya8FQUsKfntuTYvWk2w/MAc4bAog1BtM57LlOEQj78JGL7GNQBEuFqaeO
         P4FwAUpefy7K48bHa8FrA+yNIf/rvGN208wZcodL8mv1RKh+kQalVE/qjz77ukqhorXq
         ZL3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594365; x=1720199165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pBmm7sUowrfiMJzmU75UiXhzErerzQHyId7DyLqnbdo=;
        b=kfM8fTVIwsekLwG1e6WJqXTjUGFXRV0sWzH4rkWmG2aJJ4lDF4f6qWSoAjTh7cadrk
         egKG3wZKtRg08Dbho5rgkb+VF5yXTZoEOUGPAJwy1hqrFP+UyWOLElPWA5GegcSRYCyo
         9NHbWuq67fLN2bOZWdcWLpUJaJ2owpVoaNpqBhNgltajkJHr6E2jkPUhyH8pp49DWJzn
         MRn7PxrykXulbxEIy8i5oO36HR7zVyneVS/+eUtKAU7EYBuDxOU50fT65r1YdfjSoTDn
         tCpEGfh4tPKIYmoIjFwp6tTxIXIeHRe0i/xZXoMXOvLqunrHMqJtD5zjQlicP5EFr+CT
         c5cQ==
X-Gm-Message-State: AOJu0Yy3FNqfwVBueA3+/X9e+8CQHnPCFTIuIWxFJ1lxKRmtmESaBNVK
	VwZgsuz3wqeg91Cd3BzrZVrxjpmo3ETPyGv4eOPTljTBtORlhuOA2gE45g==
X-Google-Smtp-Source: AGHT+IEpLd3T9Mm6jrVpuhmvlQ+C4oSIgucGtIgldoaVps2lkiEJVmWFfvP3rxzUsxlT8P1AtrvmVQ==
X-Received: by 2002:a05:6a20:3c94:b0:1bd:289f:2ccb with SMTP id adf61e73a8af0-1bd289f63ecmr11015012637.6.1719594364485;
        Fri, 28 Jun 2024 10:06:04 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6afb8ef1sm1524623a12.40.2024.06.28.10.06.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2024 10:06:04 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/8] lpfc: Cancel ELS WQE instead of issuing abort when SLI port is inactive
Date: Fri, 28 Jun 2024 10:20:04 -0700
Message-Id: <20240628172011.25921-2-justintee8345@gmail.com>
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

During SLI port errata events, there should be no expectation that
submitted outstanding WQEs will return back CQEs.  In these situations, the
driver should not rely on receiving CQEs from the SLI port to signal WQE
resource clean up.

Put an sli_flag LPFC_SLI_ACTIVE check in lpfc_els_flush_cmd when walking
the txcmplq.  The sli_flag check helps determine whether to issue an abort
or driver based cancel on outstanding WQEs.  If !LPFC_SLI_ACTIVE, then
there's no point to issue anything to the SLI port.  Instead, let the
driver based cancel logic clean up the submitted WQE resources.

Also, enhance some abort log messages that help with future debugging.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c | 24 +++++++++++-------------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c32bc773ab29..b27ebb574bfb 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9665,7 +9665,7 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	list_for_each_entry_safe(piocb, tmp_iocb, &abort_list, dlist) {
 		spin_lock_irqsave(&phba->hbalock, iflags);
 		list_del_init(&piocb->dlist);
-		if (mbx_tmo_err)
+		if (mbx_tmo_err || !(phba->sli.sli_flag & LPFC_SLI_ACTIVE))
 			list_move_tail(&piocb->list, &cancel_list);
 		else
 			lpfc_sli_issue_abort_iotag(phba, pring, piocb, NULL);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f475e7ece41a..8bfac9143314 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12301,18 +12301,16 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				goto release_iocb;
 			}
 		}
-
-		lpfc_printf_log(phba, KERN_WARNING, LOG_ELS | LOG_SLI,
-				"0327 Cannot abort els iocb x%px "
-				"with io cmd xri %x abort tag : x%x, "
-				"abort status %x abort code %x\n",
-				cmdiocb, get_job_abtsiotag(phba, cmdiocb),
-				(phba->sli_rev == LPFC_SLI_REV4) ?
-				get_wqe_reqtag(cmdiocb) :
-				cmdiocb->iocb.un.acxri.abortContextTag,
-				ulp_status, ulp_word4);
-
 	}
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_ELS | LOG_SLI,
+			"0327 Abort els iocb complete x%px with io cmd xri %x "
+			"abort tag x%x abort status %x abort code %x\n",
+			cmdiocb, get_job_abtsiotag(phba, cmdiocb),
+			(phba->sli_rev == LPFC_SLI_REV4) ?
+			get_wqe_reqtag(cmdiocb) :
+			cmdiocb->iocb.ulpIoTag,
+			ulp_status, ulp_word4);
 release_iocb:
 	lpfc_sli_release_iocbq(phba, cmdiocb);
 	return;
@@ -12509,10 +12507,10 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
 			 "0339 Abort IO XRI x%x, Original iotag x%x, "
 			 "abort tag x%x Cmdjob : x%px Abortjob : x%px "
-			 "retval x%x : IA %d\n",
+			 "retval x%x : IA %d cmd_cmpl %ps\n",
 			 ulp_context, (phba->sli_rev == LPFC_SLI_REV4) ?
 			 cmdiocb->iotag : iotag, iotag, cmdiocb, abtsiocbp,
-			 retval, ia);
+			 retval, ia, abtsiocbp->cmd_cmpl);
 	if (retval) {
 		cmdiocb->cmd_flag &= ~LPFC_DRIVER_ABORTED;
 		__lpfc_sli_release_iocbq(phba, abtsiocbp);
-- 
2.38.0

