Received: from mail-oo1-f97.google.com (mail-oo1-f97.google.com [209.85.161.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1949C35502B
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 18:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761761825; cv=none; b=TeKf22GlJYVQfOdhhkWomczVymPD7zZMYwnvHHCXK1J0ARN+vIAg5eqaBo+FUsfLjaQgNQn8giQzMHtqlBJEEfz+lbNIfTGbZOdzfH4R/xwJlEgEQlPK3cox0IULta/b6HzLMBJhMZA4ZO1xjEXS+NrgIDr553//8UiiH0XVbNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761761825; c=relaxed/simple;
	bh=DOg68gLEGfeOn4HU2jJr6ASkOLVPT+ojjHs0bENiDE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzaSQT7XtP5iSDPblB7omxr8u8YwVg4NDkY+5ZGsYHxJiVuAXM+6eaUMK8ngq04qR3m1pESv2V2EpO4BYlccHLriExRK7vlTma1n6L3aRD89chLDUaaXLTqeTf8B2qSz2Y+CSnBINYzah9KsnTxgCvH32XLLbOqSIQDZ8Qdjmtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=d6T3sMdu; arc=none smtp.client-ip=209.85.161.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="d6T3sMdu"
Received: by mail-oo1-f97.google.com with SMTP id 006d021491bc7-65682226579so23952eaf.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 11:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761761823; x=1762366623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ryj5cK1hzgSRzQXmCF4KMASxaB6lqRarCFG1dJ+jaes=;
        b=V6RKyzB0Mac8qyGUa7a217EnLgbs6n4O47yayyYFtwTyXp5EI0dFGx7LD5/TnEJtlo
         mKZ8G63fh7ftaarulUHGqzNgYXLh8WllBt0ktLWTmipTd8VsralQfZkOL3BUL/v7+655
         afoskWwpvC6AZ3zfYnhLmygTbYDmPDnRxmZGtmmcoky61XZ9pF7gvDzKV+gPmW2wa2R6
         6CMEck3b0x77+Q/GH7NR+xAMNJL17DVJii0ZZy3Lu/Ddno9gn8lFIwgDKAQVW+0QYhVd
         X9XsT86LK+0rM+FiTtqygSItJbbwMLqLcEDCXES5hV6ZoVqK02PTtZpjSGsLE1z7W9W9
         i58A==
X-Gm-Message-State: AOJu0Yy4lOP3SCQJLOLTankrchxazRYQYIBSB+hqf6evGaBSTn5Rp603
	zIYrW51AenUGil4z6TxSKLcn+ej46fPt6A7sBiR+OsSvi3WqcTrD+jZGVPWi7Wclx+zTED/Z4u1
	Ch5ONUlSjrJieUXX3qIrfWR+mAVEu9FB/s3q7hd9oCGpXgGugqkJgP0OdRVkoZ7EvEZqF4xM+GQ
	aCKmKrGVOmGW6L+W39UrORe6V2NkcHdtCnA2H2pXMcaGQW58O7RgPErgzHWxxZ9DsVczZjUQGw1
	I0k7S28BiTlIpdy
X-Gm-Gg: ASbGncs/b3dDkR73UIdpfkXTC1AhVz/jWX+wES/Xl6k9Hqx2QjkCvFETG+VYbNxaQiL
	DJPtyh8gtSHFGNLQMCHffIoH8j82rgyMYFuux1kAA9Zj9j5kdLSX65kzAlYbV+YJJGcwKi9UteB
	kGr27jsO3hz5v2EoV4wOBd1myFOC8SezL3lBxNblWq5gDAI0EyLbbvU23GGUnMKt905wOiObERm
	+jLm0qzmvIa6HHo255qI6qszoh45/XS1phW6edvWuViLhgAol4ug+cLs+/1BH8/intiMSqIfLNi
	pWeTbU9A8fThHhdlrSNRaCBXLOJJGR8uOuwRhYN2bMumYDRwKfArG0MdLkwaDRIsQNbDL2XFBG3
	N1oKF9pqnyJ5SxErZj6YW2lSYcAbfjJUFgjh+BYyqXVh73I0yjAhJIs6WcuZtgHMYJc5et6SZW2
	R19TkKwlN6pTFHHou4rN7Tpzq5I+9VpZ4GtYHj
X-Google-Smtp-Source: AGHT+IHQjNQh+iFbTF17h2v2M6THAjBOVsKnkjPGL1wY2iUfvWBX4em9mc54Acoy+j/8TggOhCX0/xfMyL8M
X-Received: by 2002:a05:6808:10c3:b0:43d:1ffb:1b08 with SMTP id 5614622812f47-44f7a457e45mr1796724b6e.18.1761761823032;
        Wed, 29 Oct 2025 11:17:03 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-654ef2ec1d6sm356286eaf.10.2025.10.29.11.17.02
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Oct 2025 11:17:03 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2904e9e0ef9so1989655ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 11:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1761761821; x=1762366621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryj5cK1hzgSRzQXmCF4KMASxaB6lqRarCFG1dJ+jaes=;
        b=d6T3sMdu3RCTfTLgjt82DED/CSvut8woli8G/z8A7n4v9clitIYCz4bAMrDNbScZzS
         ZBXs7xaNxS7g6Qlqd/nNbyJcQkDwWTJSspyD3xMaAd/Y/lexx8STBkE3wm3SVT9ZOR9A
         GxVrulZjRJZtvrFBAQHYhazfmvOZHJn5DlanY=
X-Received: by 2002:a17:903:1c8:b0:269:a4ed:13c9 with SMTP id d9443c01a7336-294dee9976emr51850785ad.30.1761761821138;
        Wed, 29 Oct 2025 11:17:01 -0700 (PDT)
X-Received: by 2002:a17:903:1c8:b0:269:a4ed:13c9 with SMTP id d9443c01a7336-294dee9976emr51850405ad.30.1761761820524;
        Wed, 29 Oct 2025 11:17:00 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf341bsm157284565ad.14.2025.10.29.11.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 11:17:00 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 1/5] mpt3sas: Added no_turs flag to device unblock logic
Date: Wed, 29 Oct 2025 23:40:45 +0530
Message-ID: <20251029181058.39157-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251029181058.39157-1-ranjan.kumar@broadcom.com>
References: <20251029181058.39157-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Add a "no_turs" flag to _scsih_ublock_io_all_device() to
optionally skip TEST UNIT READY (TUR) checks while
unblocking devices. This is used after broadcast events
where sending TURs is not required.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 7092d0debef3..ecef13de3bba 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3829,7 +3829,7 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
  * change the device state from block to running
  */
 static void
-_scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc)
+_scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 {
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
@@ -3841,6 +3841,13 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc)
 		if (!sas_device_priv_data->block)
 			continue;
 
+		if (no_turs) {
+			sdev_printk(KERN_WARNING, sdev, "device_unblocked handle(0x%04x)\n",
+				sas_device_priv_data->sas_target->handle);
+			_scsih_internal_device_unblock(sdev, sas_device_priv_data);
+			continue;
+		}
+
 		dewtprintk(ioc, sdev_printk(KERN_INFO, sdev,
 			"device_running, handle(0x%04x)\n",
 		    sas_device_priv_data->sas_target->handle));
@@ -8810,7 +8817,7 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 
 	ioc->broadcast_aen_busy = 0;
 	if (!ioc->shost_recovery)
-		_scsih_ublock_io_all_device(ioc);
+		_scsih_ublock_io_all_device(ioc, 1);
 	mutex_unlock(&ioc->tm_cmds.mutex);
 }
 
@@ -10344,7 +10351,7 @@ _scsih_remove_unresponding_devices(struct MPT3SAS_ADAPTER *ioc)
 	ioc_info(ioc, "removing unresponding devices: complete\n");
 
 	/* unblock devices */
-	_scsih_ublock_io_all_device(ioc);
+	_scsih_ublock_io_all_device(ioc, 0);
 }
 
 static void
-- 
2.47.3

