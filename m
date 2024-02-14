Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE0A5577F;
	Wed, 14 Feb 2024 14:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707922250; cv=none; b=OrwSATxPyQuVMuDy8Q+VdIIpjXR6fyNVnf8LBe/uUbOOCJS2lM3wuXAxI06OnBtR9qdZ7X0I8hCMxZjVfe5ZNFERuK6WGPhgh7Wq8Na6noWkWl9Kz1Ozp6ByESl8smkb2n8BEi0LWcu6TBiu++yUgkx0uvapUOBnR8IhJcIfBig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707922250; c=relaxed/simple;
	bh=gpEl7I8AQ9ZRN7Yrn9GliYr/re58hUppDZDkku6MdKA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O0gDkh/tdGMWxrkkDjbpSWCSDg/txVyPs3WryxjNoJMGhVWk+2r+Pt8cPTu9H0MiRjiZDDkjqjZjEISaHp7hfv17RksFhkGeJ6KuloHW3fFyLkU9QSPwGaj6YBcjeFSFDuFd90H2keHgEUwadGdBvGmS1RalDmr16ubeSBWNTH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bkr0AjtU; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bkr0AjtU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707922248; x=1739458248;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gpEl7I8AQ9ZRN7Yrn9GliYr/re58hUppDZDkku6MdKA=;
  b=bkr0AjtU4PJ4/gsmbGrFnxvIzXaULq+xDJ8V8pkU3GqQuK1fjyjxJ8GT
   ag56X712j1RE/G4EWxZ9vVkFSNi+Td5sdZ6jVNvVyIRwXCH1kbqlkqBbj
   9nbq0kVgKYFgPZKiCqcxf3axP/ZNUeYvLxMX+sRgH3qc3J/kJL9L+sDRx
   bF/KZwhKSvyWdO094wPO3JOSIHfd/VWfDm25k8bkizGC2bTalXqTeJAcC
   q/xAy/Wju5lGSYxq0WfXNQAYVnjwRfahVcC+CccdPuU7fJM02SHx39FEz
   bO9XUiT6WBmqXbkPAPStkun9QfxbLufs0vh9cShaC44f29SU7bLaoFZzN
   Q==;
X-CSE-ConnectionGUID: Xxj5jJdfR/aEoAqtajZ7EQ==
X-CSE-MsgGUID: E5HDPQ/rQ5KYOb1E/uJcAQ==
X-IronPort-AV: E=Sophos;i="6.06,159,1705334400"; 
   d="scan'208";a="8888883"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2024 22:50:42 +0800
IronPort-SDR: qE74NCWKFVjFJSAZvCA9whuKuNx1rJ1+NqQUMJsqTDDif7BS+OXE4Z4NrLxFvM0AMvO6jw9df7
 OZ1b7hbP5Gzg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2024 06:00:17 -0800
IronPort-SDR: XuMcabTrVQD/NRMgSXTz0UMkLoU8Z542x45fUwtqqslVgIWnHOodR64Dka0zBBBYxy1veX/QCM
 wt5nkUd7GXXw==
WDCIronportException: Internal
Received: from unknown (HELO naota-xeon.wdc.com) ([10.225.163.55])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Feb 2024 06:50:40 -0800
From: Naohiro Aota <naohiro.aota@wdc.com>
To: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Cc: martin.petersen@oracle.com,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH] scsi: target: pscsi: fix bio_put for error case
Date: Wed, 14 Feb 2024 23:43:56 +0900
Message-ID: <20240214144356.101814-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.43.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As of commit 066ff571011d ("block: turn bio_kmalloc into a simple kmalloc
wrapper"), a bio allocated by bio_kmalloc() must be freed by bio_uninit()
and kfree(). That is not done properly for the error case, hitting WARN and
NULL pointer dereference in bio_free().

Fixes: 066ff571011d ("block: turn bio_kmalloc into a simple kmalloc wrapper")
CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 drivers/target/target_core_pscsi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 41b7489d37ce..ed4fd22eac6e 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -907,12 +907,15 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	return 0;
 fail:
-	if (bio)
-		bio_put(bio);
+	if (bio) {
+		bio_uninit(bio);
+		kfree(bio);
+	}
 	while (req->bio) {
 		bio = req->bio;
 		req->bio = bio->bi_next;
-		bio_put(bio);
+		bio_uninit(bio);
+		kfree(bio);
 	}
 	req->biotail = NULL;
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-- 
2.43.1

