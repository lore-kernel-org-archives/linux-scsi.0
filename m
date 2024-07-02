Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835CA12EBD6
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 03:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719889340; cv=none; b=LSjwM9EFSxi/z45b/YwahgpdnT7eUTfsu0FY59dq35nVsTYL1oCes81CxTAqUu26dEuYrET+RPs/bdFRxRUsx1dvMf8WblBOxmUlnntb3buWtdI9nhOdPAnb/LEuiQvGSGNXIxuPz+mT+gfNhDcQycqcWT9Nw6DmKy2XNO4tF7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719889340; c=relaxed/simple;
	bh=76AMBBXtU5aCqHyAiKD9DbjKd2koPJbTbe5mV7L1o6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPY5yjZBfLBB+Asozu4O/w3LupRbHZlT1yddZsW16uXr+PNxjM3C8DtDAuzRLJFYfbtGpr0utHhOeAnCD6zl58JMm71KXq2OcnKSNJNJY7RfBNARQw4wtA2rZi68eDNBx3w8GKRYf1DZkJHlFTmenopYvEIZYsougHSXGXdx7RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=lRW/TU5+; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="lRW/TU5+"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-700cc8e447aso2110213a34.2
        for <linux-scsi@vger.kernel.org>; Mon, 01 Jul 2024 20:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1719889337; x=1720494137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QQQwXyMsRqqUNEWCeRrNsfzgQh+cx/wn5vbkQhMYQAQ=;
        b=lRW/TU5+JlaDB6RTSJh2UefQqtuM/TxtLjVqRhugqTyBRyWMBFo1QMjsUPVouHSIL7
         LLO5Zldc56NstXoWgmUUtb7rdCZYnJhuj315RAMA2UuHBfBPR4/47I14ljvOd5LZt8kt
         8+N2oBHllEE08j+NrDijsmQcabHESFhilUVNZb+ZEl9odQ18jRrV2Ah5fHlT3pSE5tkI
         sOLpxtPJfnXt8F46LXt2fck9RoYkhVfzKI3M44jnnxVCjp4JF6Qy0167Y18lLySyYpXb
         WtVAIgoytYrRHbi9kvhItuypxA9ebEUkM/ddRpAROTt/UiQwHxQFUzHqIPrMF6si9QbH
         awAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719889337; x=1720494137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QQQwXyMsRqqUNEWCeRrNsfzgQh+cx/wn5vbkQhMYQAQ=;
        b=hk0qXOWdqj5J2GUM5cep0Pk7+VBFmceoEU5tzgRUEnsZON2NEqMQCuwK39cLDoFU/g
         G4Z1aGX3fElvkjCbawwm3XHygDjvqiWgcxKVd7UDt5vPf0eCm35KIrkfeh43O/ufvsov
         C8DYw1lHL9Rzu/iNnoOTiWoMty3v7LPl7396XqCQeo/yxIjtwaAsh0vLtw0hhssmg2IV
         K5RIBedxYw6Tpfq5mQXWpZS/DuNYLFvnwzHmMXLge6uR419sXlt107mTASJVDkSwba8b
         pU7IEW/WPD4xFJPB8OMT65MznFHb5kQLCIyaU+uKFH4s5HUtfUkWtO2RzwII2o8pFq3q
         qT8g==
X-Forwarded-Encrypted: i=1; AJvYcCUS2nPR7QduwoVkTTRRQPzOOp4MaU5hi9AVoFW6rrX1s1nr4M3a6DUwmX68mIxAbZq7ASp/xfR8wse1WjnrmRPOll4SZeNyZd6fKQ==
X-Gm-Message-State: AOJu0YwVxPt1jecdrt8u/Zw5IYZr++rw73vfaMFT2kSNkW/FyfHe5QNG
	EkgAXDDR18SLrdrymanRsa43xg09ookPs8BnPPZEez6AZ/s290UvE50XaFmC/VDLKzVyGQV8lzl
	vfrY=
X-Google-Smtp-Source: AGHT+IEo6Ekcikz9MU8COKrqbNv2gz5ysi3gbJlGTeBCwSZVzy9i9s/b1kCO7DSOJ+UAekre76dXuA==
X-Received: by 2002:a05:6830:6b47:b0:702:59b:d26 with SMTP id 46e09a7af769-7020766b795mr8938625a34.27.1719889337505;
        Mon, 01 Jul 2024 20:02:17 -0700 (PDT)
Received: from fedora.smartx.com ([103.172.41.200])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6a8dbb2fsm4792904a12.31.2024.07.01.20.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 20:02:17 -0700 (PDT)
From: Haoqian He <haoqian.he@smartx.com>
To: Christoph Hellwig <hch@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: fengli@smartx.com
Subject: [PATCH 3/3] scsi: sd: remove some redundant initialization code
Date: Mon,  1 Jul 2024 23:01:16 -0400
Message-ID: <20240702030118.2198570-4-haoqian.he@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240702030118.2198570-1-haoqian.he@smartx.com>
References: <20240702030118.2198570-1-haoqian.he@smartx.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the memory allocated by kzalloc for sdkp has been
initialized to 0, the code that initializes some sdkp
fields to 0 is no longer needed.

Signed-off-by: Haoqian He <haoqian.he@smartx.com>
Signed-off-by: Li Feng <fengli@smartx.com>
---
 drivers/scsi/sd.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b49bab1d8610..c7268780c642 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3957,7 +3957,6 @@ static int sd_probe(struct device *dev)
 	sdkp->disk = gd;
 	sdkp->index = index;
 	sdkp->max_retries = SD_MAX_RETRIES;
-	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
 
 	if (!sdp->request_queue->rq_timeout) {
@@ -3990,13 +3989,7 @@ static int sd_probe(struct device *dev)
 
 	/* defaults, until the device tells us otherwise */
 	sdp->sector_size = 512;
-	sdkp->capacity = 0;
 	sdkp->media_present = 1;
-	sdkp->write_prot = 0;
-	sdkp->cache_override = 0;
-	sdkp->WCE = 0;
-	sdkp->RCD = 0;
-	sdkp->ATO = 0;
 	sdkp->first_scan = 1;
 	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
 
-- 
2.44.0

