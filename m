From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 6/7] cxlflash: Fix to avoid unnecessary scan with internal LUNs
Date: Fri,  4 Mar 2016 15:55:19 -0600
Message-ID: <1457128520-53056-6-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:54162 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759087AbcCDV6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2016 16:58:30 -0500
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Fri, 4 Mar 2016 14:58:29 -0700
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 89A6A19D803F
	for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2016 14:46:23 -0700 (MST)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u24LwRDe28246172
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2016 21:58:27 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u24Ls8Oe031017
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2016 16:54:10 -0500
In-Reply-To: <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

When switching to the internal LUN defined on the
IBM CXL flash adapter, there is an unnecessary
scan occurring on the second port. This scan leads
to the following extra lines in the log:

Dec 17 10:09:00 tul83p1 kernel: [ 3708.561134] cxlflash 0008:00:00.0: cxlflash_queuecommand: (scp=c0000000fc1f0f00) 11/1/0/0 cdb=(A0000000-00000000-10000000-00000000)
Dec 17 10:09:00 tul83p1 kernel: [ 3708.561147] process_cmd_err: cmd failed afu_rc=32 scsi_rc=0 fc_rc=0 afu_extra=0xE, scsi_extra=0x0, fc_extra=0x0

By definition, both of the internal LUNs are on the first port/channel.

When the lun_mode is switched to internal LUN the
same value for host->max_channel is retained. This
causes an unnecessary scan over the second port/channel.

This fix alters the host->max_channel to 0 (1 port), if internal
LUNs are configured and switches it back to 1 (2 ports) while
going back to external LUNs.

Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index ca702d8..0f062a4 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2097,6 +2097,16 @@ static ssize_t lun_mode_store(struct device *dev,
 	rc = kstrtouint(buf, 10, &lun_mode);
 	if (!rc && (lun_mode < 5) && (lun_mode != afu->internal_lun)) {
 		afu->internal_lun = lun_mode;
+
+		/*
+		 * When configured for internal LUN, there is only one channel,
+		 * channel number 0, else there will be 2 (default).
+		 */
+		if (afu->internal_lun)
+			shost->max_channel = 0;
+		else
+			shost->max_channel = NUM_FC_PORTS - 1;
+
 		afu_reset(cfg);
 		scsi_scan_host(cfg->host);
 	}
-- 
2.1.0

