Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD74E2F49E0
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272979; cv=none; b=BlSzJemKdl5yeIVooVGp/WHXDRp4BGJgH1x2I0yOGxzJO9mNMpurxl5c1mTwka8bd9h4f4OskMvy6xKI1mAnwKFkba0R4fJLuekJpz+eU4PpzLeasNlQ2y5Cf2BCoHRvrC6V2IS62EpW5MfdMj5eJgg2sKtgg8ApowlhhRqc1zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272979; c=relaxed/simple;
	bh=qp7KMOau7kGF80BRLGd3EohmPTaw/QvLr1B3RCr3NRY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SJNy8l8/Yvukqc4wvrYHqT5+InXCIU+r1L8N9pq6GoyLuxW/VruBCP+c88BP5c75N7ICLbCXWnWsPRr8xFDKtjdoKUpKGjOIuNMpjV+1/w2NqC9u+LS3eqXOkQZAksey40ptwfCXNpi8Wv/hMdKJ5+1mA3mkxy5JeoQNTBUz3Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZclsGKML; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZclsGKML"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-748ece799bdso664125b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272977; x=1750877777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6YIn7X84N8cSUQmw7RBHHc/WUtmQqOjdeVD1JX/uvIo=;
        b=ZclsGKMLfJbjZhVwMJ28GKYw7GygngBnz5yaVagqRyWePhUesT7Z8vS9jnNHON4LiN
         g0TJeTQ3xFgUzcHgi/sAUXNikpt5Mkj+6M+CVfJezr9qZ6a7KqyZxYvTaTr+aQRH6BtD
         PogKi5dI59xgthsfb3yY7LBv2almtTmdKi1RVrzckrKr1/ixSAzKbzDnlmOjvLild/WZ
         DlxL8rayRXsRiOSNI5X0rFsz2b9mQmRGIx9goP3pvwx3zbkASMrqyFTuImto0d/EPl/x
         LkKmczZ6Kiv8zYZKvUHR4Q+Qxn3GgmMJP7f0uKhvTqT5dp3Z2kOh+YHqtW9ndf1SAJIk
         2TPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272977; x=1750877777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6YIn7X84N8cSUQmw7RBHHc/WUtmQqOjdeVD1JX/uvIo=;
        b=A67obuvpc3vlaRWXJ999g0SmdjRuIoU+L4tMU6YkczazmEEYtT4+if2vCJYsJI+IoQ
         2HJhLZ0q5r43EVj8tvZps8OmMKvoNxqGSmtF1IrbEs93OGAoTGcIxDhgmReOK9Kg3Wy0
         wL3SfCqAOU5C8blA+3jVYHlO/VpX1QeL31VcGBe/O9T7pZdYqK20j6sqq7DUwy7OF74y
         vuhL4QCaU6AmGK28IuY7Vh4eVbjFNifpTZHXy7ekGsIA+gDWqib1ygigQ0KAeeTcmK+g
         +OWvlk+kS/TabwQaS609BQNqXWmadpBX1914imfMZoInxO+qsZ68QSbM0znsTlxgfBKb
         TJNA==
X-Gm-Message-State: AOJu0YxdX55CE4wKydv7aYez16TppEpRbMpzTgSWNcyD6EmzFNb2dFzh
	xhy12ppnI6L2ZuYtG1XuKj8BmUiJooHhzIjevioUuV8CbvViAev4NHpS9cdP0w==
X-Gm-Gg: ASbGncstw99nmlT0ApVS05gkLvRp5/6mDo8qkioXUrkfGdl7o6m5Kxt6t/lmERGOhjp
	++BSGOxqw06jTT6SDr8gS2dXVEzlUG84ILclOQeNVZ92qxppP8qTWlSfi+b3AhDCHQ3fnbEMzS+
	eB3hwBro39W5ihP0falVKQOl+oyiUCF2wMm4XzeM1hhgkMEvEBmrEPsVijoChaTgGfcb1+dlzcj
	xFTf0R5VdzIHIKT8J7PMHOeXZFA2n/VP7+hwWkwB7NGjhvqL4WkVbmgCtJeijSrfLAtRsRO5bmh
	F3Hj2va9vM8owE7j+H315ljAGfHehcnwBx8xyQvtU/I/57l0yyqns1w0Ft0tN8MSky6Qf+g3+nr
	2BIkAJdY8MQzSwGq6ro4g/90uCUBT6x2c3VCrWshjBSa7uEihGFQh4ijqEQ==
X-Google-Smtp-Source: AGHT+IFYR9J3oACOrLzi8Tkp5U1DxhZHaaa8lpryWqi5YfY0o5RxtQIvOjm96RU43PmpjzqgjLTDkQ==
X-Received: by 2002:a05:6a00:3d0c:b0:73e:1e24:5a4e with SMTP id d2e1a72fcca58-7489cff1acbmr28542821b3a.24.1750272977039;
        Wed, 18 Jun 2025 11:56:17 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:16 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 08/13] lpfc: Ensure HBA_SETUP flag is used only for SLI4 in dev_loss_tmo_callbk
Date: Wed, 18 Jun 2025 12:21:33 -0700
Message-Id: <20250618192138.124116-9-justintee8345@gmail.com>
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

For SLI3, the HBA_SETUP flag is never set so the lpfc_dev_loss_tmo_callbk
always early returns.  Add a phba->sli_rev check for SLI4 mode so that the
SLI3 path can flow through the original dev_loss_tmo worker thread design
to lpfc_dev_loss_tmo_handler instead of early return.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 690eacc5f739..43d246c5c049 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -183,7 +183,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 
 	/* Don't schedule a worker thread event if the vport is going down. */
 	if (test_bit(FC_UNLOADING, &vport->load_flag) ||
-	    !test_bit(HBA_SETUP, &phba->hba_flag)) {
+	    (phba->sli_rev == LPFC_SLI_REV4 &&
+	    !test_bit(HBA_SETUP, &phba->hba_flag))) {
 
 		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->rport = NULL;
-- 
2.38.0

