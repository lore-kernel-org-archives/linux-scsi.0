Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07FD7263B
	for <linux-scsi@vger.kernel.org>; Thu,  2 Oct 2025 06:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759386646; cv=none; b=QfOJdKg+JUBhqRr9YsPI9YACULYUpZKnsW/268I4mxfx+mhHK76bsdLmEwRd2kr2PXG41Af8si+pPGuBfx0Jw8ntlG4L/czVrw98psHmaXytqVOjheajxVZZit24Qfc904LsLWHmst9Mllmts7TicMuOmegLF4Xi2lUTsyIXnU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759386646; c=relaxed/simple;
	bh=YIxKVzr9qaXBN0ZylLrG8vLvgAuwWPudPeCshwDYBxU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BedZS81/Gu+atM5TU11XN+RbXSITUgy+VbHkeVgmSolTpJl+cq5XLxXtuV9F2tfOJINFv8rjBU9aN9x4RWrncXxFLcHSxof0cqP7jLgc/TPOqUjdmS/6DlQNRQrDhSdqmKhHWT74ct9UeHLTO9kRnfvfxKPOOdVXpJHVH6XzOK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nnTh77DK; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nnTh77DK"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6318855a83fso1438281a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 01 Oct 2025 23:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759386643; x=1759991443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KAxo+DN0iB6IwYVHObHr0a0ySgSeQeXI1l5BX4eIFNE=;
        b=nnTh77DKAHBIzDXoD3gIWJUVmOCuGbMmbeAURt0dhR6fXTLgH00AD+amtAXCrGAD2a
         7BWcA+NNjU1M9foW/tpxy5k1lTpWrvNWrP11dGWC+btCvflkzb9YStPlPhk8sk9YfO5Z
         w2YApX+ClA8nGxCP0fhKNvBJcaCU2ytJ14q0sOWzJCxgz6YdXuzg/0PublYA2CiLJ1KB
         RvgHS9N+wHmpf4gYjDWR7y9nijnoHVL8HTZznOQbrBR2c2+h63z65GstbzzK8NKg3hO0
         n7TJWtKcFZkxxPNaxLQNBhWnFXUcy2H1Mp9Law4SAuSsMqARAnWHDhr/h8KAurpnQ7+9
         sM7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759386643; x=1759991443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KAxo+DN0iB6IwYVHObHr0a0ySgSeQeXI1l5BX4eIFNE=;
        b=IDkPoMJ0kZqRirRb4aM+pDCGQ8UuTRwmNx7wlZwnCycAasrNVBVBhpUz9nR5Ab6AB8
         BVX8i+9JRyk6+QhnAyBpgn+hYFtFLCT90XstrbpW7IXvwjSiTtGbpM+h4Xp3gJ8D2bww
         CU5hdZjyMFOQsVxCf4HD82vBtsUTFu/ifmsRsDt4QzwFShw/Zfmalteck4SIo/V9Ub1t
         eegjj4ERPXV0Lg5tP6g5QKcyktO6iUv9+/I/fPIuMg/P+M8xrH1n2FM44Sx4c5gCDbrh
         Dya6K5/+yYp8u5/EDsVOGWMbYNJfzFU4CWYjoFBTuliuLlylkoRkCMIJYgjIwtSB3fpu
         lgLA==
X-Forwarded-Encrypted: i=1; AJvYcCWCT60vEqiirBeeqBIOpmupfAcF3EMWeErgzI+tuk8FnvrWSC24jtfKI3Msma6fVbGlOouGtHgwAUyN@vger.kernel.org
X-Gm-Message-State: AOJu0YyTU5UryPFKZW2BIXmXiJLbC1gRrzDYyOQKLhqgg9NccIzTLOgW
	+o0iAMREaolXBl0krqYdEi1AGHcv02ZQGYDjan+lfEGHMlkdYJZpMiXF
X-Gm-Gg: ASbGnctYK8WGR58YpQ6PxsWPraJTvnWPIgc6TGZcfgr+MeJgV9DcJSLDKyQi20h/p8W
	Zqmh7lAb1pp1Vbt6LEAzezBwTRjcUexuQDnc3kG666HkqVF3bBjjd/rb/6beF19Dxd9ZqfYQN01
	Q++EvbZRoK5RVmPk0wNIkgX9oL3GRwy8LicPU4mz84e5vw0Mauh3JcUQU0Z8wy6JL2X6a142GHX
	kV3KlHJful/yKyS6VthkEd2Mc+P0QxF38wkkIQkc/1LaZ7aMeEgU3KhvkJ1h6C8ZCtAZjQzc1V3
	nvjnXrjmfpX43KEoKv5T7ucF1R7hWEs24Q+Ybyk9pqnZiTcAGuaP9VIfz26hG14aozMk/w2aOgA
	+/hIGsvJcnqPihHN1drcYka3nM9+cgUcmfe+oe0Qx5pt8aL6dInsKRgq8w9KuiedWJXgyhG1cAJ
	PPS5tV5FinQn78dRxGFD3XLdAKa8gMiw==
X-Google-Smtp-Source: AGHT+IEJ4e5RsTkszdNBup8ct9QWtwmGLRs7pM/Ik8mg+tFniTBcoaDxurre2cHsPZE3caW8pu/D7w==
X-Received: by 2002:a17:907:944e:b0:b3e:5f40:9894 with SMTP id a640c23a62f3a-b46ea31d2abmr807245466b.62.1759386642808;
        Wed, 01 Oct 2025 23:30:42 -0700 (PDT)
Received: from localhost.localdomain (user-46-112-72-121.play-internet.pl. [46.112.72.121])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4865e78242sm134271266b.35.2025.10.01.23.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 23:30:42 -0700 (PDT)
From: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
To: sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	linux-kernel-mentees@lists.linuxfoundation.org,
	Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
Subject: [PATCH RESEND] driver/scsi/mpi3mr.h: Fix build warning for mpi3mr_start_watchdog
Date: Thu,  2 Oct 2025 08:30:38 +0200
Message-Id: <20251002063038.552399-1-kubik.bartlomiej@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix watchdog name truncation.

In function mpi3mr_start_watchdog, watchdog_work_q_name is build
snprintf(mrioc->watchdog_work_q_name,
	sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
	mrioc->id);

Signed-off-by: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 8d4ef49e04d1..5307fcdf216f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -66,6 +66,7 @@ extern atomic64_t event_counter;

 #define MPI3MR_NAME_LENGTH	64
 #define IOCNAME			"%s: "
+#define MPI3MR_WATCHDOG_NAME_LENGTH	(MPI3MR_NAME_LENGTH + 15)

 #define MPI3MR_DEFAULT_MAX_IO_SIZE	(1 * 1024 * 1024)

@@ -1261,7 +1262,7 @@ struct mpi3mr_ioc {
 	spinlock_t fwevt_lock;
 	struct list_head fwevt_list;

-	char watchdog_work_q_name[50];
+	char watchdog_work_q_name[MPI3MR_WATCHDOG_NAME_LENGTH];
 	struct workqueue_struct *watchdog_work_q;
 	struct delayed_work watchdog_work;
 	spinlock_t watchdog_lock;
--
2.39.5

