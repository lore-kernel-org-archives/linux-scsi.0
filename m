From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/6] ipr: Fix target id allocation re-use problem
Date: Wed, 14 Mar 2012 21:20:06 -0500
Message-ID: <201203150220.q2F2K3Ux002767@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:39366 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab2COCUK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 22:20:10 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 14 Mar 2012 20:20:09 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 833A01FF0038
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:05 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2F2K5gw130940
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:05 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2F2K4BB002802
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:05 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


For the latest ipr SAS adapters, target id's are a completely
logical construct that are managed in the ipr driver. This fixes
an issue that can arise if a device is deleted via sysfs. If
a new device is then physically added, it will use the previous
device's target id. If the host is then rescanned, the device
that had been deleted, since it is using the same target id as
the new device is using, will never be found, resulting in
a missing device. Fix this by only freeing the target id
only if the resource is actually gone.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_fix_target_id_alloc drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_fix_target_id_alloc	2012-03-09 17:19:28.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2012-03-10 07:23:10.000000000 -0600
@@ -4339,8 +4339,7 @@ static struct ipr_resource_entry *ipr_fi
 
 	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
 		if ((res->bus == starget->channel) &&
-		    (res->target == starget->id) &&
-		    (res->lun == 0)) {
+		    (res->target == starget->id)) {
 			return res;
 		}
 	}
@@ -4414,12 +4413,14 @@ static void ipr_target_destroy(struct sc
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
 
 	if (ioa_cfg->sis64) {
-		if (starget->channel == IPR_ARRAY_VIRTUAL_BUS)
-			clear_bit(starget->id, ioa_cfg->array_ids);
-		else if (starget->channel == IPR_VSET_VIRTUAL_BUS)
-			clear_bit(starget->id, ioa_cfg->vset_ids);
-		else if (starget->channel == 0)
-			clear_bit(starget->id, ioa_cfg->target_ids);
+		if (!ipr_find_starget(starget)) {
+			if (starget->channel == IPR_ARRAY_VIRTUAL_BUS)
+				clear_bit(starget->id, ioa_cfg->array_ids);
+			else if (starget->channel == IPR_VSET_VIRTUAL_BUS)
+				clear_bit(starget->id, ioa_cfg->vset_ids);
+			else if (starget->channel == 0)
+				clear_bit(starget->id, ioa_cfg->target_ids);
+		}
 	}
 
 	if (sata_port) {
_

