Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A2FA48
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 00:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753315503; cv=none; b=Tpk5dcPr8JqRbYPrjKUcye81Da/9e3zWEOqtCKR+n8EHScyYmEgbPV+h5/aeMYfbAcibVFIeNGYcgj1KsAakCqD7sqgsqqjIOd0+pwcbjA8MOUmep64Dv2o7rov50s4R8nWbCgaQ2tVJVjUti+w8WdlvtWemvC7CDmmGPZflJkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753315503; c=relaxed/simple;
	bh=qemURw/x69WRgIrLu4hTDl6qmeqQOS30Uyqzt2Wvbes=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YLXSbALEe6xwTPltiFqkZbX/PiW7Y2gVdW1Z5GosSmPG/97/4/PcC5slY1KO6MM/vpiAmWBUGRQDwrbVDoXsOmlZEkSgu8Jc112T1e5hHiAqp8kulKSX4Ya0PVSppF6GqFqA3s2fodGOzPFmWHsw3+mYdbsqtV27KVLngSFIdyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PydYLWH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PydYLWH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCD1C4CEEF;
	Thu, 24 Jul 2025 00:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753315502;
	bh=qemURw/x69WRgIrLu4hTDl6qmeqQOS30Uyqzt2Wvbes=;
	h=From:To:Subject:Date:From;
	b=PydYLWH+Of9wXaB0HagfdIgcF5YYCppcXqW59WeAlB3490DiBdjRwAClKMjpxzS6B
	 aGJHZAcOxxf3giCc9Lq+RtjWM3vXUWxbBik59P4UcjP7JkGhOkHYAMF5HvpeNXUVsD
	 RgsDTPXPsqNMOJMCmq1meQ17G8A+Q2vkCFC5UKTYp5zuZezsHcNq7Z7my1zSsOm5YJ
	 PGYqvpEG9jgDbnfCjq4dCb83ENVQ99UED/FGkkJHHnNoSvPcWaFGH3JHHNIyfm+lal
	 1ziuwjzbwH06t4kPlu0Rw741yTFQKJE0X7W9O6LufgMsWwb+iCHfMBhhyBFpgzKWRC
	 +RZcr51/pkfNw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 0/5] libsas cleanups
Date: Thu, 24 Jul 2025 09:02:30 +0900
Message-ID: <20250724000235.143460-1-dlemoal@kernel.org>
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

