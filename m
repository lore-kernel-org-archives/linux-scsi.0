Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE810C46467
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 17:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbiL2RAV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 12:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbiL2RAQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 12:00:16 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22896101D6;
        Thu, 29 Dec 2022 09:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672333215; x=1703869215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D/lRENqbiIXYinNFSFDpkw7ukUGgZpe7PO2Ug2lf2+Y=;
  b=fJGYlUS34HXTu0OV3lwyOVFYALS8CSJbqxxSFQrgr+zjHggAmTc6iv/e
   f7xhl3gro1EdeOgKm6hKIKLoBrMzAFBUQO9+SaMSaUG0/LlmS/vcpcmfF
   s0+AvRw6CybeWzMnRN49Z4irvbUH0LO15BGJ8494uehqiZij1qWN/6s9G
   OkU+rSOKaBRVLVZQSbTceRaptl7MwBSJ5hMGtjKW8yE5gsBm4ZlNWkrIS
   +GEIoSbyJiG4FkL+x/xnCfjPFRdJ/9OtS2WDPjbJ7xTfuU2LZVOo+rSOa
   cqaBtIPYAfl5ASQSwvv9ZLKK3sAq8j4d58AY4+Ya/wdO7PaYCqyzbFFGV
   g==;
X-IronPort-AV: E=Sophos;i="5.96,284,1665417600"; 
   d="scan'208";a="323990970"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Dec 2022 01:00:14 +0800
IronPort-SDR: 0tYZJ5z1+I89gDbk2FC3ZRO2ANHqnLr0R9tiyyvx6CN1Q5hHLm7S0NmIGjW+SpVXoI3ZOv5HGa
 2odASXOrRj5BsZXsQQsSCJ6lumI7uDM97zcl75AIpPObleAdZM46CccnX2FHducBshU11AXYgr
 y+m6QRjRJqRpgZXO74koQ8//fd5XXhku5sTEiuZGY6onOUHG9TkXEjuWKQ9knNbJmm+2f/wDDF
 367lMw7Rqnms+afRQOMGnIjsHLOhgBTZAH9483WK8zzcsvNv05MOs09zxiWyLWyJipWTNSb+uo
 Ruk=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Dec 2022 08:18:18 -0800
IronPort-SDR: RDHxQnMcxfI+YK8zcqsPauQoTLLtulHqsKibYaLOE7XdO712vtmF6EhdhlRq7fkBxvkUWGfCZc
 wLB5A23mrr9GBqOvruon+IVXq/BnLrdsIevuU+yDwbhjOP/SuwUjTVnZXgGz5F0LTL/O8UsACn
 OVk7IRkorKtLaw/cMY9MAIhf73sE3hR72Nq2f72ULA5oAtKMOW6hHLgQpL6I7duRQT0rIJaqw4
 lG1rpEGwQftDvNnL2AQWXd/99k/o4bB7wvWRQgB4WXGJ4RvowoOQSvHQqXEhRb3ZcKHFWe5gXC
 ajo=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.9])
  by uls-op-cesaip02.wdc.com with ESMTP; 29 Dec 2022 09:00:13 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v2 1/7] ata: scsi: rename flag ATA_QCFLAG_FAILED to ATA_QCFLAG_EH
Date:   Thu, 29 Dec 2022 17:59:57 +0100
Message-Id: <20221229170005.49118-2-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221229170005.49118-1-niklas.cassel@wdc.com>
References: <20221229170005.49118-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The name ATA_QCFLAG_FAILED is misleading since it does not mean that a
QC completed in error, or that it didn't complete at all. It means that
libata decided to schedule EH for the QC, so the QC is now owned by the
libata error handler (EH).

The normal execution path is responsible for not accessing a QC owned
by EH. libata core enforces the rule by returning NULL from
ata_qc_from_tag() for QCs owned by EH.

It is quite easy to mistake that a QC marked with ATA_QCFLAG_FAILED was
an error. However, a QC that was actually an error is instead indicated
by having qc->err_mask set. E.g. when we have a NCQ error, we abort all
QCs, which currently will mark all QCs as ATA_QCFLAG_FAILED. However, it
will only be a single QC that is an error (i.e. has qc->err_mask set).

Rename ATA_QCFLAG_FAILED to ATA_QCFLAG_EH to more clearly highlight that
this flag simply means that a QC is now owned by EH. This new name will
not mislead to think that the QC was an error (which is instead
indicated by having qc->err_mask set).

This also makes it more obvious that the EH code skips all QCs that do
not have ATA_QCFLAG_EH set (rather than ATA_QCFLAG_FAILED), since the EH
code should simply only care about QCs that are owned by EH itself.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/ata/acard-ahci.c      |  2 +-
 drivers/ata/libahci.c         |  4 ++--
 drivers/ata/libata-core.c     | 12 ++++++------
 drivers/ata/libata-eh.c       | 22 +++++++++++-----------
 drivers/ata/libata-sata.c     |  4 ++--
 drivers/ata/libata-sff.c      |  4 ++--
 drivers/ata/libata-trace.c    |  2 +-
 drivers/ata/sata_fsl.c        |  2 +-
 drivers/ata/sata_inic162x.c   |  2 +-
 drivers/ata/sata_promise.c    |  2 +-
 drivers/ata/sata_sil24.c      |  2 +-
 drivers/ata/sata_sx4.c        |  2 +-
 drivers/scsi/ipr.c            |  4 ++--
 drivers/scsi/libsas/sas_ata.c |  8 ++++----
 include/linux/libata.h        |  4 ++--
 15 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index 7654a40c12b4..da74a86b70ba 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -263,7 +263,7 @@ static bool acard_ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 	 * Setup FIS.
 	 */
 	if (qc->tf.protocol == ATA_PROT_PIO && qc->dma_dir == DMA_FROM_DEVICE &&
-	    !(qc->flags & ATA_QCFLAG_FAILED)) {
+	    !(qc->flags & ATA_QCFLAG_EH)) {
 		ata_tf_from_fis(rx_fis + RX_FIS_PIO_SETUP, &qc->result_tf);
 		qc->result_tf.status = (rx_fis + RX_FIS_PIO_SETUP)[15];
 	} else
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 29acc35bf4a6..03aa9eb415d3 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2068,7 +2068,7 @@ static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 	 * Setup FIS.
 	 */
 	if (qc->tf.protocol == ATA_PROT_PIO && qc->dma_dir == DMA_FROM_DEVICE &&
-	    !(qc->flags & ATA_QCFLAG_FAILED)) {
+	    !(qc->flags & ATA_QCFLAG_EH)) {
 		ata_tf_from_fis(rx_fis + RX_FIS_PIO_SETUP, &qc->result_tf);
 		qc->result_tf.status = (rx_fis + RX_FIS_PIO_SETUP)[15];
 
@@ -2138,7 +2138,7 @@ static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 
 	/* make DMA engine forget about the failed command */
-	if (qc->flags & ATA_QCFLAG_FAILED)
+	if (qc->flags & ATA_QCFLAG_EH)
 		ahci_kick_engine(ap);
 }
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 884ae73b11ea..6b03bebcde50 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1590,7 +1590,7 @@ static unsigned ata_exec_internal_sg(struct ata_device *dev,
 		ap->ops->post_internal_cmd(qc);
 
 	/* perform minimal error analysis */
-	if (qc->flags & ATA_QCFLAG_FAILED) {
+	if (qc->flags & ATA_QCFLAG_EH) {
 		if (qc->result_tf.status & (ATA_ERR | ATA_DF))
 			qc->err_mask |= AC_ERR_DEV;
 
@@ -4683,10 +4683,10 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 	/* XXX: New EH and old EH use different mechanisms to
 	 * synchronize EH with regular execution path.
 	 *
-	 * In new EH, a failed qc is marked with ATA_QCFLAG_FAILED.
+	 * In new EH, a qc owned by EH is marked with ATA_QCFLAG_EH.
 	 * Normal execution path is responsible for not accessing a
-	 * failed qc.  libata core enforces the rule by returning NULL
-	 * from ata_qc_from_tag() for failed qcs.
+	 * qc owned by EH.  libata core enforces the rule by returning NULL
+	 * from ata_qc_from_tag() for qcs owned by EH.
 	 *
 	 * Old EH depends on ata_qc_complete() nullifying completion
 	 * requests if ATA_QCFLAG_EH_SCHEDULED is set.  Old EH does
@@ -4698,7 +4698,7 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 		struct ata_eh_info *ehi = &dev->link->eh_info;
 
 		if (unlikely(qc->err_mask))
-			qc->flags |= ATA_QCFLAG_FAILED;
+			qc->flags |= ATA_QCFLAG_EH;
 
 		/*
 		 * Finish internal commands without any further processing
@@ -4715,7 +4715,7 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 		 * Non-internal qc has failed.  Fill the result TF and
 		 * summon EH.
 		 */
-		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
+		if (unlikely(qc->flags & ATA_QCFLAG_EH)) {
 			fill_result_tf(qc);
 			trace_ata_qc_complete_failed(qc);
 			ata_qc_schedule_eh(qc);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 34303ce67c14..8cb250930c48 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -575,7 +575,7 @@ void ata_scsi_cmd_error_handler(struct Scsi_Host *host, struct ata_port *ap,
 	 * normal completion, error completion, and SCSI timeout.
 	 * Both completions can race against SCSI timeout.  When normal
 	 * completion wins, the qc never reaches EH.  When error
-	 * completion wins, the qc has ATA_QCFLAG_FAILED set.
+	 * completion wins, the qc has ATA_QCFLAG_EH set.
 	 *
 	 * When SCSI timeout wins, things are a bit more complex.
 	 * Normal or error completion can occur after the timeout but
@@ -611,10 +611,10 @@ void ata_scsi_cmd_error_handler(struct Scsi_Host *host, struct ata_port *ap,
 
 			if (i < ATA_MAX_QUEUE) {
 				/* the scmd has an associated qc */
-				if (!(qc->flags & ATA_QCFLAG_FAILED)) {
+				if (!(qc->flags & ATA_QCFLAG_EH)) {
 					/* which hasn't failed yet, timeout */
 					qc->err_mask |= AC_ERR_TIMEOUT;
-					qc->flags |= ATA_QCFLAG_FAILED;
+					qc->flags |= ATA_QCFLAG_EH;
 					nr_timedout++;
 				}
 			} else {
@@ -631,7 +631,7 @@ void ata_scsi_cmd_error_handler(struct Scsi_Host *host, struct ata_port *ap,
 		 * this point but the state of the controller is
 		 * unknown.  Freeze the port to make sure the IRQ
 		 * handler doesn't diddle with those qcs.  This must
-		 * be done atomically w.r.t. setting QCFLAG_FAILED.
+		 * be done atomically w.r.t. setting ATA_QCFLAG_EH.
 		 */
 		if (nr_timedout)
 			__ata_port_freeze(ap);
@@ -911,12 +911,12 @@ void ata_qc_schedule_eh(struct ata_queued_cmd *qc)
 
 	WARN_ON(!ap->ops->error_handler);
 
-	qc->flags |= ATA_QCFLAG_FAILED;
+	qc->flags |= ATA_QCFLAG_EH;
 	ata_eh_set_pending(ap, 1);
 
 	/* The following will fail if timeout has already expired.
 	 * ata_scsi_error() takes care of such scmds on EH entry.
-	 * Note that ATA_QCFLAG_FAILED is unconditionally set after
+	 * Note that ATA_QCFLAG_EH is unconditionally set after
 	 * this function completes.
 	 */
 	blk_abort_request(scsi_cmd_to_rq(qc->scsicmd));
@@ -994,7 +994,7 @@ static int ata_do_link_abort(struct ata_port *ap, struct ata_link *link)
 	/* include internal tag in iteration */
 	ata_qc_for_each_with_internal(ap, qc, tag) {
 		if (qc && (!link || qc->dev->link == link)) {
-			qc->flags |= ATA_QCFLAG_FAILED;
+			qc->flags |= ATA_QCFLAG_EH;
 			ata_qc_complete(qc);
 			nr_aborted++;
 		}
@@ -1954,7 +1954,7 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 	all_err_mask |= ehc->i.err_mask;
 
 	ata_qc_for_each_raw(ap, qc, tag) {
-		if (!(qc->flags & ATA_QCFLAG_FAILED) ||
+		if (!(qc->flags & ATA_QCFLAG_EH) ||
 		    qc->flags & ATA_QCFLAG_RETRY ||
 		    ata_dev_phys_link(qc->dev) != link)
 			continue;
@@ -2232,7 +2232,7 @@ static void ata_eh_link_report(struct ata_link *link)
 		desc = ehc->i.desc;
 
 	ata_qc_for_each_raw(ap, qc, tag) {
-		if (!(qc->flags & ATA_QCFLAG_FAILED) ||
+		if (!(qc->flags & ATA_QCFLAG_EH) ||
 		    ata_dev_phys_link(qc->dev) != link ||
 		    ((qc->flags & ATA_QCFLAG_QUIET) &&
 		     qc->err_mask == AC_ERR_DEV))
@@ -2298,7 +2298,7 @@ static void ata_eh_link_report(struct ata_link *link)
 		char data_buf[20] = "";
 		char cdb_buf[70] = "";
 
-		if (!(qc->flags & ATA_QCFLAG_FAILED) ||
+		if (!(qc->flags & ATA_QCFLAG_EH) ||
 		    ata_dev_phys_link(qc->dev) != link || !qc->err_mask)
 			continue;
 
@@ -3802,7 +3802,7 @@ void ata_eh_finish(struct ata_port *ap)
 
 	/* retry or finish qcs */
 	ata_qc_for_each_raw(ap, qc, tag) {
-		if (!(qc->flags & ATA_QCFLAG_FAILED))
+		if (!(qc->flags & ATA_QCFLAG_EH))
 			continue;
 
 		if (qc->err_mask) {
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 18ef14e749a0..908f35acee1e 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1429,7 +1429,7 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 
 	/* has LLDD analyzed already? */
 	ata_qc_for_each_raw(ap, qc, tag) {
-		if (!(qc->flags & ATA_QCFLAG_FAILED))
+		if (!(qc->flags & ATA_QCFLAG_EH))
 			continue;
 
 		if (qc->err_mask)
@@ -1477,7 +1477,7 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 	}
 
 	ata_qc_for_each_raw(ap, qc, tag) {
-		if (!(qc->flags & ATA_QCFLAG_FAILED) ||
+		if (!(qc->flags & ATA_QCFLAG_EH) ||
 		    ata_dev_phys_link(qc->dev) != link)
 			continue;
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 153f49e00713..34beda28e712 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2073,7 +2073,7 @@ void ata_sff_error_handler(struct ata_port *ap)
 	unsigned long flags;
 
 	qc = __ata_qc_from_tag(ap, ap->link.active_tag);
-	if (qc && !(qc->flags & ATA_QCFLAG_FAILED))
+	if (qc && !(qc->flags & ATA_QCFLAG_EH))
 		qc = NULL;
 
 	spin_lock_irqsave(ap->lock, flags);
@@ -2796,7 +2796,7 @@ void ata_bmdma_error_handler(struct ata_port *ap)
 	bool thaw = false;
 
 	qc = __ata_qc_from_tag(ap, ap->link.active_tag);
-	if (qc && !(qc->flags & ATA_QCFLAG_FAILED))
+	if (qc && !(qc->flags & ATA_QCFLAG_EH))
 		qc = NULL;
 
 	/* reset PIO HSM and stop DMA engine */
diff --git a/drivers/ata/libata-trace.c b/drivers/ata/libata-trace.c
index e0e4d0d5a100..9b5363fd0ab0 100644
--- a/drivers/ata/libata-trace.c
+++ b/drivers/ata/libata-trace.c
@@ -142,7 +142,7 @@ libata_trace_parse_qc_flags(struct trace_seq *p, unsigned int qc_flags)
 			trace_seq_printf(p, "QUIET ");
 		if (qc_flags & ATA_QCFLAG_RETRY)
 			trace_seq_printf(p, "RETRY ");
-		if (qc_flags & ATA_QCFLAG_FAILED)
+		if (qc_flags & ATA_QCFLAG_EH)
 			trace_seq_printf(p, "FAILED ");
 		if (qc_flags & ATA_QCFLAG_SENSE_VALID)
 			trace_seq_printf(p, "SENSE_VALID ");
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index b9a4f68b371d..7eab9c4e1473 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1042,7 +1042,7 @@ static void sata_fsl_error_handler(struct ata_port *ap)
 
 static void sata_fsl_post_internal_cmd(struct ata_queued_cmd *qc)
 {
-	if (qc->flags & ATA_QCFLAG_FAILED)
+	if (qc->flags & ATA_QCFLAG_EH)
 		qc->err_mask |= AC_ERR_OTHER;
 
 	if (qc->err_mask) {
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 11e518f0111c..f480ff456190 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -672,7 +672,7 @@ static void inic_error_handler(struct ata_port *ap)
 static void inic_post_internal_cmd(struct ata_queued_cmd *qc)
 {
 	/* make DMA engine forget about the failed command */
-	if (qc->flags & ATA_QCFLAG_FAILED)
+	if (qc->flags & ATA_QCFLAG_EH)
 		inic_reset_port(inic_port_base(qc->ap));
 }
 
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 9cd7d8b71361..4e60e6c4c35a 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -828,7 +828,7 @@ static void pdc_post_internal_cmd(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 
 	/* make DMA engine forget about the failed command */
-	if (qc->flags & ATA_QCFLAG_FAILED)
+	if (qc->flags & ATA_QCFLAG_EH)
 		pdc_reset_port(ap);
 }
 
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 2fef6ce93f07..0a01518a8d97 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -1185,7 +1185,7 @@ static void sil24_post_internal_cmd(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 
 	/* make DMA engine forget about the failed command */
-	if ((qc->flags & ATA_QCFLAG_FAILED) && sil24_init_port(ap))
+	if ((qc->flags & ATA_QCFLAG_EH) && sil24_init_port(ap))
 		ata_eh_freeze_port(ap);
 }
 
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index ab70cbc78f96..a92c60455b1d 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -866,7 +866,7 @@ static void pdc_post_internal_cmd(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 
 	/* make DMA engine forget about the failed command */
-	if (qc->flags & ATA_QCFLAG_FAILED)
+	if (qc->flags & ATA_QCFLAG_EH)
 		pdc_reset_port(ap);
 }
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 2022ffb45041..c68ca2218a05 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5370,9 +5370,9 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 					continue;
 
 				ipr_cmd->done = ipr_sata_eh_done;
-				if (!(ipr_cmd->qc->flags & ATA_QCFLAG_FAILED)) {
+				if (!(ipr_cmd->qc->flags & ATA_QCFLAG_EH)) {
 					ipr_cmd->qc->err_mask |= AC_ERR_TIMEOUT;
-					ipr_cmd->qc->flags |= ATA_QCFLAG_FAILED;
+					ipr_cmd->qc->flags |= ATA_QCFLAG_EH;
 				}
 			}
 		}
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 1ccce706167a..14da33a3b6a6 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -125,7 +125,7 @@ static void sas_ata_task_done(struct sas_task *task)
 		} else {
 			link->eh_info.err_mask |= ac_err_mask(dev->sata_dev.fis[2]);
 			if (unlikely(link->eh_info.err_mask))
-				qc->flags |= ATA_QCFLAG_FAILED;
+				qc->flags |= ATA_QCFLAG_EH;
 		}
 	} else {
 		ac = sas_to_ata_err(stat);
@@ -136,7 +136,7 @@ static void sas_ata_task_done(struct sas_task *task)
 				qc->err_mask = ac;
 			} else {
 				link->eh_info.err_mask |= AC_ERR_DEV;
-				qc->flags |= ATA_QCFLAG_FAILED;
+				qc->flags |= ATA_QCFLAG_EH;
 			}
 
 			dev->sata_dev.fis[2] = ATA_ERR | ATA_DRDY; /* tf status */
@@ -476,7 +476,7 @@ static void sas_ata_internal_abort(struct sas_task *task)
 
 static void sas_ata_post_internal(struct ata_queued_cmd *qc)
 {
-	if (qc->flags & ATA_QCFLAG_FAILED)
+	if (qc->flags & ATA_QCFLAG_EH)
 		qc->err_mask |= AC_ERR_OTHER;
 
 	if (qc->err_mask) {
@@ -631,7 +631,7 @@ void sas_ata_task_abort(struct sas_task *task)
 
 	/* Internal command, fake a timeout and complete. */
 	qc->flags &= ~ATA_QCFLAG_ACTIVE;
-	qc->flags |= ATA_QCFLAG_FAILED;
+	qc->flags |= ATA_QCFLAG_EH;
 	qc->err_mask |= AC_ERR_TIMEOUT;
 	waiting = qc->private_data;
 	complete(waiting);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c9149ebe7423..7985e6e2ae0e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -206,7 +206,7 @@ enum {
 	ATA_QCFLAG_QUIET	= (1 << 6), /* don't report device error */
 	ATA_QCFLAG_RETRY	= (1 << 7), /* retry after failure */
 
-	ATA_QCFLAG_FAILED	= (1 << 16), /* cmd failed and is owned by EH */
+	ATA_QCFLAG_EH		= (1 << 16), /* cmd aborted and owned by EH */
 	ATA_QCFLAG_SENSE_VALID	= (1 << 17), /* sense data valid */
 	ATA_QCFLAG_EH_SCHEDULED = (1 << 18), /* EH scheduled (obsolete) */
 
@@ -1756,7 +1756,7 @@ static inline struct ata_queued_cmd *ata_qc_from_tag(struct ata_port *ap,
 		return qc;
 
 	if ((qc->flags & (ATA_QCFLAG_ACTIVE |
-			  ATA_QCFLAG_FAILED)) == ATA_QCFLAG_ACTIVE)
+			  ATA_QCFLAG_EH)) == ATA_QCFLAG_ACTIVE)
 		return qc;
 
 	return NULL;
-- 
2.38.1

