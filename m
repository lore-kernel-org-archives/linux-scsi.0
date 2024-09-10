Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1357E224D2;
	Tue, 10 Sep 2024 04:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725943667; cv=none; b=XGowVT2HnRM3uFoGjLEqtn7DC9VvmZ/rZH6UzDF2ukYHqOoGlDGtGXVay+T28FslxJ/HuvOx45zQ10NfUJpf+on+27xhyZCCql5i3wFrbXyY78tBZX3o6RhAj1XpcGNvtC+mNf/O1j8V2i5Knu1MHmBR00aeB/WFxerOiB9SqbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725943667; c=relaxed/simple;
	bh=3MYYxEigIIINVZRxEIuA2JyCRof2AI/wOpPHCQvchBo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t/+x8769ZzcB0Phj//dWhOnRmad47zjj+JG+axWf5nqtCb1/FGYjqKTLsyQIGhbMGEGhho4ItNRHlv+x/P9PuI2pYI41zdZdlT9bAx3lwCN/uKQUilOe7NwXnaPE/frv0VHAGF5tXmpwDPcKnN6tiGUOjYs49Kv6LYDBSkHWqPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=o/Ap0gf/; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="o/Ap0gf/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1725943665; x=1757479665;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3MYYxEigIIINVZRxEIuA2JyCRof2AI/wOpPHCQvchBo=;
  b=o/Ap0gf/lxHDyJm6zlyQH2Au6kdAYFUCcaJUEFRPnu6wfxnicLzzXaAP
   nlNwd9MMp9CnoiF57fzRO6HRNBi8XjmobYEDEWo26WSWXZV1eHw4idDh3
   GQ1GA6SZYIv/MFSgKs/x7IlPs8EwCplTk+uy+YUvlM7eGh0U5IHLuaDdT
   hrhfUTM2MSRJ940TrtB73H6VgXy465daDoOEDK3QdgU60lUHU7w7sxUuW
   uKhizRRZLiA1SIZ6k0xliJr5Nc9IzbjXbtuKglxr4yCBMoJrnP+dvQdNY
   okKnPNMbzw4ONiA13LZ/FtTZF+kX9U6RaCX7kQKYwF9Sh/PavuHXXQ2dJ
   A==;
X-CSE-ConnectionGUID: tBoeNfnSRw+2QtNGWf8kUA==
X-CSE-MsgGUID: qCqvyR2KRSCEN0EqyH5jHw==
X-IronPort-AV: E=Sophos;i="6.10,216,1719849600"; 
   d="scan'208";a="27323046"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2024 12:47:37 +0800
IronPort-SDR: 66dfc28c_tXdo7fRQzBUJqUx19pQ9dmCbaKrAsZTiiNcXPdGptbWXQ9d
 B7OtLE3KPg9bcN0Ux5JqKNSOy5FshpwTOZA3G/Q==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Sep 2024 20:52:44 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Sep 2024 21:47:36 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb
Date: Tue, 10 Sep 2024 07:45:43 +0300
Message-Id: <20240910044543.3812642-1-avri.altman@wdc.com>
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

Fixes: 26f968d7de82 ("scsi: ufs: Introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk")
Cc: stable@vger.kernel.org
Signed-off-by: Avri Altman <avri.altman@wdc.com>

---
Changes in v2:
 - add Fixes: and Cc: stable tags
 - fix kernel test robot warning about type mismatch by using le16_to_cpu
---
 drivers/ufs/core/ufshcd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8ea5a82503a9..85251c176ef7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2919,9 +2919,8 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 	struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
 	dma_addr_t cmd_desc_element_addr = hba->ucdl_dma_addr +
 		i * ufshcd_get_ucd_size(hba);
-	u16 response_offset = offsetof(struct utp_transfer_cmd_desc,
-				       response_upiu);
-	u16 prdt_offset = offsetof(struct utp_transfer_cmd_desc, prd_table);
+	u16 response_offset = le16_to_cpu(utrdlp[i].response_upiu_offset);
+	u16 prdt_offset = le16_to_cpu(utrdlp[i].prd_table_offset);
 
 	lrb->utr_descriptor_ptr = utrdlp + i;
 	lrb->utrd_dma_addr = hba->utrdl_dma_addr +
-- 
2.25.1

