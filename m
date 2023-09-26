Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7290E7E65B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 17:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbjIZR3A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 13:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbjIZR26 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 13:28:58 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5F211D;
        Tue, 26 Sep 2023 10:28:52 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-690ce3c55f1so6949982b3a.0;
        Tue, 26 Sep 2023 10:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695749331; x=1696354131;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zs50Qz9USNcScot/XlrAoh9zCUc1fHtC2EKiaFK5zYE=;
        b=hhI849lI0SxbsgYnrppExyJTFgh4kxnKkw4qqj4b4QsNy0aXpOmtLhdsHgNtfipYs8
         VCqQdc7IYbv+8UJReH7FvpaL/eZ1cO41CunG5ido6fHletE0eL8ieoXAdHMCrLDzhLfr
         GeYNyVpawPcYA89HRW62xL4uFCstSzYaEevlWP+zS4kzeXXtahQBSr2kwiDjprDMIUj0
         QWICw0T6Ez0Ks5fvjGe0NrIaUdeANyqZ8BoOc4qbLZLt5ZBNccoRmNmeoEDALker/MdD
         f71OCX8bznPBgW2ttyYLB/0f1PdztvzdbZET2LmO/yQlYphFdkiso6Fcergxv4qWxdhI
         YZyA==
X-Gm-Message-State: AOJu0YzK0tMOtirhwG+i6e6NcN2sYWZlAa1paa2Kx6GQLmR3zwRubZEV
        XopoOg+Oi/LnovgdmhDDpIM=
X-Google-Smtp-Source: AGHT+IFxkPcPtdCySeWyE8EBrXo7l4ExkX8Vk2tIiage7ZhitShl+d5mW2WlEiBfrEi1dvIsHG2ckw==
X-Received: by 2002:a05:6a21:a5a2:b0:15d:fc71:1b9e with SMTP id gd34-20020a056a21a5a200b0015dfc711b9emr11277786pzc.49.1695749331406;
        Tue, 26 Sep 2023 10:28:51 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a80d:6f65:53d4:d1bf? ([2620:15c:211:201:a80d:6f65:53d4:d1bf])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902edc200b001c631e9ddffsm1678503plk.170.2023.09.26.10.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 10:28:51 -0700 (PDT)
Message-ID: <f5a23f12-bd74-40ea-9c25-cd32933ee555@acm.org>
Date:   Tue, 26 Sep 2023 10:28:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/23] ata: libata-core: Fix port and device removal
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230923002932.1082348-1-dlemoal@kernel.org>
 <20230923002932.1082348-3-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230923002932.1082348-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/23 17:29, Damien Le Moal wrote:
> Also delete the WAR_ON() call checking that the ATA_PFLAG_UNLOADING flag
> was cleared as that is done without holding the port lock.

Hmm ... I don't see any WARN_ON() statement being removed by this patch?

> -	/* tell EH we're leaving & flush EH */
> +	/* Wait for any ongoing EH */
> +	ata_port_wait_eh(ap);
> +
> +	mutex_lock(&ap->scsi_scan_mutex);
>   	spin_lock_irqsave(ap->lock, flags);
> +
> +	/* Remove scsi devices */
> +	ata_for_each_link(link, ap, HOST_FIRST) {
> +		ata_for_each_dev(dev, link, ALL) {
> +			if (dev->sdev) {
> +				spin_unlock_irqrestore(ap->lock, flags);
> +				scsi_remove_device(dev->sdev);
> +				spin_lock_irqsave(ap->lock, flags);
> +				dev->sdev = NULL;
> +			}
> +		}
> +	}

Can the lists ata_for_each_link() and ata_for_each_dev() iterate over change
while ap->lock is unlocked? If not, does this perhaps have to be explained in
a comment? If these lists can be changed, should these lists perhaps be examined
from the start after every unlock of ap->lock?

Thanks,

Bart.
