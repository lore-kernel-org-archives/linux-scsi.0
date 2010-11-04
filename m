From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ipr: fix lun assignment and comparison
Date: Thu, 04 Nov 2010 09:35:58 -0700
Message-ID: <4CD2E0EE.5020802@linux.vnet.ibm.com>
References: <20101104162643.264567565@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:40906 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0KDQgA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2010 12:36:00 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id oA4GQ3UM001599
	for <linux-scsi@vger.kernel.org>; Thu, 4 Nov 2010 10:26:03 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id oA4GZxiI216728
	for <linux-scsi@vger.kernel.org>; Thu, 4 Nov 2010 10:35:59 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id oA4Gdwse020218
	for <linux-scsi@vger.kernel.org>; Thu, 4 Nov 2010 10:39:59 -0600
In-Reply-To: <20101104162643.264567565@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

The lun value was not getting set up correctly for all devices attached to the
new 64 bit adapters.  The fix is to move the logic to earlier in the
ipr_init_res_entry routine such that the value does get set correctly for all
devices.

Then the ipr_is_same_device comparison function was using the wrong lun value
in the logic for the new adapters.  Change this to use the correct lun value.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-11-02 21:23:46.000000000 -0700
+++ b/drivers/scsi/ipr.c	2010-11-04 08:54:52.000000000 -0700
@@ -1048,6 +1048,8 @@ static void ipr_init_res_entry(struct ip
 			sizeof(res->res_path));

 		res->bus = 0;
+		memcpy(&res->dev_lun.scsi_lun, &cfgtew->u.cfgte64->lun,
+			sizeof(res->dev_lun.scsi_lun));
 		res->lun = scsilun_to_int(&res->dev_lun);

 		if (res->type == IPR_RES_TYPE_GENERIC_SCSI) {
@@ -1063,9 +1065,6 @@ static void ipr_init_res_entry(struct ip
 								  ioa_cfg->max_devs_supported);
 				set_bit(res->target, ioa_cfg->target_ids);
 			}
-
-			memcpy(&res->dev_lun.scsi_lun, &cfgtew->u.cfgte64->lun,
-				sizeof(res->dev_lun.scsi_lun));
 		} else if (res->type == IPR_RES_TYPE_IOAFP) {
 			res->bus = IPR_IOAFP_VIRTUAL_BUS;
 			res->target = 0;
@@ -1116,7 +1115,7 @@ static int ipr_is_same_device(struct ipr
 	if (res->ioa_cfg->sis64) {
 		if (!memcmp(&res->dev_id, &cfgtew->u.cfgte64->dev_id,
 					sizeof(cfgtew->u.cfgte64->dev_id)) &&
-			!memcmp(&res->lun, &cfgtew->u.cfgte64->lun,
+			!memcmp(&res->dev_lun.scsi_lun, &cfgtew->u.cfgte64->lun,
 					sizeof(cfgtew->u.cfgte64->lun))) {
 			return 1;
 		}

