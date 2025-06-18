Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8432F4A1B
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272971; cv=none; b=k6lLK/s4SMEoe9e0yMLUOnjtSi79FDzFg1xQfW4ObatPsfzKSwrq9i2vHmrAhxJoWN/A4HMjQnG78WOaWmItOi+1PBt4Y0URSg3eX6HvOg1TOfvWdO4hUM/zUZR3RQq5nVBrs+aZYeG+jn3KQWnGMNMAg52YJR0PBeNylLgm6cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272971; c=relaxed/simple;
	bh=sJuNvlBtSdMCRbduYiRucYpDXwUFybMmv1VDCOHIPic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=edktPQ4aElKTor+hmewjB54e3IQsMoQA4YJIVUtAP5w/7YXUo8a79m9SBrLdJj29UsAosZKZ+5PdblGR8+NZ8mr77cRum4qdshzlZXYKA9rRiMc4RYZ0ZE938RVvjtMPSB1gHIwAWkqoXhG/eM/rd13NpMykWk7ggMPHpw3xWHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kMEaSOry; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMEaSOry"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b271f3ae786so21723a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272969; x=1750877769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ejJKi4cNMECvsOhVrjM5lhWc6RQNpzTBRniJgJC3hg=;
        b=kMEaSOry7Ys1tGSdQp1ssBAcYr/fND46xE7BkiC5OWgtxSI/NskUeu/mgQP0eAxYwF
         8+j1ypG8LA8MBn3POhv4VLh7e18WuqdwhH44Ut91D1n5SBbhVWRYk/DuF7HCfUaRdEX2
         KBgM33EkM98yJoKs3EeNdzm1xZZhkKxtjtCDEE7i2QKK0RMH6cc14FKZVRNBnu62d7mp
         BKdW1FmT0X3QrB/CH248KQqObVA6aQq6p4maRFWvYZadRuKmBm2aXI+Gg8wB9e4o/bdY
         +/pRgLBoAi04W2y5xEHZm5hcw7JVJPw3P52gAoytW6OqUemtL057O27cjBXEg8ujp5AD
         pa/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272969; x=1750877769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ejJKi4cNMECvsOhVrjM5lhWc6RQNpzTBRniJgJC3hg=;
        b=khKzxXVq+biVsIHTjhf8qZAUMoF2M3hvCcKNqw044z8c3JmdhLuOIY4lbAHmYDeu2A
         vvW5EAm3dcm18Ut00JNx4vhTKLRo4u+Nrx4RwnWv6aRsEjRmZGULzw0h1H+m9CSOrnDV
         sbhAfUy4XmE1EzgFhj5nmjuTETdjazGbRMfLD8nqOIa6iKnHgbEuTxsMHchrRVSrjt4K
         MUHMeCME8J6VQ+8Xrr8jcZ3NjCFtE+cOZ51dCxK3RCYvk3xVxWtnMqUVh2F6xdpSKoGp
         yU+toG4JMGKunQLMKEUoCTyss8/ktsrt3g+iJeEHe124iOjnDJpE0faY1lXQxMrClGCF
         G6yQ==
X-Gm-Message-State: AOJu0Yyd1l+tlAB2Jo8Z8Vf72OWEoBCQK7WOnY30Y9BIocG+L3vVhxGi
	Jikk0/sjSaYD4PY4DUtBRm1CH/lUgtmz8vWFSSLsqgeejCh99WdVRlHS1YRIUA==
X-Gm-Gg: ASbGnctcSdFc/phiCV4QrDdVZjLpRprBMrF9mtNTusa4c1V9KMKXwHkBgxRHXvuHyGx
	Bxuf7lZPHMAm8tublrNHObogezhIlKCDkkRZu3vYv8MpPJuPGVY8ldZ0RMIlbTBisoWmEsIhw16
	NQWunG+XH8OImwNZJ3gCvofmYhEXvOqWw/RiUVirGhaSBrUrQ8rf51TMiySZd54UAIJcOWXuw/n
	wcioKu68eDiWIjRLpwTyojop5I4feQpuPgkr8i6bj72aI8X3fnCBXeA9GK76nYTJNxO1AGBD4V1
	V0VpFALAMESqQZMY6LXATyCwr9vN2MRWy4zOB9h0MDSaZ65q3oKppSSyIrugHunC/lVytuWmvuS
	SJz0P4j9pmhwMsCmgqpXq/IAMuAzjqwNWAS+WYd4dgasntOx7KvVZhHAk0w==
X-Google-Smtp-Source: AGHT+IHAwgbGiEjiQBZyACFiNt/kuTAxcoian7yitktXcQ+o0bg47IUt7uaI1f8AcOA99s4o7r11Ng==
X-Received: by 2002:aa7:8884:0:b0:736:a6e0:e66d with SMTP id d2e1a72fcca58-7489ce0c6cdmr23474831b3a.6.1750272968728;
        Wed, 18 Jun 2025 11:56:08 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:08 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/13] lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure
Date: Wed, 18 Jun 2025 12:21:28 -0700
Message-Id: <20250618192138.124116-4-justintee8345@gmail.com>
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

If a call to lpfc_sli4_read_rev() from lpfc_sli4_hba_setup() fails, the
resultant cleanup routine lpfc_sli4_vport_delete_fcp_xri_aborted() may
occur before sli4_hba.hdwqs are allocated.  This may result in a null
pointer dereference when attempting to take the abts_io_buf_list_lock for
the first hardware queue.  Fix by adding a null ptr check on
phba->sli4_hba.hdwq and early return because this situation means there
must have been an error during port initialization.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 8acb744febcd..31a9f142bcb9 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -390,6 +390,10 @@ lpfc_sli4_vport_delete_fcp_xri_aborted(struct lpfc_vport *vport)
 	if (!(vport->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
 		return;
 
+	/* may be called before queues established if hba_setup fails */
+	if (!phba->sli4_hba.hdwq)
+		return;
+
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	for (idx = 0; idx < phba->cfg_hdw_queue; idx++) {
 		qp = &phba->sli4_hba.hdwq[idx];
-- 
2.38.0

