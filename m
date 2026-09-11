Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDC546C82B
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 09:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789117837; cv=none; b=jkVc8xCdrphIlrjqyb6YIa766ki0oDC93Qz45vYsaRExql4xc2xRqx7eV6HXPeW6gqO3hEPDv2MmT2RK48pQDJ+ErPvsNcAGvzJ1g/NvQ/NjaHuL0UjEVPIkdz/6bsP1t4TcQI5+1+Vn35kCjlpxfhkOywBn27zmzGrQyWbM974=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789117837; c=relaxed/simple;
	bh=gfMKeptRIzf45FoSM4KSlLhXAPH0rkjAUFVje+uwEaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMoZzpj0FMqIZ1XQmg+CvQcVMkpQl2mhZiXgL6YeVmvQZiPMVMWe4daP1XOXpeK7SwdP62fytvvPZ8k3AAgNMxJvVOYHu3hRGwQJHQHGdwRPFX/wmFpdVq/zyrq+e8XWHeokxFqf8gYlVEUobgwB9JqM0DkDuUdUr24Z86WIHr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UaRrz8hd; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UaRrz8hd"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469d249c6so603140b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789117833; x=1789722633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=THUxflW+6Ol5aXdDjHqfoOqFQFqdrv6zzUkdGGX+MqU=;
        b=UaRrz8hdmyqDBG0EqmR/cv6db7sHVyIiw/EIFpjYr8CV7z9tDyhV7BbGWx7efJO7Nu
         vqyxVkGrEoYzVbcSXGzlVSlxu4/i7JGX1eaU3qesZDnhKkyxfrrFcaFbeW+Ev19j2miZ
         I1+3TW8vpRqlF2djQzOonMNHLEcrZsvvSIIMjzLj6g3cFkUlfV2BdOmX5LpLmLQLD+D/
         EAosaYlrZPcu87wpSltHjTnbtBFTGVA1uuV/wuGCTbIeJToh4nXeyo0jAoMAD+znKdhA
         7QZz15o2HOUpqw8MWibf3XdPH4071kbgtO0BGdhoLL7CIJ0PtBFTWnV8mNz8pCd5PT2o
         1AoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789117833; x=1789722633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=THUxflW+6Ol5aXdDjHqfoOqFQFqdrv6zzUkdGGX+MqU=;
        b=e6mEVNjuVQuzTL8xyjWwuTn3ZjKiawoRK+RZ8SRDF+eLnNu2N0spnuO5ER88x0uQiY
         dVRruARNlpOdotq1p/qMm+bIJ3Jj/QxdwZWKlGDF63PyVTjcvf1aWIeUt5N5wh+Uym/t
         OXJw1HX7jRAgD94YgmZCdYMVmd1RCvw5x2Qm9xR9qmFupWxVJVwHJxOdNLYFsfUsR0qK
         Iu9K6D7iceDVdeF3YUzyupwHUa98Vh/gTnF7V2hlQ1pTSaW4koYEr4Oxwvxq/HcjyG2s
         4uMldMf0BND7NTfLIhfOZVnOMJtyLOi9MxQi9ip+wPauWj03ltf5T0b1gbvm7MPrB4vk
         hZqg==
X-Gm-Message-State: AFuF++kxnDyGeZ0fDNTA6Ufck0X5K0xJJSM6Or+CTCm4miDj/GOVPn0K
	CXAyy1PxcaFawmJqqUKQqQijcQMYHJMit4CLvWL4B2Ix2i8+PYHTrJ/4
X-Gm-Gg: AYBFou2vG/bkHudssap7sS+FOfu7KNmkm8MfpautDiTiJXpOPbXjxcguWynqfhXy71f
	HC1a80rtV/BLFE9IysLtI8qvDVnYIY6b3hSTTh30jSxIgjjGN9CCw/XPAD98UviFHGJl3fXcvy3
	5SFYvJ0r2wDWakXSLBCT95cYnXftwuvZ49uwMY7DXvrtv4LOfODJr8OzcJpB9d5lMZt/Lg95fle
	0w4K6iMpBNs5PULKyPeImlB1sIXvGEUvfidP+i+3WnoX957iYyIfKY0VMsA5vpQFf+fcVWhwCtc
	zhXsIADsV+og08trz54jOTDYthnk/72xGCWcFuYIFGe4ddZauaXjUTRlJFtnHKpXyyThBfl8IdW
	zCK/yJuyvxc3wiu1K2H+ZXoVW4DE/4mprRkVKuz5oMNp2O7015gmOLjytwcUfKp9UVTRKyxFOJ2
	8P3qPyVJwmBr7L6yBUY+ZmD0MSlpKekWYIsLnQDgR5OngeDwrmMjcJ7M0RZRj94e0OEcN+UdhE+
	vktFDdstijmfSSEbMPrWOkkyGTHfkqhu4iASWNqcg==
X-Received: by 2002:a05:6a20:72a0:b0:3d0:88f5:f806 with SMTP id adf61e73a8af0-3daed31ad0cmr5756093637.15.1789117832851;
        Fri, 11 Sep 2026 02:10:32 -0700 (PDT)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6572ecasm822522a12.22.2026.09.11.02.10.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 11 Sep 2026 02:10:32 -0700 (PDT)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: jinpu.wang@cloud.ionos.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH 1/4] scsi: pm8001: free IRQs when HBA allocation fails
Date: Fri, 11 Sep 2026 17:10:08 +0800
Message-ID: <20260911091011.94676-2-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20260911091011.94676-1-flyingpeng@tencent.com>
References: <20260911091011.94676-1-flyingpeng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pm8001_alloc() registers the interrupt handlers before allocating the MPI
memory regions and device array. If one of those later allocations fails,
pm8001_pci_alloc() frees the HBA while the IRQ handlers remain registered.
A subsequent interrupt can therefore dereference the freed HBA or SAS host
data.

Release the IRQs on every failure after successful registration. Let
pm8001_free() perform the memory-region cleanup, and kill the initialized
tasklets before freeing the HBA.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 54b35893261a..8ede1f1da415 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -312,7 +312,7 @@ static void pm8001_free_irq(struct pm8001_hba_info *pm8001_ha);
 static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 			const struct pci_device_id *ent)
 {
-	int i, count = 0, rc = 0;
+	int i, count = 0;
 	u32 ci_offset, ib_offset, ob_offset, pi_offset;
 	struct inbound_queue_table *ibq;
 	struct outbound_queue_table *obq;
@@ -323,9 +323,8 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 		   pm8001_ha->chip->n_phy);
 
 	/* Request Interrupt */
-	rc = pm8001_request_irq(pm8001_ha);
-	if (rc)
-		goto err_out;
+	if (pm8001_request_irq(pm8001_ha))
+		return 1;
 
 	count = pm8001_ha->max_q_num;
 	/* Queues are chosen based on the number of cores/msix availability */
@@ -446,27 +445,16 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 	/* Memory region for devices*/
 	pm8001_ha->devices = kzalloc(PM8001_MAX_DEVICES
 				* sizeof(struct pm8001_device), GFP_KERNEL);
-	if (!pm8001_ha->devices) {
-		rc = -ENOMEM;
-		goto err_out_nodev;
-	}
+	if (!pm8001_ha->devices)
+		goto err_out;
 	for (i = 0; i < PM8001_MAX_DEVICES; i++) {
 		pm8001_ha->devices[i].dev_type = SAS_PHY_UNUSED;
 	}
 	pm8001_ha->flags = PM8001F_INIT_TIME;
 	return 0;
 
-err_out_nodev:
-	for (i = 0; i < pm8001_ha->max_memcnt; i++) {
-		if (pm8001_ha->memoryMap.region[i].virt_ptr != NULL) {
-			dma_free_coherent(&pm8001_ha->pdev->dev,
-				(pm8001_ha->memoryMap.region[i].total_len +
-				pm8001_ha->memoryMap.region[i].alignment),
-				pm8001_ha->memoryMap.region[i].virt_ptr,
-				pm8001_ha->memoryMap.region[i].phys_addr);
-		}
-	}
 err_out:
+	pm8001_free_irq(pm8001_ha);
 	return 1;
 }
 
@@ -575,6 +563,7 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 	if (!pm8001_alloc(pm8001_ha, ent))
 		return pm8001_ha;
 failed_pci_alloc:
+	pm8001_kill_tasklet(pm8001_ha);
 	pm8001_free(pm8001_ha);
 	return NULL;
 }
-- 
2.43.7

