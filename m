Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A0F2236E1;
	Fri, 11 Jul 2025 08:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752223080; cv=none; b=pYIbPOzIWOwR5K+eiTjEdLWFiRnzqGvyICs73L5hAUvYi3LO57r/Qm246FbWPy/uO6d8yrwDXAR7a7IAswx4x/qe00iaj0ZExof/Jas3NCgb0IdJTOZwgsRDmC0TNmekOXtCssHVBXWsBqEUbV/cEsMTQ+6icc8BqBhqlvbc3II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752223080; c=relaxed/simple;
	bh=r20PXwx2+Tk5rz5tBseqWz6aOkjiZA1WYIMqs5y9eqM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=R1WLYw36dlI1CFJLVMX8Qx4lXUH1hJArRD+7jSomAHxhnVkUJbv57l61FswJ59stutuTHCdcmsAZxgSjgoviXBjDiDAB0kXW+ZP2MKB9Wr42HsypjbS4hSYhK3mJUMAtwImSnlcT1CcJJN3/UNuIVkYbvxu2bDJiNg0vZBGkPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eeJzUxQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eeJzUxQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88817C4CEEF;
	Fri, 11 Jul 2025 08:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752223080;
	bh=r20PXwx2+Tk5rz5tBseqWz6aOkjiZA1WYIMqs5y9eqM=;
	h=From:To:Subject:Date:From;
	b=eeJzUxQPR4a4Y2QG+Gn/SCGmYUujH+NZWOghzhSE6u9eIjxvqfmzrc4iCoqx1+mxh
	 3GyEx/msfKbZIvdAF3Pwg5pqiBg/7HDdGP62M8p5Hc1PMZxoP09TUvfsW5EWG67y7B
	 +uHrAYl5i/Ql8jSRFnIjv+n3VB04Fmrd6dagRkN5q1kfFkmOlg33yvCdBSP+l2ujG0
	 NwdbasefmUQWUHH95axik3Ipqlir7whzUh1VqyPS6ZpUX3H169pxXmzrJWQkuGwOkb
	 MYGjyrVJvNNYatgnofWOiB+IRWLdVoSuFtBGSWDUi7tg/Jbatai8sXIP6JyUGWjk3z
	 ed5fgIZr7JY8w==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 0/3] libata-eh cleanups
Date: Fri, 11 Jul 2025 17:35:41 +0900
Message-ID: <20250711083544.231706-1-dlemoal@kernel.org>
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

 Documentation/driver-api/libata.rst     | 25 +++++---
 drivers/ata/ahci.c                      |  6 +-
 drivers/ata/ahci_da850.c                |  6 +-
 drivers/ata/ahci_dm816.c                |  2 +-
 drivers/ata/ahci_imx.c                  | 13 ++--
 drivers/ata/ahci_qoriq.c                |  4 +-
 drivers/ata/ahci_xgene.c                |  8 +--
 drivers/ata/ata_piix.c                  |  4 +-
 drivers/ata/libahci.c                   | 10 +--
 drivers/ata/libata-core.c               |  4 +-
 drivers/ata/libata-eh.c                 | 81 +++++++++----------------
 drivers/ata/libata-pmp.c                | 26 +++-----
 drivers/ata/libata-sata.c               |  2 +-
 drivers/ata/libata-sff.c                | 18 ++----
 drivers/ata/libata.h                    |  8 +--
 drivers/ata/pata_acpi.c                 |  2 +-
 drivers/ata/pata_ali.c                  | 10 +--
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
 drivers/ata/sata_fsl.c                  |  6 +-
 drivers/ata/sata_highbank.c             |  2 +-
 drivers/ata/sata_inic162x.c             |  2 +-
 drivers/ata/sata_mv.c                   | 10 +--
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
 include/linux/libata.h                  | 26 ++++----
 59 files changed, 172 insertions(+), 202 deletions(-)

-- 
2.50.1

