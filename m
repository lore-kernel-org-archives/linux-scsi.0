From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid_sas: Fallback to older scanning if no disks are found
Date: Wed, 16 Aug 2017 17:59:37 +0530
Message-ID: <4fa7815961b42046badf9169f4e06cb0@mail.gmail.com>
References: <1502798740-69337-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34776 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751461AbdHPM3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 08:29:40 -0400
Received: by mail-oi0-f53.google.com with SMTP id x3so34261582oia.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2017 05:29:39 -0700 (PDT)
In-Reply-To: <1502798740-69337-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Kashyap Desai <kashyap.desai@broadcom.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org

>-----Original Message-----
>From: Hannes Reinecke [mailto:hare@suse.de]
>Sent: Tuesday, August 15, 2017 5:36 PM
>To: Martin K. Petersen
>Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; Kashyap Desai;
>megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org; Hannes
>Reinecke
>Subject: [PATCH] megaraid_sas: Fallback to older scanning if no disks are
>found
>
>commit 21c9e160a51383d4cb0b882398534b0c95c0cc3b implemented a new
>driver lookup using the MR_DCMD_LD_LIST_QUERY firmware command.
>However, this command might not work properly on older firmware, causing
>the command to return no drives instead of an error.
>This causes a regression on older firmware as the driver will no longer
detect
>any drives.
>This patch checks if MR_DCMD_LD_LIST_QUERY return no drives, and falls
>back to the original method if so.
>
>Signed-off-by: Hannes Reinecke <hare@suse.de>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 29
>+++++++++++++++++++++++------
> 1 file changed, 23 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 39b08fc..a1cf2c3 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -4502,7 +4502,6 @@ int megasas_alloc_cmds(struct megasas_instance
>*instance)
> 		dev_info(&instance->pdev->dev,
> 			"DCMD not supported by firmware - %s %d\n",
> 				__func__, __LINE__);
>-		ret = megasas_get_ld_list(instance);
> 		break;
> 	case DCMD_TIMEOUT:
> 		switch (dcmd_timeout_ocr_possible(instance)) { @@ -4530,6
>+4529,14 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
> 		break;
> 	case DCMD_SUCCESS:
> 		tgtid_count = le32_to_cpu(ci->count);
>+		/*
>+		 * Some older firmware return '0' if the LD LIST QUERY
>+		 * command is not supported.
>+		 */
>+		if (tgtid_count == 0) {
>+			ret = DCMD_FAILED;
>+			break;
>+		}

If firmware does not support LD_LIST_QUERY,  "DCMD_FAILED" should be
returned by megasas_issue_blocked_cmd
(function which fires command to firmware) instead of DCMD_SCCESS.
Can you please help with older firmware version which returns
DCMD_SUCCESS(0) if LD_LIST_QUERY is not supported ?

"tgtid_count" may be zero(in case of no logical disks configured) even
when firmware supports LD LIST QUERY
and in that case also driver will fire old command by calling
megasas_get_ld_list() but that's not a problem.

Thanks,
Sumit

>
> 		if ((tgtid_count > (instance->fw_supported_vd_count)))
> 			break;
>@@ -5146,7 +5153,7 @@ static int megasas_init_fw(struct megasas_instance
>*instance)
> 	struct megasas_register_set __iomem *reg_set;
> 	struct megasas_ctrl_info *ctrl_info = NULL;
> 	unsigned long bar_list;
>-	int i, j, loop, fw_msix_count = 0;
>+	int i, j, loop, fw_msix_count = 0, ret;
> 	struct IOV_111 *iovPtr;
> 	struct fusion_context *fusion;
>
>@@ -5384,8 +5391,11 @@ static int megasas_init_fw(struct megasas_instance
>*instance)
> 		}
> 	}
>
>-	if (megasas_ld_list_query(instance,
>-				  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
>+	ret = megasas_ld_list_query(instance,
>+				    MR_LD_QUERY_TYPE_EXPOSED_TO_HOST);
>+	if (ret == DCMD_FAILED)
>+		ret = megasas_get_ld_list(instance);
>+	if (ret)
> 		goto fail_get_ld_pd_list;
>
> 	/*
>@@ -7426,8 +7436,12 @@ static inline void
>megasas_remove_scsi_device(struct scsi_device *sdev)
> 		case MR_EVT_LD_DELETED:
> 		case MR_EVT_LD_CREATED:
> 			if (!instance->requestorId ||
>-				(instance->requestorId &&
>megasas_get_ld_vf_affiliation(instance, 0)))
>+			    (instance->requestorId &&
>+			     megasas_get_ld_vf_affiliation(instance, 0)))
{
> 				dcmd_ret = megasas_ld_list_query(instance,
>MR_LD_QUERY_TYPE_EXPOSED_TO_HOST);
>+				if (dcmd_ret == DCMD_FAILED)
>+					dcmd_ret =
>megasas_get_ld_list(instance);
>+			}
>
> 			if (dcmd_ret == DCMD_SUCCESS)
> 				doscan = SCAN_VD_CHANNEL;
>@@ -7443,8 +7457,11 @@ static inline void
>megasas_remove_scsi_device(struct scsi_device *sdev)
> 				break;
>
> 			if (!instance->requestorId ||
>-				(instance->requestorId &&
>megasas_get_ld_vf_affiliation(instance, 0)))
>+			    (instance->requestorId &&
>+megasas_get_ld_vf_affiliation(instance, 0))) {
> 				dcmd_ret = megasas_ld_list_query(instance,
>MR_LD_QUERY_TYPE_EXPOSED_TO_HOST);
>+				if (dcmd_ret == DCMD_FAILED)
>+					dcmd_ret =
>megasas_get_ld_list(instance);
>+			}
>
> 			if (dcmd_ret != DCMD_SUCCESS)
> 				break;
>--
>1.8.5.6
