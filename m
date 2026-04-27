Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB1739023D
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 09:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777282615; cv=none; b=dGmJq3x1eLn5wJ1kA7XFuHHWcFK/oAUQZ5j5tLQ8tWqevOvOto/CXrhazY2MGGJbUHj/i6q9dWtm4pKc9/p7pdZTRpPEsMv6Hvt8fku81t2H48PFjY5g1YCZGu528O0D2s7E/8kNQrZyzxr+HTQvhIt8rGYiUxj4QmXNmX5a9BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777282615; c=relaxed/simple;
	bh=8AsHCJTrp6oTPAWoi4XYz5UZQNzkOr1rry65yDMLIek=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HNyXYpX2A/eb18cOV8jYmDQJtPocAY6+KghNYXNJE3WYhRYesmZ12SlgWs/P4zAhi6Zy0tMgzF1+tboelCNvPHjdikuhhg7eWg85CxZEQJzIOP8c6nU+4P9dy1HAsSbNM+XDK9/mfg/ow+MmA8yS6Mpyztq7gtKDuxX7tieTUTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lzUE9KhO; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lzUE9KhO"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82f8b60e485so4129830b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 02:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777282614; x=1777887414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v7/9M8ts84ru1FYHlgZaneEVjguv4ZNz/ttVD2wMfr4=;
        b=lzUE9KhOfOxACVxxuOcyG+POrjsSp9OzDu7iNUQOet2+ydqkp6i/+oBcvbCQiTH7BC
         /NH7NiwoPJ0JlKR9koa26kvTfB7PbUZgGgoZGaQmK39dwwrCFd/WM20C0/MDoUAng736
         UZdHI1G4RfR1zQamMgkTo3059mwI43M/WvCgY4dXLhoS/E4c2jVg2OPBU8c4uwmgFhHT
         ky0ovQOCsJhf1PrS/J6dqhiCQTDPF7AzbU/IJ5BtnnLJP5eqWdW3qMpV+DmOkDGtThPN
         JzNgM8mxczsaynnK4Fsw7aF3ZrfL5gVuNDkRBQbZSe1Ril1BsjWDzleNTcCWBtR/5o5c
         EmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777282614; x=1777887414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7/9M8ts84ru1FYHlgZaneEVjguv4ZNz/ttVD2wMfr4=;
        b=DeU+W96dXbVDBquLRT+0W+wTsHcVNfltXvfP8Ab/x+wXURCUo4n3wsOoV2UQ4vFbS6
         Wp5gN7IxyQ2q1uwMeQjfEUpRWh451FnVNSvKhK+XQiyISxrcdgWbvAfqsRqqao9jJX1T
         zBaaYPPySx+ccX5DQ6FenlpIjGvYVDQWMzr7iOXF/JARDVGR+oRIjglk0welGweOGDE9
         3FolGw9u5ab67iu27AyTdU8nh+MXQ2DANniLyKIMocwKVY0HHiqLxnrmHLoUagXy8ejw
         jjav/6AKQ9sKo2hfTaxk98HczdZcibuyOaAubVGiAeENcZiePH1Lc5R0LZnZSIt4IXPf
         ywKg==
X-Forwarded-Encrypted: i=1; AFNElJ/1mdxQ1/Gr1esYnRA3GPr8676Qahyu0/gronETHr/vmh+686YEXMNXws2lWwk5T8Ag+zZVWiYeFcLK@vger.kernel.org
X-Gm-Message-State: AOJu0YyfUfn2rizkqqmgWe7zjUYT12C2V25Eby/IJMD+qQCtAayvC3x0
	Y91P6lb1gWM8I5qz09vHe31xMyx1PML9whkbEBfVMfDvmGlNMmtK5j8B
X-Gm-Gg: AeBDiev2GkXLlcEjI4uMaf38tJkJtze/6fZMfZQRPWRDJgVeYk4iBPFAno5heQfxEvj
	05VBKvVPFgpiEEQ6IcG63wJUiRdynglWRunR12Uuc4T1lFjsRYUxokoQ1TW6fUnM/qRB/D6I88k
	CmRHLvPZ3HK9TFvkuSbd8wKs3fpADZqZBFFcfVC5mC8LezBJEef7fW3aut+BjBwFyJViE7MiV/+
	AqjspZr3Md57ekKjAIPC53z5+QXMUobbpamF7hPDvu/gmRm6f6qK5Go8fMahjwFCHJjLqUAjUOf
	isrzLHvYUKfEZQuVmKdnmcV+Bl3Uo6aaqw1L9gyrAVR4XTxLF0KcW6z7Weus+06/incQaEJ/jkS
	wB4/z3keYqg6C+TC1WK3nPQkfItZWlwpQcpqAkWTWc2ETJgliJ/cKszCucVLLvxO8sJLCeXiiEX
	86t5EnDL7AGkT8oPAYxZYNigUfbDoC/1eTvA==
X-Received: by 2002:a05:6a00:1bc6:b0:82f:1b1b:e166 with SMTP id d2e1a72fcca58-82f8c99159emr44806198b3a.33.1777282613662;
        Mon, 27 Apr 2026 02:36:53 -0700 (PDT)
Received: from lgs.. ([112.224.166.245])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebb3829sm33248160b3a.31.2026.04.27.02.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 02:36:53 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	James Smart <James.Smart@Emulex.Com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: scsi_transport_fc: Use put_device() on vport setup failure
Date: Mon, 27 Apr 2026 17:36:38 +0800
Message-ID: <20260427093638.328142-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fc_vport_setup() initializes the embedded device with device_initialize().
After that point, the device is managed by the driver core reference
counting rules. The initial reference should be dropped with
put_device().

The error path currently releases dev->parent and frees the fc_vport
directly. This bypasses fc_vport_dev_release(), leaving the embedded
device lifetime outside the driver core release path.

Keep the existing unwind of the transport and fc_host bookkeeping, but
drop the device reference with put_device(). The release callback will
release the parent device reference and free the fc_vport object. This
issue was found by a static analysis tool I am developing.

Fixes: a53eb5e060c0 ("[SCSI] FC Transport support for vports based on NPIV")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/scsi_transport_fc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index dce95e361daf..04b754907587 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3982,8 +3982,7 @@ fc_vport_setup(struct Scsi_Host *shost, int channel, struct device *pdev,
 	scsi_host_put(shost);			/* for fc_host->vport list */
 	fc_host->npiv_vports_inuse--;
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	put_device(dev->parent);
-	kfree(vport);
+	put_device(dev);
 
 	return error;
 }
-- 
2.43.0

