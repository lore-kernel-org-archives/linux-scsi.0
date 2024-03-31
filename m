Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B195576F1D
	for <linux-scsi@vger.kernel.org>; Sun, 31 Mar 2024 10:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711882198; cv=none; b=BwAcDnJfAgTCJe5fctpqo4WnRExpHHgA013JfQ1EC62Eq2s9W1wiZCTYXQqXTQuziiQ4PzBbch0DptuOpszP0HQuU+fNsAhXevpYtdYg1gvtyrBGHB5HJxlW/KM6ZL/hZ7SZdk1+I9bf/jB45OQmIc/480bFwjWNN7rIfbh2+6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711882198; c=relaxed/simple;
	bh=s8qh6r/pzemiCLbKY9ZlBxc+DVDuUMQSEKZ8dRmhfO8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tGBbYMcOfoXylDgqqhMX1P0S+PKjDZM/fDpCMjeghMRFPgAj9/SoT7J1jW2xNGPbXxj2hnZYZvLwuJeo7hZ8BVrwTa3JGpPhSNsdLL8O71FEJ/H3AoRASKl5mMy8frNLvr6V+LM1f2uwNepqJKXvhUYd6kc/O3sjmjuqtX8fVUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UAr7dtIB; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UAr7dtIB"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5a128e202b6so1016186eaf.2
        for <linux-scsi@vger.kernel.org>; Sun, 31 Mar 2024 03:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711882195; x=1712486995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RqISQ1t3uIuM7wLvcbfmljmQ93+8MvKa1gWDvY1NDKM=;
        b=UAr7dtIBVgtIWhVoihhbEZo0dt10TRAx0GxgkjbL5byo0DXDmCGFbc8hc8KlVA55VP
         IY91mSax8JHlJqXMt92EAo1jFzYbcdSV0mC4QhqXEQqMccnEdQbYu98l6ToHJbA9qzL2
         E70RUnFVv8PRPlUdIjaBTRNytIiG+5tMHuuZVvNaAl7Hst6CvDZziD3cCDL+ul9DiXDh
         4OsjG8ko+L/lt7jTjO69pHAJDOd36gwri2CxgfFlI3KL1Kgt73hJHU1xwDC8LpUTFH1t
         B5qmNb6JNuRmk4ZAP95AGsNdKXqNsQGvJ/HsRNSqIKelOm0CvDNEqBz4WteV6usxRnRk
         Aztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711882195; x=1712486995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RqISQ1t3uIuM7wLvcbfmljmQ93+8MvKa1gWDvY1NDKM=;
        b=cbf47pnAP30wroTYzo7GeJXQRz11Eorg2LWmiWX3aHyyQKJN/ATDsCCWKuCS7JpFj2
         Rxp29GBlDeMQswsEl529RnJsmNQnCZ3z2X9kH/v4rZK4ksV9PiqXC4mav4LyzRGut5Ii
         g676go5ZuDmIdh4pXOv5LVefaBu5gRI0Bz+i6HE2pNEwkFAPDX70ojabj+KmpTPqFGz4
         0id6itVZmHlJqcdK5EeLi17MwYIlRJwrEZblHCLBohOCWA2o8L+n9w538WRk087DyGQh
         UC4FrudusfUtjxM1+euVCnsbVkRxmC4tuXIOm5xCIKCY2K7sywwI3W8XjrDXG72hcW9E
         cJrg==
X-Gm-Message-State: AOJu0Yy4A3kXdFF/EK4NjxWP7K8iRMFnDltBqhD2BjlfKAnSzwoB8HZK
	3XzL9tP5bZ731N84gIj1lqJmJtou72v75W/S7AsYkiMJEiT9sj1g
X-Google-Smtp-Source: AGHT+IGUENbW8DaB3RkYVbnpt0weG/5dYSvjUa+k7C4RzdaqTFSZCUohzt3IIfGyqyKYgK+ZYkkhYg==
X-Received: by 2002:a05:6359:4ca8:b0:17f:565c:8db2 with SMTP id kk40-20020a0563594ca800b0017f565c8db2mr9703149rwc.12.1711882195460;
        Sun, 31 Mar 2024 03:49:55 -0700 (PDT)
Received: from FLYINGPENG-MB0.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id u6-20020aa78386000000b006e6a16acf85sm5903616pfm.87.2024.03.31.03.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 03:49:54 -0700 (PDT)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: jejb@linux.ibm.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH]  scsi/csiostor : Correctly obtain the size of the data structure
Date: Sun, 31 Mar 2024 18:49:45 +0800
Message-Id: <20240331104945.92084-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

The variable 'mbp' is a pointer. From the implementation of 
csio_enqueue_evt, it is necessary to copy the size of the data
structure pointed to by 'mbp'.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 drivers/scsi/csiostor/csio_mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_mb.c b/drivers/scsi/csiostor/csio_mb.c
index 94810b19e747..4df8a4df4408 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -1551,7 +1551,7 @@ csio_mb_isr_handler(struct csio_hw *hw)
 		 * Enqueue event to EventQ. Events processing happens
 		 * in Event worker thread context
 		 */
-		if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(mbp)))
+		if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(*mbp)))
 			CSIO_INC_STATS(hw, n_evt_drop);
 
 		return 0;
-- 
2.31.1

