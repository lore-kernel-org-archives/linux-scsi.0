From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/2] zfcp: Pass return code from fc_block_scsi_eh to scsi eh
Date: Wed, 24 Mar 2010 16:50:31 +0100
Message-ID: <20100324155827.314205000@de.ibm.com>
References: <20100324155029.241441000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:52476 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab0CXP63 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2010 11:58:29 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.1/8.13.1) with ESMTP id o2OFwRN4032686
	for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2010 15:58:27 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2OFwRvg1437720
	for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2010 16:58:27 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o2OFwRfG009075
	for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2010 16:58:27 +0100
Content-Disposition: inline; filename=fast-fail-2-zfcp.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>

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

