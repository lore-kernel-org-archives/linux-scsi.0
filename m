Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96651CB513;
	Mon,  2 Sep 2024 15:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725289247; cv=none; b=IqhEe5DnEXYhR+wdiklP5SixfvL2uiUjGaKzQnwoaVbz11VTRL+UkrJgFu/8KYrKmvJG1CcL8dzGqkoTDLVhWKxYMsDubyT5szcvDsXKh3OK38vx+dtMEb3QXKJX3ym5qS8aQxJj7WGrN+YlCr06eWBrKgQxG+u5CUIurfSARMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725289247; c=relaxed/simple;
	bh=N4F0HYqE/JN2Frkasn/4po5xLM+VA605HwLPUuG5P3U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=WvS9ba0PRp8/RMUd5eb4fEK4t6aonTHFStQuJKElKDD96/n4g+T4uzo1h1MH44FTZFPJ9Exv0ERZniDFGMUcGivMYRGtObWquruu53xcXbgCFK6C4LO/BIQi7qqJ+W5ZRvI1UePXqPP4tCQdsRhTTLh3Hepty8IRooN20PKp9us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aX7kcn+G; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aX7kcn+G"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-42bbffe38e6so20707005e9.0;
        Mon, 02 Sep 2024 08:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725289244; x=1725894044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ck070XTt7LQ3loM5VyZWdtdily/aCMgDwKrMtiiMYlM=;
        b=aX7kcn+Gmaq/TrJTvc8be2Y0IliI8/YJz7rTuGEGKOprt/fja4WzJ3RAkK1f/PdhWc
         hT1hrecvIABrQcj+uTFE/FBMgr3onLQ/mcmwWKmead1XJGe4RuvzA/yQvSTP/RPIBkTo
         Ahh/klcjxGFEdnOZJLVuPZAORU8EVM4GnFM2HhgAQUs8GIJxZyb8GeD/CFwWPc1MPYQN
         JdP3q1AlKd/X9TSy16OzO4bizA/hOU520qhVAWPheEsdbXDPGI8QIrp6sC3wzJP0CPml
         WBEOGS5ywWrcFtikCaAw5fIATUPmpMTMaR3Hp4C3TSpS3f3CW44NwVImcgQdS7eTfpD8
         ESPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725289244; x=1725894044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ck070XTt7LQ3loM5VyZWdtdily/aCMgDwKrMtiiMYlM=;
        b=s7kzH0K8Oh9N/8KsY2xvjZooYq0pR4Q/ztu54ioz2aEos0M3PnzHwlUZU1WcDF/rWc
         9nEwSAlwf0p0seGnwJmDaTjMCDoS+798+jGBs0+VGU8A+sfOMpvs18lySW8TUZcNuVbz
         Nrya79E/3xGh3rVEwgnCU82msZqWXTvHEgqFcb1CFMfHqcoZ6VeNaPqQ9BgyBkjl2QVr
         NjFnbhCYghmHk5tzv2vnFLL4/HDvrmCz2YsB5QyIOr5A7A9gnQ9BPZk+1Gn6jNSzTKbM
         VBgC2/ds++qSJlXbBnpWJQdP44AwagjZXrYa5AD0O17Jx6Odm/h8pSb5ezC+Vjomajl0
         txJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCX/N+dnclM3+PxyUv7VE+gX8pDTHFPHgPgt13fb/2se70HwBXoQcCYWe5aEpbFOmVs51280arzQuLGQ==@vger.kernel.org, AJvYcCWfSTa5McfV9/jgSF2o3SlcoZ8vSgaSMvKAQGBwOi77u220bI9vJzgoczP+qgwrEybvD4MLjVrUoTbGVIY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvbmLyELu/UevRL9RMG9oYZCrjspm214EZ+fMI3cQyKFTxiEK5
	z6qD4hmA2U0C19r8wqYX9Lb5n++tkVYzn4yvvKrvaYmKdaV7Q0/S
X-Google-Smtp-Source: AGHT+IHhvCV25tMGVpsV0Sy3/5vt7zPeVL5CewGQnDFRUNWlJ+SgrfNl95ybs2Dhp7yRgSXrYwKgNw==
X-Received: by 2002:adf:fa87:0:b0:374:bf97:ba10 with SMTP id ffacd0b85a97d-374bf97bc82mr4491458f8f.25.1725289243723;
        Mon, 02 Sep 2024 08:00:43 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-374b6a3d27fsm8626278f8f.59.2024.09.02.08.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 08:00:43 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: lpfc: Remove trailing space after \n newline
Date: Mon,  2 Sep 2024 16:00:42 +0100
Message-Id: <20240902150042.311157-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a extraneous space after a newline in two lpfc_printf_log
messages. Remove the space.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 332b8d2348e9..0e60eebe53b5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8818,7 +8818,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	rc = lpfc_sli4_queue_setup(phba);
 	if (unlikely(rc)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"0381 Error %d during queue setup.\n ", rc);
+				"0381 Error %d during queue setup.\n", rc);
 		goto out_stop_timers;
 	}
 	/* Initialize the driver internal SLI layer lists. */
@@ -21149,7 +21149,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 		if (!piocbq) {
 			spin_unlock_irqrestore(&pring->ring_lock, iflags);
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"2823 txq empty and txq_cnt is %d\n ",
+				"2823 txq empty and txq_cnt is %d\n",
 				txq_cnt);
 			break;
 		}
-- 
2.39.2

