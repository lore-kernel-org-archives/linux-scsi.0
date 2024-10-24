Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C9149C42;
	Thu, 24 Oct 2024 07:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729756367; cv=none; b=bfqSCnSDy9OqXTB1GJtayUVt5VddPOHT0rDhB2N1Qixq+sNPyiprFax0EwSSikc8kcS7bHuEIL9ikza65PJFNSxr5cT/fzbXy5Zk40shb2qehCmlL3RkFXOqyIAwyjOGSBj7ImGF+f3+dAIsjgSckOJ+iVdk0w3h651lmpGDCrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729756367; c=relaxed/simple;
	bh=OBgeXMgXB7lWPG64KctKSuo5WncijrmwaG1Ev8IYCws=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MFXfgMVJcPJQizYm2+BSSksX2UDmleEvRp+YPOYQD8fSc1S2KofRZd2YU27hHkQ59ykHpi2A2FGQFzSman71sNBtYEfYT0CKH2ELTsWZcAD7hSFm7SgB8xRqzNyVHTFCS4AzTZ3p2jBq66IpGgRGC5Ytp6E1YGGG7TvVX6PIDKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=S303C2Vp; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="S303C2Vp"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729756366; x=1761292366;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OBgeXMgXB7lWPG64KctKSuo5WncijrmwaG1Ev8IYCws=;
  b=S303C2Vp9Eucm7StZDe2Bn17zsThLWIs8zjZX4q52ed3I+xsU8VMV+QQ
   bHz6CKEHcbXqsG0Pb0obEy0amXFXOL3l6wXSnUuI6weC69RrhtxKLFXom
   us/2bjikxhLXZssWP/pw2NFSBDcPdJZzYYsti7Io8aHORbjgzwEGK8I02
   ukdrtyAhsTgjnddm8ssgTWypPXXNjZXLti8jlPAzuFWTdjrS0tLYSyk0m
   Ea3szTveE3pzpVO2qIyYvBTGjyJcvIu2GPufWUGwkV7y65r1SOHCWC5HV
   t5kVqTjnd/uY++mVumopvvi2pwJw3ojScoHVcN5+D/Yal0lok71njIPoU
   A==;
X-CSE-ConnectionGUID: whLPTryySbqoPkMxXb5hRg==
X-CSE-MsgGUID: ATh4849lR9iAvnoTqeWGhg==
X-IronPort-AV: E=Sophos;i="6.11,228,1725292800"; 
   d="scan'208";a="29156098"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Oct 2024 15:52:39 +0800
IronPort-SDR: 6719ee56_Y8BloZOZMZqOf/1eePl387MZmwywqGHbsjaYiPT0ujkMfWW
 oQn+GMBfUou1ACPolNny5YDBwqPQZWjPWj/Wdgw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Oct 2024 23:51:02 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Oct 2024 00:52:38 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 0/3] Untie the host lock entanglement - part 1
Date: Thu, 24 Oct 2024 10:50:30 +0300
Message-Id: <20241024075033.562562-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While trying to simplify the ufs core driver with the guard() macro [1],
Bart made note of the abuse of the scsi host lock in the ufs driver.
Indeed, the host lock is deeply entangled in various flows across the
driver, as if it was some occasional default synchronization mean.

Here is the first part of defusing it, remove some of those calls around
host registers accesses, which needs no protection.

Doing this in phases seems like a reasonable approach, given the myriad
use of the host lock.


Changes compared to v2:
 - leave out changing ufshcd_tmc_handler

Changes compared to v1:
 - get rid of redundant locking (Bart)
 - leave out the HCE register

[1] https://lore.kernel.org/linux-scsi/0b031b8f-c07c-42ef-af93-7336439d3c37@acm.org/

Avri Altman (3):
  scsi: ufs: core: Remove redundant host_lock calls around UTMRLDBR.
  scsi: ufs: core: Remove redundant host_lock calls around UTMRLCLR
  scsi: ufs: core: Remove redundant host_lock calls around UTRLCLR.

 drivers/ufs/core/ufshcd.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

-- 
2.25.1

