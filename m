From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH] Make sure the state of a path is set properly when
	controller is swapped from passive to active
Date: Wed, 05 Nov 2008 20:05:21 -0800
Message-ID: <1225944321.14830.1109.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:37100 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYKFEGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 23:06:24 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mA645pgf031561
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2008 21:05:51 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA646N9L111406
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2008 21:06:23 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA645rR6010324
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2008 21:05:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: dm-devel <dm-devel@redhat.com>, "Moger, Babu" <Babu.Moger@lsi.com>

When the controller ownership is changed (from passive to active),
check_ownership() doesn't set the state of the device to ACTIVE.

This patch fixes the problem.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reported and tested by: "Moger, Babu" <Babu.Moger@lsi.com>
---
Index: linux-2.6.28-rc3/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux-2.6.28-rc3.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.28-rc3/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -387,6 +387,7 @@ static int check_ownership(struct scsi_d
 	struct c9_inquiry *inqp;
 
 	h->lun_state = RDAC_LUN_UNOWNED;
+	h->state = RDAC_STATE_ACTIVE;
 	err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry), h);
 	if (err == SCSI_DH_OK) {
 		inqp = &h->inq.c9;


