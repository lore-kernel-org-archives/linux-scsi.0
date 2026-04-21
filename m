Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FDB34DCFF
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 20:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776802837; cv=none; b=YXNHtZMtjns7RRlJVVq5dESo+918IEOdpFedcTKXDOrbRbNZduuN4Eqe4faLLAKwtzD0UI8YaRHDihi//dmJd5QnjGxS7FzWY2ZaKP6VFn4HDfujV+pW/4nDszuQXO0SoESFgPzysvupJEwHEI4qkev4tXD5QKRYas1Vxm+ZrYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776802837; c=relaxed/simple;
	bh=45XAOuz0OqwNn6boAX9lmria/vzaaZB2g94/HwMz0IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5/+MOZ3rJs3lT5vPJeazdon4xYXGrJ9UUx9DHcj1OQeJEHiIh4ZyPDymJWy+TrEIHhM8u54hmLrOI/uYP0eCEVI8rdVE11JkKnLO7aHVBAzAdeaWhmG4Crmshzf9iLInujOPfefK8ICCVzPHhuxNNpaA7zCMJQkFUEjKBA6Yhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KjqLFL/c; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KjqLFL/c"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488ad135063so40059025e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 13:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776802834; x=1777407634; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61W3FDen/JDgh3XHK5UZj5HtIe9MHjg+PhurMbllz2Y=;
        b=KjqLFL/c9xf9acawTx4C+83P4d57AfPEVh9t9g/2neMThAWkgEbfBkDy1ClKhyoc3H
         wshlerDeqfW3VBZhTe++GU2vk+JTVBpl5d5wMfJZfV3cQWUSqIRQJJYvlrzj2ojNPUSL
         Zm1Fq4e5LHr2AO2zwlZlQpnlORCHrI9yWN3kMAffHUt3Hz2vBOluckM8Fnc/tDCdL7AS
         Ea+5ph+wg/wfa/bW+d+4bJEzWjlZNpeuArbbbhMm9JCrHpRHib59NDjZfR2o0kmGGbIO
         2lmZuM+2coogOcWyOOMYiuLjZiXZNPRRWGnnCs82XrKPRkEbFChvPqSASURb0uBop11W
         Pxog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776802834; x=1777407634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=61W3FDen/JDgh3XHK5UZj5HtIe9MHjg+PhurMbllz2Y=;
        b=IWrmP6Yd7rdidzVWjlpQmMuJpdutbj9oBQbqMmmN5wz38/BKUXnnImZDE1rSCF/xHZ
         Es7fGKBQsQGRs+uEmKMtpEuumE0oWvGwxT9KU92s5E8+fyEAuVJcJzw2SpGi1trMwXj6
         NOkVe7oX7qz/7OW1QBprYXf3uq6CX3KLdI3kd6qdpVxHnWBtV+hw99BZNQrhyjukwohk
         Nkw4Z1RNAtpTCVULQkSus+5SSrtkSnouwzolMpcK7RQMIm0qPZmRnVs1KsZOsTay1/Zz
         uNR1gJGOx3HmZJJyjYB8F7VSap6e0yEJYzgj5V6Lk9bthgav+/+LMH12x7TWQ2UFGo5u
         ml5A==
X-Gm-Message-State: AOJu0YwH4rN0cB8ZB7QqxZL61WGCLmEgWFhfMGSI44whkBIzlgRAhSKp
	Grtet/14wOUAn3rwnaS77GljupAUSkiUr7x/0AMVoZVNqcJcnvNCXCrYWgwJehRKcCg=
X-Gm-Gg: AeBDievSgRrmULqu+QmZWVGPaMu2MUU1OligacUWZJQjpOFQT90GjbY99D0InILpxoz
	x8hAQ8lE3tT1SBNtuyhkteNWCjKM4D7dFzZpRuzQ5jZ07a6iyniA9UG6WEvvddXWOPDBG2ov8Py
	VK3AKvRmAZ+fGKAHykAQmizBo3MK6ERhRl+XdhfgsTX23uO/OmSLHSSarWk57WTAqYMB6PNvgyZ
	WsfEwGB6RTSnv6m37976pgTPacW/zK8WjpF5TLQ2nNhMjsVWcotJwTSWeqZvE20aAqp71BOX2UO
	RFwTe7uVENyfmnQjW4UnOrLa0doY9AGeXq9zuLKWgoz8Zj0YdnRBMsUPtNoT6y8mgymLdFtQcNt
	uVbgZAXDt28IyeO5Vu+Mr6/oGHcshs4FX5E9eqR3uQWVulHzP4iLpFZdx7Dz9YF7YKzyrkNSYos
	63ippCDthNvTM3LHP5B5TLdPkafB9L4oh2zMd6A57Pz03CjUMyLbuUpRZx1kOL1dLnCVFLkV18N
	3ev70N1csZE/CbPx85ImS91
X-Received: by 2002:a05:600c:628c:b0:48a:52d4:888c with SMTP id 5b1f17b1804b1-48a52d48985mr104909355e9.3.1776802834191;
        Tue, 21 Apr 2026 13:20:34 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb78d1bcsm171910825e9.5.2026.04.21.13.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 13:20:33 -0700 (PDT)
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
Subject: [PATCH v2 1/2] scsi: smartpqi: use shost_to_hba() in pqi_scan_finished()
Date: Tue, 21 Apr 2026 22:20:17 +0200
Message-ID: <20260421202018.511388-2-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421202018.511388-1-mwilck@suse.com>
References: <20260421202018.511388-1-mwilck@suse.com>
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
Reviewed-by: Don Brace <don.brace@microchip.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>

---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b4ed991976d0..65ff50982978 100644
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
2.53.0

