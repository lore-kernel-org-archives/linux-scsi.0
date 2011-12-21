From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH] scsi_dh_alua: Retry the check-condition in case Mode Parameters Changed
Date: Wed, 21 Dec 2011 18:01:37 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD910D14606@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:64715 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1LUXBz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2011 18:01:55 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, JBottomley@Parallels.com

This patch adds a check-condition in scsi_dh_alua handler for a retry.
Sometimes,
I have seen attach failing due to this check-condition with following
error 
messages on NetApp E series storage.

Dec  7 15:31:01 nilgiris kernel: [102979.696673] scsi 3:0:2:9: alua:
port group 00 rel port 01
Dec  7 15:31:01 nilgiris kernel: [102979.697082] scsi 3:0:2:9: alua:
rtpg failed with 8000002
Dec  7 15:31:01 nilgiris kernel: [102979.697086] scsi 3:0:2:9: alua:
rtpg sense code 06/2a/01
Dec  7 15:31:01 nilgiris kernel: [102979.697088] scsi 3:0:2:9: alua: not
attached

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---

--- linux-3.2-rc6/drivers/scsi/device_handler/scsi_dh_alua.c.orig
2011-12-21 15:48:46.000000000 -0600
+++ linux-3.2-rc6/drivers/scsi/device_handler/scsi_dh_alua.c
2011-12-21 16:03:56.000000000 -0600
@@ -466,6 +466,11 @@ static int alua_check_sense(struct scsi_
 			 * Power On, Reset, or Bus Device Reset, just
retry.
 			 */
 			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
+			/*
+			 * Mode Parameters Changed
+			 */
+			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06)
 			/*
 			 * ALUA state changed


