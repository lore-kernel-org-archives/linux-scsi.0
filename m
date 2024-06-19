Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B76757F2
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 07:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718781305; cv=none; b=rJyqpPV2BLz63C4gES0nlJL7AxWX4eP6jQxaQ5nY7b+Ti06Z2LggytnhxGRIlFK8GX7HJT3esh+SDPtSAKYE/gZEsr293kP67q3Coaetk8TIntTkZ7MsINaLleLw2X3PAar+xu10ndJpmiMDNdgx80+G8zt7iT0ywxEu/Ug+mwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718781305; c=relaxed/simple;
	bh=EX4t+3xm8l3Q1wykGkU1o3cyd8qUxK6piIGJGvSRg50=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=TMcM/n6Yp16COR6cZM0HXSYuMiG/WucwtW+vtMVRr6RNT8gNfcWq20jHktWQ4UiXDNuM4VjPu6txqxzjDPNmJopVpbNxGPCp3x3zNG0qOoOy6BA1YKMJHMKisypxf2I02wWp6176rAI72elSJXExX2mYxRPMmYFj+pXSjZiIFUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=gxi7KgWK; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="gxi7KgWK"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7008acebf3fso155031a34.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 00:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1718781301; x=1719386101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Skd7XFv1VpSVP5Nz+gUbCXLZPArGMYNgkzg+l7mFaqc=;
        b=gxi7KgWK6qDSkUAfI+kPq2oCgvqjkvWZf3yy8nEXVBF1BBtmdCPvaOCjIfluMztGyD
         nnDz8cjB8Vl6ISUV87GpmK8tS5wbcfLB2bYO72lBWA7B9NevnWovPAcxkxxasOiCo/r6
         0+n/lOf2Hpots67naguvbLoLQrt5FffjEvPSsoUrrtt7ara3FVKPwSrwMqiE6nr67vTD
         lj3IpKo5iT7gxzTXE1VViaJ94eOkfldtSYLhcNyYxp/C+cClqWlV8gyyJQmbi+2wDKjA
         HMCBtzSqThQag8dPfgSI2GxzTWrwJY40j51s+uTocZbNXjEeugRsMjCF1MWYxZcLnX5B
         a6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718781301; x=1719386101;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Skd7XFv1VpSVP5Nz+gUbCXLZPArGMYNgkzg+l7mFaqc=;
        b=CoPEA05BRQWubG4db3YGPN3LqWx4JCdhom3nbD1goohck6e7qnc+V5JcBQ6FdCH+5Q
         TZtKeJojkavWWPiE+Gu6+Mguylhwn02H08werJV/7k/H1E+vs+mGD/FG+ef7Glli7PYY
         l0AWaFhzGQN5YKl8AD0F/GbdvrnwcbMMj3c/ksT0m2tkfOkG4lINtkqpOvdREzGn7dhB
         YK9flkn5HUV1vYmflTAlvHuXSkJKMCrTU5SEilPUk0sXY4kJJkGTXgvz9jZX1u1czyzo
         cbsnaBz60uz/hgvWx+MRJI6XF0huHpB5dHEJY9kZSpds37UW8N9UHnxmHcjvEdFDfWc6
         0tBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKyM6dnVsZU3vywkchNIM1l4s6WiJlMQbNAsew0HRuoKz8kQrGyf7bl9t2KHMZrYXrPdCsvlhSNgn8xVhuIjkatyBZ6UXvH2/Gpg==
X-Gm-Message-State: AOJu0Yx9JFTJqGggIsBxvu3U8i5dTjFVU+6CtSEWiwFi0kd2BvL4aZ9V
	mGmFI61WWk9cZef2ljHrknTAIFJtnhvtAg50TckIrvAltHx+46erfhsdVDRl7tg=
X-Google-Smtp-Source: AGHT+IG7O3ICtniQOneaeIPZYCNZjjl4rvONDhxstG56u2rMRyHM9mj6qtwBBthgaCjatBgs0U0Zyw==
X-Received: by 2002:a9d:6296:0:b0:6f9:710e:65a1 with SMTP id 46e09a7af769-7007568bbd1mr1952243a34.28.1718781300665;
        Wed, 19 Jun 2024 00:15:00 -0700 (PDT)
Received: from localhost.localdomain.cc ([103.172.41.199])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6fedf2a74dcsm8993316a12.46.2024.06.19.00.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 00:15:00 -0700 (PDT)
From: Li Feng <fengli@smartx.com>
To: Christoph Hellwig <hch@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2] scsi: sd: Keep the discard mode stable
Date: Wed, 19 Jun 2024 15:14:03 +0800
Message-ID: <20240619071412.140100-1-fengli@smartx.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a scenario where a large number of discard commands
are issued when the iscsi initiator connects to the target
and then performs a session rescan operation. There is a time
window, most of the commands are in UNMAP mode, and some
discard commands become WRITE SAME with UNMAP.

The discard mode has been negotiated during the SCSI probe. If
the mode is temporarily changed from UNMAP to WRITE SAME with
UNMAP, IO ERROR may occur because the target may not implement
WRITE SAME with UNMAP. Keep the discard mode stable to fix this
issue.

Signed-off-by: Li Feng <fengli@smartx.com>
---
 drivers/scsi/sd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e01393ed4207..f628ca5ac0ac 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2621,8 +2621,6 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 		if (buffer[14] & 0x40) /* LBPRZ */
 			sdkp->lbprz = 1;
-
-		sd_config_discard(sdkp, lim, SD_LBP_WS16);
 	}
 
 	sdkp->capacity = lba + 1;
@@ -3271,8 +3269,6 @@ static void sd_read_block_limits(struct scsi_disk *sdkp,
 		if (vpd->data[32] & 0x80)
 			sdkp->unmap_alignment =
 				get_unaligned_be32(&vpd->data[32]) & ~(1 << 31);
-
-		sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
 	}
 
  out:
@@ -3671,6 +3667,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 			sd_read_cpr(sdkp);
 		}
 
+		sd_config_discard(sdkp, &lim, sd_discard_mode(sdkp));
+
 		sd_print_capacity(sdkp, old_capacity);
 
 		sd_read_write_protect_flag(sdkp, buffer);
-- 
2.45.2

