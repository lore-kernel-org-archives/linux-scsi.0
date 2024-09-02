Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526CB19F103;
	Mon,  2 Sep 2024 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725286326; cv=none; b=MPBKbbXRQXJ2Hg+6D+H8UZi7zJSt72Ci51GVH4yiF+UbbV585GZtKd4ChW2lTl4OOXc4jVIW2D4mzH3IO6WFNlnur60hablz+P2ZpRKcSYxw8JsobozZ44O79M6Z9KO8DQ/NUtpS+MEzGpuZZ5ZtqP+h1mJDuVu6ZPnnOdrc37s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725286326; c=relaxed/simple;
	bh=Y3dT1cqEaGxeNcpHnUz7gh7yRKuWdeTj/5wcehnNv6A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=CYn3mwPcYy17x7uozVf/5KJJTOwp8retbQk2FBXF13jtgOzXTEwldLFt8Fe8shv1Ln9ne8s/vqLTcS35jTu1P4ilzpHpPJ8UivwWcn+oF5/cm5B/zJvDXGhGTmsPHZC7ZYvQNYjYSLgp3F+MpHcbv88+WY50gv5ZRG0tWsloakU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NoE6E7dt; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NoE6E7dt"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5c26815e174so639852a12.0;
        Mon, 02 Sep 2024 07:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725286323; x=1725891123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RptCdAZky21+tAU1YnkwI1FByFYF8uROiRobK4HGMq4=;
        b=NoE6E7dtXsy56oVOfAKVjeeNYvTR8pC3oe1mRFKP/iCgfeaBcl5mXDvcflZU0WJ1+L
         cLs5bUYaDWY1oQxE+/cD5WbLy2mCj1AVQ7OUXalKJ0BshKghrZQUJMOgBPmykYd7p3se
         8EGaqqshME1cySaeRK7I0Xtil8XH0QS1rrN5MXtYHarVu61JCoJXTVeAYiIXBnTaRgZA
         0+7giRS6EuDOlb02i33NKpfPo/HrbYeK6NDTnEf86w9G2or+i+5+v5kqMfuP0RdSBvI/
         x6rSbAZvks3RhOdsYoKSbLR4p7Tr79+mz+sCyzHVg3+7cWB1a3OQO+dFl6XyqOqje5YB
         0m+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725286323; x=1725891123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RptCdAZky21+tAU1YnkwI1FByFYF8uROiRobK4HGMq4=;
        b=m0PNCzqyUFVCFFMkBJhz8LtF27QdQVn61iZR5TCX0jC//bp9S08jSSNRGhcsqN7MXv
         TVcA7ZFELAJJv4iLWyW3VoiME8+9HZC+JYQhHxtvhMjLpYm6RNHdV1iwFe8dQKtVCzy3
         cpOJ2GQQ504VHHZT917C5DYuAHq6Jaqgta+9iJagtsiYDEy1VERVqJZsrd8MIueNUXJD
         p3+ZLYdgvttU6q8urjAAva0gvb8KSz04h2RVE6zvGPhmHKY9A1mqaqO0+8ndgMvmWg+V
         0ZfU7N5qif7JHhpw1PPDopefRExLY0xKmg08jBEW3e74m5PuMum1v6o2gnVyK+XOLPjj
         Fo+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVUs+Kvuy4gohNPgW3UJUQ45hgGEVgc6b/8A00gXxOEOcuDjVTCGQCd5KVkKymBVQVnEgqZ1rJDSWb0PA==@vger.kernel.org, AJvYcCWlS0/svOCTsdbdvAP0Vq+51IUCRrOWkStu3mMa/bSC10QdyeNBKu3eeHouL+KO5bZJuVrKdhtGm69Xz6A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxayVQK91SL5zT/5t3NvkOu+36rw5WX7a7BL/YAMQKKQs48nTJz
	OuWFyr4gcLte/OqdR87TXPCG6wLZ+GpgxRlME/EyGiLvQ3bWbRj9
X-Google-Smtp-Source: AGHT+IH8+ym5kCfrw/asOTbITqJyF7SOHJahHtR/KU4AxQeW5WnCSDCJSg5AiZSfLxAdOIT83maKXQ==
X-Received: by 2002:a17:906:da86:b0:a86:722c:1460 with SMTP id a640c23a62f3a-a89d8782136mr498124666b.18.1725286323328;
        Mon, 02 Sep 2024 07:12:03 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a1cc8a2d5sm12301266b.28.2024.09.02.07.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 07:12:02 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: zalon: Remove trailing space after \n newline
Date: Mon,  2 Sep 2024 15:12:02 +0100
Message-Id: <20240902141202.308632-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a extraneous space after a newline in a dev_printk message,
remove it. Also fix non-tabbed indentation of the statement.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/zalon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index 22d412cab91d..15602ec862e3 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -139,7 +139,7 @@ zalon_probe(struct parisc_device *dev)
 		return -ENODEV;
 
 	if (request_irq(dev->irq, ncr53c8xx_intr, IRQF_SHARED, "zalon", host)) {
-	  dev_printk(KERN_ERR, &dev->dev, "irq problem with %d, detaching\n ",
+		dev_printk(KERN_ERR, &dev->dev, "irq problem with %d, detaching\n",
 		     dev->irq);
 		goto fail;
 	}
-- 
2.39.2

