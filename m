Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE99F34BA4E
	for <linux-scsi@vger.kernel.org>; Sun, 28 Sep 2025 14:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759069144; cv=none; b=tT3U19yN/SFEBHTkNcu9kkQWWRrmauTtY1dbLp9nHES/V4zFlNKmXCgTyzUGDuZgjxCAa+jMUy9zij9GEonH7GEol8SEULRXU1wwWO4ztYpJ9J0Tr1TyeZYXEghd5+fAQFxMGSJE5TmJsRJNYfLOotYbUmU/CA9rkvggA7sBw54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759069144; c=relaxed/simple;
	bh=MrFwCcLbKUuClcrZzfcryNZzbqIQpvlXLjwePgGZEMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bOFrx9Vg7RIfXGd8kOYfNuHUGK1ERr6wkbX3EeHiJIUkHQCtQS8JBd4DJY0LkLTuarA3ZOj29ZsbNRoHUFVvG8YeJ5rXFtMAwxvX5C+qPuHOTyd/6YBXIbT6Emy9zxk2bdrWMKwntEp5Vt4+6/LPled5Xgx5HelJkQ8TT9gbUJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dqQXKW2/; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqQXKW2/"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-40f8e6bee90so484344f8f.1
        for <linux-scsi@vger.kernel.org>; Sun, 28 Sep 2025 07:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759069141; x=1759673941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=znyzSTOrLcN8UxMVwa2nIyra8CRmzJojjqcYr97PvHQ=;
        b=dqQXKW2/gZs+PC5mEepYAyBrRYRE94SElG/p/O2xOi8PGMMS0Krxx9scf+WcqPZ3YS
         YNGop0LkM80yE27RWsipjTxgXhiUR1ehvi6f6WBHDJQN5DlzLDTy2ZDpRQ3pVA9smgFj
         2CKPMhLy8p9F7CH6rC8W21hH4jP0/3CfTwm80kVjNN4FORY3mUbhl9zpVwkgz1k/15FU
         kiT81CiGUn1s8E4MHpSBQSHOQM83XlI6vQ2/XFAzzHyti6oIbbWcKqY8zV4BchKhpEZM
         734MGdNVqcp1ml/fqpZwJWEBGh9ZMlOw/CFd2mI5W0wy4/au+z7QdQLocrLfWvz1begi
         2ESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759069141; x=1759673941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=znyzSTOrLcN8UxMVwa2nIyra8CRmzJojjqcYr97PvHQ=;
        b=Q1TWtwof0J1IesRdGJEy2twC+tgShBPHqDTkd/eoYkdW0P1nubHWWz6OkEwMObxBnY
         8T2XxtUdSAF/y1HMj6yHvmK6eeAGkSrITr8p+rHlplxrufvzJdK0a28XOPpk+pF9ojwy
         wl7zwIObUKrGH9kEYvGtNJLll8EH4CiEf8rFJCuESZteAjJrIUrvNF79cw6+6HGCkh1P
         4OwC3hfuf1mS7YjX3LmfrjRMSbgHmDN8GdtOpSVsKr8hIlqRYJETdeLar/aFsHNHe4OK
         RpH1NgxTCNY+0Ovn705H/jUGP7d6zmVk26up+UNmhQWdW6juH8RskZnHJCgqQjRf8Qux
         3olA==
X-Forwarded-Encrypted: i=1; AJvYcCUsVKbP3B2fI4vWpsQs4kSCJr6bLpgJ7DRMt4wjvMnNEAqeRObkJE07LwCCSWoKKAYo1fDBd2cBFTWz@vger.kernel.org
X-Gm-Message-State: AOJu0YxprjBHlNAncLP0ueohPkB06VX3KuwIOu+Ysl4/tx79rSfHkscO
	ReKp5ABMesXXo1D4Afktg8i2UJYGyKgeQbHYPVdUpIegrFKpWGrLmoY=
X-Gm-Gg: ASbGncvIIVd1W/grLH5WuwoInwzPDnpDGPKe0dsKLaM4eTajYT+Y1vlBlwXxnGuzq4T
	AbEu6S/qYmCh4tRAy1cQM2y/T1SugpCkAatc5Kdr0jGCctmo0KQMautkd0AKNFavIpDFrHtkWTK
	HL2LpJPGJLqaSqzIyl0vvkZSyoXquU5vNKofZMILeyjBkd8th2JRYUpP5SF0VFYBCNb3B9y1eO0
	wS70G/O0l7PD+zqLcLg4m+hMDTa+6ExQj7PWllw0du/iJw4IIrUxDVdxORhTqewi+WkHU/TwZS2
	VCB14egxjhjE8L2zYEJb4Tnyxz394XpxUd1/8iSi85994vghloKGKAqwf0ULyPBBpYyiBzmTNmk
	V9TIbrK9Z/ZVTYerjuzdl0C9b8aA1rNJv1IvD7TYB+VJw8xvnUPzuBIqP/RrQ0E35d/2FDYY=
X-Google-Smtp-Source: AGHT+IHV1s5TIqlFLZO9EGIhWru1SZ4zxrnjKZj+DcnHlgI3TKLNQSSeGSQRUE5CJ4jo6X6DU9CE/w==
X-Received: by 2002:a05:600c:4ece:b0:46e:4705:495b with SMTP id 5b1f17b1804b1-46e47054bcbmr21513105e9.1.1759069140621;
        Sun, 28 Sep 2025 07:19:00 -0700 (PDT)
Received: from localhost (20.red-80-39-32.staticip.rima-tde.net. [80.39.32.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e33bed6basm145275785e9.16.2025.09.28.07.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 07:19:00 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Nilesh Javali <njavali@marvell.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	QLOGIC-ML <GR-QLogic-Storage-Upstream@marvell.com>,
	SCSI-ML <linux-scsi@vger.kernel.org>
Subject: [PATCH v2] scsi: qla2xxx: remove references to unavailable firmware files
Date: Sun, 28 Sep 2025 16:18:58 +0200
Message-ID: <20250928141859.215307-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

They are not in linux-firmware, and some(all???) of them are loaded only from flash.
This should have been done in f8ac60855ebfa and 940a7f09ad645

v2: remove firmware upload code

Cc: Nilesh Javali <njavali@marvell.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: QLOGIC-ML <GR-QLogic-Storage-Upstream@marvell.com>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d4b484c0fd9d..cc0bb30c1963 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7606,12 +7606,6 @@ qla2x00_timer(struct timer_list *t)
 #define FW_ISP2322	3
 #define FW_ISP24XX	4
 #define FW_ISP25XX	5
-#define FW_ISP81XX	6
-#define FW_ISP82XX	7
-#define FW_ISP2031	8
-#define FW_ISP8031	9
-#define FW_ISP27XX	10
-#define FW_ISP28XX	11
 
 #define FW_FILE_ISP21XX	"ql2100_fw.bin"
 #define FW_FILE_ISP22XX	"ql2200_fw.bin"
@@ -7619,12 +7613,6 @@ qla2x00_timer(struct timer_list *t)
 #define FW_FILE_ISP2322	"ql2322_fw.bin"
 #define FW_FILE_ISP24XX	"ql2400_fw.bin"
 #define FW_FILE_ISP25XX	"ql2500_fw.bin"
-#define FW_FILE_ISP81XX	"ql8100_fw.bin"
-#define FW_FILE_ISP82XX	"ql8200_fw.bin"
-#define FW_FILE_ISP2031	"ql2600_fw.bin"
-#define FW_FILE_ISP8031	"ql8300_fw.bin"
-#define FW_FILE_ISP27XX	"ql2700_fw.bin"
-#define FW_FILE_ISP28XX	"ql2800_fw.bin"
 
 
 static DEFINE_MUTEX(qla_fw_lock);
@@ -7636,12 +7624,6 @@ static struct fw_blob qla_fw_blobs[] = {
 	{ .name = FW_FILE_ISP2322, .segs = { 0x800, 0x1c000, 0x1e000, 0 }, },
 	{ .name = FW_FILE_ISP24XX, },
 	{ .name = FW_FILE_ISP25XX, },
-	{ .name = FW_FILE_ISP81XX, },
-	{ .name = FW_FILE_ISP82XX, },
-	{ .name = FW_FILE_ISP2031, },
-	{ .name = FW_FILE_ISP8031, },
-	{ .name = FW_FILE_ISP27XX, },
-	{ .name = FW_FILE_ISP28XX, },
 	{ .name = NULL, },
 };
 
@@ -7663,18 +7645,6 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
 		blob = &qla_fw_blobs[FW_ISP24XX];
 	} else if (IS_QLA25XX(ha)) {
 		blob = &qla_fw_blobs[FW_ISP25XX];
-	} else if (IS_QLA81XX(ha)) {
-		blob = &qla_fw_blobs[FW_ISP81XX];
-	} else if (IS_QLA82XX(ha)) {
-		blob = &qla_fw_blobs[FW_ISP82XX];
-	} else if (IS_QLA2031(ha)) {
-		blob = &qla_fw_blobs[FW_ISP2031];
-	} else if (IS_QLA8031(ha)) {
-		blob = &qla_fw_blobs[FW_ISP8031];
-	} else if (IS_QLA27XX(ha)) {
-		blob = &qla_fw_blobs[FW_ISP27XX];
-	} else if (IS_QLA28XX(ha)) {
-		blob = &qla_fw_blobs[FW_ISP28XX];
 	} else {
 		return NULL;
 	}
-- 
2.51.0

