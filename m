Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D251B11CBA;
	Mon, 14 Jul 2025 00:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752454633; cv=none; b=fOScdWSk7OfeRkEOPC9maXrMoP7XmZfe0djf/ISTVHP+Zz0kw0S5GXFv3JFiMklBDhXP+MRg62d6UYgvIw8CfihvrhqIUQFdxfA6Pf20Gd6m8ekjYypYsAKL4dsecEmtkxGLqX30UHmgDm+gswFIpVhoast0nn070WTVYB62/NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752454633; c=relaxed/simple;
	bh=5L6piBwSRD2UdpOMv8XQS/wbHH8tKhwR9iSIJlYLWrk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rMnKJTr4RLFGUNzvI18Alv1rm7s0n3MtbqTn6GkMhv7iw1xUDn3W8SGqTmuXSbE/BH9hMMiP4vE5gzF6PkXPyedSYuDpDqREGeChXbjgRGSQmKhgiJRhpceTVoOHgVapuurDnyoZvLNaPaGj9tKuIIlolNANBwmVKZJojGJy7R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pxCKEsps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pxCKEsps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7743DC4CEF4;
	Mon, 14 Jul 2025 00:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752454633;
	bh=5L6piBwSRD2UdpOMv8XQS/wbHH8tKhwR9iSIJlYLWrk=;
	h=From:To:Subject:Date:From;
	b=pxCKEspsS0c3ufWpwnB4JzbHOamk++0SpIFVzW22eYm7EOa7/fOffHisiCCrfmOiL
	 Oq2tUFP0xzL+g7eQHltM6xxRLkU6DHKZite3FGi9g9xrdCLbqm/xhpCDUIIfyVSmW6
	 vN+MV+LcxEoEJ7qlEkeZgFrPAaKPGRy5IWdJQUBmDhEkklU63imFvvK3ADxNvFMGNt
	 t9NSAjWp+WE6GGXWIDuf+ebaWvD9/dL2Mw+o8a642lLoewZ6Zz0iG00lmpafKyEg8G
	 kRPTLpKFwKChwCE4eXHYiYRTOxlkCHR4NnQwqfcRNuMObG8p9H/YXR0b3ztwEViSLk
	 iyZHXnt+Y249A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 0/3] libata-eh cleanups
Date: Mon, 14 Jul 2025 09:54:51 +0900
Message-ID: <20250714005454.35802-1-dlemoal@kernel.org>
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
 drivers/ata/pata_parport/pata_parport.c |  3 +-
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
 59 files changed, 165 insertions(+), 195 deletions(-)

-- 
2.50.1

