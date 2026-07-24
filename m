Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4673DA7E6
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889185; cv=none; b=uW6kvpAxXSYtzs1wnBSwHoy3epGYYq0A548UX7XNYjnSt92CiYzIa1eaqOIogMw8GnIUZer+HaJ68/NLMncWjHvEG8GaifThBZR4Wf71AI3aqQ214FfO7jEMM8elkovhM/l1iztzMczlJUnJrdXnV9bOFP56jwabUVHa/PesFGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889185; c=relaxed/simple;
	bh=3NhWK0OH6f1vgby+uQDdYCXUMRzFFze10Vhof7Aar0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqZJMMzFoADtMglrpIiW27kBN/B7F9sy8mIQdizUaA4CndfJ0FidWvOxwm0YU22g+X5ey2e4YSMUYZeJXDn8Hdx7IHYvRRYBZfN6B/xEweGexF+6NFelgT1lDrE/OjrNtMFWgbUjR2wzrVHKefsaq/3w6eyRq3WnOjTQ/v15FAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Zy6/YXRx; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Zy6/YXRx"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-ca913a601fbso195130a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:33:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784889182; x=1785493982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pXGJDVPv7Abhv09Lwg1lb6ylA9qqPAYkqFokKUay54s=;
        b=Z2Rv/nFnuY/8XtCRp4LklHtCry1TbF1jW8ZcoM5Xb1M5Gjptboq8trGgUOV11QMUB1
         zauRdDWANVDw8Jo+fLqiJ7HVAhLhbJyS3f2YTeJ53wxD/Q9vnZA+TjvipvQm0FM7jX5a
         JGS+i9NdjsOC6YSymBE8lYpKMJ+0iraIlmSIqAph6CleotrWwEZHZUQjKiFBFqlp7B6H
         QCgUfHRYvsM0zalRTFq5SQK/eV/acLZRT73q9JUYyPS6FCsu05X4iAsXDF0+N8ZVMdI8
         t0YBY8AzqAn4HCLyyWZGyO3CFQOkNcyIXuMb9QMKYhs9QDqZ5KdUixhRFMnz6a32uM99
         zayw==
X-Gm-Message-State: AOJu0YzA+3cAHASvc4+VY4LebywhzWodnWqLt3RuXwO961A3OiFFy3YC
	Sir1d3807M4mlHzOywQB0S04i5Sukq7Hr4htIXFzBvbaH29eLihh8qs4RnYpmGnQwyYFCqURzeo
	mqZKYaD4W3namBY4XjqA2hQHbJeJGHBjcKkpNQbKdIt73BG8uxD1QXU0dRCfLFyyfdG6QmbpdUw
	2SsCqfq71o7deNoeDY3xI0E3+sPmZIMgSgh5aeKilljwL//OJ5ykxc+qxgyepw9tSK41PiV3ozz
	ecqlts9U+GpAVRy
X-Gm-Gg: AR+sD11PcgmV92ugtHRp3vsD5BX+9EksdyZgl8l0I+zpxop4KJSBLU3ofVgFJ5iFXae
	TXhRFBk+vu8nsq1uaUrYerYPe3dz7P4nqpGYiaoqiMURyXAEGcyVXqUMuhKfJ67f2xQQxVLdGB0
	Z6CLGKTMp4YatR9Bp8Om1PGM+D80a7JmJTX9azihVTsFo12Nfmu9C3QCU7Q/LNfeUhoMpDyv0xy
	JI2DOvBDM1JcmJqtPZoT3pZwaVkRe27hNmwjl0L1OiYTeQRayjgPv2Ba8JM+mUoNdeYbu/nY+/Y
	Z168J3CFDlj+3A8LGrdAUaibTBgrRi0uWHdkM5FvH1GVIdS8/fK+kHxW68XtEdqrLj/rLDuJY6C
	bJjKtTgoB2k+Jfn5MSYVaegBSABUe3+Zk72zKHFQZ3jAINUIb1LHjO7d6MqMY/m1vKN6PenVxzp
	Dzs01U/mmv1i4icPqSgttzu/2jBHr9Vj5GRSA=
X-Received: by 2002:a05:6a21:3989:b0:3c3:875d:705e with SMTP id adf61e73a8af0-3c44afcd590mr7854911637.19.1784889181869;
        Fri, 24 Jul 2026 03:33:01 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cbb8f0f58d4sm530409a12.3.2026.07.24.03.33.01
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:33:01 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cab041eced3so446584a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784889180; x=1785493980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pXGJDVPv7Abhv09Lwg1lb6ylA9qqPAYkqFokKUay54s=;
        b=Zy6/YXRxB6zxNDpVoiK8fT1Pm18Uk4LUReFZH1MCe41LlNFSggMSi+Kc+s9UPW+axg
         lzpwSpAvITMAkxnnQZa66tHxcjzZIr3NFvxcBdrwsmPyZcf5cF9saMu3mnmBR75EQXym
         80FhNCeX3ItiR1WfGY04LUfUQm6k5VPTbWc3Y=
X-Received: by 2002:a05:6a21:610f:b0:3c3:ac9c:9a6e with SMTP id adf61e73a8af0-3c44b2ae3bemr7835534637.68.1784889179979;
        Fri, 24 Jul 2026 03:32:59 -0700 (PDT)
X-Received: by 2002:a05:6a21:610f:b0:3c3:ac9c:9a6e with SMTP id adf61e73a8af0-3c44b2ae3bemr7835497637.68.1784889179387;
        Fri, 24 Jul 2026 03:32:59 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1cf8fasm30233211eec.31.2026.07.24.03.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 03:32:58 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 09/10] mpi3mr: Fix SAS PHY cleanup in host addition error paths
Date: Fri, 24 Jul 2026 15:55:04 +0530
Message-ID: <20260724102505.115136-10-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

When adding a SAS host, the driver allocates a PHY array and subsequently
creates individual SAS PHYs. If a later step fails, the error path exits
without cleaning up previously allocated resources, resulting in leaks of
both the PHY array and any registered SAS PHYs.

Additionally, the return value of mpi3mr_add_host_phy() was being ignored.
If it failed, mr_sas_phy->phy would be left as NULL, which could later
lead to a NULL pointer dereference in mpi3mr_sas_port_add() when the
attached device triggers a device addition event.

Add a dedicated cleanup path that deletes any successfully created SAS
PHYs and frees the PHY array before returning from initialization
failure paths. Also, check the return value of mpi3mr_add_host_phy()
and jump to the cleanup path on failure.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=9
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 33 ++++++++++++++++++--------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 00f115ef3a47..b44e36f84e0e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1216,13 +1216,14 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 	}
 	num_phys = sas_io_unit_pg0->num_phys;
 	kfree(sas_io_unit_pg0);
+	sas_io_unit_pg0 = NULL;
 
 	mrioc->sas_hba.host_node = 1;
 	INIT_LIST_HEAD(&mrioc->sas_hba.sas_port_list);
 	mrioc->sas_hba.parent_dev = &mrioc->shost->shost_gendev;
 	mrioc->sas_hba.phy = kzalloc_objs(struct mpi3mr_sas_phy, num_phys);
 	if (!mrioc->sas_hba.phy)
-		return;
+		goto out;
 
 	mrioc->sas_hba.num_phys = num_phys;
 
@@ -1230,12 +1231,12 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 	    (num_phys * sizeof(struct mpi3_sas_io_unit0_phy_data));
 	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_io_unit_pg0)
-		return;
+		goto out_free_phy;
 
 	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
-		goto out;
+		goto out_free_phy;
 	}
 
 	mrioc->sas_hba.handle = 0;
@@ -1249,12 +1250,12 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 		    MPI3_SAS_PHY_PGAD_FORM_PHY_NUMBER, i)) {
 			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 			    __FILE__, __LINE__, __func__);
-			goto out;
+			goto out_free_phy;
 		}
 		if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
 			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 			    __FILE__, __LINE__, __func__);
-			goto out;
+			goto out_free_phy;
 		}
 
 		if (!mrioc->sas_hba.handle)
@@ -1264,26 +1265,27 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 
 		if (!(mpi3mr_get_hba_port_by_id(mrioc, port_id)))
 			if (!mpi3mr_alloc_hba_port(mrioc, port_id))
-				goto out;
+				goto out_free_phy;
 
 		mrioc->sas_hba.phy[i].handle = mrioc->sas_hba.handle;
 		mrioc->sas_hba.phy[i].phy_id = i;
 		mrioc->sas_hba.phy[i].hba_port =
 		    mpi3mr_get_hba_port_by_id(mrioc, port_id);
-		mpi3mr_add_host_phy(mrioc, &mrioc->sas_hba.phy[i],
-		    phy_pg0, mrioc->sas_hba.parent_dev);
+		if (mpi3mr_add_host_phy(mrioc, &mrioc->sas_hba.phy[i],
+		    phy_pg0, mrioc->sas_hba.parent_dev))
+			goto out_free_phy;
 	}
 	if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &dev_pg0,
 	    sizeof(dev_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE,
 	    mrioc->sas_hba.handle))) {
 		ioc_err(mrioc, "%s: device page0 read failed\n", __func__);
-		goto out;
+		goto out_free_phy;
 	}
 	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
 		ioc_err(mrioc, "device page read failed for handle(0x%04x), with ioc_status(0x%04x) failure at %s:%d/%s()!\n",
 		    mrioc->sas_hba.handle, ioc_status, __FILE__, __LINE__,
 		    __func__);
-		goto out;
+		goto out_free_phy;
 	}
 	mrioc->sas_hba.enclosure_handle =
 	    le16_to_cpu(dev_pg0.enclosure_handle);
@@ -1306,6 +1308,17 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 				le64_to_cpu(encl_pg0.enclosure_logical_id);
 	}
 
+	goto out;
+
+out_free_phy:
+	for (i = 0; i < mrioc->sas_hba.num_phys; i++) {
+		if (mrioc->sas_hba.phy[i].phy)
+			sas_phy_delete(mrioc->sas_hba.phy[i].phy);
+	}
+	kfree(mrioc->sas_hba.phy);
+	mrioc->sas_hba.phy = NULL;
+	mrioc->sas_hba.num_phys = 0;
+
 out:
 	kfree(sas_io_unit_pg0);
 }
-- 
2.47.3

