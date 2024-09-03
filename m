Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03B418B46F;
	Tue,  3 Sep 2024 18:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725389664; cv=none; b=dW0rbw0QUdKATJqkFhAVPPWQEw+V+KBgTA7/6LyrbZBknYdwQdzx/Ygxs/+XQqiKgE8Zr+42AXYwV4/ju9w8NsQvXqhGSzX06b6qYtHQg8vAYYeEjYUvzle+N/MOKA/W/qsSe5Bgx3M2HqQXoBSW/aReJEw91djQk7DpSxaI0Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725389664; c=relaxed/simple;
	bh=ZSIKP8T6oTjHe1+A8t78p5Km5ZD3WdsW+W79EHwNphs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aJNVTFUnu+nvRgUqvhj/ZLAm37qH1QT9t3/CPHw1rXlNJlwRgFjPq2CIcAXldSyWACEUAzmv1jwo+LwqnklIrIkvMnNjl4wNu3VDvJk4Ds9zNp4f5nX92Ut5UruOAxU58+UUYPbwdLcml8XuEsZ1iFhRsu5ElUJ+bVWbVct7H5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aiUzVGPt; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aiUzVGPt"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7cd8d2731d1so3700140a12.3;
        Tue, 03 Sep 2024 11:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725389663; x=1725994463; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O2DzlqGgPdsSqrdHdEWfIeC+47Crs8VQxJBVB6/aP1s=;
        b=aiUzVGPtSHlLMAX5jBcju2PU0QiaUBdGvWx/XcZgbPO4fs8Bbxc5kjcucL4KTC/PqT
         Atmz+K7VmsUWgxPi2mPo6Yt6nit3GwmYpbzKjzQB45dvHu+gU1697MpJjQhCnyt/Ie/l
         NvVML+74iD4QJW0zycRSv8kfNppc1aHJzm6JPQeapKlDZYUgyfvmez75mfMaC6AY6occ
         JjJMKWQOHegwzAjk4jEpNSW7nGgjXmojrgQ2RigFnF65EIZXt2n0GyIU5pd3xA0TxsQt
         YmeQ9X0+9rKkwxRpSTO8CW9dGQp2+TmN/mlP/Jelf7inDb6xPGx9Ryb+j3/8H87KitU+
         /AyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725389663; x=1725994463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O2DzlqGgPdsSqrdHdEWfIeC+47Crs8VQxJBVB6/aP1s=;
        b=qxdpb70jV0yxCaXa8LFSCipKyHpyXvFGpy/SkWRHB/0+yTp2JXZDowvfj5ysF4hLkq
         YV6tP4xf4Iga7YhETzYr3SwKPLTZP39uFLpbx/bNLTBoPlNuQ7GXW91nIGpJkVuKXKsQ
         SIA2CDoAjsRlAzfKECpfEl6uVBZSKXuXXu9/p/jz8gZ8aL9QXRxUxNBYHpk9DdnqunpT
         cPMQs3NEo6BmJzGwXSPnogZ3a4wpkmn1y/TzTv9NPd14UprPhmZEiwxMMVmylEtzaNZy
         MffIk++40coztqAnNscouGmJ6ZAN4BanYQGolnRwfveIyC4Pmk3Hvb6TJjTNfWSWU361
         DEYA==
X-Forwarded-Encrypted: i=1; AJvYcCWIm4wYvnMK3GZmtMDlGhGmqCgv/6SNr3D7sHfjIAUAxm2oRdf5bY5vL4SEGpH3i9OPplWcvZrrTxGdQxM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyENdlT6szlTb+m0KrqPka4V0xIG4vBwy6Bd26CVYTFIICrf/CY
	dOhd1uOaoIntWGStTRu2qdgUfBIBBJNx+84vVGR04woeTwM9p6xCy3Pj7JjbW7c=
X-Google-Smtp-Source: AGHT+IGzKXJurrgR3CSk4wcesK3azeP2MWGDgRWCB6mYCLJ1MBbSFO19SW8xX3L5nzUfcMII5Xtt8g==
X-Received: by 2002:a05:6a21:e8c:b0:1c0:eba5:e192 with SMTP id adf61e73a8af0-1cece520bf7mr11418242637.27.1725389662630;
        Tue, 03 Sep 2024 11:54:22 -0700 (PDT)
Received: from fedora.. ([106.219.162.224])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71778533256sm204637b3a.50.2024.09.03.11.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 11:54:22 -0700 (PDT)
From: Riyan Dhiman <riyandhiman14@gmail.com>
To: aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Riyan Dhiman <riyandhiman14@gmail.com>
Subject: [PATCH] scsi: aacraid: Fix memory leak in open_getadapter_fib function
Date: Wed,  4 Sep 2024 00:24:10 +0530
Message-ID: <20240903185410.21144-1-riyandhiman14@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the open_getadapter_fib() function, memory allocated for the fibctx structure
was not freed when copy_to_user() failed. This can lead to memory leaks as the 
allocated memory remains unreferenced and cannot be reclaimed.

This patch ensures that the allocated memory for fibctx is properly
freed if copy_to_user() fails, thereby preventing potential memory leaks.

Changes:
- Added kfree(fibctx); to release memory when copy_to_user() fails.

Signed-off-by: Riyan Dhiman <riyandhiman14@gmail.com>
---
 drivers/scsi/aacraid/commctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index e7cc927ed952..80838c84b444 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -220,6 +220,7 @@ static int open_getadapter_fib(struct aac_dev * dev, void __user *arg)
 		if (copy_to_user(arg, &fibctx->unique,
 						sizeof(fibctx->unique))) {
 			status = -EFAULT;
+			kfree(fibctx);
 		} else {
 			status = 0;
 		}
-- 
2.46.0

