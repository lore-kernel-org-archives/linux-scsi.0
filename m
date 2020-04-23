Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F07C55185
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 00:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF97720776
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 00:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgDWAAR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 20:00:17 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53785 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWAAQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 20:00:16 -0400
Received: by mail-pj1-f67.google.com with SMTP id hi11so1636513pjb.3;
        Wed, 22 Apr 2020 17:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NCJ4bzwr7CHPa9Gr5MhP0D80SCehlUu/onbbUIoLCdo=;
        b=Pqh5CvDwgRWo4JdJQxdnywbpQoWyqpB8cOw1yoT3JS3t01gBoc6OuW4uQR2BQidnI2
         fM4X3f+2lBbjB2ufQjhqao7dAFr4DpXArMNzOFt689omDS7jE3+ynr3h/poVc8XDaV3x
         ptS+CQvCwgt2clDFWyWSlchX9FBupKUdo/KVURRcregQgf1ozo833vhE/admGoeXR31Y
         p2Hk5PteJ0x1I+K8rQnvz/7zdZm/bompd8hnB79lTPYcaMEuLx8USxY7WehiNGSjMrbD
         cx/PFg0LoyumaQXxArSHlj4pXrbiV17mkk7uYjK6HWeptcXJErn5lszhMU3DO2KjE169
         94Ew==
X-Gm-Message-State: AGi0PuZxZHPZlkkqpmO7Ah/2yv7ujs0yGx1LYsiyBjNn7UD0jKQbwjSd
        +VsXLvnI4zuNSdDmv68L4biDUOImhsw=
X-Google-Smtp-Source: APiQypJTzB0yg4NW0mVxo2HaYSLx1utydmZ7JUsQq+UMULNfK+lt7IrRkjN6DrtO9vepGLFoUus1HA==
X-Received: by 2002:a17:90a:33c5:: with SMTP id n63mr1306161pjb.4.1587600014985;
        Wed, 22 Apr 2020 17:00:14 -0700 (PDT)
Received: from [100.124.12.67] ([104.129.198.51])
        by smtp.gmail.com with ESMTPSA id h6sm356755pje.37.2020.04.22.17.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 17:00:13 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
To:     huobean@gmail.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-6-beanhuo@micron.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
Date:   Wed, 22 Apr 2020 17:00:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200416203126.1210-6-beanhuo@micron.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/20 1:31 PM, huobean@gmail.com wrote:
> This patch is to add support for the UFS Host Performance Booster (HPB v1.0),
> which is used to improve UFS read performance, especially for the random read.
> 
> NAND flash-based storage devices, including UFS, have mechanisms to translate
> logical addresses of requests to the corresponding physical addresses of the
> flash storage. Traditionally this L2P mapping data is loaded to the internal
> SRAM in the storage controller. When the capacity of storage is larger, a
> larger size of SRAM for the L2P map data is required. Since increased SRAM
> size affects the manufacturing cost significantly, it is not cost-effective
> to allocate all the amount of SRAM needed to keep all the Logical-address to
> Physical-address (L2P) map data. Therefore, L2P map data, which is required
> to identify the physical address for the requested IOs, can only be partially
> stored in SRAM from NAND flash. Due to this partial loading, accessing the
> flash address area where the L2P information for that address is not loaded
> in the SRAM can result in serious performance degradation.
> 
> The HPB is a software solution for the above problem, which uses the host’s
> system memory as a cache for the FTL L2P mapping table. It does not need
> additional hardware support from the host side. By using HPB, the L2P mapping
> table can be read from host memory and stored in host-side memory. while
> reading the operation, the corresponding L2P information will be sent to the
> UFS device along with the reading request. Since the L2P entry is provided in
> the read request, UFS device does not have to load L2P entry from flash memory.
> This will significantly improve random read performance.

The above description is incomplete: what is missing is an explanation 
of how the L2P data is made persistent and also how it is stored on the 
device. Is an L2P update written to the device every time data on the 
device is modified or only during an orderly shutdown? In the former 
case, how big is the impact on write performance? In the latter case, 
does that mean that data is lost during an unorderly shutdown? Is HPB a 
feature that perhaps only works well for battery-powered devices?

Is the persistent L2P data overwritten in place or is new data appended 
as an update after existing data? In the former case, is all L2P data 
lost in case of a power failure? In the latter case, how is it 
guaranteed that enough free space is available to make the L2P data 
persistent?

What are the similarities and differences compared to the lightnvm 
framework that was added several years ago to the Linux kernel? Which of 
the code in this patch can be shared with the lightnvm framework?

> +config UFSHPB_MAX_MEM_SIZE
> +	int "UFS HPB maximum memory size per controller (in MiB)"
> +	depends on SCSI_UFSHPB
> +	default 128
> +	range 0 65536
> +	help
> +	  This parameter defines the maximum UFS HPB memory/cache size in the
> +	  host system. The recommended HPB cache size by the UFS device can be
> +	  calculated from bHPBRegionSize and wDeviceMaxActiveHPBRegions. The
> +	  reference formula can be
> +
> +		(bHPBRegionSize(in KB) / 4KB) * 8 * wDeviceMaxActiveHPBRegions.
> +
> +	  The HPB cache in the host system is used to contain L2P mapping entry.
> +	  If the allocated HPB cache size is lower than what calculated by the
> +	  above formula, the use of HPB feature may provide lower performance
> +	  advantage. But the system memory resource has the limitation, we can
> +	  not let HPB driver allocate its cache at will according to the UFS
> +	  device recommendation, so an appropriate size of the cache for HPB
> +	  should be specified before you choose to use HPB, then please input a
> +	  non-zero positive integer value.
> +
> +	  Nevertheless, if you want to leave this right to the HPB driver, and
> +	  let the HPB driver allocate the HPB cache based on the recommendation
> +	  of the UFS device. Just give 0 value to this parameter.
> +
> +	  Leave the default value if unsure.

Can this parameter be changed from a compile-time option into something 
that is configurable at runtime, e.g. a sysfs or configfs attribute?

> +#if defined(CONFIG_SCSI_UFSHPB)
> +	if (sdev->lun < hba->dev_info.max_lu_supported)
> +		hba->sdev_ufs_lu[sdev->lun] = sdev;
> +#endif

Isn't maintaining a LUN to scsi_device mapping something that is already 
done by the SCSI core? See also __scsi_device_lookup().

> +#if defined(CONFIG_SCSI_UFSHPB)
> +			/*
> +			 * HPB recommendations are provided in RESPONSE UPIU
> +			 * packets of successfully completed commands, which
> +			 * are commands terminated with GOOD status.
> +			 */
> +			if (scsi_status == SAM_STAT_GOOD)
> +				ufshpb_rsp_handler(hba, lrbp);
> +#endif

Please introduce helper functions such that no #if 
defined(CONFIG_SCSI_UFSHPB) statements are required in .c files. From 
Documentation/process/4.Coding.rst: "As a general rule, #ifdef use
should be confined to header files whenever possible."

> @@ -6627,16 +6656,16 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>   
>   	dev_info->ufs_features = desc_buf[DEVICE_DESC_PARAM_UFS_FEAT];
>   
> -	if (desc_buf[DEVICE_DESC_PARAM_UFS_FEAT] & 0x80) {
> -		hba->dev_info.hpb_control_mode =
> +	if (dev_info->ufs_features & 0x80) {

The above change should be moved into the combination of patches 1/5 and 
3/5, and the changes below probably too.

> +		dev_info->hpb_control_mode =
>   			desc_buf[DEVICE_DESC_PARAM_HPB_CTRL_MODE];
> -		hba->dev_info.hpb_ver =
> +		dev_info->hpb_ver =
>   			(u16) (desc_buf[DEVICE_DESC_PARAM_HPB_VER] << 8) |
>   			desc_buf[DEVICE_DESC_PARAM_HPB_VER + 1];
>   		dev_info(hba->dev, "HPB Version: 0x%2x\n",
> -			 hba->dev_info.hpb_ver);
> +			 dev_info->hpb_ver);
>   		dev_info(hba->dev, "HPB control mode: %d\n",
> -			 hba->dev_info.hpb_control_mode);
> +			 dev_info->hpb_control_mode);
>   	}

[ ... ]

> +/* BYTE SHIFT */
> +#define ZERO_BYTE_SHIFT			0
> +#define ONE_BYTE_SHIFT			8
> +#define TWO_BYTE_SHIFT			16
> +#define THREE_BYTE_SHIFT		24
> +#define FOUR_BYTE_SHIFT			32
> +#define FIVE_BYTE_SHIFT			40
> +#define SIX_BYTE_SHIFT			48
> +#define SEVEN_BYTE_SHIFT		56
 >
> +#define SHIFT_BYTE_0(num)		((num) << ZERO_BYTE_SHIFT)
> +#define SHIFT_BYTE_1(num)		((num) << ONE_BYTE_SHIFT)
> +#define SHIFT_BYTE_2(num)		((num) << TWO_BYTE_SHIFT)
> +#define SHIFT_BYTE_3(num)		((num) << THREE_BYTE_SHIFT)
> +#define SHIFT_BYTE_4(num)		((num) << FOUR_BYTE_SHIFT)
> +#define SHIFT_BYTE_5(num)		((num) << FIVE_BYTE_SHIFT)
> +#define SHIFT_BYTE_6(num)		((num) << SIX_BYTE_SHIFT)
> +#define SHIFT_BYTE_7(num)		((num) << SEVEN_BYTE_SHIFT)
 >
> +#define GET_BYTE_0(num)			(((num) >> ZERO_BYTE_SHIFT) & 0xff)
> +#define GET_BYTE_1(num)			(((num) >> ONE_BYTE_SHIFT) & 0xff)
> +#define GET_BYTE_2(num)			(((num) >> TWO_BYTE_SHIFT) & 0xff)
> +#define GET_BYTE_3(num)			(((num) >> THREE_BYTE_SHIFT) & 0xff)
> +#define GET_BYTE_4(num)			(((num) >> FOUR_BYTE_SHIFT) & 0xff)
> +#define GET_BYTE_5(num)			(((num) >> FIVE_BYTE_SHIFT) & 0xff)
> +#define GET_BYTE_6(num)			(((num) >> SIX_BYTE_SHIFT) & 0xff)
> +#define GET_BYTE_7(num)			(((num) >> SEVEN_BYTE_SHIFT) & 0xff)

Please remove the above 24 macro definitions and use get_unaligned_*() / 
put_unaligned_*() instead.

Thanks,

Bart.
