Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661E317BBF;
	Sat, 24 May 2025 03:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748058947; cv=none; b=RWGMcNtihlnKdJvj6T3Q7muBNpoKoyPiKaHHPjmVoH8RpFVbEIFaPI0kayUulXG8PLJJp6ZaQD/co4C6RQGJgBrj9vKnvYlcX95EyARKWuL7e/mey3HqV2xzJdZYiPtvgXz1m8ash7Myz73hUj2yNQCQ8SDjNvXFaLOPikycHqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748058947; c=relaxed/simple;
	bh=JU8iOU5XsMKv/yF0+qrL2TTRn1KelKiIZHxAy0V+ank=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y14PzEC5/fLe1RuQJcSI0OK8x/pzU9sP68g+pFTtbesBItynMjacdXjLwezMrIaf6+BgsnEaLpeq4FTfCpzqVkb0vgFEp6o7vbXrLJU1DQS9xFZxNaGUPxVdhi6s8ZQZQZRoKusmywzoOpR73WtHpoNKzw+cOzioIlftmPUTzmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OuCZX2MK; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OuCZX2MK"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7fd35b301bdso373527a12.2;
        Fri, 23 May 2025 20:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748058945; x=1748663745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iOOMMXXqkOKG/dAPYpGHtEnMJRzYGPdaiwfPy079iJQ=;
        b=OuCZX2MKLpVEjfx3lng0XSznsVpKbtqa4yoDgeMO28rOxecHOL+D/CcwCNB3GKV96y
         Gi6os8cT5A5gIqhmMPz14jPSQBzY7cM9ixhulkda0spYPo2LUZdvi1ueofvUB7Ms25Ei
         1GJpK7FXNWYUbojbpFduE6yzvqRoJtAxzVvT0VOYlgLLlhL7JsbhQTea5GRsXhHza4Hp
         mq54tnb/UrYzU756Op4fy/EBi2xWecfUwoe+OO+mkeTWYGOdmhFOsGvbjyka7woznswz
         z86BS7P/e6BEUC1fNEd4pBPzm6uJU7hq/e3PZCBoiUtLBJvMWZ5J3kJEW7iSlPO/H/fJ
         zY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748058945; x=1748663745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iOOMMXXqkOKG/dAPYpGHtEnMJRzYGPdaiwfPy079iJQ=;
        b=g2WDv7U22eg25g4B+fjGq57k3KHNr4sQhdhGRRBGHpJwgnTL6Iz+B0PtEnXohljUlJ
         ZJOUeWfmsz5mXHwqetuzVGSCGDQkwhUBalxj9PVwVe4O0Q2aCNjiJVPjuTR7V2W6saKe
         UsMH2uu7rMUPnw5hl5pmjXAc8+V8hiiJfsQDfrEolX7ZmBgYl6iKJ086wDCjJD8nnMpU
         35KcZJeo1DPrwcovp31vpqwnJlHAxCa99Ipbl6efbqwFig9bPSOxGEElrWQdM3P6owJz
         0j5BczDh77UhqbQoMzLplptAvvs/GagzWYNbokobA06+a5HlfIA0Q6IP1yM0c31CK5lu
         2wog==
X-Forwarded-Encrypted: i=1; AJvYcCXXlnXVFM0/sSbqjZr6+4nRUQylNtDGpynDiG5ilRVUzyb8gar5JE4KEEC99Xan7NscOH0EZ0cS28Crv/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YypvrxVhFO64Ue0geXSJ+YOpQX3znGewU2PQHY8EGrTWy4B0SOj
	aHYebkXlRyhQR3XuO4Lj9xK9rUYN9fihgnGvmCumNsiVavaHU5tVTL5N
X-Gm-Gg: ASbGncu94piv6CPjxopslb/MeXqXrTYXb+4ccFaaPkI1nRygrRQsyuwIj0T9KcQfm5V
	E5+ZfcYOtPDkd/JaAxtkmLnuW/ac862n8DBaanew/urOx9uNhYjlIx2q9+WY4PbWQcsBvk4U+IZ
	30yh+XXP9j6xc+OQmmRKdrBFIwWwzRT3/Yya3LfdmaZ+SkOeoDaVvatHUyLgwlGAk7r6fm/tuGK
	ad1S4TSAPMNFbPY9bMzbtNBTyQrfxxMWQWArz6k1Y5fV/l4hgDlCkdwtJ8IdZU+K3Cyu5sggDmf
	63ubzhra07KpSpMFj+na+KOSXs3A82y4MG6Bw/KeYBpmrCUcS6M3d+rBeoifSa2H
X-Google-Smtp-Source: AGHT+IGFrdmT47Ot+f4lT/yBluPn5u+8o8zMcAQYNom7xNEYdagmtxyMKQjvuMsVnUJxleXfcz2Sow==
X-Received: by 2002:a17:902:db03:b0:224:1001:677c with SMTP id d9443c01a7336-23414f32ca9mr27166425ad.9.1748058945398;
        Fri, 23 May 2025 20:55:45 -0700 (PDT)
Received: from n.. ([2401:4900:1cb0:129d:7b0a:6b07:3aed:30f1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2340934d8a0sm10021235ad.167.2025.05.23.20.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 20:55:44 -0700 (PDT)
From: mrigendrachaubey <mrigendra.chaubey@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>
Subject: [PATCH] scsi: scsi_devinfo: Fix typo in comment
Date: Sat, 24 May 2025 09:25:16 +0530
Message-Id: <20250524035516.27341-1-mrigendra.chaubey@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch corrects a minor typo in a comment within scsi_devinfo.c,
replacing "compatibile" with the correct spelling "compatible".

Signed-off-by: mrigendrachaubey <mrigendra.chaubey@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 90f1393a23f8..3772c3bca5fe 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -863,7 +863,7 @@ int __init scsi_init_devinfo(void)
 		goto out;
 
 	for (i = 0; scsi_static_device_list[i].vendor; i++) {
-		error = scsi_dev_info_list_add(1 /* compatibile */,
+		error = scsi_dev_info_list_add(1 /* compatible */,
 				scsi_static_device_list[i].vendor,
 				scsi_static_device_list[i].model,
 				NULL,
-- 
2.34.1

