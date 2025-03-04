Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153303D561;
	Tue,  4 Mar 2025 11:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741088828; cv=none; b=lqjr6IKtuF0zu4iDGW0OqzOK0EhcZjpRnNxelVld7Ks0+WbkdSBityTA4/TRZz++qtGNuI98qfGUFwv1FSEUCHI3ILvKEUHLvoZoQQR2QTA562D9nLJh79WII/6UplJe/1klX2abJwZeurl2ZIsejhioJlu94yParojMqip8fFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741088828; c=relaxed/simple;
	bh=BI+OERjpr3F5MqkVmf/ATnsKVeEyjD6eAIFFdA05qPk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KJl1/0fP6+J12d3YlzL/HahAEqr4twVOllrpO5X/60GZR++yaq13KC1mysyctUL2MWTAbaVc0xeXVKDwuhJ/4kVwEc//x0ctMcG7m8vDYnW770JabW6XMMirtPu2aikntQsWfORTdCeYfY36VnPYHe+QpaDQdJf32Q2tqeVfm1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=ml/sGR2D; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="ml/sGR2D"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1741088827; x=1772624827;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BI+OERjpr3F5MqkVmf/ATnsKVeEyjD6eAIFFdA05qPk=;
  b=ml/sGR2Di4Z1xgqw8SkGJIi54fz6H7IcqXvM4DQt+TDMIBe9H/+C4Yby
   0ijWm/IT2vfCNxHTY/8sHNsVjOUQcfzvd6vC6Qri43E1D4DAT2bTpeI4J
   uh/o+7HBEBFT9sRwpj7IffPdqNGqEehl3b58bq32RFKNfI/tV9w1SIwdh
   JDl9SiOfif1dVwU0xTd4KWDcyKsI6lCKwuAh/K3WpWacMvAVhv/pbzN7n
   R0YtyPD5hjz2qWyyUMsH269GVJHOFVRmkNe7VKGau5w3AppyjBH2mcSR/
   xWKldbSWvssO725nk8D5xZxz+F5KEJ4FaBN8CwufdrPEbQrW+3iKwzP1G
   g==;
X-CSE-ConnectionGUID: 8uWRA498TLuD4wRRxRsjUA==
X-CSE-MsgGUID: TlbsGDnXSrmNYKMRJUtw/w==
X-IronPort-AV: E=Sophos;i="6.13,331,1732550400"; 
   d="scan'208";a="40293757"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2025 19:47:06 +0800
IronPort-SDR: 67c6da6e_9iJ+RRmiqLCa/I61+C3/iCUsCZSZeD6xCLff8ZaXqHc7wHw
 e6RTLlv6tOCQI3M3qe/HHxG8z5a7a5bHw/9sEpQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Mar 2025 02:48:14 -0800
WDCIronportException: Internal
Received: from unknown (HELO WDAP-ez2C89klLd.corp.sandisk.com) ([10.45.30.122])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Mar 2025 03:47:04 -0800
From: Arthur Simchaev <arthur.simchaev@sandisk.com>
To: martin.petersen@oracle.com
Cc: avri.altman@sandisk.com,
	Avi.Shchislowski@sandisk.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	Arthur Simchaev <arthur.simchaev@sandisk.com>
Subject: [PATCH] ufs: core: bsg: Add hibern8 enter/exit to ufshcd_send_bsg_uic_cmd
Date: Tue,  4 Mar 2025 13:46:52 +0200
Message-Id: <20250304114652.210395-1-arthur.simchaev@sandisk.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eye monitor measurement functionality was added to the M-PHY v5
specification. The measurement of the eye monitor signal for the UFS
device begins when the link enters the hibernate state.
Hence, allow user-layer applications the capability to send the hibern8
enter command through the BSG framework. For completion, allow the
sibling functionality of hibern8 exit as well.

Signed-off-by: Arthur Simchaev <arthur.simchaev@sandisk.com>
---
 drivers/ufs/core/ufshcd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4e1e214fc5a2..546ab557a77c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4366,6 +4366,16 @@ int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 		goto out;
 	}
 
+	if (uic_cmd->command == UIC_CMD_DME_HIBER_ENTER) {
+		ret = ufshcd_uic_hibern8_enter(hba);
+		goto out;
+	}
+
+	if (uic_cmd->command == UIC_CMD_DME_HIBER_EXIT) {
+		ret = ufshcd_uic_hibern8_exit(hba);
+		goto out;
+	}
+
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
-- 
2.34.1

