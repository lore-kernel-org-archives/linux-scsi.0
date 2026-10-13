Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA3B39768F
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 23:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791849195; cv=none; b=MpGLeBmUStbTD9QeZii45KEEdz5RJs95GZnGGbOeskBzxKOBluJOfY7O7J2w4nRN91UADRewzTY6KCBBSelNzVdTpnnYdocZ5Hr0cD4BocHwREQh86cYQ8CSg9Huec2zqWQue2563vJh/BnkvRDHGp1kpqCFG843iItKkVL2yRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791849195; c=relaxed/simple;
	bh=cMRph1P0KO0ziPFs/jSruQOR20trRKNMeButZN10cxs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CUJIU3iVZtTt4/hrVgli4kuV13NcV8UtdwHYx3Pph7Pw+u4X6cgBfcqTlQY1coLp4yYCJ4viFwHmmY6pGTEXjP4mNLFDyS4vb3J8xjsqlJ/ORZUkxd2I6erLkPFddeacf52J0ZJ33MIgk5c/tcIwxk0TF/y7MJsZ0J8o7nyCobM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YhvDj1Sa; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YhvDj1Sa"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-354ba08cfd1so4172569eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 16:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791849192; x=1792453992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QeIMTi5unTP6BgCn44aISc0k6OzQAHaPaIl3/rghCo8=;
        b=YhvDj1SaQmoTYpCZ+/3dmAYOqNWtK3IpR8k7XBkEsIvUO9BFSbPyZxnYEK7PAsfLEg
         piq5ibY03F8dkvYi/zD6YerJmaaKpMq0Ntssm3+5USBo7ZGyrAGEUPMFlddctbeInx13
         ysDa8Lb9l3ctcskyGLDW7ueDuITPalk03jW2y9WR2TvLEutOPjnkQPbKJnhYB4a3zS5c
         h0Df0nRa3yoLowdVlni/bnwu86UP0BctiOozofiE7IUeiOMm40GxBEA7oiZ50MJ2niA8
         GSqv8623rPE7bSCVLaL1rvfKbrsY4jNnEiXq1OyEkvLY5mUutTedWgB5ImzZxkZnDs/n
         Rq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791849192; x=1792453992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QeIMTi5unTP6BgCn44aISc0k6OzQAHaPaIl3/rghCo8=;
        b=tDFpUnTyUWlPaCp6kAafHY8g+M2uAG15ddB84C2UQv73SE08aP/YBgDlNZnaEHKYYb
         u+dY3FsumVPoTxIVDrv6FdLhtt7sSN0Tw0QtmTzPO4nJcaYF2XeFvxJxoYVZPlWeaEnV
         xysq+0jjBGDkoBZGjXD4JFOxRcsjAE5VDJqVz6wg9T9wNUjUTXk38Hpj4cMH8h2X5U0Z
         TBUC9DNuNUN2eDEFvnWFvQyYbEYgb3Er684gIgGPu65UWrit5UwzY1HE61uIxAdriH+6
         BmQ0z2IrSuuNOoUNO8VteywAhZEYmpjlwNmsCULuqs9Il8km7+j6ujzI2XrPNpulr/yO
         8YqQ==
X-Gm-Message-State: AFq9FYLurIez0Oz4+rbt1Xhonjwm0rPC6nP70YXbOuTp7dUNfUIIrLww
	ob+iRNTY/UogErbEuSZ5POpNlpuy4sdCrVz9qF0mj1hXCVUqn94cJ+AcEuRaiRh8
X-Gm-Gg: AYBFou0fVo8CauJlV5fyJMbJiDZGE52i+UeekV9n3jCvI1saqoZ0HuP0jLBjR3x9YOv
	Er5cGZ0Ntcu5gecYeZW3rX94zbMNhEd4yx/M9/HREItYXNCijUT5j2kvWc7EFmKHYFQneEUNxBP
	VaF4Fj1wjF8LcGoft1h6hmhWhFxzHnxAk3kb0l9Ogq43WBF/95eo7E9BbEQRusUPdG27fEzhZTC
	Iu83adAt5IXHq6E0ACC+ZieZqlrsyFNUZX+nrS8UxEgZTPjPwC8LAo+M6l3cCSiXpV+fNfkORNH
	4wC/YEqy0EyLE1vQH2RrY2CI9SGO228EUFwJX4kY+eZmhB/HZL02G33FzvmOfiGXMncCxex/llf
	CdeOQi9km1eqADs0/An8pEhEsWUuMxgnZSS9HBsm51iBX/BhLORNx7nn9eEJNVQYfjoyjWzqqD+
	ArIyBHdkWyJDjO3mSgkjr8I3s6l7T/iAuKzMsVnePYyHxU97MMulRhU5Z2OIs7aj93PhhT2FeTX
	hzk3RvkTl8Br2Svhzb55INT1+IwbKR3swrUHrwjVIWn+X2V+MWynJVWkQ==
X-Received: by 2002:a05:7301:5f0b:b0:351:4648:3611 with SMTP id 5a478bee46e88-3537e1118bcmr14003949eec.26.1791849192196;
        Mon, 12 Oct 2026 16:53:12 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b29c2f861sm15137264eec.11.2026.10.12.16.53.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 16:53:11 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: jsmart833426@gmail.com,
	paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v6 6/8] lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
Date: Mon, 12 Oct 2026 17:16:46 -0700
Message-Id: <20261013001648.62289-7-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20261013001648.62289-1-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The lpfc_set_disctmo routine is not used for all cases when the driver
needs to restart discovery on the fc_disctmo timer.  Not doing so, makes
discovery timer actions invisible in some cases as they do not get logged.
This patch substitutes calls on fc_disctmo to use lpfc_set_disctmo in
lpfc_els_rcv_rscn.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>

---
 drivers/scsi/lpfc/lpfc_els.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4918d71ebfe4..5691af515b43 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8146,7 +8146,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	uint32_t payload_len, length, nportid, *cmd;
 	int rscn_cnt;
 	int rscn_id = 0, hba_id = 0;
-	int i, tmo;
+	int i;
 
 	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint32_t *) pcmd->virt;
@@ -8225,11 +8225,8 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb,
 				ndlp, NULL);
 			/* Restart disctmo if its already running */
-			if (test_bit(FC_DISC_TMO, &vport->fc_flag)) {
-				tmo = ((phba->fc_ratov * 3) + 3);
-				mod_timer(&vport->fc_disctmo,
-					  jiffies + secs_to_jiffies(tmo));
-			}
+			if (test_bit(FC_DISC_TMO, &vport->fc_flag))
+				lpfc_set_disctmo(vport);
 			return 0;
 		}
 	}
@@ -8260,11 +8257,9 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		set_bit(FC_RSCN_DEFERRED, &vport->fc_flag);
 
 		/* Restart disctmo if its already running */
-		if (test_bit(FC_DISC_TMO, &vport->fc_flag)) {
-			tmo = ((phba->fc_ratov * 3) + 3);
-			mod_timer(&vport->fc_disctmo,
-				  jiffies + secs_to_jiffies(tmo));
-		}
+		if (test_bit(FC_DISC_TMO, &vport->fc_flag))
+			lpfc_set_disctmo(vport);
+
 		if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
 		    !test_bit(FC_RSCN_DISCOVERY, &vport->fc_flag)) {
 			set_bit(FC_RSCN_MODE, &vport->fc_flag);
-- 
2.38.0

