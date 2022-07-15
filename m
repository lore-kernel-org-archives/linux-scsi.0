Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 810F6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 20:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiGOUyT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 16:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiGOUyI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 16:54:08 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C7F186FE
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 13:54:02 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id bf13so5401684pgb.11
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 13:54:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=87hcZ+ZDid2IKMkwA0j421ruOzx2YgXeYCn9F2CjdQs=;
        b=Kw6lXhBwdxOgnx20WuhxUoOV33+uB+Jv7rJO15jZXd2SU1u8A5A5unYyQiw8H0iKCJ
         7/9KvZh8iPfv9/nLRCcYFKcBMMKdptzJER0tkDDiXqSDTLAtscjY1aQTrqYlNYNTuL0K
         lM4OxnfRPik313pkI6NbH+74wd74rXuqYrjKSvEJXvhmBSoorKFT0yZG4dQRv+RmDCj5
         0ncoWUqi9wtGubnajjhO9fpUoI8YpfA8ngJkXiLjnoalCwceYsBBhSgB9wl9e1py3XlF
         tmkCEOGbuRNUSrvAfLmMgymDlscrMxyRTpUzBjqxgF6Fv6UOvr0gTXtOTw43KkTDwgxM
         gk0w==
X-Gm-Message-State: AJIora8lxOitOSk13oCQF4Xr9kKENXD0HBD3A9ZEhx7ItKk9xQJcwImy
        BrG+zZY8uuZtHVoZw+xoxJ3TU9tmGuU=
X-Google-Smtp-Source: AGRyM1sCULWjrSuPHaqC0lTAzMX7n+BWR9U55iFWLX0Q4tm6OFSLT9q4wMuNBUhpU3ly54LU9GiRGg==
X-Received: by 2002:a05:6a00:170a:b0:52a:d3d4:3852 with SMTP id h10-20020a056a00170a00b0052ad3d43852mr16025103pfc.19.1657918442163;
        Fri, 15 Jul 2022 13:54:02 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:276e:f777:f438:e01d? ([2620:15c:211:201:276e:f777:f438:e01d])
        by smtp.gmail.com with ESMTPSA id p13-20020a63e64d000000b0040c9df2b060sm3659659pgj.30.2022.07.15.13.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 13:54:01 -0700 (PDT)
Message-ID: <01cac097-1420-2142-c701-2542bf437656@acm.org>
Date:   Fri, 15 Jul 2022 13:53:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] scsi: sd_zbc: Fix handling of RC BASIS
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-4-bvanassche@acm.org>
 <90cb95f0-7d8b-af10-9480-76a2163993e2@opensource.wdc.com>
 <95f2f1d5-3e32-bb6f-b8e4-df0c232ed6eb@opensource.wdc.com>
 <7f58e047-8fa8-7300-3062-ab1d22495b2d@acm.org>
 <6d228185-1ce3-b0c8-71b8-badfe78505b7@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6d228185-1ce3-b0c8-71b8-badfe78505b7@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/12/22 15:08, Damien Le Moal wrote:
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 6acc4f406eb8..32da54e7b68a 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -716,17 +716,15 @@ static int sd_zbc_check_capacity(struct scsi_disk
> *sdkp, unsigned char *buf,
>          if (ret)
>                  return ret;
> 
> -       if (sdkp->rc_basis == 0) {
> -               /* The max_lba field is the capacity of this device */
> -               max_lba = get_unaligned_be64(&buf[8]);
> -               if (sdkp->capacity != max_lba + 1) {
> -                       if (sdkp->first_scan)
> -                               sd_printk(KERN_WARNING, sdkp,
> -                                       "Changing capacity from %llu to
> max LBA+1 %llu\n",
> -                                       (unsigned long long)sdkp->capacity,
> -                                       (unsigned long long)max_lba + 1);
> -                       sdkp->capacity = max_lba + 1;
> -               }
> +       /* The max_lba field is the capacity of this device */
> +       max_lba = get_unaligned_be64(&buf[8]);
> +       if (sdkp->capacity != max_lba + 1) {
> +               if (sdkp->first_scan)
> +                       sd_printk(KERN_WARNING, sdkp,
> +                               "Changing capacity from %llu to max LBA+1 %llu\n",
> +                               (unsigned long long)sdkp->capacity,
> +                               (unsigned long long)max_lba + 1);
> +               sdkp->capacity = max_lba + 1;
>          }
> 
>          if (sdkp->zone_starting_lba_gran == 0) {
> 
> That is, always check the reported capacity against max_lba of report
> zones reply, regardless of rc_basis (and we can even then drop the
> rc_basis field from struct scsi_disk).

I like the above patch because it simplifies the existing code.

> But I would argue that any problem with the current code would mean a
> buggy device firmware. For such case, the device FW should be fixed or we
> should add a quirk for it.

My question was which approach should be followed for devices with a 
buggy firmware? Use the zones up to the LBA reported in the READ 
CAPACITY response or reject these devices entirely?

Thanks,

Bart.
