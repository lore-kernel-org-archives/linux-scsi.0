Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBD6149E0E;
	Tue, 22 Oct 2024 07:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729583149; cv=none; b=D+U0dzGLhQKV4IFCX4VwSBLu9UD1o06soAE4d8jiUrkN12nrquA/58ck5Ww9HCaDRLwF1S1joZTtj4X4ycBSzAP5X+nVAvSz9KtFMTO55hn+pXO5Go/zpw80f2JY/Imz7lhH0WgQAQ0J9amNybJzPF/z28K+iQjSzJzi72cYp8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729583149; c=relaxed/simple;
	bh=UxZ6bvbCb77ujMYVMZzCYzvRlOwMevxBML19GKt+ack=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pfVErhsTLbVqwl3KPnngXoatE0Evx25zDWC49ToqPoKp6XgQcsbcqrIivnlLtENijSHXMQN5L7uDyq9bJk7rHMy5J5OewicKIUKg3w73OP14yY8nzQbFevcEdupkrUx/BIDlvLMpyZtjCUBHg3KhJB+TZElyixwLke1XQ0jASZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nAjwo/rq; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nAjwo/rq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729583148; x=1761119148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UxZ6bvbCb77ujMYVMZzCYzvRlOwMevxBML19GKt+ack=;
  b=nAjwo/rq2xDj73YtrHbiEdgp+QVwqOUaNsvb1yXD1A3SmllkxogrziFF
   xknegau/BEWQhUenfeiydggvQdL8oBT0OomdNYqQt1KBsFyoK7njQzYEc
   8S4V8jn+BNd2EqGdB24vaq8hKCQO7B2q4Rk6q+z5GkfXQuuNbBidEUfKg
   Y4MKrnCpbqPjmEF88U/2BtnPDzY2/fPcxPyZHCdf0pjBH94gRyriYhQ92
   fGnOAub5BYTBUzi6ywFmp/iXOuOSRQHxxvcEae1eR2AzSXwUTcTSPOlyb
   NdTZOkFNLK1o1MughutwLWYgoM+banLJhx2WR9Hbw9r09jChb4iKpDxNx
   Q==;
X-CSE-ConnectionGUID: 5I4qgx3JS5yvYaIyMDs2eg==
X-CSE-MsgGUID: ipM/o746QH6O+9i1d6wwbQ==
X-IronPort-AV: E=Sophos;i="6.11,222,1725292800"; 
   d="scan'208";a="29679844"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2024 15:45:41 +0800
IronPort-SDR: 671749b5_vh8y220RFFrJcI8fmHiIOC2MRlXLQj7qv6o/9CEiqIRP0hM
 z5M/Yj1N4LNSfhO83Tr7X0iqlJCtBMLjKy6407g==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2024 23:44:06 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Oct 2024 00:45:39 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 2/3] scsi: ufs: core: Remove redundant host_lock calls around UTMRLCLR
Date: Tue, 22 Oct 2024 10:43:18 +0300
Message-Id: <20241022074319.512127-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241022074319.512127-1-avri.altman@wdc.com>
References: <20241022074319.512127-1-avri.altman@wdc.com>
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

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 29f1cd3375bd..ca6b6df797fd 100644
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

