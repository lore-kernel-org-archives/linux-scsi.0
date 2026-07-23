Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CCE48CD4E
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 18:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784832440; cv=none; b=aP9FNfeMtLbyg493IUTinSJQL5qG7LEzchZcHzUQhiWLIr3bXFZQ5xrGnUUVv3ngbq8L3A9br2sCySGjEblCT4CgEyBzDJLz00H62PXnOiIV40VY65Ok3Mnb7UlbLuC9HV7+RS73F9EGsisS2ht+602O40t6yxy4A2EGuaXtnjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784832440; c=relaxed/simple;
	bh=M9H1p6QdSNOybgbowtw6brrEl/02Mw1iKn1qBSJlFkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jjx+Q3Bwyxw4xcemIq53M1TPb6HAh/UCvS4uMu9hIPThRDQug6LUs7vImRkPy2GCLgglZLsxg+UMqmK+TSbt5BU+oDCKlwWz9OcL3yuIhGpOiMgypxDdxCd1Y+8jCVHdlqplt4Bk0UBFPuWnndOQc8WIqpQ0Q+9wfL/39m2I4eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FlepFESJ; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FlepFESJ"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-384930ca5e2so1050926a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 11:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784832432; x=1785437232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OMO2KRomBUijve5D7xBOqgHhJt3kPIgvFbAoFSgbWN8=;
        b=FlepFESJsWWL3mgLFlHMbrQvrwkligVKZxXTI6pQfH2p1U238kH8qVhIOlai3pHolK
         zBIgGNbT80Yq4lx5AmtWOr/bYISNNBbMHzGUSOmTd2K1iUhaYpjn7owAdjpgsGv3hZ7w
         M9Imt4zVIq0CKdMQTx1U9gUice8EUT9ZyWCIFegSCqNS2ik7Q0zx++/8tDmDCoptqOFi
         CjvPs8MYj50hwBCmt95agiIzsVGOoltf6UyePgNCBnkM+cePZh2/wF4aoD4AolHXtlqR
         3Q9KYHLnsrUuthqKXna8shfkq7TUOlPhjrJjVlmkwtoUuUH8QjvxFAqqMYQJyYfZY5WQ
         8wpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784832432; x=1785437232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OMO2KRomBUijve5D7xBOqgHhJt3kPIgvFbAoFSgbWN8=;
        b=X0vkCFBsQ4/8EpmYiLpdyOhx/lJFoJa6disbKf9rBqcrILtczmujpRbDRsLyUvjYlF
         UPzwiRPs06zb3YfGhE/hwLTJ4jH8A2cN11dx9OH5El7gsfPAqtnvgUkF+pDi3eFXxfPW
         SbpwYhf2v1tTOtmFkAuiHnMIl3sbcIFwPbkD899N1kHSgDhsTcgACV6TlmI2ehPzSZRM
         9jWqN2mzNhlI5q248gAqIeKCsxKowtiL3M/fBfox5/DbMriLW6PI6Uw4fphJDgPkFyNR
         bJx51OwDlS4gRC3b4fcRtkuwEkNu1zbv0qx2BpA8SJuz96XBmo0osFJjTDSLvNSDFNdK
         t1EQ==
X-Forwarded-Encrypted: i=1; AHgh+RpnIRFRprDp6W4bimkVO921/32OzAk8I40t8CBYmTx+3CWoadJxb4BNRoZo+QKGWZoCwvJYsYNCa79U@vger.kernel.org
X-Gm-Message-State: AOJu0YwO/Zelk11dQgHq/C95KShtiqjpyjIak4U+Z8mGT3S7aZMoWPa8
	OrX0Hhr+gKtNQx+UhrBoqzN9TUw+LJb8zEa6OXTHW33EdNaOCv8VJ8VD
X-Gm-Gg: AR+sD10HJUdEFun8LgP5lk+o23P+9Vf01pxMaH84PpzvWK+PR4EaOBdxopZDzdibJ3g
	zEbknVC/XDFQmyO/j+yWIsRyLu6KC9sUBg0OlgwfaFdieWQewBiIZa8RLJ0hWpZzD5VJdnrfB77
	G0Owo9dSxGw2A4r4lAfkjGuD2hECsYbbeG5G42vCOLni0slVEJCzd+WuJkdw0+Fs29ttBzijqhA
	zcSTf3uG6G3xl3wgif6xcvh8HStLYOHTHlmExbqN/Dma75nYbGjfldXbbBxE27quHEm6zKABhAk
	0ojFCpgbSH5dc+MEWtkQAocqG+u0xuL/B3S3Zhlb2SS1Z4/JSHAK2kFziT23GWbZ+iVbgURDqJ4
	P5xN7cHQtlzouBDk3Li8j60reMLkW+prSqnZczjoS73StEyWfHaofOQBYnz3B3Hh4Ze466WUt
X-Received: by 2002:a17:90b:2ecd:b0:381:9028:5945 with SMTP id 98e67ed59e1d1-38ec64dc738mr4624841a91.14.1784832431870;
        Thu, 23 Jul 2026 11:47:11 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f03af8a45sm308155a91.10.2026.07.23.11.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 11:47:11 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Julia.Lawall@inria.fr,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: cocci@inria.fr,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 30/36] scsi: mpt3sas: remove conditional return with no effect
Date: Fri, 24 Jul 2026 03:45:32 +0900
Message-ID: <20260723184538.3888637-31-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723184538.3888637-1-ekffu200098@gmail.com>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both branches of the check return the same value, so the check has
no effect. Remove it and return the value directly.

This is the result of running the Coccinelle script from
scripts/coccinelle/misc/cond_return_no_effect.cocci.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 79052f2accbd..791a3c5fbf44 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -8369,11 +8369,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
 		return r; /* scan_start and scan_finished support */
 	}
 
-	r = _base_send_port_enable(ioc);
-	if (r)
-		return r;
-
-	return r;
+	return _base_send_port_enable(ioc);
 }
 
 /**
-- 
2.43.0

