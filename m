Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB701BDD0
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jul 2024 08:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721290111; cv=none; b=mDU2cxErIsd+ri8PWyJC+glnAXjNOLastx6gR1hQg6wAXRftWoj9FUyQNYSwvyiDY8PqvCN4E4vUrRxrGak/HEuy0bvlIlVAKdHJqGvcEWhdsoT7/O/EnNBmVa3OJD0mol9Tujm7dHL6tAPYKqV5vq1+3jevDqXahahHuf7pIRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721290111; c=relaxed/simple;
	bh=qLABD9T71TLKm1suUkJYcBMQCLNJkiu/KGSyf+3z+TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVdEc8on5YjEh4qN0RxEOSJmLWwadRI6QjdfN1NBFON903HvYF15Pfh56k0Abjzw+b9w7Ozk/C/g2GwRyS3hFgOj6gQ3CeTd92NkmVcRdVo2cL7ZgtjukIlzLxeeXoUglJHiWkH8R3Ur48fLbeMhI7TpXECHcEI2IOixJ3zYSB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=ZEb0Wvuw; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="ZEb0Wvuw"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3d9306100b5so336006b6e.1
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jul 2024 01:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1721290109; x=1721894909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IR8iierOPTZzBaSqo6PfOiKbzROZot6u1VYWUcPh8N8=;
        b=ZEb0WvuwATX+5Q3DpIELbshQ2UC+dMxvm37Zfl4sGxkmjigyB73lUiJ+ti64mdfFiJ
         bqmyNYXQF8HeYt4aYAFRGHTO09O1ae4+yQSUgOMa1uGqbYUACzXLqQAveaonEV2485tj
         gqCAk8YdO+vPEngYt24p05scCPLNOfmH+XWiurDAWoRckvYCghwzr9v6LRKb2jUbYbYG
         GP3BmVIDAq1sUDiem9QiRNOUqQsj46YQRZ6R+JvalltI1KjIvRLH5kUySB1hHa1iXsIQ
         7GgAzxSzOQkKIm/gEO3bag0S6Ml/e31ZVQB+Bt2xoh6Ezrioa3EDNiP7TAD+9pCW0jwg
         V5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721290109; x=1721894909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IR8iierOPTZzBaSqo6PfOiKbzROZot6u1VYWUcPh8N8=;
        b=IPKbMzgIYqPG2mE1B7jQelS3T+q+nUx5j7qNm5cN3m/Oky5nPNiQfHbBELlLZO6i/a
         H2/3Wt2YC9PZy3pSMAo2CniGoU8giNQnM0AmT3XtN4Xaes5DcjtqsApDkOybSpRTjj5L
         MhEhZUdWUUrSh2f0274vNtzoC0Q4tTc81cJrhmmmwmHgOFOobQEQQJEaO1IoszZjxMz2
         26T0Ol8WtlwDyeYllKPW5vRp/NX3DL7NsMT9f1vzlreyKsj+Obge2iZ8NK+J6CnIt06+
         9LqQ1JDfUOQC5dlClyRCEtNVlBNImNJouni+fCNMkaKCDz0g98FKmf8Od2e2HKXkJTIj
         dzTg==
X-Forwarded-Encrypted: i=1; AJvYcCX8i3cZx05sVPMeLO1D1ZnWxQzB4yicvFmEpdh27hfaEEeGik/v67AoyXsiPODrDcvBN/wHIOHqzqwGVzNb1z5EFtLKLC9cUk2LIw==
X-Gm-Message-State: AOJu0Yx3jaq/pgYHRb68TXl3MaKdxNj0V8VAWqDtRl1W6oHrm+qTcKnE
	5tllB413kmbHO6hO0sVKY7be5sudXF3Fx6/HfeQouud9CLJKaG8VKf3tkdjGaj8=
X-Google-Smtp-Source: AGHT+IFt/GDmyO6/5KiJNmP9PcE4OTbvejTawUJC8MDoIi9vUQcTBV/LIKuenQfb/Mg/W51y9Y9O/A==
X-Received: by 2002:a05:6808:1a1b:b0:3d9:2b5a:4ac6 with SMTP id 5614622812f47-3dad76e96a4mr2141051b6e.6.1721290108310;
        Thu, 18 Jul 2024 01:08:28 -0700 (PDT)
Received: from localhost.localdomain.gitgo.cc (vps-bd302c4a.vps.ovh.ca. [15.235.142.94])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-78e34d2c4d3sm7385958a12.48.2024.07.18.01.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 01:08:27 -0700 (PDT)
From: Li Feng <fengli@smartx.com>
To: Jens Axboe <axboe@kernel.dk>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org (open list),
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 1/2] scsi: sd: Keep the discard mode stable
Date: Thu, 18 Jul 2024 16:07:22 +0800
Message-ID: <20240718080751.313102-2-fengli@smartx.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240718080751.313102-1-fengli@smartx.com>
References: <20240718080751.313102-1-fengli@smartx.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8bb3a3611851..c180427e2c98 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2711,8 +2711,6 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 		if (buffer[14] & 0x40) /* LBPRZ */
 			sdkp->lbprz = 1;
-
-		sd_config_discard(sdkp, lim, SD_LBP_WS16);
 	}
 
 	sdkp->capacity = lba + 1;
@@ -3365,8 +3363,6 @@ static void sd_read_block_limits(struct scsi_disk *sdkp,
 			sdkp->unmap_alignment =
 				get_unaligned_be32(&vpd->data[32]) & ~(1 << 31);
 
-		sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
-
 config_atomic:
 		sdkp->max_atomic = get_unaligned_be32(&vpd->data[44]);
 		sdkp->atomic_alignment = get_unaligned_be32(&vpd->data[48]);
@@ -3756,6 +3752,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 			sd_read_cpr(sdkp);
 		}
 
+		sd_config_discard(sdkp, &lim, sd_discard_mode(sdkp));
+
 		sd_print_capacity(sdkp, old_capacity);
 
 		sd_read_write_protect_flag(sdkp, buffer);
-- 
2.45.2

