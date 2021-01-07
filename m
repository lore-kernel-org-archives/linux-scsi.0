Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14175C4332B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7C8423403
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbhAGQpf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:45:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:35720 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbhAGQpd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 11:45:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610037886; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+N7dNJ28+5fxqjannanAydtumEMocmboiRTbVhBuA4k=;
        b=ZGRWtfpGpkMfNN5YIuoRN/DrZdq6j00kCtgk49PzEEUmEGiEsR0vAOfKbtV7/ho2fnKn4o
        rXuxcELTw9r7gGcAi1yhLwyPL4Iugvk6rku4l021+nZ4L+VkYnBqLs2Hm8Zl17f1mcxoK2
        VIMsVlKFLAKJ+vP6wR2tZ3ak8yVz1LU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2AAAB765;
        Thu,  7 Jan 2021 16:44:45 +0000 (UTC)
Message-ID: <688b16a6318e11967d6032b94248db5f66b6503b.camel@suse.com>
Subject: Re: [PATCH V3 06/25] smartpqi: add support for BMIC sense feature
 cmd and feature bits
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Thu, 07 Jan 2021 17:44:45 +0100
In-Reply-To: <160763249519.26927.10907963332068924699.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763249519.26927.10907963332068924699.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 14:34 -0600, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> * Determine support for supported features from
>   BMIC sense feature command instead of config table.
> 
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>  drivers/scsi/smartpqi/smartpqi.h      |   77 +++++++-
>  drivers/scsi/smartpqi/smartpqi_init.c |  328
> +++++++++++++++++++++++++++++----
>  2 files changed, 363 insertions(+), 42 deletions(-)
> 

In general: This patch contains a lot of whitespace, indentation, and
minor comment formatting changes which should rather go into a separate
patch IMHO. This one is big enough without them.

Further remarks below.

> [...]
> 
> @@ -2552,7 +2686,7 @@ static int
> pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
>         u32 next_bypass_group;
>         struct pqi_encryption_info *encryption_info_ptr;
>         struct pqi_encryption_info encryption_info;
> -       struct pqi_scsi_dev_raid_map_data rmd = {0};
> +       struct pqi_scsi_dev_raid_map_data rmd = { 0 };
>  
>         rc = pqi_get_aio_lba_and_block_count(scmd, &rmd);
>         if (rc)
> @@ -2613,7 +2747,9 @@ static int
> pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
>         pqi_set_aio_cdb(&rmd);
>  
>         if (get_unaligned_le16(&raid_map->flags) &
> -               RAID_MAP_ENCRYPTION_ENABLED) {
> +                       RAID_MAP_ENCRYPTION_ENABLED) {
> +               if (rmd.data_length > device->max_transfer_encrypted)
> +                       return PQI_RAID_BYPASS_INELIGIBLE;
>                 pqi_set_encryption_info(&encryption_info, raid_map,
>                         rmd.first_block);
>                 encryption_info_ptr = &encryption_info;
> @@ -2623,10 +2759,6 @@ static int
> pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
>  

This hunk is fine, but AFAICS it doesn't belong here logically, it
should rather be part of patch 04 and 05.

>         if (rmd.is_write) {
>                 switch (device->raid_level) {
> -               case SA_RAID_0:
> -                       return pqi_aio_submit_io(ctrl_info, scmd,
> rmd.aio_handle,
> -                               rmd.cdb, rmd.cdb_length, queue_group,
> -                               encryption_info_ptr, true);
>                 case SA_RAID_1:
>                 case SA_RAID_ADM:
>                         return pqi_aio_submit_r1_write_io(ctrl_info,
> scmd, queue_group,
> @@ -2635,17 +2767,12 @@ static int
> pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
>                 case SA_RAID_6:
>                         return pqi_aio_submit_r56_write_io(ctrl_info,
> scmd, queue_group,
>                                         encryption_info_ptr, device,
> &rmd);
> -               default:
> -                       return pqi_aio_submit_io(ctrl_info, scmd,
> rmd.aio_handle,
> -                               rmd.cdb, rmd.cdb_length, queue_group,
> -                               encryption_info_ptr, true);
>                 }
> -       } else {
> -               return pqi_aio_submit_io(ctrl_info, scmd,
> rmd.aio_handle,
> -                       rmd.cdb, rmd.cdb_length, queue_group,
> -                       encryption_info_ptr, true);
>         }
>  
> +       return pqi_aio_submit_io(ctrl_info, scmd, rmd.aio_handle,
> +               rmd.cdb, rmd.cdb_length, queue_group,
> +               encryption_info_ptr, true);
>  }
>  
>  #define PQI_STATUS_IDLE                0x0
> @@ -7209,6 +7336,7 @@ static int pqi_enable_firmware_features(struct
> pqi_ctrl_info *ctrl_info,
>  {
>         void *features_requested;
>         void __iomem *features_requested_iomem_addr;
> +       void __iomem *host_max_known_feature_iomem_addr;
>  
>         features_requested = firmware_features->features_supported +
>                 le16_to_cpu(firmware_features->num_elements);
> @@ -7219,6 +7347,16 @@ static int pqi_enable_firmware_features(struct
> pqi_ctrl_info *ctrl_info,
>         memcpy_toio(features_requested_iomem_addr,
> features_requested,
>                 le16_to_cpu(firmware_features->num_elements));
>  
> +       if (pqi_is_firmware_feature_supported(firmware_features,
> +               PQI_FIRMWARE_FEATURE_MAX_KNOWN_FEATURE)) {
> +               host_max_known_feature_iomem_addr =
> +                       features_requested_iomem_addr +
> +                       (le16_to_cpu(firmware_features->num_elements)
> * 2) +
> +                       sizeof(__le16);
> +               writew(PQI_FIRMWARE_FEATURE_MAXIMUM,
> +                       host_max_known_feature_iomem_addr);
> +       }
> +
>         return pqi_config_table_update(ctrl_info,
>                 PQI_CONFIG_TABLE_SECTION_FIRMWARE_FEATURES,
>                 PQI_CONFIG_TABLE_SECTION_FIRMWARE_FEATURES);
> @@ -7256,6 +7394,15 @@ static void
> pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
>         struct pqi_firmware_feature *firmware_feature)
>  {
>         switch (firmware_feature->feature_bit) {
> +       case PQI_FIRMWARE_FEATURE_RAID_1_WRITE_BYPASS:
> +               ctrl_info->enable_r1_writes = firmware_feature-
> >enabled;
> +               break;
> +       case PQI_FIRMWARE_FEATURE_RAID_5_WRITE_BYPASS:
> +               ctrl_info->enable_r5_writes = firmware_feature-
> >enabled;
> +               break;
> +       case PQI_FIRMWARE_FEATURE_RAID_6_WRITE_BYPASS:
> +               ctrl_info->enable_r6_writes = firmware_feature-
> >enabled;
> +               break;
>         case PQI_FIRMWARE_FEATURE_SOFT_RESET_HANDSHAKE:
>                 ctrl_info->soft_reset_handshake_supported =
>                         firmware_feature->enabled;
> @@ -7293,6 +7440,51 @@ static struct pqi_firmware_feature
> pqi_firmware_features[] = {
>                 .feature_bit = PQI_FIRMWARE_FEATURE_SMP,
>                 .feature_status = pqi_firmware_feature_status,
>         },
> +       {
> +               .feature_name = "Maximum Known Feature",
> +               .feature_bit =
> PQI_FIRMWARE_FEATURE_MAX_KNOWN_FEATURE,
> +               .feature_status = pqi_firmware_feature_status,
> +       },
> +       {
> +               .feature_name = "RAID 0 Read Bypass",
> +               .feature_bit =
> PQI_FIRMWARE_FEATURE_RAID_0_READ_BYPASS,
> +               .feature_status = pqi_firmware_feature_status,
> +       },
> +       {
> +               .feature_name = "RAID 1 Read Bypass",
> +               .feature_bit =
> PQI_FIRMWARE_FEATURE_RAID_1_READ_BYPASS,
> +               .feature_status = pqi_firmware_feature_status,
> +       },
> +       {
> +               .feature_name = "RAID 5 Read Bypass",
> +               .feature_bit =
> PQI_FIRMWARE_FEATURE_RAID_5_READ_BYPASS,
> +               .feature_status = pqi_firmware_feature_status,
> +       },
> +       {
> +               .feature_name = "RAID 6 Read Bypass",
> +               .feature_bit =
> PQI_FIRMWARE_FEATURE_RAID_6_READ_BYPASS,
> +               .feature_status = pqi_firmware_feature_status,
> +       },
> +       {
> +               .feature_name = "RAID 0 Write Bypass",
> +               .feature_bit =
> PQI_FIRMWARE_FEATURE_RAID_0_WRITE_BYPASS,
> +               .feature_status = pqi_firmware_feature_status,
> +       },
> +       {
> +               .feature_name = "RAID 1 Write Bypass",
> +               .feature_bit =
> PQI_FIRMWARE_FEATURE_RAID_1_WRITE_BYPASS,
> +               .feature_status = pqi_ctrl_update_feature_flags,
> +       },
> +       {
> +               .feature_name = "RAID 5 Write Bypass",
> +               .feature_bit =
> PQI_FIRMWARE_FEATURE_RAID_5_WRITE_BYPASS,
> +               .feature_status = pqi_ctrl_update_feature_flags,
> +       },
> +       {
> +               .feature_name = "RAID 6 Write Bypass",
> +               .feature_bit =
> PQI_FIRMWARE_FEATURE_RAID_6_WRITE_BYPASS,
> +               .feature_status = pqi_ctrl_update_feature_flags,
> +       },
>         {
>                 .feature_name = "New Soft Reset Handshake",
>                 .feature_bit =
> PQI_FIRMWARE_FEATURE_SOFT_RESET_HANDSHAKE,
> @@ -7667,6 +7859,17 @@ static int pqi_ctrl_init(struct pqi_ctrl_info
> *ctrl_info)
>  
>         pqi_start_heartbeat_timer(ctrl_info);
>  
> +       if (ctrl_info->enable_r5_writes || ctrl_info-
> >enable_r6_writes) {
> +               rc = pqi_get_advanced_raid_bypass_config(ctrl_info);
> +               if (rc) {
> +                       dev_err(&ctrl_info->pci_dev->dev,
> +                               "error obtaining advanced RAID bypass
> configuration\n");
> +                       return rc;
> +               }
> +               ctrl_info->ciss_report_log_flags |=
> +                       CISS_REPORT_LOG_FLAG_DRIVE_TYPE_MIX;
> +       }
> +
>         rc = pqi_enable_events(ctrl_info);
>         if (rc) {
>                 dev_err(&ctrl_info->pci_dev->dev,
> @@ -7822,6 +8025,17 @@ static int pqi_ctrl_init_resume(struct
> pqi_ctrl_info *ctrl_info)
>  
>         pqi_start_heartbeat_timer(ctrl_info);
>  
> +       if (ctrl_info->enable_r5_writes || ctrl_info-
> >enable_r6_writes) {
> +               rc = pqi_get_advanced_raid_bypass_config(ctrl_info);
> +               if (rc) {
> +                       dev_err(&ctrl_info->pci_dev->dev,
> +                               "error obtaining advanced RAID bypass
> configuration\n");
> +                       return rc;

Do you need to error out here ? Can't you simply unset the
enable_rX_writes feature?


Regards
Martin



