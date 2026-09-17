Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFFF41A50B
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682268; cv=none; b=TiQqXIcHM1qkidtXn9hmaLoaiKA8YK8RfbvN5KPOY61C93MPeLCJKQd5Cz/PrKiwyeBIJXCrxntdHCaMRLV7Mmas9re22X5bKBIwfSXXW80cLsRJFs7TyCgdajqo1oewyeL+cC7DiPFJ7tbuKK6np48eK97cWyp3mw2qrxu0mZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682268; c=relaxed/simple;
	bh=KXZOrBnKSepxS2QLfDBEj7FGGofNkMox6fmgsGgu6AI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KMi+IaEYHEnijqf20lY2E3sCpdmeksPwBRvb72YgsktEdArWBd5WxMWgfQCc+3OR52IjAB9E+JZWJYwxug7dxubWuVsgqSpgm7TprDyn88PhHfYicRaW4Y/HIBQ86Lz7GrXpcFhU6R46zLl6ZOK/Rs0oVYcqkVhocYHpH1sbF+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jZvIUE+c; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jZvIUE+c"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cbedd5aece4so984710a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682266; x=1790287066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TGTcS+zZebXvyRrwhzQB0NHMGhZ6om2SEVKGo9451MI=;
        b=jZvIUE+c9fJo8cQQXGpA0b+mQo6ETzzeHglnzkInUG+li+u88fqu9PZGAx1gk01wqM
         62PaZb9MbZhs89le13UUVAx/yKfEwQw/JfVMcV7Yb+NAqwXZhgS9NPLbUV6TjhyDoMRN
         7nTrOzHIoEY6m65C2N4YcWBgqiNLJSxIUke2F6LLk8TnXBmA1XXoFrhNIOUw0BXJg4cx
         ItwA/p3l9snUxOk7u+VZ8I+a4odzPW3ZobP+n8biKeh9jSqhYaNuQGMHT8L5rVWUrVWX
         dq8LrlCxKg9ou6N+XJKd2SxkS26uFBmd30kHY4TKCn6yO5kDQZVNPV+kQylX5Al0Txcj
         V24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682266; x=1790287066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TGTcS+zZebXvyRrwhzQB0NHMGhZ6om2SEVKGo9451MI=;
        b=qv+ztpna8NB/xtH4oMJ27Mb62hYVWvxqGLI+rKLEKfhsvFrBR9O+cD21K4HhBFQyzE
         qFX1kjLKPj8U1U0KqvyPtMhFZtkz1EEgwXdXRjBU6NjM5G0+SX1TS75dTxlqqLPxcYoa
         Dwnqv+LBgiRONmu8tI+2+XAEMXXxt+SAVb7gx0NpJyRcneibwxTV08yEvyjA37fBEbQ9
         SY4GhkrRo6wnqLaGJGiBOTmHL7DMt2zk6wQA524rh6BwCBMfVhkkwffJ2sP7zM899jdP
         EwKrUlru+M/yQNSiYGgipLFXNclHyz8uAhaRxveOy8Ivr8sw9EQzi8cMP9ZUPW3Hr4ru
         bZ5g==
X-Gm-Message-State: AFuF++lSZtk9TaAqDuTAP5cucYXK230gyEmGIqSo2nWpstl9tj9QtQ/D
	K7Nwk6o9scaFu0aK3fyN0S2Th2q6430aYQbm1Y5L9zvWye203vWVvomnJ4tBjEGE
X-Gm-Gg: AYBFou2lA5eOvm87AOUmi0hIDvocKfiAOI5bZOsOmi3RbHmLepQPbGexGJ+fUXRSJ7q
	OjITfuM8ycsogPIdTiB6siOnjUcRc14gwynidUsHRcubEq0k6CJ6bfLh5iORyi4IDLnXNGGOns/
	hSw98arP44O0By4qa0QZXIHj9Ed4J8bxLpde9mtJAEURC6tjK5faiGv4iRbMeEkYx7V8PsEaTBS
	xA/utC/EW60B32QekCZOPstxFeAmmZ0Jl36IEvBTGisHXykNXJvadxyBTtU3Cx2jFLjqt8zn87n
	JUQqAmkC+U62xvuRiUsOQUqJ5hHyGr4XwEQ5IL0Ah7ZSZEw+XyivORLRpXUTZBCIyaWmxVFjoYG
	qobCvJHlobOTqM6e6M9lvpSxD7oY0sL0kUPIX8XySlsOptuJL8Pb8iAwWUH9AJadyrWDBzfAnmz
	s/XRnnHJ+QdgJwdIEW4cM8n8CJxoQFBbjyZ3cF3qo/Q/QlHRzxDDKqH+zQvxH8NzDHZRcdCFD55
	G57tpTucRUIYXYmuV99o3ItRMmGcyqJh8IsWoT47qiGOlE8EYipleF8mkA=
X-Received: by 2002:a17:90b:4c49:b0:398:9beb:a2be with SMTP id 98e67ed59e1d1-39e361ae608mr6688125a91.32.1789682266503;
        Thu, 17 Sep 2026 14:57:46 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:46 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 13/14] lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
Date: Thu, 17 Sep 2026 15:20:14 -0700
Message-Id: <20260917222015.61053-14-nkirkland2304@gmail.com>
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
index cb06dbc9edfa..0f2a8c71d8db 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8399,7 +8399,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	uint32_t payload_len, length, nportid, *cmd;
 	int rscn_cnt;
 	int rscn_id = 0, hba_id = 0;
-	int i, tmo;
+	int i;
 
 	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint32_t *) pcmd->virt;
@@ -8478,11 +8478,8 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
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
@@ -8513,11 +8510,9 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
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

