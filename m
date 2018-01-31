From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH] scsi: mpt3sas: fix oops in error handlers after shutdown/unload
Date: Wed, 31 Jan 2018 17:00:00 -0200
Message-ID: <1517425200-19126-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750742AbeAaTAh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Jan 2018 14:00:37 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0VIxM1Y086408
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2018 14:00:34 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fuhgmnfhx-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2018 14:00:21 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Wed, 31 Jan 2018 12:00:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

This patch adds checks for 'ioc->remove_host' in the SCSI error
handlers, so not to access pointers/resources potentially freed
in the PCI shutdown/module unload path.  The error handlers may
be invoked after shutdown/unload, depending on other components.

This problem was observed with kexec on a system with a mpt3sas
based adapter and an infiniband adapter which takes long enough
to shutdown.  The mpt3sas driver finished shuttting down, which
disabled interruption handling, thus some running commands have
not finished and timed out.  Since the system was still running,
waiting for the infiniband adapter to shut down, the scsi error
handler for task abort of mpt3sas was invoked, and hit the oops
because 'ioc->scsi_lookup' was NULL.

During patch testing, a different oops happens if host reset is
reached (when it eventually calls 'mpt3sas_base_get_iocstate()').

The device reset and target reset handlers do not cause oopses,
but print a misleading message of host reset in progress, thus
fix those too.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b258f21..3c4e47c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3007,6 +3007,13 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out;
 	}
 
+	if (ioc->remove_host) {
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		r = SUCCESS;
+		goto out;
+	}
+
 	/* search for the command */
 	smid = _scsih_scsi_lookup_find_by_scmd(ioc, scmd);
 	if (!smid) {
@@ -3069,6 +3076,13 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out;
 	}
 
+	if (ioc->remove_host) {
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		r = SUCCESS;
+		goto out;
+	}
+
 	/* for hidden raid components obtain the volume_handle */
 	handle = 0;
 	if (sas_device_priv_data->sas_target->flags &
@@ -3131,6 +3145,13 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out;
 	}
 
+	if (ioc->remove_host) {
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		r = SUCCESS;
+		goto out;
+	}
+
 	/* for hidden raid components obtain the volume_handle */
 	handle = 0;
 	if (sas_device_priv_data->sas_target->flags &
@@ -3179,6 +3200,13 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	    ioc->name, scmd);
 	scsi_print_command(scmd);
 
+	if (ioc->remove_host) {
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		r = FAILED;
+		goto out;
+	}
+
 	if (ioc->is_driver_loading) {
 		pr_info(MPT3SAS_FMT "Blocking the host reset\n",
 		    ioc->name);
-- 
1.8.3.1
