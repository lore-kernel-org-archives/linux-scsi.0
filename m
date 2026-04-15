Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D15C377000
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 20:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776286148; cv=none; b=NGmG+gSphhSQ3leS4kaxMI/HUSv/tt1V4+iBLRgoiQmorH7/Q3twJUESBZhlAhq3ExsPfONG5gEOaJl789JvnCIYyLUjJs5qQ0C7h/qKN9/BAASwBTIqxmuFDvf822sLFThdLPQ4n4zF5XRqCmgGa3dmvYTpOELHMOwVbmXKs98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776286148; c=relaxed/simple;
	bh=jaHsYdGbpYEYbhaKRJDxVaFvTJCn06yxrg2fJlh+JU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqc63nqoMRzHbA6uFRTlLkUd2KLstkdFfVxnV5QjFS0rs8BlePWpgpy/sF/jpD/ARlQ9zkDilK6DGJ4K+E70N+o7Pvx5P0q1PpnkuccGJC2OuE5MWdN/8YEN9pW5DJoW/jQG3J2KOJcLQKDRC2hRRxd7vv15N80XUaUd9V1WMyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DhTGujyu; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DhTGujyu"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso68423955e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 13:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776286145; x=1776890945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zUcXYrAHaFcSZpGG6Or5FD6LmBv6L/glEjP9yZLQ6B4=;
        b=DhTGujyuwfKiK1pVz3Rhe/Y4mVw2moOtSuBL7h1xGW+nS96sNBU+YEibYLIS177txH
         cUM2oXdUjjB6XlhYjra5bGWtrVvBRpjTHCj4BiekJZMB6Yiu2JEmdp8ER/MEF8d9bV86
         nZvCCKLANx/LA6NwWK8YMUE+/qTHx/VUPtrdVDy81bKh1frcDs+7a7LCiv0St21fHWAR
         tAIeXECUYs01ZT+FwE1PsRe0vPhlaqQXAWZoMc1IJKLlJ37plmFDtNkFESRUrO2eCY8o
         cM6gMFWRVGHvB9xqoFVXBcirAjjs02DkMTzvgM1XIB0wfpjWqfJ1QRbHwM48bQTZhIBk
         zywA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776286145; x=1776890945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zUcXYrAHaFcSZpGG6Or5FD6LmBv6L/glEjP9yZLQ6B4=;
        b=lxcEoPL5BxLNiAdvS89opfv2bG+4K+dZLX45qxi+A8OmRBlfAjE75eHUQdW1V1X1v4
         uVKnzSGWOq99oJ1LSAVam48YWc/5iE9wtPp4tM8ZvXAqFeVOh5jZBxAjP2f1EfkczSa0
         JNiiLhhgUc9ZnnbCe+e9APgEp5S2xFlpI5s8IkGBZUZUycjUFjF8GWzBoOp51lLbct+t
         bNc99J25pjYUyGGybBvH6mflLusL75YBQhM81xtsu/oIdnW/AbRkipMuYcIv9HaepatZ
         UdUDVLq7sFQWLAxvjmAzblF2lxlDm6XPjARVVuPI2j8n6O5rcrABdAWl5WbqDM2OStgi
         c8ww==
X-Gm-Message-State: AOJu0Yw0rv5V124nai1sPjz2i0yx/06rQBnyb84J9IFfd9xtwrBtQt2F
	npn6pg/OJwDXVjUSHCzF/N7+17kmRu84OKYLn1T2CAP9GxHcRvEns/pA+2krCa9NKlA=
X-Gm-Gg: AeBDievx98r3d9hSRmUq2j16tWgzY7NkrXchx1E7cJqxLnsRR8wga/g+5VuXlbjlTXQ
	E3nR26Om+NzA4LsHYj4Gd4lxPhu+I4uZeHQ/GgwtTuo9R351yhUV23MpB+gk38z/zoqHTlqjRqR
	PgHOdfeTZGgMSErvitznJUb1vJQTJpG9h/xLU+IQE5fDowKzGgrKqxedZfO/GOEe12Jmc7+U+MA
	ZEVIXziUdS3roaTXyhFED9LWf83BU+hlkcT4zoc7or3QIEtBNBwriSQ5WTy4n8yx/rXUxFb918s
	ADMhinqB4ukoHIRFtcMd7NQU9EKRLUDTCE58N2RZiolrYCKn5HiplHgAUm8pwdZU6AEtj9kk7f6
	ynTY/4WW3gNc82VfCZnqqD0OcFYFE4zCPKlts0jiD3BJL0WywrCApFuvIfPrRgYrWtSd4aQKUPS
	zQ7SYadVRQvSOgJ7RmSBOAApP9AO/5DHC0eaXopjJPTiFW1CUoWytDkDhqI4PlG9t93QhLQHQcm
	VGjnKjk1ajVqghOutv2RJ0E
X-Received: by 2002:a05:600c:460a:b0:488:a824:fdff with SMTP id 5b1f17b1804b1-488e00fdbc3mr152534465e9.22.1776286145008;
        Wed, 15 Apr 2026 13:49:05 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488f1e945d0sm92777675e9.12.2026.04.15.13.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2026 13:49:04 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Don Brace <don.brace@microchip.com>
Cc: linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	Martin Wilck <mwilck@suse.com>,
	storagedev@microchip.com,
	stable@vger.kernel.org
Subject: [PATCH 1/2] scsi: smartpqi: use shost_to_hba() in pqi_scan_finished()
Date: Wed, 15 Apr 2026 22:48:49 +0200
Message-ID: <20260415204850.799431-2-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260415204850.799431-1-mwilck@suse.com>
References: <20260415204850.799431-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

shost_to_hba() is used everywhere except to obtain pqi_ctrl_info
from shosti, except in pqi_scan_finished(), where shost_priv() is used.
This causes one pointer dereference to be missed, as shost->hostdata
is a pointer in smartpqi. Fix it.

Fixes: 6c223761eb54 ("smartpqi: initial commit of Microsemi smartpqi driver")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Don Brace <don.brace@microchip.com>
Cc: storagedev@microchip.com
Cc: stable@vger.kernel.org
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b4ed991..65ff509 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2642,7 +2642,7 @@ static int pqi_scan_finished(struct Scsi_Host *shost,
 {
 	struct pqi_ctrl_info *ctrl_info;
 
-	ctrl_info = shost_priv(shost);
+	ctrl_info = shost_to_hba(shost);
 
 	return !mutex_is_locked(&ctrl_info->scan_mutex);
 }
-- 
2.51.0

