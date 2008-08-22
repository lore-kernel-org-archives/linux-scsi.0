From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH]: scsi_dh: Initialize path state to be passive when path is
	not owned
Date: Thu, 21 Aug 2008 23:12:40 -0700
Message-ID: <1219385560.14830.103.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:32943 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYHVGNJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2008 02:13:09 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7M6D8KK011385
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2008 02:13:08 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7M6D8U5206460
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2008 00:13:08 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7M6D8Sh008744
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2008 00:13:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>

Set the path state to be passive when we learn that the controller does
not own the path to the LUN.

This will avoid sending even a single i/o thru the passive path at the
probe time.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

Index: linux-2.6.27-rc3/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux-2.6.27-rc3.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.27-rc3/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -402,6 +402,9 @@ static int check_ownership(struct scsi_d
 		}
 	}
 
+	if (h->lun_state == RDAC_LUN_UNOWNED)
+		h->state = RDAC_STATE_PASSIVE;
+
 	return err;
 }
 


