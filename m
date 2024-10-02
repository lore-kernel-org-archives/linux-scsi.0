Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CE41C9B91;
	Wed,  2 Oct 2024 13:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877048; cv=none; b=PkIjN9yeaK4/DO9R/WpjjP3OPrigfDBGcg8qszQh5WIlCopkdHx/GqSYKh3Gz4uo4CGMf5fIe3yIsVQAIxdIosi/dcEeiYAJz0sBO8LkNrVCqH45/aeZdDJRFtqbCif4rXFOBRPyOqjPhGMPMpuvPU1N1gZxZ8noZWIscrkC488=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877048; c=relaxed/simple;
	bh=y3zYsFzDmVtsnZq5KY5Yd5vtFXgRBVc5qH/k4iL6XWI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=XoqmW+sRx6SimOlHqgnDdb8+2fjdaPM2BjG/F8LeaeaYPutdJF0pBXRvf+z/Ryk80Gffc/c/2cpsSdYBjVchBEADONPnv97D4CNY+ajl4RqQLd/XoS0ysncsiqYuMPIhj6hK8GP7qEy2qVDUWn5+OSxGrffA0aAtyeGwJULDhGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QWgCyRpY; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QWgCyRpY"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c5bca6603aso8066516a12.1;
        Wed, 02 Oct 2024 06:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727877045; x=1728481845; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WWBsEVWHxlmoTxKKfz7nCVNWsm+nWQz4TmY2koB96fk=;
        b=QWgCyRpYXln+aAMDUQb5ffb+Bggpi/nnLacSAVng1jB6V4WZ6Pq+2rAKq5LId1lMhj
         UjsbbhNi9pqfy08ZAVXR1Sj7c60s1FaY/mCrbMV/5JgYvCNl789WhqXAOPb0wFBxgiFk
         rI18jo95g6F690w5yNET6GpvxBRkUOMG+g1qKkpwDbk/rWHuRtsqm6lkmVmBXyvhjeaP
         kTQd+pQqkA2PAVvTPxCb7hqkPsO0TUQ4EZ+ZtksVLPIa/ppcvRvHqdzuGyph/AyuF5+r
         FYVEXbfpevPlq/1c5OdNTSowKWFMGhCe72gX6HL47WnmpzLeRILxO3FL2KhzPh7MZwMm
         QPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727877045; x=1728481845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WWBsEVWHxlmoTxKKfz7nCVNWsm+nWQz4TmY2koB96fk=;
        b=Kf3WnyA8qFBNkBJrCOsQl073iT4miV8/Rj6hWCkKFqUfpHQkyxtu32YbXQ1DFVh8oc
         eNbOlx+UQLldR0g0nJ5h9DIzwTN5Kg3psQsHsKuLJD5YXVg3+fPFyGiOkTQJEo3aNiFp
         ZZMQ8Yme6mLaVZLtxKFfEh2/QmXYhIMfjFe5NCNy1OkD2JMfoDRVLZUgaUc8Eeod5MTL
         mcP81amo0WexuPSOySan3RGmsexGN+V0fVuZTd5IMirpGyBqWB+Ho+xkzTWcB+Q/OiQ1
         STHK0KAhV1s+2ZxUZpi7Ue33An8y+M2xjZJd+4TxKJ2PfFQKMj7kceioWdWYiZ53vaDW
         pQqg==
X-Forwarded-Encrypted: i=1; AJvYcCU6XGfYZopjYMnShKMEMStUqAsPNWgR0FlKvEXBgy5DyG9oFdubJx6R2Pb31GHT51ondjsvD5aLvNuhTA==@vger.kernel.org, AJvYcCUVLxa6z9SEFvbKULM1f9MWO07J31u0c0E/lYmyLhRxX4ywCru/UP3A9BMtRKukJCDcXAJaECAlFckU944=@vger.kernel.org
X-Gm-Message-State: AOJu0YyK9aimUMfFeNH7ZJ1MktNovd6dLnLWnAODc5CMmiOBOUg8MFMp
	R9gzyFe+Fv2oEROtOVFn+xaUK+M6/sihXdtSiI9k8c42tUljHfai
X-Google-Smtp-Source: AGHT+IH/EpAeM+W/UdNV9tXVlYHu8zXbCKQrBu3Iy8uTLO36wckhupjR16FT0kAbYrpuepchBo/poA==
X-Received: by 2002:a05:6402:3508:b0:5c5:cd4b:5c4d with SMTP id 4fb4d7f45d1cf-5c8b191865bmr2406468a12.8.1727877045077;
        Wed, 02 Oct 2024 06:50:45 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c882405b3bsm7589572a12.20.2024.10.02.06.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 06:50:44 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: scsi_debug: remove a redundant assignment to variable ret
Date: Wed,  2 Oct 2024 14:50:43 +0100
Message-Id: <20241002135043.942327-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

The variable ret is being assigned a value that is never read, the
following break statement exits the loop where ret is being re-assigned
a new value. Remove the redundant assignment.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/scsi_debug.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d95f417e24c0..7c60f5acc4a3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3686,14 +3686,12 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
 		sdeb_data_sector_lock(sip, do_write);
 		ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
 		   fsp + (block * sdebug_sector_size),
 		   sdebug_sector_size, sg_skip, do_write);
 		sdeb_data_sector_unlock(sip, do_write);
-		if (ret != sdebug_sector_size) {
-			ret += (i * sdebug_sector_size);
+		if (ret != sdebug_sector_size)
 			break;
-		}
 		sg_skip += sdebug_sector_size;
 		if (++block >= sdebug_store_sectors)
 			block = 0;
 	}
 	ret = num * sdebug_sector_size;
-- 
2.39.5

