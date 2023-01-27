Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD4D2C61DA4
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 15:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbjA0PaK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 10:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbjA0PaI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 10:30:08 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9281E21959;
        Fri, 27 Jan 2023 07:30:07 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4A6EF2205E;
        Fri, 27 Jan 2023 15:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674833406; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TILPmO6xmFGAFOSuUaexsBJ9guSfp9LwuhV49bX8pZE=;
        b=Yi2CzkYoLTOwjFRxg6JZJWcc8dq7BkrCS7h32qJ0y5p2B7ayj0XB1nlvbvez93U+Xx7rR6
        LXiCyc1Rr1OZ6ag5mmMQjdbB5TPOiXc+fVkQ6gsSuH2HC2APdFa0HlpVJsH1waJPr7V5ft
        c00PXYeiyFWPzmrbGRNQx0MmjlFH15Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674833406;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TILPmO6xmFGAFOSuUaexsBJ9guSfp9LwuhV49bX8pZE=;
        b=lJTNuW6W+fLDMFPBf49YqjtzX6JlRSNhPv545OOihVGZ1F4hr1kS9d/cH2CjmURJB4MpU0
        CpSTJ0qC6CeQmHCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 372A81336F;
        Fri, 27 Jan 2023 15:30:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WpuTC/7t02P6ZgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 Jan 2023 15:30:06 +0000
Message-ID: <e257cab1-7eed-d1d5-4129-f2bedb50953e@suse.de>
Date:   Fri, 27 Jan 2023 16:30:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 08/18] scsi: sd: set read/write commands CDL index
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-9-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230124190308.127318-9-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 20:02, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Introduce the command duration limits helper function
> sd_cdl_cmd_limit() to retrieve and set the DLD bits of the
> READ/WRITE 16 and READ/WRITE 32 commands to indicate to the device
> the command duration limit descriptor to apply to the command.
> 
> When command duration limits are enabled, sd_cdl_cmd_limit() obtains the
> index of the descriptor to apply to the command for requests that have
> the IOPRIO_CLASS_DL priority class with a priority data sepcifying a
> valid descriptor index (1 to 7).
> 
> The read-write sysfs attribute "enable" is introduced to control
> setting the command duration limits indexes. If this attribute is set
> to 0 (default), command duration limits specified by the user are
> ignored. The user must set this attribute to 1 for command duration
> limits to be set. Enabling and disabling the command duration limits
> feature for ATA devices must be done using the ATA feature sub-page of
> the control mode page. The sd_cdl_enable() function is introduced to
> check if this mode page is supported by the device and if it is, use
> it to enable/disable CDL.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/scsi/sd.c     |  16 +++--
>   drivers/scsi/sd.h     |  10 ++++
>   drivers/scsi/sd_cdl.c | 134 +++++++++++++++++++++++++++++++++++++++++-
>   3 files changed, 152 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 7879a5470773..d2eb01337943 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1045,13 +1045,14 @@ static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
>   
>   static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
>   				       sector_t lba, unsigned int nr_blocks,
> -				       unsigned char flags)
> +				       unsigned char flags, unsigned int dld)
>   {
>   	cmd->cmd_len = SD_EXT_CDB_SIZE;
>   	cmd->cmnd[0]  = VARIABLE_LENGTH_CMD;
>   	cmd->cmnd[7]  = 0x18; /* Additional CDB len */
>   	cmd->cmnd[9]  = write ? WRITE_32 : READ_32;
>   	cmd->cmnd[10] = flags;
> +	cmd->cmnd[11] = dld & 0x07;
>   	put_unaligned_be64(lba, &cmd->cmnd[12]);
>   	put_unaligned_be32(lba, &cmd->cmnd[20]); /* Expected Indirect LBA */
>   	put_unaligned_be32(nr_blocks, &cmd->cmnd[28]);
> @@ -1061,12 +1062,12 @@ static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
>   
>   static blk_status_t sd_setup_rw16_cmnd(struct scsi_cmnd *cmd, bool write,
>   				       sector_t lba, unsigned int nr_blocks,
> -				       unsigned char flags)
> +				       unsigned char flags, unsigned int dld)
>   {
>   	cmd->cmd_len  = 16;
>   	cmd->cmnd[0]  = write ? WRITE_16 : READ_16;
> -	cmd->cmnd[1]  = flags;
> -	cmd->cmnd[14] = 0;
> +	cmd->cmnd[1]  = flags | ((dld >> 2) & 0x01);
> +	cmd->cmnd[14] = (dld & 0x03) << 6;
>   	cmd->cmnd[15] = 0;
>   	put_unaligned_be64(lba, &cmd->cmnd[2]);
>   	put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
> @@ -1129,6 +1130,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>   	unsigned int mask = logical_to_sectors(sdp, 1) - 1;
>   	bool write = rq_data_dir(rq) == WRITE;
>   	unsigned char protect, fua;
> +	unsigned int dld = 0;
>   	blk_status_t ret;
>   	unsigned int dif;
>   	bool dix;
> @@ -1178,6 +1180,8 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>   	fua = rq->cmd_flags & REQ_FUA ? 0x8 : 0;
>   	dix = scsi_prot_sg_count(cmd);
>   	dif = scsi_host_dif_capable(cmd->device->host, sdkp->protection_type);
> +	if (sd_cdl_enabled(sdkp))
> +		dld = sd_cdl_dld(sdkp, cmd);
>   
>   	if (dif || dix)
>   		protect = sd_setup_protect_cmnd(cmd, dix, dif);
> @@ -1186,10 +1190,10 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>   
>   	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
>   		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
> -					 protect | fua);
> +					 protect | fua, dld);
>   	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
>   		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
> -					 protect | fua);
> +					 protect | fua, dld);
>   	} else if ((nr_blocks > 0xff) || (lba > 0x1fffff) ||
>   		   sdp->use_10_for_rw || protect) {
>   		ret = sd_setup_rw10_cmnd(cmd, write, lba, nr_blocks,
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index e60d33bd222a..5b6b6dc4b92d 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -130,8 +130,11 @@ struct sd_cdl_page {
>   	struct sd_cdl_desc      descs[SD_CDL_MAX_DESC];
>   };
>   
> +struct scsi_disk;
> +
>   struct sd_cdl {
>   	struct kobject		kobj;
> +	struct scsi_disk	*sdkp;
>   	bool			sysfs_registered;
>   	u8			perf_vs_duration_guideline;
>   	struct sd_cdl_page	pages[SD_CDL_RW];
> @@ -188,6 +191,7 @@ struct scsi_disk {
>   	u8		zeroing_mode;
>   	u8		nr_actuators;		/* Number of actuators */
>   	struct sd_cdl	*cdl;
> +	unsigned	cdl_enabled : 1;
>   	unsigned	ATO : 1;	/* state of disk ATO bit */
>   	unsigned	cache_override : 1; /* temp override of WCE,RCD */
>   	unsigned	WCE : 1;	/* state of disk WCE bit */
> @@ -355,5 +359,11 @@ void sd_print_result(const struct scsi_disk *sdkp, const char *msg, int result);
>   /* Command duration limits support (in sd_cdl.c) */
>   void sd_read_cdl(struct scsi_disk *sdkp, unsigned char *buf);
>   void sd_cdl_release(struct scsi_disk *sdkp);
> +int sd_cdl_dld(struct scsi_disk *sdkp, struct scsi_cmnd *scmd);
> +
> +static inline bool sd_cdl_enabled(struct scsi_disk *sdkp)
> +{
> +	return sdkp->cdl && sdkp->cdl_enabled;
> +}
>   
>   #endif /* _SCSI_DISK_H */
> diff --git a/drivers/scsi/sd_cdl.c b/drivers/scsi/sd_cdl.c
> index 513cd989f19a..59d02dbb5ea1 100644
> --- a/drivers/scsi/sd_cdl.c
> +++ b/drivers/scsi/sd_cdl.c
> @@ -93,6 +93,63 @@ static const char *sd_cdl_policy_name(u8 policy)
>   	}
>   }
>   
> +/*
> + * Enable/disable CDL.
> + */
> +static int sd_cdl_enable(struct scsi_disk *sdkp, bool enable)
> +{
> +	struct scsi_device *sdp = sdkp->device;
> +	struct scsi_mode_data data;
> +	struct scsi_sense_hdr sshdr;
> +	struct scsi_vpd *vpd;
> +	bool is_ata = false;
> +	char buf[64];
> +	int ret;
> +
> +	rcu_read_lock();
> +	vpd = rcu_dereference(sdp->vpd_pg89);
> +	if (vpd)
> +		is_ata = true;
> +	rcu_read_unlock();
> +
> +	/*
> +	 * For ATA devices, CDL needs to be enabled with a SET FEATURES command.
> +	 */
> +	if (is_ata) {
> +		char *buf_data;
> +		int len;
> +
> +		ret = scsi_mode_sense(sdp, 0x08, 0x0a, 0xf2, buf, sizeof(buf),
> +				      SD_TIMEOUT, sdkp->max_retries, &data,
> +				      NULL);
> +		if (ret)
> +			return -EINVAL;
> +
That is a tad odd.
Is CDL always enabled for 'normal' SCSI?

Cheers,

Hannes
