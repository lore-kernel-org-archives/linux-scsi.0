Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A7B230BCC
	for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2026 08:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768725760; cv=none; b=knTgWpfzIDknCkvvneOPHpwCE+rJ94cMt+u3LJ11LVpYHgIC+xv9iTO5ZWoWTtnGVy3j6SAKtm4o6BMozs19u6PTo645+GRyLrm8kL9Qpt95p5NgqqLaBc7a/EGmmIaIEgqHb9Mj+sutlbjvdIVif43oimEgYjSLWEih2sg1mi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768725760; c=relaxed/simple;
	bh=9aUbMduAp6P1yv9Ry2zEqcm6Hw+tz0d8LWhPXPVZNYE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FZg51PBRlACtF/tw7YylPYbQm/HyJyC6wWTC5laQBj8dlp3tQ+j0SRNY/hIJaaaUvc9bXKpo9s4KasCaJuvgjwlDwUvfv+XHLT2im6QE8xKj/eOCngSKSvSdhwpDEQ0NTRvd8Bg2pwt5SDeTVLiKEi8VKQPug9BnIhOE8n8wqiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YQ+b9zKk; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQ+b9zKk"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-432dee2b55fso227827f8f.1
        for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2026 00:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768725757; x=1769330557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VKAk41QcC3JcYF9Ksias9WJVIfTmP0yOEq+ND2zxmCE=;
        b=YQ+b9zKkueRbwYqZLXJoSFZXnlkV9QN9si2ks1TAO6qBrkGBkJhATN4XUvTopAHrZv
         asb82Qwjp9nQG/f+vms5dgbTmFk/LrY66JirfW5n0pWinam6Z66RRelCjPf7rVmlmueO
         GNYWEzYpcyzctb/9XgXbxEbRE3EOFlyEtzMyPYkRfbzPBKouv06YDrRdtemYXQ2RW3pa
         +EHUTFk97Wf2+5MwVPu3nHYGXdxJ3qTeDPuwarsaiOg9kbUgSjeoS9wu9qONkn8ArY42
         EjJB7yWCpWy8ZCIRkIBa/o0IjF6Vj/UZdap79NKTStVJCZ3nw0pqma90shKabjhamT3T
         sJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768725757; x=1769330557;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VKAk41QcC3JcYF9Ksias9WJVIfTmP0yOEq+ND2zxmCE=;
        b=PlcLhxAmYpVojGKSBjWSjNoS3okPTFlAwN+M4bIxwnUzE7le0e7pZ3uoMtPKhnc6qw
         Cc930SjXQj7ngRY1P0cMri9mYgUK9DjgENjhJcRfxAgCPqBV9sEkpXx7/ZoT720DK7g/
         MsEJI0GTy1JQl6GL5xSUAk0RTCV/nLBOVfUWH0t0nli232FmOUJW27Nk33p8pKudiXL1
         oysT/dSJklT08QVXnhF2dfVecnGvmLgfQoTeR3T42Wpp5bNtutmdIEiC31C4kMhfJ4R0
         DsjV8tRmUqyPBPg25NwH9C158nr32fGjhPfDXrG1RKLgcwnbZodhcOXYESFrsDWLIs8l
         Eo3g==
X-Forwarded-Encrypted: i=1; AJvYcCVT8jLV2676YXT0crItTAn48E0qEGckmX2uhvBWVs9wUibcbgo12YRFMyo+/cDHz/549MBX0NPAPVn7@vger.kernel.org
X-Gm-Message-State: AOJu0YyOhyBbHPr6rbMHWDj3DhZeL/IgAQ5uPXO0cRUI8qJ2NvtI7HKH
	PJFQhv64wqU6IWuFDl/6RJobJm30enqTgQ74pTY+ZPJOlk+XK9PFci6N
X-Gm-Gg: AY/fxX6hLVnLp5x7xjKP8t/NRiB+EESHc8a7Weprs70vxrHdVXkEsv6yhf91h/BazJI
	7BLQUelpPsUSPEKvHPG8jdRBFzwW3xH/fDqrJehB7wAXB5aTgSRvWng0l34vRG1MOxw5I80sg4p
	3TkWvtgdXsGhG5dAYgkdbVFLaYAJbCX3M+mJgcBtfohU6rSGMZMOrYQWIsrGxR1crhtFQtnsQYa
	icAcZWrD48VUibeVYUCAKwMrePSlVYlEyLSDkm9o4yJsM8VxpU5Dv958HjZL3AaPIbRoSFFdzSm
	ZAKz3LeY19Rhsdk4R2y5jKP/fpRv7+Nbqs+ikOw1tg04CEemKcNh/rHiZsEj3ZlfAC3vifETDFK
	d8dMNaReDwG33x3ehuNkCgPE8QC3wjMp0mHzwphRCB/ff1vl3/bkdQj1+B1MuSEC1p1SP/bfaZN
	XSpmEarTC8iCxr1Ro5tNCnYG6d8yNB2UU7Wl8G08tWtx+BwE0VDaf2jImz5tj8Jm+t5VYR4g==
X-Received: by 2002:a05:600c:6489:b0:46f:ab96:58e9 with SMTP id 5b1f17b1804b1-4801e2a21femr53469855e9.0.1768725757048;
        Sun, 18 Jan 2026 00:42:37 -0800 (PST)
Received: from 3ce1e5d2d1b2.cse.ust.hk (191host009.mobilenet.cse.ust.hk. [143.89.191.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356992201csm16245897f8f.2.2026.01.18.00.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 00:42:36 -0800 (PST)
From: Chengfeng Ye <dg573847474@gmail.com>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	Markus.Elfring@web.de
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <dg573847474@gmail.com>,
	Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH v2 RESEND] scsi: mpt3sas: Fix use-after-free race in event log access
Date: Sun, 18 Jan 2026 08:41:35 +0000
Message-Id: <20260118084135.321976-1-dg573847474@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A use-after-free race exists between ioctl operations accessing the
event log and device removal freeing it. The race occurs because
ioc->remove_host flag is set without synchronization, creating
a window where an ioctl can pass the removal check but still access
freed memory.

Race scenario:

  CPU0 (ioctl)                       CPU1 (device removal)
  ----------------                   ---------------------
  _ctl_ioctl_main()
    mutex_lock(&pci_access_mutex)
    if (!ioc->remove_host)
      [check passes]
                                     scsih_remove()
                                       ioc->remove_host = 1
                                       mpt3sas_ctl_release()
                                         kfree(ioc->event_log)

    _ctl_eventreport()
      copy_to_user(..., ioc->event_log, ...)  <- use-after-free
  mutex_unlock(&pci_access_mutex)

Fix by setting ioc->remove_host while holding pci_access_mutex. This
ensures the ioctl path either completes before removal starts, or sees
the flag and returns -EAGAIN.

Fixes: 6a965ee1892a ("scsi: mpt3sas: Suppress a warning in debug kernel")
Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
CC: Markus Elfring <Markus.Elfring@web.de>
CC: Sathya Prakash <sathya.prakash@broadcom.com>
CC: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
CC: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
CC: Martin K. Petersen <martin.petersen@oracle.com>
CC: Tomas Henzl <thenzl@redhat.com>
---
V1 -> V2: Use scoped_guard instead of lock/unlock pair

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 7092d0debef3..973893528747 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11264,7 +11264,10 @@ static void scsih_remove(struct pci_dev *pdev)
 	if (_scsih_get_shost_and_ioc(pdev, &shost, &ioc))
 		return;
 
-	ioc->remove_host = 1;
+	/* Set remove_host flag under pci_access_mutex to synchronize with ioctl path */
+	scoped_guard(mutex, &ioc->pci_access_mutex) {
+		ioc->remove_host = 1;
+	}
 
 	if (!pci_device_is_present(pdev)) {
 		mpt3sas_base_pause_mq_polling(ioc);
-- 
2.25.1

