Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D0FC433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 01:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiCFBo4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Mar 2022 20:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiCFBo4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2022 20:44:56 -0500
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2709163512;
        Sat,  5 Mar 2022 17:44:04 -0800 (PST)
Received: by mail-pf1-f179.google.com with SMTP id g1so10843645pfv.1;
        Sat, 05 Mar 2022 17:44:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ESryfROo1uEFmWzaZ2Itgf5HMTBkxiKxsBmRvgvVj7Q=;
        b=rtz+rY8ph2maZDpAgf697IwyURzt7qVlkYFR/NcUpmnsbTmbhFHM7Ti+dwD03H3Qp+
         QRdEC9kg46PIfBDTjfUUvFTbWbBRAK1YU88FqYiAF17d6LsbCOL4Hg9vLl55wR/QkGl5
         vZuv65f4t/nIcZ72VzWq4y4k6oKzWFelDJTs1MsNeV/7G8zsvP0aPBYUas9smp4rmPHI
         P3PcHTYFAYU7mfV12OCLft3wkwi1f+7pB6bvUgMcrD3MTaTxLN2+egTY9HOjrIj1jpT+
         n9GpVYy6gAXT4PqYkVxXpQR6Hb3YnGaGGwNDi/galUsZ0an/Oz4HNrtCbOSN65KWjjMJ
         Q9IQ==
X-Gm-Message-State: AOAM532xAWLdDI5D7HeJW1gieJS9PconYAnp08Quvp5SPLiatqeL8HuY
        MTz95cOmDB4J9foPZuaGuxQ=
X-Google-Smtp-Source: ABdhPJwMU5N5V2xWdtfigS89AL+B1HGKz052fHBwARt7guzsIKUX/ctVGi1n/ye08mlYfQXB37e+wA==
X-Received: by 2002:a05:6a00:b90:b0:4f1:4b2:738e with SMTP id g16-20020a056a000b9000b004f104b2738emr6271683pfj.33.1646531043477;
        Sat, 05 Mar 2022 17:44:03 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id i192-20020a636dc9000000b0037c7149fb0asm6479926pgc.89.2022.03.05.17.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 17:44:03 -0800 (PST)
Message-ID: <fbd048ff-cda0-2edd-da94-2bd37be14cb5@acm.org>
Date:   Sat, 5 Mar 2022 17:44:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 05/14] sd: call sd_zbc_release_disk before releasing the
 scsi_device reference
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-6-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220304160331.399757-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/22 08:03, Christoph Hellwig wrote:
> sd_zbc_release_disk accesses disk->device, so ensure that actually still has
> a valid reference.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
