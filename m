Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C58158A27
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jul 2024 13:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721829095; cv=none; b=VqjZhICKY1F0RPFek12a6Uggr1osfFgV52COuOo9MkWuzGEd9m5VbsUfVnIPUg1LgaW85HZTDi8oloqYhqKQKroKozTi74AuH9oGGY4X3cTNRCaaDbgYvcVONWwOd/v91zIusdX/psKLF3506dIFnpxg2Q8KW9XDkvkJCXtx7Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721829095; c=relaxed/simple;
	bh=SsSkhNGn7QJejrmFIGvtXvlDi/a721Ld8Pj4EOwWE9Y=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oNWFL27U6U6aXcm7kkk//LRpbIAyrzyqYzma2vJXa1EmfQFAzTQnul20+fpJecctb/zNMNblf6Dz75WkOUSzCzZOyc3ErIVlIe8Ntrjs0F1EMu6VKaMTcz3jS7jcYeLdD25PYObneZfGiX5AnEfdNpRIo+LWDnGwds4lnEY3Wsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vamshigajjela.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AW5wLz9R; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vamshigajjela.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AW5wLz9R"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-672bea19dd3so20103957b3.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jul 2024 06:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721829093; x=1722433893; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RrSVcz2VewJByKdMTTCyLdkt0Sk8iz5c/M167BcRneY=;
        b=AW5wLz9RIirxjwNsnGeKKn57OpR1l5gRSpRbrzXsw11ssdXqmVzLSxxTFPNV+TFfxA
         0IJjzjiowdKl5dOclPWRCVjarJP6E2fqs9O5N0IJ/j+np4F4g3zqd1sFRQTTnuDfxK32
         tqOKp8nEOKDdxcdfb9MYUMXmskYdB1rOFX0jXPnugZ+CbdvSqcNNIpR774xRD9zHnlTR
         4ihIqT2dTkZrtwOQQUAnTYRmviUOHxGSAsm1RAukB1OT8uYe+nOkw2oBsug4t71dxtSz
         UFWE9JXv5VV1ZOIH++wj+x0/+oIQrdU9Te35ifqnoirh0X284eCL03JjqXLNnoD+xdF1
         w1aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721829093; x=1722433893;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RrSVcz2VewJByKdMTTCyLdkt0Sk8iz5c/M167BcRneY=;
        b=JRrCou7ZG23PaioI4fraI8+g2fy3CAi4y71OznSLIOqubi0FfXndk/4Hvv5wY3zSUN
         BUWBR7B3UP8MsLQY3RlsOd4m/MBXD18XDI+jHiTiV73QO6H0dkRVLs1F93sZH9Gyx2c7
         8CGQQ978ClpaMPJrcOD2E82slhRS9DWQf8+mQWx/hadwkYdBZ/+k3tiqGuQoUMsDGgGm
         aL+74PYiQX2dHUeneVDDKWOnJIUFBQDCTpStBHWMd9UBT+Hm8Z/58MFz2nLyTYH9nTHd
         +hRunLfDHr2i4vh0zpwElDadJQloRMiL23CqILDFWYHsd99mQDYEHAVfSod54ZC1Po8M
         TxUA==
X-Forwarded-Encrypted: i=1; AJvYcCVihFcUAXWGWGIbo/Hs3954vnCabjpDmw9h4G8RzBiaQK52W9EDukey0MLAR0u7/2UtQHxsiYVWRYWD7ZZ6gJ0NazAGXHCsJYvchg==
X-Gm-Message-State: AOJu0YwJcwVbUZpQQc/n+cTks6kUOdqB6EpAdntO1p5bE2Q9hIXOZe2j
	rvGWPkTo/S4IRwqJ81IusGsaJyVODXSMRFBhiwLIvS6re2Xj7x0J/XnIRbwKpRUa5sf2YUbRhc+
	9mJw6HXHgo76ezQfOR+OxLnnLfxDK3g==
X-Google-Smtp-Source: AGHT+IHbNtAEuIYXFpzA3YyBaOuWG4DbFIf/VUQVlqhnq9b7xo1ygHVyCorff/HREiUTR/35hKqZj6/k+Rc0jmFFM1pJ
X-Received: from vamshig51.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:70c])
 (user=vamshigajjela job=sendgmr) by 2002:a05:690c:810:b0:673:b39a:92ce with
 SMTP id 00721157ae682-673b39aa039mr103587b3.3.1721829092669; Wed, 24 Jul 2024
 06:51:32 -0700 (PDT)
Date: Wed, 24 Jul 2024 19:21:26 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240724135126.1786126-1-vamshigajjela@google.com>
Subject: [PATCH] scsi: ufs: core: Fix hba->last_dme_cmd_tstamp timestamp
 updating logic
From: Vamshi Gajjela <vamshigajjela@google.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Vamshi Gajjela <vamshigajjela@google.com>
Content-Type: text/plain; charset="UTF-8"

The ufshcd_add_delay_before_dme_cmd() always introduces a delay of
MIN_DELAY_BEFORE_DME_CMDS_US between DME commands even when it's not
required. The delay is added when the UFS host controller supplies the
quirk UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS.

Fix the logic to update hba->last_dme_cmd_tstamp to ensure subsequent
DME commands have the correct delay in the range of 0 to
MIN_DELAY_BEFORE_DME_CMDS_US.

Update the timestamp at the end of the function to ensure it captures
the latest time after any necessary delay has been applied.

Signed-off-by: Vamshi Gajjela <vamshigajjela@google.com>
Fixes: cad2e03d8607 ("ufs: add support to allow non standard behaviours (quirks)")
Cc: stable@vger.kernel.org
---
 drivers/ufs/core/ufshcd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index dc757ba47522..406bda1585f6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4090,11 +4090,16 @@ static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
 			min_sleep_time_us =
 				MIN_DELAY_BEFORE_DME_CMDS_US - delta;
 		else
-			return; /* no more delay required */
+			min_sleep_time_us = 0; /* no more delay required */
 	}
 
-	/* allow sleep for extra 50us if needed */
-	usleep_range(min_sleep_time_us, min_sleep_time_us + 50);
+	if (min_sleep_time_us > 0) {
+		/* allow sleep for extra 50us if needed */
+		usleep_range(min_sleep_time_us, min_sleep_time_us + 50);
+	}
+
+	/* update the last_dme_cmd_tstamp */
+	hba->last_dme_cmd_tstamp = ktime_get();
 }
 
 /**
-- 
2.45.2.1089.g2a221341d9-goog

