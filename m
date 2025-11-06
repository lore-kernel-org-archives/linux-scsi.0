Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CB2222594
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467352; cv=none; b=ndb5IX4KjmoTGxLwmxsGIVs2wc2ePf8mXix2Kpd19SHoHqN2av6mx58ZyIcslUu4NuU2cXRLZfVTVbd8HbjzV+aNPX6vL8mNLNOODU6T4HgCfwEvnxqNcGRqq/+G7d9fvLVOm/lsPW2HdWcAB07JCXvxkOxVmV9DOTA19pVxk0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467352; c=relaxed/simple;
	bh=3gKah2niYJp6tkgSBK+F+Kk+1kjGwPie2WRv27EAN6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WR+bIntX+Fz9YSOioSxE31UJDirElF52dlBqPIHGxePHRRaqUjev7YIZAe389aWI4F9EfL7a85r1fMbzi0PCYELiDs0vznje5hwRykoLKzvoFV6watEooDnupbc9ceaHdHefME2gQwmpGhCwRLCOY8R2JTkkWXKqCnmlUQwJLTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kVh9qSUQ; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kVh9qSUQ"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7a4c202a30aso102573b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 14:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762467350; x=1763072150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LoWFU/KqS/eBlcNuvKOFUQZwF3UasuIObktTRMTeO6U=;
        b=kVh9qSUQuAxtKaYDCpFfqOsHXtL/9QVEVYEgr9baxFBzmeiHVheViTlvDf3aYFxawJ
         wFabUT1YP1h84QLpqlCm4EnwMEoqSS88wh7tpY56Nqdlu3Kzw3HGXOZ4l/SwvBu1MS5p
         rnrhuhMUYiW2UhzNO5Hswi3j9Po0BPGlqVN4tpatcAb8lZa0XvMCg0A1YemHaBqUzvIw
         t8RhkZhFRYykVSZHtsavxf3oORKiAKPPNBLzdFPWJ/tQ8FeKkCuBjKbqvGkP8iGF4g1k
         +5wHbQPIO2C6eOIqJmLxnjn8ZojGH2VGfApN0Qb5vtGpZGIfjPGkvbvzq5XmoSfDnsNS
         tOxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762467350; x=1763072150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LoWFU/KqS/eBlcNuvKOFUQZwF3UasuIObktTRMTeO6U=;
        b=IuQEbq5PKvTNogf/t8krY4fcWXesbPv1/fYGf1N6hoGcyvY/oTV3UnDPAphuPui43v
         k23/+/mnrRgmEqrFl1GDLobbP+eYGsYqI/sk7M5bJfXO+CAKjhz2nAroHSXFz3lz3pBW
         Jtuav+sjR65Ge0gAVEwvoKIYOc2ky+YQuObqRrK8vZqh/Zo9gyru2ufYYELBvAXI/IV+
         wQfm5Yvop7TNnvk/VIKlQD7i7xWuQIA52NwOiGJFoXF57WF/BYwxHxo9N4S3Ei7V5jXW
         yZJxabkI04dSD2apZTSzl9SIUoLwLT6vpDUe0/o2wW7ASsTHxuMfGQ7bidAh7h7tTv3O
         rKaA==
X-Gm-Message-State: AOJu0YzuOAYPufjTreKMX2TUOVyDu4jzutXgdqCKWiuVTtf9Wdq1EHvX
	fDauvZtRY8hEiLuTOZerKjf4WyZQ41agmNGrtDLA5XS1PSr1tGdSDM2WCr2Y6o0B
X-Gm-Gg: ASbGnctsjo9p5q3JXaECpQlGDxRvqZqbyrQfmtIt9titN3XYDnd22wYbFhw5+ivctcH
	j+rhEz7hBUUezK+RBrq0rehCyIUwlDRVlEsVxqY8RB+QFBszB8nLVoXawv7MoYgWojV7mVkuWah
	cIs9V/RGCcAPnzVZWOQ8lPIVQ9KutVXucQRQ0Yjhii4ItKnOiqh8fu4SNlAZxqNyoh6zpTV/OLJ
	r8+0QtY8Huuou1hGK94egJGULmXHiUTIYOumkC0kwwzlq+U0PhYu/v4bh8poNFX1fHefvaQ7DQL
	VQNSuF5yziwj3N2+W2nbujtBQzTQjddl19G8c42cAOVLrAsy3HTu4+lr6108qj65Qr5XdjhKEKQ
	KQjNp2XrDKQB2ZwynlAgLU2S6AwheSxZ9eiEsxSQIxU6zQpYNAs9CCDzvJkN7t2CxepdPCGB5s2
	Y0pRbzNNMFYQuTRVu3noLRKA2ix63CnsqRTdlDA0+PBbsf3RiCFmWKUMDc/43v
X-Google-Smtp-Source: AGHT+IELXawZplCLQ5INf11eGhX7tDuFK57hEuaRR++nuDBTJ2bsbCI7XZFrOENJHlxPiWMibwn/oQ==
X-Received: by 2002:a05:6a20:6a14:b0:345:e30f:d6e6 with SMTP id adf61e73a8af0-352283731b4mr1686924637.15.1762467349812;
        Thu, 06 Nov 2025 14:15:49 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccc59de7sm568901b3a.65.2025.11.06.14.15.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 14:15:49 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 07/10] lpfc: Fix reusing an ndlp that is marked NLP_DROPPED during FLOGI
Date: Thu,  6 Nov 2025 14:46:36 -0800
Message-Id: <20251106224639.139176-8-justintee8345@gmail.com>
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

It's possible for an unstable link to repeatedly bounce allowing a FLOGI
retry, but then bounce again forcing an abort of the FLOGI.  Ensure that
the initial reference count on the FLOGI ndlp is restored in this faulty
link scenario.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 36 +++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  4 +++-
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 00cfd4ac4ccd..0045c1e29619 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -934,10 +934,15 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
 		/* One additional decrement on node reference count to
-		 * trigger the release of the node
+		 * trigger the release of the node.  Make sure the ndlp
+		 * is marked NLP_DROPPED.
 		 */
-		if (!(ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
+		if (!test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
+		    !test_bit(NLP_DROPPED, &ndlp->nlp_flag) &&
+		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
+			set_bit(NLP_DROPPED, &ndlp->nlp_flag);
 			lpfc_nlp_put(ndlp);
+		}
 		goto out;
 	}
 
@@ -995,9 +1000,10 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					IOERR_LOOP_OPEN_FAILURE)))
 			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
 				      "2858 FLOGI Status:x%x/x%x TMO"
-				      ":x%x Data x%lx x%x\n",
+				      ":x%x Data x%lx x%x x%lx x%x\n",
 				      ulp_status, ulp_word4, tmo,
-				      phba->hba_flag, phba->fcf.fcf_flag);
+				      phba->hba_flag, phba->fcf.fcf_flag,
+				      ndlp->nlp_flag, ndlp->fc4_xpt_flags);
 
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
@@ -1015,14 +1021,17 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * reference to trigger node release.
 		 */
 		if (!test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
-		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
+		    !test_bit(NLP_DROPPED, &ndlp->nlp_flag) &&
+		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
+			set_bit(NLP_DROPPED, &ndlp->nlp_flag);
 			lpfc_nlp_put(ndlp);
+		}
 
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
 				 "0150 FLOGI Status:x%x/x%x "
-				 "xri x%x TMO:x%x refcnt %d\n",
+				 "xri x%x iotag x%x TMO:x%x refcnt %d\n",
 				 ulp_status, ulp_word4, cmdiocb->sli4_xritag,
-				 tmo, kref_read(&ndlp->kref));
+				 cmdiocb->iotag, tmo, kref_read(&ndlp->kref));
 
 		/* If this is not a loop open failure, bail out */
 		if (!(ulp_status == IOSTAT_LOCAL_REJECT &&
@@ -1279,6 +1288,19 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	uint32_t tmo, did;
 	int rc;
 
+	/* It's possible for lpfc to reissue a FLOGI on an ndlp that is marked
+	 * NLP_DROPPED.  This happens when the FLOGI completed with the XB bit
+	 * set causing lpfc to reference the ndlp until the XRI_ABORTED CQE is
+	 * issued. The time window for the XRI_ABORTED CQE can be as much as
+	 * 2*2*RA_TOV allowing for ndlp reuse of this type when the link is
+	 * cycling quickly.  When true, restore the initial reference and remove
+	 * the NLP_DROPPED flag as lpfc is retrying.
+	 */
+	if (test_and_clear_bit(NLP_DROPPED, &ndlp->nlp_flag)) {
+		if (!lpfc_nlp_get(ndlp))
+			return 1;
+	}
+
 	cmdsize = (sizeof(uint32_t) + sizeof(struct serv_parm));
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_FLOGI);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 43d246c5c049..717ae56c8e4b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -424,6 +424,7 @@ lpfc_check_nlp_post_devloss(struct lpfc_vport *vport,
 			    struct lpfc_nodelist *ndlp)
 {
 	if (test_and_clear_bit(NLP_IN_RECOV_POST_DEV_LOSS, &ndlp->save_flags)) {
+		clear_bit(NLP_DROPPED, &ndlp->nlp_flag);
 		lpfc_nlp_get(ndlp);
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY | LOG_NODE,
 				 "8438 Devloss timeout reversed on DID x%x "
@@ -566,7 +567,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 			return fcf_inuse;
 		}
 
-		lpfc_nlp_put(ndlp);
+		if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+			lpfc_nlp_put(ndlp);
 		return fcf_inuse;
 	}
 
-- 
2.38.0

