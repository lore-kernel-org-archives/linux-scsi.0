Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56591277C8B
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 08:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753260851; cv=none; b=CixHmHKbMvWVvo6gVZ80lUr0bPrFzsmfi+3bWER0cUd+QOoE64pRaZO+d9sPBUYH9qqhIZU7BGlNi2gsX3B80WJXVA6JS9SAK/xUrDWeHlrD2ZQqu7WbPYGVhkB7AMk0FNDJ3tDkBLsc38alwI566edx3cTlmwtCV+tN2tXHg/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753260851; c=relaxed/simple;
	bh=mKfCeGQUq77/r+GtnBsln8sExrFHwJgp/alcPKKSwww=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=N5Lc6lrZBOkt0cEtWmuKo6lHKIdQ4JT2tAMajr5HTF8k6BbHdkB1HtzvX2Cgo7l2X3TBVNVFzuxn259BOP+pabjuiG5K+XgWQPeLjiGigrP/u/KS4GMNHESIzZLnKE1K/JyRfsoNUSxP3oSmF0j3gMM5ZeL71/vkP+ItItwdIyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCEmIhM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCEmIhM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F23C4CEF5;
	Wed, 23 Jul 2025 08:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753260850;
	bh=mKfCeGQUq77/r+GtnBsln8sExrFHwJgp/alcPKKSwww=;
	h=From:To:Subject:Date:From;
	b=nCEmIhM7O9jmxBMkD+OnLuM9GpCEnfKGxMuWBb39665L/hIx7cbtteCfLlFuOHfLp
	 ZJS+Sr3JqI+tErXEkSJUJzR+dN53UssojXehsp5UxdcUs3/1UZpfrYTPdLIrJQyg7p
	 JaUHN6QJA08pPvL/kfpnVVa7zC2tdTXqhKKu/rVJSY7QJrb2uDyurDVOil4mO8IuEe
	 PkI4uw/STOReTSzrEfsrEHMokScwcbrJbXvWfoXzxO2Zl0779jhcgw7Qu5W/HXZZas
	 SaqKZuLaEqpAN1xpGwzJXPs1m2HTZjiuVgFICoAe/CQu9XDbawSqyr9SD5r3Cvac+X
	 LZKtTYBLnLUsA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 0/5] libsas cleanups
Date: Wed, 23 Jul 2025 17:51:38 +0900
Message-ID: <20250723085143.134333-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin, John,

While debugging an issue with the pm8001 driver, I generated these
cleanup patches. No functional changes overall.

These patches are against the 6.17/scsi-staging branch of the scsi tree.

Changes from v1:
 - Added patch 1
 - Modified patch 2 to not inline sas_ata_wait_eh()
 - Added review tags

Damien Le Moal (5):
  scsi: libsas: Refactor dev_is_sata()
  scsi: libsas: Simplify sas_ata_wait_eh()
  scsi: libsas: Make sas_get_ata_info() static
  scsi: libsas: Move declarations of internal functions to sas_internal.h
  scsi: libsas: Use a bool for sas_deform_port() second argument

 drivers/scsi/libsas/sas_ata.c      | 11 +---
 drivers/scsi/libsas/sas_discover.c |  2 +-
 drivers/scsi/libsas/sas_internal.h | 78 ++++++++++++++++++++++++-
 drivers/scsi/libsas/sas_phy.c      |  6 +-
 drivers/scsi/libsas/sas_port.c     | 13 ++---
 include/scsi/sas_ata.h             | 91 +++++-------------------------
 6 files changed, 102 insertions(+), 99 deletions(-)


base-commit: 3ea3a256ed81f95ab0f3281a0e234b01a9cae605
-- 
2.50.1

