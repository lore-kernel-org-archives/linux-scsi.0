Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2487F224FA
	for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2026 05:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768714279; cv=none; b=dYsM7TnN3ks8pWVnu1/QFEF5SCrut/0mcjV6o5t4/1QvBI9gJiDU0NzDpKkimNkw6x60H9DhkUWR27jVrLOE7G4NWWyGYAWDly4kp0b1U8eYQGkRuIhWN9T490VXXm70nSG2x+/TpEyem5yAFUtfj6chGeG8wIAOAlOXg81oJVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768714279; c=relaxed/simple;
	bh=fkhXpp5OCKlj1yuiIdnEYADmB1Ali1BEyuc42nHc1s4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rCR9B9rXUIdc52QzyvVYvH8xkCuB1w9Fwlkvxeqfyw/LO/eZYL5GrQYkcLbaZxdPzQZPoXYsOFOu18gp9aQOHlAB+SvKX66uvBmoYce0r9vl0rUWAwOp83h/8rpJe2LHLr6GnIknB+njyPW+5WQKJHJO7PepEFbXr0JekuAoBpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HJhKUetv; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HJhKUetv"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-432c0b8f114so360815f8f.0
        for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 21:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768714276; x=1769319076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BOpOj9KW01OdX7LlAL2wctL3KjfB8CTK3nQNmhrSkw0=;
        b=HJhKUetvIwxOhrqDx9jhyUqxtSLkQyjSfHd/0b/8B+YkCeUymBLgD6UIeml2iZ5MIK
         04dCjtZCGv2hkVEK7d4YFnBCd1LcWyaBTpijEqc98/cuvzNUVb2OZYNiscqqZ+Ft9ng+
         tvthF6VvdOPa0XWRQ+2F20yHigqsqNO54VTn18J4v7ubweAJOHAWxmckMXoeec7V++Ha
         +dJxoKXrY+H2WThuVCS7qBSwbPmzQ3ClK2q1Jkher4K6sMdZlWQZdIrU+ClzhX8ESZlu
         NB2k9XeHYmcldfPZmGIL1W7ojeJJbHEhDTTEWZcN6u2ko1Yb4RTXJAgj7ur69lHI3Kww
         6+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768714276; x=1769319076;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BOpOj9KW01OdX7LlAL2wctL3KjfB8CTK3nQNmhrSkw0=;
        b=fQWiABh0VJQYAoGfckArJlqtsFCvzmd98y73v2Ao70nt/GUCMiUvrkkyOLr6pkdU8f
         uvCzWmRviWwlLJGQOZwF8eYp8bUHg2blftYWSt0XECP+0IzItL3/hz8CjdBZhja+DdD8
         r80mYVTvID0yfb58QLcCOCjgSV5hJCkhFM5TcWhisfoxC3KwbzwJlaLxA0LCa0tzDcQ2
         DADEzMqKM/5cXwspKPiz6WrVsNrJjVdkc6pYDmRFu4aqnFScwQOqIawWG+6clwrwR9+O
         ypfx2MQ1TFRVrXNr0Kqlhb+KnjD4dntzTGWPSKb72iVWXwKSl2OIcE3CC8EftnGceHF0
         kUnA==
X-Forwarded-Encrypted: i=1; AJvYcCU8ya1z1nHyUiCF5G7Z37dsL7VNG6pb4eq8SgQ5in8jCJJMmDMTGp2iEV0dl70RP4KfO5dO4/Y8Ms+p@vger.kernel.org
X-Gm-Message-State: AOJu0YxkakZuS0+A6DR6T8CPQ4gLZjX6jPardOdbz+F2M28kEbKT98kA
	2d2my3f8zxTNo8rcIFILTgHVyiV1anWvtr+yOdDJ1BeNjIozZ1ztMXQx
X-Gm-Gg: AY/fxX65Ghnc5ecNkZMkmwtkr2UmG0EeZ6izB5/qbPddR95iGtr/BM9rj5I4xGD4bZg
	NgOEch+WEVZZkbCiESGUB3jlHhuq3dUZ9kDCunAvJTsTAMBkTQ9I5woZSBUw6wZQRibNLSN8arV
	+43gpO6HHmbJNhOZEQZg7CaBsiYMcQKUI1rAdf6ZPnsTgKtoSaXZlpw8ifl74Y1WI/V616ArCX2
	4weE0JMganU5T55l6vMYOEL2oVVm+755u5S/ccB3s+ff7V30sPrBUOnbtVpM0A78C7MjLXkv98R
	NOA6LVtk72tC6CL8GHGaNqhT1kkPyiD0lvPHVVD/Ox1VnFDM6jrsB6mYOI+CdACuSJEccI1sDK1
	DG5JLH0+XC35jENgMNDl1FPbxNdCuMBplWWEFrbUW8pObm/+A1Qqo8qoaKCVaQ67cAC0cLiTSxS
	6ewTTAtgHEhdxHlwCfQyUQVfLjaPm4YGzLfB/GBp8bEl+b8uUPTyVU9lNydeQ=
X-Received: by 2002:a5d:5f83:0:b0:431:32f:3153 with SMTP id ffacd0b85a97d-43569bdb2d5mr5478370f8f.7.1768714276213;
        Sat, 17 Jan 2026 21:31:16 -0800 (PST)
Received: from 3ce1e5d2d1b2.cse.ust.hk (191host009.mobilenet.cse.ust.hk. [143.89.191.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356999824csm14904136f8f.39.2026.01.17.21.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 21:31:15 -0800 (PST)
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
Subject: [PATCH] scsi: mpt3sas: Fix use-after-free race in event log access
Date: Sun, 18 Jan 2026 05:30:50 +0000
Message-Id: <20260118053050.313222-1-dg573847474@gmail.com>
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

Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 7092d0debef3..3086e27a6293 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11264,7 +11264,10 @@ static void scsih_remove(struct pci_dev *pdev)
 	if (_scsih_get_shost_and_ioc(pdev, &shost, &ioc))
 		return;
 
+	/* Set remove_host flag under pci_access_mutex to synchronize with ioctl path */
+	mutex_lock(&ioc->pci_access_mutex);
 	ioc->remove_host = 1;
+	mutex_unlock(&ioc->pci_access_mutex);
 
 	if (!pci_device_is_present(pdev)) {
 		mpt3sas_base_pause_mq_polling(ioc);
-- 
2.25.1

