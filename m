Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DAD225785
	for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2026 07:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768719794; cv=none; b=ka84cEs4yeua3WLPea35KPtrwbopyqbUt01bnL3el3NnPbBVDIEsV7GYAyjRKjYlrfEE7AlI5QUm8HMeOkd7Po/X/3P1JSaiXOBkq4b5OJMNWK6/YRYUafk9YV8QHCd12kTEjDkpQE9wNcJcFPRkAvUv5NrGJkvLuAGPboLb4+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768719794; c=relaxed/simple;
	bh=CJ20BdSc3shk+8PeBJbNxX2xUlMTHoO04lnwXOyirwg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rApmserRmHfNOkZgLOMHPpua9bDXG9HkMf93o0R5iiM7XgDEr15bjblFgkjyJALIyqo7CXWizcCyVemWmVL/t6tkgZcrkOPvYyBFM1t/dOct9l/Kow8KKwQmrJGmqRyh9WirI59r3udJsI/oMTztawKJECLmqva29U8/nXSohMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U0r8H+b3; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U0r8H+b3"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42fbb061a08so434645f8f.2
        for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 23:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768719792; x=1769324592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3hBz9XaEMOL/y+MvlCbl4u+hBnfx10ydis7U4oQtDmY=;
        b=U0r8H+b3YtUDda+mZyAyY7p1GEPOfcrd15fZ83fXvTcymRX8I4x6+8193HVGXwrKiX
         pgXSRMW3TnD7snrTLTKXwiT/cWvrCA5cvN6yxFRoP2wa5zWEtgcX3DnL+9T7PX8RMW1F
         +iX/wKjPdlS+6+B4OYqpuSURR6q+KqSU/svC42UEQxwOFfvD2baIfe0yJhFi4yz1ZV6e
         XpfIDWTJO27ZytyqzK1XpC9fpIXfqW6rPMimA7OCfSMHFK6E6Ak6EWfVU4DxyMvL+a2y
         rQ2MlfZ3AMwrB4WNZmYxTJn4mviJ/ZvfaapQLPJmNBltqjjZ+ZsPmTcK+zBaaV9nkFrq
         rSxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768719792; x=1769324592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3hBz9XaEMOL/y+MvlCbl4u+hBnfx10ydis7U4oQtDmY=;
        b=ig5pnXj1WsMkNrU0DE/LusTyyE2LYI5MJamcTrwajPW3bjcp8PDCIDJ3/GYB6u9C4R
         NMW0ZO2t9LTraL6SxsVTW4nk/54FvjwbC6pKjSzipyIEDkjO0BFHNZogPOq3t1Pb5pdu
         2HNGl7dRBGEyu+1IhrCaQCqYrjdhvVJm1oY3QqAtooTq4EV3FtSluc/BGLX7DfhbK2SU
         wtcpyAZPlfwEmNSiH/mylBD7nh/XIruQXNvuO2Z6NSNahNUVk/gXyfGt5ZcTWN7QRPWX
         LsP66hUZXV5luiGBCDFu0InxREXhfz0F6hHOMrUJcXQ4HahI9smwrUwcJ34rkGU5KgJC
         0wWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYtHXZDaT8nP67V5dmXZyzwBpxmlTLiYs5Z6H38V1YqPQCw057QkaYm+hAqxYCQgd8vOtpORMBzKFU@vger.kernel.org
X-Gm-Message-State: AOJu0YzP4K1c5vA7/+ygWugXZfQ0CeX+VbUxOoguXwrgcwK3t4rqqoTc
	RMgYvo6DQSpQxvk3sfKD/TfWxxtwVA0rbK6POzG37l2ihjWMO8DdM+2c
X-Gm-Gg: AY/fxX6Xa7KKziYObrfge74y1Z5eycEqaHJqrV7d9ooaMbyyboYbY7abgo6JDh8jogH
	4D4jb2R2LWeu6Tv9F621pQq/h7mW9bh91F/bb+pLEYvH380AMXCg1bW0Is8LaGcG3/z2A8YG91m
	y71nPHjhZSfDTFE8LSB9caNqw8z0ahVwm8RkfF4llWD9tRbSMccpNujoB40C73DME5eE1nBrbpw
	0xkeqqk9j4XHKqeQyOgFkjLLu9DA8gJWDnH/H4T+gqDS7Be3OCbnkawe1gyE2sdtYswLFdxaOBR
	r2H7hC4m4JP3U4obvNJ7OezCYbJnvcKSn2sTK5+dQhKDjqqiDmZIZ6Tx/QakoG3VCJP24yfnUAR
	QRaKUHtNQ507zxHjdan7+Jtz9MgGi0cRCQkpCsLCPu6r5IdL3zdEgS0h6+499W183OP3Q1vrl8c
	yPrRFoS96niN8CN7XSaP27YdvSKOYGxWF0Wx3dpRIDr9Dsiu4xrLehdV4ByfA=
X-Received: by 2002:a05:600c:3594:b0:47e:e20e:bbbc with SMTP id 5b1f17b1804b1-4801e2f2845mr68388275e9.1.1768719791404;
        Sat, 17 Jan 2026 23:03:11 -0800 (PST)
Received: from 3ce1e5d2d1b2.cse.ust.hk (191host009.mobilenet.cse.ust.hk. [143.89.191.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4802dc90068sm44687605e9.7.2026.01.17.23.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 23:03:10 -0800 (PST)
From: Chengfeng Ye <dg573847474@gmail.com>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <dg573847474@gmail.com>
Subject: [PATCH v2] scsi: mpt3sas: Fix use-after-free race in event log access
Date: Sun, 18 Jan 2026 07:02:56 +0000
Message-Id: <20260118070256.321184-1-dg573847474@gmail.com>
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
---
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

