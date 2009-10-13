From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 5/5] zfcp: Flush SCSI registration work when adding unit
Date: Tue, 13 Oct 2009 10:44:11 +0200
Message-ID: <20091013084946.938175000@de.ibm.com>
References: <20091013084406.630890000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:46969 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933810AbZJMIu3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2009 04:50:29 -0400
Content-Disposition: inline; filename=718-zfcp-flush-work.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When configuring a LUN for use in zfcp, flush the SCSI work to ensure
the SCSI device has been created before returning. This means that a
configuration procedure can run these commands in a script and the
SCSI device is available immediately after the unit_add:

echo 1 > /sys/bus/ccw/drivers/zfcp/0.0.181d/online
echo 0x401040C300000000 > \
        /sys/bus/ccw/drivers/zfcp/0.0.181d/0x500507630313c562/unit_add
lsscsi

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_sysfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/s390/scsi/zfcp_sysfs.c	2009-10-07 15:54:50.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs.c	2009-10-09 14:21:14.000000000 +0200
@@ -224,6 +224,7 @@ static ssize_t zfcp_sysfs_unit_add_store
 
 	zfcp_erp_unit_reopen(unit, 0, "syuas_1", NULL);
 	zfcp_erp_wait(unit->port->adapter);
+	flush_work(&unit->scsi_work);
 	zfcp_unit_put(unit);
 out:
 	mutex_unlock(&zfcp_data.config_mutex);

