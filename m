Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910AC27603A
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 11:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892298; cv=none; b=jj02ZvVlIcWdBvaDwMd+QZunNjsVJ7d+ie2gonPrCtAth00FaJvXEn+Aau4XEw1q7PyXKZOemsPoqzgA1WHSbU0jEZjghDbwVq2ckSTnl5myNpOlgCS4XKgD6Fro7bOKDar/9MMvgjZl14QGZ80YRhyCVoLyFatksH1+VMPR7Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892298; c=relaxed/simple;
	bh=89mAF8/HfeAAy+lChXI+4an13kHGsbwUAGqjWo6/H4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=df/VfyuuEmj99ripeJE+HDc6z+xyQWin04tKxI6+LN6zdbqTnnHh7OXBCXMQ4w8aMqYBxc93GB2dBAF6Q1jXKeMg3C8g6omkVaEHF+xEuuvjxF32BIyq8fKbkOrZi3f7bX5GF6GpHk9B8yNKGmkt9T+ur0m0gc/t1yHl4kh1AU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=aXn2mDzY; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aXn2mDzY"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so267615a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 04:24:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784892295; x=1785497095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RAVVheM0VSMw8aV/g8IP8EtUIBudHx/KgxzKrj5G/Qk=;
        b=PdFQaou87JjAkEdyqJnqeR+aYvmeUUzz/jNp+q5LvbdWIZVbS9f8N4/GamsxOFapn7
         F3Whr4iH6Y/WFu6nkDHWulXFspFLAuxMRISI6hgw0cNibPlaGN2YAWNYEwsepc2kv+Lv
         SHyUBAgZvMSYoOQCQ533V4Dn1qHv22iRNuSav8/qRG7F1QeIfcWpMt0bQZtN0+jGRfCt
         cwCFu4iFcNd5f5xr4CLKUguLATehMUmqkQJBNku2pW7c2Cj61DQ71CVclZINOrmVmVFP
         JQoTFWsQVEUiROYx6sN3FxIUVmtlVBdOsrfTJUdMjg0sRFgqYPN93SMT2b/Y31KT3EC9
         cQMA==
X-Gm-Message-State: AOJu0YxNHN5L/37rKUza2so9x69PFXoSTMl5Wh0SPEFJcZaaLNiXrgz0
	IyY6olOFcGLph8Jq0fIpoXQyxkGAUZEcY5mblp0UFESDf35mKCMz/5KPUvaKiWBPaprU7pYGtMJ
	DZQF3V/n75EiBB63KoeNNbOHv2mLp5kcfKQF0KN9QvP5EbImPxiILzc6dXNz7lnUpwkuXD20QMl
	OOBRDLvTgQzguXVH2eg/AmBM4mfT9MiZEJ3iVkmtkVguwCgFyjLYuAMKa1Vnyv6wRovo+2UcYbB
	j1COy15/mR+pAsD7eti2pOu
X-Gm-Gg: AR+sD10TgISWbHNIUoG3V5VzSuWen0S1ruhm+aXuL5jjAp9iZ7OqeLazeEPOLHImBu0
	gUdTblDmlC+OwS6nkhRUWaHLZg8cUun7dS91/Bn6lNq8z0RCygks6ikHUw64YZSUB/iojzKkifO
	I6XM913lYNcEfN3mhN5GJIcq1Qc/OWlTkOGIPDqMyyf4tL45E6gcC641vLuM2E09YbQDXla+46f
	kqXW51So06NOIFxx+jX89JBeKEw+58ahiRS7SJuOjOPSpKTlrs2m1dhx+bRumdshsrkcSwXH96b
	c6/OIeQFXOcOsDOQgq+wNSNLNl/eqevPHbasZlN+MOdI3HBJh3wsj3W9wCX8WyHlvd2qTog87Bl
	fhV6ixbrH3gNkYyJtxNwWIZMSqnufaTfgnmFMdc8rqRMMvg7b9kj6fVkYKdrZVapxnqRKwwrOg3
	BuwJyTdcpjMPD5S21MFsvbvZMPS4lpjl7LBf86mv9GY+o=
X-Received: by 2002:a17:90b:2d83:b0:38e:7f1b:f01 with SMTP id 98e67ed59e1d1-38ec666521amr7049200a91.36.1784892295040;
        Fri, 24 Jul 2026 04:24:55 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-38f109a5a94sm103513a91.5.2026.07.24.04.24.54
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2026 04:24:55 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cab048cdb3eso489516a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 04:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784892293; x=1785497093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RAVVheM0VSMw8aV/g8IP8EtUIBudHx/KgxzKrj5G/Qk=;
        b=aXn2mDzYDAGofztvLFTuuJb6UyZJTwWz8HrdNVoBL1pAOGJE0rqa5B9Ke0ZLa4nNGo
         SPpKZrk3nxBReesqLFL52icjDSf6C+2JKMF8+ErmaezkOnvSLhxmJhIBI4TQtOVTcfDI
         thR+pLgXD7V7wol8hnM/bBc8hf6a4W0SpMPVg=
X-Received: by 2002:a05:6a21:7309:b0:3b4:8ba9:4d8e with SMTP id adf61e73a8af0-3c44b00c842mr7875366637.23.1784892293106;
        Fri, 24 Jul 2026 04:24:53 -0700 (PDT)
X-Received: by 2002:a05:6a21:7309:b0:3b4:8ba9:4d8e with SMTP id adf61e73a8af0-3c44b00c842mr7875334637.23.1784892292590;
        Fri, 24 Jul 2026 04:24:52 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3149198adabsm19312457eec.8.2026.07.24.04.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 04:24:51 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	ranjan.kumar@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH] mpi3mr: Fix potential deadlock in mpi3mr_fault_uevent_emit
Date: Fri, 24 Jul 2026 22:16:30 +0530
Message-ID: <20260724164630.924288-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Change GFP_KERNEL to GFP_NOIO in mpi3mr_fault_uevent_emit() to avoid
a potential deadlock during memory reclaim when the controller is in
a fault state and cannot process I/O.

Fixes: ec54b348f274 ("scsi: mpi3mr: Record and report controller firmware faults")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 31b19ed1528e..e772874ea77c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1289,7 +1289,7 @@ static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc)
 	struct kobj_uevent_env *env;
 	int ret;
 
-	env = kzalloc_obj(*env);
+	env = kzalloc_obj(*env, GFP_NOIO);
 	if (!env)
 		return;
 
-- 
2.52.0

