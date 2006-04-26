From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/1] scsi: Add IBM 2104-DU3 to blist
Date: Wed, 26 Apr 2006 13:48:11 -0500
Message-ID: <200604261848.k3QImCKm015086@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:34703 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S964815AbWDZSsR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Apr 2006 14:48:17 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k3QImEje022759
	for <linux-scsi@vger.kernel.org>; Wed, 26 Apr 2006 14:48:14 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k3QIiPUh269760
	for <linux-scsi@vger.kernel.org>; Wed, 26 Apr 2006 12:44:25 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k3QImDoh015189
	for <linux-scsi@vger.kernel.org>; Wed, 26 Apr 2006 12:48:14 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Some versions of the IBM 2104-DU3 disk enclosure
have been observed to hang Inquiries to non zero
LUNs to the SES device. This device only has LUN 0,
so this patch adds it to the BLIST to prevent scsi
core from scanning beyond LUN 0.


Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/scsi_devinfo.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/scsi_devinfo.c~scsi_2104-DU3_blist drivers/scsi/scsi_devinfo.c
--- linux-2.6/drivers/scsi/scsi_devinfo.c~scsi_2104-DU3_blist	2006-04-25 14:52:21.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/scsi_devinfo.c	2006-04-25 14:55:33.000000000 -0500
@@ -56,6 +56,8 @@ static struct {
 	{"DENON", "DRD-25X", "V", BLIST_NOLUN},			/* locks up */
 	{"HITACHI", "DK312C", "CM81", BLIST_NOLUN},	/* responds to all lun */
 	{"HITACHI", "DK314C", "CR21", BLIST_NOLUN},	/* responds to all lun */
+	{"IBM", "2104-DU3", NULL, BLIST_NOLUN},		/* locks up */
+	{"IBM", "2104-TU3", NULL, BLIST_NOLUN},		/* locks up */
 	{"IMS", "CDD521/10", "2.06", BLIST_NOLUN},	/* locks up */
 	{"MAXTOR", "XT-3280", "PR02", BLIST_NOLUN},	/* locks up */
 	{"MAXTOR", "XT-4380S", "B3C", BLIST_NOLUN},	/* locks up */
_
