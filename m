Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A172ECD19
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 23:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758841704; cv=none; b=Wfup+7e8W4UCJQVrvENVQHcLjbFG/CM3VLYrb8fnLzFjhkeTQdlNsTXA3WAFRAlcewfS/w0v4SFCmxxPfyNTP2GJYQQ/xFdo+wBqECfdwCBd2AY6VQLccywEcPbxd+NtBQReFt7h59ercVZyV6SLkk4SqctcPQ25MoZrjXJwvpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758841704; c=relaxed/simple;
	bh=YqDERhDFXVcrdLn1MdWmpLGWWTO492yEeSdMj/0EWC4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gw/5/zbUBYbGBCwOcMOUn65i1roPNpkPdd4jslCXsi+hj5VpKCMuXKDDlP7GztJXHuPYATyadjGizJyMXI0c3LNhV1XjHHxeSrwZzn5gDF9AWGNU+UHGdcKoGvLLKrkki4zOYHzYm/WI33s4FyxczhEwLsK8rCU/rkjH1DJI8hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RmeiR5wg; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RmeiR5wg"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46dd25efa05so2521365e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 16:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758841701; x=1759446501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xSBomsio/aXumk0O7FUF3OGHhY1q91e5j1ZV2rtU1y8=;
        b=RmeiR5wgpS9E4Js4fLLuMSsIW7F78i15fQG1fiyoml8y1tfIQUhRpHj7x5Ay7kwIYT
         Fv9mUPxovmFsDNILbt97LAL1gjUmQOoZUQQWzCai8bK0QMjUaEHLa/oJIcxHTfqzN+NF
         RosqIuPAdx4tNOLNX+QaWi0o9x5JNBvATHO2UD5VWW3EC/tjxW4oKxifPuKPoT197wn/
         +hac4rw/uUKBCztLIy/xhMcFQNYcGhuJ3fEDzAeGljHVLGrIGvVb9vqlJCc0ItSw2LAX
         K6OdPbTyNE/izPT01afvQMA83QqFQAJvdASnboJ30qOwbo4N3xPyxC230mcL2p0RAjE4
         pl6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758841701; x=1759446501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xSBomsio/aXumk0O7FUF3OGHhY1q91e5j1ZV2rtU1y8=;
        b=SIbA0QcyK9v8kZfd88SSSgnZ+morAF4tZ5aMhykcWxlFkW9vwlUqFMqL3LBDQtgTPm
         766CqdbiKPRqZDTTcWWlGrdZaJCko+nRGii4F+oMKvZ8zWoYrQFkhF2Vfa+19P+X0HHx
         lIzntdBJU5rfrakqdUH9y8eweLo7m3+e+MFT43ofG/nOhaazuDf4sfRP7S4CfXxTk7EL
         YoOCkEamdJf6LmehJpQPpwffK+ND2yh9VGD0JCdhRRH8UdI+Yh3bTQj88YT0+XWACyHw
         HwEKfFomsJiKFxNnjfVQc9HXI2AOhoVvc2sg96H2ObFaSuUwQo6txakGVtZqsXhc1vzk
         4wEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXe1O9EkvlrIEVJp5M/OnmLFOalCbU66ZlsxVkb1JyL9zIkxytGEpGNTSRQX/laa2EsvJ53sXwlde0b@vger.kernel.org
X-Gm-Message-State: AOJu0YyrWHlVlPUJYu/X5LDk7v/0AD3gnFiCICc+xXniP51HMg/2Bb2K
	+J6sj+WZgmfPrvbpWPCH6RQlNuYRK1wSJDL/RfcFLNNcBE4OEO4HUII=
X-Gm-Gg: ASbGncs061ZATIYtzxI9I+c3DKUviuGsQilogGgo4hso8X/QoabuS/P+J5NgNazyR0Z
	lWEU7qrNJiH2iFbEpBWBd0wpSvoiGz/T7iMudA9cvPNiOs9OMNXXAuCzk7F+707fvyVi+i4XKVR
	yYaFa6EEDjKx/EShAwr9h/95uxH5TYZGzNZwegk6pHWL317W0Aub/MGsuI7eWRaj3wKnsa86vOs
	Indrt71HK7JGGGcoFyKmM0rHe02WElNsTlArnWEctLmM56Ccx6B8kc1x1VgNW5L8whHjmQKvRMn
	2TWUr4urEnKDZF7OlgsrHsMweqjByqasytS7MVRbP+Jp0DqujXHlj2p3E75ySG9a0pHC+galbRf
	rgLtK0jtfr5dmlKIZYA5ZWv01o/UEdHdt91DhQhJs5OrYvbR+Fe/JOZv3weQr
X-Google-Smtp-Source: AGHT+IFZJKJA1WLKaM6/g7U91HDWA6lf9gGclcEqnWYc5Rqmkt9EMHYC0Cklt8AQE/MWzMPoSCeMxg==
X-Received: by 2002:a05:6000:2a89:b0:407:7a7:1c99 with SMTP id ffacd0b85a97d-40e3b04d984mr2294065f8f.0.1758841700554;
        Thu, 25 Sep 2025 16:08:20 -0700 (PDT)
Received: from localhost (20.red-80-39-32.staticip.rima-tde.net. [80.39.32.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb74e46bcsm4658944f8f.8.2025.09.25.16.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 16:08:20 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Nilesh Javali <njavali@marvell.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	QLOGIC-ML <GR-QLogic-Storage-Upstream@marvell.com>,
	SCSI-ML <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: qla2xxx: remove references to unavailable firmware files
Date: Fri, 26 Sep 2025 01:08:16 +0200
Message-ID: <20250925230818.7548-1-xose.vazquez@gmail.com>
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

Cc: Nilesh Javali <njavali@marvell.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: QLOGIC-ML <GR-QLogic-Storage-Upstream@marvell.com>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d4b484c0fd9d..e5aa4297fc0d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7619,12 +7619,6 @@ qla2x00_timer(struct timer_list *t)
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
@@ -7636,12 +7630,6 @@ static struct fw_blob qla_fw_blobs[] = {
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
 
-- 
2.51.0

