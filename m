Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B29518953E
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726148630; cv=none; b=kcwLY3HJbucRMaCQkUYL30z9YIKUCpIpGlbTXj+6Gi0IhHr7pvI7fi8jFJDx33WnjHviOFNQi478sNFXRxXsXHXTP+5/bC4oywFdY/Ntrr3HQx2g3SGNBccUHBF8JpiK1JEL33f4FpN8yZzLhTegUbUMsTsNYa+CHdiWtF4/Lfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726148630; c=relaxed/simple;
	bh=FGvyRE7WKpqB3eoj4rv5pL0kkGxhJoGJCmxLSvPTpDg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JTsClozErdC5T8U5Sx/2gzxA13NOX3saneXr8vPDoVkVSmSndN2CI2VOr9t/vVM22lHhFDDnvujdbwjTO5XO0mJoMcphPxeY12o+VXnQ3XElaeczTZ9SQfZXdquWHUyTQi/EYdt/iWmKQDarSJddTQkln/mCQKo58LsQMNGxXXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QvP+2RJf; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QvP+2RJf"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a7a843bef98so123337566b.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 06:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1726148626; x=1726753426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tG7ZTB+p3r1CQdqveb6zksyGyOcA8bApOy7w5xWeuyI=;
        b=QvP+2RJfz3dikbFwZULoPJGlYiE2SdhYFJX+Qm1yTM7XjDjLJR8btX4idqBZUMaIae
         qodZ+RyMwh6dqbyCUDcd9Bl6sohtWDkjJRvdEwPIQDSGHa6qgxjANDpBNDq8STt1Tred
         /pTt4c9ziJUgi5cKBn5oC2LqradWAnh+MAefR/TbOD0uH2XdGZ4SSiU0di8LVJj3nOAf
         OCQ8JcTzYkrScEKGU6zOAnOUmP18QJq+PZFoc0/z/muHhM97wVyMV/66SVnhQSveiD4n
         zwmhJvEFDfKJcOSCqtpwdIVWp7vMVYYGK6k1TeqS8XLUQY/hXPVcVz8j0mV70xDwMEwz
         qYIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726148626; x=1726753426;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tG7ZTB+p3r1CQdqveb6zksyGyOcA8bApOy7w5xWeuyI=;
        b=A5BqNi1dTdgkNXLh+mTckRLM3dbqZd4/c+7iJ8r2rIxqrnWea/dT4VyxehTMKiry+N
         DlEyfHLNP0rE1bUsseOhSdl1LTqHbVVObQhz+ZXd2Laq8uwRIKUEvOpilche+4h9FXNa
         Oc3PdkzJPmi3xJEMBEvTTAIrNOZe4uIplKbpDHKIqlMnOsOyesYRjI8WwG72r6AVSqzD
         IQrMBuSrfNDRJJE0OHnRo6/EoOCUKZnUcL0pQ9OPX6ag+2DnuNt62ExWlC2ys7ZH00So
         OZjY53RuJwCDlBI2Ar61FtboZwX4uJoqMGlmMvOE5dX1UsFHi/EePj9hjDrMiZNZI9VR
         LpsQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1BWAmtKg0jBf/PvNUzW3/2B8XXm5g0aHly12H5Am3/cE02rQWAUCl2LpA9Bc/PFVipkNKJAf3tkWu@vger.kernel.org
X-Gm-Message-State: AOJu0YyBvJxyPCcGWi1Oo9jQnsHWEISNQcBIMCJMPrGOx4EdRc84BcOm
	ncAmndjyiR/9mdRzI5NiRgEr8iRio02QoRLJVWhb49MKRMz8gedb0ksvCV6fVTs=
X-Google-Smtp-Source: AGHT+IEFlUS9HZa7j9xcyGY++HCqGOEfyB97DgCv7GhWWZbQEe1p+CsgndjS+K8M5Yt+8rds6Lr+jQ==
X-Received: by 2002:a17:907:f794:b0:a80:f840:9004 with SMTP id a640c23a62f3a-a9029407febmr278050566b.12.1726148625612;
        Thu, 12 Sep 2024 06:43:45 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a8d259c1fa3sm750257866b.80.2024.09.12.06.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 06:43:45 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: fix off-by-one error in sd_read_block_characteristics()
Date: Thu, 12 Sep 2024 15:43:08 +0200
Message-ID: <20240912134308.282824-1-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

if the device returns page 0xb1 with length 8 (happens with qemu v2.x, for
example), sd_read_block_characteristics() may attempt an out-of-bounds
memory access when accessing the zoned field at offset 8.

Fixes: 7fb019c46eee ("scsi: sd: Switch to using scsi_device VPD pages")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9db86943d04c..9513406ad640 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3404,7 +3404,7 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp,
 	rcu_read_lock();
 	vpd = rcu_dereference(sdkp->device->vpd_pgb1);
 
-	if (!vpd || vpd->len < 8) {
+	if (!vpd || vpd->len <= 8) {
 		rcu_read_unlock();
 	        return;
 	}
-- 
2.46.0

