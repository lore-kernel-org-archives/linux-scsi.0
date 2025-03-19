Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA69517A312
	for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2025 23:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742425410; cv=none; b=bDJhnwC9pd6BsNOwrEJSzukIKn/9TjRwhbykB0D+93723HM+BKO7x3h9dGwg573jsDnGe5rackM8esNqZvz+QJEz56ejkNO8QK7CelFI/ppyJPyutsvZ5odtFzPDDfMUvTRG1ffKf9GiBvUzjUAsOg1ngmRjsdwXORAGRRefw+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742425410; c=relaxed/simple;
	bh=Ym/oE9/zF1E6WrnK7sblqTplV6fSMY8+bf5qbWR2xCo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=In4cC6VXcR+GXu92Z+Akrua2/8DW4sDSETDll+4X3h9pwcvgVGKTvuRi8D1v4BZaq7kceYB6kYT1gC8j2gxqrG3NJZpQcxP1gQ8cFacpC4OyfISRuu+6Bqo9DRjqLeYQBtsF1F2+wAvSN9oik5FygyJQmxlaxQ3GUbRskukG238=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J2/NpOmN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J2/NpOmN"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2242ade807fso3025165ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Mar 2025 16:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742425408; x=1743030208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6nIujCaipHEcjWLXKMhhxpOA7wQAYdR7gK4wSARh5AA=;
        b=J2/NpOmNPKEQRESWufotm7gFEll2n6Ag2a6od7bg0I3XUNUTx48Q71dUt4IEJiAyb/
         pLc6s/0hXPvKziS2AWb34ZxYbBcjW33cCSCxxwT5XuxLYgNEE7mkt8EP0O3mG8HdzTbN
         gZeiITe1UdiljdEWIL/FgNroIQqZl80Mpo3LbEUhKgES59VKa9FjHU7d+y5EshmfGHTx
         Dhy+e8LFzPKOxCWSz8exP+vEMZEC+ZyWB9bqiww97q1nYtGavcgRJLbLWRClAA9mxaRM
         Bk1mmAI6sBkOLnlHMkwy9I/t5IsiTUd3xVa+yurBupVrvuQ2juKeP+CkwBseUtlMkBtC
         OR4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742425408; x=1743030208;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6nIujCaipHEcjWLXKMhhxpOA7wQAYdR7gK4wSARh5AA=;
        b=FWE7HsW//XI3zmU/F3R/w+hDLnc2jSEWvndBi9tL/sJdZGSjoLB+t9LSZoS8XEJsdD
         i3j6KnV0QJUOI9Lk8nbeXEU/9In1Ozmu12a7QP6pCnOEWlDvBQBwglBzJccq6j8W/6AC
         Nk4y9ZY3XPII/0K34wt1ArGwF4uff572CBfRK3jLbfl++BnbEsPkCmNVjNS20XgV1Mqp
         3IqD+A4AFqiqScT8X6naSJKN2XABmhZK9PMg3HdCuyA8nzv6ZcamEmmOISnSjA5OtgBX
         bRjsTjIFYCSXIm805OhsO73I7ulQuq9I91AaazJSJnPCO77AMUlYt/hBU8ELGDWuJ1wK
         Q3Ug==
X-Gm-Message-State: AOJu0YwrMiBrfv5+inBXdOYZJPPbaAqRTfaaim+bmhU67O97iTIG6xFF
	Gkh53LJO4IX+XLQ2g6LNo0V8VCaXEkwZ0qpmjH/O2499XdMOGZGmPAn+Ij3IWsxXa1RDTYxutQf
	NbZNTIJcjAXIFiK0kdcn3ww==
X-Google-Smtp-Source: AGHT+IGY3B63A+a3JRwvAfAFumFgsjw1Ar3r6BNfWtiIpuP0pkmz5wFEyXp+q7/EyGOCwI9iSkI5T3Bj8kpcdIojVA==
X-Received: from pfble5.prod.google.com ([2002:a05:6a00:4fc5:b0:737:6066:fee8])
 (user=salomondush job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:6713:b0:1f5:8cc8:9cc5 with SMTP id adf61e73a8af0-1fd133f989amr2152207637.34.1742425408172;
 Wed, 19 Mar 2025 16:03:28 -0700 (PDT)
Date: Wed, 19 Mar 2025 23:03:05 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250319230305.3172920-1-salomondush@google.com>
Subject: [PATCH] scsi: pm80xx: Set phy_attached to zero when device is gone
From: Salomon Dushimirimana <salomondush@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>, Salomon Dushimirimana <salomondush@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Igor Pylypiv <ipylypiv@google.com>

When a fatal error occurs, a phy down event may not be received to set
phy->phy_attached to zero.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 183ce00aa671..f7067878b34f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -766,6 +766,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.49.0.rc1.451.g8f38331e32-goog

