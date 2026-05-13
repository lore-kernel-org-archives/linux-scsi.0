Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837C64C9559
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 17:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778694186; cv=none; b=HB55g7KxNzyjWjAhAwSU6czMC6R5CQtJ0ubg7BQRE+0mMwhnYMwN9rmoh78YzYaBp6RUnDsaARoKC2g56TWPkJ/iOlaXjdh0eHBGhKpVjWFZAH9/2q/vkNI5OSPqHAcy3c4VF+scrnKfvh1Hg3Ol32grhVTAG+Uwv+tFy+eGLgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778694186; c=relaxed/simple;
	bh=lc+IGH0poue7EOWyWEhf4BsBdmd01TDgiIasq1HkBDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrI+CgGkAhjZbtkAOh5eQ+nex8cm5pJMSgPeRfpUe14l7zTFzGJucrxJfcOwsFs5LSIjiBarKKE8CqMn3V9nvc08q9U2JaIG9hgkIHo7g05p+5+A50ZkkvcC7ZhTivhiNkNXnbZNcbO2P3KvYORcvyR2igo+ayoC5HnK3k/L9v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IRtolmjs; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IRtolmjs"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48896199cbaso62192675e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 10:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778694184; x=1779298984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z/U/GzJ8VybTWe2MVWA1b3Y2w7oCzXqTk6bWcPUWOoc=;
        b=IRtolmjsDJxGpU++5UwtGo7mdJA/JaPXnhZ7Spux0y4tUB8WZmvFgSlG4BCWrS983Z
         C6t1kT5CwIu840kZy3F4vTU3rvoNLPOoGOX3DEKfkBcuOmEUz9x6nwznyTKNF7wamQxN
         /7Wy30h9g1xWd0PBt61YaMASPZfjhnabob4TpIccFU/6U3e/6q7vsJflxfuzG9J8lAZI
         jZyBmct9Ww1ytYK3icWN9twsoid71O7qhTxEuwYWyhcOYqsEcdyjjVWUcMBp3fkPWEhW
         92NaubFakXbhYyInHR6KHdWY+ormInw4gWV/QoNOA84EzRSvyJ35eI5+odjPQdWrXXnN
         h/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778694184; x=1779298984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z/U/GzJ8VybTWe2MVWA1b3Y2w7oCzXqTk6bWcPUWOoc=;
        b=JQDlGgpOf74UxEqVDgwA4b2qa5MyJT3KCCQpEDVp+2Hkf8POTxalLhk8io4J0pBUHY
         JbndKZUJOdQvLyqtJ0i2012HGH0JWg8D4col9yEhmJIZ1TSD4jAIeSeAdOvQODZcFcLN
         sEPqMll7sb8KcGCcnrdjID7mQ2fDSWOSvQM6a5CHHMMvbfHdm608sUz+tzOsUg3B5/ot
         RPTaDVoyMFkbrK5wdJPTfw9glBSfNkWM9gFKsN+bhgzzx958KwGjT7UYMqfH8os06SMz
         lv7DQ5gGBAqIlL6sb9l1F1wd8dBDTq9w1kETa1+f9GNVmdCiAxNhfG/120CkQJbY0U+i
         aT3Q==
X-Gm-Message-State: AOJu0Yxvf1Xymexf1iggAo6lGDYCGxS3692eXMFmnTFTChBnpaCv1t1H
	HIirVFsmArOt3SXlghxfHoJXz2fGaIKdaEmmPzGd+j9TwF548Jg0NN8l4L2Hzxm3odw=
X-Gm-Gg: Acq92OHeDu0nk6l62pPY4mVWbsBgfbQldWbg9tEWXhfjfj5p0htCqMmy2A9udVDr51C
	DFOXmmOz1qet1qLCzQUBRcWaXWI08NgHnHIMFxAPlFxgtYGlmYlcqbnEGlvd+twtv/fCYvImng0
	rA5zbtvpI/EDGYLOCEn57r47gBee6479p0nNnZR7awlna42ueESr5MAB5OmlrVubWoO14jJRcN9
	VseG3pF222E09cQDgT0ayTDgbxHFHiWYVhQQ3BhPAUpvjS3a6xi/1Q2K7qaFdQOQAB4cqXBXH4r
	TCBQAbJxa9das6fWved6q1W1+JblHdNQzI4pReSbSry9I1jIUoBDO3NftTNzbEvbgjQDkUunRXV
	E6sqmCQb3DdQyme+oFktRVAT5SEwvSDH9Kfu5RUxbapYCr8QVnbuHlqxLtgMM4JUeC+MOFRYv8L
	wNYG9vYiwR34G22Om4qDQv/W1V6Cnmk/NhAq3si30ZVGErxHW5MJPQYfbW1SqOrJrpi2j03Oqke
	MqRVjzBIqvpudUheowDHMVZ
X-Received: by 2002:a05:600c:870f:b0:48e:8741:fd42 with SMTP id 5b1f17b1804b1-48fc9a0ef1cmr71204045e9.12.1778694184055;
        Wed, 13 May 2026 10:43:04 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48fd62b500fsm3897975e9.1.2026.05.13.10.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 10:43:03 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Don Brace <don.brace@microchip.com>,
	ranjan.kumar@broadcom.com
Cc: linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	Martin Wilck <mwilck@suse.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Martin Wilck <martin.wilck@suse.com>,
	storagedev@microchip.com,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] scsi: smartpqi: use shost_to_hba() in pqi_scan_finished()
Date: Wed, 13 May 2026 19:42:35 +0200
Message-ID: <20260513174236.430465-2-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260513174236.430465-1-mwilck@suse.com>
References: <20260513174236.430465-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Martin Wilck <martin.wilck@suse.com>

shost_to_hba() is used everywhere except to obtain pqi_ctrl_info
from shosti, except in pqi_scan_finished(), where shost_priv() is used.
This causes one pointer dereference to be missed, as shost->hostdata
is a pointer in smartpqi. Fix it.

Fixes: 6c223761eb54 ("smartpqi: initial commit of Microsemi smartpqi driver")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Don Brace <don.brace@microchip.com>
Cc: Don Brace <don.brace@microchip.com>
Cc: storagedev@microchip.com
Cc: stable@vger.kernel.org
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 2026ac645d6a..5ec583dc2e7d 100644
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
2.54.0

