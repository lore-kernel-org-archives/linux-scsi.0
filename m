Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D535C001DB
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jun 2023 17:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjF2R1i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jun 2023 13:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbjF2R1d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2023 13:27:33 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9427EB9;
        Thu, 29 Jun 2023 10:27:32 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1b7e1875cc1so7478735ad.1;
        Thu, 29 Jun 2023 10:27:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688059652; x=1690651652;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cKJ9DhjvqOBp2CVGYQWoLrEARGd6+E4wYs71rV2g1z4=;
        b=U8oCLS+p0rFth/+icK7fQQtNcDm3wjPpTCOnENecO228XYXLTcR8TbZE4OA36w9Rks
         VwG7j7zx76n9QIs1WIdDhPU8iycve78CFfhpRxA3jeXB6RYcqm60dNsFCk2/bsbweeZX
         maRDxFHW7JVr1LU8S34ZXEJP0mbvAd7ZBL+ragiEeBeU+rGLD3gdDNiVfsMGpax3nJ+6
         zFl5MH0ONgfI8A9eGCH/QWbTxdzRhbthmXQDKkchgKNCOt2Pvx9FvLOVDHpHqCHZOjqH
         lIDs+p/C7rqsCtsLFlyrE0saPogli8W7E15R/Y3SvBxTNZkO0ZeRKjL4VCDcRc4jmgAI
         1kZQ==
X-Gm-Message-State: AC+VfDxUQ+Xc2jCgBU9KNeL9KFB3t1W0w8upCSNoYA6RCeLX7jzTcaS+
        iip2hhQ9x6Sj8e2dcfviG4M=
X-Google-Smtp-Source: ACHHUZ5WIfd9BXaEMUY2N1uIJDb8Arth8vDZjzTiDG4DJBtYdm1ulp797OdTSCnJEY17cSbyJaFO8Q==
X-Received: by 2002:a17:902:c3c6:b0:1b5:5aa0:cfd9 with SMTP id j6-20020a170902c3c600b001b55aa0cfd9mr12671795plj.48.1688059651889;
        Thu, 29 Jun 2023 10:27:31 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a601:6da1:e847:d4b1? ([2620:15c:211:201:a601:6da1:e847:d4b1])
        by smtp.gmail.com with ESMTPSA id jm23-20020a17090304d700b001b51b3e84cesm9411237plb.166.2023.06.29.10.27.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 10:27:31 -0700 (PDT)
Message-ID: <3d467dc4-ef32-3b5e-ad3d-127381b596c9@acm.org>
Date:   Thu, 29 Jun 2023 10:27:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 0/5] Improve checks in blk_revalidate_disk_zones()
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230629062602.234913-1-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230629062602.234913-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/23 23:25, Damien Le Moal wrote:
> This series slightly modifies the 4 block device drivers that support
> zoned block devices to ensure that they all call
> blk_revalidate_disk_zones() with the zone size and max zone append
> limits set. This is done in the first 4 patches.
> 
> With these changes, the last patch improves blk_revalidate_disk_zones()
> to better check a zoned device zones and the device limits.

This patch series changes a lot of code without making it very clear what
the advantages of this patch series are. The cover letter says "better
check" without explaining what is improved. The description of patch 5/5
says "the zone checks implemented in blk_revalidate_zone_cb() can be
improved" without explaining what is improved.

More information about what has been improved and why these improvements
are considered useful would be welcome.

Thanks,

Bart.

