Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92E2257431
	for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2025 09:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765790725; cv=none; b=VwfXQgwRJJGhTEDYdgbWFD8TRzMmeTwGHkePZu+/itFeMx0EtNk2sv2xRaOJJ7BQGQqprnPLRRM/Uv8FMxv2d7uROF7f7WicrBOlZviBmCVHreyhmw0agFQmmoKJev+H863WmjVx7DJr4yxSqMFZ5ZrlexwXFsDxaTqd3m+irqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765790725; c=relaxed/simple;
	bh=GVUOau41wtSRrzq1gW8TzCx9KKMRVp2AKcoXjj3LKuk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q4TeO6c4TQ5W6I+mzF7n1voV1hQ1DIAND+yGTTX5lVrZ1dTm4AVS3VcbuH7nZUBQu6wjEhHut4ZfxJwy+IWmAJFR5f++jzcmRaQwEtRb8y7Do6xbmlYGZvYOJ3ftwIHL8VyHK0cwt+V1+rWyny0qyPBuR1lZI4SZGnW7Hvrp2DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hmJ+Bm2H; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hmJ+Bm2H"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7aad4823079so2850419b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2025 01:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765790723; x=1766395523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3DmiqPIze3+BLGu9DyGx3Wtju9GPPa4BUef2/znrs80=;
        b=hmJ+Bm2H3BP6YUvRh0PFWTaZjKREKOwSQA3zkC9oXFA3mvYNZuRb0PVcHHyk8XWsTH
         +jrgGXImn3GMomhXvQIi7lG1/L5u706XAO5K3ZE7goRxheUPMGFwMJZcsn8TqIERE/bh
         /gA5JxLtwDr4R/yyYNiXigLyOqmpgqROtr/vpDBArZNrBlQM+iSH0rHiG5pqZ5h7OYBj
         1FWiBVIEAadM2xFlz7tjB5pZGUDgngYKpdhJ2pT0bfTinMiQZiflSq8iJB73ZdBV0lCY
         tVjAw9VuWynKjOMWbOHahbnKXWbDBw/o4gZQFB0NQA/n7K3tmwPBkQFy6dulOR6EvgYw
         gNaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765790723; x=1766395523;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3DmiqPIze3+BLGu9DyGx3Wtju9GPPa4BUef2/znrs80=;
        b=eKbYCzk6ou8QnTCEHTXxb/xXr71+13ltQRrn+b9Z0aLyIIT2OSINmTDgyTfXvgHbmW
         uI+7YFXYI077Fnb5sXr2Nt5E0XzVcxspHz+HB90SYJ98AXgQHp/7YuryE/1UgsQToYpD
         Ldu39DWq/plwFsLQY5gOX9KCP8L5kQwml5cC2F/I0tSZbBWJgdDjW5nLxhmT9r0xey6A
         Ax6wJjqrtKno2A3Pa2VuJDGNxJq2/frsankClqVAdD63XLCwHJ0GGqZBfAm6D4KCN/MG
         T7VtWzqpt7TTaEVgC7f6jh57/5sHcwQgoCoJvNg6JqHNFqpccwNFepZEi2fWcaxPht5r
         IRWw==
X-Gm-Message-State: AOJu0YzINcE50HyVL8KLg52GPPh2dKMBLExfHjy26b6xJAIHKIbVevb+
	vxVWLehZLKgrj9C5RHMXF/FlAb3tKskQYkcowo0FODvyzgQS9IHlnGWE
X-Gm-Gg: AY/fxX7pRmOyhzAIO6eAezA5kaTTCdz89G3tmTAR9YJFD7rORUZb8hgAyKUVOhlcRrg
	ZSa2LFgi/3GcKIo4WegcE55J4rO6N1jsrzLGyQiz1IhRUG3HX8AXK893f3yDxlVe7u2/De2nvek
	YZr+cxevmniiZPJic//ZnIYdNd6S/jz+ye8rUxQP6Uk61TLfHa2xakyuCl4ZtXXa5LPVUiyoJGP
	DbajvtYUvmUAecMetLu3qbNqwDxs/B4QfY87BPsmSl4HBrx44cRbiBejfZa/f9ED+8srDqqwXvw
	JwtWh6k5cLzZz6VTVHpvWFarv7aU6qibfrbDnOoC8PuNc4aREm7p3ZB8CafIScCSFulsNPnBlm9
	cmc8iiKwu31cS3jWWNA4dZRPzcUru/D77+Grw4q2kbppLmqL6rLoJbbd3lwjGVoiEKQiYD/Tb79
	rv
X-Google-Smtp-Source: AGHT+IFVrcdKsUl8LGKuYd8Sn6ufZOa+bgUtrEH4GEtosRxVvJDbXCdbjQ7NB/bdg6dpRmRf3Xwssg==
X-Received: by 2002:a05:6a00:bc90:b0:7e8:4471:8c4 with SMTP id d2e1a72fcca58-7f6694aee9cmr8850889b3a.37.1765790722917;
        Mon, 15 Dec 2025 01:25:22 -0800 (PST)
Received: from oslab.. ([2402:f000:4:1006:809:ffff:fffe:18ea])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4bf7be436sm12036058b3a.0.2025.12.15.01.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 01:25:22 -0800 (PST)
From: Tuo Li <islituo@gmail.com>
To: ketan.mukadam@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tuo Li <islituo@gmail.com>
Subject: [PATCH] scsi: be2iscsi: Fix a possible null-pointer dereference in beiscsi_alloc_mem()
Date: Mon, 15 Dec 2025 17:25:09 +0800
Message-ID: <20251215092509.4035061-1-islituo@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There appears to be a potential null-pointer dereference in the
error-handling path. Consider the following scenario:

1. One or more mem_descr->mem_array objects have been allocated
successfully, so i is non-zero.
2. In the i-th iteration, DMA memory allocation succeeds, resulting in a
non-zero j.
3. A subsequent kmalloc_array() call fails, leaving mem_descr->mem_array as
NULL and transferring control to the free_mem label.

Under these conditions, the cleanup code may dereference
mem_descr->mem_array while freeing DMA memory, as shown below:

  dma_free_coherent(&phba->pcidev->dev,
    mem_descr->mem_array[j - 1].size,
	mem_descr->mem_array[j - 1].
	virtual_address,
	(unsigned long)mem_descr->
	mem_array[j - 1].
	bus_address.u.a64.address);

To reduce the risk of such a null-pointer dereference, it may be preferable
to separate the cleanup of resources associated with a failed
mem_descr->mem_array allocation from the cleanup of previously initialized
descriptors. Likewise, DMA memory allocated prior to a failed
mem_arr->virtual_address allocation could be released independently, rather
than being handled by the shared while loop under the free_mem label.

Signed-off-by: Tuo Li <islituo@gmail.com>
---
 drivers/scsi/be2iscsi/be_main.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index a0e794ffc980..1a22871843a0 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2554,8 +2554,18 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 	kfree(mem_arr_orig);
 	return 0;
 free_mem:
-	mem_descr->num_elements = j;
-	while ((i) || (j)) {
+	while (j) {
+		j--;
+		mem_arr--;
+		dma_free_coherent(&phba->pcidev->dev,
+					    mem_arr->size,
+					    mem_arr->virtual_address,
+					    (unsigned long)mem_arr->
+					    bus_address.u.a64.address);
+	}
+	while (i) {
+		i--;
+		mem_descr--;
 		for (j = mem_descr->num_elements; j > 0; j--) {
 			dma_free_coherent(&phba->pcidev->dev,
 					    mem_descr->mem_array[j - 1].size,
@@ -2565,11 +2575,7 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 					    mem_array[j - 1].
 					    bus_address.u.a64.address);
 		}
-		if (i) {
-			i--;
-			kfree(mem_descr->mem_array);
-			mem_descr--;
-		}
+		kfree(mem_descr->mem_array);
 	}
 	kfree(mem_arr_orig);
 	kfree(phba->init_mem);
-- 
2.43.0

