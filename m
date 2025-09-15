Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6B7292938
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957964; cv=none; b=nLEN14lEzEMTnKpOScc3TPjUnZEcJML00TDiNdFwO0Ckvmxgt1/Q6frwhFgP7Q/0e3PPog88C9rtLo+SHa+o7WufdcoCKvF0fjqiuyMk5u9c1pfIby/XN/dpRUB42lBYu2ntr9OH4KmzgWMqlL15G5mXjMV9O4MMUVkd81iOeKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957964; c=relaxed/simple;
	bh=RSKBuB9ki9zeXpKLMgTRPzwyzajAwUBqYiz0dRJrreM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fvfBE9olY2q31paJ6EskQhlFfVz5MKDQ/JGJcDs3OJOt0Im0o3LEZvEJbc1+rZEJb+a81v6JfW2uy6LJOMuE9fGHlQDL7voauJtnBUHzLOXnCGQqAjmb+ish2j5tyEpgwdRd0XwRsrDvuY3xGzEupGYQtvaJMZibgizmszqyebk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BDFzA5A9; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BDFzA5A9"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-78393b448a1so11048276d6.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957960; x=1758562760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mu28WbTaDoQECBvjM55cZaec5kIndHyML7dLdpit9Y0=;
        b=BDFzA5A9aMZ3+j0BEFETEzcXsSb+6+Sip8CY3LQDzO7rwaF2er8Qo+qoKY9hoc0UwA
         m6NJ0V8L7I0rAeU/72ScYGLKUou3z7agDViLpoSp/NZgfxbDpO6JoMqQFjxh85wIl5Mo
         qj0HshQfS8k+qY8X18l5XFLz4HRM6Ub+/+PnnmL0AukD9FVXhkC0escGbHAFT/u4+04p
         IUeLuiZyxdkFed3MpJ8oozkFm0adMCOKAwu7mo/2cQNOPft9Kk0LwXBF2aQQTBiTyYB9
         WFVMrLOQITohoSbenNLdLQI4yDAsDsMLNvg+oLkwY9TkTq3mWrThbh8ow0zjuFJ1RXLT
         R3ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957960; x=1758562760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mu28WbTaDoQECBvjM55cZaec5kIndHyML7dLdpit9Y0=;
        b=XfDplv2EB4qRHDsxlziwMcqZy9+98tMrTtfIDJVQb5x31wU0rNAOBoJ+m1u2BStNS5
         gn6qcnoNnFcWOgv6A0RbRnK2npGrCu3/cVeu/WQeyDf+ko/R0gHEMtf98VHrG53M+X+/
         WYISUxalZW32Op8zsqWaBJClwLWQ+f1jkxguBmCHFvsSwWuRwYP/DorrV0o2xHKk35qH
         O9Gcd/ohp5nr5DwMehTQ3JuUjujdU8NVbMkecwW8NhPgfIvs0c670kjl7W1Dzp3mjbnV
         Rz5MvqL5qYMtakVYg9EH1WTV7+KlGsFqNnSFfASoPHLeM/8Hdb+g6gs17ugNYhO/olZD
         hPYA==
X-Gm-Message-State: AOJu0YzKnp1sT9QXF+N41nzEEr7iVTI7PvAHKcrIDuyuU82EFaXq1Pny
	QgHcOPBO09dJA0Yde+VbXA0cWTJU/Um4RfR4C3jO8hDmptvbpUDTehzOXHDcTg==
X-Gm-Gg: ASbGncul2RTx6kwq3dThQE6Q9KSTb6NNyb+i27I7q/6dmBHAIoy6bU40Ysnj1zR2a4a
	kBgMiWMfeUk1VQca8aT2+u0pbkmCWoAErawOOb3vG7IVkNPQMzYdfIYUPivlBQYg1ssMHFltQ9X
	JV8MvgIIhNuuePzUyNBlPy+eEYpcYLTzsU/C/pru9bkL7fBDT/1leCGPgMGCAUNfSuYGwlZINHJ
	gMrEF25F8DcJ68rqX6r43Knq/tNPpeeU+giHv6yT/QDofnkiW4vnXhgOXnc2vpvbhW8dQslreEI
	0w8NeQRfoKVlOCj0rI10tM8bAuOrBFWMVaKOgjr0iweWrCTun6DRW0FcU3DK8M+xvHx4iaK15UE
	8talym1fXJCs+zXAEgYq23QnW/0xSgxxj4gONpC+r3RBppRnrDEFsnBaq06rfDAyBuZ4EgXqZrT
	vkZHQC+BpLXdw6gyIB0Q==
X-Google-Smtp-Source: AGHT+IH9DP9OFf8jWqGCisFzQ3e3sQAiecVtgYXKD2Q0LBOLw7QQrDaf7L5WwR2bBsy3F59uo2QPBQ==
X-Received: by 2002:a05:6214:21e4:b0:755:33b:93c3 with SMTP id 6a1803df08f44-767bd944e83mr157148626d6.20.1757957960226;
        Mon, 15 Sep 2025 10:39:20 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:20 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/14] lpfc: Check return status of lpfc_reset_flush_io_context during TGT_RESET
Date: Mon, 15 Sep 2025 11:08:03 -0700
Message-Id: <20250915180811.137530-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If lpfc_reset_flush_io_context fails to execute, then the wrong return
status code may be passed back to upper layers when issuing a target reset
TMF command.  Fix by checking the return status from
lpfc_reset_flush_io_context() first in order to properly return FAILED or
FAST_IO_FAIL.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 508ceeecf2d9..6d9d8c196936 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5935,7 +5935,7 @@ lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct fc_rport *rport)
 /**
  * lpfc_reset_flush_io_context -
  * @vport: The virtual port (scsi_host) for the flush context
- * @tgt_id: If aborting by Target contect - specifies the target id
+ * @tgt_id: If aborting by Target context - specifies the target id
  * @lun_id: If aborting by Lun context - specifies the lun id
  * @context: specifies the context level to flush at.
  *
@@ -6109,8 +6109,14 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 			pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
 			spin_unlock_irqrestore(&pnode->lock, flags);
 		}
-		lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
-					  LPFC_CTX_TGT);
+		status = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+						     LPFC_CTX_TGT);
+		if (status != SUCCESS) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+					 "0726 Target Reset flush status x%x\n",
+					 status);
+			return status;
+		}
 		return FAST_IO_FAIL;
 	}
 
@@ -6202,7 +6208,7 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 	int rc, ret = SUCCESS;
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "3172 SCSI layer issued Host Reset Data:\n");
+			 "3172 SCSI layer issued Host Reset\n");
 
 	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
-- 
2.38.0

