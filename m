Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF294D8A7
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jul 2024 07:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721374755; cv=none; b=DSlGbQRfLhf7t7ZWz1adx5YE1zGGNB3F9c7lZMA218m/H2Atz0/hMoW+LmnCINWqIkFsPvC+7GAi9fhklWqELKXxaQ6iRTKAoQXCsFPWUj3HC7HcufmJ70u3gYjAjX4m+Rs5nCi9day7TP9tN46MnOIkD7d93OOpLyP+o0vKkH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721374755; c=relaxed/simple;
	bh=Bz3CKJFCB2bT8M9EOaz5HUt9QvH09t7BS29E1qXVU3I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eIAE+TnvrchTlsCuYHlcat6AmrcIhRm1o1zS/6KmiMri7u528YmgXfWcLpmCzd1sXFqi++TLVWh5wAO/RvFRCc1NseahykfsCHvxrKfonJ16/DZCpHPf5QHSTl8SYkj7pJwiDNxlfNYYPCqGdYPZmSqWYG/p7sWsOuGJlAU9vgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqqYavWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqqYavWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FBCC4AF0C;
	Fri, 19 Jul 2024 07:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721374755;
	bh=Bz3CKJFCB2bT8M9EOaz5HUt9QvH09t7BS29E1qXVU3I=;
	h=From:To:Cc:Subject:Date:From;
	b=LqqYavWR7e+9tBnL31+SW/j3qLGA6U5t1Fao4VpcRhT2M4yM7bbbaCp3hAo+vAH0d
	 t55Eh90m1Y3MiX3+e9Wv3U3nQCZ9w/AtdnT86IJurrgpdAaEtWFFoX3sCpXe3mZBjU
	 +/gBfHgVkpNGy6VR5Ivn67Vn+trPBNdMK+vijnB0GPvm83Rppl2cpQEy05rUg+tfXY
	 +zaMYIn3C+/LKbOVFm1csvqgMuYpnfHmsfByfnzEKPcerHpqox5ceJ3vCiG2krlfnL
	 jm0y0MLKb1hiYESWwubcsC2rxaJhY461Xytwf5QJHsWhq/6j+RV/ads2gBgGT46w+3
	 IfrexrVzz3q1A==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 0/2] Fix IOMMU page fault on report zones
Date: Fri, 19 Jul 2024 16:39:10 +0900
Message-ID: <20240719073913.179559-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A couple of patches to avoid IOMMU page faults error when executing a
report zones command on ATA SMR drives connected to mpt3sas or mpi3mr
SAS HBAs. These page faults happen only with AMD hosts and are not
triggered with Intel machines.

Damien Le Moal (2):
  scsi: mpi3mr: Avoid IOMMU page faults on report zones
  scsi: mpt3sas: Avoid IOMMU page faults on report zones

 drivers/scsi/mpi3mr/mpi3mr_os.c     | 11 +++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.c | 20 ++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

-- 
2.45.2

