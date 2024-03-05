Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32B812B71
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 00:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599883; cv=none; b=a0xbpc4a/z2bRSa8zeyW1QJbx9Ff50HYZJfbMYGgjnxrAk1TWHk4ev7K3wy+izyq54SBz94JAK2BgwQKdsay2KgLqFs3cdndZpE4foksCC70QlKq94tQvyue536CpNZ5uIw6KnQuyLw/HmSfhglckZHRWL1tO7yq5RRe6T/2M4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599883; c=relaxed/simple;
	bh=l1B7DL+QxZKXAInqPgoxYQhQfMm3hZjNqcIgYcFRiA0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eXmnBzpGzhkFCc/rH32QuMxWpo4H8Qz+uo71iuA2L9Ub6zC4xiPfBYwwEf3/HkBWJ2fPBuGw0ohI2mFwjC/16JfNGhlMFIDNYlyMJYENVn1vkSHESfd9ylsDlNnlXLAF+nBJ+Aq6zw+jqUzT7RDhxPQvps0IUH86bgLo9+3ax7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ln1VZLKu; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ln1VZLKu"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609a8fc232bso22000777b3.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Mar 2024 16:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709599880; x=1710204680; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/rSrKaEP0cu2EEhDxf63kSlEB7iQAh36Fr8Ir9gTxu4=;
        b=ln1VZLKu5+RmXA1sFmdN5RLOFSeHEvBQQuxNFPSMvRvaOrd0Pk4eLH082LtqedwjXJ
         9H91dKjKnun1LO9vq57Xkr5j2VjJ07C5pkiDWieMvRYt3lBhAv0hNJNffY6yz+ZLgTai
         DNWjUluuL5AsxpqwO9IpLg6FSsLdr+ynR1DwGcEN4K0subUdDnBM9TrlquJrFNxzOkI9
         rprR0cVzZDWvUbVmh1HVE1Ng2o0sSOJE4YSh1HJI0CjudrtbVI6qcqA+Ee5eKy8Mx2Q5
         shdvR3IMqByi9uCkYIZ8zqPq3lf8zeQQ7r+h58i8DYbCsk35g39fmSTJsCyyfPXTkxBf
         /BLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709599880; x=1710204680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rSrKaEP0cu2EEhDxf63kSlEB7iQAh36Fr8Ir9gTxu4=;
        b=m0cU6sLrJMugASFIHJY8I6IDjuZfK3UcVhesxqYY6Cg9NCTDICB1lOHOCzeev6dttK
         dhK5BsHlrMPERmWEvNtekJpPAtKyg3Ao+QoGpaN+LnCek4OirPNPTIxQA1hh80hXos/5
         +uaBunZVz3ud6cTvVvxmf3UYmuQbrQd1Cgr9LREhxsJEGUyzdX/WblQlgSQiDs0R29pB
         MyHFB7Q/9DSJCGDadTYFIvIfmZrthAjrViQI7VjD5P/olvol7FegiwC/mvMewAy1ZoF4
         BuPlo5LKUULlHJ86lmTuw/T1b3j3loj1BVEWxoRe7EepkE1zdYz8DIw9XHOz1XTqMQ+r
         ky0w==
X-Forwarded-Encrypted: i=1; AJvYcCXtrTGdb+AWBYvNFEFMtO6aYMq6w4lgi0dRTIB6/S3Po0EBxWQ6tI2wSXt9Ss2OwaA73300RQRBMHrY2bM5IUnjSH6pnmFQ6yiZrw==
X-Gm-Message-State: AOJu0Yx37aE2ix/9acotb+LldDc2lUspkHwtwWdfxMGuaw5V1a3+SQOe
	Eq/D9qvcpK+lysPXDUJquI3tQteeB1hGay1WEVLpvHn7Cbrjd5Fl/aflYIcJ8VgJln46yaMfELW
	HyJMwnc9gLw==
X-Google-Smtp-Source: AGHT+IH0taBqeMsbYKpUMKAKLG8w3t/pn1bQnH1/UJUTTJL6q6kvljHPQbPcYP7rtlwNxzaYSsc13QQM44B3KA==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:e901:e760:20cd:d870])
 (user=ipylypiv job=sendgmr) by 2002:a81:9a05:0:b0:608:2ad5:cd28 with SMTP id
 r5-20020a819a05000000b006082ad5cd28mr2227317ywg.4.1709599880122; Mon, 04 Mar
 2024 16:51:20 -0800 (PST)
Date: Mon,  4 Mar 2024 16:51:02 -0800
In-Reply-To: <20240305005103.1849325-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305005103.1849325-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240305005103.1849325-7-ipylypiv@google.com>
Subject: [PATCH v5 6/7] scsi: aic94xx: Add libsas SATA sysfs attributes group
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Hannes Reinecke <hare@suse.de>, 
	Xiang Chen <chenxiang66@hisilicon.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: TJ Adams <tadamsjr@google.com>, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"

The added sysfs attributes group enables the configuration of NCQ Priority
feature for HBAs that rely on libsas to manage SATA devices.

Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 8a3340d8d7ad..ccccd0eb6275 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -14,6 +14,7 @@
 #include <linux/firmware.h>
 #include <linux/slab.h>
 
+#include <scsi/sas_ata.h>
 #include <scsi/scsi_host.h>
 
 #include "aic94xx.h"
@@ -34,6 +35,7 @@ MODULE_PARM_DESC(use_msi, "\n"
 static struct scsi_transport_template *aic94xx_transport_template;
 static int asd_scan_finished(struct Scsi_Host *, unsigned long);
 static void asd_scan_start(struct Scsi_Host *);
+static const struct attribute_group *asd_sdev_groups[];
 
 static const struct scsi_host_template aic94xx_sht = {
 	.module			= THIS_MODULE,
@@ -60,6 +62,7 @@ static const struct scsi_host_template aic94xx_sht = {
 	.compat_ioctl		= sas_ioctl,
 #endif
 	.track_queue_depth	= 1,
+	.sdev_groups		= asd_sdev_groups,
 };
 
 static int asd_map_memio(struct asd_ha_struct *asd_ha)
@@ -951,6 +954,11 @@ static void asd_remove_driver_attrs(struct device_driver *driver)
 	driver_remove_file(driver, &driver_attr_version);
 }
 
+static const struct attribute_group *asd_sdev_groups[] = {
+	&sas_ata_sdev_attr_group,
+	NULL
+};
+
 static struct sas_domain_function_template aic94xx_transport_functions = {
 	.lldd_dev_found		= asd_dev_found,
 	.lldd_dev_gone		= asd_dev_gone,
-- 
2.44.0.278.ge034bb2e1d-goog

