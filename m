Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36813ECBDA
	for <linux-scsi@vger.kernel.org>; Wed,  6 May 2026 09:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778060710; cv=none; b=oWTuj7U43wIlRbmLF/eG/HSIWoMNLSD6MbRN5+wcjF8Lmeo88BOy/w1rDKcvI2I2B6771XY7sJI7uyIX9ySnYgPRyx8/JXJChdSPQVGHwtMeKLeprMuH1GDN+Vqd55sQ8Hvi2WRcGqS4VPAJI72q70o5a+G2uFq8BDvz9HEDNes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778060710; c=relaxed/simple;
	bh=/4GOugeFmVNvQmhJxFl65oFDmFB1nq66GEwmFZuNJX4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KqIIwV9Yqeow5z0QxEzqyFQz6HW/8qcAdW/GgC66LQo79mOXYIL6yTWNGCW5g4pmozE5C9onoZbtMjUClDH2y1g3hw4HIBTcy6yd9Jora/sln+ar0B3CIX/41KYOraQ1U5AdIvJA+mXde961J6wsdV+gUOjjwRh1EvxIivDfaVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TprZ9KS5; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TprZ9KS5"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5a86c1fe573so5051530e87.3
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2026 02:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778060707; x=1778665507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vdgpu01n6LJ08f+4Zy/ksMaSMU8iAjugnioWdV7lEek=;
        b=TprZ9KS5Rvp7Q/u+ggNi9Y8PHM2x2kAdZl7GeQx9++6ot9JNN7x248Z8ar/Z1SnilQ
         eMUgpH6ffZjqxBTqHGDA1CCLaNoiieLQSpj5DLsRVWzFLMKkDVRVUXNswRz3MI9gQrJV
         Ocu20IrRW4gC5SYFWhIzcwJjED4x9hswJVx8yJZPuqY6Aku/op029CBo0sFZCYDrLR5d
         RLFk2z/g2cNm47SJTls8j68N2RiieDF/N1YD+VtTVsEqWolyAju9fOEoFDxtDpuC2A2g
         7qhMmmAv+SvRso9yzxY1AFN59aRgYuxI+wAS0DnA4pZVeMAKC7fKRIistZx32aI64fAq
         2gRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778060707; x=1778665507;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vdgpu01n6LJ08f+4Zy/ksMaSMU8iAjugnioWdV7lEek=;
        b=HrCrMzIzMbXfD8B2hhp1mJLYmslFk5Q2/XhsMhSfAY80VEzFeIC2hRk/3m/GJpo2Nu
         CQ0HmF/Vug13/YvrJ1Jg3VgqQ0iw1uUTa+vISTItMBlkcvxpbIAoX1bQlo9oUwvgfMKH
         zxv+r61RfaPyxsM+YNlgmXJEnUjvtpn0i6kzzQYHEgBFJcCMfITNxcsOHFR0xeDclGhA
         ttHiUi/j12pdr5WnTG5W8NISTRpvugJ83etqK2ZKOkoSPzv6V+gUYY1H3sXTvRsjqDUm
         2EVmvL58O5WoenijmRudsp3cQ1kdjEuQt3FkX4RbVYitVoX5/1pAUJCWrAgF9wqmEP3B
         4qwA==
X-Gm-Message-State: AOJu0YwisfrZcRGicxmAkiyPa8bRKjgWHTVo0h6TmLS43YL9MZEu07Rh
	0DFEW5+vCo3xktzFGT/4GyzYJ+z8E6hxn2SI2HbKSBcQQrVsCJmGk+nv3/1fJ2ds
X-Gm-Gg: AeBDiesQ6yFky2+PLg+8db2kcuSMvvZ+TPG+bP9fejMlpOGhfqcnulrohmcBrwxTfPW
	FBZvBpDi+za2vOEtD9BVSQQa76C/EfvkCua54ThU2/sdH7YtpmNj4qEjMhMVK0HEhqOnmFQ4LN4
	Ml497H8w2Tw78Qe77gjVy36Lo5VC3NZlVMT7lQMYgX7icim9ed8H+cQ46TvHmchDBcoORv6dsYB
	+NjW0ivmiSapOos6VxSDfjDPdZ8cBf3ZZLDgB8tbPGNxO7a2ZtLf//tQc+rADQNfss+/9WvpaK7
	14aIAYkVnzcibc/VJfU75bD063AFQSyrJnmrRC+kkqrzvy6icBDumMqEbo9xQgXhfnGcNbEMDkv
	VmHewjCy9B6kW7hT7fhBGl57G8TJdykfG7qAEVHLg9s8DS3Wo1s4O/Y0LH1f+Gk4N3+o10ydu4B
	lm2sqywir16twp91bZAj63PpXMy4t220PxzBWvyLeJlfEUyjCZei/kvLPRFre1kBSw0mN0na+OS
	z9D7xBaNRkd1A==
X-Received: by 2002:a05:6512:39c6:b0:5a8:7f03:e226 with SMTP id 2adb3069b0e04-5a887ce0494mr975208e87.24.1778060706535;
        Wed, 06 May 2026 02:45:06 -0700 (PDT)
Received: from Shofiq (87-92-218-151.rev.dnainternet.fi. [87.92.218.151])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a86c7a1698sm3326449e87.3.2026.05.06.02.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 02:45:06 -0700 (PDT)
From: Md Shofiqul Islam <shofiqtest@gmail.com>
To: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Md Shofiqul Islam <shofiqtest@gmail.com>,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Subject: [PATCH v2] scsi: scsi_scan: Fix typo in comment
Date: Wed,  6 May 2026 12:45:04 +0300
Message-ID: <20260506094504.2235-1-shofiqtest@gmail.com>
X-Mailer: git-send-email 2.54.0.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix spelling mistake in comment:
 - initialze -> initialize

Signed-off-by: Md Shofiqul Islam <shofiqtest@gmail.com>
---
 drivers/scsi/scsi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ef22a4228..a35a5f777 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -858,7 +858,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 }
 
 /**
- * scsi_add_lun - allocate and fully initialze a scsi_device
+ * scsi_add_lun - allocate and fully initialize a scsi_device
  * @sdev:	holds information to be stored in the new scsi_device
  * @inq_result:	holds the result of a previous INQUIRY to the LUN
  * @bflags:	black/white list flag
-- 
2.54.0.windows.1

