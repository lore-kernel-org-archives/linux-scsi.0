From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH v2 1/2] scsi: mpt3sas: fix oops in error handlers after shutdown/unload
Date: Fri, 16 Feb 2018 20:39:57 -0200
Message-ID: <1518820798-21018-2-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1518820798-21018-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46292 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750797AbeBPWkL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Feb 2018 17:40:11 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w1GMdiJ0146322
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2018 17:40:10 -0500
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2g63kracwa-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2018 17:40:10 -0500
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Fri, 16 Feb 2018 17:40:09 -0500
In-Reply-To: <1518820798-21018-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Bart.VanAssche@wdc.com, sreekanth.reddy@broadcom.com
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dougmill@linux.vnet.ibm.com

This patch adds checks for 'ioc->remove_host' in the SCSI error
handlers, so not to access pointers/resources potentially freed
in the PCI shutdown/module unload path.  The error handlers may
be invoked after shutdown/unload, depending on other components.

This problem was observed with kexec on a system with a mpt3sas
based adapter and an infiniband adapter which takes long enough
to shutdown:

The mpt3sas driver finished shutting down / disabled interrupt
handling, thus some commands have not finished and timed out.

Since the system was still running (waiting for the infiniband
adapter to shutdown), the scsi error handler for task abort of
mpt3sas was invoked, and hit an oops -- either in scsih_abort()
because 'ioc->scsi_lookup' was NULL (without commit dbec4c90
"scsi: mpt3sas: lockless command submission"), or later up in
scsih_host_reset() (with or without that commit), because it
eventually called mpt3sas_base_get_iocstate().

After commit dbec4c90, the oops in scsih_abort() does not occur
anymore (_scsih_scsi_lookup_find_by_scmd() is no longer called),
but that commit is too big and out of the scope of linux-stable,
where this patch might help, so still go for the changes.

Also, this might help to prevent similar errors in the future,
in case code changes and possibly tries to access freed stuff.

Note the fix in scsih_host_reset() is still important anyway.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 74fca18..5ab3caf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2835,7 +2835,8 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
-	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
+	    ioc->remove_host) {
 		sdev_printk(KERN_INFO, scmd->device,
 			"device been deleted! scmd(%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
@@ -2898,7 +2899,8 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
-	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
+	    ioc->remove_host) {
 		sdev_printk(KERN_INFO, scmd->device,
 			"device been deleted! scmd(%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
@@ -2961,7 +2963,8 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
-	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
+	    ioc->remove_host) {
 		starget_printk(KERN_INFO, starget, "target been deleted! scmd(%p)\n",
 			scmd);
 		scmd->result = DID_NO_CONNECT << 16;
@@ -3019,7 +3022,7 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	    ioc->name, scmd);
 	scsi_print_command(scmd);
 
-	if (ioc->is_driver_loading) {
+	if (ioc->is_driver_loading || ioc->remove_host) {
 		pr_info(MPT3SAS_FMT "Blocking the host reset\n",
 		    ioc->name);
 		r = FAILED;
-- 
1.8.3.1
