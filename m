Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664FE30F7E8
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 14:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781102197; cv=none; b=GJ+BGbRmGYN6+3X0XjtA/141dXAgLrZMmFrKipn5EvScFtLNalchuM6vAVJFYq3zkMya/KErPADbnATzt8o1sUeJdA1nUKkH1ex8toJq+iNosnarmi1CqEEvMExZR37h6jXSlHCZ5ZfGLKRPqNaJZRqGj9+cc9LebACXWNgHcpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781102197; c=relaxed/simple;
	bh=6TvW/HzmyHDaaA9wKRoNNaNcjePQQ1Zdsv2Dq52jLls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kqWmhOsJku3K9H5A5JOE6c2IU6STXYMvDFlwkPQ3r6FAbdgLNXhlwc6LQI5p576BZT6T/eLViRRksRmbrSWIaGkmWy5UjvVNo9AYNEicGWFSnbKk78r57Fpo1uWpgSZ226ruGb5kmC8VZwtkJRsvEJ8sOO+1oh5GR9gDxIu01SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=PKsZSJRp; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="PKsZSJRp"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45eea68dd6fso3698447f8f.2
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 07:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1781102195; x=1781706995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hDOKETMRFbOV/EaNxch8DdRYXkZ7LpkUfIIjCWECVFI=;
        b=PKsZSJRpWKuTVt/Xgx0EqbYZmLHcLKRaH0Dth6ftfe0WvYdvYqPhxmd1UgKmjdyKky
         Fw833KIfwpNVaG/qGXt54M+jXj7MUVXdSqzeLY08X0wfefGBNPy/ljSm8BI+2+MpDSCX
         3coZA16+8qW5iy6hUzofiGBdMSR87VxlH5/lXkmxa1eALHMZd6G3Tn05VRurBcNyYnp4
         1h5vYJOc6sjg2kvkbUNjac1SMT1mt3ue6Wf00gIOndEXT7tbpu/yLcMhOnYR7E/Y2QNG
         vf6+l4H7R986cXeyxf0viHTzZv3LL0dy2+qa7M2MKI+hMn3W1E31AzF3Y04HLX3WCusH
         TNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781102195; x=1781706995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDOKETMRFbOV/EaNxch8DdRYXkZ7LpkUfIIjCWECVFI=;
        b=IftoFphhFd0z9ZE9ByBa2uejvRaCXKY87BrMqtOKaxj+YqbI9XGripCMx5zFKnae3P
         ll/Ekv7HsJDb/1ZNi1ga5A5QwUn/+uBCpAppEgatOCfK29dycv79DiwxY8s9Q6SX0p0r
         gPP5A02F1rD9Jkl95YEJFub5GTaGc1oTKPpliFjpx+t6MJu5Qr/hXWhDFpi0Mv0kHujg
         ua+cyC83n+m2eRtbG4oOL+OgTRgyaIkB2tbPSuMaLq9ouz9mj2iMjWUlq2cuWZ5cF4FV
         cP7DePOJ2yPU0CGo9oAnKq+2MPVE6wySO4/kIH5plO7lY9LHcCfZBULiqwcXrq5KxZRD
         8XXQ==
X-Gm-Message-State: AOJu0Yy6Npl5D9O69PDBNHRzipMNVUPTW9OPE+iZT3h6ERwLPAVHAi7u
	O5v4Lh2kXQ6g80DkOgBl1wvHigFjEPZgVOsdU7o4y0QNNfnxBrimDxKvppOUCf1V6bE=
X-Gm-Gg: Acq92OEK2fVoaOilnv0ubMy4yami56u6qtWfu8KgrBQGc39p5L+yRszzgqZySlQmS2e
	VUMrG/mTUwRop/COrjyaMPK5ZuAIVnrOLb5hqBbkGPau0MGJmTrebnvfXplWSn+ILf4K6YwE5d1
	WfvB+lOcijCF/vsy/nPjRh6BhIn4L63N2q3drUmcRSZjH+Pl4kc/HbSzTZrpvs/mr/UGCUXCCKg
	KutiRzWaVcLYAtd9873GfgFPoLqpIYKMGLkVomvSVmYISzKmxspkv6IixQ2b3vLlOZhlt2i0Gai
	YTADB8ezdwNZySWyAN7rm7qVkXp4vRN1mmi6wrOihELzrrIjAyJ492SBFqmNVoX/Q/WWgRoAms4
	fUr4tsCi4lmgtZXBgcYIutKyp7Ckk1d5hBTPrKlWqNIK9qAV2cW8z4/WqrTLjtjqizJ5nMJgUs6
	6r4U35Z044kCAjup2BF6WsuMipZ85y73fuu8Q136HhVNsX2fpMgs2nAG2nGCWpGTXoh20SLDmPu
	tBF/E2G9Y/UN1DU2n1qSiE0vA==
X-Received: by 2002:a5d:4d0b:0:b0:44b:5398:4e85 with SMTP id ffacd0b85a97d-46030502519mr29582966f8f.22.1781102194826;
        Wed, 10 Jun 2026 07:36:34 -0700 (PDT)
Received: from localhost (p200300f65f47db046aec8c3a4b621e71.dip0.t-ipconnect.de. [2003:f6:5f47:db04:6aec:8c3a:4b62:1e71])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f35fb24sm77388008f8f.34.2026.06.10.07.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 07:36:33 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1] scsi: Improve style of pnp_device_id array terminator
Date: Wed, 10 Jun 2026 16:36:28 +0200
Message-ID:  <096aaa981c0bf1aaa8be75e675f17b1c9ca0086c.1781102092.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1709; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=6TvW/HzmyHDaaA9wKRoNNaNcjePQQ1Zdsv2Dq52jLls=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqKXZs6LWlqXEgYJ43bW4uQljW4ivYfy7om6ZEm 5HBy1LS9UqJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCail2bAAKCRCPgPtYfRL+ TiYuB/9XcyLke0vULKKBlQUXzsLhftaLl1fBgoib5hfrAypiAW/NdqcY3GsM2ls2maVA1VDIz+7 lpse6weFy13v8JMUuwGd8W7trrROlxKKqwgTQQWFxG2aZ8QIP17zROC5CJraAyqnCcI+/Cipvib sftytuasbBRyIdndlMYYoNdqRr5+Zgpq3Gc+KtamKnPGRnh9luiiV+r/ePs1ZjP5p/Pjd0qHZAL BBVFoV4h4JDmXSss4xGweQzKqNQaPET3qIl1fFpdqhzDN57Z33+wMmU1m7MGEYG0PpnFGRdC9b7 pxeXoPvvPc2Xn6jqB0a48HrAz97SONdg/3sahDcJAkNnyOra
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

To match how device-id array terminators look like for other device
types drop `.id = ""` from it and let the compiler care for zeroing the
entry.

There are no changes in the compiled drivers, only the source looks
nicer.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
Hello,

I'm currently working on changing various *_device_id definitions.
This patch is irrelevant for this quest and a pure style update for
consistency reasons without further dependencies on it. I just stumbled
over this while working on that quest.

So if you don't like this patch, I won't insist.

Best regards
Uwe

 drivers/scsi/aha1542.c   | 2 +-
 drivers/scsi/g_NCR5380.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index fd766282d4a4..93dab19c1cb9 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1083,7 +1083,7 @@ static int isa_registered;
 #ifdef CONFIG_PNP
 static const struct pnp_device_id aha1542_pnp_ids[] = {
 	{ .id = "ADP1542" },
-	{ .id = "" }
+	{ }
 };
 MODULE_DEVICE_TABLE(pnp, aha1542_pnp_ids);
 
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 270eae7ac427..41731a7304dd 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -739,7 +739,7 @@ static struct isa_driver generic_NCR5380_isa_driver = {
 #ifdef CONFIG_PNP
 static const struct pnp_device_id generic_NCR5380_pnp_ids[] = {
 	{ .id = "DTC436e", .driver_data = BOARD_DTC3181E },
-	{ .id = "" }
+	{ }
 };
 MODULE_DEVICE_TABLE(pnp, generic_NCR5380_pnp_ids);
 

base-commit: 49e02880ec0a8c378e811bc9d85da188d7c6204c
-- 
2.47.3

