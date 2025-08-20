Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8007F27C178;
	Wed, 20 Aug 2025 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701141; cv=none; b=Da0x5Y95TidlI2snkolZQbAbyGciQwN0fYdg3cubFtSeeuqr2adzzs878vHDOVAFvyN5ZMtlRXTX0/hrOhE3vv5Z9v24b5cmlB4E2+sVU4bFM0oRBO5/DXePmncSJUL0tShC+UNebPLW5sb/DTnpLMtblws80WRqgJ/whwVcjwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701141; c=relaxed/simple;
	bh=a9JVGlwGYXW2hFGBHL9RHXg7JiwCWRbnsUA6+G+T1L8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j07kfCTSfuOKAE5xmkKwa1xKsYpE8voWUAWpAHzTIE+fw2lyw8SmD5WeS6a1tVll13YnT80nueDCuof4vKK3A2mpRQ3aoql9poHVirOTR7FRogOwOffTelHNfcRkrb+PhMygbsJBjSKwUPccH96gQUPmGOTXhP28VFmwU6LgSTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ESiHHS1J; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ESiHHS1J"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2445818eb6eso49479895ad.2;
        Wed, 20 Aug 2025 07:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755701138; x=1756305938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rkgDCA4x59UzST9zClVUyf6IYYHR1UzirdfSdk3MAOg=;
        b=ESiHHS1JQ+SeNuQmJ+FJy2kTnO5FPDSS9GPshY9QHKKOVpSsSKYmT20PBkBJt0eznu
         JLrYEsLpHt+zhV+j6zquusz1QWiFK/w7gK0C2ZAcGpUjLKZowrbflLRtOqc+M53rIH78
         SrUQ+N2MzjjUot03X/9Fy9KEgV4tzfnLLKh7ZbQ3J7/Hv38m2bPJtmeBsSBhFsHQgGXy
         ivv4RWxWzjWb0t5KQKCqqEPCMd78L2pcJSy1otTApwoIflQ9xFfcl90lMs1J4zEFmbI0
         5Pqj41iGB5NyDdQ9r3iFtqia3cQSIkL4tCCbwoJpk7clT2L6byabsvEUZsdFvBPV+hs2
         BJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755701138; x=1756305938;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rkgDCA4x59UzST9zClVUyf6IYYHR1UzirdfSdk3MAOg=;
        b=QtiVzKBoodFe9OWQIJjOeKYb33BVrdimBhVH7LQh3EpOnrjNEvP/46uxVoWOrf8kAe
         kcTHyZW/DKtVbm9wFs3HX8he6TjUJY1L3uejUu4YU0VPPrAEM4r+RLD8FxLygtc6ihbc
         dKBBagVHqfdBCagCjcVrsAluAn4sYphoR7KBl6z71YGkh4hYob2ucJnBoyLr+oQDlRiC
         KXOCadDyGgB3XPnC5bgsV/iMt+mAikIB2ML7Z2ailTRjUi/W54fzyu02OALoUW4OdRs/
         U5CR1DJPkSSi+V5CTUDQrm6bDmsTd7hXxlRrf/F6tAvEbRUhlmfGPzMFgjfbEZ/HpNvE
         F/Cg==
X-Forwarded-Encrypted: i=1; AJvYcCXAEdGa+rmoTydVGQ2U3mV74mtd1IIZC6gGBcPnZPQC0Fxy4J2X8itI51CaYqBJFPsin9o2nnzTfrtL8Ro=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVLg/EaAlH+F7ciOXz45QA4wIwim0rYKcy3vozk6kVtxhiLj12
	JxCsHobQU4jmY/lT0ShmIWTwNxcsUGwlh7IY4Z/g6jrxDVjDjXXESt+4MY3obQ==
X-Gm-Gg: ASbGnctU6aLNt0dvb6vNcEcM9Pxa5Bd6SVLTP6zqBulhrO3cS3qlM7zpXHQvWzzGlRn
	fnaiuNdsRVMNseBVB4bN++Akn7MqomJzEf+HODZozqRkx5bY4jGksgIBDs1vBfAeHduOOTTUi8j
	zwZ9AdDBjSUf/QTsdYl251ub4EZAKQPKNNeLjO6iAt7I+ucI1OV4oh81IRJ9MYGJnE2LFWdKpEK
	z92u+tjJidOxMUqH3MmnfFX2a0w/tRiBdgtmvvqNtD5THlNrTxeq/pGyjAz8qF2jivANHT5F6Ji
	Q8VLjRqdSpCKS1n4Y20iUhpxu4Enjo+AjcLzZfZQm7YBSY54EdTedEQTBeW9rzfRS65gTbdt0cg
	Q4Rs0aqKIX/H+Q1TJ67N63FHakibLI92WMTorm4LYLv0QpQ==
X-Google-Smtp-Source: AGHT+IHo3/oTDGeBjcqWQ/wfmJfUflfkuKNsAFQbiYBhXfX1UH5ZT84x+r+3F436vpJ7UpMbE5yyWA==
X-Received: by 2002:a17:902:f70b:b0:240:25f3:211b with SMTP id d9443c01a7336-245ef27a0f6mr31360785ad.51.1755701137583;
        Wed, 20 Aug 2025 07:45:37 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed379e92sm29197515ad.65.2025.08.20.07.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 07:45:36 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org
Subject: [PATCH v8 0/2] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Wed, 20 Aug 2025 20:15:08 +0530
Message-ID: <20250820144511.15329-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

This v8 series follows up on v7 of the
"scsi: sd: Fix build warning in sd_revalidate_disk()" patches.

On Tue, 19 Aug 2025 Bart Van Assche wrote:
> The traditional order for kfree() statements is the opposite order of
> the corresponding kmalloc() calls.
>
> Shouldn't this patch remove the initializer from the 'err' variable?
> Otherwise this patch looks good to me.

Based on Bart’s feedback, I have addressed the following in v8:

Changes in v8:
  - Patch 1/2:
      * Reverse the order of kfree() calls to follow the conventional
        opposite-of-kmalloc() order.
      * Added Bart Van Assche’s Reviewed-by tag.
  - Patch 2/2:
      * Removed the unused ‘err’ variable initializer.

As before, the first patch fixes the stack usage warning by moving a
large struct off the stack (with Fixes and Cc: stable tags). The second
patch then simplifies sd_revalidate_disk() by making it return void.

Many thanks to Bart and Damien for their reviews and guidance.


Abinash Singh (2):
  scsi: sd: Fix build warning in sd_revalidate_disk()
  scsi: sd: make sd_revalidate_disk() return void

 drivers/scsi/sd.c | 56 +++++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

-- 
2.43.0

