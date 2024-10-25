Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080971FF04A
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 18:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729882216; cv=none; b=Set5gaNJbPJsxzz2Vbsxsq5nOmCRHDjjuVDcTeJRMJjer7dWeuaTLsSy+qdqaZtsAPAZpUwuUnMG9lEzv4R1wriM/UW613SYRuMR9YMcx2ZV2lisirDvYLF7d7CwdDE0oyLNUppjqJPNFCdy1jVO73uKeOifmHYwMx+1x6/0eCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729882216; c=relaxed/simple;
	bh=CGB6LxmT0WXhEjsf6xrepgUWVuXW/Zv1jXqqTyC2SJo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Z4t1XKdp2R051YSMl0usjo6TU4IB6A9Xo8e+/WhHPkhC0DQwd59UMvUrvN7JrGDgpzM16Khj5/+oh6Ov5GnDT5Pbv7uuuZUr35q/HrXK0bbAqdHQ/TYFDaqRjHNzjKUAgQK9cO7B3F8BHytHjnHbofSv/nDsUJ3IRGkhT/+s3/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ttkvU98y; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ttkvU98y"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20e67b82aa6so26898965ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 11:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729882214; x=1730487014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e0+NHsCuboH95g4yQb8qYWh0zFmSJiQuZvvpd/g2KQA=;
        b=ttkvU98yL+mcy3GYGZhq0+Z/f+Lsk2pqb6Njgzjmbvg9mKgNdx6YfHN+ccj+rhSVsV
         LxswnyskcCjxkksMDhHY2iDX6OIIxHlizrckEBmu2KPr9KVztq8emRMwkuX/7dim7jju
         XDw5+aY0PKBJkXBkQb2poLt0DizYYvVmqH5hTH7dyr2D9lAf+19n8e2Pir8IKBUngkUO
         QjYOBGcZSM4uCGtBFH2tIfbv+iNCtdC5aLtRo84qnl5mjzbCuvtWFg07dWjTnPFFQq4W
         h5/FqAcRhNxiCwFmS5IUVN+LtOX5oO8YU6srMEKPMGrVAjBK9Xi9YmoWMCPIkBQY8dwr
         oljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729882214; x=1730487014;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e0+NHsCuboH95g4yQb8qYWh0zFmSJiQuZvvpd/g2KQA=;
        b=Knj3Civm4cWxe/+hHRDFzHPLEZzq2ZTmbiiQABJdaQ2UdPDBGa2b6hR2y1Eh8ld8IZ
         ZtJoU0FWtXuaUDS++kH/8rp1WkJ/fME3oNqNvQlcVtBXfpV7Yb1qSUldcTCJ2TcvEP40
         VePAap26YbRiC4rWaHk1yx6jFzJ74Fgvufdc4Vz18OcULKBqT7E3dW36uiWgcDnk/NGd
         YwrJvlm2fRMsmSb/SsdQxy7yWTBb23o8Bx8/Kf6NM1+Q+n1UDeWCujLcbM1EOFlkSxRi
         AkDTL+00AJlN4bR8pG4LLACpncQVx34Tqy/9XmfpGexiyya1DXeEzYZ/caBmW32FgTW9
         77vg==
X-Gm-Message-State: AOJu0YwNPs3BawgedjEkGUYkmPT8XNBIgmSxtL+HkTP1EYfdphWOEp3t
	aisbB4IQGSLNZNrwesCGAmlSmge3K9tahjbvHPgj/PVjwRH2pI/wuG+MGSCaLgow3SXrArP8L8d
	YbLP4tvPFvQ==
X-Google-Smtp-Source: AGHT+IHm7qoXaMzwNAnNJmodVt+UDTG1/KMKRAhan8DuhRdo0c3Sn8G90KEAwU47YeMs5XVE86rIcoyZHC9Vww==
X-Received: from ip.c.googlers.com ([fda3:e722:ac3:cc00:ef:85c8:ac13:4138])
 (user=ipylypiv job=sendgmr) by 2002:a17:902:f544:b0:20c:ee32:75a6 with SMTP
 id d9443c01a7336-210c6731cdcmr2755ad.0.1729882213968; Fri, 25 Oct 2024
 11:50:13 -0700 (PDT)
Date: Fri, 25 Oct 2024 18:50:09 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241025185009.3278297-1-ipylypiv@google.com>
Subject: [PATCH v2] scsi: pm8001: Increase request sg length to support 4MiB requests
From: Igor Pylypiv <ipylypiv@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"

Increasing the per-request size maximum to 4MiB (8192 sectors x 512 bytes)
runs into the per-device DMA scatter gather list limit (max_segments) for
users of the io vector system calls (e.g. readv and writev).

This change increases the max scatter gather list length to 1024 to enable
kernel to send 4MiB (1024 * 4KiB page size) requests.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---

Changes since v1:
- Added .max_sectors = 8192 to pm8001 scsi host template.
- Defined page size, sector size, and max I/O size to calculate max_sectors
  and sg_tablesize values.

 drivers/scsi/pm8001/pm8001_defs.h | 7 +++++--
 drivers/scsi/pm8001/pm8001_init.c | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index 501b574239e8..7871e29a820a 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -92,8 +92,11 @@ enum port_type {
 #define	PM8001_MAX_MSIX_VEC	 64	/* max msi-x int for spcv/ve */
 #define	PM8001_RESERVE_SLOT	 8
 
-#define	CONFIG_SCSI_PM8001_MAX_DMA_SG	528
-#define PM8001_MAX_DMA_SG	CONFIG_SCSI_PM8001_MAX_DMA_SG
+#define PM8001_SECTOR_SIZE	512
+#define PM8001_PAGE_SIZE_4K	4096
+#define PM8001_MAX_IO_SIZE	(4 * 1024 * 1024)
+#define PM8001_MAX_DMA_SG	(PM8001_MAX_IO_SIZE / PM8001_PAGE_SIZE_4K)
+#define PM8001_MAX_SECTORS	(PM8001_MAX_IO_SIZE / PM8001_SECTOR_SIZE)
 
 enum memory_region_num {
 	AAP1 = 0x0, /* application acceleration processor */
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 33e1eba62ca1..c87443b14ff7 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -117,6 +117,7 @@ static const struct scsi_host_template pm8001_sht = {
 	.scan_start		= pm8001_scan_start,
 	.can_queue		= 1,
 	.sg_tablesize		= PM8001_MAX_DMA_SG,
+	.max_sectors		= PM8001_MAX_SECTORS,
 	.shost_groups		= pm8001_host_groups,
 	.sdev_groups		= pm8001_sdev_groups,
 	.track_queue_depth	= 1,
-- 
2.47.0.163.g1226f6d8fa-goog

