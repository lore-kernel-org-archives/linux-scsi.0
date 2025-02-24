Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CBE19258B
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2025 08:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740384012; cv=none; b=qvlnfv5bmkCJzj2Plj3Iy8f8ByGy+092XejdpuvOpVrPKoHNjcVowsAOcW73/88G065npEz5ZXFR8gL4P9ezC42mlXMmUxBNIc+n4EViTJTWylX7CcIbIjnmXvdUveblfFv/tIFmr1jLhBws6sz/Le8C1r2kF7L9AjT/n7/+7MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740384012; c=relaxed/simple;
	bh=Xd4oedjS5mRBvStLIQflCdGYi8iYAD4YJRK2TqG+8qA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KO2h2ifjrL0BUkcTMqS0dpdLEeHpUXcEqNmP3FWW0ax2NrB+ktU3+nwFQKeuRpJs9rXkYo3OYaZYjV2ho0EmsJBC4w8ECnuhgnBXdf0BxcV5JeIr4zZPT+CMKrCdFetZmnkDW7bHq9cDgvKUOhUmfTd3IlJPkvjxh+d7jkbwdcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=jhemCgoP; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="jhemCgoP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1740384011; x=1771920011;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Bw8tMw78S8R21QO2WRUUnizBixrnBKXCS7S3OqUR87I=;
  b=jhemCgoPW8zJlD5t7JuWj3Qqa5oOKmm7bM2kqtD5g7ABdR6l2/O3htCY
   HGpmO2bbBHuPsjo1PqJqSqKAClw2yw3BI9sA78PP0RtfjvfTOgWwtGrWO
   R07WQFPGXbpR/XD8aoQmbDzGBFUFCUFkSjYSoxln8h5EOR8lmn99s/+z4
   Y=;
X-IronPort-AV: E=Sophos;i="6.13,311,1732579200"; 
   d="scan'208";a="474723514"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 08:00:08 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.38.20:3760]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.48.97:2525] with esmtp (Farcaster)
 id e49110e6-2f0c-4a59-b2c7-f7c42191b148; Mon, 24 Feb 2025 08:00:06 +0000 (UTC)
X-Farcaster-Flow-ID: e49110e6-2f0c-4a59-b2c7-f7c42191b148
Received: from EX19D002AND002.ant.amazon.com (10.37.240.241) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 24 Feb 2025 08:00:06 +0000
Received: from HND-5CG1082HRX.ant.amazon.com (10.118.254.124) by
 EX19D002AND002.ant.amazon.com (10.37.240.241) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 24 Feb 2025 08:00:03 +0000
From: Yuichiro Tsuji <yuichtsu@amazon.com>
To: <linux-scsi@vger.kernel.org>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin
 K . Petersen" <martin.petersen@oracle.com>, Yuichiro Tsuji
	<yuichtsu@amazon.com>
Subject: [PATCH] scsi: qla2xxx: Fix typos in a comment
Date: Mon, 24 Feb 2025 16:59:07 +0900
Message-ID: <20250224075907.2505-1-yuichtsu@amazon.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWB004.ant.amazon.com (10.13.139.164) To
 EX19D002AND002.ant.amazon.com (10.37.240.241)

Fix typos in a comment.

hapens -> happens
recommeds -> recommends

Signed-off-by: Yuichiro Tsuji <yuichtsu@amazon.com>
---
 drivers/scsi/qla2xxx/qla_sup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 6d16546e1729..9e7a407ba1b9 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2136,8 +2136,8 @@ qla2x00_write_flash_byte(struct qla_hw_data *ha, uint32_t addr, uint8_t data)
  * @flash_id: Flash ID
  *
  * This function polls the device until bit 7 of what is read matches data
- * bit 7 or until data bit 5 becomes a 1.  If that hapens, the flash ROM timed
- * out (a fatal error).  The flash book recommeds reading bit 7 again after
+ * bit 7 or until data bit 5 becomes a 1.  If that happens, the flash ROM timed
+ * out (a fatal error).  The flash book recommends reading bit 7 again after
  * reading bit 5 as a 1.
  *
  * Returns 0 on success, else non-zero.
-- 
2.43.5

