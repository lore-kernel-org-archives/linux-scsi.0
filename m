Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7DA36A34F
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 19:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782329371; cv=none; b=jevtvL6m5m3hXYED0d7BpkuV9jb4C21r+CDCFasnKcGU0rt/zMazSylO/2sGC9Q1Fyb+l4RVC6SXHDGIJDbld24a32xDKBZf/ymfNkIFGraVKqyiM7sAirVdbtlF5zU6dJjNyKjeLT6I+Bnsh9tiWNbu7ID33xxXQzDtGVUM5RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782329371; c=relaxed/simple;
	bh=KfobHz08dbLXCqsa2a3bsT6qpzgc/F0vU80U0F0aBDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eenMYzJdoJx7ZpIMFrD/6Xu2CNzN/DaXZqrJlFxBhHzVj51U5pBOIO7CAXSeLWGOkYchzqZoeENw2lrzdlaGxxACorFAdV27q3GMsV4lx7/sOhbzlG6W2L5RBTOiobShBOBcjTRqQUSKaUHPN9lo8Je5vn/FOMFndhu5OzVbGNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IBZEkcB0; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IBZEkcB0"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7f69b71f7b2so17598097b3.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 12:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782329368; x=1782934168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KwS5YQ3ICacnY6R0z+tOr/hE/h8NT3ik+293aPkrQJs=;
        b=IBZEkcB0lBQpnvuspLWu0c2Sq6Rllc6tvzoFGV6WMUE071eFjEbtGIGdr52UwMsn7l
         GfpivJnZL+W1YT+2k2xNstQan+4BBs1wwSFK08LDIMIAJhHweHyyjA32OcJBbtgnc3H8
         xU2UA5E7nP2DhiMwAHa7z1VvSW+Fyw8Z7hEkaY1Ow6XiUA/FQl9cEE01jrT+HFVUBkr6
         HSSWaBf1kTKQtlmyOdH3a4jbGcUd8i1RrwxtK5rGRUqlLeqRyBFPonm5S15qW+fy1mAA
         Cobq0J71Sd96vBRQfJJbD3+cxddiWtkORz1dGq+/mobdk2UYNiGXBLxBwsGXnevz7GRy
         cI0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782329368; x=1782934168;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KwS5YQ3ICacnY6R0z+tOr/hE/h8NT3ik+293aPkrQJs=;
        b=BC3ZdOQY6JiMK4qfUH+Gk5BOn1dPmRMW0LwR/GtuW3hGAi/kTTa7fDKL8IJkuULfOM
         m18L+FKPnhyCu17JcUFa/I0JAAr9X+rst9VW86cD3XCvcUjGztkdpMe2Em//+G7Saluw
         Ca9fz5dux+irQNOcK8+OM4iofwp80bG5Il1qTkw1GdS7cqm6Hlkp5MMs37bEBp1Cbxoa
         gv95Tgj78keZELhixD6hqQywk4Hh/nd7MNhZC/qvsbB68Ynn05f5n1s5BrouIIbgcELJ
         Vzz7h52aHBVhS8a16J5WbSzzx9wruqilT847MgC3KwR1wujLEUMzdsqTvBQPRh4L5YOZ
         sERQ==
X-Gm-Message-State: AOJu0Yxz2N9C39G9XLX8SWDTlfl+9OJWeiBZy/l9qZ+Bfm8qgWPY4TTB
	JbT+kYnDNMLGeIPg3nW/eeFmYXstPAtGvqUeYZ0fKxjo4TBkiTjVorQr
X-Gm-Gg: AfdE7cl/w/SV/OpCLoQApR4eMV2s9ArsdQmZ5BQ/PFwFMeQ27RLhB8kBf5sqpD3EWT+
	qevstplDBEjzKzVG91lpINh0jaBAo7cuIdEI5TWIMDEdMNkHmZ0fKdb8ZbsqbVS+roLkLrEGJnQ
	PTueHN4Hd1TNLOqF97fdvlBsA8Ki1Nl0upJWEv8NDExEDue6vaWOIHKs0dgdjw+glIFj/3j++k0
	aZ+8KAwZ6fMje0x1RH3/dVDtiit90RFPZnUH0PSm9VzGIxK819yR4UPHgcCQvLl36Mn3mJnktTi
	seLJFUy0zyk7ZTExqXRb9RXh5Yi2mJBgvCpTMRGB+ruQV/x9Fu6zJUZqAlCRHRzvwgm6/zwnsZs
	aXTCcnagTzCzFYtQe8dnttjMlgs/eN40QIWXCdVDdXlyfse/Pj04BLQDmhPQ8APkERBtjVD1RzA
	1nvEbCWmCinfJf/lQg0L1rvRjTKPuzeZnuBo9k
X-Received: by 2002:a05:690c:b90:b0:7cf:f7be:f4fc with SMTP id 00721157ae682-807ecaf19edmr51975807b3.3.1782329368408;
        Wed, 24 Jun 2026 12:29:28 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8025ce65f85sm62493367b3.12.2026.06.24.12.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 12:29:28 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Adam Radford <aradford@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH] scsi: 3w-9xxx: validate ioctl data buffer sizes
Date: Wed, 24 Jun 2026 21:28:39 +0200
Message-ID: <20260624192839.5631-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several 3w-9xxx character ioctls read or write fixed-size structures in
the ioctl data buffer, but allocation is based only on the user supplied
buffer_length. A short buffer can make event, compatibility, or lock
commands access beyond the allocated coherent ioctl buffer.

Require the data buffer to be large enough for the fixed payload used by
each local ioctl before allocating and copying the full request.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
 drivers/scsi/3w-9xxx.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 9b93a2440..a125801e3 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -653,6 +653,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	ktime_t current_time;
 	TW_Device_Extension *tw_dev = twa_device_extension_list[iminor(inode)];
 	int retval = TW_IOCTL_ERROR_OS_EFAULT;
+	unsigned int min_data_length = 0;
 	void __user *argp = (void __user *)arg;
 
 	mutex_lock(&twa_chrdev_mutex);
@@ -673,6 +674,26 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 		goto out2;
 	}
 
+	switch (cmd) {
+	case TW_IOCTL_GET_COMPATIBILITY_INFO:
+		min_data_length = sizeof(TW_Compatibility_Info);
+		break;
+	case TW_IOCTL_GET_LAST_EVENT:
+	case TW_IOCTL_GET_FIRST_EVENT:
+	case TW_IOCTL_GET_NEXT_EVENT:
+	case TW_IOCTL_GET_PREVIOUS_EVENT:
+		min_data_length = sizeof(TW_Event);
+		break;
+	case TW_IOCTL_GET_LOCK:
+		min_data_length = sizeof(TW_Lock);
+		break;
+	}
+
+	if (driver_command.buffer_length < min_data_length) {
+		retval = TW_IOCTL_ERROR_OS_EINVAL;
+		goto out2;
+	}
+
 	/* Hardware can only do multiple of 512 byte transfers */
 	data_buffer_length_adjusted = (driver_command.buffer_length + 511) & ~511;
 
@@ -2302,4 +2323,3 @@ static void __exit twa_exit(void)
 
 module_init(twa_init);
 module_exit(twa_exit);
-
-- 
2.54.0

