From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] eata_pio: off by one in eata_pio_detect()
Date: Fri, 23 Aug 2013 15:11:31 +0300
Message-ID: <20130823121131.GA10539@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29215 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3HWMMa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Aug 2013 08:12:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Neuffer <mike@i-Connect.Net>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-eata@i-Connect.Net, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

Smatch complains that the reg_IRQ[] array only has MAXIRQ (16) elements
so we are one space beyond the end of the array here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 356def4..1663173 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -919,7 +919,7 @@ static int eata_pio_detect(struct scsi_host_template *tpnt)
 	find_pio_EISA(&gc);
 	find_pio_ISA(&gc);
 
-	for (i = 0; i <= MAXIRQ; i++)
+	for (i = 0; i < MAXIRQ; i++)
 		if (reg_IRQ[i])
 			request_irq(i, do_eata_pio_int_handler, IRQF_DISABLED, "EATA-PIO", NULL);
 
