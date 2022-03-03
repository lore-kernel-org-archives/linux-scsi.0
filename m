Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84400C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 00:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiCCAPk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiCCAPe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 19:15:34 -0500
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C40123BE9
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 16:14:47 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id h17so3025047plc.5
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 16:14:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SCp6Px1xLrnrH/iIFUZxVzjnxKyrHjqrBOZLVG4udcM=;
        b=LzhqM5Qtucl2VNPhMjWqmtRVURjYQU6Vl21zURScYmOs1U9jS4mVZg6ZzzcSRShswy
         pbvMbN3npOG8OVczoncPvSTWqQkCzXfMfJ0ldRqTZvrw/F34IRxmquTDIBSf5tNtmK2Z
         bT2oO1fHRxlIEPd9FXmR3RuyAmDrw8YJKFqZHe7zfT0igEfRgswvZ0R2DSngYBf4r3u8
         YVRSRmC96PnUSB0Zi3fOPNbELLBWNgMut3HzCsZNRsUDRsqN9L6WfR9YidFmfZLmELnn
         xZu9IYQTbcT04W5+u0rZgWhoRD1e1EWqOonS/C3YtfLo7c+p5jfYvpEGqWkhWLYlsWUv
         EGyQ==
X-Gm-Message-State: AOAM5328eyEuN6cAgFq+3s51u5jog2iQVOcMTQe+9r6bcXdjVlcBhISR
        S9xP7fsB9ipTus53xetu8dFe/xPmOi4=
X-Google-Smtp-Source: ABdhPJz8UEgLOPd/475JxxZtkMVgyXj+zLcSp+HujlWuCTZQ6CGpU9bhU7WT9RLqiRyI1J/WJd+7bA==
X-Received: by 2002:a17:90a:6809:b0:1b9:bc46:fdd7 with SMTP id p9-20020a17090a680900b001b9bc46fdd7mr2428288pjj.148.1646266486920;
        Wed, 02 Mar 2022 16:14:46 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 67-20020a630846000000b00372782a65d0sm273068pgi.60.2022.03.02.16.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 16:14:46 -0800 (PST)
Message-ID: <82c21426-4d23-1e5f-ef9b-212d623eb8f7@acm.org>
Date:   Wed, 2 Mar 2022 16:14:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 03/14] scsi: core: Do not truncate INQUIRY data on modern
 devices
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-4-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302053559.32147-4-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 21:35, Martin K. Petersen wrote:
> Low-level device drivers have had the ability to limit the size of an
> INQUIRY for many years. This made sense for a wide variety of legacy
> devices. However, we are unnecessarily truncating the INQUIRY response
> for many modern devices. This prevents us from consulting fields
> beyond the first 36 bytes.
> 
> If a device reports that it supports a larger INQUIRY response, and
> the device also reports that it implements SPC-4 or newer, allow the
> larger INQUIRY to proceed.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   drivers/scsi/scsi_scan.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index f4e6c68ac99e..95bf9a1f35ce 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -728,7 +728,17 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   		if (pass == 1) {
>   			if (BLIST_INQUIRY_36 & *bflags)
>   				next_inquiry_len = 36;
> -			else if (sdev->inquiry_len)
> +			/*
> +			 * LLD specified a maximum sdev->inquiry_len
> +			 * but device claims it has more data. Capping
> +			 * the length only makes sense for legacy
> +			 * devices. If a device supports SPC-4 (2014)
> +			 * or newer, assume that it is safe to ask for
> +			 * as much as the device says it supports.
> +			 */
> +			else if (sdev->inquiry_len &&
> +				 response_len > sdev->inquiry_len &&
> +				 (inq_result[2] & 0x7) < 6) /* SPC-4 */
>   				next_inquiry_len = sdev->inquiry_len;
>   			else
>   				next_inquiry_len = response_len;

Hi Martin,

Do the benefits of this change outweigh the additional complexity 
introduced by this code and the risk of breaking support for certain 
devices? I'm asking this because the number of LLDs that sets 
inquiry_len is small:

$ git grep -nH '>inquiry_len[[:blank:]]*=[[:blank:]]'|grep -v scsi_scan
drivers/firewire/sbp2.c:1508:		sdev->inquiry_len = 36;
drivers/staging/rts5208/rtsx.c:67:	sdev->inquiry_len = 36;
drivers/usb/image/microtek.c:323:	s->inquiry_len = 0x24;
drivers/usb/storage/scsiglue.c:77:	sdev->inquiry_len = 36;

Does any of these LLDs support SPC-4 devices? Can this change e.g. break 
support for certain USB sticks?

Thanks,

Bart.
