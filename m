Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B247BCDB465
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 16:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbjJSQy0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbjJSQyZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2023 12:54:25 -0400
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2635B130;
        Thu, 19 Oct 2023 09:54:23 -0700 (PDT)
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-53fbf2c42bfso6120949a12.3;
        Thu, 19 Oct 2023 09:54:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697734462; x=1698339262;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SBJucs1YHXW9xgzE6huYc95qZju3HfB6c1Cuv0YfbQo=;
        b=h/VOc9/sxBM2KMPLzFiKSEBUCirNN8JWP4UQzHdp9Bc8YMF/JPyBnbNs5mddPeusOg
         +CdWtZ4zCymv3zS0rfEn7xyxEvOibsb+QGIWILBtHzA/BRl9dIZsFbPntPeuRn6DtrhL
         oxJVy5STCeRUiZ3oKHbfFLhUnOvJ+bUy0P8TvaequIgLAH4QFzOH554tmIN9HzGyL6/R
         dKMalDiZ7b/awGcewGgxghHRljM9lMFuOIknnT7k18Xhzn/pBcIscnSXCFyIG3H2oETb
         p7YA2E6p8yQzRIyMRigCtJ+0tqfSisU7zXXmZRKHFfuNFbzh0MfQWgTWxc1C+wAjbrAo
         J2sA==
X-Gm-Message-State: AOJu0YyhZa1WrG7Wtv9LMUya2FHA2nqSZVdVJ3MHGg1Prisn5Z4P8qUm
        ZL2kHIbFCYbwlgpnnnpv/+Q=
X-Google-Smtp-Source: AGHT+IE2sOdl2hbEzGE2FrTKdNyb7ub3AnJY6YxOwXJu58/bMMBmV/vCMdwTWS1IwHpYfMGtE60MEw==
X-Received: by 2002:a17:903:708:b0:1ca:abe:a08b with SMTP id kk8-20020a170903070800b001ca0abea08bmr2315289plb.68.1697734462267;
        Thu, 19 Oct 2023 09:54:22 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:3306:3a7f:54e8:2149? ([2620:15c:211:201:3306:3a7f:54e8:2149])
        by smtp.gmail.com with ESMTPSA id d11-20020a170903230b00b001aaf2e8b1eesm2169601plh.248.2023.10.19.09.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Oct 2023 09:54:21 -0700 (PDT)
Message-ID: <0e7a436d-2100-47ea-9fde-899b9ad67253@acm.org>
Date:   Thu, 19 Oct 2023 09:54:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 10/18] scsi: sd_zbc: Only require an I/O scheduler if
 needed
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231018175602.2148415-1-bvanassche@acm.org>
 <20231018175602.2148415-11-bvanassche@acm.org>
 <88133920-cb0c-43ea-a735-dee63267ffc8@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <88133920-cb0c-43ea-a735-dee63267ffc8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/18/23 17:26, Damien Le Moal wrote:
> On 10/19/23 02:54, Bart Van Assche wrote:
>>   	/* The drive satisfies the kernel restrictions: set it up */
>>   	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
>> -	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
>> +	if (!q->limits.driver_preserves_write_order)
> 
> Where is this limit introduced ? I do not see it anywhere in your patches. Did I
> miss something ?

Hi Damien,

Please take another look at patch 01/18 of this series. I think that you
have seen that patch before since a Reviewed-by tag was posted by you on
August 17. See also 
https://lore.kernel.org/linux-block/6d823671-db2b-2280-0c93-87d03a2f471e@kernel.org/.

Thanks,

Bart.

