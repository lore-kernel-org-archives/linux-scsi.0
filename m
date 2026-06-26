Received: from mail-oo1-f97.google.com (mail-oo1-f97.google.com [209.85.161.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1432E380FF8
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 11:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474543; cv=none; b=NinhJUrVor5hZl2PPRjiNx/C4QVvLtHH0n007AoMHX55P07jCUbP8LdBBoUcm90gPlzJEf1wzPzcDKOAvwOM92+0yH7J7m1kBt4XlZs0CIu18Bt+tGIrfIus81hHEI9r/zPByFCreUqRCiDVC9W1uIOt4g065rG1HJq6myJjuCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474543; c=relaxed/simple;
	bh=ZoO9wXxs+WvjU3NsD3FuZ9+dDYKhP/ax/0V50GhqOqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbTNrluhUAaFi4SWcQ7jFZ8wovZFdnTXqXhF7LkO40jOOtGCoxuEcVAAKJMeNxN70BX3uKERYm3iUjY/PecarGQqGiJnniYg/GCRkbsPQnaNz7edjroeoKfw2odRcaW/XB2NrZq2ZTBVhN1UA/6IPUAAAMr0nPMBSa7fOfs4htA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Lp0v/ie4; arc=none smtp.client-ip=209.85.161.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Lp0v/ie4"
Received: by mail-oo1-f97.google.com with SMTP id 006d021491bc7-6a14d52e72cso105564eaf.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782474541; x=1783079341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p/jyubpJT7IF7Yla0nAr7w2h40Udg0dIgmIF5QQggu4=;
        b=R9ijnjpMDm83eby9vlgcKuGJvm53ppotnYEKmuEojrwjjbgwTZoTLMdw1LBSa7DOkd
         DYU8gQrIfUB7C7QEFh8ly/rIGTRQNL7N2af9Q9BbJzUuLD86403akkg8+5IZDnq+9hPg
         YZdT41oaBu+TQXq3BUBGRYKF46zphHzoOiqVH3Iswt+6qAvMiMYuxulTE53dl2eYWOBD
         duLgR3OJe9dGpEONoyKKUdS72P3vfQLjeHJ1ZJ2hMHf490RW7zpQcV6lWnOHLFWlYqsk
         b5WdU4tpLZKX4+QjRCfVac2qyBkQ9QV5ebyCCIYcgESoHc4WvEqmwnfc+fO+yZs16oDc
         0lLg==
X-Gm-Message-State: AOJu0YwV9d92SmXFzkYMoG1AiZv5Hfr1rAEn4TR8SxLfq8vheJCape7j
	BKK9BXHhfUHJttFMXgtiOIl0vDzaB24a7ElyuMdL5yhq/3Kc5LDWlPg2Q+LR+DyYG/Iewc6zEV/
	oiPT/upR6eTkI0U8jRdXUAOgjlN8P2FYPk+FvZVUQU3+9tQkhhipX2TR47JQ8PYhNHsVmt57GF8
	pBjzXhD+cz2bBXI8QluB+ZOhkIb1UUc4TuFLvfh3tzqmlRN1mUn+vqmAryn3h0/EX0+xfxzP1u8
	Cs3N5ilxKly0T2n
X-Gm-Gg: AfdE7cmn+o2j9HqgoDyjMlRPCRSX40tpA9PzcG20ZaytedQRCdqe7u+zTiv+vOywbho
	0C3txKBzGNiWWt4GaFGs89cEltITllseHm097sn2sZDhnFwDAjUApfrdKwkl0DroCd8ltjecBbt
	haejkeCXUchpvylpbIl85gSoR3EMrXpDTcyjyFNZhmu2sBLphIF+PgxVNEId+kWp4+tZdRQ7tWp
	6L27iGxh6tTkAvSvrdU/nFaplGXtTaUDGZGDASDRgLaDHYnRStxxp1aBAxPSq9Lv9d0gSmsb0Ci
	xzhmSprnFDlUnRlXk97HqFRoAH6lqr9lw8eCkTnxUDqcuPwbiOU50yYsqc/01MGnXn+b+JqebQp
	1OwgnnHcPyjOWMt0YWUlVDbxdMSC2sfbIjsDjbkMy2niOl2SHZZGVpbQ4AQGYJhjWGsd2ddxM+S
	+LmRGMdFC0maqf9netFHA2WJDInl4vjl+tTMIrZPc40/b5wA==
X-Received: by 2002:a05:6820:1689:b0:6a1:5052:4acb with SMTP id 006d021491bc7-6a15052511fmr75064eaf.49.1782474540862;
        Fri, 26 Jun 2026 04:49:00 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-6a1412849desm150375eaf.4.2026.06.26.04.48.59
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2026 04:49:00 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30c011c7cb9so2025285eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1782474538; x=1783079338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/jyubpJT7IF7Yla0nAr7w2h40Udg0dIgmIF5QQggu4=;
        b=Lp0v/ie4eMMYkRm0VlHyQzsyMy0aO1Wfn/qC6D/QsTOEPbSfavFFQjGypjfBbLPeM2
         3go6+tniyDpeXPIizf41A4Qiy0tb56hKfP5OhGNBSlcUf7HBcPjayABEjGEvg/XTKTY4
         WkifeRnzhKv3+k9xYj8YobX5VBVMq94fSM0OA=
X-Received: by 2002:a05:7300:430f:b0:30c:5ebf:63c9 with SMTP id 5a478bee46e88-30c84d9ba29mr6979303eec.5.1782474538493;
        Fri, 26 Jun 2026 04:48:58 -0700 (PDT)
X-Received: by 2002:a05:7300:430f:b0:30c:5ebf:63c9 with SMTP id 5a478bee46e88-30c84d9ba29mr6979251eec.5.1782474537251;
        Fri, 26 Jun 2026 04:48:57 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c58831asm18844838eec.13.2026.06.26.04.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 04:48:56 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 09/10] mpi3mr: Fix SAS PHY cleanup in host addition error paths
Date: Fri, 26 Jun 2026 17:11:08 +0530
Message-ID: <20260626114109.43685-10-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

When adding a SAS host, the driver allocates a PHY array and
subsequently creates individual SAS PHYs. If a later step fails, the
error path exits without cleaning up previously allocated resources,
resulting in leaks of both the PHY array and any registered SAS PHYs.

Add a dedicated cleanup path that deletes any successfully created SAS
PHYs and frees the PHY array before returning from initialization
failure paths.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 28 ++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 1b793d86f758..0236bbfcff6d 100644
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
@@ -1264,7 +1265,7 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 
 		if (!(mpi3mr_get_hba_port_by_id(mrioc, port_id)))
 			if (!mpi3mr_alloc_hba_port(mrioc, port_id))
-				goto out;
+				goto out_free_phy;
 
 		mrioc->sas_hba.phy[i].handle = mrioc->sas_hba.handle;
 		mrioc->sas_hba.phy[i].phy_id = i;
@@ -1277,13 +1278,13 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
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
@@ -1306,6 +1307,17 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
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

