Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6612614DFE4
	for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2024 22:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708726999; cv=none; b=fpLKPCRzcy5MNAK3cpO989riFJVGSvs0FJ+Ne6bJe86OuLH9N6kKVncZWNI6jOwVh0vroTcBDX2s4MWJkUFY6xiN/Cs6x4lV2Z3MsBRljqWp+xq+a7MAPyeRMHAeF/ndX8H0OA32av4B7lHsjLMb4BuazSIIRsP20r8WT5e3ntM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708726999; c=relaxed/simple;
	bh=gjMkG4A6VKeg8L3wOX72tlhUgkPYbTyo8rC5lCzc/xc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DMV+N1x7M20b87Rz8tlkijpPex9lDgHE85lG+Q5OI5dTu0Scq9LukHsJLZXzbNH76gDT7b3WLSQG6mW50guZx0KEqvR4cYXwx2+7O64rZN3o2v9MMbFKbytciD4ySnB0YyH29CYxIgb5NW+hxacaPfPkIyuoLXaj8vZzZ34OngM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KWxIKhT0; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KWxIKhT0"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-7c3e3ac59b3so63914639f.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2024 14:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708726995; x=1709331795; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UGEZep2bi/abyYM1QXV/FReUH/n6RMxu5K38G5FIyYk=;
        b=KWxIKhT0fRhVF8s2zQFumrUTDw6tJAlMeyzj7ataVDkALYx00Ltdi7nKB/UXHkniV3
         yJct18O7sZdpxFYYqEGNT1zbF0wI8K9HHP8u0ODnqhzBBKHn962jVMAbbZ/uaPTAE7wX
         eiJO2QdqEPy3SgDbw67qvSThjQPnRxFMkm31XXWnPYiMuce+9+m6OjikUp7H9FZ+nYHC
         aGu4FpdadUvXYoPanfkSUjqNGaXCOShSkYvuKBevbJuwZeYp/lk+x7tn5gdvr3TJ3CMp
         Hfd40zmNp2AJGeg8xN+eVmqwq0hxUdqDuw8g93NBMKHV71uEsgn3PwS5vLJ4oWGi2BQ/
         wcLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708726995; x=1709331795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UGEZep2bi/abyYM1QXV/FReUH/n6RMxu5K38G5FIyYk=;
        b=T6aSSaEMR5m8v/Sho3BqELktLDj99R6qtJ0pHxAGjeimdgzVdTbPb2Dar8ZAj0xIvR
         Xb/dNwCoW+jCt7gMF7Mwl0jbAWPzsj4sTOwXFx850i6WQQ168Io/8ZwcyMaTnOrCyxfJ
         xnRWsrD96yISZzR8XOS4tZlnBCEnxc1nW7aVRhWAFbMPscw0UbU2El50DrYqIrfwLBav
         V/ms5xWZH0vAccZ+6/OQA0uGEJF97w1PyXt4Cb2oayC5XGEQKCWpfIRcj2SmK+3sxEFj
         o5gFsYctmYZeKxFUCEyxcHRqfXgfl981p3zJEZ9dKXmWzC27kPG3STN6StJ3HDUDVNvJ
         76WA==
X-Forwarded-Encrypted: i=1; AJvYcCWhu4l48CHs/fYL5esuuIijzkG7slJAhqfCkpLEe6+HIX0hsP1FYY32M5KoDyBzijaMrJQRb0zgdCRkwRb+uDvO48jK6wLNVylZsw==
X-Gm-Message-State: AOJu0YwVofL850hK1rrYFWAI4liopvGdMh0EB9U3ZgXPiBg9VkMDUxus
	VUqyuy0LrdlCcl+hbRCUXnBbohV90pFUI+x8RG9pIjKKurrLzmmS5IW3aRY76r3LZwvAXSF/vep
	sV5l8WrDoRTOun1ATHUYvlg==
X-Google-Smtp-Source: AGHT+IHUDax96YW/dLQiH58KiosXlAxUWeNSSadMNJlcVuoMXhds3TkQYERhSbm/Z7tGEYtmbj9kMFVEdJ9Dtwm14A==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6602:21c4:b0:7c4:9c05:d8a5 with
 SMTP id c4-20020a05660221c400b007c49c05d8a5mr6265ioc.4.1708726994675; Fri, 23
 Feb 2024 14:23:14 -0800 (PST)
Date: Fri, 23 Feb 2024 22:23:07 +0000
In-Reply-To: <20240223-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v1-0-9cd3882f0700@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v1-0-9cd3882f0700@google.com>
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1708726991; l=2731;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=gjMkG4A6VKeg8L3wOX72tlhUgkPYbTyo8rC5lCzc/xc=; b=UYPkwNW+u+IG5SwHWneAt8sx4dhS9pOJJjUiYB6pIM632xEy5Mt4vk9TihIz2H7sRZimP1ovB
 tx+x7hymDZZDPtOQ4DR6ay7OO4oqFJb8qN+s1l2MwvjpwgxBOLQGrBE
X-Mailer: b4 0.12.3
Message-ID: <20240223-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v1-2-9cd3882f0700@google.com>
Subject: [PATCH 2/7] scsi: mpt3sas: replace deprecated strncpy with strscpy
From: Justin Stitt <justinstitt@google.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Ariel Elior <aelior@marvell.com>, 
	Manish Chopra <manishc@marvell.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
	Manish Rangankar <mrangankar@marvell.com>, Don Brace <don.brace@microchip.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kees Cook <keescook@chromium.org>, MPT-FusionLinux.pdl@broadcom.com, 
	netdev@vger.kernel.org, storagedev@microchip.com, 
	Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

The replacement in mpt3sas_base.c is a trivial one because desc is
already zero-initialized meaning there is no functional change here.

For mpt3sas_transport.c, we know edev is zero-initialized as well while
manufacture_reply comes from dma_alloc_coherent(). No functional change
here either.

For all cases, use the more idiomatic strscpy() usage of:
strscpy(dest, src, sizeof(dest))

Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8761bc58d965..c1e421cb8533 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4774,7 +4774,7 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 	char desc[17] = {0};
 	u32 iounit_pg1_flags;
 
-	strncpy(desc, ioc->manu_pg0.ChipName, 16);
+	strscpy(desc, ioc->manu_pg0.ChipName, sizeof(desc));
 	ioc_info(ioc, "%s: FWVersion(%02d.%02d.%02d.%02d), ChipRevision(0x%02x)\n",
 		 desc,
 		 (ioc->facts.FWVersion.Word & 0xFF000000) >> 24,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 421ea511b664..76f9a9177198 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -458,17 +458,17 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 			goto out;
 
 		manufacture_reply = data_out + sizeof(struct rep_manu_request);
-		strncpy(edev->vendor_id, manufacture_reply->vendor_id,
-		     SAS_EXPANDER_VENDOR_ID_LEN);
-		strncpy(edev->product_id, manufacture_reply->product_id,
-		     SAS_EXPANDER_PRODUCT_ID_LEN);
-		strncpy(edev->product_rev, manufacture_reply->product_rev,
-		     SAS_EXPANDER_PRODUCT_REV_LEN);
+		strscpy(edev->vendor_id, manufacture_reply->vendor_id,
+			sizeof(edev->vendor_id));
+		strscpy(edev->product_id, manufacture_reply->product_id,
+			sizeof(edev->product_id));
+		strscpy(edev->product_rev, manufacture_reply->product_rev,
+			sizeof(edev->product_rev));
 		edev->level = manufacture_reply->sas_format & 1;
 		if (edev->level) {
-			strncpy(edev->component_vendor_id,
-			    manufacture_reply->component_vendor_id,
-			     SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN);
+			strscpy(edev->component_vendor_id,
+				manufacture_reply->component_vendor_id,
+				sizeof(edev->component_vendor_id));
 			tmp = (u8 *)&manufacture_reply->component_id;
 			edev->component_id = tmp[0] << 8 | tmp[1];
 			edev->component_revision_id =

-- 
2.44.0.rc0.258.g7320e95886-goog

