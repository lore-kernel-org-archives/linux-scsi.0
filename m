Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F0C4C77AD
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 18:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783536054; cv=none; b=FjqoUKDq/h9jeWp53kkhnq/A6mouAFjXZiP5cS99D1xFdG/8SsW0nIhi6HScx32CmunaLRsetjwOHU9HlbJ1cQh06EVp4zIElUms9RWtnkasQh7bHdhRPVly1qYmbHqtj/sPHQmXFoMxgWf8qV23vy7RvEk01VCPMYq7K0uvVUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783536054; c=relaxed/simple;
	bh=53SFGo1WTeBtwlKruDqXMf90a31IOfZGOUD9lFClJ1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWvAoQkVoAnznRSkoQIbZt2kMIk8mt76op5+eMc6Dyeb0UWBz29RVA2lPZpZ2vRtbxJ3t9NCxU2RKdXx9AbYC4OKMlRePO9VOxN1oldTZJARdQu0vMMNgLQsESgnnel26pHD8i5O2yG2XeWwXdAwPyLTxdaobN+755WhjAjfcSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=h0R4fjxc; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="h0R4fjxc"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2cacd69a9c0so13567785ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783536052; x=1784140852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DrpYS9EFV03PRy8iPH8Id70B920HkrWbnnXvWxKX26w=;
        b=Ig3gzf9LdEV9CV5h5YBtP6maoQmMlGKaDCM/25V/hIqCItGsmsb0ofc69UnGaiV459
         rm+DMCszARhnX47wfzpjZV7PV4Ei3sTccoR+hZMCI/vcz+cjl5H3oSKBvqEY3ivbeih7
         gPTUVR28e13uf/OSnGgrRXclumB+t4otrpmjNQV4atN1lC5XhoOjOGEeNLh46oV3NkPZ
         tMZNO7mxEjR/t7fZjHJ9uGrUzhaUifJMpR95fnZbZKhLqaYLCO4yV9Mz5aqcj+S+2V5N
         VbHwr391nwoWa7d7D4zwEklUoqxnml11SZ/FVx/HJp04g9o69iRmSvtlsKnPN/qwxdsp
         p5Og==
X-Gm-Message-State: AOJu0Yxlov2uOkn6MeC53gnoa6AFFOF+UsFgVS0KhzzjzD3N9po3zwtj
	fvVAz6acvTy67YW1YcYfR8piO246gA0J7AiA9/onIUSgwJYKBlVzRmIIqiNKTM+jI9Ye4fdiu6H
	fv3hW141kvUXQTSeW8MzBQvFex2z1rlCg6/LYVk4c2QJ7WdYKAfVshhD2l+dhznzgoCDFV7fBH0
	JPQZrT6XT7e1Ia1tNdTWKYPs1cgRHmeK9n/q4ZxWAJfzutlijiBUUukRD/BT/s8IAe+KaF8fXmc
	acoNU9xk0vUBOH3
X-Gm-Gg: AfdE7cm/mqCHNr2peWV9LPivKc7zlYod/gZXgyyiVHk9YE+XirC77nO7YPEcvndsPDH
	Fa23hBNmyuePkxCgEiAm9Pw6gB7L4J4PJZsohTcugxuzsV9av9dz8aIRivzhh4Cg2bxSytro1QZ
	JPmnd4utmfcqZKvNmVFm/YMP7DEaR+4aAKALDuvtghwqznlp/mSSvbFaVO79bqOYDHJE8rddRll
	pt32OHbnUL2f8n9P0baLf+pMjRzCuediqfu0SJ9Qess65YC8zToGI/x0+akw6XI/mcuBgArggju
	agULdzgu1SD9KyuPL76Dm0Tf0NS807DSAWyeN5KiD6GSUy9dioj2bFhccevohUJnBjBp/ER5g+W
	4fuOrPtKYjpbm2K2gFlXOPATL/AsiEQdpbCQn3wGJtEz92QmQxGHg09Z9b/KJ81UWtsqYu0cuQE
	REmCVKX5kiblf2nrfDNLcx40ACHQqzK4AVB/Zg5WYoyiTJZQ==
X-Received: by 2002:a17:902:d58f:b0:2ca:281:27f9 with SMTP id d9443c01a7336-2ccea40c69emr35326205ad.27.1783536051889;
        Wed, 08 Jul 2026 11:40:51 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2ccc9cdb141sm5767155ad.45.2026.07.08.11.40.51
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2026 11:40:51 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c88da04b719so1001250a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783536050; x=1784140850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DrpYS9EFV03PRy8iPH8Id70B920HkrWbnnXvWxKX26w=;
        b=h0R4fjxcZe+hlKP81oOwYyHg4OIGv6M2Oxhl/D2kmjDCSxFSKH29ci0ohax1sNN5ie
         Sj9lq+MdpBaIKKg0EkURscBZjvVJBh/K5SCrhK+IPfvrj+00BEQnlIYR/mwZjLc00Ef8
         PtSWiv+sw/0Qf6LJFlkkCxDzU8ScbDy0UIHqY=
X-Received: by 2002:a05:6a21:1f88:b0:3c0:9c19:b27b with SMTP id adf61e73a8af0-3c0bcce9940mr3989219637.73.1783536049941;
        Wed, 08 Jul 2026 11:40:49 -0700 (PDT)
X-Received: by 2002:a05:6a21:1f88:b0:3c0:9c19:b27b with SMTP id adf61e73a8af0-3c0bcce9940mr3989177637.73.1783536048930;
        Wed, 08 Jul 2026 11:40:48 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm19820599eec.18.2026.07.08.11.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:40:48 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 08/10] mpi3mr: Fix SAS port allocation and registration error handling
Date: Thu,  9 Jul 2026 00:03:03 +0530
Message-ID: <20260708183305.244485-9-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

During SAS port creation, the driver does not verify successful port
allocation before attempting registration, which can lead to a NULL
pointer dereference. Additionally, if registration fails, the allocated
port is not freed, resulting in a memory leak.

Fix this by adding a NULL check after allocation and freeing the port
when registration fails.

Additionally, fix similar missing NULL checks for rphy allocations,
handle sas_rphy_add() failures properly, and ensure the target device
reference is released in the error path to prevent resource leaks.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=8
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a8e2e3..b51edbb921eb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1428,9 +1428,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 
 	port = sas_port_alloc_num(mr_sas_node->parent_dev);
+	if (!port) {
+		ioc_err(mrioc, "failure at %s:%d/%s() (sas_port_alloc)!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
 	if ((sas_port_add(port))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
+		sas_port_free(port);
 		goto out_fail;
 	}
 
@@ -1450,10 +1456,22 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	mr_sas_port->port = port;
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		rphy = sas_end_device_alloc(port);
+		if (!rphy) {
+			ioc_err(mrioc, "failure at %s:%d/%s() (sas_end_device_alloc)!\n",
+			    __FILE__, __LINE__, __func__);
+			sas_port_delete(port);
+			goto out_fail;
+		}
 		tgtdev->dev_spec.sas_sata_inf.rphy = rphy;
 	} else {
 		rphy = sas_expander_alloc(port,
 		    mr_sas_port->remote_identify.device_type);
+		if (!rphy) {
+			ioc_err(mrioc, "failure at %s:%d/%s() (sas_expander_alloc)!\n",
+			    __FILE__, __LINE__, __func__);
+			sas_port_delete(port);
+			goto out_fail;
+		}
 	}
 	rphy->identify = mr_sas_port->remote_identify;
 
@@ -1463,6 +1481,9 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	if ((sas_rphy_add(rphy))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
+		sas_port_delete(port);
+		sas_rphy_free(rphy);
+		goto out_fail;
 	}
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add = 0;
@@ -1498,6 +1519,9 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	return mr_sas_port;
 
  out_fail:
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
+
 	list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
 	    port_siblings)
 		list_del(&mr_sas_phy->port_siblings);
-- 
2.47.3

