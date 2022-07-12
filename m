Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E3BC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 22:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbiGLW34 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 18:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbiGLW3r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 18:29:47 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D699BDBAF
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:29:45 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id r186so1624171pgr.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:29:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lJjvBL7DPPK5Qj27AT3CKL6eL0cLxFkisiBEdqcX+Y0=;
        b=Sd1kE7KBYEh6mqt3rKsEZvUCGkGNxJHWfZBZSRZXjxQbTCuLX3kf7eVIkTdWd9QKm6
         sORCg93VGtWPzLwmKr7q6mP4OJuOnyPI8E01rGi/LMF9uIOCw7Ym8Tl+Fzzccxet1kGS
         /bNxGZFA5A5HQ2FKLDCeYAiAj+FD3JLJ4cljOGUOyE/gdu5Mo3GD1OKw4W/XJcATouaJ
         otJz8t4QR2lYpthFcjBAkEucSEPi/lP002MOR3dFmMBKfD2DWSN4ewNw+6Yxip6XNaax
         A9npswiBIvA31MYk47qb+zHUTtkGc2J1+DLeZpp6O1H9VjHSNHJFN7I+wUPGZ1dNMOcH
         5EPA==
X-Gm-Message-State: AJIora+ftggWJAjXe8l3CVVpACRTCWSABI0orhDcOqqaZozW8XdBwgRD
        bC1nTY+nNYzIRof7AP6MM9g=
X-Google-Smtp-Source: AGRyM1suHt/kztUtYrMUIVhwh/jBo3cpG0+wV89w+eThafVYmCeUXrwig13QGwgKyjlyO1clEVZMRg==
X-Received: by 2002:aa7:8186:0:b0:528:c344:ed6e with SMTP id g6-20020aa78186000000b00528c344ed6emr111615pfi.35.1657664984925;
        Tue, 12 Jul 2022 15:29:44 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:de3c:137c:f4d2:d291? ([2620:15c:211:201:de3c:137c:f4d2:d291])
        by smtp.gmail.com with ESMTPSA id gb6-20020a17090b060600b001ef8d2f72fesm84511pjb.45.2022.07.12.15.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 15:29:44 -0700 (PDT)
Message-ID: <88942839-e618-010b-07a7-76e0a302b1c3@acm.org>
Date:   Tue, 12 Jul 2022 15:29:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 1/2] scsi: core: Make sure that hosts outlive targets
 and devices
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220707182122.3797-1-bvanassche@acm.org>
 <20220707182122.3797-2-bvanassche@acm.org>
 <8fa5f4a0-fcdf-365d-8c42-9ab4041f2a8e@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8fa5f4a0-fcdf-365d-8c42-9ab4041f2a8e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/9/22 08:57, Mike Christie wrote:
> If so, could we move what are doing in this patch down a level? Put the wait in
> scsi_remove_target and wake in scsi_target_dev_release. Instead of a target_count
> you have a scsi_target sdev_count.
> 
> scsi_forget_host would then need to loop over the targets and do
> scsi_target_remove on them instead of doing it at the scsi_device level.

Hi Mike,

Thanks for having taken a look.

Could the approach outlined above have user-visible side effects?

A different approach has been selected for v4 of this patch series. Further feedback
is welcome.

Thanks,

Bart.
