Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D24134BF
	for <linux-scsi@vger.kernel.org>; Wed,  6 Mar 2024 01:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709688159; cv=none; b=T1K0Zvato9rbrMIRGY5YlGx4Nn/JiNu2hZ+cMOVenaU6MCwbULvZBnTDDFKF9zWdI01xIV17T4OLB+QE1nPr2KqUyBXYxxgjzBZuwiWJmQY2YkD/D32+TFqYrKP1dUgvzKtFfUj7vHbCA3nP9j5aRla0ZFY+IAEdrsitBt78O2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709688159; c=relaxed/simple;
	bh=eNWF6foC4RAjM/7mIBIDm6Ws+q1aoKRiMrqNZ34dkrM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W2RbdFbcHzNyT5TEJC4jaznuHWIjPK1UXzM8/+dHjxWg66miJa9ISxdP9lFEJaXmo81qUHVDhXpNZ+Iy8oERNn8F+S26rro09oNxl4LoiPE4KsdVfhfJ1Mv7b/6uJE7STbrbcQJyHiwjdKJFpJPQjl49hc1XxTxj4rizA1ZoeQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rh1Aqv4e; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rh1Aqv4e"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-608e88ca078so98214437b3.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 17:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709688156; x=1710292956; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=djrkg2o6GYfOpuFfrfroOSUyfmqyZMD72kLam/QnMds=;
        b=rh1Aqv4eXPnrUGTyaL7W06vu5m5oG0CNiB3SW4g44mFwWDT14P5qotLkk5hmi/D6z6
         Nlr3btXAN0858M79zia9hPseaUzkmPo6xGgb6hHgzKAOU4H4OC5UdUf5hWRaWy4ijF+D
         NvjZN5J6okVSrUPOrFgqHJ10dCXQnZ+6ruAOCYPkrDPf+SSNkFNd8HLcLuI7J8pFMweQ
         bgPylctqGzYrUle3WYoWv1VJYzCNWoNRCvy06bJtmUzlk/QmyZYL2IyCr5xKBt2VCSbZ
         3hZioJJloYy1cSdQJjPp/97h+zH1ViB9+tJjiZzCPCsheG6fDEatEnEl87B7zq3iITW8
         EZuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709688156; x=1710292956;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=djrkg2o6GYfOpuFfrfroOSUyfmqyZMD72kLam/QnMds=;
        b=nP9avNsYG5+/bo4YlMkUBSsQ1RJnW4Fn+5ORhqBajwxYwK/llkBoNoUsCAGKo2FGv9
         ezg6jahPvHFmCt6nGaMd02q17zRCTvFfqXWMaOBun3hzgQn9OEs7nAnfwVC1U1wkf6nD
         TrgBbm1hMYcoD8mQTvn0QydVSzSOu2HoRmPeTYN66TYdXCdPdHE0Ltikfxr8NPgNL5GR
         Fa/1a5DqjsOz93lkalkXkdpypZSic5vcsqyZJmdeKDWmHCRfA7cxs55ddJ8jNPbIPyxI
         uRR/JJWsZcVNgrHTKxBE5+gWGS0tVRz5IsZ/Bb+ux+pnOt8TaC21yVLgOAavyR2MJdee
         LVWw==
X-Forwarded-Encrypted: i=1; AJvYcCVS5P/gs7Hy4UnNc2WuFFsHCtXt1Luzypn6yba2i5E8PO4niYBgcNq1KKNk/Ip9wwhzUY9qllkrOzemIS1TQer+1iMHloTp2X6Tig==
X-Gm-Message-State: AOJu0Yxls43W5JV2iNFAdyCLcJLnhbzqJOARHIItm1pycp07pB/T7l/z
	gA5v2WOxf5A79cru7DGvAPPcO2i8vo9wEodp7mF357J28XnxhomEfCEq7vA22LJoKWhgLMriyOv
	/iZjjCC8uvQ==
X-Google-Smtp-Source: AGHT+IEghJ9PK/cUoNltMVXmRLwQJyqnNza3sX0GvOvMSKx9Y/m0pcuh+FPl6LfR7gKE5mmkr4x2Cht5mrrCRw==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:69ff:df2c:aa81:7b74])
 (user=ipylypiv job=sendgmr) by 2002:a81:9958:0:b0:609:1fd9:bbf with SMTP id
 q85-20020a819958000000b006091fd90bbfmr3386990ywg.3.1709688156555; Tue, 05 Mar
 2024 17:22:36 -0800 (PST)
Date: Tue,  5 Mar 2024 17:22:22 -0800
In-Reply-To: <20240306012226.3398927-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240306012226.3398927-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240306012226.3398927-4-ipylypiv@google.com>
Subject: [PATCH v7 3/7] scsi: pm80xx: Add libsas SATA sysfs attributes group
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Hannes Reinecke <hare@suse.de>, 
	Xiang Chen <chenxiang66@hisilicon.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: TJ Adams <tadamsjr@google.com>, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>, Jack Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"

The added sysfs attributes group enables the configuration of NCQ Priority
feature for HBAs that rely on libsas to manage SATA devices.

Acked-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c  | 5 +++++
 drivers/scsi/pm8001/pm8001_init.c | 1 +
 drivers/scsi/pm8001/pm8001_sas.h  | 1 +
 3 files changed, 7 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 5c26a13ffbd2..9ffe1a868d0f 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -1039,3 +1039,8 @@ const struct attribute_group *pm8001_host_groups[] = {
 	&pm8001_host_attr_group,
 	NULL
 };
+
+const struct attribute_group *pm8001_sdev_groups[] = {
+	&sas_ata_sdev_attr_group,
+	NULL
+};
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index ed6b7d954dda..e6b1108f6117 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -134,6 +134,7 @@ static const struct scsi_host_template pm8001_sht = {
 	.compat_ioctl		= sas_ioctl,
 #endif
 	.shost_groups		= pm8001_host_groups,
+	.sdev_groups		= pm8001_sdev_groups,
 	.track_queue_depth	= 1,
 	.cmd_per_lun		= 32,
 	.map_queues		= pm8001_map_queues,
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 3ccb7371902f..ced6721380a8 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -717,6 +717,7 @@ int pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha);
 void pm8001_free_dev(struct pm8001_device *pm8001_dev);
 /* ctl shared API */
 extern const struct attribute_group *pm8001_host_groups[];
+extern const struct attribute_group *pm8001_sdev_groups[];
 
 #define PM8001_INVALID_TAG	((u32)-1)
 
-- 
2.44.0.278.ge034bb2e1d-goog

