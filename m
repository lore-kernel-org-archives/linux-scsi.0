Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186682D9782;
	Fri, 27 Jun 2025 13:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751032223; cv=none; b=mZzAXOcEARikff/p8LRkgeMB4rnIqnfAtXWWzYPXpyjuPeoW8hmtrQPnH03qKFFCItq5xvslegrgXbJLterqwX7FO2lSqzQ+QNn5mHjqTwImeSbKhtTvXB7Pc46I3TYjDoQXusB/g+LDHdMkFJfeEGo5WskVe1eMEnt+vZ0CnmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751032223; c=relaxed/simple;
	bh=jO9NTW7rg0yFghL9qZx0QIgPu3xkk+uwBQU+xk661Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fXngiBKGKFy2uaj5AnhJKWsMl9vz2jz8Jm7TG1lWhHY9bchtwohGofJtVrQYuIhsIFuCMOCiPfQOthoza+eowTkuGvbW5TiipeimwHSvs+TXXaOZbebb+NXm0vVem6p9WX0OLr4+yPp1wtUIWhtQH9uI5RBG8KWrFWnHjxuVwmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KFgMFFNM; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KFgMFFNM"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45362642f3bso3116645e9.2;
        Fri, 27 Jun 2025 06:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751032220; x=1751637020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r96sMY7excAozo4t+XwPYAcLjTB7ze6VHgofkrq2Cr0=;
        b=KFgMFFNMUZZ7dQ27VnAlije3Kn3r2ybhuSP59+hKdqXs4oBsiPT1qUJSq8K+u/Ex6Q
         fpx+mlTYpfqUdSnAYP10CWtMm3bUMISTix3LT9V02l60ewXkWMDQG3QxUjrW9eQ1ryr7
         knUYRuEBsEdkfhon/FX+XLHq/q9JW4V9x/swn2jJqtp25bimrSyOdLfSdfOjPHp1ZzW1
         iXryDfrq2w1zaKf0C1X0AogLcs5GwrzlkanPC1cTCII5/fccpMVDRF88JOUsw7rVKeiF
         ub30Kay4vG3ObkltUkpkIWpHw6B2II7gOklkZEd5+bCjlz6FL2+RTNz1n4x4IWednbFf
         3b/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751032220; x=1751637020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r96sMY7excAozo4t+XwPYAcLjTB7ze6VHgofkrq2Cr0=;
        b=jQVZCRCJXcRM5Hb2rDJ+2SHHpYViGITN3yrod+A5gfnmtaDc/shhdArnG5F0zuenMa
         YT4xx7Qvh5k7qjSos6cvY+RSwBE11I4QEEvKPVql7e/GKfUJm9vv2sKwy57L7V2RDp/X
         k+KGoCzPeQoALmurWGgWAccmnZYBKFQ5xt5ZP1R2LtbRQ0gIZYGtch52cZcPIy0Qd20N
         v8N6fa4BbMgPwQwTd4jQzQFspFS/M2/R+LsTL44d458OkJ5LRUXwo0Pf29YQQHHgIUdS
         N0WhPVgm43K/gAPxOgV1zQlq6AkDyFpU6iu9UZQAjyACkexZcaD3PTAQj432lIY/J2bB
         PYHA==
X-Forwarded-Encrypted: i=1; AJvYcCVnqIcV/PDBib3VUJCwWwfehXWiFVREH2E75lfduu6qz2cVSnE995vDNF0HyAsN4pFGx+HMUKs2pHOo9w==@vger.kernel.org, AJvYcCWs5WnnWtzemxMDckRGjATp949RErDhGEyhYr6q2ZGq9a6tRf7AXl8C5lYyMa0qdFjZsmzPBh3Oj7KIk/w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz99m5aOD7WLpLKIXdKr7KpnDP/1yaRkfONQzBmIn0ayRZqXTHN
	xBPapUd/EzBooeGAlLJus1pXs8gqajVX0ORbeUyWMMqM6/hrutyQBQP6xmJBaBN0
X-Gm-Gg: ASbGncu4ToXhm8LKJLdItUIfIH51IYYraK/fT5FnDfswNCXlEpWrjnmKGyeBb5TMKbg
	VjY2iz8tKPKAmFZTb4vfzNi8Z42x8V6HvZaiIiigt0j7SWBEjJXdzOicDprxddSRbmSNIv0g4gz
	txdpZlLgo8bJ5TbQYBcq98jHvCwU30Ksoh4IOLm3GnW4+fRK6YDk0silvSavjWey11fVcETuhed
	uKbBzMUreUfDknuDAdf7EYxDyamtp03tSuUmYhzouPpQiLlRzYE7IAgl6iTQC9QHIdI/DoO3PAq
	F+geaMjF5M7PdEdXNNOLL1eIv929zo37tOYRxtLE0JLAZ8BKJr7h2elVZW3501Wdkh7KsM8VaFz
	fBwtishFg6Jj14oc=
X-Google-Smtp-Source: AGHT+IHXEr/qwh3nPWY4KSjtPMeVKp9ybJL/1QNlTH38uDYKJGj9IL7OnSDfIXrqJDva3ZD95f7Y6g==
X-Received: by 2002:a05:600d:10:b0:451:dee4:cd07 with SMTP id 5b1f17b1804b1-4538edf5becmr11476485e9.0.1751032220144;
        Fri, 27 Jun 2025 06:50:20 -0700 (PDT)
Received: from thomas-precision3591.imag.fr ([2001:660:5301:24:fade:13b1:a534:8568])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4538a421434sm52012505e9.37.2025.06.27.06.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 06:50:19 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Jeff Garzik <jeff@garzik.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mvsas: Fix dma_unmap_sg() nents value
Date: Fri, 27 Jun 2025 15:48:18 +0200
Message-ID: <20250627134822.234813-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: b5762948263d ("[SCSI] mvsas: Add Marvell 6440 SAS/SATA driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/scsi/mvsas/mv_sas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 6c46654b9cd9..15b3d9d55a4b 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -818,7 +818,7 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	dev_printk(KERN_ERR, mvi->dev, "mvsas prep failed[%d]!\n", rc);
 	if (!sas_protocol_ata(task->task_proto))
 		if (n_elem)
-			dma_unmap_sg(mvi->dev, task->scatter, n_elem,
+			dma_unmap_sg(mvi->dev, task->scatter, task->num_scatter,
 				     task->data_dir);
 prep_out:
 	return rc;
@@ -864,7 +864,7 @@ static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
 	if (!sas_protocol_ata(task->task_proto))
 		if (slot->n_elem)
 			dma_unmap_sg(mvi->dev, task->scatter,
-				     slot->n_elem, task->data_dir);
+				     task->num_scatter, task->data_dir);
 
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SMP:
-- 
2.43.0

