Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E1E311C2D
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 16:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776358789; cv=none; b=ILqnd4qZFffQ2QOvYfls22QnBX2ehsWmqDxoCpNuRsr0AHyfsZQ+neOUjJvvFge0C1zt4VEWluWJTvpibq9ubuv1kTIQO7vT1bBvy2UQvSPwNC9xcaYrOpXGJ6F5FmoYA/gIoyz27YL4D2MgCtmamA3sh3M9qos917OIWG/AH+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776358789; c=relaxed/simple;
	bh=1LP+9Y9TG4oK4f0ZkbP0a0/ld5plxckV7HRW4ZFOBCc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u2zcRUIRmJ1Nyp37Yp99AzeRKl/MpLG1NpM/m+HtBBdVGEJ5euS3FBeClUOTi2L+E6I2UsnOg+UmAzquqlOkn+/JFUKEDuOdwYZ/3tffHBOYr6AYb8OAORgOgQhqNpnoQcMeBUNq9zjbPn/MJxOtS0SuGakn8KTjDefP4HJkVYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8Nktlp8; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8Nktlp8"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b2589c26e3so73845295ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 09:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776358788; x=1776963588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VksxkcPuGa1fBZOzll7HizxJVJENQAeYC1HuFM93zwo=;
        b=j8Nktlp8PDB+71AU24VxK0+bQ7JFQw1NN2DJ77fCnHzUsS7MD1/qHkPdISdIxOTC/F
         06HaMbyI5T2LxgB1pyCMVUKwozkahynsMRFxTp/1V9JjMgAgMkOK2/kr1yHud8vDERc3
         HXFkiKxHOsKVzsDGpKBLJzm2Hp7x8XROIjGVaxxrhs731GavfEsG/tgtYEw9yU4GX5U+
         hZF/hBxt1WugNXw1A8aAjOZncAlPpuTs9pB4iwDsrS4dhESIEFA6bl5eyfcmbDEGsdfL
         sHqDOB1nlcvJWE/wwPa1+jtKqRPwRllS6FQcNAg+6sqaDq8cDQGTVqKekKvsqbieT7qv
         oHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776358788; x=1776963588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VksxkcPuGa1fBZOzll7HizxJVJENQAeYC1HuFM93zwo=;
        b=Oe+tEYtI7dB8foCw4n4l8SzCHh/rAtjuK0FziYrWmscvb3WjzDvCPEPDJUZhb4Mfhg
         7wQFSDyjmGQmTM0+iFkzEFeyc+qWdvKIGYtx0OTfxcTfgkuT43HWZQ0Pb0JcoCbNlDvq
         r8w5oBxaXNO/Yu7WdXmQobZrWMEMoGmxZ0jEB/M2ktS/WdnJt2PLmxXyM+DglMKIar+x
         dcyrhkgjN2AybLLHwqesryfD468jBM3lvdruQODSLHe/k4A8/ikj0/UKwMYifYtRGBkV
         xqDX0D8CTojFjnFbYZWpXJD5L9Zv/sH/Ukuoai1KB2W8tX4119cx86aMt8QyLZ1LG52g
         BURw==
X-Forwarded-Encrypted: i=1; AFNElJ8QTNhNFqszKMY1hhJeuuiLVSLqM6IXpsKUCTmYN4ZNivQwpUek6RS/WNmTdAukuPxCWK2xBFi40PXw@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6di5hORJLHfoeKLB6l2L7S8RZCyocy1SGVm1fCS3p/Xc28rTK
	j2cWH4KoIzrDf4gYODVwfbCzHUG9d0v4b81mJlH51umKkxxJ6kazFur2
X-Gm-Gg: AeBDievIRevJBEezme08I8LQcbNgnd10xvM4KQLbTAjcDW/WYxHb90Zos5s8IuD5xP3
	KA6eTHLL4OT2eiq/c7ZMlKwztm2lU4gYpL8XCJBDVBmmX+1QcQqdBOrW3kl1KAi5ijKEcHGlgeB
	pUYhL+tp7RAF7rxfzw6cvbGYR81FpIv0UZs7+ibjynvWghI1nN/hcTWugDaDGHbVESsP5fqnLyl
	LP3iVBmqTrX2RGAKqUKg8WvY4+agJJUaNdio9RtNeW9n11AEudHk9qB6of4tISm13WuH5ChmUIg
	49ZiNHqADSREFqeCaJwpKjQdlfHz/GauhdeXuRblMebE9b0ApQXTb/q6cKyx+G1sCOL7djbAeoa
	6nHOKngHaCubRuvH3t6w8HESiBb/ct1BluiUJKoIhjexvoyyzYDjNv6Hw+sS0JkKeBykPjVwxUw
	uXDgcY4rG6YCDNLPfWqQRvAurIjuxMX5wkydQAxnQeDw==
X-Received: by 2002:a17:902:b588:b0:2b2:4c92:c389 with SMTP id d9443c01a7336-2b2d5a6e445mr206661275ad.34.1776358788087;
        Thu, 16 Apr 2026 09:59:48 -0700 (PDT)
Received: from lgs.. ([223.80.110.69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4780f0428sm59683665ad.9.2026.04.16.09.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 09:59:47 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] [SCSI] advansys: fix host resource leak in EISA probe error path
Date: Fri, 17 Apr 2026 00:59:35 +0800
Message-ID: <20260416165935.3958686-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A manual code audit found that advansys_eisa_probe() frees saved
Scsi_Host objects directly in its error path.

Those hosts have already been successfully initialized by
advansys_board_found(), so freeing them directly bypasses the normal
teardown path and leaks host resources such as IRQs, DMA or MMIO
resources, and the Scsi_Host release path.

Fix this by releasing the saved hosts with advansys_release() and
dropping their corresponding I/O regions before freeing the probe data.

Fixes: d361db483241 ("[SCSI] advansys: Sort out irq number mess")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/advansys.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index fcf059bf41e8..022a8190ae31 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11373,9 +11373,17 @@ static int advansys_eisa_probe(struct device *dev)
 	return 0;
 
  free_data:
-	kfree(data->host[0]);
-	kfree(data->host[1]);
-	kfree(data);
+	for (i = 0; i < 2; i++) {
+		struct Scsi_Host *shost = data->host[i];
+		int ioport;
+
+		if (!shost)
+			continue;
+
+		ioport = shost->io_port;
+		advansys_release(shost);
+		release_region(ioport, ASC_IOADR_GAP);
+	}
  fail:
 	return err;
 }
-- 
2.43.0

