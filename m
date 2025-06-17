Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934662BF012;
	Tue, 17 Jun 2025 10:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750154605; cv=none; b=i1YDtBiaixJ1OvaapBDttVmNpq6UwrXk/RV6O4TbWIAQVoMq9MN26s3Cu8xo0T8wL8m8T7Le2Wrv2Io+Y5jl8hW1T3Cy3tN4EtCTxkWVjewHmV8jD0cZ9rvtDToXeH0YzTgClaNo/GnigQvuOAQEtfaukCeXHdt7cmmbYLxhJ+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750154605; c=relaxed/simple;
	bh=vDseggZPlNNEp+ybqhzFguBws6RBkzSe0p57oXgsotI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=brwqYf3fNJaHZJpsSM6KxM/GnpPbM9f01XOzh51/TBQzd/ZpZH5fPmEwPrWTzkeu4lhfDAcNaX6pm0+0nlJoMP0BO+EAd6GTG9DnCLCHH6qbUz9dZed/Gtvk1sGq82Yi0S8HPmzEielE9yXbgr1sEK2Qco4x8/48LqOnv4Erc0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=IrqOPYRl; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="IrqOPYRl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1750154603; x=1781690603;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vDseggZPlNNEp+ybqhzFguBws6RBkzSe0p57oXgsotI=;
  b=IrqOPYRl53wcG/3VUbdKKLUYmUnWL/3fFtidd5RtlI2tsrf5K1qxoeht
   KugURO22aYIZIvAh1x6A/a0pS9yEu2juCJbmTtbdzigbyP/1fJZKHMNhd
   JTGciYOF+FrfI0CBzA8SpJnM8G1//aPQGSWpMYBVQk6c4+TW/0afZlYuK
   WvPaIjXpU8vYqSsC3eWHjn7IhGM06om+3I5K4Lav4uxJNH2hQOPuBckUf
   k1cki1sEFZ/pPBBUBq7iyW58q3nuk2UEDLriYX8+SZJ/AZBqCseEj25tR
   AbicTG150Cidvozkk/JJ04mUWC4vM7M4C3eASKW0A9NI9zEz3OJphlqkj
   A==;
X-CSE-ConnectionGUID: H0hGyXBKTZi3Ckm5Dqi8EQ==
X-CSE-MsgGUID: 99y+SXklSIaa5XFdJjvEmg==
X-IronPort-AV: E=Sophos;i="6.16,242,1744041600"; 
   d="scan'208";a="90748002"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2025 18:03:16 +0800
IronPort-SDR: 68512ef1_fq1kboJ0nbpBr7kTs6yELx694pKA4keyUdLWpjE1IcU/OMe
 2bJqFOMaYU2RrnMKxtHNHZUAvVQqrJpBi5N7jzw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jun 2025 02:01:38 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jun 2025 03:03:15 -0700
From: Avri Altman <avri.altman@sandisk.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>
Subject: [PATCH 0/2] scsi: ufs: Two minor optimizations in query UPIU preparation
Date: Tue, 17 Jun 2025 12:56:09 +0300
Message-Id: <20250617095611.89229-1-avri.altman@sandisk.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This short series introduces two minor optimizations to the UPIU
preparation code in the UFS core driver. Shouldn't have functional
impact.

Avri Altman (2):
  scsi: ufs: Clear ucd_rsp_ptr for UPIU requests once
  scsi: ufs: Document NOP_OUT transaction code

 drivers/ufs/core/ufshcd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

-- 
2.25.1

