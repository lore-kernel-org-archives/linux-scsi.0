Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213A91373
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 02:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753408846; cv=none; b=dUSbaou5tOizLlVekRNzGFRUz/yHER31D+z4smsBItrzWL4K6N3uhxVJC6KxQdokAQDgGvzmVP1W9VcXkH35MdhG/rrfaiPlqW5H+lZk4AdyJouDWSeS2izr8BjM6/lcavV5FKgSlxXt7Z6iiEdVb3vhJTancoQH7uadxVQ3FX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753408846; c=relaxed/simple;
	bh=wdlyzF8ZaP1KWddmlRMEGkVkhYijPtDjHmkTbm7hGv8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jo1jXPZPqhoVQSOLKXJGx7Ra9+9XWRbXj9KNazoJ6Q1aXyqw3ity4har/pEmPsAyE8bYPvWL9Q61RCKzu1tIrzlwLNk/HqlVJ/8lGM5/1PA2ElnCby+N9u4D+c4nSICR9hhAn3p8dSJ20LBuHN3PLx2TpCluXGlXHiwx1n7cDtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHtscaWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHtscaWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5C2C4CEED;
	Fri, 25 Jul 2025 02:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753408845;
	bh=wdlyzF8ZaP1KWddmlRMEGkVkhYijPtDjHmkTbm7hGv8=;
	h=From:To:Subject:Date:From;
	b=UHtscaWG7UcCLhlV8SwSJKrRxRDIO6Sn1izUBF07Z8cjKwvjhD08mpSPBze0XAaVc
	 5hVbS1E8NEFxtDMP0Uq/n+kld2kZV4agkE33UKNg02iPMlakiVqA6wZnxRm+q+c8D1
	 J7gnomMx/s8SxsMJci93a3NTQNfinBxYD9k8reBTxAB27wwMVkNM13bb3pyHTZouyC
	 StSi33IUXqTqGfqqXXs9Y8YJubkCnAaq3tddtnuHrqFuD0woftSXUgdJbkA3CaIiTz
	 7Grg2058eS8CnXNB/1y5UpYv16olQX26WMG2u7GMaFSWThIf4RCwUXvWSDvtMvgs/y
	 PwQyATYW3hcjw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 0/5] libsas cleanups
Date: Fri, 25 Jul 2025 10:58:13 +0900
Message-ID: <20250725015818.171252-1-dlemoal@kernel.org>
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

Changes from v3:
 - Corrected commit message of patch 2
 - Added review tags

Changes from v2:
 - Modified patch 2 to remove the unnecessary check using dev_is_ata()
 - Added review tags

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

 drivers/scsi/libsas/sas_ata.c      | 10 +---
 drivers/scsi/libsas/sas_discover.c |  2 +-
 drivers/scsi/libsas/sas_internal.h | 78 ++++++++++++++++++++++++-
 drivers/scsi/libsas/sas_phy.c      |  6 +-
 drivers/scsi/libsas/sas_port.c     | 13 ++---
 include/scsi/sas_ata.h             | 91 +++++-------------------------
 6 files changed, 101 insertions(+), 99 deletions(-)


base-commit: 3ea3a256ed81f95ab0f3281a0e234b01a9cae605
-- 
2.50.1

