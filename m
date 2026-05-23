Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47A116132A
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 22:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779573910; cv=none; b=Z+b11U3IyVxizXDcbISJw+1/6FETdT9hPW2PSPq3BF53c/ZSlg86efEYLwfVpofGd5zaN8X9DVpgf5GMrrWzF03xbgknCL8t94fyy/vaNazz6Lp2JN8cwc56dzyfkxaHp6Nneka6cRWwxDNtiw7nnoiAPIDRP3hpg23RAWemtAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779573910; c=relaxed/simple;
	bh=nqXrPshNv7qlUklPTHk3IHHY+HT4W2RHmvPaOwZ0p+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CiJXqZ8Edm9aArs1Nip+DWg7VdLIb+Z95YjHFdNgUu2dNfRgpcijLshUXKVsQ9RSuyPPQbJ+YpjSK/aSQbXZuBPgN15rLdhblZDWXm9cTERYQcHxNPoGFAeLZJB3XuzBj+QTfr/0d8qZ7IWBX5C8w2T8F3fb8HPGkRqu6CIQOVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XE6xDsxO; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XE6xDsxO"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49048a8ca1bso1102635e9.1
        for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 15:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779573907; x=1780178707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dTIRT3uGIMJZM8E3LVRRCiObVIyPeDLGuwvDsuYMwxw=;
        b=XE6xDsxOlq8su+2N7j0I/d3TnKYhSMkIVkbE0P/gYCVKB5WLJSHiGqQNwnDXuraleD
         H+WAhfEFHgcCQewFqkPU0TnvO8IAVItagC3d9y98lX1TIEG88H19X/R3SA/yd4WtyPTg
         Uo1A0m/gUr/fG/JxaRS2KXdan5M1JS0TIUtQKp9u3Pd0zXztUfCfGeUAAJ+ANwWtAklJ
         1EzNdaqpkH3OAn9R6Kmxu/HS8xxanbCAUxQofJok2UMEo4RZPrZqg1jPksw9EdnHtBRQ
         J1VIi2HSz6r/Xb1A0ewDLUkO7sJipX990JknrIeBPePhvhgUFZ3NzGjyvKpmfz/4NYEw
         k2TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779573907; x=1780178707;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTIRT3uGIMJZM8E3LVRRCiObVIyPeDLGuwvDsuYMwxw=;
        b=jzoDd04umvsQX+mdcVzvxgiT3t3tvZQL0J+oBSofbKw0UGiKWukDfcV2oNBStmbcFm
         rPljtOnheh7o4PFLhLXC3ViOvN9nZyiP2NEVicjfZcOwGaqLLydcqDdziM5xLR13q5B4
         sbtbJzuqST5JnA2a+BIxJBvnZT1/2GHB4zZw12LwK63Ul9UCjnT96r/P1eEky1lIu7fF
         PCi0AdSwVI+pf4KevzWH/vaL7xW0qtDPWoMLrSLw5Znl9emIX5FWoCzkPmiFVEH/MHSK
         9vQRn7eS6djLlbbWn/YbKN1lTZtK4m7GXb6ZgMY2B+K2riHBj374WKEqsw6mHpaR1aHF
         AYag==
X-Forwarded-Encrypted: i=1; AFNElJ9p37t0OvuXvAgzXA1zv+uxPnm3fsrWGA6tnM64t1FJTPiJ3LwQ3ssfF221iSMPj9bHm4JY78auDHj4@vger.kernel.org
X-Gm-Message-State: AOJu0YxDGmQXkDA+0sPHW8Y9wHjfryzdA4QMrZeTgfMAblUpTIFzQb5k
	Yt3EPYqotLrGAF2eMozavxpewtr767apGFO+BbwOJYctKYPpydNjsJA=
X-Gm-Gg: Acq92OE3X3MigTNo7/sKvaS6chjFEvAaQB/IhrYO98zdn6pk5+pBGrOP+xECpmBDuxG
	pZ5oPMKugOKKGMYyDe2DWIB1obniHbs4zJtyc19dlCIUK6+JMnif4ee3ndy32OFLEVmz2tHAboM
	j6dB44x74lK1P9Gpl7GXZ+R2zbyRcLpUqiXoxdgP6YgbGY+qOMsstSWalBoAZhMMnQ/C11ToXGS
	41FGfyM0qEmFDUIUZDCkxfNyJCoGJlVcjKETw+V3jYauYn5jfxXEPMxoPCrYFuRN1wOiX1jXixD
	NeKaxtMouba6nj7QJNjOA+ejLeLfwfEFy7e2ywuMPqkRL0ngp9twDQcSNm5QhZ0XbQxWYRUGUXV
	xVy4Ne1p+wAYbzGN6orFTcPDgU/p/YkjsfhZd3TDw3kDFBTaTkgxSUDiUU1m0DDwizy1tGl4tmK
	LC7+NuDVLxopW59sZtruMgS8mBaWuoNIWLBDtV037ZfI7ZJmVS+EGLoIBgJsJF
X-Received: by 2002:a05:600c:4fc9:b0:48e:6db5:76e6 with SMTP id 5b1f17b1804b1-490424884aamr52403355e9.2.1779573906842;
        Sat, 23 May 2026 15:05:06 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49045282201sm152536785e9.8.2026.05.23.15.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 15:05:06 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	SCSI-ML <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: devinfo: identify ""/"Scanner" entry in scsi_static_device_list
Date: Sun, 24 May 2026 00:05:04 +0200
Message-ID: <20260523220505.109164-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Added in commit 0d7323c865608, lacking proper identification.
Original report: https://bugzilla.redhat.com/155457

"Vendor: Model: Scanner Rev: 1.80" has been identified as Microtek
ScanMaker MRS-600E3 or MRS-1200E6, and likely others, in some bug reports:
https://sane-project.org/old-archive/1998-05/0104.html
https://lists.opensuse.org/archives/list/users-de@lists.opensuse.org/thread/KWDJMYBLYZAJYY7RE7RWDKET72RMYBZT/
https://groups.google.com/g/de.comp.os.unix.linux.hardware/c/OJYeaMgfWFM/m/dvmq6l2oicYJ
http://www.sane-project.org/man/sane-microtek.5.html

Add a comment to identify the unknown vendor/model.

Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 5988d941e76b..cdd4fec6b991 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -124,7 +124,7 @@ static struct {
 	{"YAMAHA", "CDR102", "1.00", BLIST_NOLUN},	/* locks up */
 	{"YAMAHA", "CRW8424S", "1.0", BLIST_NOLUN},	/* locks up */
 	{"YAMAHA", "CRW6416S", "1.0c", BLIST_NOLUN},	/* locks up */
-	{"", "Scanner", "1.80", BLIST_NOLUN},	/* responds to all lun */
+	{"", "Scanner", "1.80", BLIST_NOLUN},	// Microtek ScanMaker E3/6 responds to all lun
 
 	/*
 	 * Other types of devices that have special flags.
-- 
2.54.0

