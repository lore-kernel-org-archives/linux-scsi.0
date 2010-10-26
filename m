From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [RESUBMIT][Patch] scsi_dh_rdac: retry IO for 06/3f/03 in
  rdac_check_sense fn
Date: Tue, 26 Oct 2010 19:23:11 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED704BFE578@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:36096 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512Ab0JZNzo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 09:55:44 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@kernel.org>, device-mapper development <dm-devel@redhat.com>
Cc: "sekharan@us.ibm.com" <sekharan@us.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Resubmitting this patch to get the attention.

This patch adds retry for the IO returned with 06/3f/03((INQUIRY_DATA_CHANGED)) sense code  in rdac_check_sense(). IO returned with 06/3f/03 from controller are currently failed by scsi mid layer, as a reason momentarily path failure is noticed by DM multipath. 

Signed-off-by: Vijay Chauhan<vijay.chauhan@lsi.com>
Reviewed-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
---

diff -uprN linux-2.6.35-rc6-orig/drivers/scsi/device_handler/scsi_dh_rdac.c linux-2.6.35-rc6/drivers/scsi/device_handler/scsi_dh_rdac.c
--- linux-2.6.35-rc6-orig/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-07-22 15:13:38.000000000 -0400
+++ linux-2.6.35-rc6/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-07-27 12:13:58.000000000 -0400
@@ -738,6 +738,11 @@ static int rdac_check_sense(struct scsi_
 			 * Quiescence in progress , just retry.
 			 */
 			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
+			/*
+			 * INQUIRY DATA has changed, retry again.
+			 */
+			return ADD_TO_MLQUEUE;
 		break;
 	}
 	/* success just means we do not care what scsi-ml does */

