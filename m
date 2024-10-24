Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8191AF0D6;
	Thu, 24 Oct 2024 07:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729756371; cv=none; b=XYAFO6rnvKrRiCDy/fSqw4oUspNqfdOjjjRE99i+fcrKuwHFdDcDr756TyjtTdpRs3Gp+P2Wdsj5e+fIWHvPgA1IdZeW+iEi3Zd2I55DOswoKdsKmmCV6swIlE3flsPLw5vUQllqSyGDsGIF2Yp2fXTwmQYnRZZUL6+JnA18J1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729756371; c=relaxed/simple;
	bh=SRocwuixUYSgIE0bkZnSwSKBfeC4gykcO7qkFJlSgHY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DhvDZL2avsdRVz40mlT1P3A4xvqW+sS7pPLDGA30kfI65LxTSd4lX77rIAjLl26DOqeITLvKbvHEpo6dYxhsRTjoNb/n2lAZvD73K+XbWPkX/yV/OasSX/W+XMVNw0nmZBOSzvnjy9beuKuMAYlr1GgaPo2ncV/C0nqCx40dl4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=N0unCHey; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="N0unCHey"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729756369; x=1761292369;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SRocwuixUYSgIE0bkZnSwSKBfeC4gykcO7qkFJlSgHY=;
  b=N0unCHeypRvW0D1tnOpAK7Ff39lkgGcRYdHTuFlWDVQcq6GBv5vd81Mv
   HZOOxyFJll/qe5sEaf70Rsp3bsmvrXN27vPypuWSVLyH2kcEdB1RHke6w
   vA5EOdPN5uF5I3+cWiit13qkACMhFm0cP8LYG7IxL74dZyW2ESvYmbPfp
   Zv5kUB4QfBKjNUJ1sziAWFOqqwq+hqa/RMsgeAiupooU7p1KSSQkgRODW
   duikuZEmOs/RlfMLBAqyWjfnpzO0Xr4cjnfSBp5Q1Ev86K5O0QqV/floC
   lZzDyIh03EkYPh3EghcYDIhTVy0oCjVmjUD59ToEMcWOR3sxDq30pS4W0
   A==;
X-CSE-ConnectionGUID: BX5U/cqZTH2ZzjciCj3SQA==
X-CSE-MsgGUID: 64NfhDn5TYqyAewlIUyIrA==
X-IronPort-AV: E=Sophos;i="6.11,228,1725292800"; 
   d="scan'208";a="29156110"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Oct 2024 15:52:47 +0800
IronPort-SDR: 6719ee5d_gOVQGwvdr4ILfAuNXyu4ql/LhQkqTNwSxd34sOzI7+knNFl
 e6I1s9+DW0y8bKtEECs7VVKj2leVy8j3uuJvrXA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Oct 2024 23:51:09 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Oct 2024 00:52:45 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 2/3] scsi: ufs: core: Remove redundant host_lock calls around UTMRLCLR
Date: Thu, 24 Oct 2024 10:50:32 +0300
Message-Id: <20241024075033.562562-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241024075033.562562-1-avri.altman@wdc.com>
References: <20241024075033.562562-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no need to serialize single read/write calls to the host
controller registers. Remove the redundant host_lock calls that protect
access to the task management request List cLear register: UTMRLCLR.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index faea4b294bdb..c2f44834062e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7012,14 +7012,11 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 {
 	int err = 0;
 	u32 mask = 1 << tag;
-	unsigned long flags;
 
 	if (!test_bit(tag, &hba->outstanding_tasks))
 		goto out;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_utmrl_clear(hba, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* poll for max. 1 sec to clear door bell register by h/w */
 	err = ufshcd_wait_for_register(hba,
-- 
2.25.1

