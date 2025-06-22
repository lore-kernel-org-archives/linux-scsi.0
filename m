Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C8972622;
	Sun, 22 Jun 2025 07:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750575941; cv=none; b=BNPktgtrUpSzsJANMnBXtXcqN3OwluNDRS9/UfEp5HBdLddBZcDrgjnsL3xZqqKHqiu2oDioXa7mUNg4Pp5dmvC1aZQrdH85PSSEGEC2RxwhrB/WutyTHPhQvc2EE/cM6wDA6NY1hDfKUx4a4JsbQKNS7r8FUJa3h1KF5rH3b9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750575941; c=relaxed/simple;
	bh=l9l87sZf62pg5/dTBE6/y8SuF5Z7ql7BaMW5Ex2MJLc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b4NdtW89OAiSg0j5v9M6AR/84fqQVW5/vxW73g+Gxo5acKeaE1N8rITDVFy6DsKK0Qshr9H+viUXmr9zCkKmQH5q3h00CkLyHvGhZ184XKlowrkMW+kvdF2zGL5Gz0BD797fpoPJlBt/RXyaS2XQjfdeUAv1LB49aQVrBWwtF3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JQ+BguOP; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JQ+BguOP"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b31d592bbe8so2134787a12.2;
        Sun, 22 Jun 2025 00:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750575939; x=1751180739; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m8TXebLUoEWcZMAmOu6HQ6oFbM2pQE/lBu07ZCSxO04=;
        b=JQ+BguOPS54bX7NN7UwtEnEeynUiDiR/c6evMQiDPn3WgUoceh0h2ytM8nbXQRa2zP
         u0OnG1i7b9SP7yw48hMbYzKQ5qVy8eLinphTdCRVbBgBCVqmBf3blNV03K7oTdVb/m+X
         RBLVPqcIptg9S6+D3UsKO8Hhz5n91WUFlgRAOIzRFJLhjLwcJ4ub8t+Eg9r7JusDdDcj
         KoTigfR3Wbaf7t0w9kz8dXJekSABfiFujJEXI0RocDQiIUZCa0NFeq7MHtBFRcndAj2S
         t8Kvf5m2ojow/vvW3+PhPEf3T81fEyFZlE9dGFCsikgXOEV8J7vvPN5heTgIOn9k1L0k
         JqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750575939; x=1751180739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m8TXebLUoEWcZMAmOu6HQ6oFbM2pQE/lBu07ZCSxO04=;
        b=UuTNadV0pj/FK2Z6zSaqxplFajj6kyn3hwGZu7hGfJXvTdIuHJQZK87s9BAvtAr4dz
         godRNQ+56Xav1kRtLhdCspXcH2mDxl0vRon4fGGImPQWVLQzrhgvge9po+UE4CQsIIrh
         MFd5a8aS4Jgj2fL+g2qSWkVUVt9QxW9H6TApmD32v1eDWX8M9yok7V4hTzwJqOKbDz8g
         ZRShNSDIelSLHympIyk0ltIbg/9Rn/fczLiCv2QPTHYG9tFk/feMby8gKeglXHek/dwq
         PxPrfj2zUzscHjuuSZqmvil1oMKrR3CQCKO5a3OoXlBNaL8+vzZhOGTw1u9sO5dlJNqZ
         Q3aw==
X-Forwarded-Encrypted: i=1; AJvYcCWHcrCJjO65Oo2aA7Y3x3nwDBhM6XZeZJAeoeOyG4/JOdX/q1sOnYGWO9/xIzoirLpaebSk+LEM9LEutmo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxkc2VXbqDGKvZphiyYXDu9D8MfzX/Qq6XhH6Ude9JP89d87Fip
	rWyybUnQRlm7gw1oNWM67F9Tnc7am6lj8+e1KTRZWLtB2/wfKi6xfsvk
X-Gm-Gg: ASbGnct6X6mn/uw3SNJwN/lTM5lIdVp/bx1ZDDizD79TBTIV4Tc0+VUzoUiSBYNAE7h
	BAo9kRkv1awLmPR326ks3llThNIAcTWHhiqi4g9Q6ZFdS5wC9+fdV3T2ueuwqkGRr28venAjdCG
	Y1keOxamupwHsCHhkNVV2ARMd0AaIWVHyBBCz2OBMlsfXElmU7gE4Sr0ju2CS1JdNaZ8po7YUUr
	Yw29RmPNGvVNNILEws2HzrOySYYh1ZnMNJnFzWAbbfvB9n4at3wSg1gch/F5Wv0gmxyg9FkCBAK
	6Kae8PB2/yuI/9qmI1RM/EYzsTX8GM1pTfdbryqd7JOD2or6cyBwcvx9PoNQEw0EkIaIIoF6zl0
	=
X-Google-Smtp-Source: AGHT+IHOY1NVRCuhUcPfLZ+2JOQpsI722dBzpPSfCKAL/WkxkTXZtezK97UDzR64v/NoZkwzHmwmgA==
X-Received: by 2002:a17:90b:2e87:b0:312:1ae9:1529 with SMTP id 98e67ed59e1d1-3159d8dfb8cmr12848835a91.27.1750575939131;
        Sun, 22 Jun 2025 00:05:39 -0700 (PDT)
Received: from n.. ([2401:4900:1c0f:2858:1595:9335:9300:7c1c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3159e0856bcsm5171326a91.49.2025.06.22.00.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jun 2025 00:05:38 -0700 (PDT)
From: mrigendrachaubey <mrigendra.chaubey@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>
Subject: [PATCH v2] scsi: scsi_devinfo: remove redundant 'found'
Date: Sun, 22 Jun 2025 12:35:20 +0530
Message-Id: <20250622070520.13297-1-mrigendra.chaubey@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250531054638.46256-1-mrigendra.chaubey@gmail.com>
References: <20250531054638.46256-1-mrigendra.chaubey@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the unnecessary 'found' flag in scsi_devinfo_lookup_by_key().
The loop can return the matching entry directly when found, and fall
through to return ERR_PTR(-EINVAL) otherwise.

Signed-off-by: mrigendrachaubey <mrigendra.chaubey@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index a348df895dca..e364829b6079 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -269,17 +269,12 @@ static struct {
 static struct scsi_dev_info_list_table *scsi_devinfo_lookup_by_key(int key)
 {
 	struct scsi_dev_info_list_table *devinfo_table;
-	int found = 0;
 
 	list_for_each_entry(devinfo_table, &scsi_dev_info_list, node)
-		if (devinfo_table->key == key) {
-			found = 1;
-			break;
-		}
-	if (!found)
-		return ERR_PTR(-EINVAL);
+		if (devinfo_table->key == key)
+			return devinfo_table;
 
-	return devinfo_table;
+	return ERR_PTR(-EINVAL);
 }
 
 /*
-- 
2.34.1

