From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: add support for disks >2 TB (and CBSs >12
 bytes)
Date: Mon, 29 Jun 2009 22:02:06 +0200 (CEST)
Message-ID: <tkrat.518b97167f27772a@s5r6.in-berlin.de>
References: <85681F9DCBFF144DA59C70D83EBC1DA2E1EDE7@EIOISER.ioi.com.tw>
 <49FEFF7A.3090603@s5r6.in-berlin.de>
 <1241448686.3315.27.camel@mulgrave.int.hansenpartnership.com>
 <4A4908C4.1070705@s5r6.in-berlin.de>
 <tkrat.a60470e5bddd2db4@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:56712 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474AbZF2UCM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 16:02:12 -0400
In-Reply-To: <tkrat.a60470e5bddd2db4@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, Ronald <Ronald@ioi.com.tw>

We forgot to set Scsi_Host.max_cmd_len.  Therefore SCSI core sent at
most 12 bytes long commands to FireWire targets.  Among else, this
prevented support of disks larger than 2 TB.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: b/drivers/ieee1394/sbp2.c
===================================================================
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -881,6 +881,12 @@ static struct sbp2_lu *sbp2_alloc_device
 
 	shost->hostdata[0] = (unsigned long)lu;
 
+	/*
+	 * SBP-2 does not impose limits on the CDB length.  Targets may have
+	 * limits, but this is going to be reported at the command set level.
+	 */
+	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
+
 	if (!scsi_add_host(shost, &ud->device)) {
 		lu->shost = shost;
 		return lu;

-- 
Stefan Richter
-=====-==--= -==- ===-=
http://arcgraph.de/sr/

