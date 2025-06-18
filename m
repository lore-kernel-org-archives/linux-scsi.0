Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4753A2F49EA
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272977; cv=none; b=qWybLH4PrCNWKzzUi1aVFdVvOYVWDjGwk7l6PlIXQ9Zntjes8FyUEwx35cIlHtaUDzXKdbtK8GhDDLQk4iAnG+lwDCwc0KAA+mUSBLLjr5IhWgXPvEWjqQ/uvl8HxGxP5u/rht/MI2AaJ5KUMKYNJ7dKAeYpOHUkW4nu2XnmWSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272977; c=relaxed/simple;
	bh=rRYTK9oFBYnAnf28CfVcXIRxWYC6j7NGTLDdcz4Pjao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I0JeQUIqFJrT1plgF0duFXh8YwThmOfuL3pHpl2E4EnFAWNSaMEHqqAtlEGo++eOQLlOxz20XLTqF5CMhiCeqSrOtjGdFRkZ9f8fV9ZY+1vv3N+2W6n8VGc5nei5dCRpvi0tDGMHLDoHo6IYUM/EeaZ1S8D/X0uKkd2Y/uQOHDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=coaY/v8C; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="coaY/v8C"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7487d2b524eso3896678b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272975; x=1750877775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7BajKV9miHGMrsCFJmE6peV/B0ZLUkmuvep9PSHWzkU=;
        b=coaY/v8Cg3Pihf/arWbKeL4O5td+OaPw8UDcR5w0t6KHncJ0K7lUvJw1VQH/5zcMCr
         Cw3PSkRCp0j2Lx4GcoH9TFCW1q7Aawyk6XckBe2ihHfeXbCuRQLfnENttKuNkWNpuZRK
         aBp3NY0rGumrdtemdAfG2FDBGFxNZ6OXZXlNEwRVZKGGJDZatN+YPKWa3bWCd5xlZwUj
         IvzHZES/MYoCfKECXQJ77pJ1HCDM5Ml58ceeQWaq76IX7c30ni3NMR/T5AcXNgZJMg36
         rGKDkeVaL1NhR+dBvTlgP1Ea+UVYUgG2rZlwJQRpCUziIcDFFP8tCw5kY6U4e12U9gBO
         lcEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272975; x=1750877775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7BajKV9miHGMrsCFJmE6peV/B0ZLUkmuvep9PSHWzkU=;
        b=qusf6bSnqZuqf41ima0dWSH4HGhhrRryJXXiKJVy3/BNbBH3x7timWd1HEeQQtN/pS
         KZSHaUZVXVtsO3DwN/eweaRYRreFsyuILc7LY4RmqY4pZXRCCQtmOTBQslRAy1/5JnHR
         hehvDdB0z2lAdP6cESfsWLiLQuqRkp2Qpb+EXuH7Zh/8roTwbk7MarZJ664z6pa/HITn
         /P5e2I/uFt+H/h5L+1aCEyUVpa1nwqAzB5mX+HPsUCTGAOEK3AaFs1nwdNei+MpP8H5O
         jsrLG+0WhGxHPlzp7XbgheHREvTrBC+AyPIrZm3VZSXd5PJmqYDLrveLuhp/N6g56C7O
         5dbg==
X-Gm-Message-State: AOJu0YzKT2WicAKuBRchRumfPmzzU2kRPxfDa9NZtTy3heKPlytRfLf9
	SUYD4KGRL/nY++sMGZtMs7U58pfhvRt1LOL1MLy3na060NyxbuPZnarcIX/CCA==
X-Gm-Gg: ASbGncvlZGmDR/cjZfzf4QyEPu/LsGQ13zerS2lJPoGlB+16o2/12dzCK3mk7HZIOLO
	kXSvv/S9bKj9o/tkqQkpVAWRHPFaqSQv+9vjd0VGQKyGHu0c8M+KPK3AOw5z5GGLWJF0h2qCHq9
	0A1nD02nPsMfjEnaHc/Ux7GY0w8k0Rnrgq6oY1CVraRnvLoBVarqR6HaD2Ue4TNoETwH7gRP6rq
	exRFAxMWJbFsiRgOGF1YqVY8FPQ8jYKA+ODLOrKPe35OEruSWkHaRMOWUKBxN30uk9EC7WBkObH
	C2xfZhyKQwbQ+UdPfU6IdG7/GqmldCF4RZDVW7TQp1oIDb0vsCPmuglf0ztv8z2azgYqba3FuN9
	4/kF4F6yVnc3Dgef+JVno+ywfXfShEybNLm2KoQf+ZyisER8=
X-Google-Smtp-Source: AGHT+IHuISYfSFEdPlaXZufdQ0ELhknp0NjQyXM+L/U5ktr3S4yn3iJcNELB5rF1wUm+j8Lxgucryw==
X-Received: by 2002:a05:6a00:6f46:b0:748:e150:ac5c with SMTP id d2e1a72fcca58-748e150ad75mr7334516b3a.23.1750272975447;
        Wed, 18 Jun 2025 11:56:15 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:15 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 07/13] lpfc: Relocate clearing initial phba flags from link up to link down hdlr
Date: Wed, 18 Jun 2025 12:21:32 -0700
Message-Id: <20250618192138.124116-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250618192138.124116-1-justintee8345@gmail.com>
References: <20250618192138.124116-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Port wide initialization flags FLOGI_ISSUED and RHBA_CMPL make more sense
to be cleared upon a link down event rather than waiting for a link up
event.  By moving clearing of these initializatin flags to a link down
handler, future confusion on the state of initialization is avoided.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 4 ++--
 drivers/scsi/lpfc/lpfc_hbadisc.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f7ed245aece5..fca81e0c7c2e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8376,9 +8376,9 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	clear_bit(FC_PUBLIC_LOOP, &vport->fc_flag);
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "3311 Rcv Flogi PS x%x new PS x%x "
-			 "fc_flag x%lx new fc_flag x%lx\n",
+			 "fc_flag x%lx new fc_flag x%lx, hba_flag x%lx\n",
 			 port_state, vport->port_state,
-			 fc_flag, vport->fc_flag);
+			 fc_flag, vport->fc_flag, phba->hba_flag);
 
 	/*
 	 * We temporarily set fc_myDID to make it look like we are
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index b88e54a7e65c..690eacc5f739 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1266,6 +1266,10 @@ lpfc_linkdown(struct lpfc_hba *phba)
 	}
 	phba->defer_flogi_acc.flag = false;
 
+	/* reinitialize initial HBA flag */
+	clear_bit(HBA_FLOGI_ISSUED, &phba->hba_flag);
+	clear_bit(HBA_RHBA_CMPL, &phba->hba_flag);
+
 	/* Clear external loopback plug detected flag */
 	phba->link_flag &= ~LS_EXTERNAL_LOOPBACK;
 
@@ -1436,10 +1440,6 @@ lpfc_linkup(struct lpfc_hba *phba)
 	phba->pport->rcv_flogi_cnt = 0;
 	spin_unlock_irq(shost->host_lock);
 
-	/* reinitialize initial HBA flag */
-	clear_bit(HBA_FLOGI_ISSUED, &phba->hba_flag);
-	clear_bit(HBA_RHBA_CMPL, &phba->hba_flag);
-
 	return 0;
 }
 
-- 
2.38.0

