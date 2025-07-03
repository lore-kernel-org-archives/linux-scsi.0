Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BE32E9EDE
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 14:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751551669; cv=none; b=tWF16DiMKf4w2EFXHZ4lWJqnUUeRP8sh64DTUd9350hm6zM+MV9kgHHe/6A5aseFD2DXFTTrnY9I4vIpo3JtsCZq8D1AowZ9Zuo7jDgCoghNdCbC6gyubf3AH8mKoOzm3pwyCTZ9uyMmZw71DLATqku4Gha/kGug1tovdXTIn34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751551669; c=relaxed/simple;
	bh=tZiZ92ztTcdwSFwaDSEjuylr6E2oMfBwx3JEMzcXyII=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=JhofYZd6h1MqUsveX89hCzgfrIxscjy2pWo78JSE3738lZtGzbOm/Do/gx2XPB0u9AaIPkzcnGECJaJX8W07Z1O3o7M6+HCWBcBiHxC82AdAggJM/o/MDjd8CWhXANt6TZpIYzpg5zNt5COWk5CHF78QKIs/PXQLKH/QJi1wgUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xui94Qb+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xui94Qb+"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-453634d8609so58074555e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2025 07:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751551665; x=1752156465; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ycI4WYThtdNsX6KYwyJiENU7SdlsJACu2s2/RAZVc/g=;
        b=xui94Qb+fQn9ZjakukbMGl2DdqpOFHJY6ZLSYwcBLgPjkKL6hZaoUV3Hr/YzjFvNzb
         zCeQHiKRA/QiTBKY8padANOeys4SBeNSk0GvYFiRXkf7VhoNrAuyJ3sxgOpGTD6G77lG
         jHz2R3Kx+lVrZ+h0/B1telDK8avjKvA3ZsFZPhGTbhPdlpZbZyLPVoHw2acnDkGHOAgM
         mDlp5FknINVQuvhLZb+XMQokPXRmO/BaDCSyBnnbWWADfnz35b1TKWfVoOXf4e/943Fi
         wT2lKZXh9Lxpt9iCXqa1yN3dyRUaMJHzntWAvEJMgIA8/bJYVOKsSsT5S6/2niWaqbdp
         fydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751551665; x=1752156465;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ycI4WYThtdNsX6KYwyJiENU7SdlsJACu2s2/RAZVc/g=;
        b=R001UUkaAij0ZKtpD8iIpci+2CoMBlxWORPiHEzDuBl97rUtfYd3DVH7n4sL135mmY
         /djkzV6V5oD5QT7awPtTOf392R7u78fwl+pKDfhvKFP0TF4P6awUv3M12rgGiFBpxa/7
         Cv+ZIfMaDWiJLfj607Y2BEZkKMlbobxl2JKCj2mw5n1uhE+hpuT5knRCraLidHHmZhnQ
         1APoQrdHONRUSRDzvW/NjAp/PiDmDvouM1RxuIFJNQjwKPCRNpNGmh2L03bpoOcvpfn4
         aNAuJqgurzxYRNUrFs+OJEfhbH2OosORz0r9LBe9WNAQg9U1xxQNMKVMSe4LFcNkKKSz
         1UuQ==
X-Gm-Message-State: AOJu0YzlY/DSEugPWF5jfLSWDk5wSv0uibL6QcfTSRdp68N7GTK/5D2X
	tv3uXDHYo+t6Ov7USrwz4CPIXVyvXQWJfLWSJSywndZIpE8XfglW3Qgpl8TuVyrfsDs=
X-Gm-Gg: ASbGncsHV7RstOMwkWd20KawhzkwDJXY9bbS6GQZbQoQTQurEgF+xjb+FpExMOaBpnR
	7j2QaXMRKKhWqhDIr5Y1QDtIcHEECtVpYA0N4yXYIcqdjufCN18+j4MxkjQWYdDdwzRhHlrpQay
	kFKwFfWAZzzozmE6SmL7eZEtgYOVE00CRD5t1vdSmk7Ra0VbKnkfmD+t6U7m8dNoV9e5pctwyJo
	5+RBTLvgynOS4vQpX98UE7GOW079ZcC4qgqutoc3CVuJKypx9fZmRxQ6lNUFLOnbDG/5lguxB02
	8DlKJ1DDbVwLPbbTWxXWy4I9F9pDUWBNKgoRBu0Idmqvv17crCeC76FlxPptz044hBCeIpH88vY
	pzx3+idUg79QpiAEP
X-Google-Smtp-Source: AGHT+IENaq88sCKdSam+I4emffuT1q9K5iTEZO5saslNhRejQ3SetZS7xkYpcNjBldQAnYj+qmKUfA==
X-Received: by 2002:a05:6000:480c:b0:3a8:310a:b1dc with SMTP id ffacd0b85a97d-3b32fffbbc4mr2523114f8f.56.1751551664251;
        Thu, 03 Jul 2025 07:07:44 -0700 (PDT)
Received: from gpeter-l.roam.corp.google.com ([145.224.66.164])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e5966csm18926220f8f.72.2025.07.03.07.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 07:07:43 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
Date: Thu, 03 Jul 2025 15:07:40 +0100
Subject: [PATCH] scsi: ufs: exynos: call phy_notify_pmstate() from hibern8
 callbacks
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250703-ufs-exynos-phy_notify_pmstate-v1-1-49446d7852d1@linaro.org>
X-B4-Tracking: v=1; b=H4sIAKuOZmgC/0XNQQ6DIBCF4auYWXcSSgOtXqUxBnGoLIoW0EiMd
 y8pabv83+J7OwTylgI01Q6eVhvs5HKcTxXoUbkHoR1yA2dcsCu74GIC0pbcFHAeU+emaE3q5me
 IKhJqRvXQ10JpKSEbsydjt49/b0t7ei35Jpbx/9JUv48MY4HxCxvGeyXEjRspmpVDexxvUT6tU
 rwAAAA=
X-Change-ID: 20250703-ufs-exynos-phy_notify_pmstate-c0e9db95ac66
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Peter Griffin <peter.griffin@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1720;
 i=peter.griffin@linaro.org; h=from:subject:message-id;
 bh=tZiZ92ztTcdwSFwaDSEjuylr6E2oMfBwx3JEMzcXyII=;
 b=owEBbQKS/ZANAwAKAc7ouNYCNHK6AcsmYgBoZo6u+V3Q026xLVWd3U0WTHK0GIijnylbPkNaZ
 Nk9sNbretSJAjMEAAEKAB0WIQQO/I5vVXh1DVa1SfzO6LjWAjRyugUCaGaOrgAKCRDO6LjWAjRy
 up9jD/wMpHZvlBCnREgmHLSrg0lxxe2ntcr9OETQ+7+AiDjL5pkH9OAGBPU+NCBY/bCqDjguH9v
 EVtws4IY/0/0VViKPOiH2Y9zJuNyaYNzadlQStEJyHJdDFH5YXfJcRGTtbR+mRehJu+6XK6vXDU
 AK6pemUfcwJ8g03tqVMjURIuJYdRns34AUP/BHPlTV92w7MqEXqjifiNfuDqyhADk5Qeq2Gc5Qc
 Cf5CpXIQmWjOKyU0STy1zlQmUnXjipvGTmmjmzNdRcDqK3eQQzMUL2xbnrc7oqzlXimVgkaDLme
 xOSDaZzsw0YiIsM7zHIv9hrWjjrQckT5JOkcZ8LMMvzvxDHTUcZrTasdvCGElrDcnNs2965dw7N
 7zldXitX3acPMpUtmvyf2DwuITA1Y9oPcE2x7CZxBA7k7YGAUEUUc9f++sG4TmNBgE43Ygokkz3
 OEgP5NJNLUZUiz4rZ4WxT7E5RFO6Aur6uf/EEVRqn+PNHWEYbbTmt6NqZZ7MGy5wGI96/Ku1a2i
 TMLTscMTHr/lOTuYwBcfwhQu/n2ue4ARLjIi0flCIp76E4mQ0dh6up3U2ip1m/E2Y/GBvqx4yEF
 BlWaeijNzs9rAJPCuDdxXxNEqoziojgXHxtp3tj20cOHs2ONAeHknZNQb3+BtzXN/kKcsqcrlqc
 xRXHSsU+e3Jg7fA==
X-Developer-Key: i=peter.griffin@linaro.org; a=openpgp;
 fpr=0EFC8E6F5578750D56B549FCCEE8B8D6023472BA

Notify the ufs phy of the hibern8 link state so that it can program the
appropriate values.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
Note this patch has a dependency on the new API proposed in [1]

[1] https://lore.kernel.org/lkml/20250703-phy-notify-pmstate-v2-0-fc1690439117@linaro.org/ 
---
 drivers/ufs/host/ufs-exynos.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 3e545af536e53e06b66c624ed0dc6dc7de13549f..e9fac23dc15abd685aba4c169c82e211040dec8b 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1574,6 +1574,8 @@ static void exynos_ufs_pre_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
 			exynos_ufs_disable_auto_ctrl_hcc(ufs);
 		exynos_ufs_ungate_clks(ufs);
 
+		phy_notify_pmstate(ufs->phy, PHY_UFS_HIBERN8_EXIT);
+
 		if (ufs->opts & EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER) {
 			static const unsigned int granularity_tbl[] = {
 				1, 4, 8, 16, 32, 100
@@ -1606,6 +1608,8 @@ static void exynos_ufs_post_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
 		exynos_ufs_gate_clks(ufs);
 		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
 			exynos_ufs_enable_auto_ctrl_hcc(ufs);
+
+		phy_notify_pmstate(ufs->phy, PHY_UFS_HIBERN8_ENTER);
 	}
 }
 

---
base-commit: 4611e0cba12ff5bb64b469cfac129f40f41b5caf
change-id: 20250703-ufs-exynos-phy_notify_pmstate-c0e9db95ac66
prerequisite-change-id: 20250703-phy-notify-pmstate-f02ba5582f65:v2
prerequisite-patch-id: 99070bdd3132b74f7b8932d3d8bef685815a5edd
prerequisite-patch-id: 02cd952ede323864a87816a20e3f6e06b885eab3

Best regards,
-- 
Peter Griffin <peter.griffin@linaro.org>

