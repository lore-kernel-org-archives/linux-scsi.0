From: David Milburn <dmilburn@redhat.com>
Subject: [PATCH] mvsas: defer non-NCQ cmds when NCQ cmds are active
Date: Tue, 21 Sep 2010 14:17:01 -0500
Message-ID: <20100921191701.GA16726@dhcp-10-15-1-70.hsv.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab0IUTQ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2010 15:16:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, jeff@garzik.org, k.skarlatos@gmail.com

Non-NCQ commands should run exclusively, ata_qc_issue warns when mixing
non-NCQ and NCQ commands.

Signed-off-by: David Milburn <dmilburn@redhat.com>
Reported-by: Konstantinos Skarlatos <k.skarlatos@gmail.com>
---
 drivers/scsi/libsas/sas_ata.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 042153c..ddbade7 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -347,6 +347,7 @@ static int sas_ata_scr_read(struct ata_link *link, unsigned int sc_reg_in,
 static struct ata_port_operations sas_sata_ops = {
 	.phy_reset		= sas_ata_phy_reset,
 	.post_internal_cmd	= sas_ata_post_internal,
+	.qc_defer               = ata_std_qc_defer,
 	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= sas_ata_qc_issue,
 	.qc_fill_rtf		= sas_ata_qc_fill_rtf,
