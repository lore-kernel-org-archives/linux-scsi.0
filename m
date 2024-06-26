Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921CB176FA5
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396864; cv=none; b=PfORfYcBa+QmQAr0hXdhVj/1j2/jzQAlIVeCf75LJBzlZz3aXq89cJYQeAdwOghVwF1021laXunD1UPB/7xaW4ajnulREnnmCHsnn+BixFhCcJhaGnFquaEMZQ73NfmziESkV20EsNWHToQib/UTjqCDPXAvTPsKFhIZx8Okl4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396864; c=relaxed/simple;
	bh=3ikQMWc8UtYYolUrL+XPcqZG44/cQVeSKs0Ig3k5n50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/YopCvIZbJZ5km/b8GdmfO9VidOAV+/TC+wgxoopB3cjW4pkgKKszimO0SzjgnTKiQ1ZdzYY/FoVIltBAQGZ/U7FJcw5R+ev2THW0P2NsdySJ862+yM6h8mR1rP4chZI7cmxt54JmnCKzmur845LvMjb169TPzYMgghX6gvtgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e3jvb+Y/; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e3jvb+Y/"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f47f07acd3so53571805ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396863; x=1720001663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zvrU0gGdjp0IDM5cybs3chAZgV1peeqZh5UJovl2csI=;
        b=e3jvb+Y/dn7iJTp/UQONngH10SV+VuuTbBBVRsV4VjCFYL4MI2AqfmeweEggc3U0+1
         YbIjTjpdX86LuNplgWuC4mI7Z8Hi/SIthaHw8VaCgt+KnujO5uny1RU5bgEAFTPGG/uc
         gLHWnZbdUGSM2Nj8gvRfKEHYGE38d52l+dS0t9Nq+KwRmqQBW1MqbUvJEeIVxLK+B4Kb
         q1bWY63/tmjx9vautnqZTubI8pDcBQt4OSjfWZ/wpkoYDmg4pL91BAzJXtg+4TjoAnhx
         +AhgPv1+Xh57NRoTdnp95NVyaqMblETA/sehmHYvldZjhPLgiyQopZX7/N8k2RyvzQwk
         QZ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396863; x=1720001663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zvrU0gGdjp0IDM5cybs3chAZgV1peeqZh5UJovl2csI=;
        b=mabnQH1q8bOb463SB6ttCj/9oJTf6ZQ20p1RdxXYDMDDQKgEAKmYHC+mSE3jVq2ILp
         YaP2ux49cS8yIy9OZ81EA1pnt6Hf/VyC3VG7FuMPcWb5RjY/yIccjNdY/BH2W661xJWD
         UqPuZZ2gsHwa+IIsT26n7URFqerAzMibLOzAvQiBCdJdxXgQ2D/3xRKg0DKbPRGhi0tK
         aju250upB/YwqRkjZ8SHDBqVItZhoX9McnxM2xflKIXwsjO/JO3S+Ium4/JnSD8S9fqX
         38T7prCKokjm2sYDbkpwp0bfU9GY8CZYDZH4UxNxv7Z8OI0Dd3gdKeg6B0BNTNQF18S+
         Ooeg==
X-Gm-Message-State: AOJu0YxV0OkgBY4dNNAOeuv62muHdHT+ZY8RG56jVHXJQvRMM9ci71kn
	7Kvfhv3jifjUFve/N5xe1FE54bSj+V2TQ3uMBL1xkkrP9RqGixPSfIr1NA==
X-Google-Smtp-Source: AGHT+IH/j6xizen67xnLH/LaRa7jofyi8Nx2ApvXAXuLyuXPNKy/ISSCE24kQZXVZqN3k1MUU21zAg==
X-Received: by 2002:a17:902:ced0:b0:1fa:7f7e:2e24 with SMTP id d9443c01a7336-1fa7f7e329amr29557265ad.26.1719396862631;
        Wed, 26 Jun 2024 03:14:22 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:22 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 07/14] scsi: megaraid_sas: Replaced ternary operation with max() in megasas_alloc_irq_vectors
Date: Wed, 26 Jun 2024 06:13:35 -0400
Message-ID: <20240626101342.1440049-8-prabhakar.pujeri@gmail.com>
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
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 88acefbf9aea..ad7369d78ab9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5996,10 +5996,7 @@ megasas_alloc_irq_vectors(struct megasas_instance *instance)
 			instance->msix_vectors - instance->iopoll_q_count,
 			i, instance->iopoll_q_count);
 
-	if (i > 0)
-		instance->msix_vectors = i;
-	else
-		instance->msix_vectors = 0;
+	instance->msix_vectors = max(i, 0);
 
 	if (instance->smp_affinity_enable)
 		megasas_set_high_iops_queue_affinity_and_hint(instance);
-- 
2.45.1

