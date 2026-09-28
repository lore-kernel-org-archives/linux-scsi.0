Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F97832B118
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618096; cv=none; b=Bh0y2GV9s5EvbeCswCvY7iMxXnv5YknvoXqG/mxU38/k/wBpVU86A/Id80DKpWCDxGon+TuRVCide5rwLrV6QVSd8JaivPde1n+HbN41BcYigQ7565KDpwY6Jx2dxhGacCWZfff7c6Tc8GilEeZhLckrtm1qbYlwJjAxnfcK60k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618096; c=relaxed/simple;
	bh=zfPBsKdkSRy5JX8P59HKRwbuYRr6S9mHFf6IwB1FwYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uma/KVynVgSH8Xt+Oo7Zh3M39fRXcDrtGhVmNrIZ6lHA3egu6GbwPQHus+U7VclKJS166wp9+zDuSLkYOmjlDlYg1EYPEcQoo/HiITK/OavRb8rfDAbesP9gFgfzVhY6BiRarcvakUM6QDyDJE6b5ekd6YQXHFlvUtjLCL3B1gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f7NO2h97; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f7NO2h97"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-343479e6005so77601eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 10:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790618094; x=1791222894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+5fnJq9rLQambLd+nanHYkwDfDzE90DFqM/+qfsm4xQ=;
        b=f7NO2h97EyN6yy729kO5duZoQt2HE1WXhPXRM6O6ZcErLqsPHiIOnxVIdiY7TYoCK5
         Al95ML3Cg5Ax0fwDLhMZ0locpikD3yqAFXvCxDifNkoOvHfbdIN7JYPnmjMx7+hlvPIc
         /q7EH18PMjr1C6Mob62mUyI5paaBK4XMRvV+X5Wac7i44JdKcjEK7IYM4IPfZjAFzCgR
         IcuEj9dLJ9xRsgewUD5yp1kosUEsiZ6XGmYSmA3xDdZqWS9wILKMskER05u1weYrVh0A
         tUyhcXtiSw30Dl8RSMIoGqv4bbhbCDnbSRUu7JHEBs+awxi/1QFg00hXsN8S85Pz2K1J
         c9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618094; x=1791222894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+5fnJq9rLQambLd+nanHYkwDfDzE90DFqM/+qfsm4xQ=;
        b=gv9vFyzm4n7L7AHB4KnZjVjcuNm3pO6E4cHdAtx5H43OXXmzLwAqVPIRBDJ3fIUvdT
         1DszPpkhdWHyBNBi30QcnCyvvGT1B/ZoMHz1KPeUzJSP2m3lZS5Pu4yMdB2kmNi9UWUI
         HNNy/yKKbxeIzUNit5pNWYFSwM6EWYOSkctK1YgqX8tINZfX3SO5rLDdr9aHJJDJtLqB
         TD9pMWKuNk4grf7aYXT8EAcksbdYSIwtTQ5u8j+f8YEtCtIQCXC6789KDyC2XVejGEhs
         JWSsXPGTXyGkEabbLnnHuYsUYKXHHHCBXsMPgGfsudQaQqWHdgd+s15LZaRyyx0gwTGF
         2w+Q==
X-Gm-Message-State: AFq9FYI67fXlmMviQboCQoT6QaNDwAEuXVGwYlYi5JRDTyTchtKIKHPA
	4MJWPwdhiUrPQdLVS4/kD4mwBC0AWmyYml8W7s5M64nT8XKT5K71vAjijEx/X1PG
X-Gm-Gg: AYBFou3MOQiAbt/P0EYYzEG0rcTbx/jurv8sjambI2bp5faDVLlJtxpnhLF0dz9+fZy
	2/+gziII3V7LMqYU+CrXPr6wPJz+KkSp2mqWjQ+emGSYsjnBNqeCPkJVSvs1H5/4fHleIWNKEXz
	A7jwBSXchzPaE9Ze2QTgIAcbD78t/ZzOcIbqb/pckIVvZ4aQcss4H489/bq9hfVlCoPE+ftyGbz
	ofLbjrH/ZpcFyMppQEfTcRFZ4BHigqaS35rVdFvXQC2hWRwrhzlf8E674A2UETL4c9f0Evj9pTm
	8xOdx8bb+/3GeId27kap0RksoEh/1xhv/uMZ+PfdXIDm+vcgcZefJLtw8+LUjG7Kcs2vaRokYAk
	Zu9EsZY2sD0acwqzD2P1kEotmboGO+hQGDIfpOLIgpQUiMBYLFx3WhxUfPWGjCxVTGddVNkqJlb
	oa0QB7bPCtYZJwkuLGSP1ZxutGW5nclZEXWmyrvVd5o9r21USZjfoACs5AMhTikXJGyWObFDBRs
	Cb6ypnDmHQyXYDLmE5ZkxhRyKbj7mhkx2e2q7htOvL8z8hGRDcYaGv67Q==
X-Received: by 2002:a05:7300:d0a5:b0:33e:6877:ca6a with SMTP id 5a478bee46e88-34af9a07502mr78956eec.26.1790618093665;
        Mon, 28 Sep 2026 10:54:53 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm21189418eec.11.2026.09.28.10.54.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:54:52 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v5 04/10] lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
Date: Mon, 28 Sep 2026 11:17:51 -0700
Message-Id: <20260928181757.21959-5-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260928181757.21959-1-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
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

