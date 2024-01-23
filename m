Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D9B1615B7
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970184; cv=none; b=BHO92Cjajvr1F/iWWyzzwHCBOLXWHGgcRD0z2K/HOmeGp1QL/Vn5/OF83C0rJaiva7SHrlmlPE2KPSIF33dS1uIg9KhjEdsfkNWx0VHVaXHpSAF+NUi4kEKbDkZ/D1kD+nXh0HiMwtycdTrx28yoPsgnFYylf5jApZtrtmZgr6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970184; c=relaxed/simple;
	bh=LBqk/a/7XxyM37MkXdksahXfcAh3M0YpOfyluKrlFV0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GJ7XTB9uM1ki/gipUGpifKU+/qf8twc943E0QEvTphu9LADMZrjLObh7rcuA6YpT0pkGdf31XKsrrMCXm3p/YQSViAtBHep3LETWTicya7fRKcDeZn1etJPl0aih/xWuvgrRWVKxrlyb4gVTpGAaslgrGo63segUB+iSwChF2fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=GCwh5Ys5; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GCwh5Ys5"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6dbdb1cb23fso2009966b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 16:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1705970181; x=1706574981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XUCj35B+IoUqLMsvIqNWwmNsYz5bFEZJWHH794ML50A=;
        b=GCwh5Ys5AreNGnJv/o5MlywdeWL+y/chxDSHj197Kcl65QXHWa/QrusK3ZOTD8lhq9
         AoucqwVyfC2267GBWyiT9UUNs0e4MK/Fm63YrIjOfzaz6VsyUcf4aCwCac/yAqDb2vyR
         PEKbRWcUWlhwUm7GcO+gaCdfhkCEWJy62yo5Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705970181; x=1706574981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XUCj35B+IoUqLMsvIqNWwmNsYz5bFEZJWHH794ML50A=;
        b=HaePiY7clPMNHo4ZoQmFSN3gZ01GdPjnQLuPtcDcZMwo/Ypq29F+wEvlu9wUb2/qbP
         mGr2Toc9GR18R2odcw/fG35YwtzPPf1P8c2knrIzXIX7aH7+0mfyHGeDyJ/cyv1715+Z
         NlL0COvoV6FTZobfzzGWfzASeGPyyYhP4CKhXYOtUgefq7n/xYnrh/KqVNLm6R9gZ9l7
         xVIgFaRVXOclD7bWitOxW2k9mkl4UlOQqK2TtV4nryn6nbUOfTWo0/A4YXKgI5cJ2Xbt
         nf4TwrNzgxI6NbvCQLhSdqdJgm7GUwvwqef0G+ydiqHdS8ghG9O9iCgmGGnh5qneB966
         Uikw==
X-Gm-Message-State: AOJu0Ywam9Q/Mzel9OQxjvHjaScQLoK/CYqjnxE1y4KFDanl85RNLH9N
	n1BbftoqPk94KCrmRDkP7z7BEHOMqhlmnHNoo/Uz62nSljrKP7uHKafoucR2gg==
X-Google-Smtp-Source: AGHT+IGHAOZ5RbrxlekwcgptdcBkTzY/+KlPMJsJzP8k7ICUY18jNvt4AfpnzbQWNGfW72d9WEsgGg==
X-Received: by 2002:a05:6a20:72a9:b0:19c:4dca:a86 with SMTP id o41-20020a056a2072a900b0019c4dca0a86mr1877300pzk.66.1705970181377;
        Mon, 22 Jan 2024 16:36:21 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id u20-20020aa78494000000b006dab0d09ef0sm10164283pfn.45.2024.01.22.16.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 16:36:18 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: linux-hardening@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 72/82] scsi: sd_zbc: Refactor intentional wrap-around test
Date: Mon, 22 Jan 2024 16:27:47 -0800
Message-Id: <20240123002814.1396804-72-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240122235208.work.748-kees@kernel.org>
References: <20240122235208.work.748-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1962; i=keescook@chromium.org;
 h=from:subject; bh=LBqk/a/7XxyM37MkXdksahXfcAh3M0YpOfyluKrlFV0=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlrwgLEf/Cz5+23/+enVsVIkLx8QMLFJ93FtDfb
 s/ses2igzyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZa8ICwAKCRCJcvTf3G3A
 JpEDD/9MrWjc6bOmLUNDTK8C65JpgDJf58ljxn97yBwSxMLQcWeG03LZ2GDDyQBTzP63WppqnI7
 ikfMG8tyk4rfJg5sDwA2nSAc0ZBsSwVQFMlPTIH7bAaKqsDDw4a8GBqBMXyJIqODCBt4pT4VDsF
 cYb3ksk+uVx42hbg+85EHCyBBDtW+UgTWsJnEKTG7SYN2rdS8mxVACStdqvaijZrgDeQucGZBV0
 5t3y06uoK9tzxx11ps0PiwZD1Eb30y/j1Puzv+wuIik8LpMUijX/QOF4spJeXn9Uf/kTrdiXrtD
 CAjxej0vsOSSdJgXMK1SdKvSfYjGaYdXkI8LiM/rUs5o0ZUUvZiZu53llRz5BRrqDAIFfUGeJP/
 bvu8LIIJHygXBw0InDKzOgSz7a9VcQOlWz7oHfbeZ8NUVwheYgIl+J4lUiBVKR7eXEg2Gi7L24O
 HyHMkzEePZv03dkGkLTu9NiV9a5Ncv4emMcauHel4wVwzEk/akthm0xu2LcJFkqvkcL/bN1ayT6
 yRwPu5VutSooWXVuKdM3Zq9Q/bn2TJJTuZAZo2zaMG6ugxX/03/6zTGuC0Mz5z17SedNM9c/6sv
 zA29mGYVnEl4G+dotIhrrvQ2UU2LJZEWJCtvONixSMW665U+C3gyac/J1KHzBgFDXuWD98EU+xD AiN7s4tQdaMO3kA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In an effort to separate intentional arithmetic wrap-around from
unexpected wrap-around, we need to refactor places that depend on this
kind of math. One of the most common code patterns of this is:

	VAR + value < VAR

Notably, this is considered "undefined behavior" for signed and pointer
types, which the kernel works around by using the -fno-strict-overflow
option in the build[1] (which used to just be -fwrapv). Regardless, we
want to get the kernel source to the position where we can meaningfully
instrument arithmetic wrap-around conditions and catch them when they
are unexpected, regardless of whether they are signed[2], unsigned[3],
or pointer[4] types.

Refactor open-coded wrap-around addition test to use add_would_overflow().
This paves the way to enabling the wrap-around sanitizers in the future.

Link: https://git.kernel.org/linus/68df3755e383e6fecf2354a67b08f92f18536594 [1]
Link: https://github.com/KSPP/linux/issues/26 [2]
Link: https://github.com/KSPP/linux/issues/27 [3]
Link: https://github.com/KSPP/linux/issues/344 [4]
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/sd_zbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 26af5ab7d7c1..2c377e4cdb2b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -295,7 +295,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			    (lba < start_lba ||
 			     lba >= start_lba + zone_length)) ||
 			    (zone_idx > 0 && start_lba != lba) ||
-			    start_lba + zone_length < start_lba) {
+			    add_would_overflow(start_lba, zone_length)) {
 				sd_printk(KERN_ERR, sdkp,
 					  "Zone %d at LBA %llu is invalid: %llu + %llu\n",
 					  zone_idx, lba, start_lba, zone_length);
-- 
2.34.1

