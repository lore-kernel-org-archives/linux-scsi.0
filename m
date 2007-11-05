From: swen@vnet.ibm.com
Subject: [patch 4/6] zfcp: Remove SCSI devices when removing complete adapter
Date: Mon, 05 Nov 2007 12:37:46 +0100
Message-ID: <20071105114623.907717000@vnet.ibm.com>
References: <20071105113742.233391000@vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:65171 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbXKELqf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 06:46:35 -0500
Content-Disposition: inline; filename=804-zfcp-rmdevs.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The common I/O layer can call remove a handler to inform zfcp
that a device disappeared. The handler zfcp_ccw_remove then
removes all unit, port and the adapter data structures. Removing
the units requires that the SCSI devices are removed first.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_ccw.c |    3 +++
 1 file changed, 3 insertions(+)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2007-11-02 08:37:56.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2007-11-02 08:38:26.000000000 +0100
@@ -120,6 +120,9 @@ zfcp_ccw_remove(struct ccw_device *ccw_d
 
 	list_for_each_entry_safe(port, p, &adapter->port_remove_lh, list) {
 		list_for_each_entry_safe(unit, u, &port->unit_remove_lh, list) {
+			if (atomic_test_mask(ZFCP_STATUS_UNIT_REGISTERED,
+				&unit->status))
+				scsi_remove_device(unit->device);
 			zfcp_unit_dequeue(unit);
 		}
 		zfcp_port_dequeue(port);

-- 
