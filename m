Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A31743030E
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785928485; cv=none; b=cVZ/9OFfZRjBXXKI4/micLHtEO8cSNPbt0YdxWZTQzvMdas5v5cDP9Vb7K0ZjwFRl4XdEvXXcEZ8vjBV9hElVBTQCLswN2SWLiKWgxQKXRVuaSTpi2iDzhRs7caFnTa8VV2+KrkCHebgcmn1Yl42KWxR+yktJPCBswv/gfC2gdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785928485; c=relaxed/simple;
	bh=me/1VhefOkHHqyizuSEEQhIHG46HftgluVtJTE/tZVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0di3lnqX4oFDUt7KDOlj1LBXhg32L5Ccup1miUwRKypHkN0E7DWyvN3uU5LrdOYpe7s84O8CNeFnyS6YigZwxlB6oELs8Fs/abY+qMeqMQLA/vniQqpuUCyiRj7vtVznCigD0vHySAN3lITkfDtAhLUE+9SDs1Ch0oaqZat4to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=A/ITxRYO; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="A/ITxRYO"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-8453427d3f4so1044542b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928483; x=1786533283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s8jxcX3iGy41JPBph8tblwcq3UotxCtvgkPYOhPoJBw=;
        b=enhQgEviSfAniD+8Nq+ozVlDdtdY1E7MxswLMsCByixBMHeb0Rw3BQifCNWtPY+7GY
         /6iWMNOAezA269lVpY2NCA0qdPKK0qZ7/m1jZHsvIHqRw7mpIZ7yIUe1z7i/RMmvu77t
         BQvkVElfHdyHHmGJC31rDx0wmleMvstOMQ/mYB6K6ODQPdECAJNbx4K7vV3rI40Xl+kD
         KzQ487eUpC0F7nTnryQM48jd/cZqg6SfwBUptAGEDfAE6bp5RlxZdHeZ1JzrK2Ebdpwq
         ZPkCO0U8zFqmf9r7KkRjvXaXypLEBN7z0pgAhrl/4M/gUwr5DVY9okN+nVaeBixX80zM
         Kxxw==
X-Gm-Message-State: AOJu0YwtfLKzrlhvU4/3O23A35FcPDGuVcfsr6ASAAYWG0e4+h4ZqCFz
	YEtpAKdSMoWQGLAR2snUcyo+dRZpdzP8I4awBlkZ+VBptLJQVP/I8Z34COgUv2f5YWHxkGbKg6d
	v5QG9pXRMWr/2VBhmYzTVnjuj4FyEoDXD6Az0f24Kziw1iUZpKK6flj46NoptShuGi1UTkjo3YY
	3jbC27g45DBdRYZ+ITmznDfN7O3Uev4SuBM8ALFbw247hJQioZ9srTMzelnT4S6A+fWlQNX5Kdh
	ynavyRcxrqMOqEA
X-Gm-Gg: AR+sD10NW9maYbovxm/FL8Oac7+d6rSM2Oq0ma55YecwlagsYkyCKXP9tjZd7maJBYV
	hhSlzNbQJTMcH8FHc9rZrpK78KP73eRojFzZcHPFU4RRaLL3Zy7RLVb3eWm3sSX3iWbtSTd5omE
	IO5jWkol3cC6P8KIkdnQpRxp+noeRXSC79jRykuLVuUxHiybit2shj7k6sShUn0h4uH+uR652eB
	rPfXfypfuJ1cRPfkz8b/oAePBGuDgHohFpDWZ793pFF6dAD0ui3IjW8qhwqS67OoXqqwOSAilzP
	OxAnkU7PDbWk6ZhCvGmZEfwIUtHRUvrx2nRcqJxZO4i3O/XYEF1hdNb+AG4jdN5h6cmGd7U3nVY
	AQrdIT3H5nLx49+H6IgDrF4BxffFYWYAEzMl6nc0rf94cjTVvn59kaR7LLlyNyMP18F1d+KHXJ5
	JjW8xvPfUBvpPPqTWcFp0JUjRgnO9xFTiLxfU=
X-Received: by 2002:a05:6a20:7350:b0:3c3:88a5:83db with SMTP id adf61e73a8af0-3cb85e2b7ebmr6563115637.5.1785928482918;
        Wed, 05 Aug 2026 04:14:42 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-13fca6c616dsm567883c88.4.2026.08.05.04.14.42
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2026 04:14:42 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-ca7c1e22995so1261368a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785928481; x=1786533281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s8jxcX3iGy41JPBph8tblwcq3UotxCtvgkPYOhPoJBw=;
        b=A/ITxRYOCd5cipu3hB3LaS3y65Yc5JQ73xUxjXqcsLe8v1GySlLLIui75UwAXi9XG8
         Us2riMiQCL4PgnjuVxfM7QFHcWNU6XhHjGXTT5gMDsMRsTm46Bb+7QyBVrCd2bioRzt9
         AXOoFuXm8V0QRfjxQAOrEhM7ig4qJOGTo4mA4=
X-Received: by 2002:a05:6a20:7350:b0:3c3:88a5:83db with SMTP id adf61e73a8af0-3cb85e2b7ebmr6562869637.5.1785928480841;
        Wed, 05 Aug 2026 04:14:40 -0700 (PDT)
X-Received: by 2002:a05:6a20:7350:b0:3c3:88a5:83db with SMTP id adf61e73a8af0-3cb85e2b7ebmr6562790637.5.1785928480262;
        Wed, 05 Aug 2026 04:14:40 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158673b7f4sm16740227eec.17.2026.08.05.04.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 04:14:39 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 09/10] mpi3mr: Fix SAS PHY cleanup in host addition error paths
Date: Wed,  5 Aug 2026 16:36:33 +0530
Message-ID: <20260805110634.346670-10-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
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
index db9cb0b03b9f..e4c223a0acf6 100644
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

