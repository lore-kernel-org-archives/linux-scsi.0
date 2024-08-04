Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B651E80B;
	Sun,  4 Aug 2024 07:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722756161; cv=none; b=ggeOayZw/pM2YfHEim/SMB/UlSqZUWBUKLPfYK9rbOHAMSVsyacJ329ME5kzjWLGAkZhmyjrCwHA4eoEFUKG0Wj70cTGmCT7TWmhtPG9hJ+r2AcujXVvs/d6eJvTXo9NFJI/UvwbXYJcyH7mUE6BETSPRAQx5ibwJfFDXCg3tkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722756161; c=relaxed/simple;
	bh=pEg7NKttWt+PEsAx0S4atArTENcvZrfXCM6nOp+A2Zs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UaCUvsX9dwitcjk7DcchEfUcEtiobvSIHZ+g+TCGnWcjkkyaFe6yN9vc3PLeg+t9x77iu8ELixe7kYwsfE/2iCOpRpO5NF8Fn0Mf7VSlK4GJ47b1YtVvMkDw9roB91Dvhjgb6IUjZPot2w0lp8bVyqGZ0fcNnJMFVw+873H72KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jLD9960C; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jLD9960C"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1722756159; x=1754292159;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pEg7NKttWt+PEsAx0S4atArTENcvZrfXCM6nOp+A2Zs=;
  b=jLD9960CV0lGM3/1XSrK1vzZvJtZN8DmANVMcgQQGdp/HTKk9N+Xjy4K
   tAGBFHtnSKm3A+vDz8m5WmqAHGUm+HOzObK3Qlye/8LBOad/c1cKzUNTu
   bPMkB9trQ3+LcKw60mKJSZ742KEDzHHZm/R99HUnEVBlUwPLWlTCjwTT/
   VvAD8MZ4M/CWFgbYJlCNnWIMEgaTeY1XhCAAhxMMe1Rf+Sf7FUv4KqUT6
   NNINDR9NnzAsDe/ZWm5VjTY7i4bfbUHZ8iLI56jMxwHzCwr9NlU8qy5eB
   5laU0v4sdr0ur8OWkU/3yqVSIOJ0B95VKTYUV9J8YQ1IoQQyV3R9dt06I
   w==;
X-CSE-ConnectionGUID: 2VZU0DNASWaPk8czcOtDFQ==
X-CSE-MsgGUID: yPkz1fEvTmS+Hs6UJ9U40Q==
X-IronPort-AV: E=Sophos;i="6.09,262,1716220800"; 
   d="scan'208";a="23711338"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Aug 2024 15:22:33 +0800
IronPort-SDR: 66af1e42_DPWvLBdpfFrIL51J2M7HgkxyrQpRvl6wwgukWLg9b8jRIJU
 wtgCacrcab1OCXA/xg5UhEBp7asq99xXoPpvrqg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Aug 2024 23:22:59 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Aug 2024 00:22:31 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 0/2] scsi: ufs: Add host capabilities sysfs group
Date: Sun,  4 Aug 2024 10:21:07 +0300
Message-Id: <20240804072109.2330880-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Martin,

This patch series add sysfs entries for the host capabilities registers.
This platform info is otherwise not available. Please consider this
patch series for the next merge window.

Thanks,
Avri

---

Changes in v2:
 - Add sysfs doc
 - replace the pm_runtime_xx by ufshcd_rpm_xx for hci register read

---

Avri Altman (2):
  scsi: ufs: Prepare to add HCI capabilities sysfs
  scsi: ufs: Add HCI capabilities sysfs group

 Documentation/ABI/testing/sysfs-driver-ufs |  48 ++++++++
 drivers/ufs/core/ufs-sysfs.c               | 133 ++++++++++++++++++---
 include/ufs/ufshci.h                       |   5 +-
 3 files changed, 168 insertions(+), 18 deletions(-)

-- 
2.25.1

