From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] mpt3sas: issue_reset is uninitialized
Date: Thu, 4 Dec 2014 13:57:05 +0300
Message-ID: <20141204105705.GB22643@mwanda>
References: <20141203100918.GA29583@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23846 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaLDK5a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2014 05:57:30 -0500
Content-Disposition: inline
In-Reply-To: <20141203100918.GA29583@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The "issue_reset" can be used uninitialized.  It should be set to false
at the start.

Also I cleaned up the types a little by using bool.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: style fix.  use true/false instead of 1/0.

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1560115..b9c2739 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3419,7 +3419,7 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
 	u16 smid;
 	u32 ioc_state;
 	unsigned long timeleft;
-	u8 issue_reset;
+	bool issue_reset = false;
 	int rc;
 	void *request;
 	u16 wait_state_count;
@@ -3483,7 +3483,7 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SasIoUnitControlRequest_t)/4);
 		if (!(ioc->base_cmds.status & MPT3_CMD_RESET))
-			issue_reset = 1;
+			issue_reset = true;
 		goto issue_host_reset;
 	}
 	if (ioc->base_cmds.status & MPT3_CMD_REPLY_VALID)
@@ -3523,7 +3523,7 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
 	u16 smid;
 	u32 ioc_state;
 	unsigned long timeleft;
-	u8 issue_reset;
+	bool issue_reset = false;
 	int rc;
 	void *request;
 	u16 wait_state_count;
@@ -3581,7 +3581,7 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
 		_debug_dump_mf(mpi_request,
 		    sizeof(Mpi2SepRequest_t)/4);
 		if (!(ioc->base_cmds.status & MPT3_CMD_RESET))
-			issue_reset = 1;
+			issue_reset = false;
 		goto issue_host_reset;
 	}
 	if (ioc->base_cmds.status & MPT3_CMD_REPLY_VALID)
