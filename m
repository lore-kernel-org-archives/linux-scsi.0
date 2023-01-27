Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B6FC38142
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 13:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbjA0NAq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 08:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjA0NAp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 08:00:45 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8689CBB84;
        Fri, 27 Jan 2023 05:00:44 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 44CBA1FF59;
        Fri, 27 Jan 2023 13:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674824443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ME628VQG1ftYrq0V4Zr+oJ33XRrdiNp0Y5GKNohMKLY=;
        b=wQWBnS5gW1rb/gfJCWMFT1dQ0YA10heQl0RKaTMKM1S2hNuuzMqHCC1DJMCMctkss8Ld0j
        GWC5tpaiPApzkmT23MjIPn1pH3eCFpfYrQaIzQI1AViFsESsf6IsEXZN/tWeA7AocQ5ED2
        1PdQ6eShRSOA4PUkQuZVsa1+lpgDZxY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674824443;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ME628VQG1ftYrq0V4Zr+oJ33XRrdiNp0Y5GKNohMKLY=;
        b=7CF10NdQ2SlmGKVSATXD3iCpnC211w7c2yNg3zJI+Fn9mSCJycqm07+VHv4KQHt00AlCs+
        TtEJ1m45sqhmcnBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 34D171336F;
        Fri, 27 Jan 2023 13:00:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vTueDPvK02NfEwAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 Jan 2023 13:00:43 +0000
Message-ID: <f0793325-3022-e7b8-672d-00f2f9ee0cd9@suse.de>
Date:   Fri, 27 Jan 2023 14:00:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 07/18] scsi: sd: detect support for command duration
 limits
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-8-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230124190308.127318-8-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 20:02, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Detect if a disk supports command duration limits. Support for
> the READ 16, WRITE 16, READ 32 and WRITE 32 commands is tested using
> the function scsi_report_opcode(). For a disk supporting command
> duration limits, the mode page indicating the command duration limits
> descriptors that apply to the command is indicated using the rwcdlp
> and cdlp bits.
> 
> Support duration limits is advertizes through sysfs using the new
> "duration_limits" sysfs sub-directory of the generic device directory,
> that is, /sys/block/sdX/device/duration_limits. Within this new
> directory, the limit descriptors that apply to read and write operations
> are exposed within the read and write directories, with descriptor
> attributes grouped together in directories. The overall sysfs structure
> created is:
> 
> /sys/block/sde/device/duration_limits/
> ├── perf_vs_duration_guideline
> ├── read
> │   ├── 1
> │   │   ├── duration_guideline
> │   │   ├── duration_guideline_policy
> │   │   ├── max_active_time
> │   │   ├── max_active_time_policy
> │   │   ├── max_inactive_time
> │   │   └── max_inactive_time_policy
> │   ├── 2
> │   │   ├── duration_guideline
> ...
> │   └── page
> └── write
>      ├── 1
>      │   ├── duration_guideline
>      │   ├── duration_guideline_policy
> ...
> 
> For each of the read and write descriptor directories, the page
> attribute file indicate the command duration limit page providing the
> descriptors. The possible values for the page attribute are "A", "B",
> "T2A" and "T2B".
> 
> The new "duration_limits" attributes directory is added only for disks
> that supports command duration limits.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/scsi/Makefile |   2 +-
>   drivers/scsi/sd.c     |   2 +
>   drivers/scsi/sd.h     |  61 ++++
>   drivers/scsi/sd_cdl.c | 764 ++++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 828 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/scsi/sd_cdl.c
> 
I'm not particularly happy with having sysfs reflect user settings, but 
every other place I can think of is even more convoluted.
So there.

> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index f055bfd54a68..0e48cb6d21d6 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -170,7 +170,7 @@ scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
>   
>   hv_storvsc-y			:= storvsc_drv.o
>   
> -sd_mod-objs	:= sd.o
> +sd_mod-objs	:= sd.o sd_cdl.o
>   sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o
>   sd_mod-$(CONFIG_BLK_DEV_ZONED) += sd_zbc.o
>   
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 45945bfeee92..7879a5470773 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3326,6 +3326,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>   		sd_read_write_same(sdkp, buffer);
>   		sd_read_security(sdkp, buffer);
>   		sd_config_protection(sdkp);
> +		sd_read_cdl(sdkp, buffer);
>   	}
>   
>   	/*
> @@ -3646,6 +3647,7 @@ static void scsi_disk_release(struct device *dev)
>   
>   	ida_free(&sd_index_ida, sdkp->index);
>   	sd_zbc_free_zone_info(sdkp);
> +	sd_cdl_release(sdkp);
>   	put_device(&sdkp->device->sdev_gendev);
>   	free_opal_dev(sdkp->opal_dev);
>   
Hmm. Calling this during revalidate() makes sense, but how can we ensure 
that we call revalidate() when the user issues a MODE_SELECT command?

Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
