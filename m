Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB78C6370C
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiLHLDW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiLHLBv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:01:51 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BCCF7B;
        Thu,  8 Dec 2022 03:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497253; x=1702033253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cg0mv9DrQD9PnF4SPJZRB416GhIAfBiBPoam2Ec2fMg=;
  b=TOMa8EDaCR/tO1klnKTCJ7UfCnh09sN6AqRr0/dBBcrMnTpBvbsLzWBd
   hS/xHkE+DJnCmDDHO87AwfTZqq0OrQFYsshniOnA6DUIBh7U8gQYJEBB0
   pSoeay/QVVCdJXz2yhaofgMfmZoaFN03vuTU1BkGa3K7UTw4r6bRLOg0m
   E7C+/PeUeSxScZiqcwWdLe6AwKIm1JjR93gipiM/P4EKnvG3PNgSGBDk3
   ePoYFPdT1+/QEoxs8KEtkk0IOdBRXUw2QKR4ccfEJ7oVWo1wSUVu0yO2Y
   a+lfcsrouO7WQeFU0BzoXL6PN67Tg5T0IVHhKyi7HZMPHOGpHwq0vmmFU
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333365"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:00:53 +0800
IronPort-SDR: y7Hbv7EE33lM6Qahb3zyLesQMcz8L2Y+8FyxcTb+tXxGO4Y38p/W+XGRQz3QunZaj8VwcAkIYL
 yAs4fm3SidVp+xjla4bt1okZfbo8pgLYFDLTVtyh433Sx67TMDFW8Vw0BUf195mhlhCEUKoqJ5
 H8kqZp18VLFffJmJXZgSqCi5BMT5JZ+tOrFsO79VG7EGcjY0r0mykWx6hOYiqrckfY3th9Bhw6
 OAhI7x5e4YM5SeDOGODRllW2dT+gg4FG2Yo062Xxv1r3lUhYx7yZe4DAOIHdyM7QppWoZoSk2C
 kiM=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:13:38 -0800
IronPort-SDR: T+J7fQw8WgSOcNDoJmDhD4sxFAvA8tJk8SCJraNFYLk8p1tf5e3JGHq5qxxLc+ym+HHzDPXaYs
 95RuFp8+YC6BUDE7wHiVhgjJPQVJFRtQVV2BkJxa41t8JsUxFe3836r5Ws7fJbOQNcqyRr9zq9
 oIcx3/0L69AxzqwdURTxcfxo/DjMACmAflIkcGVd9Q2vpRUMHTwE7m9PVqpL7d3EQr4NuXXl3x
 x88sujw23F99W7/ipJjF8gqeF4cLLtd1xZ5DRBPn6nganloKL2du2NqR77a4YNeSYvN8XkKuA1
 a38=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:00:52 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 04/25] ata: libata: fix broken NCQ command status handling
Date:   Thu,  8 Dec 2022 11:59:20 +0100
Message-Id: <20221208105947.2399894-5-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, the status is being read for each QC, inside
ata_qc_complete(), which means that QCs being completed by
ata_qc_complete_multiple() (i.e. multiple QCs completed during a single
interrupt), can have different status and error bits set. This is
because the FIS Receive Area will get updated as soon as the HBA
receives a new FIS from the device in the NCQ case.

Here is an example of the problem:
ata14.00: ata_qc_complete_multiple: done_mask: 0x180000
qc tag: 19 cmd: 0x61 flags: 0x11b err_mask: 0x0 tf->status: 0x40
qc tag: 20 cmd: 0x61 flags: 0x11b err_mask: 0x0 tf->status: 0x43

A print in ata_qc_complete_multiple(), shows that done_mask is: 0x180000
which means that tag 19 and 20 were completed. Another print in
ata_qc_complete(), after the call to fill_result_tf(), shows that tag 19
and 20 have different status values, even though they were completed in
the same ata_qc_complete_multiple() call.

If PMP is not enabled, simply read the status and error once, before
calling ata_qc_complete() for each QC. Without PMP, we know that all QCs
must share the same status and error values.

If PMP is enabled, we also read the status before calling
ata_qc_complete(), however, we still read the status for each QC, since
the QCs can belong to different PMP links (which means that the QCs
does not necessarily share the same status and error values).

Do all this by introducing the new port operation .qc_ncq_fill_rtf. If
set, this operation is called in ata_qc_complete_multiple() to set the
result tf for all completed QCs signaled by the last SDB FIS received.
QCs that have their result tf filled are marked with the new flag
ATA_QCFLAG_RTF_FILLED so that any later execution of the qc_fill_rtf
port operation does nothing (e.g. when called from ata_qc_complete()).

Co-developed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libahci.c     | 90 +++++++++++++++++++++++++++++++++++++--
 drivers/ata/libata-sata.c |  3 ++
 include/linux/libata.h    |  2 +
 3 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 0167aac25c34..019d74d6eb7d 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -56,6 +56,7 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static void ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
+static void ahci_qc_ncq_fill_rtf(struct ata_port *ap, u64 done_mask);
 static int ahci_port_start(struct ata_port *ap);
 static void ahci_port_stop(struct ata_port *ap);
 static enum ata_completion_errors ahci_qc_prep(struct ata_queued_cmd *qc);
@@ -157,6 +158,7 @@ struct ata_port_operations ahci_ops = {
 	.qc_prep		= ahci_qc_prep,
 	.qc_issue		= ahci_qc_issue,
 	.qc_fill_rtf		= ahci_qc_fill_rtf,
+	.qc_ncq_fill_rtf	= ahci_qc_ncq_fill_rtf,
 
 	.freeze			= ahci_freeze,
 	.thaw			= ahci_thaw,
@@ -2058,6 +2060,13 @@ static void ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 	struct ahci_port_priv *pp = qc->ap->private_data;
 	u8 *rx_fis = pp->rx_fis;
 
+	/*
+	 * rtf may already be filled (e.g. for ncq commands).
+	 * If that is the case, we have nothing to do.
+	 */
+	if (qc->flags & ATA_QCFLAG_RTF_FILLED)
+		return;
+
 	if (pp->fbs_enabled)
 		rx_fis += qc->dev->link->pmp * AHCI_RX_FIS_SZ;
 
@@ -2071,6 +2080,9 @@ static void ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 	    !(qc->flags & ATA_QCFLAG_EH)) {
 		ata_tf_from_fis(rx_fis + RX_FIS_PIO_SETUP, &qc->result_tf);
 		qc->result_tf.status = (rx_fis + RX_FIS_PIO_SETUP)[15];
+		qc->flags |= ATA_QCFLAG_RTF_FILLED;
+		return;
+	}
 
 	/*
 	 * For NCQ commands, we never get a D2H FIS, so reading the D2H Register
@@ -2080,13 +2092,85 @@ static void ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 	 * instead. However, the SDB FIS does not contain the LBA, so we can't
 	 * use the ata_tf_from_fis() helper.
 	 */
-	} else if (ata_is_ncq(qc->tf.protocol)) {
+	if (ata_is_ncq(qc->tf.protocol)) {
 		const u8 *fis = rx_fis + RX_FIS_SDB;
 
+		/*
+		 * Successful NCQ commands have been filled already.
+		 * A failed NCQ command will read the status here.
+		 * (Note that a failed NCQ command will get a more specific
+		 * error when reading the NCQ Command Error log.)
+		 */
 		qc->result_tf.status = fis[2];
 		qc->result_tf.error = fis[3];
-	} else
-		ata_tf_from_fis(rx_fis + RX_FIS_D2H_REG, &qc->result_tf);
+		qc->flags |= ATA_QCFLAG_RTF_FILLED;
+		return;
+	}
+
+	ata_tf_from_fis(rx_fis + RX_FIS_D2H_REG, &qc->result_tf);
+	qc->flags |= ATA_QCFLAG_RTF_FILLED;
+}
+
+static void ahci_qc_ncq_fill_rtf(struct ata_port *ap, u64 done_mask)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	const u8 *fis;
+
+	/* No outstanding commands. */
+	if (!ap->qc_active)
+		return;
+
+	/*
+	 * FBS not enabled, so read status and error once, since they are shared
+	 * for all QCs.
+	 */
+	if (!pp->fbs_enabled) {
+		u8 status, error;
+
+		/* No outstanding NCQ commands. */
+		if (!pp->active_link->sactive)
+			return;
+
+		fis = pp->rx_fis + RX_FIS_SDB;
+		status = fis[2];
+		error = fis[3];
+
+		while (done_mask) {
+			struct ata_queued_cmd *qc;
+			unsigned int tag = __ffs64(done_mask);
+
+			qc = ata_qc_from_tag(ap, tag);
+			if (qc && ata_is_ncq(qc->tf.protocol)) {
+				qc->result_tf.status = status;
+				qc->result_tf.error = error;
+				qc->flags |= ATA_QCFLAG_RTF_FILLED;
+			}
+			done_mask &= ~(1ULL << tag);
+		}
+
+		return;
+	}
+
+	/*
+	 * FBS enabled, so read the status and error for each QC, since the QCs
+	 * can belong to different PMP links. (Each PMP link has its own FIS
+	 * Receive Area.)
+	 */
+	while (done_mask) {
+		struct ata_queued_cmd *qc;
+		unsigned int tag = __ffs64(done_mask);
+
+		qc = ata_qc_from_tag(ap, tag);
+		if (qc && ata_is_ncq(qc->tf.protocol)) {
+			fis = pp->rx_fis;
+			fis += qc->dev->link->pmp * AHCI_RX_FIS_SZ;
+			fis += RX_FIS_SDB;
+			qc->result_tf.status = fis[2];
+			qc->result_tf.error = fis[3];
+			qc->flags |= ATA_QCFLAG_RTF_FILLED;
+		}
+		done_mask &= ~(1ULL << tag);
+	}
 }
 
 static void ahci_freeze(struct ata_port *ap)
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 908f35acee1e..f3e7396e3191 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -655,6 +655,9 @@ int ata_qc_complete_multiple(struct ata_port *ap, u64 qc_active)
 		return -EINVAL;
 	}
 
+	if (ap->ops->qc_ncq_fill_rtf)
+		ap->ops->qc_ncq_fill_rtf(ap, done_mask);
+
 	while (done_mask) {
 		struct ata_queued_cmd *qc;
 		unsigned int tag = __ffs64(done_mask);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 31f4eaf515e1..3b7f5d9e2f87 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -199,6 +199,7 @@ enum {
 	/* struct ata_queued_cmd flags */
 	ATA_QCFLAG_ACTIVE	= (1 << 0), /* cmd not yet ack'd to scsi lyer */
 	ATA_QCFLAG_DMAMAP	= (1 << 1), /* SG table is DMA mapped */
+	ATA_QCFLAG_RTF_FILLED	= (1 << 2), /* result TF has been filled */
 	ATA_QCFLAG_IO		= (1 << 3), /* standard IO command */
 	ATA_QCFLAG_RESULT_TF	= (1 << 4), /* result TF requested */
 	ATA_QCFLAG_CLEAR_EXCL	= (1 << 5), /* clear excl_link on completion */
@@ -876,6 +877,7 @@ struct ata_port_operations {
 	enum ata_completion_errors (*qc_prep)(struct ata_queued_cmd *qc);
 	unsigned int (*qc_issue)(struct ata_queued_cmd *qc);
 	void (*qc_fill_rtf)(struct ata_queued_cmd *qc);
+	void (*qc_ncq_fill_rtf)(struct ata_port *ap, u64 done_mask);
 
 	/*
 	 * Configuration and exception handling
-- 
2.38.1

