Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07657225771
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2025 10:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749810711; cv=none; b=JumrWAG0NNVbs2No76nhcdmPWeRC3RhhUlYDdqu7bHizGMCdAHkFXvxqdMsOfjVYE1tm4r2swl+ICVLD9Dlua0e2ZRjRIl6jKgv45mwyaGdZJUCDBr9r99YltcRV9YDW1MYMstBly0HVMxRe8MwPEL98lJMf+Fl+QgyU+fp3S04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749810711; c=relaxed/simple;
	bh=5sYCKbI/gYwb2bYGM83dav3w5RvtEDcqGbT6doQZFr8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AORLR/+uX04eXSSip0k0XjgiOiEJ1L3/lV3I2LC7lC1NroMT8OJZhiNN54L1lT5Z4a8AK9dyBJN8595LD5RUlkNBQegCenL7ky3JKCyxYQOMW6+xUX7yPnprzPzAn1u5nTf6oZfywWiFo87xWG4cE0FL7B368il0kPoj6M7YBhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--anvithdosapati.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fTIKz+Zw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--anvithdosapati.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fTIKz+Zw"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so3143549a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2025 03:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749810709; x=1750415509; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UBgGeCMx8gjAEWFHsQLbpWrzg0KQfIHdDSSpVmi3jJM=;
        b=fTIKz+ZwDhHs43FT02Lo4UYsAkHrWbXe7NJUspOT1jkcDXGWmwZKs7xy9M0lKTQ+mT
         YeXdsFPByjJVzbST5IHGiM2V/VpvZhFNoxKmaa8x+omu67TIDPt5nQBJT9i0ayumLBnL
         Q2Bw47J88YlPYhfGj6+z/HGHjQoqmKPr/FDlToDKHTntZ4X9zCQmuhlhIW4fSY2nSr1w
         CTC3FDBkrVCVEEgLg/lWKbBW31xMdoiHlqKG9qWGYn1A2iu58WW87slITb9FgZFY1b/T
         wXFk+SGbgIzPWz4zPtzwPzyXo6R14fCoNLu2+bGfOUv+xZRpEHZaKRL2X0Y49KvtaXuY
         qmwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749810709; x=1750415509;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UBgGeCMx8gjAEWFHsQLbpWrzg0KQfIHdDSSpVmi3jJM=;
        b=DTKB1b/pBY5QT5VjR4y12AylXJcCapcYQEQteM/BmiYYhGFSh3bHIB/PUB/8p+oYNg
         5Oq7D6vBqHZOPTCERAVVRrx3iIAxCed8JXePQC3ACm/AkglBCU1lvO1pohAKnb0pOCCj
         hFz6ft1RdfA/KfS6bfGBrpK5hAxXm03Uc0MDubeUcl5AUwERQE5iT55u1MYg+0MU9IDD
         5tp6nXKyrlhO5I4g7DbyxvMQpH5Lh+G0fW8E/xfbtEdFFgbzTR9ZTdBHeQR8gaJ9DBHh
         jPFR6kJZgsBGqb5qlzrTWWURd0ftyBNKTxHY3TAXifsvSl/yzE+Vw6v40gjGR+SQSgUo
         TB/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUWtYdn1hd835l2TVCLkWZpLfbqJJ5pb2Z4Sw/AUakdvfMaNCrH84jBrl64NhG/lb8fvP1BY6LXEfaY@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2eKZnc0GnX1jpKSsBsuiRUJursENb+M7Cv4aOSOF0EB0uP1qY
	3gjjCGtCxCqxUNx0BSlf7PqoQ4GneAs2vFcCqBNJaIbNmasy+U21it8jGXppGbYIbtbHzqEAuSd
	hVperlVQ0yzjOBjdWLPqOcDHVKBzKOvsPlMP++w==
X-Google-Smtp-Source: AGHT+IFpOXWYhxEUl6O5fDMwAb82LX3FW4BHRXpXdIWBE1hUY35o1nAM35Pi421kZPrVIRLuOBb519VynBJDAAkMFkBcow==
X-Received: from pjuj5.prod.google.com ([2002:a17:90a:d005:b0:2fc:3022:36b8])
 (user=anvithdosapati job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5628:b0:312:1b53:5e9f with SMTP id 98e67ed59e1d1-313d9eba5b5mr4431826a91.24.1749810709445;
 Fri, 13 Jun 2025 03:31:49 -0700 (PDT)
Date: Fri, 13 Jun 2025 10:31:40 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250613103140.1121621-1-anvithdosapati@google.com>
Subject: [PATCH] scsi: ufs: core: Do clk scaling conditionally in reset and restore
From: Anvith Dosapati <anvithdosapati@google.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, manugautam@google.com, vamshigajjela@google.com, 
	anvithdosapati <anvithdosapati@google.com>
Content-Type: text/plain; charset="UTF-8"

From: anvithdosapati <anvithdosapati@google.com>

In ufshcd_host_reset_and_restore, scale up clocks only when clock
scaling is supported. Without this change cpu latency is voted for 0
(ufshcd_pm_qos_update) during resume unconditionally.

Signed-off-by: anvithdosapati <anvithdosapati@google.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4410e7d93b7d..fac381ea2b3a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7802,7 +7802,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	hba->silence_err_logs = false;
 
 	/* scale up clocks to max frequency before full reinitialization */
-	ufshcd_scale_clks(hba, ULONG_MAX, true);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_scale_clks(hba, ULONG_MAX, true);
 
 	err = ufshcd_hba_enable(hba);
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog

