Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1499414A4F0;
	Tue, 22 Oct 2024 07:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729583129; cv=none; b=BTZr/bn3Vj4u5iTdD5HZvrdr/DxrcCusCNsgXotQZHaK0CiaC1yHJmZbgKSJyHFNFcrrVv5pfDVt5W2wazJuIVDAPxp1WIzhTjtEfysx0F5N7v65QG7huTmQId/aHE8ocVJBOQ53T7uVX1yqohHSIseCqm/DXRPNY+ZaLH6QQ44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729583129; c=relaxed/simple;
	bh=P+sigj3NdXbec5NDcpWfBeJ9hag3FsGgKYoz1DFkHtw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eEgRKwrRGfpVBfmTM2PH8tsK/t90B5enthCfkcexoX5dUsrfA0JL+D+r4i7QNDEQ/32Hx8RlFLk7eL/LgdC2VHjNbayW+ZDYVybXnKxi66NyUj2sSVRs0dciiynxYxkjD8UWD75/iQgrTwnq1OemH9gbR7UHzXXY3t5VWJq5Tko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=n68CvutR; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="n68CvutR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729583127; x=1761119127;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=P+sigj3NdXbec5NDcpWfBeJ9hag3FsGgKYoz1DFkHtw=;
  b=n68CvutRB9K5VDpT5jp9RNJgOAMJ1ukc54Pg8NrMrXaI4Tpha75qyure
   eGrz1BZVOYxQJv4v705vV+pcbLH065loLWhI9E5OKDhE6JW6Lz6fZptV1
   Hj/2eIgRibeH0oz9GcwFTfRJciLlpDRvoNvxejAMahYdszl13HzzZKohv
   4Msljthz4clRPiNlTZGaee3ZkmPbvzznmSno/IejSu2LkuiMQ3y/sTAEH
   CLNGnnKZBtVebsRwv0BxJ6mbXupxhMdiWa8+nCOzR+Qu7hYkFSUao/K/o
   BhbVi7ACJZAIBL694FaF/lTtdiyy8T6hrnzZfP5TMMos/quY7Vo+X2xnW
   Q==;
X-CSE-ConnectionGUID: 3zbmKEDRS6ebS4td2hEx2A==
X-CSE-MsgGUID: NxY1sKxRS06oQh/uDMpd1g==
X-IronPort-AV: E=Sophos;i="6.11,222,1725292800"; 
   d="scan'208";a="30533951"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2024 15:45:27 +0800
IronPort-SDR: 671749a7_If94Cuvg/ILrXCfjOUoEf8xqOCIcyTOjN/7T3KIfYNfi62C
 mIlkSs/6DXEzlFFRU7VHjXrZpvpe9BOQeD3XVGw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2024 23:43:52 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Oct 2024 00:45:25 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 0/3] Untie the host lock entanglement - part 1
Date: Tue, 22 Oct 2024 10:43:16 +0300
Message-Id: <20241022074319.512127-1-avri.altman@wdc.com>
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


Changes compared to v1:
 - get rid of redundant locking (Bart)
 - leave out the HCE register

[1] https://lore.kernel.org/linux-scsi/0b031b8f-c07c-42ef-af93-7336439d3c37@acm.org/

Avri Altman (3):
  scsi: ufs: core: Remove redundant host_lock calls around UTMRLDBR.
  scsi: ufs: core: Remove redundant host_lock calls around UTMRLCLR
  scsi: ufs: core: Remove redundant host_lock calls around UTRLCLR.

 drivers/ufs/core/ufshcd.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

-- 
2.25.1

