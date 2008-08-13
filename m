From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH]: [scsi_dh] Initialize lun_state in check_ownership()
Date: Tue, 12 Aug 2008 17:26:59 -0700
Message-ID: <1218587219.16794.71.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56942 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbYHMA11 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2008 20:27:27 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7D0ROOu002422
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 20:27:24 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7D0ROAD241724
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 20:27:24 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7D0RO6c003219
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 20:27:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, "James.Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Yanqing_Liu <Yanqing_Liu@Dell.com>


lun_state need to be initialized inside check_ownership().

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.27-rc1/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux-2.6.27-rc1.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.27-rc1/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -386,6 +386,7 @@ static int check_ownership(struct scsi_d
 	int err;
 	struct c9_inquiry *inqp;
 
+	h->lun_state = RDAC_LUN_UNOWNED;
 	err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry), h);
 	if (err == SCSI_DH_OK) {
 		inqp = &h->inq.c9;


