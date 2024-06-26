Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CDB175AA
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396851; cv=none; b=DTNDe+pfOhL9RVDOQ2NTu2c5YUt0S1d4oc9hCNXAQVpzBVSawJp3oN6tY1kmJI45mLZyeVThjlgb3NNID7Ras6hxt9IbQb7z0EMGYNXZbW8NSpaQakki1r5d3NBRUt1fGCJOyydFNGiWmV80QHmS+7xuYECwpYSWrZEBndQZFzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396851; c=relaxed/simple;
	bh=n71cz1XaFfzqDVs3dRw1Q7xECno2TKDVXW0ttbsrD04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZLVuXe1uXt0vLeAheGqtNKRM2no7U2HIYTRT5p2EhF5C9XUycMQxvGniXyNbzrXkNJo9C4raXgcYOjlgNw+bpNowCwXqqqZZ1YbCp0CosI1GCGx1KpR1biKVKae/7bGu7r9cR8s9rvxX9cD0TYBYZJ3KQrm8NrZJxNx3r2CvAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mbk+ubNJ; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mbk+ubNJ"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1f47f07aceaso51012665ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396849; x=1720001649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JLoG2uabhknU+Jtelcz0I6w9X0Nddlla+eHGKKiRhro=;
        b=mbk+ubNJmGgvEs6+B92JFNTmuvLqOXW44mZFdW4PAHdLJOYEj6tj+z6j7cUvYFxBjI
         srX1gcGiXTks6W7K97dzHEi8+7W4jUCOumyw4JYOQdARHppTuWoq1LVFWofxzfude5NB
         qD3CzbWdBaysiqUDGtKM7ZIvq836IAlu4+7uRFkB0ouD/naZt+KdAs8BBfpw7Wv6vgcv
         Q58BQ9HYSqNbwwJnzvqFmJUbWIhTFxUP34SpEIpdB0W61q3WI1+fZdgKd0wC3+kR8JUR
         s6a/r8iVkDftPf1M5N/Sb/C9+kd/78Xpa5NmNLEdCLZYmyuXh3nR1LwXVDTSVyC6WnsI
         70ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396849; x=1720001649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JLoG2uabhknU+Jtelcz0I6w9X0Nddlla+eHGKKiRhro=;
        b=KXdyAEa46L+9fr7ZIklqftjEwBJEZ1LqMJC0J1uXz2HPMDQ0BOcv4usl9Irjxz/R7q
         yc7fV0uaOjmkKQAo0eH/THb7ZGtHqfLIv1Dxl7Z6aD0RGsLNyAz1N91ERDZKk+RpLyOY
         wV4YRNbP9j8wd07D/RL7eH7mjbY6GpzVLY51Rw0CjBcmDUYLxl/I4eYNpdCAJ8p2jOzH
         JUYh7hc/n8/IMH59BkVaJ4VDBCAbiqAgCio0aSylvEThpYIXf8Dj1v7V2cHZY6bEV878
         7L8TulJtbDMfZmoyU23qT10nECE9PtiDGrfmwzI5pRnStXiJgK+5sFLxjiEi1cKIEMGy
         GC6w==
X-Gm-Message-State: AOJu0YypX0VFDIir5IYKx2pdusaUnw+IEL1VjGRA2kHMr/Klw+ON1EIK
	CbqvgW0ElJQbhJ+RZaw/yJc3QI/A8UBEfdqql1fiwXBmfxmKb5jFnz/qgQ==
X-Google-Smtp-Source: AGHT+IHH76Zmx+SCgUDiumV3fz6SVPqqy5mTEwzgCVyGc2QZqjVbOfZjLztH50UvUDAgqLz59LxySw==
X-Received: by 2002:a17:902:da86:b0:1f9:d817:1fb0 with SMTP id d9443c01a7336-1fa158d0809mr115061675ad.14.1719396848910;
        Wed, 26 Jun 2024 03:14:08 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:08 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 01/14] scsi: advansys: Simplified memcpy length calculation in adv_build_req
Date: Wed, 26 Jun 2024 06:13:29 -0400
Message-ID: <20240626101342.1440049-2-prabhakar.pujeri@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
References: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
---
 drivers/scsi/advansys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ab066bb27a57..e5ae43e00f24 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7691,7 +7691,7 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	/* Set CDB length and copy it to the request structure.  */
 	scsiqp->cdb_len = scp->cmd_len;
 	/* Copy first 12 CDB bytes to cdb[]. */
-	memcpy(scsiqp->cdb, scp->cmnd, scp->cmd_len < 12 ? scp->cmd_len : 12);
+	memcpy(scsiqp->cdb, scp->cmnd, min(scp->cmd_len, 12));
 	/* Copy last 4 CDB bytes, if present, to cdb16[]. */
 	if (scp->cmd_len > 12) {
 		int cdb16_len = scp->cmd_len - 12;
-- 
2.45.1

