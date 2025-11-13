Received: from mail-yx1-f100.google.com (mail-yx1-f100.google.com [74.125.224.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6282F6906
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 15:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763048595; cv=none; b=M2lrZrp4HTXxWS6k8E6Ig2d2xrBNuNZDAfBfCck3KT+zBTzM6ADQRH+VcCQBsEeB5CHkbjostnU9GnlG+aM/mi6zdbjH6hKMe84BSGIRCQZm92S3cILEgkOZqQpZonQfPGcLly46zbhnrjwxGQcqcXW/HTdADfmvedo/V4+RwTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763048595; c=relaxed/simple;
	bh=U6ah0bBxoi/XsdVmC4mTjhn4CkUiyOzbqoMmJbo7x5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kN0Sw7xjaPQTfclBqOCvxi3vksp7mCons2P/+kUObaJVJsru+Im968/Q/161QQtlQdedpOpcFsSXcVuGCtI490zYWD1bEK7SrCFtzlrh1gvLI6zKyx0dOqMSJwyNc137bN3R0gkkKzUsPBIVe9JStEmCbI6VKypGX4OrOEbNCU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fgnkb9hx; arc=none smtp.client-ip=74.125.224.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fgnkb9hx"
Received: by mail-yx1-f100.google.com with SMTP id 956f58d0204a3-64107188baeso872184d50.3
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 07:43:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763048593; x=1763653393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OCfibRyTIz7Q0z8nNj5A7CSDLZ86SBMfVD3UUUGKDZA=;
        b=JK3BLdBkiDl3KujdH8xmLSE69ud5xWpOO2LooCevA8+mHWbiuoGc+PpmXk/4u/IdYw
         a6v0ZMzblgwk0TImm3PkgW+Evvutwe26JeAvJz9o8RLwECxWB9lrLoIak5q239R8lir4
         LQz/Fko+d7A5DuZAPfeaooCUVia/qCMePFHXyaZBWAHRsT0mqau5t8SPnKEHz/0Pwdmq
         B+IQsueCQdI6ORWZp+WrkAN9RFE4HL3rR5UgfgujZFx+wai11woCaaMUEbDihzmYx4Vi
         IC1h7YT3TlDrMvrbER2BzYJ1N5r35KcfKf2HtkX6mvrATRLcMFGS+nUg2YE8GhgqFAQX
         xJCA==
X-Gm-Message-State: AOJu0YyEn5LeuT82ipywAhxz2LSU62k6SPQ1PeVpKjQ68jdKIB3JmWRY
	XQEW5NAeKp3l1Wu7md9vPV+DLWdF4RIlKbOMYGda+zLamAp2fHVacugnz2ItEr/5+d1z6o2lVct
	VmNjDXIkSo6UUIMlrzLKZpxmQrimrIMtKYvCwJcw4cI1t9Kh48a5pXf+UPMcG4RCUXYzCwFt4Rm
	yYkl0iYRp2eHzsBrPx8IR5fXfMhnzVi/M6bh4s2n+f1D5Z/1h6aF11Qaiyk+rxvvCVv0z71Ibb0
	NxhZo0Enc9B4G59
X-Gm-Gg: ASbGnctPMzc71V7mrUbzjX4X8tdy1osppUvg8bKzuDmmsks3xTMYe+lcKIRWxTHIYFn
	LIbnLhkd9GLKTtKhbcNy19SFirTFzQ7YYOlgwFcxdtPChNwOu4d2jKQtVx/SkPmhEiIIu4i+Y+M
	tThDoa88gknA+W/ha0V5yqWnz1SdSHSmml8tlc7Z8MWLzPUTrKjaIgPJVWECZDST51zQzyT9mDS
	txaPN0Gh21AEuUiPYW2VVvK668pGpGToagXkQCZlTjN2Ds/bN0K3h7sI/ci4Zmltd4IYaWBmZLQ
	xBLY+nh1OnZ/i0iAtSpHNcL0WG4ETyTL7Gm7WhpV2sTBesDu54KDc972BnPAF6+ZFIls/b0PBAV
	HJX8FjvL95A5025zsrt8i7XupR7RdmrNstlgNCkih3kj238qbJQr5xfaOUuiAD+rFobemwtMANB
	hY8Ib3xIOHfhGOv5CSrx1/lcO8qpvK5KdzGg==
X-Google-Smtp-Source: AGHT+IEgb5YJiYxFjs3RTqRgr1/z7oIR/oSeZ/W/F/3MaGUlfuXfFiraCk8kzLbayqR1X6q2ONlFEJkPyXW7
X-Received: by 2002:a05:690e:148b:b0:63f:9c56:96a with SMTP id 956f58d0204a3-64101a0143dmr6349278d50.5.1763048593106;
        Thu, 13 Nov 2025 07:43:13 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-14.dlp.protect.broadcom.com. [144.49.247.14])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-6410ea165c0sm179811d50.7.2025.11.13.07.43.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Nov 2025 07:43:13 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3416dc5754fso1353902a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 07:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1763048591; x=1763653391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCfibRyTIz7Q0z8nNj5A7CSDLZ86SBMfVD3UUUGKDZA=;
        b=fgnkb9hxA4Z9mYTUO4AN/gnTU/nQ3ITeJ39LIkLp3DUeSH7nNx8/p4md7LWN1EFsMu
         9pSu4BNj/Hh0tYgZEA9rPASwtgon1RiHfel4aVs98ID4c9CvJhWmq4rV4Z4WKoG6KAXc
         71FlJfc13/E3Pzz7ONwRh+Bk2pI4AQKpNKlAQ=
X-Received: by 2002:a17:902:d54a:b0:298:3aa6:c03d with SMTP id d9443c01a7336-2984edf0dfemr92683155ad.57.1763048591472;
        Thu, 13 Nov 2025 07:43:11 -0800 (PST)
X-Received: by 2002:a17:902:d54a:b0:298:3aa6:c03d with SMTP id d9443c01a7336-2984edf0dfemr92682915ad.57.1763048590940;
        Thu, 13 Nov 2025 07:43:10 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2cca66sm29100085ad.99.2025.11.13.07.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 07:43:10 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 2/6] mpt3sas: Added issue_scsi_cmd_to_bringup_drive module parameter part-1
Date: Thu, 13 Nov 2025 21:07:06 +0530
Message-ID: <20251113153712.31850-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113153712.31850-1-ranjan.kumar@broadcom.com>
References: <20251113153712.31850-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Introduced a new module parameter "issue_scsi_cmd_to_bringup_drive"
(default=1) which allows overriding the driver's behavior of issuing
SCSI TEST_UNIT_READY/START_UNIT commands to bring devices to READY
state during unblock.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 013b10348ec4..17f5d6da634d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -159,6 +159,15 @@ module_param(enable_sdev_max_qd, bool, 0444);
 MODULE_PARM_DESC(enable_sdev_max_qd,
 	"Enable sdev max qd as can_queue, def=disabled(0)");
 
+/*
+ * permit overriding the SCSI command issuing capability of
+ * the driver to bring the drive to READY state
+ */
+static int issue_scsi_cmd_to_bringup_drive = 1;
+module_param(issue_scsi_cmd_to_bringup_drive, int, 0444);
+MODULE_PARM_DESC(issue_scsi_cmd_to_bringup_drive, "allow host driver to\n"
+	"issue SCSI commands to bring the drive to READY state, default=1 ");
+
 static int multipath_on_hba = -1;
 module_param(multipath_on_hba, int, 0);
 MODULE_PARM_DESC(multipath_on_hba,
-- 
2.47.3

