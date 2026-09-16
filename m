Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A68364942
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 08:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547744; cv=none; b=eH3eOC6CDVdj1c7ahhTria9bp8iUOhPQYlMtIk+v9iNqfAdvZfqMEERewE6SA2vJc9ghYPDjZD4ZLIcfMulort1ZU/q9gt87WFySw2CQ70uqpuiG8JZCxOUKn5tzvLn4dGwRCet48PWGoeZ2oNCEX7Lz2At1W+d06DEXAjY33aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547744; c=relaxed/simple;
	bh=j8VbxXPsTOsfFiIwSGkcDeILGBTb8aFb8fZ4yFQQ6PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWeLA5zqObgupPxex1xNKUfBo086E5k02l8ZNQLb8E5Z6zIxYirwF0JOQNhAkHd9nVK/ETIc5iaoaXfLvRVNS0RH4XOYel6mz3aoS+7VNzaOQ8CJ2GpgWmdFh5PRA568E4bk33WCr9z7jLUHwynDCBnPRTPfL09FmgVZGi60qZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=OBJZ8lBg; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OBJZ8lBg"
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-8052a85c13cso1214985a34.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547742; x=1790152542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vojN320hrWrxQVJyelXMNNmhNfAwtJPTfu5Q9t9NF4A=;
        b=rUJqirO9As637xCYDVm7tAMWaSue+rWFO8fih7xaGT6cKzfAqoOfHoQUv8eIWRfZmf
         9jhS1auSH6aKBsNPf0K1YJLkZLekjUY53cMIXZ5WRH2GCFoU4aJQdMt7nzkHDGsc4M5I
         Tot2tqz2zEbUsoU9TntuWUdktutv3q+xcGAEhukKkkPhHYnfp3h/e8bIJhhFfKx+CfZn
         XS8cMWq0KYsbRfy0HNFj8MQkuZbBhK6fxVHTwyuYvf/E+RTj3x+rJWTRIwjmSBsFxVtO
         ya+CtvncA/AzDIg6huq8VgVlNR+rTBRz5zGW8PrmTajfMbSmTD3WyM4xm90MDd4gmXjF
         zJPw==
X-Gm-Message-State: AFuF++nIW5vkk+siHEX1pu74iBN1E4tnuQdBrQqFsDA6C5aoI9hj9KRz
	gTGKejkDRv5rerMN4sB+mxoYO1hXxW7AU8bn6jGLrwFpkd36JYnT57utFLfQSmq/VUaeeO0Gc4K
	2SdG2IePVseRyuMSVeuk8HR2mXs7MjDrNYAXALMvOL6u47S0SZLmRkM/eWLy1OjJWh/uM6DSwfC
	HOKFUmekxw6CBuPl5ddRF/x4G6F/CF8TBLvvAVxoYHwZFetXYuJeddjcSjmemRZ01fZXvEmDzFg
	oQqbLdyOJX2j3pd
X-Gm-Gg: AYBFou3CfCTJuQQcF5BfvLFvhr5JaS1UIaMOJWLQJ6NcJLn7f240HfttXmVk0Fiv8GT
	MoZtO+MTM9vO1OqZzv/h7TeDBxyOmOKdqB6t9DT9fX10mOydO1ExSlgoLfRUVLf/kZoacXiOM3W
	VXO6MIlykxaDGP0sfmxcLjoathfVwJqBCyWWsIrtIGDq+0qAGR+vJWw3t6/d98yYf+XF2JH6WDu
	8ezdkDPyKK58RptLyslL/WIgAVl/n0GhoKA1LHF3AKDpsEKJBlpmTyOAEFgwYDFwT0+UsRV0w2L
	t5iOcg9vBBVxAtiVrv4kosNDI6VGoHvTK0FS6J7MtJa6dMpk8/Igs4scJ49VKFVza3WYvSpvU30
	LdrzvO9u2sT88tq5ulT5CNqMvqhCyqVqfWA2W7ctpeCfTx8uNV+7758GBlECS5UPDHH2wR58zEi
	IS3xAedJVUp4+VsnXftMb08poUkHc1Us3crAM5vg==
X-Received: by 2002:a05:6830:6d49:b0:806:1728:aed9 with SMTP id 46e09a7af769-80b2d408ecbmr4960961a34.5.1789547741765;
        Wed, 16 Sep 2026 01:35:41 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-80b078ce11asm1016789a34.7.2026.09.16.01.35.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:35:41 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3965ba1ba3eso6798060a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789547740; x=1790152540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vojN320hrWrxQVJyelXMNNmhNfAwtJPTfu5Q9t9NF4A=;
        b=OBJZ8lBgu4RVoRgnvsL8IrOhLt572j+G4+KxewBb/yldOZOdlEeqmF0ASdCmztJLfP
         dYkM9ki915k6icgEja4+/O3KjR+N64JtqGfW9gaswWO5DbgfVSQOQTfdzuwns0OBfQi9
         TW2xIYP0tG5f8OGHKAHxpwfX0iixHKA3NxGro=
X-Received: by 2002:a17:90b:2744:b0:398:ba56:b926 with SMTP id 98e67ed59e1d1-39e1e5770b9mr4448923a91.25.1789547740330;
        Wed, 16 Sep 2026 01:35:40 -0700 (PDT)
X-Received: by 2002:a17:90b:2744:b0:398:ba56:b926 with SMTP id 98e67ed59e1d1-39e1e5770b9mr4448825a91.25.1789547739749;
        Wed, 16 Sep 2026 01:35:39 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5ac47cfsm5226261eec.17.2026.09.16.01.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:35:39 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 09/10] mpi3mr: Fix SAS PHY cleanup in host addition error paths
Date: Wed, 16 Sep 2026 13:57:04 +0530
Message-ID: <20260916082705.44712-10-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
References: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
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
index 0dacfae6fa9d..a3412cd4ca5b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1223,13 +1223,14 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
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
 
@@ -1237,12 +1238,12 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
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
@@ -1256,12 +1257,12 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
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
@@ -1271,26 +1272,27 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 
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
@@ -1313,6 +1315,17 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
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

