Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902CA33993;
	Sun, 27 Oct 2024 08:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730017657; cv=none; b=A6WFg85pAL0ZautnjJbNECXOA6yuC17XDWulX5jEkP6QQ5vlrADwi5LzKWmbrMFNaPBbvTK9S+Gkm9rXV2acVp9y6LedRGD4dlTy9wzBpzzHyb/EigyFEv9mgjZ29IOEA0cI/M12auWqFSjILCaaBY1G3Ee9+BAAthoWt6/3MiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730017657; c=relaxed/simple;
	bh=tdI6gICm+nn4sHIDHn6ielBjJAiwon3U55rUAKs0jjs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VeH42dEwzLVmV6Ynl1blBOIHt7E65SFU9C5NXNcqiFNDgyjYTVgqFVIBXzPeSDzSeHYaF9uAKmX3btnBGoLsUHRem1EoSZSOh1W+QPKug0NdpjVqahCUVmXf2oZqLUHqV9Ug6P8+cin4JNfSoc1RrUvo5TGeOJ6yushhu6Xo8Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=q2WC//uJ; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="q2WC//uJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730017655; x=1761553655;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tdI6gICm+nn4sHIDHn6ielBjJAiwon3U55rUAKs0jjs=;
  b=q2WC//uJO/d+RKZjTMVgHkSuS8FynSrXd9pp5oOHHbw7F457ZB7sy4L3
   stesY5OnYUH5ifS6HUW1oULpd0THoDfmnaeekvmtUFstxXdyFKP9W1CPS
   IpQJRB4+xm5it5kqoeW16YJyzIItjep8eTXTBolLZCiacSZ7WjpI/Rkzq
   OAL0l3uBS2HCQadBtEbjyHwOxSi084y6uUPyOUxz/t59Tvbx1+oOLE+4D
   WWFw4elIj8Rqg4CnDxd56auYPvctERLHwFw/sHd31GOIL4H/V4IbWdfey
   mYCNl6OMSmsQfKJ8qe1CoMg5ZlbQPw6c8TpQvOxGQN/mJbTOL+pzJqBXM
   Q==;
X-CSE-ConnectionGUID: v2wZRuwEQou3+hJS9r3NRw==
X-CSE-MsgGUID: /BYDzP62QbeLcu8pWpEhfw==
X-IronPort-AV: E=Sophos;i="6.11,236,1725292800"; 
   d="scan'208";a="30942555"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2024 16:27:29 +0800
IronPort-SDR: 671deafc_tbXMHCs8qD2Y+k43qNoR6h4NAC1E/FxJutaTTPZK23isB5q
 X2uAKJD015+IK+8QqLXEmTpagbbV35GkJlrBsMQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2024 00:25:48 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2024 01:27:28 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 0/2] Untie the host lock entanglement - part 2
Date: Sun, 27 Oct 2024 10:25:17 +0200
Message-Id: <20241027082519.576869-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is the 2nd part in the sequel, watering down the scsi host lock
usage in the ufs driver. This work is motivated by a comment made by
Bart [1], of the abuse of the scsi host lock in the ufs driver.  Its
Precursor [2] removed the host lock around some of the host register
accesses.

This part replace the scsi host lock by dedicated locks serializing
access to the clock gating and clock scaling members.


[1] https://lore.kernel.org/linux-scsi/0b031b8f-c07c-42ef-af93-7336439d3c37@acm.org/
[2] https://lore.kernel.org/linux-scsi/20241024075033.562562-1-avri.altman@wdc.com/

Avri Altman (2):
  scsi: ufs: core: Introduce a new clock_gating lock
  scsi: ufs: core: Introduce a new clock_scaling lock

 drivers/ufs/core/ufshcd.c | 92 ++++++++++++++++++++-------------------
 include/ufs/ufshcd.h      |  4 ++
 2 files changed, 52 insertions(+), 44 deletions(-)

-- 
2.25.1

