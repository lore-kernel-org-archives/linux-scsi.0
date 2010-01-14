From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/3] zfcp: Introduce bsg_timeout callback.
Date: Thu, 14 Jan 2010 17:19:01 +0100
Message-ID: <20100114163345.126589000@de.ibm.com>
References: <20100114161859.790342000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:52191 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab0ANQdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 11:33:47 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.1/8.13.1) with ESMTP id o0EGXksG029189
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 16:33:46 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0EGXkqS1413248
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 17:33:46 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o0EGXjOv022397
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 17:33:46 +0100
Content-Disposition: inline; filename=zfcp_bsg_timeout.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Introduce a zfcp callback for timeouts triggered from FC BSG.  With
zfcp, the underlying hardware cannot abort CT or ELS requests, so
there is nothing to do when the block layer timeout expires.  To avoid
interference with the block layer timeout, simply indicate that the
block layer timer should be reset. The timer running in the hardware
for the pending CT or ELS request will return the request when it
expires.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_ext.h  |    1 +
 drivers/s390/scsi/zfcp_fc.c   |    6 ++++++
 drivers/s390/scsi/zfcp_scsi.c |    1 +
 3 files changed, 8 insertions(+)

--- a/drivers/s390/scsi/zfcp_ext.h	2010-01-14 17:00:09.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2010-01-14 17:00:21.000000000 +0100
@@ -108,6 +108,7 @@ extern void zfcp_fc_wka_ports_force_offl
 extern int zfcp_fc_gs_setup(struct zfcp_adapter *);
 extern void zfcp_fc_gs_destroy(struct zfcp_adapter *);
 extern int zfcp_fc_exec_bsg_job(struct fc_bsg_job *);
+extern int zfcp_fc_timeout_bsg_job(struct fc_bsg_job *);
 
 /* zfcp_fsf.c */
 extern int zfcp_fsf_open_port(struct zfcp_erp_action *);
--- a/drivers/s390/scsi/zfcp_fc.c	2010-01-14 17:00:09.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2010-01-14 17:00:43.000000000 +0100
@@ -788,6 +788,12 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_j
 	}
 }
 
+int zfcp_fc_timeout_bsg_job(struct fc_bsg_job *job)
+{
+	/* hardware tracks timeout, reset bsg timeout to not interfere */
+	return -EAGAIN;
+}
+
 int zfcp_fc_gs_setup(struct zfcp_adapter *adapter)
 {
 	struct zfcp_fc_wka_ports *wka_ports;
--- a/drivers/s390/scsi/zfcp_scsi.c	2010-01-14 17:00:09.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2010-01-14 17:00:21.000000000 +0100
@@ -652,6 +652,7 @@ struct fc_function_template zfcp_transpo
 	.show_host_port_state = 1,
 	.show_host_active_fc4s = 1,
 	.bsg_request = zfcp_fc_exec_bsg_job,
+	.bsg_timeout = zfcp_fc_timeout_bsg_job,
 	/* no functions registered for following dynamic attributes but
 	   directly set by LLDD */
 	.show_host_port_type = 1,

