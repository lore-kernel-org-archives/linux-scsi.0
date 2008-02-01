From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] sd: make error handling more robust (v2)
Date: Fri, 01 Feb 2008 12:03:27 -0500
Message-ID: <47A350DF.5020404@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([70.169.137.4]:4502 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbYBARDV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 12:03:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>

This patch fixes a problem with some out-of-spec SCSI disks that report
hardware or medium errors incorrectly.  Without the patch, the kernel
may silently ignore a failed write command or return corrupted data on a
failed read command.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

This is a simplified version of the original patch that fixes just the
problem at hand, without trying to handle other theoretical out-of-spec
cases.

Applies to kernels 2.6.18 - 2.6.24-git10+.

--- linux-2.6.24-git10/drivers/scsi/sd.c.orig	2008-02-01 11:24:37.000000000 -0500
+++ linux-2.6.24-git10/drivers/scsi/sd.c	2008-02-01 11:26:12.000000000 -0500
@@ -990,6 +990,8 @@ static int sd_done(struct scsi_cmnd *SCp
 		/* This computation should always be done in terms of
 		 * the resolution of the device's medium.
 		 */
+		if (bad_lba < start_lba)
+			goto out;
 		good_bytes = (bad_lba - start_lba)*SCpnt->device->sector_size;
 		break;
 	case RECOVERED_ERROR:


