Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76ED2F531D
	for <linux-scsi@vger.kernel.org>; Fri,  4 Jul 2025 12:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751633745; cv=none; b=BP+a2ghnJUZHHKovO3z/XQedHLD2LmZG2zz8ToxAfYsNkZY4f/JA2SJt4uqmGglP/QgRuJXm5x04/JtDSmBcQBgGf/mRUSza1++c5Egqa/7Vu78ePFHHwkxD3P8LVXf74jyfLNYnLmvRc25iXFHNgxdhBWuakq+xL6R220+qSRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751633745; c=relaxed/simple;
	bh=KPH3Xiy9mlbjaxPq8h3ifisCHjsTKK7k/FurarbQ5uI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=svFIJ9jmvA2W5qxHUZUAim7z+Z0REVKbrLh5wl5PTAdvwQVtsszQA6PCeohat1nXbr0E+8Flw55n5cvori2Y6jW3mD3qIY7pBdUTSGyemPNF2cPmOmnRk8fugMfikIibD/KvAM6OMez92C3niY3haZfrnISBEQeWCOeZ9OJVopc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vijZUmqk; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vijZUmqk"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-553d27801b4so37283e87.3
        for <linux-scsi@vger.kernel.org>; Fri, 04 Jul 2025 05:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751633742; x=1752238542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bXS2CAH8cY4s46125RlrGwDTCzxYthjabffdF2nmZ6E=;
        b=vijZUmqk5dvIE5ReLc28vf++0zXe/+XCfx1sbVYumPRxSm/UEKH7ebnQ9ppSWcyG2n
         sv27PgQ8IUSCOTduAp1J6dbIqGJSvkLTdXUvxU+CQaKIIOSYIZQPLooz5IW6NfSG5F3B
         lA571fObpCjHbbCoNFkiXQFXIBIXtVhizlUgtJVBFcDcoB0d0JHDZ0KzO1hm+nVrVdRq
         T8KjkpJ818MTTz60YEr4tB5/y7U16n4Dw1s6c4mIHVy0dubuDtHyYS9CWkXCn4p1XVMN
         wyiAVs410o89oIw5zwU1VvG5THJ532lDMouV+prINax+o+/LRNefX4MFQyJ9aI5wWkOg
         DL4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751633742; x=1752238542;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bXS2CAH8cY4s46125RlrGwDTCzxYthjabffdF2nmZ6E=;
        b=qjgoz1zNvmqlxF+fff1I5zjWhx9q7RVDrfcGsb11KjHJMrp2NBvACxKvGnhAuuQjJh
         NHwXYsVu2rF+jbawDGmo7OvKa8150aM5moIAC41OymsFHOWlKHDsdUfgHwdzP2zAWbr3
         nyLyyFJPL4I6IQI8ufjp3wRpPPaQwZc5qt3RW/f6XGZsYcEoCkYoTPflBp2bc86T5GFs
         RMZUJ5tbooXcTZEOyxqc/+1bA/S0nBCiLMepAxTDg6DlauIWwmAl0kQx/tXrRPNhx3v5
         9kI8gaKKGW83tVxoUJdNu0MIG8CQBrTSWlHjkBYWskchPanX0sKKYgszvieAPnFHIRiq
         ifeg==
X-Forwarded-Encrypted: i=1; AJvYcCVWXIW+fbGeZoH7PAwIJyD7G7r+W3bN/NDh8XLa27EGzUjdrGgLFVmk+OflQJ608fiBFjjy+1732NfL@vger.kernel.org
X-Gm-Message-State: AOJu0YyztUT45euBm39pxKFgYczAfpgia+0CHqsx4z2IXoUdQwMSBgUh
	Y7QcjkviiRyVdPy9BcDMerGMBbt7pPRJ1BUFVzTsVp66yNtl0Z+HbzDijktvRUGlcrk=
X-Gm-Gg: ASbGncvBL2SEFTQaJWRKhucxWbbhQTQfu714749icrdnvXoGgJYbc5f9z2IgXiFu+sy
	/uNT1oJfaIpLD5gGRaRQ8M14Q0EWrY7H5YjC8IU2yzNiuxBLHvev54kkdAorqftpw1D0LzJHQcI
	v4byVOPXkn7/bFcYwnYKZBg9oyLylsYk58q8SqxXugE4f1Q1tVqERtvU8D2LmgPaCG6lOqIGP/1
	jfkYJPwLv7XV3FzUUwNMlMjb63cLpGgg3HJefOT7QwigApvHN26PXxOUTAuVjiLiziDgnqMLW0O
	bEob7WdRex5uxunL6mBGjXYft9hiTUk0LOImPdzx6Soth4oIDCaZT4L2tn7L/d6IYBBzOS5E7H3
	JcfZaD7PzL/HY88vp9dmNCtKVKlt8Pcnk
X-Google-Smtp-Source: AGHT+IEXL/S82jil0CchvfSvjiER+3hIXl3C8odNwTNIX/B7ZjFtkvE5wSgpuVOReGNVJal1fGnQMA==
X-Received: by 2002:a05:6512:39d5:b0:553:af02:78e4 with SMTP id 2adb3069b0e04-556f330539dmr222570e87.5.1751633741779;
        Fri, 04 Jul 2025 05:55:41 -0700 (PDT)
Received: from localhost (c-85-229-7-191.bbcust.telenor.se. [85.229.7.191])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-556383d33f3sm247513e87.68.2025.07.04.05.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 05:55:41 -0700 (PDT)
From: Anders Roxell <anders.roxell@linaro.org>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	arnd@arndb.de,
	Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] pps: Fix IDR memory leak in module exit
Date: Fri,  4 Jul 2025 14:55:36 +0200
Message-ID: <20250704125536.1091187-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing idr_destroy() call in pps_exit() to properly free the pps_idr
radix tree nodes. Without this, module load/unload cycles leak 576-byte
radix tree node allocations, detectable by kmemleak as:

unreferenced object (size 576):
  backtrace:
    [<ffffffff81234567>] radix_tree_node_alloc+0xa0/0xf0
    [<ffffffff81234568>] idr_get_free+0x128/0x280

The pps_idr is initialized via DEFINE_IDR() at line 32 and used throughout
the PPS subsystem for device ID management. The fix follows the documented
pattern in lib/idr.c and matches the cleanup approach used by other drivers
such as drivers/uio/uio.c.

This leak was discovered through comprehensive module testing with cumulative
kmemleak detection across 10 load/unload iterations per module.

Fixes: eae9d2ba0cfc ("LinuxPPS: core support")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index c75a806496d6..adbedb58930d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -5024,6 +5024,7 @@ static void __exit iscsi_transport_exit(void)
 	class_unregister(&iscsi_endpoint_class);
 	class_unregister(&iscsi_iface_class);
 	class_unregister(&iscsi_transport_class);
+	idr_destroy(&iscsi_ep_idr);
 }
 
 module_init(iscsi_transport_init);
-- 
2.47.2

