Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CEE4B0495
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 18:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791485023; cv=none; b=YXXtyW0MPjbqav3hgMPK27bRCjPDJlcEEsrBwQjEG5UgNq18P5jVEH5nMXCFGAsGlPahh1Tt4wAUkApEusfZ48rGFWEVmJEx2wBxLCLPbIvHUfUOmUrMsfnSptT4KTKwH14wj4teWvYBawlcD9gQVB75GJI9AfehEKU9LkUX5LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791485023; c=relaxed/simple;
	bh=uSXX/v1i277yMPTo3o6YTUypZcjJkmSCfy7gVxyfX4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IqZNbEMqxcSmddmxPWGJN1nCNzZOYwlYhX/ftKeRkZq/P2tO5efpy0NWDBqIWDYpNoHan/5KHZMWDXGO5URCVeuh3FXNa+qclQgnpl260l93M8FpwZMfEqtssS5hMe5hxUzwxP42CCAwqGfIdQHQaP0hXvVfW7wjZ9mFMKfI7vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IOzmRbFb; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IOzmRbFb"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1698ea378so29281925e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 11:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791485018; x=1792089818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2TQ/dYlIEQ7IbvZ9UoPQ3SFyHjvvBzoDN2VtQPnIdfI=;
        b=IOzmRbFbvUNn0qvu6K5nvkazL7O5xQCPFI3SwI0IRlZu65GI3t1SdrnosvsQ+e1TI3
         Y6TztGymVoh0nUzNJqvsRFCn0na5IZAD3Atk7ph2tMQCOnwW8FPSRwqitJIyRxspL5tI
         dUGNf7BynasoVkQPYHOkeYjyigD+bOdqqEDZYztwyjOHgT79p1tUp+Q8bociH0vuIf52
         Y6asZXiU93GUmX7vK2UROfqP/cUsaksLV+7Seu31lf4PiNw8YGbZYZ9ljRiceRUL8zaR
         dOHgykPLMRhgiFAUqVW00Co+Rm3HIx+AVGvEib9DUBqEfwMXoStuVOpFhcwfcl74rbbV
         kJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791485018; x=1792089818;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2TQ/dYlIEQ7IbvZ9UoPQ3SFyHjvvBzoDN2VtQPnIdfI=;
        b=RhpCUH24FR3fpuvFE0lqy8Fz7nsCcQV8Ao0qwvWVwCT8rj/54dZYgtsE1+B2cwcNgv
         r02cxVsCoy8Q3zaxuV2th/wfyjv0xAmvPRx7OgQjoASQuX2XSb+lg0Ghx6b4xGkouHhF
         5hxTZPEsTYI345gH4gIcPpLXuJPKLWmoEqsjVMgB6V34FWG414b44iZXji7Wr5UT+dTU
         OyObxkquYej951Ga80ekSAUXiVZleOEOkI2HwCrnV19zLY3KnHJ+uxg7dKntZ9HbASjG
         VS+/hDJarzQmFkyK5ebzTiTPsPC9YHWkEVQumKc3U9GSfjnP7fQ/K1wDnRY9QzNzXEsJ
         A2eA==
X-Forwarded-Encrypted: i=1; AKwUvByWCqSXRkJODTZbW/mw71D1sxFibiHV5x9EluYi/mIVtLHtKATqnuWBEe30Q9JgmqTsf9wzlPJfEuXG@vger.kernel.org
X-Gm-Message-State: AFuF++mahce3ceHjPbp78/zxFlCU+WLM3YUYLM69lTkFOAzidOsSwpuC
	k8Qb83z+oPdODaZjT7V46makKit0EvW6PReX94sHu81pouJYpK3K+h9l
X-Gm-Gg: AYBFou07kfO3QTHg7xUyWLNCOvWZK+4GvAjrDZXUS+rLJBwKA07lOImXdS/uBzJ88hR
	+DIexn01GUITVnnPgywG6N++EwD49IHoo0DOqMTWeSyORlHndz4qLprklKKRYcJ0JtOTP65fK/p
	nYmtmzClO+Q2yylKNHjqh4e53q063E6y9xINVtgkU9k5IIAmBLa25vB/TZJedZ2jbJt8hjOEf1g
	6D37OCaUy9Roeor/hY8zrGVxgFGLbVGn3xEQVg6BpupPIAH7WVblhxAFZgbimOIfMxU1LJ7ioGr
	bVWEjj1DFSLDzXYs6scmhLQa6Ics4p7KngGetvhMYvi9vL7vw+5TOENaszTDwkENqVIr9FDeYY6
	5ARbfvC6PH00RlVz0WosplPUKyWQv0CVE6cfxpPX8ao7aH2UPPUhruV7UtqDdGjNJpg9vT6GgFN
	20f2m5E44G9wJdJIq4TV4Wl3f6s8CWZwcL4HGQR9IFbtuucCNerkWxzcTrbIt19AjPzQ==
X-Received: by 2002:a05:600c:1911:b0:4a1:78c5:79f5 with SMTP id 5b1f17b1804b1-4a180455696mr118519395e9.33.1791485018191;
        Thu, 08 Oct 2026 11:43:38 -0700 (PDT)
Received: from dev1.kernelcare.com ([2a01:4f8:172:1c85::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bb5dd8dsm4881605e9.0.2026.10.08.11.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:43:37 -0700 (PDT)
From: Andrey Misiurov <andrey.misyrov@gmail.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	justin.tee@broadcom.com,
	paul.ely@broadcom.com,
	martin.petersen@oracle.com,
	nihaal@cse.iitm.ac.in,
	linux-scsi@vger.kernel.org,
	Andrey Misiurov <andrey.misyrov@gmail.com>
Subject: [PATCH 6.1.y] scsi: lpfc: Fix use-after-free of mboxq in lpfc_sli4_driver_resource_setup()
Date: Thu,  8 Oct 2026 20:43:28 +0200
Message-ID: <20261008184328.2857037-1-andrey.misyrov@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 6.1.y backport of upstream commit 1bd28625e25b ("scsi: lpfc: Fix
memory leak in lpfc_sli4_driver_resource_setup()") added the new
mempool_free() of mboxq in the wrong place. Upstream frees mboxq after
the error handling of lpfc_get_sli4_parameters(). In 6.1.y the hunk
landed before that call, right after the NVMET WWN loop:

	mempool_free(mboxq, phba->mbox_mem_pool);
	lpfc_nvme_mod_param_dep(phba);
	rc = lpfc_get_sli4_parameters(phba, mboxq);

mbox_mem_pool is created a few lines earlier in the same function, so
the pool is full and mempool_free() really kfree()s mboxq.
lpfc_get_sli4_parameters() then builds and issues a mailbox command in
freed memory. This happens on every SLI4 probe. Its error paths also
free mboxq a second time.

Move the mempool_free() to where upstream and the other stable trees
have it.

Fixes: 299f5baa1321 ("scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()")
Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 13ebbe4..fc5a640 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8175,7 +8175,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			}
 		}
 	}
-	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	lpfc_nvme_mod_param_dep(phba);
 
@@ -8209,6 +8208,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			goto out_free_bsmbx;
 		}
 	}
+	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/*
 	 * 1 for cmd, 1 for rsp, NVME adds an extra one
-- 
2.43.7

