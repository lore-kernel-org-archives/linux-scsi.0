Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918C4C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A722236F9
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbhAHAOw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 19:14:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:59226 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727300AbhAHAOw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 19:14:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610064845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hu4rSXkvZ1sXcugdUlNC0iqpiJTDdy9XPlTgIh8vy/8=;
        b=cNtgYIjZFTNqzGTGWnO6lV3d6Ohe83Ru+oYJBLXL+s0I0C5/UAmf8zgfZ1qaaQmUs7Fe3t
        VX5MGXhRU4m+bWr6TDXA/PR3p/XCJ5ZO2epCH2HJY5imVbW8jwMrpY2M9kOwnw7oXjfwzc
        IFHOg9vot88b91/+5lMD6boA5DbvSPc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A99D5B77D;
        Fri,  8 Jan 2021 00:14:05 +0000 (UTC)
Message-ID: <8912abe0d7b0b39bfe2efff16db58ec888a8d6d6.camel@suse.com>
Subject: Re: [PATCH V3 10/25] smartpqi: add stream detection
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 08 Jan 2021 01:14:04 +0100
In-Reply-To: <160763251860.26927.14463337801880165741.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763251860.26927.14463337801880165741.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 14:35 -0600, Don Brace wrote:
> * Enhance performance by adding sequential stream detection.
>   for R5/R6 sequential write requests.
>   * Reduce stripe lock contention with full-stripe write
>     operations.

I suppose that "stripe lock" is used by the firmware? Could you
elaborate a bit more how this technique improves performance?

> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>  drivers/scsi/smartpqi/smartpqi.h      |    8 +++
>  drivers/scsi/smartpqi/smartpqi_init.c |   87
> +++++++++++++++++++++++++++++++--
>  2 files changed, 89 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h
> b/drivers/scsi/smartpqi/smartpqi.h
> index a5e271dd2742..343f06e44220 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -1042,6 +1042,12 @@ struct pqi_scsi_dev_raid_map_data {
>  
>  #define RAID_CTLR_LUNID                "\0\0\0\0\0\0\0\0"
>  
> +#define NUM_STREAMS_PER_LUN    8
> +
> +struct pqi_stream_data {
> +       u64     next_lba;
> +       u32     last_accessed;
> +};
>  
>  struct pqi_scsi_dev {
>         int     devtype;                /* as reported by INQUIRY
> commmand */
> @@ -1097,6 +1103,7 @@ struct pqi_scsi_dev {
>         struct list_head add_list_entry;
>         struct list_head delete_list_entry;
>  
> +       struct pqi_stream_data stream_data[NUM_STREAMS_PER_LUN];
>         atomic_t scsi_cmds_outstanding;
>         atomic_t raid_bypass_cnt;
>  };
> @@ -1296,6 +1303,7 @@ struct pqi_ctrl_info {
>         u8              enable_r5_writes : 1;
>         u8              enable_r6_writes : 1;
>         u8              lv_drive_type_mix_valid : 1;
> +       u8              enable_stream_detection : 1;
>  
>         u8              ciss_report_log_flags;
>         u32             max_transfer_encrypted_sas_sata;
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index fc8fafab480d..96383d047a88 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -5721,8 +5721,82 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd
> *scmd)
>         atomic_dec(&device->scsi_cmds_outstanding);
>  }
>  
> -static int pqi_scsi_queue_command(struct Scsi_Host *shost,
> +static bool pqi_is_parity_write_stream(struct pqi_ctrl_info
> *ctrl_info,
>         struct scsi_cmnd *scmd)
> +{
> +       u32 oldest_jiffies;
> +       u8 lru_index;
> +       int i;
> +       int rc;
> +       struct pqi_scsi_dev *device;
> +       struct pqi_stream_data *pqi_stream_data;
> +       struct pqi_scsi_dev_raid_map_data rmd;
> +
> +       if (!ctrl_info->enable_stream_detection)
> +               return false;
> +
> +       rc = pqi_get_aio_lba_and_block_count(scmd, &rmd);
> +       if (rc)
> +               return false;
> +
> +       /* Check writes only. */
> +       if (!rmd.is_write)
> +               return false;
> +
> +       device = scmd->device->hostdata;
> +
> +       /* Check for RAID 5/6 streams. */
> +       if (device->raid_level != SA_RAID_5 && device->raid_level !=
> SA_RAID_6)
> +               return false;
> +
> +       /*
> +        * If controller does not support AIO RAID{5,6} writes, need
> to send
> +        * requests down non-AIO path.
> +        */
> +       if ((device->raid_level == SA_RAID_5 && !ctrl_info-
> >enable_r5_writes) ||
> +               (device->raid_level == SA_RAID_6 && !ctrl_info-
> >enable_r6_writes))
> +               return true;
> +
> +       lru_index = 0;
> +       oldest_jiffies = INT_MAX;
> +       for (i = 0; i < NUM_STREAMS_PER_LUN; i++) {
> +               pqi_stream_data = &device->stream_data[i];
> +               /*
> +                * Check for adjacent request or request is within
> +                * the previous request.
> +                */
> +               if ((pqi_stream_data->next_lba &&
> +                       rmd.first_block >= pqi_stream_data->next_lba)
> &&
> +                       rmd.first_block <= pqi_stream_data->next_lba
> +
> +                               rmd.block_cnt) {

Here you seem to assume that the previous write had the same block_cnt.
What's the justification for that?

> +                       pqi_stream_data->next_lba = rmd.first_block +
> +                               rmd.block_cnt;
> +                       pqi_stream_data->last_accessed = jiffies;
> +                       return true;
> +               }
> +
> +               /* unused entry */
> +               if (pqi_stream_data->last_accessed == 0) {
> +                       lru_index = i;
> +                       break;
> +               }
> +
> +               /* Find entry with oldest last accessed time. */
> +               if (pqi_stream_data->last_accessed <= oldest_jiffies)
> {
> +                       oldest_jiffies = pqi_stream_data-
> >last_accessed;
> +                       lru_index = i;
> +               }
> +       }
> +
> +       /* Set LRU entry. */
> +       pqi_stream_data = &device->stream_data[lru_index];
> +       pqi_stream_data->last_accessed = jiffies;
> +       pqi_stream_data->next_lba = rmd.first_block + rmd.block_cnt;
> +
> +       return false;
> +}
> +
> +static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct
> scsi_cmnd *scmd)
>  {
>         int rc;
>         struct pqi_ctrl_info *ctrl_info;
> @@ -5768,11 +5842,12 @@ static int pqi_scsi_queue_command(struct
> Scsi_Host *shost,
>                 raid_bypassed = false;
>                 if (device->raid_bypass_enabled &&
>                         !blk_rq_is_passthrough(scmd->request)) {
> -                       rc =
> pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device,
> -                               scmd, queue_group);
> -                       if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY)
> {
> -                               raid_bypassed = true;
> -                               atomic_inc(&device->raid_bypass_cnt);
> +                       if (!pqi_is_parity_write_stream(ctrl_info,
> scmd)) {
> +                               rc =
> pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device, scmd,
> queue_group);
> +                               if (rc == 0 || rc ==
> SCSI_MLQUEUE_HOST_BUSY) {
> +                                       raid_bypassed = true;
> +                                       atomic_inc(&device-
> >raid_bypass_cnt);
> +                               }
>                         }
>                 }
>                 if (!raid_bypassed)
> 



