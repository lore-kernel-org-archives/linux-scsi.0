Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03EF1E3760
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736256928; cv=none; b=nHm19lQAI/IwOJBRtaraH7ZiB9nqNO8TiRcslspZxoRoYK7fsPTeg9DqXUiWc7FEUV3eqRMK/3wpQP/FqQXGJnbyCYJc4D0LXb01ZkQNqgUhFCw8Jd4vbbwrHNybuZIgRIHwkYGTBaG1otidn9+nABfTHnqYdpSsW1ECEY8FzDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736256928; c=relaxed/simple;
	bh=4286aysA7oRVs8jwu5zQ5rCNC2YPaGJojNRwFE8eYfA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nzGdm4pD+CZaatTOl/g9iI1HfDKD/FHZETvBqaf82JesGBuiyEpBqOHzGHl0CiwM6c6IfjqroCccmwil0RNu97dK5GsyywtZsdHN9TNOS7lq9AsywG8PGCiltkput/DoOiyz/attVJMWwKvRM1I2EPp3N/K5qlMUMIK048uw+DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IrDiW7tF; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IrDiW7tF"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-385df53e559so12170458f8f.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jan 2025 05:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736256923; x=1736861723; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J7FFIEdHS9CbAL61Tl5ApigOpZoV4UoWP/2qqHJFSmM=;
        b=IrDiW7tFFBPDNCrpIZfSYCI9kKiIqXHdsw2geF3xrMQpptLb0uPLA4OS7g2e+c/eCJ
         /wdDtlNcTGHVDDkouNeGLoD8SitYnPeIF4YA9Q1NQXeIWHoXePPe+SRFiYHKd9cBosSD
         iXF0YEcBGK08fw+X+cQndtTUK2bmGqVZJEI7BwysapFKOBEg/G/KJfX/dprrEprRT7m3
         dLRuwZgKvRMtOZ43iWrJjapSldx1NR60Mh8GKrWVie0+ImzPDfZOcL0YJ1Vj/DhvwJ9b
         VXDx6x+Q2DZFvaJgeRET9dFJhU7ihS3autCDdKjW6xN08qwIweptDPXJTsrcOdoK6e/e
         4Yjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736256923; x=1736861723;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J7FFIEdHS9CbAL61Tl5ApigOpZoV4UoWP/2qqHJFSmM=;
        b=jd7VRd9OIPKaMiCPDM+r+2p7s2IAxTyt92lcRg1zRodwNHM/NkmJyOQllLFgfR7fDX
         cn6TDJwI75tFyJrQ/PpoYLxhe7Ct+NNp6Fi/XRoYqD6AkQqx5IXdWq/gQF0NV9J1t7nw
         MmmgieKn2WBMmTO/SdNlePTqig/s1YMA8SqVd02yvoZeTqgTaQybqSYgRWSVCVbddffQ
         oi0C7uzw3eIp68WoqWIb+MAGIdAg4mRV7Jt8kZYk4B6/XYQ+8NHcPkhUY05bO4OqUass
         Z5HYjTj41CbB/7oNNlog9m1jwRPDRsZn87yovxEVHIQ/rFNgnsZ22FZVbtAe02UOzCxx
         CkVg==
X-Forwarded-Encrypted: i=1; AJvYcCX4Nf8GBFWzrbd3fd5NNKmrvvjFTqcOjqlOr66aPl6CxS4u4JMgZw4pfQCRhMhs8qH51Q2uichckuZY@vger.kernel.org
X-Gm-Message-State: AOJu0YwGVDMidwny2zEF2UiaXXu/10Ws7i121O4y7x1q9HUcAON+1ufZ
	kKhSIrTpc7fX8i1MSnXZ45BtFlBonpkJB0zkkHxU0/dyjqQZu1f/orS7f2VIsnw=
X-Gm-Gg: ASbGncv5j2quRexp+yLnkhIOgMBOf/mkNGSel5qSfUulQ8+T5NQX/H0CxcsUOTgJBmC
	nuzww49Wp5VrYeZMWjY0xalfkW2SRFuvF/8V68aRtX8caanW37idDJgWplz/TOjoWNgs7Lj3qXN
	2hoLMm/W5/SbiJHrCH5vSBmDfOMvX5d09ghqPcczxSvsQcz1GPt9xDlOSETWNqMo9fAtApfpt9e
	rUUZ7jgDCrS32sY9/5iRn2NVZKnOlPYufo+ndQELX4aIW92ZTX27QgdLztNiQ==
X-Google-Smtp-Source: AGHT+IGcx6zv+W7uELezmWMCmgGv2pbdtmIgaj3rQCqkbfeqR1hydKp/UfPE/8wdBxQsYajS2jxmFA==
X-Received: by 2002:a05:6000:186d:b0:386:1cd3:8a08 with SMTP id ffacd0b85a97d-38a221ed256mr58676524f8f.5.1736256923354;
        Tue, 07 Jan 2025 05:35:23 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c828817sm51326659f8f.1.2025.01.07.05.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 05:35:22 -0800 (PST)
Date: Tue, 7 Jan 2025 16:35:19 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: fnic: delete incorrect debugfs error handling
Message-ID: <a5c237cd-449b-4f9d-bcff-6285fb7c28d1@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

Debugfs functions are not supposed to require error checking and,
in fact, adding checks would normally lead to the driver refusing to load
when CONFIG_DEBUGFS is disabled.

What saves us here is that this code checks for NULL instead of
error pointers so the error checking is all dead code.  Delete it.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/scsi/fnic/fnic_debugfs.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index caee32bc9190..5767862ae42f 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -679,46 +679,23 @@ static const struct file_operations fnic_reset_debugfs_fops = {
  */
 int fnic_stats_debugfs_init(struct fnic *fnic)
 {
-	int rc = -1;
 	char name[16];
 
 	snprintf(name, sizeof(name), "host%d", fnic->host->host_no);
 
-	if (!fnic_stats_debugfs_root) {
-		pr_debug("fnic_stats root doesn't exist\n");
-		return rc;
-	}
-
 	fnic->fnic_stats_debugfs_host = debugfs_create_dir(name,
 						fnic_stats_debugfs_root);
-
-	if (!fnic->fnic_stats_debugfs_host) {
-		pr_debug("Cannot create host directory\n");
-		return rc;
-	}
-
 	fnic->fnic_stats_debugfs_file = debugfs_create_file("stats",
 						S_IFREG|S_IRUGO|S_IWUSR,
 						fnic->fnic_stats_debugfs_host,
 						fnic,
 						&fnic_stats_debugfs_fops);
-
-	if (!fnic->fnic_stats_debugfs_file) {
-		pr_debug("Cannot create host stats file\n");
-		return rc;
-	}
-
 	fnic->fnic_reset_debugfs_file = debugfs_create_file("reset_stats",
 						S_IFREG|S_IRUGO|S_IWUSR,
 						fnic->fnic_stats_debugfs_host,
 						fnic,
 						&fnic_reset_debugfs_fops);
-	if (!fnic->fnic_reset_debugfs_file) {
-		pr_debug("Cannot create host stats file\n");
-		return rc;
-	}
-	rc = 0;
-	return rc;
+	return 0;
 }
 
 /*
-- 
2.45.2

