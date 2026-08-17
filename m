Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E39A30C146
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 03:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786937723; cv=none; b=jvuKeG+N2cfRQiXkmPuV/zHuDU9RHqHAhE9vzVm41fJFmIryW9cfOuJUfcckDgf3ZeHh2k6UDBVAv0CrRFsG/MLQwn/5BIHLueXNKWxVUKreZ0R8KcuabhOfdjrhWgCIkvB6Mzzu7QYiz8JFyM0NBZDwPMvswWK+Ol91MrSprtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786937723; c=relaxed/simple;
	bh=EVNOEegsd9blPfKgfabnfEt4Bv9p41pWKStOyI6Iq4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bHz70Yrs+F5R55GMd8YuZ68dIHHZuZrQC+fJhQZqxg3lY6R1p791KHzOfibIpYomazi73MYIL0UexyBc1murCNLBujRUlgtrDlU5R92oGMc5JiIgoH7AewYCWtpsbICqKO2b2/3qK6Wp59600g6zDK5QVjFHqV0sdsEGeGfzc8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jsLFxOb5; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jsLFxOb5"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8518d5ddaabso849395b3a.2
        for <linux-scsi@vger.kernel.org>; Sun, 16 Aug 2026 20:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786937722; x=1787542522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tq4qHb0iPI7fx4THaZJfb9gp5/61SUMlprlE6Co21dg=;
        b=jsLFxOb58lclM3vUPJtWdOvgmX4yEeIu5H99mijnU+IS6qUQi0/CuYOSXe+Cdh4HUx
         QQVj7PTtNqSeG+GPAIIA0tKqhH0GJVpkfJPxstXBZWnuAOO5RgPRfpD0RF3fgwZv9QHn
         eeIjqRaR2DCQ8WsH7PVRgjCoawNDLEC15wYqeC7rdE37Kgc5xxsTNQQ555q3aRlcZ4YL
         LMhckNs6M6/rpnO3aL8Kx8Ri1IAmbyI7RfrepjUwMeptJk1hjelSGdeGQzTJU58kRum9
         Mlp3+EBNpktGm5ve4FYmDe7INlmly9rpuU///zzA3oNHws62mDwV7mns1Whjb09yUaRh
         856g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786937722; x=1787542522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tq4qHb0iPI7fx4THaZJfb9gp5/61SUMlprlE6Co21dg=;
        b=Fe+S/5CPpSx91rmlEZ0J4thTawrCaPo03VW6QPIgCg1Z7huxDgLpOE+bKElzp/KR7B
         118dIjGJnPhA25Sa9xCY70rB/jte730B+FUlbjCSyFYHNvHyC662wb4D0jecG1vxoC0p
         E5TjQr9UG4zXCcURNaRdQq9NSXsT/AwRP0k8XJGBmtDPKoJLykb8njxsnQN8McUCMPvf
         fzQLmabnkvMMCv8fKD+merHIXzALQ56LP9EIZPvn6H3G0lIkq0yXuH2zmSkPwpqqQak3
         beeDoLgO1hrsC2cGiL3xrU6J94vFo8mEZh9DTPVbDQk+KwCTnKpoDZJWeV96KcrUTjWS
         qpbg==
X-Forwarded-Encrypted: i=1; AHgh+RpAKsRzJ1JjOL+xi2O8TqdUMC+GuO0fdcH2WVHY2y0ZF/AcCvdgIyvDFQPATrh2gkHT4mHOGB595E2+@vger.kernel.org
X-Gm-Message-State: AOJu0YzTmeKhaJIWqLMGbHXncf5imoW4NDA7W3L1mSX/Oaij0rXRzv1F
	C81z1OiQkeX7bB2nZFizdlgS5Vr4KGIKzTBAnqWxQERYXJw7cxdWRj8=
X-Gm-Gg: AR+sD10rC62DtJF+GuAL2mkeRSe4rHnURlpYGBj99GwwZkU196AEcI4iUmhI5GGJSrs
	TLbiMmjixImIpKIjDhsfdmb31WZVUgBu3zYFhI3E2K2WnC8V3Ge7XwCVGK3hWaVqbnjc9aev04S
	KZnpp/rgws6qeItJcNE6Irgf5EC3EGEoPUXSx4gaDAMYqibuEbkdgmKWI5ALV9Jpc+qYwet8t/V
	saocg0k/QS95wjScbWZYij7T8GzRuffCdCsrjrifk5OmHUBP5hnVuHsmV5njf2TGP7oFcxRhy+r
	WNHszpab0OAKK0Yo57xY1ATfJt4Xus3fATsF/PEEIUi+28BdBFFpZJyEWE2/0MT9qdAjcYButLB
	tNikfFCQE+dNASnYLOwmuxJYZek1ItBJ5VkYLbUsudWuURW7JD7hbYEsADCP8f8ZUcEII2NLUL8
	DxsoVIsw9nwVME9bzV5mOXdoCY7bQ5nFZUmdAvTc3fGmJ8Q46BIsLiypNdHfk=
X-Received: by 2002:a05:6a00:bb0f:b0:848:4080:afe8 with SMTP id d2e1a72fcca58-84fde38e7d2mr19002835b3a.22.1786937721801;
        Sun, 16 Aug 2026 20:35:21 -0700 (PDT)
Received: from DL2XHKPB4.dl.net ([103.63.104.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8517d045290sm2179268b3a.25.2026.08.16.20.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 20:35:21 -0700 (PDT)
From: Triet Hoang <triet.hoang.dev@gmail.com>
To: don.brace@microchip.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Triet Hoang <triet.hoang.dev@gmail.com>
Subject: [PATCH] scsi: smartpqi: Handle pqi_alloc_io_request() failure
Date: Mon, 17 Aug 2026 10:35:05 +0700
Message-ID: <20260817033505.736519-1-triet.hoang.dev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check the return value of pqi_alloc_io_request() before dereferencing
the returned request in pqi_submit_raid_request_synchronous() and
pqi_lun_reset().

Return SCSI_MLQUEUE_HOST_BUSY when a request cannot be allocated so that
the operation can be retried instead of dereferencing a NULL pointer.

Signed-off-by: Triet Hoang <triet.hoang.dev@gmail.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 5ec583dc2e7d..0930decef404 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4667,6 +4667,10 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 	}
 
 	io_request = pqi_alloc_io_request(ctrl_info, NULL);
+	if (!io_request) {
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
 
 	put_unaligned_le16(io_request->index,
 		&(((struct pqi_raid_path_request *)request)->request_id));
@@ -6353,6 +6357,9 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *d
 	struct pqi_task_management_request *request;
 
 	io_request = pqi_alloc_io_request(ctrl_info, NULL);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	io_request->io_complete_callback = pqi_lun_reset_complete;
 	io_request->context = &wait;
 
-- 
2.53.0

