From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 30/39] megaraid_sas: Do not set fp_possible if TM capable for non-RW syspdIO, change fp_possible to bool
Date: Fri, 10 Feb 2017 00:59:30 -0800
Message-ID: <1486717179-23320-31-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:35559 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752176AbdBJJcb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 04:32:31 -0500
Received: by mail-pg0-f44.google.com with SMTP id 194so9234413pgd.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 01:32:01 -0800 (PST)
In-Reply-To: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

FIX - firmware wants non-RW SYS PD IOs to avoid FastPath for
better tracking and other functionalities if the device
is task management capable.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index a9b66ce..ba102e4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2566,7 +2566,8 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
  */
 static void
 megasas_build_syspd_fusion(struct megasas_instance *instance,
-	struct scsi_cmnd *scmd, struct megasas_cmd_fusion *cmd, u8 fp_possible)
+	struct scsi_cmnd *scmd, struct megasas_cmd_fusion *cmd,
+	bool fp_possible)
 {
 	u32 device_id;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
@@ -2687,6 +2688,8 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 	int sge_count;
 	u8  cmd_type;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request = cmd->io_request;
+	struct MR_PRIV_DEVICE *mr_device_priv_data;
+	mr_device_priv_data = scp->device->hostdata;
 
 	/* Zero out some fields so they don't get reused */
 	memset(io_request->LUN, 0x0, 8);
@@ -2715,12 +2718,14 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 		megasas_build_ld_nonrw_fusion(instance, scp, cmd);
 		break;
 	case READ_WRITE_SYSPDIO:
+		megasas_build_syspd_fusion(instance, scp, cmd, true);
+		break;
 	case NON_READ_WRITE_SYSPDIO:
-		if (instance->secure_jbod_support &&
-			(cmd_type == NON_READ_WRITE_SYSPDIO))
-			megasas_build_syspd_fusion(instance, scp, cmd, 0);
+		if (instance->secure_jbod_support ||
+		    mr_device_priv_data->is_tm_capable)
+			megasas_build_syspd_fusion(instance, scp, cmd, false);
 		else
-			megasas_build_syspd_fusion(instance, scp, cmd, 1);
+			megasas_build_syspd_fusion(instance, scp, cmd, true);
 		break;
 	default:
 		break;
-- 
2.8.3
