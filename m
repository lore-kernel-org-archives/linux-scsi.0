From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH]: [scsi_dh] Do not use scsilun in rdac hardware handler
Date: Tue, 12 Aug 2008 17:26:58 -0700
Message-ID: <1218587218.16794.70.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:57306 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbYHMA1Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Aug 2008 20:27:24 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7D0KqNV027744
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 20:20:52 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7D0RNk7176204
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 18:27:23 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7D0RMYj028327
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 18:27:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Yanqing_Liu <Yanqing_Liu@Dell.com>


RDAC storage controller doesn't seem to use the scsilun format. It uses
only the last byte for LUN.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.27-rc1/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux-2.6.27-rc1.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.27-rc1/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -376,7 +376,7 @@ static int get_lun(struct scsi_device *s
 		if (inqp->page_id[0] != 'e' || inqp->page_id[1] != 'd' ||
 		    inqp->page_id[2] != 'i' || inqp->page_id[3] != 'd')
 			return SCSI_DH_NOSYS;
-		h->lun = scsilun_to_int((struct scsi_lun *)inqp->lun);
+		h->lun = inqp->lun[7]; /* Uses only the last byte */
 	}
 	return err;
 }


