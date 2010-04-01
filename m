From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/2] zfcp: Pass return code from fc_block_scsi_eh to scsi eh
Date: Thu, 01 Apr 2010 13:48:50 +0200
Message-ID: <20100401115739.812781000@de.ibm.com>
References: <20100401114848.628357000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:60664 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab0DAL5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 07:57:41 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.1/8.13.1) with ESMTP id o31BveR4020646
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2010 11:57:40 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o31Bve8t1687664
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2010 13:57:40 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o31BveTD021132
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2010 13:57:40 +0200
Content-Disposition: inline; filename=fast-fail-2-zfcp.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The return code FAST_IO_FAIL from fc_block_scsi_eh indicates that the
pending I/O requests have been terminated as a result of the
fast_io_fail_tmo. Pass this return code back to the scsi eh to stop
the scsi eh in this case.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2010-03-23 10:59:09.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2010-03-23 11:21:10.000000000 +0100
@@ -174,7 +174,7 @@ static int zfcp_scsi_eh_abort_handler(st
 	struct zfcp_fsf_req *old_req, *abrt_req;
 	unsigned long flags;
 	unsigned long old_reqid = (unsigned long) scpnt->host_scribble;
-	int retval = SUCCESS;
+	int retval = SUCCESS, ret;
 	int retry = 3;
 	char *dbf_tag;
 
@@ -199,7 +199,9 @@ static int zfcp_scsi_eh_abort_handler(st
 			break;
 
 		zfcp_erp_wait(adapter);
-		fc_block_scsi_eh(scpnt);
+		ret = fc_block_scsi_eh(scpnt);
+		if (ret)
+			return ret;
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
 			zfcp_dbf_scsi_abort("nres", adapter->dbf, scpnt, NULL,
@@ -230,7 +232,7 @@ static int zfcp_task_mgmt_function(struc
 	struct zfcp_unit *unit = scpnt->device->hostdata;
 	struct zfcp_adapter *adapter = unit->port->adapter;
 	struct zfcp_fsf_req *fsf_req = NULL;
-	int retval = SUCCESS;
+	int retval = SUCCESS, ret;
 	int retry = 3;
 
 	while (retry--) {
@@ -239,7 +241,10 @@ static int zfcp_task_mgmt_function(struc
 			break;
 
 		zfcp_erp_wait(adapter);
-		fc_block_scsi_eh(scpnt);
+		ret = fc_block_scsi_eh(scpnt);
+		if (ret)
+			return ret;
+
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
 			zfcp_dbf_scsi_devreset("nres", tm_flags, unit, scpnt);
@@ -275,10 +280,13 @@ static int zfcp_scsi_eh_host_reset_handl
 {
 	struct zfcp_unit *unit = scpnt->device->hostdata;
 	struct zfcp_adapter *adapter = unit->port->adapter;
+	int ret;
 
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1", scpnt);
 	zfcp_erp_wait(adapter);
-	fc_block_scsi_eh(scpnt);
+	ret = fc_block_scsi_eh(scpnt);
+	if (ret)
+		return ret;
 
 	return SUCCESS;
 }

