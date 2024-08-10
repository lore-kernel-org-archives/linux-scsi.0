Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CAF13B5AF
	for <linux-scsi@vger.kernel.org>; Sat, 10 Aug 2024 04:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723264027; cv=none; b=hypXuNFtzicqQxa23In034tS5eQeAIMHcWR449DcbtwLizs53yj9SC+mSbsD/iQqhptrU+AA6Tp3GhDhXqWbZQwuZg+KcvANKeWFjiG84KVFBelIS0UqvArfgwexL27vlmVFXX5s8f27lIv68Q2swRzHmONmwrgeJx67Pg+EicQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723264027; c=relaxed/simple;
	bh=SW0/SOcJuPJyjB85vRVWiDNbYWzKqRGvPyZyp7oMWLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+6/YS5x+GWcJ4uCDeWuqxsIhewQ+pI3e97SF4z+Ro/Ws7AY3TDHSN0Ket4+I/KK4DcGyc+jC47i3qfqCsvupL3a1mwX6WCfwtLG37m9QK09MVw+PEJYqPAXOCtQYI5UhjUZhjS78Pd3k42xzKsfn+IFChQlmb4Xl05LRWQNXTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=CTiYyhbD; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CTiYyhbD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723264025; x=1754800025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SW0/SOcJuPJyjB85vRVWiDNbYWzKqRGvPyZyp7oMWLw=;
  b=CTiYyhbDtJ6TzGg98z3E8RQp7n+asXA/L6lQcNyXv2WoZIynu2hu30Mj
   bm+S5mMXE1Uv9VT0s3TGHlBF2XH8syzS4YQD7SU8Wy+QglL/BI2PwvGBm
   bAkrnzp8yjVafyb1TCgyYMd+vqlSdKpUEf7+1AJ1c6umMwytYdGmNdvby
   Ztc1NjBjNw/oFGmnEMfVldFp78edwGhZyzDBXTzKBrNbAYHhPUzTA6Mhc
   vXDw2gAnuKzR6vlUinOLSaI6j4SvvL4hHs1VrTbcgILhw1X9HJvOZ7pSp
   UHeWEmNOee3ZhG1s7jLB4AWBWjmBDApWhElkmNMdiqG3RLMt9B20cYueP
   A==;
X-CSE-ConnectionGUID: eSOSQH4pRn6MKTzHLXhRhQ==
X-CSE-MsgGUID: mbeC9CiBRSOPsc0+d5ngdg==
X-IronPort-AV: E=Sophos;i="6.09,278,1716220800"; 
   d="scan'208";a="23359479"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Aug 2024 12:27:04 +0800
IronPort-SDR: 66b6df6f_y5f6WASzzc/u6poR9LzegZLZHnnhDh8vn5fO8OXe7uWnIT3
 9s1xrbPBSLR25VJ0VuiDjDh0aTfYpmPTre6t8vQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Aug 2024 20:33:04 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 09 Aug 2024 21:27:03 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] scsi: mpi3mr: Add missing spin_lock_init() for mrioc->trigger_lock
Date: Sat, 10 Aug 2024 13:27:00 +0900
Message-ID: <20240810042701.661841-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240810042701.661841-1-shinichiro.kawasaki@wdc.com>
References: <20240810042701.661841-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit fc4444941140 ("scsi: mpi3mr: HDB allocation and posting for
hardware and firmware buffers") added the spinlock trigger_lock to the
struct mpi3mr_ioc. However, spin_lock_init() call was not added for it,
then the lock does not work as expected. Also, the kernel reports the
message below when lockdep is enabled.

    INFO: trying to register non-static key.
    The code is fine but needs lockdep annotation, or maybe
    you didn't initialize this object before use?

To fix the issue and to avoid the INFO message, add the missing
spin_lock_init() call.

Fixes: fc4444941140 ("scsi: mpi3mr: HDB allocation and posting for hardware and firmware buffers")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index ca8f132e03ae..616894571c6a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5234,6 +5234,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&mrioc->watchdog_lock);
 	spin_lock_init(&mrioc->chain_buf_lock);
 	spin_lock_init(&mrioc->sas_node_lock);
+	spin_lock_init(&mrioc->trigger_lock);
 
 	INIT_LIST_HEAD(&mrioc->fwevt_list);
 	INIT_LIST_HEAD(&mrioc->tgtdev_list);
-- 
2.45.2

