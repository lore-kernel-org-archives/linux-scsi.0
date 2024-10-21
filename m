Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B3F1EABA6;
	Mon, 21 Oct 2024 12:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729512358; cv=none; b=LkPFOHXaUZPIcYBPxDSDl15rl/2rTG8IMunCikJJH9miiGivJ87kPMn5Kd+mV1o9ryi/nejapZ353+BiwKk+e2TyuNLrrpFlpFRF3SZGFA04KlA79/FYznfL7OH8hLWlC3/6VdLjsekVAWdn6FNGYPqbsAzC/9ETGmHxf7mGAoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729512358; c=relaxed/simple;
	bh=TfHS6fsENhaF/hIqepQjlW1Tz+LVrupzEVhHjDPZ9oA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N9nYXzQ9qOsdErVK9gTvnIt12gOWm3HmfZnDAW7NHWEMkib9VF+txjd1+6TRWoiRZqZQaDJGIEuH5aLNJy0GW+rHr7VfyTVTmIj6SDX144m/ZaQQYKIKWhGXQblbZocFwIqjYoXsI1v1uiNnJdzzkZJ/2cNH8DqoJZp6SMuHtbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GVNee7E4; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GVNee7E4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729512356; x=1761048356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TfHS6fsENhaF/hIqepQjlW1Tz+LVrupzEVhHjDPZ9oA=;
  b=GVNee7E4d36JRLG0soxpRFyR2rRvwiLmSA6NUX94Z+6SSezH6+WBtbky
   XDA/xM4wTdQZNsAbmQZdpUncw7HDgeXwk4AefXuVDbF3ZQCdnoWyu9HqV
   yYCNYrEFUXZy7DMn9xAy+ubRiC2rBSe/pBXdBCoAExrAy3ubK7ybX95xR
   oIPv82NOOdcLbXG74aRULvqkpGljBQLtmm15KEW4ugAC7S8wxJ1wptHHi
   zCJCUM/J4RpgtfeLWoKn2148MyuUgpTXK+HMsODOJBBdaaV+aNWkIDAHN
   uHuxmj/omvkOsbMJDuk2s0X/w4HbETWwWyYOdL8lb/x7J8l+Yjxf3uhaZ
   A==;
X-CSE-ConnectionGUID: V2F6fuCzRPaHi/kTMYll5A==
X-CSE-MsgGUID: I7sbvonKT+mHAhDWzo8+8Q==
X-IronPort-AV: E=Sophos;i="6.11,220,1725292800"; 
   d="scan'208";a="30593017"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2024 20:05:52 +0800
IronPort-SDR: 67163532_nAB0R/j9a6rTsMUGF31UBuVSAFU3zpQT3fRSQ1XpSoAWeQ/
 ALvzfZVpcVZjZPiRkBtuzx6an7ULJf86AMZccAg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2024 04:04:18 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2024 05:05:51 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 4/4] scsi: ufs: core: Use reg_lock to protect HCE register
Date: Mon, 21 Oct 2024 15:03:13 +0300
Message-Id: <20241021120313.493371-5-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241021120313.493371-1-avri.altman@wdc.com>
References: <20241021120313.493371-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the host register lock to serialize access to the Host Controller
Enable (HCE) register as well, instead of the host_lock.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4eee737a4fd5..3cc8ffc6929f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4795,9 +4795,9 @@ void ufshcd_hba_stop(struct ufs_hba *hba)
 	 * Obtain the host lock to prevent that the controller is disabled
 	 * while the UFS interrupt handler is active on another CPU.
 	 */
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->reg_lock, flags);
 	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->reg_lock, flags);
 
 	err = ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE,
 					CONTROLLER_ENABLE, CONTROLLER_DISABLE,
-- 
2.25.1

