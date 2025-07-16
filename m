Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB43726FD88;
	Wed, 16 Jul 2025 02:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752631534; cv=none; b=kMTavSvO6jOxtnvqqxkmI+tV+Z0JPy0hZv1yQgVxXGtIxoX+6Bn/9lFtY2oU1aSOwm8K9i2rKMyqJfTFtFPDMeZSPF+pnQAbVtoaDG0sJZ3af0bVaUc+/i3lCAxu+opVfCfbH8rWhjqVhekdf5tbma64k0hwzvhg76r0FKsVBn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752631534; c=relaxed/simple;
	bh=6jJmJJGRk+YiTP9EWNXFM9nhRYFIBVZ7/ZKRSEEfwa0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OtISLbUlG5PhR5481G6tV58flSXN1vr3v9yzT3nTicUin/GhEkt+gtLaRFnLN2N8deHvN4WIq5EVmErLSZ5R714kP0Xxrs+68a4SGmUlGi3UIZJWJ5a4dD9YoInP6aGqXLqRi9kI3LNqXCUVwEjmSADx98OXCQCzv8EZAjiDVJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQhBTTTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQhBTTTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A58DC4CEF1;
	Wed, 16 Jul 2025 02:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752631534;
	bh=6jJmJJGRk+YiTP9EWNXFM9nhRYFIBVZ7/ZKRSEEfwa0=;
	h=From:To:Subject:Date:From;
	b=HQhBTTTi8NJpSZ9fpo0C2CIEDa0L6CGeTYvopGXGtD8v/e32tVhFB+eEzJkdQLLTb
	 OjRED1jxwG0YEA598F46hVCvK5jrYzIcM9wiSVUJXFSsOWi0CBo9EgXze3fIbE9Hm/
	 PDOAqW493RsDgE+1uacutD9Q7o3w1k0A0DP0ZPvGkdRysbfuxVXFeD/gwbv3bn2Kmr
	 0LKtPa6uF52Oc9sGuumHaEEgWl9n15e/nScB2S7NYi78e/Bqzl3e35vAFVyDU+ykAw
	 MQ2R5r6lIPmyApH+4hVwgB6SVR3UrLZOg5F36eGVVNnomRzvO4yajLzhT1/cPX840Y
	 LzyFawfcAHs+Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v5 0/3] libata-eh cleanups
Date: Wed, 16 Jul 2025 11:03:12 +0900
Message-ID: <20250716020315.235457-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

3 patches to cleanup libata-eh code and its documentation.

Changes in patch 2 propagate to libsas.

No functional changes are introduced.

Changes from v4:
 - Added reivew tags
 - Fixedup patch 2 pata_parport modifications to keep the hardreset
   operation initialization to NULL

Changes from v3:
 - Move the use of the ATA_LFLAG_NO_HRST link flag in
   ata_std_error_handler() from patch 2 to patch 1.
 - Reduce number of changes in ata_eh_reset() in patch 2 using local
   variables.
 - Correct typos in patch 2 commit message and added suggested-by tag
 - Added review tag in patch 3

Changes from v2:
 - Removed former patch 1 "Make ata_eh_followup_srst_needed() return a
   bool" (sent it as a standalone patch)
 - Addressed Niklas'comment on patch 1
 - Added patch 2
 - Improved the description of reset methods in patch 3

Changes from v1:
 - Correct compilation error when CONFIG_ATA_SFF is not enabled by
   defining a stub for sata_sff_hardreset().

Damien Le Moal (3):
  ata: libata-eh: Remove ata_do_eh()
  ata: libata-eh: Simplify reset operation management
  Documentation: driver-api: Update libata error handler information

 Documentation/driver-api/libata.rst     | 25 +++++----
 drivers/ata/ahci.c                      |  6 +--
 drivers/ata/ahci_da850.c                |  6 +--
 drivers/ata/ahci_dm816.c                |  2 +-
 drivers/ata/ahci_imx.c                  | 13 ++---
 drivers/ata/ahci_qoriq.c                |  4 +-
 drivers/ata/ahci_xgene.c                |  8 +--
 drivers/ata/ata_piix.c                  |  4 +-
 drivers/ata/libahci.c                   | 10 ++--
 drivers/ata/libata-core.c               |  4 +-
 drivers/ata/libata-eh.c                 | 67 ++++++++-----------------
 drivers/ata/libata-pmp.c                | 26 ++++------
 drivers/ata/libata-sata.c               |  2 +-
 drivers/ata/libata-sff.c                | 18 ++-----
 drivers/ata/libata.h                    |  8 ++-
 drivers/ata/pata_acpi.c                 |  2 +-
 drivers/ata/pata_ali.c                  | 10 ++--
 drivers/ata/pata_amd.c                  |  4 +-
 drivers/ata/pata_artop.c                |  4 +-
 drivers/ata/pata_atiixp.c               |  2 +-
 drivers/ata/pata_efar.c                 |  2 +-
 drivers/ata/pata_ep93xx.c               |  4 +-
 drivers/ata/pata_hpt366.c               |  2 +-
 drivers/ata/pata_hpt37x.c               |  4 +-
 drivers/ata/pata_hpt3x2n.c              |  2 +-
 drivers/ata/pata_icside.c               |  2 +-
 drivers/ata/pata_it8213.c               |  2 +-
 drivers/ata/pata_jmicron.c              |  2 +-
 drivers/ata/pata_marvell.c              |  2 +-
 drivers/ata/pata_mpiix.c                |  2 +-
 drivers/ata/pata_ns87410.c              |  2 +-
 drivers/ata/pata_octeon_cf.c            |  2 +-
 drivers/ata/pata_oldpiix.c              |  2 +-
 drivers/ata/pata_opti.c                 |  2 +-
 drivers/ata/pata_optidma.c              |  2 +-
 drivers/ata/pata_parport/pata_parport.c |  4 +-
 drivers/ata/pata_pdc2027x.c             |  2 +-
 drivers/ata/pata_rdc.c                  |  2 +-
 drivers/ata/pata_sis.c                  |  2 +-
 drivers/ata/pata_sl82c105.c             |  2 +-
 drivers/ata/pata_triflex.c              |  2 +-
 drivers/ata/pata_via.c                  |  2 +-
 drivers/ata/pdc_adma.c                  |  2 +-
 drivers/ata/sata_dwc_460ex.c            |  2 +-
 drivers/ata/sata_fsl.c                  |  6 +--
 drivers/ata/sata_highbank.c             |  2 +-
 drivers/ata/sata_inic162x.c             |  2 +-
 drivers/ata/sata_mv.c                   | 10 ++--
 drivers/ata/sata_nv.c                   |  2 +-
 drivers/ata/sata_promise.c              |  4 +-
 drivers/ata/sata_qstor.c                |  4 +-
 drivers/ata/sata_rcar.c                 |  2 +-
 drivers/ata/sata_sil24.c                |  8 +--
 drivers/ata/sata_svw.c                  |  4 +-
 drivers/ata/sata_sx4.c                  |  2 +-
 drivers/ata/sata_uli.c                  |  2 +-
 drivers/ata/sata_via.c                  |  4 +-
 drivers/scsi/libsas/sas_ata.c           |  4 +-
 include/linux/libata.h                  | 26 ++++++----
 59 files changed, 166 insertions(+), 195 deletions(-)

-- 
2.50.1

