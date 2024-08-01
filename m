Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4CE170A04;
	Thu,  1 Aug 2024 09:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722502914; cv=none; b=Zwm/2bxa0niNtZHOlXT0rfNh6pgLI/RjbkxkrQaR/lV552/8EIBuQRnxxnK/ABkUxjVTYopkyAkhexVgzZEOoEhhiUz/iPOEnQGNVdJDUjGzEwwloz8I62O+rGhWrtMYexKBvgIKkroV7cJPR85faFZ4mqN3oM2+TOVkK1D7xgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722502914; c=relaxed/simple;
	bh=uuwDgalZB04Vpsr8ToCnDBoEnt6veXa3nmiU7WiVxHs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=svQoMIEpb63EyUqfyET5iJpRJPxHvDYS6w56K42ZlqrWiqa8f5ul8OyYK0+Ezc1kbfm/PpztHWiNRCXjGFJx+MPmkqeVcOJO9xjpK0mMMIgmTkcrXk0oUWkmx4fpnCIksrsnMNQkOncZd172EpsRv7J5vjtfIaubH7UXkZeDeBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CPFSwpQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CPFSwpQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69BAC32786;
	Thu,  1 Aug 2024 09:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722502913;
	bh=uuwDgalZB04Vpsr8ToCnDBoEnt6veXa3nmiU7WiVxHs=;
	h=From:To:Subject:Date:From;
	b=CPFSwpQdu48z5QB+qNEDsKQazmzO2kZLUcL1t5nPot5oA2GiKnl+T/48XWtv9SQk/
	 VQ2b7lNbNKP+tjK7aq2lvxPNVn0PRwKkt1uymW63L4GxJFgehQlByn+/EI5MkSP4t6
	 0l/N1/3Wcy2TYu+QP+AlXjoTnRSwSYhbVGvzj4p+mSVhBIhNlzrZUDvPcDBSX1ePOy
	 gRLYwfiGG3Zi3KvvRfwOGKFkvjSglq5dtycZuxi3uZ6Ne9ulLwMJkVPhj7H9hTJ/ax
	 YuwzwwCgsKOF1qP+Aij81HNZ8dg6jR7yr4AKi118PID7xamWujqwiq5AgBQcR3WT/N
	 X+dcQF9xf706Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH] ata: libata: Remove ata_noop_qc_prep()
Date: Thu,  1 Aug 2024 18:01:51 +0900
Message-ID: <20240801090151.1249985-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function ata_noop_qc_prep(), as its name implies, does nothing and
simply returns AC_ERR_OK. For drivers that do not need any special
preparations of queued commands, we can avoid having to define struct
ata_port qc_prep operation by simply testing if that operation is
defined or not in ata_qc_issue(). Make this change and remove
ata_noop_qc_prep().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-core.c     | 18 +++++++-----------
 drivers/ata/libata-sff.c      |  1 -
 drivers/ata/pata_ep93xx.c     |  2 --
 drivers/ata/pata_icside.c     |  2 --
 drivers/ata/pata_mpc52xx.c    |  1 -
 drivers/ata/pata_octeon_cf.c  |  1 -
 drivers/scsi/libsas/sas_ata.c |  1 -
 include/linux/libata.h        |  1 -
 8 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fc9fcfda42b8..b4fdb78579c8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4696,12 +4696,6 @@ int ata_std_qc_defer(struct ata_queued_cmd *qc)
 }
 EXPORT_SYMBOL_GPL(ata_std_qc_defer);
 
-enum ata_completion_errors ata_noop_qc_prep(struct ata_queued_cmd *qc)
-{
-	return AC_ERR_OK;
-}
-EXPORT_SYMBOL_GPL(ata_noop_qc_prep);
-
 /**
  *	ata_sg_init - Associate command with scatter-gather table.
  *	@qc: Command to be associated
@@ -5088,10 +5082,13 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 		return;
 	}
 
-	trace_ata_qc_prep(qc);
-	qc->err_mask |= ap->ops->qc_prep(qc);
-	if (unlikely(qc->err_mask))
-		goto err;
+	if (ap->ops->qc_prep) {
+		trace_ata_qc_prep(qc);
+		qc->err_mask |= ap->ops->qc_prep(qc);
+		if (unlikely(qc->err_mask))
+			goto err;
+	}
+
 	trace_ata_qc_issue(qc);
 	qc->err_mask |= ap->ops->qc_issue(qc);
 	if (unlikely(qc->err_mask))
@@ -6724,7 +6721,6 @@ static void ata_dummy_error_handler(struct ata_port *ap)
 }
 
 struct ata_port_operations ata_dummy_port_ops = {
-	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= ata_dummy_qc_issue,
 	.error_handler		= ata_dummy_error_handler,
 	.sched_eh		= ata_std_sched_eh,
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 06868ec5b1fd..67f277e1c3bf 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -26,7 +26,6 @@ static struct workqueue_struct *ata_sff_wq;
 const struct ata_port_operations ata_sff_port_ops = {
 	.inherits		= &ata_base_port_ops,
 
-	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= ata_sff_qc_issue,
 	.qc_fill_rtf		= ata_sff_qc_fill_rtf,
 
diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index c84a20892f1b..a34e56a9d535 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -884,8 +884,6 @@ static const struct scsi_host_template ep93xx_pata_sht = {
 static struct ata_port_operations ep93xx_pata_port_ops = {
 	.inherits		= &ata_bmdma_port_ops,
 
-	.qc_prep		= ata_noop_qc_prep,
-
 	.softreset		= ep93xx_pata_softreset,
 	.hardreset		= ATA_OP_NULL,
 
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 9cfb064782c3..61d8760f09d9 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -328,8 +328,6 @@ static void pata_icside_postreset(struct ata_link *link, unsigned int *classes)
 
 static struct ata_port_operations pata_icside_port_ops = {
 	.inherits		= &ata_bmdma_port_ops,
-	/* no need to build any PRD tables for DMA */
-	.qc_prep		= ata_noop_qc_prep,
 	.sff_data_xfer		= ata_sff_data_xfer32,
 	.bmdma_setup		= pata_icside_bmdma_setup,
 	.bmdma_start		= pata_icside_bmdma_start,
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 6c317a461a1f..3f9258677915 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -620,7 +620,6 @@ static struct ata_port_operations mpc52xx_ata_port_ops = {
 	.bmdma_start		= mpc52xx_bmdma_start,
 	.bmdma_stop		= mpc52xx_bmdma_stop,
 	.bmdma_status		= mpc52xx_bmdma_status,
-	.qc_prep		= ata_noop_qc_prep,
 };
 
 static int mpc52xx_ata_init_one(struct device *dev,
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 2884acfc4863..0bb9607e7348 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -789,7 +789,6 @@ static unsigned int octeon_cf_qc_issue(struct ata_queued_cmd *qc)
 static struct ata_port_operations octeon_cf_ops = {
 	.inherits		= &ata_sff_port_ops,
 	.check_atapi_dma	= octeon_cf_check_atapi_dma,
-	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= octeon_cf_qc_issue,
 	.sff_dev_select		= octeon_cf_dev_select,
 	.sff_irq_on		= octeon_cf_ata_port_noaction,
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 88714b7b0dba..7b4e7a61965a 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -564,7 +564,6 @@ static struct ata_port_operations sas_sata_ops = {
 	.error_handler		= ata_std_error_handler,
 	.post_internal_cmd	= sas_ata_post_internal,
 	.qc_defer               = ata_std_qc_defer,
-	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= sas_ata_qc_issue,
 	.qc_fill_rtf		= sas_ata_qc_fill_rtf,
 	.set_dmamode		= sas_ata_set_dmamode,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d598ef690e50..d5446e18d9df 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1168,7 +1168,6 @@ extern int ata_xfer_mode2shift(u8 xfer_mode);
 extern const char *ata_mode_string(unsigned int xfer_mask);
 extern unsigned int ata_id_xfermask(const u16 *id);
 extern int ata_std_qc_defer(struct ata_queued_cmd *qc);
-extern enum ata_completion_errors ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
 		 unsigned int n_elem);
 extern unsigned int ata_dev_classify(const struct ata_taskfile *tf);
-- 
2.45.2

