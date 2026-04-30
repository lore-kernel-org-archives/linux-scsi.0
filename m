Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384A43B2FFD
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 21:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777582990; cv=none; b=A629tSLSXNHqGyTUoXyQSFP+0eVAM2HDNpLvGiiQii2hc7xsAHK96J9PlNAziVvUAskqUZzSqGzYFpUroTzZKuLTl4A8cqFXHdPs93KxFfZDBs+sTvD3NNDgcZRudsTpbSDNFjgLhGVKjRIDuGf6ybM9vXxaQ7swofhzaRGQDDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777582990; c=relaxed/simple;
	bh=dKcQ9gofc1MkJSPdgtxtQwz2NADeQERcN6d2YDBtYD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+u6yaEu6cW8Xgxd+qrt8fzyihVcpDYq6jgsdRhQIxIS3IsRCZKtEhnuQGq0WNCx014kJb84zaJLkAKX9OFRzR9XduB8ZYLnLlq18G7ZvLpaY+qS2lOomVPWjSJJhsMZqNE8OQfFSlFKu3pnNC8Y+8Q6wGLbUegdkjYxN0dzXN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G+m1PWBo; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+m1PWBo"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c7b9f54d3deso838213a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 14:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777582988; x=1778187788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rtPqpREBagzBSxsaqoRtZ+VHKYl1bjv3s2ciLoIpvw=;
        b=G+m1PWBot3m8CpTFUgTkvAUJAZt0kNqxzUiULb8Lm+YJ85fydV/eYUMXPQ9u4GZQHe
         GgATFrZUnIlwcFT1N66vsT9w4vLY4um2CMdqnB4T2Ndyesn70oY7X7DWsx74zmi2MXUq
         qvqQARxyWTNnoV1k/odN7Uh1F+cSGyc+frr+V8rdQ6DBoGf9NV5hVIOaNLUmh45FGrq6
         IBKzxLe9NkcCe6hmMY8eWGpnuOC48CcZzUFFbc/sKg4Qb3CDtZy1A/OWU6o86MzIcqKN
         qyxuUUMC/45kpv3vLPVPgsx7zopmIuH3UJxEU3WELl8sztugVKJamZAofcU4hIYsAGL/
         OxlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777582988; x=1778187788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1rtPqpREBagzBSxsaqoRtZ+VHKYl1bjv3s2ciLoIpvw=;
        b=lmzfZ2V37JuV6tfpG7NkG5zSwHRVIWXgm7GSoy+TUAaUoKZTT8d6u/Eh+/Pyd42/Mg
         o0GMWiV3kjNyuEydzMd7QnJO5Z/5Kb4aObQ2t6Znr+aduDX3pznoh7Beq/rGwSF9EjqQ
         IpnLjtLQ+8KB2Fevmbqbvi4JJmAvOPIQxxStov+3T0vkcVSQ9E0Q1CYOUp4FuWD4AZGk
         XSHvKnwqeCdY3LbC6KIHuCrNd3vGNS5R3s4sLq7CwT0GEaMWbDMYnpdXFqF3lXUHUjtw
         98qri23PIMtXzmVb6/Vc1iA4UoK02WDOJwq6RxBN8SISJ6eYfXO+cGS1R2RoFK+8JvRU
         575w==
X-Gm-Message-State: AOJu0YxcpObjkf50YR4nOtoZwknPY5ui9sOHxdH5eMNsCvQX983KijM8
	mC6QLSTOIhDAJycuy4PxWCGVj+pASAeilj9mBspx1fiKu77GBHFKFjZ27w4UHA==
X-Gm-Gg: AeBDievYUO2wjFpj7hI7/2B8elT+hY/Kh5wiBp6McXC3OhIk3z+Z27vgC3s+wmDWPdQ
	L6rITXm6OidB7rYSi6WIx3hFUtoElvptwI9GymXQR/nfqJyjFHaOsFcYLi/1gKIGzGTZi2sndze
	lN3RtMYK0dU9ITx/JE3nQv9P081p0oOrABuNUM52uXkr2Q8N72mLsCeYzXhOobQGnzgR3hbCHaG
	NgtceVZDIYs1wDc0R53xC9C94VacEVTY3ZYlGLHUDdvJFyv3IHJQtKpB3J/PEEqWPTY5uYWQj3N
	Hu1VFUQZZhFWU+32Mk6QCdjPj8ptiLNPczj+rD2fzMjm5K1/dxf2HZ14egTWiU+QlhQK0+wTIxA
	ZlwXRQH/t5pB8j+hsOhKfUmbJBzny80LZxLjnz9mGGO3NkRcl4l3gyYOt7g0OyuwjOQtPxDRzQ4
	95YMBEcU5WtzFtXQvDaFqCOXf2ZAQ9BCo3QusvMcSNXo95gddp9zk4fcoJJBAfQAWEDrXlT8kBM
	13APgijC5SSen2fYhc+qNPPFFso6KDYFKT7k4bS1wEbRA==
X-Received: by 2002:a05:6a00:408c:b0:82f:5051:f024 with SMTP id d2e1a72fcca58-834fdbd91cbmr5717378b3a.27.1777582987982;
        Thu, 30 Apr 2026 14:03:07 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515b4f7c1sm516809b3a.51.2026.04.30.14.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 14:03:07 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/3] scsi: bnx2fc: tgt_ofld_list to FAM
Date: Thu, 30 Apr 2026 14:02:45 -0700
Message-ID: <20260430210245.29840-4-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430210245.29840-1-rosenp@gmail.com>
References: <20260430210245.29840-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify allocation slightly by allocating tgt_ofld_list with hba. No
need to kfree separately.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |  6 +++---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 14 ++------------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 9a5de1048542..31bb701cc5ea 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -224,9 +224,6 @@ struct bnx2fc_hba {
 	char *dummy_buffer;
 	dma_addr_t dummy_buf_dma;
 
-	/* Active list of offloaded sessions */
-	struct bnx2fc_rport **tgt_ofld_list;
-
 	/* statistics */
 	struct bnx2fc_fw_stats bfw_stats;
 	struct fcoe_statistics_params prev_stats;
@@ -246,6 +243,9 @@ struct bnx2fc_hba {
 	struct list_head vports;
 
 	char chip_num[BCM_CHIP_LEN];
+
+	/* Active list of offloaded sessions */
+	struct bnx2fc_rport *tgt_ofld_list[];
 };
 
 struct bnx2fc_interface {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 26e0ff380860..7e740ac6bf1b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1337,7 +1337,6 @@ static void bnx2fc_hba_destroy(struct bnx2fc_hba *hba)
 		bnx2fc_cmd_mgr_free(hba->cmd_mgr);
 		hba->cmd_mgr = NULL;
 	}
-	kfree(hba->tgt_ofld_list);
 	bnx2fc_unbind_pcidev(hba);
 	kfree(hba);
 }
@@ -1356,7 +1355,7 @@ static struct bnx2fc_hba *bnx2fc_hba_create(struct cnic_dev *cnic)
 	struct fcoe_capabilities *fcoe_cap;
 	int rc;
 
-	hba = kzalloc_obj(*hba);
+	hba = kzalloc_flex(*hba, tgt_ofld_list, BNX2FC_NUM_MAX_SESS);
 	if (!hba) {
 		printk(KERN_ERR PFX "Unable to allocate hba structure\n");
 		return NULL;
@@ -1380,19 +1379,12 @@ static struct bnx2fc_hba *bnx2fc_hba_create(struct cnic_dev *cnic)
 	hba->phys_dev = cnic->netdev;
 	hba->next_conn_id = 0;
 
-	hba->tgt_ofld_list =
-		kzalloc_objs(struct bnx2fc_rport *, BNX2FC_NUM_MAX_SESS);
-	if (!hba->tgt_ofld_list) {
-		printk(KERN_ERR PFX "Unable to allocate tgt offload list\n");
-		goto tgtofld_err;
-	}
-
 	hba->num_ofld_sess = 0;
 
 	hba->cmd_mgr = bnx2fc_cmd_mgr_alloc(hba);
 	if (!hba->cmd_mgr) {
 		printk(KERN_ERR PFX "em_config:bnx2fc_cmd_mgr_alloc failed\n");
-		goto cmgr_err;
+		goto tgtofld_err;
 	}
 	fcoe_cap = &hba->fcoe_cap;
 
@@ -1416,8 +1408,6 @@ static struct bnx2fc_hba *bnx2fc_hba_create(struct cnic_dev *cnic)
 
 	return hba;
 
-cmgr_err:
-	kfree(hba->tgt_ofld_list);
 tgtofld_err:
 	bnx2fc_unbind_pcidev(hba);
 bind_err:
-- 
2.54.0

