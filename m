From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid_sas: clean function declarations in
 megaraid_sas_base.c up
Date: Mon, 19 Sep 2016 19:20:44 +0530
Message-ID: <eb5f597c4bfdc507ce74d43a6ecf6f17@mail.gmail.com>
References: <1474200479-32042-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35219 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758069AbcISNuq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 09:50:46 -0400
Received: by mail-oi0-f46.google.com with SMTP id w11so196605453oia.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2016 06:50:46 -0700 (PDT)
In-Reply-To: <1474200479-32042-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn

>-----Original Message-----
>From: Baoyou Xie [mailto:baoyou.xie@linaro.org]
>Sent: Sunday, September 18, 2016 5:38 PM
>To: kashyap.desai@avagotech.com; sumit.saxena@avagotech.com;
>uday.lingala@avagotech.com; jejb@linux.vnet.ibm.com;
>martin.petersen@oracle.com
>Cc: megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org; linux-
>kernel@vger.kernel.org; arnd@arndb.de; baoyou.xie@linaro.org;
>xie.baoyou@zte.com.cn
>Subject: [PATCH] megaraid_sas: clean function declarations in
>megaraid_sas_base.c up
>
>We get a few warnings when building kernel with W=1:
>drivers/scsi/megaraid/megaraid_sas_fusion.c:281:1: warning: no previous
>prototype for 'megasas_free_cmds_fusion' [-Wmissing-prototypes]
>drivers/scsi/megaraid/megaraid_sas_fusion.c:714:1: warning: no previous
>prototype for 'megasas_ioc_init_fusion' [-Wmissing-prototypes] ....
>
>In fact, these functions are declared in
>drivers/scsi/megaraid/megaraid_sas_base.c, but should be declared in a
header
>file, thus can be recognized in other file.
>
>So this patch adds the declarations into
>drivers/scsi/megaraid/megaraid_sas_fusion.h.
>
>Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c   | 13 -------------
> drivers/scsi/megaraid/megaraid_sas_fusion.h |  9 +++++++++
> 2 files changed, 9 insertions(+), 13 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 2d62d71..b73b6f3 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -189,25 +189,12 @@ u32
> megasas_build_and_issue_cmd(struct megasas_instance *instance,
> 			    struct scsi_cmnd *scmd);
> static void megasas_complete_cmd_dpc(unsigned long instance_addr); -void
-
>megasas_release_fusion(struct megasas_instance *instance); -int -
>megasas_ioc_init_fusion(struct megasas_instance *instance); -void -
>megasas_free_cmds_fusion(struct megasas_instance *instance);
>-u8
>-megasas_get_map_info(struct megasas_instance *instance); -int -
>megasas_sync_map_info(struct megasas_instance *instance);  int
>wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
> 	int seconds);
>-void megasas_reset_reply_desc(struct megasas_instance *instance);  void
>megasas_fusion_ocr_wq(struct work_struct *work);  static int
>megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
> 					 int initial);
>-int megasas_check_mpio_paths(struct megasas_instance *instance,
>-			     struct scsi_cmnd *scmd);
>
> int
> megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd
>*cmd) diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>index 80eaee2..3fe730a 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>@@ -991,5 +991,14 @@ union desc_value {
> 	} u;
> };
>
>+void megasas_free_cmds_fusion(struct megasas_instance *instance); int
>+megasas_ioc_init_fusion(struct megasas_instance *instance);
>+u8 megasas_get_map_info(struct megasas_instance *instance); int
>+megasas_sync_map_info(struct megasas_instance *instance); void
>+megasas_release_fusion(struct megasas_instance *instance); void
>+megasas_reset_reply_desc(struct megasas_instance *instance); int
>+megasas_check_mpio_paths(struct megasas_instance *instance,
>+			      struct scsi_cmnd *scmd);
>+void megasas_fusion_ocr_wq(struct work_struct *work);
>
> #endif /* _MEGARAID_SAS_FUSION_H_ */
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

>--
>2.7.4
