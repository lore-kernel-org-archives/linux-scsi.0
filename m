Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D714296BA9
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 15:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774971146; cv=none; b=CwYg4RTU8ZP2DgVeLfPfoUQfzIpopsShtgfayLZoVpecN6yxIPybvJT3USKvVsXfVz+37e3kJYFbhhe79e9zt3uS/kduSd51hUL7w/dpNNfbMlfs3nJM/9560r09WJIzzYFJqB6ULJtfWhmm8x1Jfbxf1IZkyCoYGyCYbh+2wUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774971146; c=relaxed/simple;
	bh=07COx8t2X+hjjjtUzBkzjAKo5dekCAlvLYFjCV4qPuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SIQsmMxvFNXybIS9/jYLNshc+gA3FjqQKFa/61K3Frb+/JKGTvA3IZVh9lBiJfIqLlApgC6EhYDfu9ZGaoCMSMgM7CDg4q6fSVsi2KPc+BFpyB6NT/7ThSOCNe+f9RCq5wlaoZhbXjT9QC0h1OWSXjyuMfSvOeBJCEoiCviJM5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jf6BRFSk; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jf6BRFSk"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-66ba9898ae8so4030386a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 08:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774971134; x=1775575934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4CajCLer9zDfIuUqNg+GkOvqWEkudlgIu9Wnppv2wwk=;
        b=jf6BRFSkM5JwT48IR9f3XoHqXCrT6Ii/GhkLk3LJqRZ77Jdr8oH93IPcF5kZHT03Xg
         PgVkMFEd2wZX7k2y4dmvVYnKDevMjGsrf5uQ9ouklZ8Xn8wT/GKjSPWA8aJBlZ8tYLto
         bbYI5Awu0BlFWxFf2nS15ww/8xY9X/Iwq1eqC6JHstWs7hwHn6bflwzNG6nporoXVUr6
         2y2oJprk/tLBfMIk/ElgyELiH+HyFCt28OvGEGBjwgOCI+jJnNAirRiGxgNj4cEE5v/N
         rTp+avCZYDyLmmDGxeew/IYpvQMh/l9Bygabk7N1qKWMzPGRGaeycKqgI9GV34FqDe4J
         UFsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774971134; x=1775575934;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CajCLer9zDfIuUqNg+GkOvqWEkudlgIu9Wnppv2wwk=;
        b=pcWvjQGhJPcKnl39j1OlbVHHJWhq3J+DrnasEm/k1TN9yTjrxxLbpVvXWhlq2PRHo0
         Pr8DrzqEDoUY+6XnfImx8w3chcHAG/d7yK564xRGCdnvcRbW/I6A5IouHWPsW5d1ro6J
         pEyF7vsg8cu0ZhIrnack+YyN/J23G3Qb1JGSt2WrnVIJ4lzKv3tEEa1EvibfoVCuTm6a
         3aWzpVX2H9ssFchhlP98BOhFSVk0ZSsa2NqKViycYz7r7w1NrXK4t3StV6nSWXXLespr
         hO9IaBy+KcenGqVMxXnRcaebgwYRdLTnOJ1HVzD59FBPZe+qdsDseyGyPfbhmlGhXuEV
         Wa4g==
X-Forwarded-Encrypted: i=1; AJvYcCU3qiQiop9ufLSCCO9YN7Z6dheqebuOv7w69IgoI0CBfUGC9UgVn38N9MBCcifKT4ymn7ZTD4EibE5e@vger.kernel.org
X-Gm-Message-State: AOJu0YwPss3Y8JScrADHDvumrRd2JMvPSpUUKtdnDwQE6L7ZG31wG/8l
	p3zLLcyyjbhqH89VGBri5RLgkXRn8wBHZS94vgNy7rbHpg6ws23EHiYF
X-Gm-Gg: ATEYQzwbDdSQbpQwWKDLLP0BeK7JshpCqWkpA9OA7VjFVc5EmhGeQhZDyy1JgP8oOK/
	QcFkm4YmFNiPLChtO0j+iS36KfmlfBwE+WQm7PGPW6u0BI+pj+uJ1NjnuvMYK9o+BUx5FkZp1LC
	DVWGkR/BHPZ5qcRgdsnLUdLkcmb8MAOEDzOPwEHgeHJU/RAU9w+Pptzs4W7kNvsW+cXGG9kxP65
	oPjR5zXmh6I2YyBW49qEAsuwxosROJeETRjYrnCXSpWcRso49f2ucRQ1LTx+9LpHg5yzjH1vJ2Q
	aYPrS5Q8yirHADl/AmInSB++dfOuVSGlvNJoAH2wRs7epXI2bD4gafdBYsvipbRTTlPduSUxf9v
	CYKnc4mquolfAzwa4V5XlO44ZgsHjX4e9BfKQGurkmf418ptu2Bj7CkUOgQdT5Owk/5l4lDwUsf
	p8qTPVi+aDZ/8V73zh+OIYgA==
X-Received: by 2002:a17:907:d0e:b0:b9b:132c:a590 with SMTP id a640c23a62f3a-b9be835c18cmr238854966b.4.1774971133547;
        Tue, 31 Mar 2026 08:32:13 -0700 (PDT)
Received: from localhost ([87.254.0.141])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9b7b1e472dsm419536966b.50.2026.03.31.08.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 08:32:13 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Manivannan Sadhasivam <mani@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: ufs: ufs-qcom: Fix spelling mistake "retore" -> "restore"
Date: Tue, 31 Mar 2026 16:30:49 +0100
Message-ID: <20260331153049.1344957-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a dev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 5a58ffef3d27..bc037db46624 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2810,7 +2810,7 @@ static int ufs_qcom_get_rx_fom(struct ufs_hba *hba,
 	/* Restore Power Mode. */
 	ret = ufshcd_change_power_mode(hba, &old_pwr_info, UFSHCD_PMC_POLICY_FORCE);
 	if (ret) {
-		dev_err(hba->dev, "%s: Failed to retore power mode to HS-G%u: %d\n",
+		dev_err(hba->dev, "%s: Failed to restore power mode to HS-G%u: %d\n",
 			__func__, old_pwr_info.gear_tx, ret);
 		return ret;
 	}
-- 
2.53.0

