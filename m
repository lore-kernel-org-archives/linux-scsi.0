Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B5228D827;
	Mon, 14 Apr 2025 12:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744632184; cv=none; b=bOhGWb7qSp0N3+hCTY63+4Ef6oDnpAeh40+m5YJOCY8XP7T1/YOJm9RKIStVeUHoTtYFmsgOj7ZLFLv5C8XwDOLJRF3UdVzRrqLqnXpw0aq6hcIRyiyWDnyi6CjY9zMrYvdZjtT0fhMNa7RSV+y7SwIM7GIKLW2k8XdxfFvt1Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744632184; c=relaxed/simple;
	bh=yQhu3P/IVBTkj6xKgQDgbt0udy6TtralCwdBILsjbqw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GisnrQ2ekD4lmbdYbVnUgy1GjE+PQi1c1N/U1hiEEH3f0Cf02Mhfw2LMTxgWDCAJMWlj9XI0OLizrwOYH0+rYP50a4VUjf+OB9tRK301SAVKELUZfbHSxIfvJ6YiH/n6cpTKHW0ZWgbyEGFj9Lnhb36454Ji7cylUP+RhR+SQw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=wm3Q76uZ; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="wm3Q76uZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1744632182; x=1776168182;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yQhu3P/IVBTkj6xKgQDgbt0udy6TtralCwdBILsjbqw=;
  b=wm3Q76uZwaBx+wDOAD72IDN3TuS5vcqL1y/4PqHyYdxF0QKmSViZtKc2
   U+uQK8Tne4e2zBSfzr6YVFE3+EdcvyMLCTRgll/Q/vpHmCGsHfwSdpOQA
   MO16eRgq32UYqDI4Q5Xv1pRJ84kiLAst8k9hKIEX0jU7RL2yFT1VcGJw6
   JrRiTSA8RlIyQCh6IgomlYoUMzBJmY6vwRf3rRGpxCOB/QRQM1dCWpxdR
   T+HhTjqVG4RI5h1LqwdBycCE6hnJMTOr1R/rgbEIezPPWMucrGeGb9Az5
   Jryw9zQLXdClVV29N3//5+1+SVut4zr8ngCTyjNrIjVc/WF00jmh6naxp
   g==;
X-CSE-ConnectionGUID: YMPsY1kcQeOVJ8dc0UIymw==
X-CSE-MsgGUID: R8Qh5MOVRomEyWBdJ/pGng==
X-IronPort-AV: E=Sophos;i="6.15,212,1739808000"; 
   d="scan'208";a="81236032"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2025 20:03:01 +0800
IronPort-SDR: 67fceb6b_WvB7lkGHdaYXgz2KQMTW4Dkj82JgsSUJxQ9KaeeMFgxFc+4
 5oacgmI422vMvieH8FsOkPw7E8SZis+UDDseeIA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2025 04:03:07 -0700
WDCIronportException: Internal
Received: from unknown (HELO WDAP-ez2C89klLd.corp.sandisk.com) ([10.45.30.122])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Apr 2025 05:02:59 -0700
From: Arthur Simchaev <arthur.simchaev@sandisk.com>
To: arthur.simchaev@sandisk.com
Cc: avri.altman@sandisk.com,
	Avi.Shchislowski@sandisk.com,
	beanhuo@micron.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org
Subject: [PATCH v2] ufs: bsg: Add hibern8 enter/exit to ufshcd_send_bsg_uic_cmd
Date: Mon, 14 Apr 2025 15:02:57 +0300
Message-ID: <20250414120257.247858-1-arthur.simchaev@sandisk.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds functionality to allow user-level applications to send
the Hibern8 Enter command via the BSG framework. With this feature,
applications can perform H8 stress tests. Also can be used as one
of the triggers for the Eye monitor measurement feature added to the
M-PHY v5 specification.
For completion, allow the sibling functionality of hibern8 exit as well.

Signed-off-by: Arthur Simchaev <arthur.simchaev@sandisk.com>

---
Changed since v1:
 - elaborate commit log
---
 drivers/ufs/core/ufshcd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index be65fc4b5ccd..536b54ccc860 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4363,6 +4363,16 @@ int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 		goto out;
 	}
 
+	if (uic_cmd->command == UIC_CMD_DME_HIBER_ENTER) {
+		ret = ufshcd_uic_hibern8_enter(hba);
+		goto out;
+	}
+
+	if (uic_cmd->command == UIC_CMD_DME_HIBER_EXIT) {
+		ret = ufshcd_uic_hibern8_exit(hba, uic_cmd);
+		goto out;
+	}
+
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
-- 
2.49.0

