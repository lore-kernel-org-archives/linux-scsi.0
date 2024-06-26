Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61E2176FA5
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396867; cv=none; b=GCWhSD29k8FvC8VhdX8A4+/qShfXzR+sicE5wFFvGE40/gY5aFfx4XItAYXaAicUOsmhzEoU3TZIUu/RYSOZiC/xCyIg1ma/IEiZueetspoWC/x3SP+0BVAkhRjjoYYeLHpLuBXxGeL5zutDr+DNvBSPcELaXrvAEAZq6Mxo3Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396867; c=relaxed/simple;
	bh=Lpop0nfADxhs8O0ttyskxF1m7MTLqbP1GDEFj4MgJdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gtf/rBCt+vyDt3gMmfMYjBwCR0Jgxpw1jpJGWXgszt0edNgNwQ2fqNT4E2A3XCCYvfgXptl0QTQ19fweNHGEguFIzv2HXvxFSYj2DHl131GKlcKosjGmzv5hIjrn/36g3uYkBBS8V4VD9ontk8lnOD4m9JupvRunSdCBLqW9J1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iCiR4nNL; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iCiR4nNL"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1f480624d0dso55402055ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396865; x=1720001665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuY0dw8oPJEFMzmrTleHKd1Ke+g5UwuSoBavurCfkoE=;
        b=iCiR4nNLBrQdKi3JPzcpPyCaDZfBPyrrPzsoctBqg8GOZ/CQWNfbc9yo5lJIvQRT6K
         e2u0zgfFVrcZf1gSEbRJnVNUkunkWZpoLydHbCdXWn7f6pHfs4CpE11U2Ryj+s+xvjLh
         E7f3AJ3hlnmxOYBnmRPuJ+ZpvagEq70N1EJF9xtT7BPfjj4CFQMZhAUDfBhy5hm1kjFs
         KDNs72V0dR6TzThTIuqqB//9Gs7OfK9WHTNi5jA9pyM646fJPWUh/QWY9UmnKJOPoHZS
         4ay42qLYSi1It3DOvdXKsAXqVI/GcBOAS63Os2Q6JBUr2TAuPRmsf4B/RVjlFH0V/qAp
         yxLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396865; x=1720001665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FuY0dw8oPJEFMzmrTleHKd1Ke+g5UwuSoBavurCfkoE=;
        b=MEvW3967V0vFmzDpCLyyjvlobnCKoZyLmSxOBF8bFH7NvdmRW40vFB4c+XQrAlRuq6
         MwiaZc9/LFjMV1LNqfb7eadXBqX2qzAp4nEx1dhprr/H1/BvdeCqoAe+tlcIYCUuE/gm
         hHme9LAoy7lLfPYEHZCjHhUdt6zkEYEQQ6zTiJp88PEQ1SVhKJS/uWULPOrFc4zhwgVJ
         mjzQ/rlxvmDET5z3w+9dzYSKXKMfKmIHJcBAGitJ4jo8scN12t74p8LMXqa3uZBANb1A
         Yg85b6hiUe9/XGR0NNwL1o243DwrtsiAIskGTAUmMbbLMt2+P5btsxpvo/kvw+ihv3hA
         lj7A==
X-Gm-Message-State: AOJu0Yyp2TguEG2huU202Vq+yX1ELE5TR/8WawL5seyiPw5xxDk2vQ+p
	yHTLHSjWTOs3fTvv9kb7/PiTpwxBxJEctu2ueDtutO10xwpka6dmMx/14g==
X-Google-Smtp-Source: AGHT+IHg3pQ51bji8X13qaNi+qvuUUd377cs6puCsnUoAYwS/LPcZsOOb7c8vLsAI/jbG7Qdfd2tLg==
X-Received: by 2002:a17:903:22cd:b0:1f9:de01:902c with SMTP id d9443c01a7336-1fa23bd19a0mr135311685ad.5.1719396864928;
        Wed, 26 Jun 2024 03:14:24 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:24 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 08/14] scsi: mpi3mr: Used min() in mpi3mr_map_data_buffer_dma for buffer size
Date: Wed, 26 Jun 2024 06:13:36 -0400
Message-ID: <20240626101342.1440049-9-prabhakar.pujeri@gmail.com>
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
 drivers/scsi/mpi3mr/mpi3mr_app.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index cd261b48eb46..350f3df02baf 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1171,11 +1171,8 @@ static int mpi3mr_map_data_buffer_dma(struct mpi3mr_ioc *mrioc,
 		drv_buf->dma_desc[i].addr = mrioc->ioctl_sge[desc_count].addr;
 		drv_buf->dma_desc[i].dma_addr =
 		    mrioc->ioctl_sge[desc_count].dma_addr;
-		if (buf_len < mrioc->ioctl_sge[desc_count].size)
-			drv_buf->dma_desc[i].size = buf_len;
-		else
-			drv_buf->dma_desc[i].size =
-			    mrioc->ioctl_sge[desc_count].size;
+		drv_buf->dma_desc[i].size = min(buf_len,
+						mrioc->ioctl_sge[desc_count].size);
 		buf_len -= drv_buf->dma_desc[i].size;
 		memset(drv_buf->dma_desc[i].addr, 0,
 		       mrioc->ioctl_sge[desc_count].size);
-- 
2.45.1

