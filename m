Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1057B85934
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 03:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719889334; cv=none; b=sNlrquXJ6ZTPYX9xIgi7kee9pwa23CXWNDpdoAyqu50i64oWJJyq+9nTrnZmzbT52+4sMC0YYXRo6942lq4BXYsguZvnoyXtLusDh4cMUsnkcfIxd67U+8CHjBLzuTukPJuXfGz1QhAJKoTVNUbKKrxtMM/3Eah9t2Rvi6PpW1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719889334; c=relaxed/simple;
	bh=yiJFaJgdWIpSzq4I1bh4NFNS0sS3mumsKHKQMWi9Duw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBbm7n3IICYM/Pf9J6+ZEDxMNumO6ejeCg4/15MYUMDRlD3aMiO24Z0FfFXvxzUNdMjhCU8tKV032ZeILvDgOqclmFhnbBwLzEyV59P+x7sH5Rbsf85rq8xQsTI5Hcm0lE8UMm1PgEP8fjPHnLXSvgBOFgNcgyF1FlJzspt7dr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=opkiiNOE; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="opkiiNOE"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-37611e6ed4dso14513605ab.2
        for <linux-scsi@vger.kernel.org>; Mon, 01 Jul 2024 20:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1719889332; x=1720494132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z5wro2DPQQzDm4JEbFr9RFX4ZrKb+KLG6vY37L6bP9Y=;
        b=opkiiNOE6G/+ZxDBex22KOc3oTB0pSYB7lJfPDnTQc16jMbCY81GKcS5sNUI4BgVwb
         o7VkuUq+B/oXK/1YjvPZnPRSoEK7+Yrj/ij+4udZwSAAcveIYl9W4jtuCEiCbH9+WfkR
         4f2SxYVJhFRF7gICy/UG09xXuDXJXuqaP3FwDaiX6rQMYM0WjIG6Mn+2BSqrMe3dRk0G
         aE3omH3f9AsaAThh+5RaEEy3yf+rnOq5BrN9f064V58bZ2Gi5Z5cDImjEC02V13NKWmj
         PV/LHColcl3zbJDA/E/XNfuYaxn/P178CCQtm24f92k/V0k9bukr3uoLS/2FNqH7Cqko
         72Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719889332; x=1720494132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z5wro2DPQQzDm4JEbFr9RFX4ZrKb+KLG6vY37L6bP9Y=;
        b=r3W/IMBaPmQIF8kGxaeGdYYgISZ54joyodWF5eauVY3rSmaNroePpGWFU3U8DPdAnh
         yAodYiW7A35/9ZTb093DjEhEVo7ITf8WBPxlOaMgd3lkkwmkH7yKDW5MCe0jJvf3VKEJ
         BZh03XJEZHvL+b4u9aY6xV6s9QrCd4bNwmUQJFkzs/gdvKJY/DOhmb7lDgINjd32ZVeC
         GZJeNd3DAyDpUXo7oPXlUwSZC5pYFX0pP8ZY1/1TxAy80qUTtln4/hhf3+3dTCvHTtwO
         vwqesR3neSQZAP/imUaO+XV96gQ6xKvWxhpDAALnZ6qwR+oCwHWn5+dJuKpFJoNCwo3r
         dKqw==
X-Forwarded-Encrypted: i=1; AJvYcCU3V+YJ5pqtgtpe+hNJI/e3+qLNkdouPYvciBOP7Es1Q+I4MGImRiYVazcryDqBgeKI1rnyfFK5liMYh3P+7kcjRS4vpLx3vEzl0Q==
X-Gm-Message-State: AOJu0YzKVMyYY0undqV4r/dJqMt11vinRFO9y9wn/K+7DXIpRf9yaXo1
	H15P0hu6t5e5rAYtffG5YY0yryelc+pi41n0/qfYxu+xfJfItz4wsaJ2xMe9+Nc=
X-Google-Smtp-Source: AGHT+IEpTMk59V3NV8KVvtbOMVVsa4fULF1zm0uglqoSp4Io1UgeVjGAy7FP7CAi425G0Y2cNLDt1A==
X-Received: by 2002:a92:c54b:0:b0:374:5a2d:178 with SMTP id e9e14a558f8ab-37cd07285b2mr89734205ab.2.1719889332060;
        Mon, 01 Jul 2024 20:02:12 -0700 (PDT)
Received: from fedora.smartx.com ([103.172.41.200])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6a8dbb2fsm4792904a12.31.2024.07.01.20.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 20:02:11 -0700 (PDT)
From: Haoqian He <haoqian.he@smartx.com>
To: Christoph Hellwig <hch@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: fengli@smartx.com
Subject: [PATCH 2/3] scsi: sd: remove scsi_disk field lbpvpd
Date: Mon,  1 Jul 2024 23:01:15 -0400
Message-ID: <20240702030118.2198570-3-haoqian.he@smartx.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240702030118.2198570-1-haoqian.he@smartx.com>
References: <20240702030118.2198570-1-haoqian.he@smartx.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The lbpme bit in scsi_disk can be used directly to indicate
if the logical unit supports logical block provisioning
management. The lbpvpd bit is no longer needed, so remove
this field from scsi_disk.

Signed-off-by: Haoqian He <haoqian.he@smartx.com>
Signed-off-by: Li Feng <fengli@smartx.com>
---
 drivers/scsi/sd.c | 8 ++++----
 drivers/scsi/sd.h | 1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 44a19945b5b6..b49bab1d8610 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3306,8 +3306,10 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 
 static unsigned int sd_discard_mode(struct scsi_disk *sdkp)
 {
-	if (!sdkp->lbpvpd)
-		/* Disable discard if LBP VPD page not provided */
+	if (!sdkp->lbpme)
+		/* LBPME was not set means the logical unit
+		 * is fully provisioned, so disable discard.
+		 */
 		return SD_LBP_DISABLE;
 
 	/* LBP VPD page tells us what to use */
@@ -3430,7 +3432,6 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 	struct scsi_vpd *vpd;
 
 	if (!sdkp->lbpme) {
-		sdkp->lbpvpd    = 0;
 		sdkp->lbpu      = 0;
 		sdkp->lbpws     = 0;
 		sdkp->lbpws10   = 0;
@@ -3445,7 +3446,6 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 		return;
 	}
 
-	sdkp->lbpvpd	= 1;
 	sdkp->lbpu	= (vpd->data[5] >> 7) & 1; /* UNMAP */
 	sdkp->lbpws	= (vpd->data[5] >> 6) & 1; /* WRITE SAME(16) w/ UNMAP */
 	sdkp->lbpws10	= (vpd->data[5] >> 5) & 1; /* WRITE SAME(10) w/ UNMAP */
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 36382eca941c..ff9ff2655c25 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -146,7 +146,6 @@ struct scsi_disk {
 	unsigned	lbpu : 1;
 	unsigned	lbpws : 1;
 	unsigned	lbpws10 : 1;
-	unsigned	lbpvpd : 1;
 	unsigned	ws10 : 1;
 	unsigned	ws16 : 1;
 	unsigned	rc_basis: 2;
-- 
2.44.0

