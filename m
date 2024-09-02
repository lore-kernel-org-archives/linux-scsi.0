Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7318519F139;
	Mon,  2 Sep 2024 14:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725286977; cv=none; b=X+Thkjn2ri94M6TxhVNf13OVcVba20K5r2nHl+bITTNQECgapXECtzqMAJt51Hhrr9WcRmCTAtPbRMOFTbKjTFz63v5Sz5FsvwTM68gYfUrzy6Pyo//rZVTrD+cLrQ567c6lZZ6D8vr5jqn2gfB+X1Zhuvu7+u6bE3wrk+Rufj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725286977; c=relaxed/simple;
	bh=+m7KrcY3Zd+TvZpm7I1VNB5h+aHTR2/jWfUjNDgdG+M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=f32HwQFMiKuyxHg7lahAGK7UqM1e9zQqQzi0EV98aYqPzek7HZlMLr/D25gV0RVQ/LSbliULeyP1R3drXMwa0Jfc9iXDqjwuDvfke7pvf8ACBYg9ocqrLj9sq9JMzuK4qLjPI1tSVfopXhNUiQcNPKqS/hoHrN5xVcfiYZ0NUkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T3zBKoay; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T3zBKoay"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-42bac9469e8so35893585e9.3;
        Mon, 02 Sep 2024 07:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725286974; x=1725891774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ByOVhvRwqCrOoU+CnVRLsOcyP0QsvAOUfT9DN4RNoWU=;
        b=T3zBKoayt+UA3AxppazXXFXn2/JyC1yXGCUzzBXXBieg19izmZS7q8II42U4RMNzsI
         JoKa+dh//f2sU97hbxLyqzefisa8TKvsUGSfP5QaQo+D5HLV3nRGXnWPeGv3zDIhKHIR
         XInNTEBNHI6pc57J5/dg4SXrlNyu4V8HQy4la36zNAT1k9/l+nT/U0HsDSsT+H6BAvBP
         OdfubDCuqNDZaI+Fe7jSGGx+4KcduyGBHzMXoBjT2VnTlPpoSUNE43cYrXSVHpGP5dpp
         df3EwPuaLICf7oPiaYthQxpFy0VopOH5VHCF6LbX+O7EEee0HLQXiMUOhh5w1s8Hbl7W
         cvZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725286974; x=1725891774;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ByOVhvRwqCrOoU+CnVRLsOcyP0QsvAOUfT9DN4RNoWU=;
        b=tqjtuetmH281b+29F4UqkWDJR2q3uSYy9FPdVXbEwquzF5f/xjtJJ2nVckH9jiFA2d
         kWk2lGmc6z0r2Y38QtYsUYxssSi+TQDg7T442Eb7KL0VVFjVwHEFEXclBhEkJSp0+PVr
         qarDTXULR0wdN2/HDJBVfDaSY241S65IAk45ZkDPhZ4sPimhVrbdVLkiolqmxBYARv4d
         Qqvw+aJHKmx1mkDxIyAAeQPyW5FiunKvG2BTUW+tVu7jFHKv4IrixwHFipb7cVJjL38R
         X9x/H65t7Xpr0q/pSlLwJF4I/9Lwr0oUv+HM3KRpbO//6Mw90r8cOvI3geyucYT/aOKr
         EHhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJACp98PGdvwbQlFMo99jmsVWzi2H7kTIotKJa/G/p+rK2bZjrrTNgaSEVh/kfgjmij2rZu93sw6ikfA==@vger.kernel.org, AJvYcCXsnoRC8GsQNX22nHs1XiwKCTgc2VNImuzDpMnm4/M9QJXdBRgBx4g2I5P47mUyG6swLxAxcBAto8FAEkY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6laxFM0eF70z+D+z+pOqedQ7Q4fFj6XkhaKBBfh4FJ87Hk3Yp
	h7Z4yhSNpMgj3dcmXXwoGlK9HVYqqczT0Rr05sG1nqs50Bv+X6aEw+8R9lQX
X-Google-Smtp-Source: AGHT+IGFRo73oF4xaHel3PVVWWVDWfrYCRfONvxK74loMqQbS058GHGXJgQUDFgz88BLdi1/ZfbvsQ==
X-Received: by 2002:a05:600c:3ca9:b0:426:6220:cb57 with SMTP id 5b1f17b1804b1-42c82f67431mr27542525e9.25.1725286973521;
        Mon, 02 Sep 2024 07:22:53 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bba57bb20sm117180715e9.4.2024.09.02.07.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 07:22:53 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] megaraid_sas: Remove trailing space after \n newline
Date: Mon,  2 Sep 2024 15:22:52 +0100
Message-Id: <20240902142252.309232-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a extraneous space after a newline in a dev_err message.
Remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6c79c350a4d5..4ecf5284c0fc 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6380,7 +6380,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 				GFP_KERNEL);
 			if (!fusion->stream_detect_by_ld[i]) {
 				dev_err(&instance->pdev->dev,
-					"unable to allocate stream detect by LD\n ");
+					"unable to allocate stream detect by LD\n");
 				for (j = 0; j < i; ++j)
 					kfree(fusion->stream_detect_by_ld[j]);
 				kfree(fusion->stream_detect_by_ld);
-- 
2.39.2

