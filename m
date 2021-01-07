Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D287BC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B63323403
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbhAGQp7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:45:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:36094 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbhAGQp6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 11:45:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610037912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MHq++/KDTZ0akAwOJlLLcyYlrTXGYOgI/TzwbHUI9dA=;
        b=ebIGn2/YLZuSrAf8tsmjzHRJZ9vvIxsQUav7eCqtpe9GTLO9q0VTF92UsV2n/d5U955s0A
        gSyi5MwneWvsO2pXoGqb6v5m1AW5QApKkCC0vnzLz2vqkjuznduO7SX2fpraQMrrrzvHZg
        AmekgoHGFCg7gR9lY15XknSzO2Ku/pU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 14989B77D;
        Thu,  7 Jan 2021 16:45:12 +0000 (UTC)
Message-ID: <e83150ef31a885a3374e287a2a7fc31967c757bc.camel@suse.com>
Subject: Re: [PATCH V3 08/25] smartpqi: add support for long firmware version
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Thu, 07 Jan 2021 17:45:11 +0100
In-Reply-To: <160763250690.26927.15055129460333690813.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763250690.26927.15055129460333690813.stgit@brunhilda>
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
> * Add support for new "long" firmware version which requires
>   minor driver changes to expose.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>  drivers/scsi/smartpqi/smartpqi.h      |   14 ++++++++---
>  drivers/scsi/smartpqi/smartpqi_init.c |   42
> ++++++++++++++++++++++++---------
>  2 files changed, 40 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h
> b/drivers/scsi/smartpqi/smartpqi.h
> index eb23c3cf59c0..f33244def944 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -1227,7 +1227,7 @@ struct pqi_event {
>  struct pqi_ctrl_info {
>         unsigned int    ctrl_id;
>         struct pci_dev  *pci_dev;
> -       char            firmware_version[11];
> +       char            firmware_version[32];
>         char            serial_number[17];
>         char            model[17];
>         char            vendor[9];
> @@ -1405,7 +1405,7 @@ enum pqi_ctrl_mode {
>  struct bmic_identify_controller {
>         u8      configured_logical_drive_count;
>         __le32  configuration_signature;
> -       u8      firmware_version[4];
> +       u8      firmware_version_short[4];
>         u8      reserved[145];
>         __le16  extended_logical_unit_count;
>         u8      reserved1[34];
> @@ -1413,11 +1413,17 @@ struct bmic_identify_controller {
>         u8      reserved2[8];
>         u8      vendor_id[8];
>         u8      product_id[16];
> -       u8      reserved3[68];
> +       u8      reserved3[62];
> +       __le32  extra_controller_flags;
> +       u8      reserved4[2];
>         u8      controller_mode;
> -       u8      reserved4[32];
> +       u8      spare_part_number[32];
> +       u8      firmware_version_long[32];
>  };
>  
> +/* constants for extra_controller_flags field of
> bmic_identify_controller */
> +#define
> BMIC_IDENTIFY_EXTRA_FLAGS_LONG_FW_VERSION_SUPPORTED    0x20000000
> +
>  struct bmic_sense_subsystem_info {
>         u8      reserved[44];
>         u8      ctrl_serial_number[16];
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index 419887aa8ff3..aa8b559e8907 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -998,14 +998,12 @@ static void pqi_update_time_worker(struct
> work_struct *work)
>                 PQI_UPDATE_TIME_WORK_INTERVAL);
>  }
>  
> -static inline void pqi_schedule_update_time_worker(
> -       struct pqi_ctrl_info *ctrl_info)
> +static inline void pqi_schedule_update_time_worker(struct
> pqi_ctrl_info *ctrl_info)
>  {
>         schedule_delayed_work(&ctrl_info->update_time_work, 0);
>  }
>  
> -static inline void pqi_cancel_update_time_worker(
> -       struct pqi_ctrl_info *ctrl_info)
> +static inline void pqi_cancel_update_time_worker(struct
> pqi_ctrl_info *ctrl_info)
>  {
>         cancel_delayed_work_sync(&ctrl_info->update_time_work);
>  }
> @@ -7245,13 +7243,23 @@ static int
> pqi_get_ctrl_product_details(struct pqi_ctrl_info *ctrl_info)
>         if (rc)
>                 goto out;
>  
> -       memcpy(ctrl_info->firmware_version, identify-
> > firmware_version,
> -               sizeof(identify->firmware_version));
> -       ctrl_info->firmware_version[sizeof(identify-
> > firmware_version)] = '\0';
> -       snprintf(ctrl_info->firmware_version +
> -               strlen(ctrl_info->firmware_version),
> -               sizeof(ctrl_info->firmware_version),
> -               "-%u", get_unaligned_le16(&identify-
> > firmware_build_number));
> +       if (get_unaligned_le32(&identify->extra_controller_flags) &
> +               BMIC_IDENTIFY_EXTRA_FLAGS_LONG_FW_VERSION_SUPPORTED)
> {
> +               memcpy(ctrl_info->firmware_version,
> +                       identify->firmware_version_long,
> +                       sizeof(identify->firmware_version_long));
> +       } else {
> +               memcpy(ctrl_info->firmware_version,
> +                       identify->firmware_version_short,
> +                       sizeof(identify->firmware_version_short));
> +               ctrl_info->firmware_version
> +                       [sizeof(identify->firmware_version_short)] =
> '\0';
> +               snprintf(ctrl_info->firmware_version +
> +                       strlen(ctrl_info->firmware_version),
> +                       sizeof(ctrl_info->firmware_version),

This looks wrong. I suppose a real overflow can't happen, but shouldn't
it rather be written like this?

snprintf(ctrl_info->firmware_version + 
 sizeof(identify->firmware_version_short),
 sizeof(ctrl_info->firmware_version) 
 - sizeof(identify->firmware_version_short), 
 "-u", ...)

> +                       "-%u",
> +                       get_unaligned_le16(&identify-
> > firmware_build_number));
> +       }
>  
>         memcpy(ctrl_info->model, identify->product_id,
>                 sizeof(identify->product_id));
> @@ -9607,13 +9615,23 @@ static void __attribute__((unused))
> verify_structures(void)
>         BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
>                 configuration_signature) != 1);
>         BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
> -               firmware_version) != 5);
> +               firmware_version_short) != 5);
>         BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
>                 extended_logical_unit_count) != 154);
>         BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
>                 firmware_build_number) != 190);
> +       BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
> +               vendor_id) != 200);
> +       BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
> +               product_id) != 208);
> +       BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
> +               extra_controller_flags) != 286);
>         BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
>                 controller_mode) != 292);
> +       BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
> +               spare_part_number) != 293);
> +       BUILD_BUG_ON(offsetof(struct bmic_identify_controller,
> +               firmware_version_long) != 325);
>  
>         BUILD_BUG_ON(offsetof(struct bmic_identify_physical_device,
>                 phys_bay_in_box) != 115);
> 



