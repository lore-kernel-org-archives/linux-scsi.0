Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89CDAC6FD1D
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 02:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCPCAo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 22:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjCPCAj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 22:00:39 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E02AF2BB
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 19:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678932037; x=1710468037;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=frvO2agJBLyaiESLPLi6KEXOHNLtpqWj0D7l6//gTck=;
  b=iz87SVw6rK3M3drbNCVMC36JurLMYrRwCyUAO9/g/YU1/Nl0HH+O8JpW
   CgEG8GwlUdXNwRx8+c2FGjajwAKV6HdIvx5cVgIBKb/P3z+Pn1BNfn1Cz
   6AMBC4E91ewbwFwKXc+WZWNtsscXWfxj+lKkHfxSg9ccV3cYqmvNtsMCp
   tNTAXup6eWsPiAP878LQofpC88Ja/ca5e6xZHkNSffoY/e9Rv0wyo8wlk
   hqLDKiDC3NF5C+My4B0IjxiZYmTSDOIiX6F3xpmuQXz5e/F7pv1NG2Yrk
   5ORdwrTfWCyz7IM1bx121yzt64Gvpr5DucsjnknG1bAIB1dlZBkvZyd1N
   A==;
X-IronPort-AV: E=Sophos;i="5.98,264,1673884800"; 
   d="scan'208";a="224020860"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2023 10:00:34 +0800
IronPort-SDR: rT6KX154jYOxokcnbUxzqftz6DopVJTwrGiRJ0Idj9ZCJ3SBPTNZ9bNWTgWDyFEHHPGTN8bOqV
 7ImWxri8Pep6y+GTWevLC5PvmLBct3T0JgbN/H2RMj2keqwTunPaKt3dF3t8UzECC1JukJhY7b
 8Hqqdx68fT1uG3qLvJOGy9Jr/xhumIHKlkgjnJgdCwMNuOtgxKHyiP/Dl+Z887lUXHJzY+9/ha
 vodM1B8vc9ymawqp+Cn3A+ok4+cpSU1wjV96IH27fSGw4c27UxGrpeR77dA7/I7f9jJUqjc1As
 IWk=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Mar 2023 18:17:00 -0700
IronPort-SDR: vYw9XbBrl/5d2TPwwDc71yIdyxdNJwxsbqKd7BX4xfzn82mrw4B24yCgp38h1NY24NWc6xW3LR
 NVYHNYTWtxcqx2Snq6dxPvusGijO0Rgw/HFtkYW6dDuPCxi8UkyixtlWUD9LIHvaSKKhisisO2
 /hsoZUardKrnOIZxEwt3FB77OMNng1xzZEwpFugWZmaqSbLP8HF3udyqBSj6eM95rzkSHHlHzW
 mpkVDW4RL0rrjpMWRBXl2DEm/Du/xLYqM12AXXlweWtDug9VdhT7koOeBD2i4+AyApIuQW7MEv
 cdM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Mar 2023 19:00:35 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PcVpV0ZKdz1RtVy
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 19:00:34 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1678932032; x=1681524033; bh=frvO2agJBLyaiESLPLi6KEXOHNLtpqWj0D7
        l6//gTck=; b=O5NEhEOYDYzRLeeVx579qgOZqzEvmwyli7naBjmovIziFs+apeo
        ftJqf5TZ6kye6zPJs7GtC5sED71/KDXOw+cIkKJbd2gVQ4mJCc4Odo1cYYziH8Vk
        Mv0ezm2WHyWGlxEbUtcuURlLpKMWpWg4xssr4Ceo1xTZEuOURT4JZOV20S6ra+IC
        Wb2E15lA7rG+5425HA4Jf3ViTxUGhf2YBjqcE+8pKajcW6PnVObFUmlwpnIySuDx
        lGbv3xUlG7YiX+BJnqA7Om7wrC6XK0nQtnaT27/q+YagS3M0z6dRA2TmYYQP9tgW
        F8SIKp90Ai1q0akUNr1jsz77CMB+0Yi7Sow==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GtpT_sKl1_8S for <linux-scsi@vger.kernel.org>;
        Wed, 15 Mar 2023 19:00:32 -0700 (PDT)
Received: from [10.89.80.69] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.80.69])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PcVpR4Bd2z1RtVm;
        Wed, 15 Mar 2023 19:00:31 -0700 (PDT)
Message-ID: <c91be70e-14a9-7ad6-ba7c-975a640a34d3@opensource.wdc.com>
Date:   Thu, 16 Mar 2023 11:00:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v4 02/19] block: introduce ioprio hints
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
 <20230309215516.3800571-3-niklas.cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230309215516.3800571-3-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/03/10 6:54, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> IO priorities currently only use 6-bits of the 16-bits ioprio value: the
> 3-upper bits are used to define up to 8 priority classes (4 of which are
> valid) and the 3 lower bits of the value are used to define a priority
> level for the real-time and best-effort class.
> 
> The remaining 10-bits between the IO priority class and level are
> unused, and in fact, cannot be used by the user as doing so would
> either result in the value being completely ignored, or in an error
> returned by ioprio_check_cap().
> 
> Use these 10-bits of an ioprio value to allow a user to specify IO
> hints. An IO hint is defined as a 10-bits value, allowing up to 1023
> different hints to be specified, with the value 0 being reserved as the
> "no hint" case. An IO hint can apply to any IO that specifies a valid
> priority class other than NONE, regardless of the IO priority level
> specified.
> 
> To do so, the macros IOPRIO_PRIO_HINT() and IOPRIO_PRIO_VALUE_HINT() are
> introduced in include/uapi/linux/ioprio.h to respectively allow a user
> to get and set a hint in an ioprio value.
> 
> To support the ATA and SCSI command duration limits feature, 7 hints
> are defined: IOPRIO_HINT_DEV_DURATION_LIMIT_1 to
> IOPRIO_HINT_DEV_DURATION_LIMIT_7, allowing a user to specify which
> command duration limit descriptor should be applied to the commands
> serving an IO. Specifying these hints has for now no effect whatsoever
> if the target block devices do not support the command duration limits
> feature. However, in the future, block IO schedulers can be modified to
> optimize IO issuing order based on these hints, even for devices that
> do not support the command duration limits feature.
> 
> Given that the 7 duration limits hints defined have no effect on any
> block layer component, the actual definition of the duration limits
> implied by these hints remains at the device level.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>

Jens, Martin,

Any thoughts on this new interface ?

Bart,

I would like to hear your opinion as well.


> ---
>  include/uapi/linux/ioprio.h | 49 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/include/uapi/linux/ioprio.h b/include/uapi/linux/ioprio.h
> index 4444b4e4fdad..607c7617b9d2 100644
> --- a/include/uapi/linux/ioprio.h
> +++ b/include/uapi/linux/ioprio.h
> @@ -58,4 +58,53 @@ enum {
>  #define IOPRIO_NORM	4
>  #define IOPRIO_BE_NORM	IOPRIO_NORM
>  
> +/*
> + * The 10-bits between the priority class and the priority level are used to
> + * optionally define IO hints for any combination of IO priority class and
> + * level. Depending on the kernel configuration, IO scheduler being used and
> + * the target IO device being used, hints can influence how IOs are processed
> + * without affecting the IO scheduling ordering defined by the IO priority
> + * class and level.
> + */
> +#define IOPRIO_HINT_SHIFT		IOPRIO_LEVEL_NR_BITS
> +#define IOPRIO_HINT_NR_BITS		10
> +#define IOPRIO_NR_HINTS			(1 << IOPRIO_HINT_NR_BITS)
> +#define IOPRIO_HINT_MASK		(IOPRIO_NR_HINTS - 1)
> +#define IOPRIO_PRIO_HINT(ioprio)	\
> +	(((ioprio) >> IOPRIO_HINT_SHIFT) & IOPRIO_HINT_MASK)
> +
> +/*
> + * Alternate macro for IOPRIO_PRIO_VALUE() to define an IO priority with
> + * a class, level and hint.
> + */
> +#define IOPRIO_PRIO_VALUE_HINT(class, level, hint)		 \
> +	((((class) & IOPRIO_CLASS_MASK) << IOPRIO_CLASS_SHIFT) | \
> +	 (((hint) & IOPRIO_HINT_MASK) << IOPRIO_HINT_SHIFT) |	 \
> +	 ((level) & IOPRIO_LEVEL_MASK))
> +
> +/*
> + * IO hints.
> + */
> +enum {
> +	/* No hint */
> +	IOPRIO_HINT_NONE = 0,
> +
> +	/*
> +	 * Device command duration limits: indicate to the device a desired
> +	 * duration limit for the commands that will be used to process an IO.
> +	 * These will currently only be effective for SCSI and ATA devices that
> +	 * support the command duration limits feature. If this feature is
> +	 * enabled, then the commands issued to the device to process an IO with
> +	 * one of these hints set will have the duration limit index (dld field)
> +	 * set to the value of the hint.
> +	 */
> +	IOPRIO_HINT_DEV_DURATION_LIMIT_1 = 1,
> +	IOPRIO_HINT_DEV_DURATION_LIMIT_2 = 2,
> +	IOPRIO_HINT_DEV_DURATION_LIMIT_3 = 3,
> +	IOPRIO_HINT_DEV_DURATION_LIMIT_4 = 4,
> +	IOPRIO_HINT_DEV_DURATION_LIMIT_5 = 5,
> +	IOPRIO_HINT_DEV_DURATION_LIMIT_6 = 6,
> +	IOPRIO_HINT_DEV_DURATION_LIMIT_7 = 7,
> +};
> +
>  #endif /* _UAPI_LINUX_IOPRIO_H */

-- 
Damien Le Moal
Western Digital Research

