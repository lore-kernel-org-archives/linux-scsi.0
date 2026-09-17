Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1054A7C83
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682257; cv=none; b=fzLtbcPvxdTjvmH4VKOzHA7UnYOmvgsLoKEcvuoPwM13GDKvfwOe2VI/a1xEweP3AmuMxtnhvCztaSWhxdmBnNzkZENCw3XwPHBSyAYdWL8VY6ASK3ki5IYyPvNXe9bAU/h41oadGQorPwjfBInxefWMGf4Kh3kB9+nQjeMgoKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682257; c=relaxed/simple;
	bh=zfPBsKdkSRy5JX8P59HKRwbuYRr6S9mHFf6IwB1FwYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TjY5sd+yghxZ13eJazg1Y/I/PjRYpyX/weeTcH57apmRA0Hkm1ooqq1wglRh1kZF0+vkkJqaaxjwdaX1NNeVRPyCrmn49V5PKGUUNGKLQqDdC4qtgV2XuvWVHYTPCrOJpJk05k78mm2+fn0hp0IOK1UGYRaqrzuYvTTn9+nTKfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YJ3qHL5p; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YJ3qHL5p"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39d654f02baso105544a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682255; x=1790287055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+5fnJq9rLQambLd+nanHYkwDfDzE90DFqM/+qfsm4xQ=;
        b=YJ3qHL5pNnQWoDvBOdFy9Rcjy/E2SzsdzevFg6JEampkZmbJSlBvlriXOTKkc23CCO
         iMCpteDh3fjhaoezIEYh/TPAmSedqEIDXc/Bx4KzS7zVHwq/i4SJ+hQgW9HwZJJQgsdd
         jEEOK4ir8ND/pml1wpPAe11pw19BvGg0nvgX7IUJsLNX4VkCfvjyhLHbnQ1tWckXfVbB
         TOuDAPBTgQ/jml+KkdEyuFxHF/6C8YN2wR9T17UY5Zz9xQLHWfsudPN4gdPjHbeaIN15
         /K4fZCWcqUqm6757JHJu373aw0DupamHPrM013pRZSDSSwe2bxrVCQuv2Ti3ie9L8E7m
         ezIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682255; x=1790287055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+5fnJq9rLQambLd+nanHYkwDfDzE90DFqM/+qfsm4xQ=;
        b=Vtrv8H0XPiMX4I5jXf1taVlW1paJwXXBB1sYFsYGLh+b/oEz+aQcOKmugOmXBODoYh
         r2EJNs1cWPHORws6TL5PJh8+hg+j3Puw6GVPNCeX5/50iw5D6kVvRM/kpXrWdqF6CZRY
         vhpQYjIeZ7Evq00IWELiBLbvHxG+V1IphvKHRPplBwzq1PXJ+MKUsIBA+cPZ3Whh4dAe
         L0Kng9KZH6gve9Uoyv3GTL2xVXdml5tSEQE/rsf8ebAV6Y19Y+IS4DmFOgUWNn6NyOOZ
         uw36zQD9i2fgi+RFgtnI8VOtO9mLsm+lVAVnEWBuTWgjuCsad86lscV7WjMMtjglVsTB
         yGMg==
X-Gm-Message-State: AFuF++mFK/cUsYMWw4aRLoAjrqacYIcZ8kNEU0lG0pOvTxEyVuk9uPBY
	FHIo6kUXW/O+X1JAGywhW2pNYX5fyREgr9t3/0dGnhkXkHwOAD34zAJ+CLjOvQ==
X-Gm-Gg: AYBFou3ThZ0viLOlW0Y+WLa91O5Mk9EI1wAEl5CTsx61a4cTiEVBxcm4O1zQ3231U1k
	iQ4k8Ph4HABvRsexqLreUIkqH/Zs4YWsjS0AeN3leneWY8voq3yvp1bXUoIo+b+1XZ/PTJAH8Ve
	GQch2vFvxg9X6/4JUYjnpZ7CTwYDjoOY1iBgzv9eKlCtQW/jtU5/9M6XXLsq5d9eKRjkuDebZGT
	u/UpF+CqMhIOP6/l64GduOIxJ/G31KeFJ0+v8N5sO7GcsMgYuZpUfKomJxWU8YAOroTm2S8jVhr
	svA7Ds+BPFpqRAG7WShZ6DRIaKh7zQEQTFFRApG/xJe6y/c/Pa2RTnwxPRKimkBkAbFfBi2eyNp
	R6NGT1ys+o5L1ZBP7rWsvADfsTghSm9urNYF1rUr5D4IOnvVmInXn/6COPmb29vkWd5DTbVkzB4
	SaroIZ6oT9fLi49ts9jwMwQ3lNJoaIcPvxgf8DPQfFnwd/5/ev7w+N8iZ4+D/nK5yKIUsFekyVz
	YFwclgVCdA4EWs2ZBXgRHoEjXpmiuV/q5TLvGEjyK5ho2RQVZDmWISegT4=
X-Received: by 2002:a17:90b:5288:b0:39e:4c7f:8b18 with SMTP id 98e67ed59e1d1-39e54cfa7f4mr1055634a91.29.1789682255050;
        Thu, 17 Sep 2026 14:57:35 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:34 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 04/14] lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
Date: Thu, 17 Sep 2026 15:20:05 -0700
Message-Id: <20260917222015.61053-5-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260917222015.61053-1-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current initial kref count drop logic for an ndlp that fails FDISC
assumes that the ndlp has never registered with transport layer and thus
the lpfc_dev_loss_tmo_callbk never called.  However, a failed FDISC can
occur after a successful transport layer registration too.  So,
lpfc_dev_loss_tmo_callbk can occur and there is a potential use-after-free
on the ndlp.

Check ndlp->fc4_xpt_flags if previously registered with an upper layer
transport and check ndlp->nlp_flags if there is a LPFC_EVT_DEV_LOSS work
pending.  If not previously registered nor LPFC_EVT_DEV_LOSS work pending,
then set the NLP_DROPPED flag as before and decrement the initial kref on
FDISC error.  However, if ndlp has been previously registered, then let the
pre-existing logic for each transport's respective dev_loss_tmo_callbk
perform the initial kref decrement.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6f6394a0047c..45aad4cd2dc8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11416,7 +11416,6 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		ulp_status, ulp_word4, vport->fc_prevDID);
 
 	if (ulp_status) {
-
 		if (lpfc_fabric_login_reqd(phba, cmdiocb, rspiocb)) {
 			lpfc_retry_pport_discovery(phba);
 			goto out;
@@ -11427,11 +11426,22 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			goto out;
 		/* Warn FDISC status */
 		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
-			      "0126 FDISC cmpl status: x%x/x%x)\n",
-			      ulp_status, ulp_word4);
+			      "0126 FDISC cmpl status: (x%x/x%x) ndlp x%px "
+			      "Data: x%lx x%x x%x x%x x%x x%x x%x x%x x%x\n",
+			      ulp_status, ulp_word4, ndlp, ndlp->nlp_flag,
+			      ndlp->nlp_DID, ndlp->nlp_last_elscmd,
+			      ndlp->nlp_type, ndlp->nlp_rpi, ndlp->nlp_state,
+			      ndlp->nlp_prev_state, ndlp->fc4_xpt_flags,
+			      kref_read(&ndlp->kref));
 
-		/* drop initial reference */
-		if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+		/* If have not previously registered with transport layer and no
+		 * LPFC_EVT_DEV_LOSS work pending, then drop initial reference.
+		 * Otherwise, let the dev_loss_tmo_callbk drop the initial
+		 * reference.
+		 */
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
+		    !test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
+		    !test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
 			lpfc_nlp_put(ndlp);
 
 		goto fdisc_failed;
-- 
2.38.0

