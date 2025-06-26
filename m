Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A9627713;
	Thu, 26 Jun 2025 04:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750911579; cv=none; b=XaqV4iQ0MM9g596YDuBY66IBJmaNoN9EPbp0p6nIwUUbdrYM2U6idPGeD4DHiJl3rdFQzvG2zaTmyrD8jNptgUWfK4iJ7lqb+FBjaQMTpTAItVZ70gEjalaJIXfeNoTsC1l1MAHP1ZI9em0xuZVjsTCEJD1NF/rKtylPi0nsSkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750911579; c=relaxed/simple;
	bh=Azcx5DAIRGyFizpoNj1dK8LiOxpAELO3S4L3HMgck14=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fHJ9WRfBxQsat9uCYnLBxp8At0hsYsKXi6L8UKFlrH4xkt30DsNloVR88S/WGwUrLn9OTCWpIOCIHURbj1xKj/6kgqlynM462VRkBJo3kLIAODn0WV0/Ei357li7SGqPA+mV8I20UhZf2sFLKFs4FFmjjO2UhP+DVIuKkpty730=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aYkBhSk5; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aYkBhSk5"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b34ab678931so403536a12.0;
        Wed, 25 Jun 2025 21:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750911575; x=1751516375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e7KNO401syobiGwdw9hkUtwfyUPUj/xa8j+8Zw4WnR4=;
        b=aYkBhSk5ZL28hRzvrj/5UYIJTo9rLDxtiWwvOYuJjbLmFev2tZZx61KEOQ334nfX/U
         xBaGcdTYmOV3Jf5hpxLd7I4pDt5BbnSsiXh74pHZYRUlDT0d12f0lzd1CtMUantodeL4
         C9BY/NTdxJazTlJ4ew1d2brf41ecLkS0OvmMydeiEQ/hWZSoiQrO4HXK/Ra9DTqWSg7V
         OrsPjeHrLD4uPYuRduu18zv5UnIyFMn51JYYZBBwdB8sKEWDiXZi0GADA8W0fD+UPe7H
         Q4sWpP/zPCMyuV/9s/X9fneMzdgK6xl5ua+iX7eTPQ7P+UGxCuVrphRa0bYdIFA0Blsv
         ooxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750911575; x=1751516375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e7KNO401syobiGwdw9hkUtwfyUPUj/xa8j+8Zw4WnR4=;
        b=F5mdaIKqxgM6ozMmRzO+QYvWQs9WtheWy/+lIhNL7uuz5IVD2VYCQU301rPlFE2xiv
         I+87+IuNc5YOHtP8mwW+GSQTrQGkmOlxG/4GzWYRFs7dkKXqYX85/SK/qGsp8qmOx942
         yIse5FNhWy3ZtAc0qjzyOO85wEz+DXH4vNg5/Gpod3whRc/1HIvvjCNGUX2thgsdqIQK
         tPe9ihlvz1nIPwJ6+nbmD06Zd3/Jxx9Rp9dBNXaWOpivBx2MCkvujSO6ZpftVc0Sbbw6
         S4Wh4HgmviM0mKKRJSi8oW1W1qgzkP9OhxvGlJAHL0SRgv1qzz4YIlu/7A5AkZdThI40
         9SDg==
X-Forwarded-Encrypted: i=1; AJvYcCXMUgfauvOFZs4d0OD3mzMfomBRTEZro86q2OtLPgbsCQiPQHr//7bZw+IvkoqFsnQ/qFmB2+K0+hOt@vger.kernel.org
X-Gm-Message-State: AOJu0YxNbV6K66rpP3Pu8Qiz+p/gnruFkckzTFqQVmdImfWsrl/E6PEL
	kBXxvDdDLidh8H965WOvq+tm/TbOJ00sKunJOSzCCg/xhrO14Sr+LqHI/F/3Ng==
X-Gm-Gg: ASbGncs+43nFaqVOLxV7/3KJpcZfYmJe3c2L/+puDmwD46/cwJf36yLflSdfHougsZv
	1ustXQQHOjCYHcJu88AmlJDOUTyu6JiiXNw1p/f9PWrl4joiY5TbQ4BsYC1R0UdazOF+TihQMrB
	U5LpcA1uKc127uv5HQdwJu7jwpNn9IaJu4fxNb/nNmzlHt46dijxsdvDL/riYhpyO0+a4X5Q6m0
	fGBQByOmndnMHyiU7S74HQhEJBRWBqof9UUORYLxngzoajUNIGAIkY7v46bKgzn5QkJhJB6wmFB
	hi7MBfXGKcm59m7lbqDTtSkzRAq/SugwUMl0gMYnjhZS4MAmpmPPBw1E3j3mRw==
X-Google-Smtp-Source: AGHT+IH+Q6+aooxTgLKuAMZ2jdp9wZGuurAp7EKpbOOnT2BHua7mop9YcuNJsZ+gomB/BVvZJkcXYw==
X-Received: by 2002:a17:90b:2dc2:b0:311:ea13:2e6e with SMTP id 98e67ed59e1d1-315f26b86abmr7758585a91.28.1750911575388;
        Wed, 25 Jun 2025 21:19:35 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-315edd0dfedsm1190650a91.1.2025.06.25.21.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 21:19:34 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 4C5B1420A9A6; Thu, 26 Jun 2025 11:19:31 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux SCSI <linux-scsi@vger.kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Rob Landley <rob@landley.net>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH] scsi: Format scsi_track_queue_full() return values as bullet list
Date: Thu, 26 Jun 2025 11:18:58 +0700
Message-ID: <20250626041857.44259-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1355; i=bagasdotme@gmail.com; h=from:subject; bh=Azcx5DAIRGyFizpoNj1dK8LiOxpAELO3S4L3HMgck14=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkxJxk2nqjb/eX+A5fzS9cJi1vwS2+bx+VomMORfyzpv 8vRyXd1OkpZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjARzmRGhvV83586R0lmstuI Ws66ILz7Xd1m/qITSUfm2rad2vxk01yG/0H8DqIe39jX3H/D07ulXOKEYrOR67NI8bvvV/nYHo0 QZAYA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Sphinx reports indentation warning on scsi_track_queue_full() return
values:

Documentation/driver-api/scsi:101: ./drivers/scsi/scsi.c:247: ERROR: Unexpected indentation. [docutils]

Fix the warning by making the return values listing a bullet list.

Fixes: eb44820c28bc ("[SCSI] Add Documentation and integrate into docbook build")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/scsi/scsi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 518a252eb6aa05..ca8cf50824f35d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -242,9 +242,10 @@ EXPORT_SYMBOL(scsi_change_queue_depth);
  * 		specific SCSI device to determine if and when there is a
  * 		need to adjust the queue depth on the device.
  *
- * Returns:	0 - No change needed, >0 - Adjust queue depth to this new depth,
- * 		-1 - Drop back to untagged operation using host->cmd_per_lun
- * 			as the untagged command depth
+ * Returns:	* 0 - No change needed
+ *		* >0 - Adjust queue depth to this new depth,
+ * 		* -1 - Drop back to untagged operation using host->cmd_per_lun
+ * 		  as the untagged command depth
  *
  * Lock Status:	None held on entry
  *
-- 
An old man doll... just what I always wanted! - Clara

