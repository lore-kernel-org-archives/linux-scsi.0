Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13823C43381
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED36B23437
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbhAGQpn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:45:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:35894 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728210AbhAGQpm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 11:45:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610037896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/5UPG57ATXVObABDYpKUm3bQ4VVw46AtMURmEl9POc=;
        b=dUe/7Q76oo3q/xOT9PNdPQAJyFy49De4fk2m1mtQonAJOJ08ZJ2hsM0MXZPzwp3ejt30V3
        RRIu591xIB2TZ4Nat++YnzET7A33qZKbdDdmpfpKiTDhDxYv5RY1OQTpA08MlyvFUSqFDn
        UQBl/GR5u4/O64ABvCgFOATj3WKz1P8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E6B4EAD5C;
        Thu,  7 Jan 2021 16:44:55 +0000 (UTC)
Message-ID: <d084a9fc0757a0f15e860dafe8179679ab620a5e.camel@suse.com>
Subject: Re: [PATCH V3 07/25] smartpqi: update AIO Sub Page 0x02 support
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Thu, 07 Jan 2021 17:44:55 +0100
In-Reply-To: <160763250110.26927.1557519699967861731.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763250110.26927.1557519699967861731.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 14:35 -0600, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> The specification for AIO Sub-Page (0x02) has changed slightly.
> * bring the driver into conformance with the spec.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>  drivers/scsi/smartpqi/smartpqi.h      |   12 ++++---
>  drivers/scsi/smartpqi/smartpqi_init.c |   60 +++++++++++++++++++++--
> ----------
>  2 files changed, 47 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h
> b/drivers/scsi/smartpqi/smartpqi.h
> index 31281cddadfe..eb23c3cf59c0 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -1028,13 +1028,13 @@ struct pqi_scsi_dev_raid_map_data {
>         u8      cdb_length;
>  
>         /* RAID 1 specific */
> -#define NUM_RAID1_MAP_ENTRIES 3
> +#define NUM_RAID1_MAP_ENTRIES  3
>         u32     num_it_nexus_entries;
>         u32     it_nexus[NUM_RAID1_MAP_ENTRIES];
>  
>         /* RAID 5 / RAID 6 specific */
> -       u32     p_parity_it_nexus; /* aio_handle */
> -       u32     q_parity_it_nexus; /* aio_handle */
> +       u32     p_parity_it_nexus;      /* aio_handle */
> +       u32     q_parity_it_nexus;      /* aio_handle */
>         u8      xor_mult;
>         u64     row;
>         u64     stripe_lba;
> @@ -1044,6 +1044,7 @@ struct pqi_scsi_dev_raid_map_data {
>  
>  #define RAID_CTLR_LUNID                "\0\0\0\0\0\0\0\0"
>  
> +
>  struct pqi_scsi_dev {
>         int     devtype;                /* as reported by INQUIRY
> commmand */
>         u8      device_type;            /* as reported by */
> @@ -1302,7 +1303,8 @@ struct pqi_ctrl_info {
>         u32             max_transfer_encrypted_sas_sata;
>         u32             max_transfer_encrypted_nvme;
>         u32             max_write_raid_5_6;
> -
> +       u32             max_write_raid_1_10_2drive;
> +       u32             max_write_raid_1_10_3drive;
>  
>         struct list_head scsi_device_list;
>         spinlock_t      scsi_device_list_lock;
> @@ -1533,6 +1535,8 @@ struct bmic_sense_feature_io_page_aio_subpage {
>         __le16  max_transfer_encrypted_sas_sata;
>         __le16  max_transfer_encrypted_nvme;
>         __le16  max_write_raid_5_6;
> +       __le16  max_write_raid_1_10_2drive;
> +       __le16  max_write_raid_1_10_3drive;
>  };
>  
>  struct bmic_smp_request {
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index aa21c1cd2cac..419887aa8ff3 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -696,6 +696,19 @@ static int pqi_identify_physical_device(struct
> pqi_ctrl_info *ctrl_info,
>         return rc;
>  }
>  
> +static inline u32 pqi_aio_limit_to_bytes(__le16 *limit)
> +{
> +       u32 bytes;
> +
> +       bytes = get_unaligned_le16(limit);
> +       if (bytes == 0)
> +               bytes = ~0;
> +       else
> +               bytes *= 1024;
> +
> +       return bytes;
> +}

Nice, but this function and it's callers belong into patch 06/25.


> +
>  #pragma pack(1)
>  
>  struct bmic_sense_feature_buffer {
> @@ -707,11 +720,11 @@ struct bmic_sense_feature_buffer {
>  
>  #define MINIMUM_AIO_SUBPAGE_BUFFER_LENGTH      \
>         offsetofend(struct bmic_sense_feature_buffer, \
> -               aio_subpage.max_write_raid_5_6)
> +               aio_subpage.max_write_raid_1_10_3drive)
>  
>  #define MINIMUM_AIO_SUBPAGE_LENGTH     \
>         (offsetofend(struct bmic_sense_feature_io_page_aio_subpage, \
> -               max_write_raid_5_6) - \
> +               max_write_raid_1_10_3drive) - \
>                 sizeof_field(struct
> bmic_sense_feature_io_page_aio_subpage, header))
>  
>  static int pqi_get_advanced_raid_bypass_config(struct pqi_ctrl_info
> *ctrl_info)
> @@ -753,33 +766,28 @@ static int
> pqi_get_advanced_raid_bypass_config(struct pqi_ctrl_info *ctrl_info)
>                         BMIC_SENSE_FEATURE_IO_PAGE_AIO_SUBPAGE ||
>                 get_unaligned_le16(&buffer-
> >aio_subpage.header.page_length) <
>                         MINIMUM_AIO_SUBPAGE_LENGTH) {
> -               rc = -EINVAL;

This should be changed in 06/25.

>                 goto error;
>         }
>  

Regards
Martin



