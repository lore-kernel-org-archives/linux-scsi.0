Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C3EECAAA1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 16:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbiJXQak (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Oct 2022 12:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiJXQaF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2022 12:30:05 -0400
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8AC24958
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 08:16:30 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id d26so5659267eje.10
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 08:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pA2DCPwRYA7c1orrXlYkM+PvEg6pon+LSgU2rwJcTX8=;
        b=UXsM4LHBzWdr9uYgU1mnDO3rl9BV1eOWjSwVpT4AwoPoK+rSvZC/2wUMC+7k/xOsfU
         zhtJtrXhusPBT/+TLl9jfXbDXOwR4krvszZSTWW3x9GZ/I8JE1pgfKJIALQwr1Fa3a0C
         mUaEBICn/LtWXfDlw55ZnNpkKWKxIbAFF5Xpxv2IIpli1bjX51aylP88E2PfWpiV3wnx
         AMiOJfVvKesyJWdoPKUcE8UdtNFffjtpHw+tSREWjW/eDK+kJGgC1nebsnX2uDuyimVI
         2mpYAt/y/SzXRKGFTdsaSirf/uHL2e9fo62lAkMql9tehU+PIEnTEFerDB6yD7egZxuz
         0P+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pA2DCPwRYA7c1orrXlYkM+PvEg6pon+LSgU2rwJcTX8=;
        b=AtyAeWCrOJBE1GMEyjgQIWKEWEnzSmgmIQXqfexGNTwvquZl1SKEpXYkANmSLN6Coe
         KEgbN3rtzgoPyoIY4mjgJtmTZQ1Z80wpccRUQNiOoZSOecyXZ5UwkwDABkBWeVls8Hh0
         4d3tDeHVy9WGtRU/SsrZOKdVyQS2kp+dcTfIIYNWT1nEo9g4Mw7vHXDvrGtaPR5pOYma
         xhF99+vjzB4PqglmTu/ZkG5qfirIcvYsJAwZNUTU6FKV7JmW7JdlGtimTZBFNzo7q9uz
         UyP/m15bBK8ObM5TbE6kzyKkSA26kD8hM1kkGFehMnlJh8JSmbp3SMJbxg0z70Kfz2rB
         3tDQ==
X-Gm-Message-State: ACrzQf3t8k256Q130K4z/hRtoo874MflT7C/djjByEcgpaCJp/s/gwUR
        qlE/MkgOQkWHR2MegLNPgow=
X-Google-Smtp-Source: AMsMyM4CJew1uDBRZTvXOS8S3oRgwjKJjSOf0ZD0Q7Or4lQ9PFD6WAxQx+z1eIXUSIMK9v2Y8kDnMw==
X-Received: by 2002:a17:907:2712:b0:78d:a223:729b with SMTP id w18-20020a170907271200b0078da223729bmr28393730ejk.443.1666624139600;
        Mon, 24 Oct 2022 08:08:59 -0700 (PDT)
Received: from [192.168.178.40] (ip5f597b78.dynamic.kabel-deutschland.de. [95.89.123.120])
        by smtp.gmail.com with ESMTPSA id r10-20020a17090609ca00b0079de6b05c99sm4250645eje.138.2022.10.24.08.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 08:08:59 -0700 (PDT)
Message-ID: <a729c641-ccd8-812c-c688-1bf3830432c6@gmail.com>
Date:   Mon, 24 Oct 2022 17:08:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5/5] scsi_debug: change store from vmalloc to sgl
Content-Language: en-US
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
References: <20221024010244.9522-1-dgilbert@interlog.com>
 <20221024010244.9522-6-dgilbert@interlog.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <20221024010244.9522-6-dgilbert@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24.10.22 03:02, Douglas Gilbert wrote:
> A long time ago this driver's store was allocated by kmalloc() or
> alloc_pages(). When this was switched to vmalloc() the author
> noticed slower ramdisk access times and more variability in repeated
> tests. So try going back with sgl_alloc_order() to get uniformly
> sized allocations in a sometimes large scatter gather _array_. That
> array is the basis of maintaining O(1) access to the store.
> 
> Using sgl_alloc_order() and friends requires CONFIG_SGL_ALLOC
> so add a 'select' to the Kconfig file.
> 
> Remove kcalloc() in resp_verify() as sgl_s can now be compared
> directly without forming an intermediate buffer. This is a
> performance win for the SCSI VERIFY command implementation.
> 
> Make the SCSI COMPARE AND WRITE command yield the offset of the
> first miscompared byte when the compare fails (as required by
> T10).
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/Kconfig      |   3 +-
>   drivers/scsi/scsi_debug.c | 478 +++++++++++++++++++++++++++-----------
>   2 files changed, 341 insertions(+), 140 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 03e71e3d5e5b..97edb4e17319 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1229,13 +1229,14 @@ config SCSI_DEBUG
>   	tristate "SCSI debugging host and device simulator"
>   	depends on SCSI
>   	select CRC_T10DIF
> +	select SGL_ALLOC
>   	help
>   	  This pseudo driver simulates one or more hosts (SCSI initiators),
>   	  each with one or more targets, each with one or more logical units.
>   	  Defaults to one of each, creating a small RAM disk device. Many
>   	  parameters found in the /sys/bus/pseudo/drivers/scsi_debug
>   	  directory can be tweaked at run time.
> -	  See <http://sg.danny.cz/sg/sdebug26.html> for more information.
> +	  See <https://sg.danny.cz/sg/scsi_debug.html> for more information.
>   	  Mainly used for testing and best as a module. If unsure, say N.
>   
>   config SCSI_MESH
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 697fc57bc711..0715521b2527 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -221,6 +221,7 @@ static const char *sdebug_version_date = "20210520";
>   #define SDEBUG_CANQUEUE_WORDS  3	/* a WORD is bits in a long */
>   #define SDEBUG_CANQUEUE  (SDEBUG_CANQUEUE_WORDS * BITS_PER_LONG)
>   #define DEF_CMD_PER_LUN  SDEBUG_CANQUEUE
> +#define SDEB_ORDER_TOO_LARGE 4096
>   
>   /* UA - Unit Attention; SA - Service Action; SSU - Start Stop Unit */
>   #define F_D_IN			1	/* Data-in command (e.g. READ) */
> @@ -318,8 +319,11 @@ struct sdebug_host_info {
>   
>   /* There is an xarray of pointers to this struct's objects, one per host */
>   struct sdeb_store_info {
> +	unsigned int n_elem;    /* number of sgl elements */
> +	unsigned int order;	/* as used by alloc_pages() */
> +	unsigned int elem_pow2;	/* PAGE_SHIFT + order */
>   	rwlock_t macc_lck;	/* for atomic media access on this store */
> -	u8 *storep;		/* user data storage (ram) */
> +	struct scatterlist *sgl;  /* main store: n_elem array of same sized allocs */
>   	struct t10_pi_tuple *dif_storep; /* protection info */
>   	void *map_storep;	/* provisioning map */
>   };
> @@ -880,19 +884,6 @@ static inline bool scsi_debug_lbp(void)
>   		(sdebug_lbpu || sdebug_lbpws || sdebug_lbpws10);
>   }
>   
> -static void *lba2fake_store(struct sdeb_store_info *sip,
> -			    unsigned long long lba)
> -{
> -	struct sdeb_store_info *lsip = sip;
> -
> -	lba = do_div(lba, sdebug_store_sectors);
> -	if (!sip || !sip->storep) {
> -		WARN_ON_ONCE(true);
> -		lsip = xa_load(per_store_ap, 0);  /* should never be NULL */
> -	}
> -	return lsip->storep + lba * sdebug_sector_size;
> -}
> -
>   static struct t10_pi_tuple *dif_store(struct sdeb_store_info *sip,
>   				      sector_t sector)
>   {
> @@ -1001,7 +992,6 @@ static int scsi_debug_ioctl(struct scsi_device *dev, unsigned int cmd,
>   				    __func__, cmd);
>   	}
>   	return -EINVAL;
> -	/* return -ENOTTY; // correct return but upsets fdisk */
>   }
>   
>   static void config_cdb_len(struct scsi_device *sdev)
> @@ -1221,6 +1211,55 @@ static int fetch_to_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
>   	return scsi_sg_copy_to_buffer(scp, arr, arr_len);
>   }
>   
> +static bool sdeb_sgl_cmp_buf(struct scatterlist *sgl, unsigned int nents,
> +			     const void *buf, size_t buflen, off_t skip)
> +{
> +	bool equ = true;
> +	size_t offset = 0;
> +	size_t len;
> +	struct sg_mapping_iter miter;
> +
> +	if (buflen == 0)
> +		return true;
> +	sg_miter_start(&miter, sgl, nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
> +	if (!sg_miter_skip(&miter, skip))
> +		goto fini;
> +
> +	while (equ && (offset < buflen) && sg_miter_next(&miter)) {
> +		len = min(miter.length, buflen - offset);
> +		equ = memcmp(buf + offset, miter.addr, len) == 0;
> +		offset += len;
> +		miter.consumed = len;
> +		sg_miter_stop(&miter);

I think, the sg_miter_stop is obsolete here.
Also, I think there is no need to set miter.consumed. If len is less
than miter.length, the loop will end and not not call sg_miter_next
again.

Bodo

> +	}
> +fini:
> +	sg_miter_stop(&miter);
> +	return equ;
> +}
> +

