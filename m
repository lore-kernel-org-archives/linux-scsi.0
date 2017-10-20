From: Douglas Miller <dougmill@linux.vnet.ibm.com>
Subject: [PATCH 1/1] qla2xxx: Fix oops in qla2x00_probe_one error path
Date: Fri, 20 Oct 2017 08:17:22 -0500
Message-ID: <1508505442-30352-2-git-send-email-dougmill@linux.vnet.ibm.com>
References: <1508505442-30352-1-git-send-email-dougmill@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751750AbdJTNR3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Oct 2017 09:17:29 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9KDAQGS033437
        for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2017 09:17:29 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2dqfwq6d4u-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2017 09:17:29 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <dougmill@linux.vnet.ibm.com>;
        Fri, 20 Oct 2017 09:17:28 -0400
In-Reply-To: <1508505442-30352-1-git-send-email-dougmill@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com

On error, kthread_create() returns an errno-encoded pointer, not NULL.
The routine qla2x00_probe_one() detects the error case and jumps
to probe_failed, but has already assigned the return value from
kthread_create() to ha->dpc_thread.  Then probe_failed checks to see
if ha->dpc_thread is not NULL before doing cleanup on it. Since in the
error case this is also not NULL, it ends up trying to access an invalid
task pointer.

Solution is to assign NULL to ha->dpc_thread in the error path to avoid
kthread cleanup in that case.

Signed-off-by: Douglas Miller <dougmill@linux.vnet.ibm.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9372098..bd39bf2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3212,6 +3212,7 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
 		ql_log(ql_log_fatal, base_vha, 0x00ed,
 		    "Failed to start DPC thread.\n");
 		ret = PTR_ERR(ha->dpc_thread);
+		ha->dpc_thread = NULL;
 		goto probe_failed;
 	}
 	ql_dbg(ql_dbg_init, base_vha, 0x00ee,
-- 
1.7.1
