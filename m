Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964D4238C2A
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 05:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753248363; cv=none; b=RPRGlUSSNGIhioHCgv5KWcJZlWfWwqAJLXObaFpmSHFzRDCz0o/FhH0+eDRwQeBlFmzQzBDfHVePxPIlInI5ueaNFnWy7GG+juXU/ND7kGNvOjF0+etwX0DIS0VAM9FkdKl1/KycfJSUttHy+qtiOtFotedWocN6tGxpfrR6VdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753248363; c=relaxed/simple;
	bh=Z5mZkUaY0q3ACLWX8IvxSQvwiaywgEmEHIupcSGu1Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dpasOZYmHUykVTzH0dJUn58A6yD+A6oP6VZO4Q2yubgPrQRlRlaXge531Xm9U0kj7kUYFW1ddGYXOuwlg3iozKDtiJ3H7PLJOW47ifJPPNPb2ChiaUzxWACXsvvI8g+EZDO8nekz52lsRsTFX5mAbIdsIAQ5rwczvE0NAq0MA2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1tgFnei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1tgFnei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032A9C4CEE7;
	Wed, 23 Jul 2025 05:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753248363;
	bh=Z5mZkUaY0q3ACLWX8IvxSQvwiaywgEmEHIupcSGu1Zg=;
	h=From:To:Cc:Subject:Date:From;
	b=L1tgFnei0Phojbz2ssyzsmatDMbfiCLBSVIvAE8u03Oews3OpOZlm+rO4a58Gj66p
	 rRAJ0V1DLbmlL2HIOAhXu2oWcyLoIP8tfriVOdLhIMtxmRN2OCh8/J+hcZWDL7NvJm
	 Z+7OffdRvYOx4zEBL8gM12ZRdtCEdeH7Ot7Joe8SGJc2H6uZuZAm+/466/1TXc+oH3
	 avDwp4xVpqhw8YdblWZH5D9DHYX34INY9lNm5JBgB3+y7FIL7Y4G6BxKglWuHl24wc
	 p00XlZwtc7E6w9PJX5q3aT8oJj5+QSGyDfJ1a1QCdLwt64Kpj0DsUpUnijWXTTeKnm
	 1IzHKI5KgEiwQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com
Cc: Friedrich Weber <f.weber@proxmox.com>
Subject: [PATCH 0/2] Disable CDL probing on ATA with mpt2sas and mpt3sas
Date: Wed, 23 Jul 2025 14:23:32 +0900
Message-ID: <20250723052334.32298-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin,

Friedrich reported issues with HBAs using the mpt3sas driver and CDL
probe, particularly on device hot-plug. These 2 patches address this
issue by force-disabling CDL probing with mpt2sas and mpt3sas. This has
no effect on feature limitation since the firmware of all HBAs driven by
mpt2sas and mpt3sas do not have a SAT implementation capable of handling
CDL on ATA devices.

Damien Le Moal (2):
  scsi: Allow SCSI hosts to force-disable CDL support probing
  scsi: mpt3sas: Disable Command Duration Limit Probing

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 ++
 drivers/scsi/scsi.c                  | 6 +++++-
 include/scsi/scsi_host.h             | 6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

-- 
2.50.1

