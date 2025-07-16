Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C716427380C;
	Wed, 16 Jul 2025 02:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752631536; cv=none; b=Dr7U04KkuwFDWKOo58xuPW5ENd6dJgQd2p6H4TKXJPWY609eO6WHCUT9XZoIrLgZwUSKrm96lLkEN8QX+itHV9xL/Vj24rb+Cszrxf/FmG4uTvGqaMSzbM9gLD8yvI3GMPVnJ3WDRLoi8+hSy0vPo8y0KHKKoEOuRnvKxIdMnxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752631536; c=relaxed/simple;
	bh=ateg90QKzs22QnJpOQZS0HllYFh8nd5tdh6P1J7Uy/M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KajzWHaJsT9KhoP9vkWdVdCFZsPChCZzWY04zYDC8oRYY60ADhjXR8Jc9ChhHh+YcczbMQQjBjcNDO7TYs3fxJ+jJGP5qG4ZuL8NF8NRnmx+H3NVM8LVrrzmoKNKIwi/vuhAuU5BJGUNGeXysn/7kMF5vR2wDuhufpva2mTp40Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ScH3QDV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ScH3QDV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A22C4CEF8;
	Wed, 16 Jul 2025 02:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752631536;
	bh=ateg90QKzs22QnJpOQZS0HllYFh8nd5tdh6P1J7Uy/M=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ScH3QDV8prDicuxvU8SvVmNhZht+xhlIp8AyTT5q0lA1ieOP+hUzOlLlKyF4lJQoF
	 fZiOO/yNbYiqCpVYkzqA4nrZlqt4hdHR/mmq7rLvNCTAv95d+1UF9L6DARtPLqPw+q
	 7tirX3lOVl7drlSC+iRYGV9yig9+0mZF2c6+1AC8y9rC3P3ql650DaTEqaoqUgjcNZ
	 bTsD6xwjYJSOjvIxCkZcAMrSqU993Og64Vqr7Juy8sHnMuIZsTRiBM6uU2xUUrwrEb
	 M+t55xzt5Mv1CHufAhi33B3XJ+TVw4gEcH6AL6nzKSim9h078Imb3nMUEhxXWDqY2I
	 RKU/1BUaWJa/Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v5 2/3] ata: libata-eh: Simplify reset operation management
Date: Wed, 16 Jul 2025 11:03:14 +0900
Message-ID: <20250716020315.235457-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250716020315.235457-1-dlemoal@kernel.org>
References: <20250716020315.235457-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce struct ata_reset_operations to aggregate in a single structure
the definitions of the 4 reset methods (prereset, softreset, hardreset
and postreset) for a port. This new structure is used in struct ata_port
to define the reset methods for a regular port (reset field) and for a
port-multiplier port (pmp_reset field). A pointer to either of these
fields replaces the 4 reset method arguments passed to ata_eh_recover()
and ata_eh_reset().

The definition of the reset methods for all drivers is changed to use
the reset and pmp_reset fields in struct ata_port_operations.

A large number of files is modifed, but no functional changes are
introduced.

Suggested-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/ahci.c                      |  6 ++---
 drivers/ata/ahci_da850.c                |  6 ++---
 drivers/ata/ahci_dm816.c                |  2 +-
 drivers/ata/ahci_imx.c                  | 13 ++++++-----
 drivers/ata/ahci_qoriq.c                |  4 ++--
 drivers/ata/ahci_xgene.c                |  8 +++----
 drivers/ata/ata_piix.c                  |  4 ++--
 drivers/ata/libahci.c                   | 10 ++++-----
 drivers/ata/libata-core.c               |  4 ++--
 drivers/ata/libata-eh.c                 | 29 +++++++++++--------------
 drivers/ata/libata-pmp.c                | 26 ++++++++--------------
 drivers/ata/libata-sata.c               |  2 +-
 drivers/ata/libata-sff.c                |  8 +++----
 drivers/ata/libata.h                    |  8 +++----
 drivers/ata/pata_acpi.c                 |  2 +-
 drivers/ata/pata_ali.c                  | 10 ++++-----
 drivers/ata/pata_amd.c                  |  4 ++--
 drivers/ata/pata_artop.c                |  4 ++--
 drivers/ata/pata_atiixp.c               |  2 +-
 drivers/ata/pata_efar.c                 |  2 +-
 drivers/ata/pata_ep93xx.c               |  4 ++--
 drivers/ata/pata_hpt366.c               |  2 +-
 drivers/ata/pata_hpt37x.c               |  4 ++--
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
 drivers/ata/pata_parport/pata_parport.c |  4 ++--
 drivers/ata/pata_pdc2027x.c             |  2 +-
 drivers/ata/pata_rdc.c                  |  2 +-
 drivers/ata/pata_sis.c                  |  2 +-
 drivers/ata/pata_sl82c105.c             |  2 +-
 drivers/ata/pata_triflex.c              |  2 +-
 drivers/ata/pata_via.c                  |  2 +-
 drivers/ata/pdc_adma.c                  |  2 +-
 drivers/ata/sata_dwc_460ex.c            |  2 +-
 drivers/ata/sata_fsl.c                  |  6 ++---
 drivers/ata/sata_highbank.c             |  2 +-
 drivers/ata/sata_inic162x.c             |  2 +-
 drivers/ata/sata_mv.c                   | 10 ++++-----
 drivers/ata/sata_nv.c                   |  2 +-
 drivers/ata/sata_promise.c              |  4 ++--
 drivers/ata/sata_qstor.c                |  4 ++--
 drivers/ata/sata_rcar.c                 |  2 +-
 drivers/ata/sata_sil24.c                |  8 +++----
 drivers/ata/sata_svw.c                  |  4 ++--
 drivers/ata/sata_sx4.c                  |  2 +-
 drivers/ata/sata_uli.c                  |  2 +-
 drivers/ata/sata_via.c                  |  4 ++--
 drivers/scsi/libsas/sas_ata.c           |  4 ++--
 include/linux/libata.h                  | 17 ++++++++-------
 58 files changed, 134 insertions(+), 145 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5558e9f7b85d..e1c24bbacf64 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -110,17 +110,17 @@ static const struct scsi_host_template ahci_sht = {
 
 static struct ata_port_operations ahci_vt8251_ops = {
 	.inherits		= &ahci_ops,
-	.hardreset		= ahci_vt8251_hardreset,
+	.reset.hardreset	= ahci_vt8251_hardreset,
 };
 
 static struct ata_port_operations ahci_p5wdh_ops = {
 	.inherits		= &ahci_ops,
-	.hardreset		= ahci_p5wdh_hardreset,
+	.reset.hardreset	= ahci_p5wdh_hardreset,
 };
 
 static struct ata_port_operations ahci_avn_ops = {
 	.inherits		= &ahci_ops,
-	.hardreset		= ahci_avn_hardreset,
+	.reset.hardreset	= ahci_avn_hardreset,
 };
 
 static const struct ata_port_info ahci_port_info[] = {
diff --git a/drivers/ata/ahci_da850.c b/drivers/ata/ahci_da850.c
index ca0924dc5bd2..f97566c420f8 100644
--- a/drivers/ata/ahci_da850.c
+++ b/drivers/ata/ahci_da850.c
@@ -137,13 +137,13 @@ static int ahci_da850_hardreset(struct ata_link *link,
 
 static struct ata_port_operations ahci_da850_port_ops = {
 	.inherits = &ahci_platform_ops,
-	.softreset = ahci_da850_softreset,
+	.reset.softreset = ahci_da850_softreset,
 	/*
 	 * No need to override .pmp_softreset - it's only used for actual
 	 * PMP-enabled ports.
 	 */
-	.hardreset = ahci_da850_hardreset,
-	.pmp_hardreset = ahci_da850_hardreset,
+	.reset.hardreset = ahci_da850_hardreset,
+	.pmp_reset.hardreset = ahci_da850_hardreset,
 };
 
 static const struct ata_port_info ahci_da850_port_info = {
diff --git a/drivers/ata/ahci_dm816.c b/drivers/ata/ahci_dm816.c
index b08547b877a1..93faed2cfeb6 100644
--- a/drivers/ata/ahci_dm816.c
+++ b/drivers/ata/ahci_dm816.c
@@ -124,7 +124,7 @@ static int ahci_dm816_softreset(struct ata_link *link,
 
 static struct ata_port_operations ahci_dm816_port_ops = {
 	.inherits = &ahci_platform_ops,
-	.softreset = ahci_dm816_softreset,
+	.reset.softreset = ahci_dm816_softreset,
 };
 
 static const struct ata_port_info ahci_dm816_port_info = {
diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
index f01f08048f97..86aedd5923ac 100644
--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -642,18 +642,19 @@ static int ahci_imx_softreset(struct ata_link *link, unsigned int *class,
 	int ret;
 
 	if (imxpriv->type == AHCI_IMX53)
-		ret = ahci_pmp_retry_srst_ops.softreset(link, class, deadline);
+		ret = ahci_pmp_retry_srst_ops.reset.softreset(link, class,
+							      deadline);
 	else
-		ret = ahci_ops.softreset(link, class, deadline);
+		ret = ahci_ops.reset.softreset(link, class, deadline);
 
 	return ret;
 }
 
 static struct ata_port_operations ahci_imx_ops = {
-	.inherits	= &ahci_ops,
-	.host_stop	= ahci_imx_host_stop,
-	.error_handler	= ahci_imx_error_handler,
-	.softreset	= ahci_imx_softreset,
+	.inherits		= &ahci_ops,
+	.host_stop		= ahci_imx_host_stop,
+	.error_handler		= ahci_imx_error_handler,
+	.reset.softreset	= ahci_imx_softreset,
 };
 
 static const struct ata_port_info ahci_imx_port_info = {
diff --git a/drivers/ata/ahci_qoriq.c b/drivers/ata/ahci_qoriq.c
index 30e39885b64e..0dec1a17e5b1 100644
--- a/drivers/ata/ahci_qoriq.c
+++ b/drivers/ata/ahci_qoriq.c
@@ -146,8 +146,8 @@ static int ahci_qoriq_hardreset(struct ata_link *link, unsigned int *class,
 }
 
 static struct ata_port_operations ahci_qoriq_ops = {
-	.inherits	= &ahci_ops,
-	.hardreset	= ahci_qoriq_hardreset,
+	.inherits		= &ahci_ops,
+	.reset.hardreset	= ahci_qoriq_hardreset,
 };
 
 static const struct ata_port_info ahci_qoriq_port_info = {
diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index dfbd8c53abcb..5d5a51a77f5d 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -613,11 +613,11 @@ static irqreturn_t xgene_ahci_irq_intr(int irq, void *dev_instance)
 static struct ata_port_operations xgene_ahci_v1_ops = {
 	.inherits = &ahci_ops,
 	.host_stop = xgene_ahci_host_stop,
-	.hardreset = xgene_ahci_hardreset,
+	.reset.hardreset = xgene_ahci_hardreset,
+	.reset.softreset = xgene_ahci_softreset,
+	.pmp_reset.softreset = xgene_ahci_pmp_softreset,
 	.read_id = xgene_ahci_read_id,
 	.qc_issue = xgene_ahci_qc_issue,
-	.softreset = xgene_ahci_softreset,
-	.pmp_softreset = xgene_ahci_pmp_softreset
 };
 
 static const struct ata_port_info xgene_ahci_v1_port_info = {
@@ -630,7 +630,7 @@ static const struct ata_port_info xgene_ahci_v1_port_info = {
 static struct ata_port_operations xgene_ahci_v2_ops = {
 	.inherits = &ahci_ops,
 	.host_stop = xgene_ahci_host_stop,
-	.hardreset = xgene_ahci_hardreset,
+	.reset.hardreset = xgene_ahci_hardreset,
 	.read_id = xgene_ahci_read_id,
 };
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index d441246fa357..229429ba5027 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1074,7 +1074,7 @@ static struct ata_port_operations piix_pata_ops = {
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= piix_set_piomode,
 	.set_dmamode		= piix_set_dmamode,
-	.prereset		= piix_pata_prereset,
+	.reset.prereset		= piix_pata_prereset,
 };
 
 static struct ata_port_operations piix_vmw_ops = {
@@ -1102,7 +1102,7 @@ static const struct scsi_host_template piix_sidpr_sht = {
 
 static struct ata_port_operations piix_sidpr_sata_ops = {
 	.inherits		= &piix_sata_ops,
-	.hardreset		= sata_std_hardreset,
+	.reset.hardreset	= sata_std_hardreset,
 	.scr_read		= piix_sidpr_scr_read,
 	.scr_write		= piix_sidpr_scr_write,
 	.set_lpm		= piix_sidpr_set_lpm,
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 4e9c82f36df1..b335fb7e5cb4 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -162,10 +162,10 @@ struct ata_port_operations ahci_ops = {
 
 	.freeze			= ahci_freeze,
 	.thaw			= ahci_thaw,
-	.softreset		= ahci_softreset,
-	.hardreset		= ahci_hardreset,
-	.postreset		= ahci_postreset,
-	.pmp_softreset		= ahci_softreset,
+	.reset.softreset	= ahci_softreset,
+	.reset.hardreset	= ahci_hardreset,
+	.reset.postreset	= ahci_postreset,
+	.pmp_reset.softreset	= ahci_softreset,
 	.error_handler		= ahci_error_handler,
 	.post_internal_cmd	= ahci_post_internal_cmd,
 	.dev_config		= ahci_dev_config,
@@ -192,7 +192,7 @@ EXPORT_SYMBOL_GPL(ahci_ops);
 
 struct ata_port_operations ahci_pmp_retry_srst_ops = {
 	.inherits		= &ahci_ops,
-	.softreset		= ahci_pmp_retry_softreset,
+	.reset.softreset	= ahci_pmp_retry_softreset,
 };
 EXPORT_SYMBOL_GPL(ahci_pmp_retry_srst_ops);
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bbf1318a2b9a..97d9f0488cc1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -65,8 +65,8 @@
 #include "libata-transport.h"
 
 const struct ata_port_operations ata_base_port_ops = {
-	.prereset		= ata_std_prereset,
-	.postreset		= ata_std_postreset,
+	.reset.prereset		= ata_std_prereset,
+	.reset.postreset	= ata_std_postreset,
 	.error_handler		= ata_std_error_handler,
 	.sched_eh		= ata_std_sched_eh,
 	.end_eh			= ata_std_end_eh,
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 30c831e56a7f..2946ae6d4b2c 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2793,13 +2793,16 @@ static bool ata_eh_followup_srst_needed(struct ata_link *link, int rc)
 }
 
 int ata_eh_reset(struct ata_link *link, int classify,
-		 ata_prereset_fn_t prereset, ata_reset_fn_t softreset,
-		 ata_reset_fn_t hardreset, ata_postreset_fn_t postreset)
+		 struct ata_reset_operations *reset_ops)
 {
 	struct ata_port *ap = link->ap;
 	struct ata_link *slave = ap->slave_link;
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_eh_context *sehc = slave ? &slave->eh_context : NULL;
+	ata_reset_fn_t hardreset = reset_ops->hardreset;
+	ata_reset_fn_t softreset = reset_ops->softreset;
+	ata_prereset_fn_t prereset = reset_ops->prereset;
+	ata_postreset_fn_t postreset = reset_ops->postreset;
 	unsigned int *classes = ehc->classes;
 	unsigned int lflags = link->flags;
 	int verbose = !(ehc->i.flags & ATA_EHI_QUIET);
@@ -3756,10 +3759,7 @@ static int ata_eh_handle_dev_fail(struct ata_device *dev, int err)
 /**
  *	ata_eh_recover - recover host port after error
  *	@ap: host port to recover
- *	@prereset: prereset method (can be NULL)
- *	@softreset: softreset method (can be NULL)
- *	@hardreset: hardreset method (can be NULL)
- *	@postreset: postreset method (can be NULL)
+ *	@reset_ops: The set of reset operations to use
  *	@r_failed_link: out parameter for failed link
  *
  *	This is the alpha and omega, eum and yang, heart and soul of
@@ -3775,9 +3775,7 @@ static int ata_eh_handle_dev_fail(struct ata_device *dev, int err)
  *	RETURNS:
  *	0 on success, -errno on failure.
  */
-int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
-		   ata_reset_fn_t softreset, ata_reset_fn_t hardreset,
-		   ata_postreset_fn_t postreset,
+int ata_eh_recover(struct ata_port *ap, struct ata_reset_operations *reset_ops,
 		   struct ata_link **r_failed_link)
 {
 	struct ata_link *link;
@@ -3845,8 +3843,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		if (!(ehc->i.action & ATA_EH_RESET))
 			continue;
 
-		rc = ata_eh_reset(link, ata_link_nr_vacant(link),
-				  prereset, softreset, hardreset, postreset);
+		rc = ata_eh_reset(link, ata_link_nr_vacant(link), reset_ops);
 		if (rc) {
 			ata_link_err(link, "reset failed, giving up\n");
 			goto out;
@@ -4077,20 +4074,20 @@ void ata_eh_finish(struct ata_port *ap)
  */
 void ata_std_error_handler(struct ata_port *ap)
 {
-	struct ata_port_operations *ops = ap->ops;
+	struct ata_reset_operations *reset_ops = &ap->ops->reset;
 	struct ata_link *link = &ap->link;
 	int rc;
 
 	/* Ignore built-in hardresets if SCR access is not available */
-	if ((ops->hardreset == sata_std_hardreset ||
-	     ops->hardreset == sata_sff_hardreset) && !sata_scr_valid(link))
+	if ((reset_ops->hardreset == sata_std_hardreset ||
+	     reset_ops->hardreset == sata_sff_hardreset) &&
+	    !sata_scr_valid(link))
 		link->flags |= ATA_LFLAG_NO_HRST;
 
 	ata_eh_autopsy(ap);
 	ata_eh_report(ap);
 
-	rc = ata_eh_recover(ap, ops->prereset, ops->softreset,
-			    ops->hardreset, ops->postreset, NULL);
+	rc = ata_eh_recover(ap, reset_ops, NULL);
 	if (rc) {
 		struct ata_device *dev;
 
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index d5d189328ae6..57023324a56f 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -15,9 +15,9 @@
 
 const struct ata_port_operations sata_pmp_port_ops = {
 	.inherits		= &sata_port_ops,
-	.pmp_prereset		= ata_std_prereset,
-	.pmp_hardreset		= sata_std_hardreset,
-	.pmp_postreset		= ata_std_postreset,
+	.pmp_reset.prereset	= ata_std_prereset,
+	.pmp_reset.hardreset	= sata_std_hardreset,
+	.pmp_reset.postreset	= ata_std_postreset,
 	.error_handler		= sata_pmp_error_handler,
 };
 
@@ -727,10 +727,7 @@ static int sata_pmp_revalidate_quick(struct ata_device *dev)
 /**
  *	sata_pmp_eh_recover_pmp - recover PMP
  *	@ap: ATA port PMP is attached to
- *	@prereset: prereset method (can be NULL)
- *	@softreset: softreset method
- *	@hardreset: hardreset method
- *	@postreset: postreset method (can be NULL)
+ *	@reset_ops: The set of reset operations to use
  *
  *	Recover PMP attached to @ap.  Recovery procedure is somewhat
  *	similar to that of ata_eh_recover() except that reset should
@@ -744,8 +741,7 @@ static int sata_pmp_revalidate_quick(struct ata_device *dev)
  *	0 on success, -errno on failure.
  */
 static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
-		ata_prereset_fn_t prereset, ata_reset_fn_t softreset,
-		ata_reset_fn_t hardreset, ata_postreset_fn_t postreset)
+				   struct ata_reset_operations *reset_ops)
 {
 	struct ata_link *link = &ap->link;
 	struct ata_eh_context *ehc = &link->eh_context;
@@ -767,8 +763,7 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 		struct ata_link *tlink;
 
 		/* reset */
-		rc = ata_eh_reset(link, 0, prereset, softreset, hardreset,
-				  postreset);
+		rc = ata_eh_reset(link, 0, reset_ops);
 		if (rc) {
 			ata_link_err(link, "failed to reset PMP, giving up\n");
 			goto fail;
@@ -932,8 +927,7 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
  retry:
 	/* PMP attached? */
 	if (!sata_pmp_attached(ap)) {
-		rc = ata_eh_recover(ap, ops->prereset, ops->softreset,
-				    ops->hardreset, ops->postreset, NULL);
+		rc = ata_eh_recover(ap, &ops->reset, NULL);
 		if (rc) {
 			ata_for_each_dev(dev, &ap->link, ALL)
 				ata_dev_disable(dev);
@@ -951,8 +945,7 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 	}
 
 	/* recover pmp */
-	rc = sata_pmp_eh_recover_pmp(ap, ops->prereset, ops->softreset,
-				     ops->hardreset, ops->postreset);
+	rc = sata_pmp_eh_recover_pmp(ap, &ops->reset);
 	if (rc)
 		goto pmp_fail;
 
@@ -978,8 +971,7 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 		goto pmp_fail;
 
 	/* recover links */
-	rc = ata_eh_recover(ap, ops->pmp_prereset, ops->pmp_softreset,
-			    ops->pmp_hardreset, ops->pmp_postreset, &link);
+	rc = ata_eh_recover(ap, &ops->pmp_reset, &link);
 	if (rc)
 		goto link_fail;
 
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 47169c469f43..4734465d3b1e 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1704,6 +1704,6 @@ const struct ata_port_operations sata_port_ops = {
 	.inherits		= &ata_base_port_ops,
 
 	.qc_defer		= ata_std_qc_defer,
-	.hardreset		= sata_std_hardreset,
+	.reset.hardreset	= sata_std_hardreset,
 };
 EXPORT_SYMBOL_GPL(sata_port_ops);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index e61f00779e40..7fc407255eb4 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -31,10 +31,10 @@ const struct ata_port_operations ata_sff_port_ops = {
 
 	.freeze			= ata_sff_freeze,
 	.thaw			= ata_sff_thaw,
-	.prereset		= ata_sff_prereset,
-	.softreset		= ata_sff_softreset,
-	.hardreset		= sata_sff_hardreset,
-	.postreset		= ata_sff_postreset,
+	.reset.prereset		= ata_sff_prereset,
+	.reset.softreset	= ata_sff_softreset,
+	.reset.hardreset	= sata_sff_hardreset,
+	.reset.postreset	= ata_sff_postreset,
 	.error_handler		= ata_sff_error_handler,
 
 	.sff_dev_select		= ata_sff_dev_select,
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index ca44fb792aeb..e5b977a8d3e1 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -180,11 +180,9 @@ extern void ata_eh_autopsy(struct ata_port *ap);
 const char *ata_get_cmd_name(u8 command);
 extern void ata_eh_report(struct ata_port *ap);
 extern int ata_eh_reset(struct ata_link *link, int classify,
-			ata_prereset_fn_t prereset, ata_reset_fn_t softreset,
-			ata_reset_fn_t hardreset, ata_postreset_fn_t postreset);
-extern int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
-			  ata_reset_fn_t softreset, ata_reset_fn_t hardreset,
-			  ata_postreset_fn_t postreset,
+			struct ata_reset_operations *reset_ops);
+extern int ata_eh_recover(struct ata_port *ap,
+			  struct ata_reset_operations *reset_ops,
 			  struct ata_link **r_failed_disk);
 extern void ata_eh_finish(struct ata_port *ap);
 extern int ata_ering_map(struct ata_ering *ering,
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index ab38871b5e00..23fff10af2ac 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -216,7 +216,7 @@ static struct ata_port_operations pacpi_ops = {
 	.mode_filter		= pacpi_mode_filter,
 	.set_piomode		= pacpi_set_piomode,
 	.set_dmamode		= pacpi_set_dmamode,
-	.prereset		= pacpi_pre_reset,
+	.reset.prereset		= pacpi_pre_reset,
 	.port_start		= pacpi_port_start,
 };
 
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index bb790edd6036..9d5cb9c34c52 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -392,11 +392,11 @@ static struct ata_port_operations ali_20_port_ops = {
  *	Port operations for DMA capable ALi with cable detect
  */
 static struct ata_port_operations ali_c2_port_ops = {
-	.inherits	= &ali_dma_base_ops,
-	.check_atapi_dma = ali_check_atapi_dma,
-	.cable_detect	= ali_c2_cable_detect,
-	.dev_config	= ali_lock_sectors,
-	.postreset	= ali_c2_c3_postreset,
+	.inherits		= &ali_dma_base_ops,
+	.check_atapi_dma	= ali_check_atapi_dma,
+	.cable_detect		= ali_c2_cable_detect,
+	.dev_config		= ali_lock_sectors,
+	.reset.postreset	= ali_c2_c3_postreset,
 };
 
 /*
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 5b02b89748b7..a2fecadc927d 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -394,7 +394,7 @@ static const struct scsi_host_template amd_sht = {
 
 static const struct ata_port_operations amd_base_port_ops = {
 	.inherits	= &ata_bmdma32_port_ops,
-	.prereset	= amd_pre_reset,
+	.reset.prereset	= amd_pre_reset,
 };
 
 static struct ata_port_operations amd33_port_ops = {
@@ -429,7 +429,7 @@ static const struct ata_port_operations nv_base_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 	.cable_detect	= ata_cable_ignore,
 	.mode_filter	= nv_mode_filter,
-	.prereset	= nv_pre_reset,
+	.reset.prereset	= nv_pre_reset,
 	.host_stop	= nv_host_stop,
 };
 
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 40544282f455..6160414172a3 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -301,7 +301,7 @@ static struct ata_port_operations artop6210_ops = {
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= artop6210_set_piomode,
 	.set_dmamode		= artop6210_set_dmamode,
-	.prereset		= artop62x0_pre_reset,
+	.reset.prereset		= artop62x0_pre_reset,
 	.qc_defer		= artop6210_qc_defer,
 };
 
@@ -310,7 +310,7 @@ static struct ata_port_operations artop6260_ops = {
 	.cable_detect		= artop6260_cable_detect,
 	.set_piomode		= artop6260_set_piomode,
 	.set_dmamode		= artop6260_set_dmamode,
-	.prereset		= artop62x0_pre_reset,
+	.reset.prereset		= artop62x0_pre_reset,
 };
 
 static void atp8xx_fixup(struct pci_dev *pdev)
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 8c5cc803aab3..4c612f9543f6 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -264,7 +264,7 @@ static struct ata_port_operations atiixp_port_ops = {
 	.bmdma_start 	= atiixp_bmdma_start,
 	.bmdma_stop	= atiixp_bmdma_stop,
 
-	.prereset	= atiixp_prereset,
+	.reset.prereset	= atiixp_prereset,
 	.cable_detect	= atiixp_cable_detect,
 	.set_piomode	= atiixp_set_piomode,
 	.set_dmamode	= atiixp_set_dmamode,
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 2e6eccf2902f..6fe49b303fee 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -243,7 +243,7 @@ static struct ata_port_operations efar_ops = {
 	.cable_detect		= efar_cable_detect,
 	.set_piomode		= efar_set_piomode,
 	.set_dmamode		= efar_set_dmamode,
-	.prereset		= efar_pre_reset,
+	.reset.prereset		= efar_pre_reset,
 };
 
 
diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index e8cda988feb5..b2b9e0058333 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -879,8 +879,8 @@ static const struct scsi_host_template ep93xx_pata_sht = {
 static struct ata_port_operations ep93xx_pata_port_ops = {
 	.inherits		= &ata_bmdma_port_ops,
 
-	.softreset		= ep93xx_pata_softreset,
-	.hardreset		= ATA_OP_NULL,
+	.reset.softreset	= ep93xx_pata_softreset,
+	.reset.hardreset	= ATA_OP_NULL,
 
 	.sff_dev_select		= ep93xx_pata_dev_select,
 	.sff_set_devctl		= ep93xx_pata_set_devctl,
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 5280e9960025..b96e8bd2a3f8 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -322,7 +322,7 @@ static const struct scsi_host_template hpt36x_sht = {
 
 static struct ata_port_operations hpt366_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
-	.prereset	= hpt366_prereset,
+	.reset.prereset	= hpt366_prereset,
 	.cable_detect	= hpt36x_cable_detect,
 	.mode_filter	= hpt366_filter,
 	.set_piomode	= hpt366_set_piomode,
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 4af22b819416..07e3a984cbb1 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -543,7 +543,7 @@ static struct ata_port_operations hpt370_port_ops = {
 	.cable_detect	= hpt37x_cable_detect,
 	.set_piomode	= hpt37x_set_piomode,
 	.set_dmamode	= hpt37x_set_dmamode,
-	.prereset	= hpt37x_pre_reset,
+	.reset.prereset	= hpt37x_pre_reset,
 };
 
 /*
@@ -567,7 +567,7 @@ static struct ata_port_operations hpt302_port_ops = {
 	.cable_detect	= hpt37x_cable_detect,
 	.set_piomode	= hpt37x_set_piomode,
 	.set_dmamode	= hpt37x_set_dmamode,
-	.prereset	= hpt37x_pre_reset,
+	.reset.prereset	= hpt37x_pre_reset,
 };
 
 /*
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 5b1ecccf3c83..2cc57fcf2c46 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -356,7 +356,7 @@ static struct ata_port_operations hpt3xxn_port_ops = {
 	.cable_detect	= hpt3x2n_cable_detect,
 	.set_piomode	= hpt3x2n_set_piomode,
 	.set_dmamode	= hpt3x2n_set_dmamode,
-	.prereset	= hpt3x2n_pre_reset,
+	.reset.prereset	= hpt3x2n_pre_reset,
 };
 
 /*
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 61d8760f09d9..70f056e47e6b 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -336,7 +336,7 @@ static struct ata_port_operations pata_icside_port_ops = {
 
 	.cable_detect		= ata_cable_40wire,
 	.set_dmamode		= pata_icside_set_dmamode,
-	.postreset		= pata_icside_postreset,
+	.reset.postreset	= pata_icside_postreset,
 
 	.port_start		= ATA_OP_NULL,	/* don't need PRD table */
 };
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 9cbe2132ce59..a6f2cfc1602e 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -238,7 +238,7 @@ static struct ata_port_operations it8213_ops = {
 	.cable_detect		= it8213_cable_detect,
 	.set_piomode		= it8213_set_piomode,
 	.set_dmamode		= it8213_set_dmamode,
-	.prereset		= it8213_pre_reset,
+	.reset.prereset		= it8213_pre_reset,
 };
 
 
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index f51fb8219762..b885f33e8980 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -113,7 +113,7 @@ static const struct scsi_host_template jmicron_sht = {
 
 static struct ata_port_operations jmicron_ops = {
 	.inherits		= &ata_bmdma_port_ops,
-	.prereset		= jmicron_pre_reset,
+	.reset.prereset		= jmicron_pre_reset,
 };
 
 
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 8119caaad605..deab67328388 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -99,7 +99,7 @@ static const struct scsi_host_template marvell_sht = {
 static struct ata_port_operations marvell_ops = {
 	.inherits		= &ata_bmdma_port_ops,
 	.cable_detect		= marvell_cable_detect,
-	.prereset		= marvell_pre_reset,
+	.reset.prereset		= marvell_pre_reset,
 };
 
 
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index 69e4baf27d72..ce310ae7c93a 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -145,7 +145,7 @@ static struct ata_port_operations mpiix_port_ops = {
 	.qc_issue	= mpiix_qc_issue,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= mpiix_set_piomode,
-	.prereset	= mpiix_pre_reset,
+	.reset.prereset	= mpiix_pre_reset,
 	.sff_data_xfer	= ata_sff_data_xfer32,
 };
 
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index 44cc24d21d5f..bdb55c1a3280 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -123,7 +123,7 @@ static struct ata_port_operations ns87410_port_ops = {
 	.qc_issue	= ns87410_qc_issue,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= ns87410_set_piomode,
-	.prereset	= ns87410_pre_reset,
+	.reset.prereset	= ns87410_pre_reset,
 };
 
 static int ns87410_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 2d32125c16fd..df42ebe98db7 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -941,7 +941,7 @@ static int octeon_cf_probe(struct platform_device *pdev)
 		/* 16 bit but not True IDE */
 		base = cs0 + 0x800;
 		octeon_cf_ops.sff_data_xfer	= octeon_cf_data_xfer16;
-		octeon_cf_ops.softreset		= octeon_cf_softreset16;
+		octeon_cf_ops.reset.softreset	= octeon_cf_softreset16;
 		octeon_cf_ops.sff_check_status	= octeon_cf_check_status16;
 		octeon_cf_ops.sff_tf_read	= octeon_cf_tf_read16;
 		octeon_cf_ops.sff_tf_load	= octeon_cf_tf_load16;
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 3d01b7000e41..81a7f3eb5654 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -214,7 +214,7 @@ static struct ata_port_operations oldpiix_pata_ops = {
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= oldpiix_set_piomode,
 	.set_dmamode		= oldpiix_set_dmamode,
-	.prereset		= oldpiix_pre_reset,
+	.reset.prereset		= oldpiix_pre_reset,
 };
 
 
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index 3d23f57eb128..3db1b95d1404 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -156,7 +156,7 @@ static struct ata_port_operations opti_port_ops = {
 	.inherits	= &ata_sff_port_ops,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= opti_set_piomode,
-	.prereset	= opti_pre_reset,
+	.reset.prereset	= opti_pre_reset,
 };
 
 static int opti_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index cc876dc7a9d8..b42dba5f4e05 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -346,7 +346,7 @@ static struct ata_port_operations optidma_port_ops = {
 	.set_piomode	= optidma_set_pio_mode,
 	.set_dmamode	= optidma_set_dma_mode,
 	.set_mode	= optidma_set_mode,
-	.prereset	= optidma_pre_reset,
+	.reset.prereset	= optidma_pre_reset,
 };
 
 static struct ata_port_operations optiplus_port_ops = {
diff --git a/drivers/ata/pata_parport/pata_parport.c b/drivers/ata/pata_parport/pata_parport.c
index 93ebf566b54e..22bd3ff6b7ae 100644
--- a/drivers/ata/pata_parport/pata_parport.c
+++ b/drivers/ata/pata_parport/pata_parport.c
@@ -321,8 +321,8 @@ static void pata_parport_drain_fifo(struct ata_queued_cmd *qc)
 static struct ata_port_operations pata_parport_port_ops = {
 	.inherits		= &ata_sff_port_ops,
 
-	.softreset		= pata_parport_softreset,
-	.hardreset		= NULL,
+	.reset.softreset	= pata_parport_softreset,
+	.reset.hardreset	= NULL,
 
 	.sff_dev_select		= pata_parport_dev_select,
 	.sff_set_devctl		= pata_parport_set_devctl,
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index a4ee3b92c9aa..d792ce6d97bf 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -130,7 +130,7 @@ static struct ata_port_operations pdc2027x_pata100_ops = {
 	.inherits		= &ata_bmdma_port_ops,
 	.check_atapi_dma	= pdc2027x_check_atapi_dma,
 	.cable_detect		= pdc2027x_cable_detect,
-	.prereset		= pdc2027x_prereset,
+	.reset.prereset		= pdc2027x_prereset,
 };
 
 static struct ata_port_operations pdc2027x_pata133_ops = {
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index 19cbb5c94b42..6ff4c11e937d 100644
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -276,7 +276,7 @@ static struct ata_port_operations rdc_pata_ops = {
 	.cable_detect		= rdc_pata_cable_detect,
 	.set_piomode		= rdc_set_piomode,
 	.set_dmamode		= rdc_set_dmamode,
-	.prereset		= rdc_pata_prereset,
+	.reset.prereset		= rdc_pata_prereset,
 };
 
 static const struct ata_port_info rdc_port_info = {
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 31de06b66221..2b751e393771 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -552,7 +552,7 @@ static struct ata_port_operations sis_133_for_sata_ops = {
 
 static struct ata_port_operations sis_base_ops = {
 	.inherits		= &ata_bmdma_port_ops,
-	.prereset		= sis_pre_reset,
+	.reset.prereset		= sis_pre_reset,
 };
 
 static struct ata_port_operations sis_133_ops = {
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 93882e976ede..2d24c6b3e9d9 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -248,7 +248,7 @@ static struct ata_port_operations sl82c105_port_ops = {
 	.bmdma_stop	= sl82c105_bmdma_stop,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= sl82c105_set_piomode,
-	.prereset	= sl82c105_pre_reset,
+	.reset.prereset	= sl82c105_pre_reset,
 	.sff_irq_check	= sl82c105_sff_irq_check,
 };
 
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index 26d448a869e2..596e86a031b3 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -170,7 +170,7 @@ static struct ata_port_operations triflex_port_ops = {
 	.bmdma_stop	= triflex_bmdma_stop,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= triflex_set_piomode,
-	.prereset	= triflex_prereset,
+	.reset.prereset	= triflex_prereset,
 };
 
 static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index bb80e7800dcb..a8c9cf685b4b 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -451,7 +451,7 @@ static struct ata_port_operations via_port_ops = {
 	.cable_detect	= via_cable_detect,
 	.set_piomode	= via_set_piomode,
 	.set_dmamode	= via_set_dmamode,
-	.prereset	= via_pre_reset,
+	.reset.prereset	= via_pre_reset,
 	.sff_tf_load	= via_tf_load,
 	.port_start	= via_port_start,
 	.mode_filter	= via_mode_filter,
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 8e6b2599f0d5..17a5a59861c3 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -140,7 +140,7 @@ static struct ata_port_operations adma_ata_ops = {
 
 	.freeze			= adma_freeze,
 	.thaw			= adma_thaw,
-	.prereset		= adma_prereset,
+	.reset.prereset		= adma_prereset,
 
 	.port_start		= adma_port_start,
 	.port_stop		= adma_port_stop,
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 6e1dd0d9c035..7a4f59202156 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1097,7 +1097,7 @@ static struct ata_port_operations sata_dwc_ops = {
 	.inherits		= &ata_sff_port_ops,
 
 	.error_handler		= sata_dwc_error_handler,
-	.hardreset		= sata_dwc_hardreset,
+	.reset.hardreset	= sata_dwc_hardreset,
 
 	.qc_issue		= sata_dwc_qc_issue,
 
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 87e91a937a44..84da8d6ef28e 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1395,9 +1395,9 @@ static struct ata_port_operations sata_fsl_ops = {
 
 	.freeze = sata_fsl_freeze,
 	.thaw = sata_fsl_thaw,
-	.softreset = sata_fsl_softreset,
-	.hardreset = sata_fsl_hardreset,
-	.pmp_softreset = sata_fsl_softreset,
+	.reset.softreset = sata_fsl_softreset,
+	.reset.hardreset = sata_fsl_hardreset,
+	.pmp_reset.softreset = sata_fsl_softreset,
 	.error_handler = sata_fsl_error_handler,
 	.post_internal_cmd = sata_fsl_post_internal_cmd,
 
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index c8c817c51230..3421039f4bae 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -428,7 +428,7 @@ static int ahci_highbank_hardreset(struct ata_link *link, unsigned int *class,
 
 static struct ata_port_operations ahci_highbank_ops = {
 	.inherits		= &ahci_ops,
-	.hardreset		= ahci_highbank_hardreset,
+	.reset.hardreset	= ahci_highbank_hardreset,
 	.transmit_led_message   = ecx_transmit_led_message,
 };
 
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index db9c255dc9f2..46a8c20daf18 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -730,7 +730,7 @@ static struct ata_port_operations inic_port_ops = {
 
 	.freeze			= inic_freeze,
 	.thaw			= inic_thaw,
-	.hardreset		= inic_hardreset,
+	.reset.hardreset	= inic_hardreset,
 	.error_handler		= inic_error_handler,
 	.post_internal_cmd	= inic_post_internal_cmd,
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index bcbf96867f89..ffb396f61731 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -687,7 +687,7 @@ static struct ata_port_operations mv5_ops = {
 
 	.freeze			= mv_eh_freeze,
 	.thaw			= mv_eh_thaw,
-	.hardreset		= mv_hardreset,
+	.reset.hardreset	= mv_hardreset,
 
 	.scr_read		= mv5_scr_read,
 	.scr_write		= mv5_scr_write,
@@ -709,10 +709,10 @@ static struct ata_port_operations mv6_ops = {
 
 	.freeze			= mv_eh_freeze,
 	.thaw			= mv_eh_thaw,
-	.hardreset		= mv_hardreset,
-	.softreset		= mv_softreset,
-	.pmp_hardreset		= mv_pmp_hardreset,
-	.pmp_softreset		= mv_softreset,
+	.reset.hardreset	= mv_hardreset,
+	.reset.softreset	= mv_softreset,
+	.pmp_reset.hardreset	= mv_pmp_hardreset,
+	.pmp_reset.softreset	= mv_softreset,
 	.error_handler		= mv_pmp_error_handler,
 
 	.scr_read		= mv_scr_read,
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index f36e2915ccf1..841e7de2bba6 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -462,7 +462,7 @@ static struct ata_port_operations nv_generic_ops = {
 	.lost_interrupt		= ATA_OP_NULL,
 	.scr_read		= nv_scr_read,
 	.scr_write		= nv_scr_write,
-	.hardreset		= nv_hardreset,
+	.reset.hardreset	= nv_hardreset,
 };
 
 static struct ata_port_operations nv_nf2_ops = {
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 2df1a070b25a..2a005aede123 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -188,7 +188,7 @@ static struct ata_port_operations pdc_sata_ops = {
 	.scr_read		= pdc_sata_scr_read,
 	.scr_write		= pdc_sata_scr_write,
 	.port_start		= pdc_sata_port_start,
-	.hardreset		= pdc_sata_hardreset,
+	.reset.hardreset	= pdc_sata_hardreset,
 };
 
 /* First-generation chips need a more restrictive ->check_atapi_dma op,
@@ -206,7 +206,7 @@ static struct ata_port_operations pdc_pata_ops = {
 	.freeze			= pdc_freeze,
 	.thaw			= pdc_thaw,
 	.port_start		= pdc_common_port_start,
-	.softreset		= pdc_pata_softreset,
+	.reset.softreset	= pdc_pata_softreset,
 };
 
 static const struct ata_port_info pdc_port_info[] = {
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 8a6286159044..cfb9b5b61cd7 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -123,8 +123,8 @@ static struct ata_port_operations qs_ata_ops = {
 
 	.freeze			= qs_freeze,
 	.thaw			= qs_thaw,
-	.prereset		= qs_prereset,
-	.softreset		= ATA_OP_NULL,
+	.reset.prereset		= qs_prereset,
+	.reset.softreset	= ATA_OP_NULL,
 	.error_handler		= qs_error_handler,
 	.lost_interrupt		= ATA_OP_NULL,
 
diff --git a/drivers/ata/sata_rcar.c b/drivers/ata/sata_rcar.c
index 22820a02d740..487eadd4073f 100644
--- a/drivers/ata/sata_rcar.c
+++ b/drivers/ata/sata_rcar.c
@@ -624,7 +624,7 @@ static struct ata_port_operations sata_rcar_port_ops = {
 
 	.freeze			= sata_rcar_freeze,
 	.thaw			= sata_rcar_thaw,
-	.softreset		= sata_rcar_softreset,
+	.reset.softreset	= sata_rcar_softreset,
 
 	.scr_read		= sata_rcar_scr_read,
 	.scr_write		= sata_rcar_scr_write,
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 87f4cde6a686..d642ece9f07a 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -393,10 +393,10 @@ static struct ata_port_operations sil24_ops = {
 
 	.freeze			= sil24_freeze,
 	.thaw			= sil24_thaw,
-	.softreset		= sil24_softreset,
-	.hardreset		= sil24_hardreset,
-	.pmp_softreset		= sil24_softreset,
-	.pmp_hardreset		= sil24_pmp_hardreset,
+	.reset.softreset	= sil24_softreset,
+	.reset.hardreset	= sil24_hardreset,
+	.pmp_reset.softreset	= sil24_softreset,
+	.pmp_reset.hardreset	= sil24_pmp_hardreset,
 	.error_handler		= sil24_error_handler,
 	.post_internal_cmd	= sil24_post_internal_cmd,
 	.dev_config		= sil24_dev_config,
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 598a872f6a08..c5d6aa36c9c3 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -340,8 +340,8 @@ static const struct scsi_host_template k2_sata_sht = {
 
 static struct ata_port_operations k2_sata_ops = {
 	.inherits		= &ata_bmdma_port_ops,
-	.softreset              = k2_sata_softreset,
-	.hardreset              = k2_sata_hardreset,
+	.reset.softreset	= k2_sata_softreset,
+	.reset.hardreset	= k2_sata_hardreset,
 	.sff_tf_load		= k2_sata_tf_load,
 	.sff_tf_read		= k2_sata_tf_read,
 	.sff_check_status	= k2_stat_check_status,
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index f7f5131af937..0986ebd1eb4e 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -241,7 +241,7 @@ static struct ata_port_operations pdc_20621_ops = {
 
 	.freeze			= pdc_freeze,
 	.thaw			= pdc_thaw,
-	.softreset		= pdc_softreset,
+	.reset.softreset	= pdc_softreset,
 	.error_handler		= pdc_error_handler,
 	.lost_interrupt		= ATA_OP_NULL,
 	.post_internal_cmd	= pdc_post_internal_cmd,
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 52894ff49dcb..44985796cc47 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -67,7 +67,7 @@ static struct ata_port_operations uli_ops = {
 	.inherits		= &ata_bmdma_port_ops,
 	.scr_read		= uli_scr_read,
 	.scr_write		= uli_scr_write,
-	.hardreset		= ATA_OP_NULL,
+	.reset.hardreset	= ATA_OP_NULL,
 };
 
 static const struct ata_port_info uli_port_info = {
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 4ecd8f33b082..68e9003ec2d4 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -120,7 +120,7 @@ static struct ata_port_operations svia_base_ops = {
 static struct ata_port_operations vt6420_sata_ops = {
 	.inherits		= &svia_base_ops,
 	.freeze			= svia_noop_freeze,
-	.prereset		= vt6420_prereset,
+	.reset.prereset		= vt6420_prereset,
 	.bmdma_start		= vt6420_bmdma_start,
 };
 
@@ -140,7 +140,7 @@ static struct ata_port_operations vt6421_sata_ops = {
 
 static struct ata_port_operations vt8251_ops = {
 	.inherits		= &svia_base_ops,
-	.hardreset		= sata_std_hardreset,
+	.reset.hardreset	= sata_std_hardreset,
 	.scr_read		= vt8251_scr_read,
 	.scr_write		= vt8251_scr_write,
 };
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 7b4e7a61965a..adb9e7a94785 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -559,8 +559,8 @@ static int sas_ata_prereset(struct ata_link *link, unsigned long deadline)
 }
 
 static struct ata_port_operations sas_sata_ops = {
-	.prereset		= sas_ata_prereset,
-	.hardreset		= sas_ata_hard_reset,
+	.reset.prereset		= sas_ata_prereset,
+	.reset.hardreset	= sas_ata_hard_reset,
 	.error_handler		= ata_std_error_handler,
 	.post_internal_cmd	= sas_ata_post_internal,
 	.qc_defer               = ata_std_qc_defer,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index cf0b3fff3198..912ace523880 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -944,6 +944,13 @@ struct ata_port {
  */
 #define ATA_OP_NULL		(void *)(unsigned long)(-ENOENT)
 
+struct ata_reset_operations {
+	ata_prereset_fn_t	prereset;
+	ata_reset_fn_t		softreset;
+	ata_reset_fn_t		hardreset;
+	ata_postreset_fn_t	postreset;
+};
+
 struct ata_port_operations {
 	/*
 	 * Command execution
@@ -970,14 +977,8 @@ struct ata_port_operations {
 
 	void (*freeze)(struct ata_port *ap);
 	void (*thaw)(struct ata_port *ap);
-	ata_prereset_fn_t	prereset;
-	ata_reset_fn_t		softreset;
-	ata_reset_fn_t		hardreset;
-	ata_postreset_fn_t	postreset;
-	ata_prereset_fn_t	pmp_prereset;
-	ata_reset_fn_t		pmp_softreset;
-	ata_reset_fn_t		pmp_hardreset;
-	ata_postreset_fn_t	pmp_postreset;
+	struct ata_reset_operations reset;
+	struct ata_reset_operations pmp_reset;
 	void (*error_handler)(struct ata_port *ap);
 	void (*lost_interrupt)(struct ata_port *ap);
 	void (*post_internal_cmd)(struct ata_queued_cmd *qc);
-- 
2.50.1

