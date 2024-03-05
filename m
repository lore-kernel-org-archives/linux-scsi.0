Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBED134CE
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 00:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599884; cv=none; b=Q+XNUnPUW5il7q7hdgQW3AxyjVeqBu8de7TjjhE6XR1VIGHRAauVzOqn9MccD651QVbNCgd07QVDB7QflOVY4Ku9vpnIyVrAMvFREF/E7mQTAB8gfGjNm3+DwBYidN53pzAZ7Aw3nTS7v1mOFslvkG9ZtOaC3Sgq6BSTuQVvaoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599884; c=relaxed/simple;
	bh=JK5ZL4PnU5QeI+1YMzB3uaBk//5D5vcBBN1SI7nMnwU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cVeqiuY5/zVT9nubPLDmN75E4r+gkiR1DDbUN0uZugvbOdqDLjqHx7cHfV9Z6RhBp3rOL0EBhaRwPmgaQSih7MVUhGWcWRSUGJxN6S9Nev+4cRSVxz88P96GTdMFCB57Uy/sFAqz9VEIOGGfW6HPItfr1Y+ZaLQfptr6WNWXyf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zGTq+ph1; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zGTq+ph1"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc64b659a9cso9343712276.3
        for <linux-scsi@vger.kernel.org>; Mon, 04 Mar 2024 16:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709599882; x=1710204682; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uY5VRSDJS+IotGAZM4PBm3CjluNBdRiBTTCOlg+57LQ=;
        b=zGTq+ph1Gt70cMez1/KmQsCju6MOn1yHDUKz8BGOzj8khX4msGBh50eXZTILZoQggV
         zNzK8E0InmCpWO1aodtcdShw2yyxFs8zuUCTOHuaCe7TPdTz4UcQ8Ne//PEqeS/ZFvmU
         /r4gQIpgdnK3ooK+gyRibZ10mRWtX2DMs0U1i9ALw3D4Wgh6n27Sdtq193dLc0gaepCF
         2yzPFl7O5jn3RvZ7Ki0LAI2uvovNcfBc8RALvq/TZqUzPXYR3dEYS4cnv45MpuMNocbC
         gLsp/Fa5YlMx5vnXamD6HO/GHCz0dppimHbdYcIgLuP8muVILGcyuDMLvWy2iWPdEZWS
         clAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709599882; x=1710204682;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uY5VRSDJS+IotGAZM4PBm3CjluNBdRiBTTCOlg+57LQ=;
        b=VpsGGH/2uxvLi1PvwZjIICnHtsosnWr6uNRD5B7MoyE1TNJLB4ldThipnT/SCZzm53
         Z8Yxl1dxDtfFvLmp0HkAptuNbf8xURt9i2viaSpT8srtKB7BaNHrrKmwqidRP9xDTPpq
         Yrwshz+bJtBT1KEkTF54fvvTpsp6Ynhnr7U8MfClj1NnexSt3qgpQyKPFRSQcyCdegHi
         arRdgqA5fh/QtuIkcehubPZxWTuuf7osPYtqYiz4rmmg0LabJQmfKMCecSMYxo4vTlHx
         Q87vhXSGwSmlP0gcd4tEgavjwVzrDXQNutalyZW5kPSxxZEQ0S+yeHoGi0Vjx/O5dMvP
         jKlA==
X-Forwarded-Encrypted: i=1; AJvYcCV/ZmrrLFgmWv+NAboAc6o5Df072fLh2I+44v82kbqfkqbftXOFOLF/VJWsy9iiNXL5EO8pKY8KnWsTRV84iyBxH6iMzaR/aOtEbw==
X-Gm-Message-State: AOJu0YyDbMl8AeilSERnZLGwx2MR11ECZIivrvlTJ/CZI0CVihjd7Jct
	d1dxuU5p29m/Y2bL7bzMrb839ygM3j/qweyvD/hVXdm06egyv5kDin10hWiEvabEG8FIjM0ziOV
	fAC2Ld8JjzA==
X-Google-Smtp-Source: AGHT+IFlhgHHWVA1TkUHFLU46HuPh9Pm+a647sbF3wlljbxMV51Ln2wZuV9e2Yf7mOeLRXIgQSgT+g4jkbhtQA==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:e901:e760:20cd:d870])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:1885:b0:dc6:207e:e8b1 with SMTP
 id cj5-20020a056902188500b00dc6207ee8b1mr2710413ybb.2.1709599882317; Mon, 04
 Mar 2024 16:51:22 -0800 (PST)
Date: Mon,  4 Mar 2024 16:51:03 -0800
In-Reply-To: <20240305005103.1849325-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305005103.1849325-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240305005103.1849325-8-ipylypiv@google.com>
Subject: [PATCH v5 7/7] scsi: isci: Add libsas SATA sysfs attributes group
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
 drivers/scsi/isci/init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 6277162a028b..8658dcd61b87 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -149,6 +149,11 @@ static struct attribute *isci_host_attrs[] = {
 
 ATTRIBUTE_GROUPS(isci_host);
 
+static const struct attribute_group *isci_sdev_groups[] = {
+	&sas_ata_sdev_attr_group,
+	NULL
+};
+
 static const struct scsi_host_template isci_sht = {
 
 	.module				= THIS_MODULE,
@@ -176,6 +181,7 @@ static const struct scsi_host_template isci_sht = {
 	.compat_ioctl			= sas_ioctl,
 #endif
 	.shost_groups			= isci_host_groups,
+	.sdev_groups			= isci_sdev_groups,
 	.track_queue_depth		= 1,
 };
 
-- 
2.44.0.278.ge034bb2e1d-goog

