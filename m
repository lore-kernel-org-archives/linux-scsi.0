Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CDCC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Oct 2022 19:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiJFTyF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 15:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbiJFTx6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 15:53:58 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C562D6E2F7
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2022 12:53:56 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id h10so2666801plb.2
        for <linux-scsi@vger.kernel.org>; Thu, 06 Oct 2022 12:53:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4OFHm7dUAHdF320uXhivhEic4eFA9ZYKeHsLQ8JiEjk=;
        b=QS41PBTSmssq8PxvNGyJsQQmq9hva4sS5xFxjJx5xmUpnxT8yawYT9YS8XuwRldgTz
         oCsKdUhkwkaYsnZxb9e+kqTBPWQZfh6epF5mRNFQJwJDh5feUVyxMaXXzUFEtqMHdWXb
         cAVD0aq47BnoiykpPCHGmZPRgS2EMqFDY0CwHT/yqlEQcY83CCB6h0cRc7JO1VsR24xo
         gtQqBwmjbptXsbk9hFYjOdO0k2JxEoVeuKyWmOsmyCYnLLRLVl/AxbuXKwg1SW/t/UOc
         +W2pPB3QleKBqHWcLHQib03VY28sFOEAnzZzjfRO+x4ybIqra6ZUqvri5DoJcvrddxV+
         K5NA==
X-Gm-Message-State: ACrzQf0niFe5Gr/G2v2n+frI/jUMqIZl4jPt7pPtqgM+4Sl+IzNuYBjc
        5WAVImjo30ZojujZRJSjPfM=
X-Google-Smtp-Source: AMsMyM4ScrYZZaHfXYIoMdaKgnhk+2uL2dzLs9vWOSYgGmWpeCeldJhUJv1LG75QJz3kfbioBGOVVQ==
X-Received: by 2002:a17:902:f611:b0:179:dc1f:48a5 with SMTP id n17-20020a170902f61100b00179dc1f48a5mr1483037plg.0.1665086036060;
        Thu, 06 Oct 2022 12:53:56 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:1d3c:9be0:da66:6729? ([2620:15c:211:201:1d3c:9be0:da66:6729])
        by smtp.gmail.com with ESMTPSA id z188-20020a6265c5000000b005367c28fd32sm13245096pfb.185.2022.10.06.12.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Oct 2022 12:53:55 -0700 (PDT)
Message-ID: <8ec2c047-bd18-171e-616d-7e7b34d2d68e@acm.org>
Date:   Thu, 6 Oct 2022 12:53:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] restrict legal sdev_state transitions via sysfs
Content-Language: en-US
To:     Uday Shankar <ushankar@purestorage.com>, linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
References: <20220924000241.2967323-1-ushankar@purestorage.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220924000241.2967323-1-ushankar@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/23/22 17:02, Uday Shankar wrote:
> Userspace can currently write to sysfs to transition sdev_state to
> RUNNING or OFFLINE from any source state. This causes issues because
> proper transitioning out of some states involves steps besides just
> changing sdev_state, so allowing userspace to change sdev_state
> regardless of the source state can result in inconsistencies; e.g. with
> iscsi we can end up with sdev_state == SDEV_RUNNING while the device
> queue is quiesced. Any task attempting IO on the device will then hang,
> and in more recent kernels, iscsid will hang as well. More detail about
> this bug is provided in my first attempt:
> https://groups.google.com/g/open-iscsi/c/PNKca4HgPDs/m/CXaDkntOAQAJ
> 
> Signed-off-by: Uday Shankar <ushankar@purestorage.com>
> Suggested-by: Mike Christie <michael.christie@oracle.com>
> ---
> Looking for feedback on the "allowed source states" list. The bug I hit
> is solved by prohibiting transitions out of SDEV_BLOCKED, but I think
> most others shouldn't be allowed either.
> 
>   drivers/scsi/scsi_sysfs.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 9dad2fd5297f..b38c30fe681d 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -822,6 +822,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>   	}
>   
>   	mutex_lock(&sdev->state_mutex);
> +	switch (sdev->sdev_state) {
> +	case SDEV_RUNNING:
> +	case SDEV_OFFLINE:
> +		break;
> +	default:
> +		mutex_unlock(&sdev->state_mutex);
> +		return -EINVAL;
> +	}
>   	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
>   		ret = 0;
>   	} else {

The return value -EAGAIN might be more appropriate since it is not the value
written into sysfs that is invalid but the current state that is inappropriate
for the requested transition.

Thanks,

Bart.
