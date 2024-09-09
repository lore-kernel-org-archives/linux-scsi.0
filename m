Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3EB175D21;
	Mon,  9 Sep 2024 09:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725875927; cv=none; b=aY+FBZKcFinkJeRKmMTVOg11fap44+Bs8xKfjiz3ZaUdNGCREuy2EJDTXd29iWBbkCjJabBF07HH9ApTArzI14LF0SXZvxXpx4XBWaomBtMU9bw3OBKNzdDBle7Caj0gQizFu4oI++ObI1POS6KRmJ68A1X73uPCcq3QBucQ4XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725875927; c=relaxed/simple;
	bh=AoeX4cp4AZC6Uz9D1At8LlEzifxcucNkyBNyGvR7Ygo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u3sTKOaOdA9BY2cpQQlPRvq/+emgVx840szQD6pXcUx5VB0V/7Yc8AirFPt1i/xJK2mZky3HokWGlfFfI4fGQrMeBRRWJ6XE+EFQLuyzhxq424LdErqiuK0UCI48H+YtSm7gf9VQWmL3yHi3fqQKk7z3QBmkE6adxO3nhDYGB28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HIHnJRx5; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HIHnJRx5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1725875925; x=1757411925;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AoeX4cp4AZC6Uz9D1At8LlEzifxcucNkyBNyGvR7Ygo=;
  b=HIHnJRx5XTFLUPb6aRxHMY0xAxZWL+9J8TiHS7lOMxSLDy7D0SjtbQgc
   SVoeA3z4aDEA0Zk5EzncR17BFY1tmJSmD+Oiy1ymCM+bOuuRfzZ5+IlFH
   nbCPDiV6wj6mA8U4SIYd6pygKWdEBYzdWQQyTmw5kIxatF9vky8rBc4ND
   IqEEY18zzSuWUZG+o5w5+Bc9hmZTD5XDeUDHwv4SjF3vUO9lNTb2nH1Wl
   mbefZKC2Gg7D9+tVs6ZEFKgqliXvJk+Z3nrD8IwBg0HWo3m/t5eO27L7s
   8kdJeoZpGqAg7r/J98t637NLIw4cyKIek6neYptgzGpzaHEUGwGSchzeu
   g==;
X-CSE-ConnectionGUID: pIU0beIhTMmOJChnPDBKBQ==
X-CSE-MsgGUID: unLo4UDjSgCiGxT2cMO1Rw==
X-IronPort-AV: E=Sophos;i="6.10,213,1719849600"; 
   d="scan'208";a="26246093"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Sep 2024 17:58:37 +0800
IronPort-SDR: 66deb9f1_grHJXNo5RhOqXY0LVRMS7P/PdFQhoBB9P2dAY6qjgKe/FbQ
 27MR7gn5FWvyhFLZvYCbNxeNa8EVqY2QO9fGOOQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Sep 2024 02:03:45 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Sep 2024 02:58:34 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb
Date: Mon,  9 Sep 2024 12:56:46 +0300
Message-Id: <20240909095646.3756308-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace manual offset calculations for response_upiu and prd_table in
ufshcd_init_lrb() with pre-calculated offsets already stored in the
utp_transfer_req_desc structure. The pre-calculated offsets are set
differently in ufshcd_host_memory_configure() based on the
UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk, ensuring correct alignment and
access.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8ea5a82503a9..e7ed3625710e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2919,9 +2919,8 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 	struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
 	dma_addr_t cmd_desc_element_addr = hba->ucdl_dma_addr +
 		i * ufshcd_get_ucd_size(hba);
-	u16 response_offset = offsetof(struct utp_transfer_cmd_desc,
-				       response_upiu);
-	u16 prdt_offset = offsetof(struct utp_transfer_cmd_desc, prd_table);
+	u16 response_offset = utrdlp[i].response_upiu_offset;
+	u16 prdt_offset = utrdlp[i].prd_table_offset;
 
 	lrb->utr_descriptor_ptr = utrdlp + i;
 	lrb->utrd_dma_addr = hba->utrdl_dma_addr +
-- 
2.25.1

