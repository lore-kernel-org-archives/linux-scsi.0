From: brking@us.ibm.com
Subject: [PATCH 14/15] ipr: Send uevent change notifications
Date: Mon, 21 Feb 2005 15:09:55 -0600
Message-ID: <200502212109.j1LL9u6P013322@d01av03.pok.ibm.com>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:5256 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262134AbVBUVJ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:09:57 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL9vUk031755
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:57 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL9vew048302
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:57 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL9uL7013344
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Send scsi_host kobject uevent notifications for potential
configuration changes. This small change allows userspace ipr
apps to use netlink/uevent for configuration change notification
instead of having to poll /sys for this information. These apps
can already look for add/remove uevents for devices, but they also
need to be notified when an adapter reset occurs, which is what this
patch will do.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_kobject_uevent drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_kobject_uevent	2005-02-21 13:16:47.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-21 13:16:47.000000000 -0600
@@ -1923,6 +1923,7 @@ restart:
 	}
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	kobject_uevent(&ioa_cfg->host->shost_classdev.kobj, KOBJ_CHANGE, NULL);
 	LEAVE;
 }
 
@@ -4053,10 +4054,10 @@ static int ipr_ioa_reset_done(struct ipr
 	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
 		if (ioa_cfg->allow_ml_add_del && (res->add_to_ml || res->del_from_ml)) {
 			ipr_trace;
-			schedule_work(&ioa_cfg->work_q);
 			break;
 		}
 	}
+	schedule_work(&ioa_cfg->work_q);
 
 	list_for_each_entry_safe(hostrcb, temp, &ioa_cfg->hostrcb_free_q, queue) {
 		list_del(&hostrcb->queue);
_
