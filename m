From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH 3/5] megaraid_sas: do not crash on invalid completion
Date: Fri, 11 Nov 2016 17:21:51 +0530
Message-ID: <5f5b5d4c3503fabc4344b8eddfc30129@mail.gmail.com>
References: <1478857492-4581-1-git-send-email-hare@suse.de> <1478857492-4581-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37229 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753256AbcKKLvz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2016 06:51:55 -0500
Received: by mail-it0-f48.google.com with SMTP id u205so116905104itc.0
        for <linux-scsi@vger.kernel.org>; Fri, 11 Nov 2016 03:51:55 -0800 (PST)
In-Reply-To: <1478857492-4581-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>owner@vger.kernel.org] On Behalf Of Hannes Reinecke
>Sent: Friday, November 11, 2016 3:15 PM
>To: Martin K. Petersen
>Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; linux-
>scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
>Subject: [PATCH 3/5] megaraid_sas: do not crash on invalid completion
>
>Avoid a kernel oops when receiving an invalid command completion.
scmd_local set to NULL(for cases MPI2_FUNCTION_SCSI_IO_REQUEST and
MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST) will be serious bug(either in driver
or firmware) which should be debugged
and driver should not really continue beyond that. This indicates that
driver internal frames are corrupted. If needed, whenever driver detects
it, it can mark the adapter as dead(stopping further activities).
If OS is installed behind megasas controller then after declaring adapter
dead, system reboot will be required. Kernel panic may give here more
information whenever this condition hits so we kept it like this.
If you are facing this issue, please share the details. I will work on
this.

Thanks,
Sumit

>
>Signed-off-by: Hannes Reinecke <hare@suse.com>
>---
> drivers/scsi/megaraid/megaraid_sas_fusion.c | 22 +++++++++++++++-------
> 1 file changed, 15 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>index 38137de..eb3cb0f 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>@@ -2298,13 +2298,15 @@ static void megasas_build_ld_nonrw_fusion(struct
>megasas_instance *instance,
> 			break;
> 		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
> 			/* Update load balancing info */
>-			device_id = MEGASAS_DEV_INDEX(scmd_local);
>-			lbinfo = &fusion->load_balance_info[device_id];
>-			if (cmd_fusion->scmd->SCp.Status &
>-			    MEGASAS_LOAD_BALANCE_FLAG) {
>-
>atomic_dec(&lbinfo->scsi_pending_cmds[cmd_fusion->pd_r1_lb]);
>-				cmd_fusion->scmd->SCp.Status &=
>-					~MEGASAS_LOAD_BALANCE_FLAG;
>+			if (scmd_local) {
>+				device_id = MEGASAS_DEV_INDEX(scmd_local);
>+				lbinfo =
>&fusion->load_balance_info[device_id];
>+				if (cmd_fusion->scmd->SCp.Status &
>+				    MEGASAS_LOAD_BALANCE_FLAG) {
>+
>atomic_dec(&lbinfo->scsi_pending_cmds[cmd_fusion->pd_r1_lb]);
>+					cmd_fusion->scmd->SCp.Status &=
>+
>~MEGASAS_LOAD_BALANCE_FLAG;
>+				}
> 			}
> 			if (reply_descript_type ==
> 			    MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS) { @@
>-2315,6 +2317,12 @@ static void megasas_build_ld_nonrw_fusion(struct
>megasas_instance *instance,
> 			/* Fall thru and complete IO */
> 		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO
>Path */
> 			/* Map the FW Cmd Status */
>+			if (!scmd_local) {
>+				dev_err(&instance->pdev->dev,
>+					"cmd[%d:%d] already completed\n",
>+					MSIxIndex, smid);
>+				break;
>+			}
> 			map_cmd_status(cmd_fusion, status, extStatus);
> 			scsi_io_req->RaidContext.status = 0;
> 			scsi_io_req->RaidContext.exStatus = 0;
>--
>1.8.5.6
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of
>a message to majordomo@vger.kernel.org More majordomo info at
>http://vger.kernel.org/majordomo-info.html
