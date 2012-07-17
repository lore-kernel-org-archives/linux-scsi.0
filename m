From: <sreekanth.reddy@lsi.com>
Subject: [PATCH 08/09] [SCSI] mpt2sas : Fix for With post diag reset same set
 of device gets added, removed and then again gets added with new target ids
Date: Tue, 17 Jul 2012 15:56:13 +0530
Message-ID: <20120717102613.GA7358@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:46103 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754920Ab2GQKZb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2012 06:25:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: jejb@kernel.org

When device discovery is disabled during driver load time using module parameter
"disable_discovery=1" and when diag reset is issued then from logs, it is observed
that the devices get added, removed and then added with new target ids.

So, inorder to limit this turn-off the code which is deleting and devices across
host reset when the disable_discovery module parameter is turned on.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 7a69a5c..7efefb7 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7264,7 +7264,8 @@ mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 		_scsih_search_responding_sas_devices(ioc);
 		_scsih_search_responding_raid_devices(ioc);
 		_scsih_search_responding_expanders(ioc);
-		if (!ioc->is_driver_loading) {
+		if ((!ioc->is_driver_loading) && !(disable_discovery > 0 &&
+		    !ioc->sas_hba.num_phys)) {
 			_scsih_prep_device_scan(ioc);
 			_scsih_search_responding_sas_devices(ioc);
 			_scsih_search_responding_raid_devices(ioc);
