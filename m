Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4FFC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Mar 2022 15:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242378AbiCNPGV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Mar 2022 11:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiCNPGT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2022 11:06:19 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E68A3EBA1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 08:05:09 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id x4so18541297iom.12
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 08:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Qv0ctZNGjuMHErRKtH6tt/mtgdEahUlvx8zamL6m8vU=;
        b=N9hg3BIE5p7LvVmg4KVrNn4kNF4vduTCaejUoJR5THfPLowx1GbE2zcgd8B1oR2XF+
         q16YhGN0YKjzlefONIgGLPQVIozelW4E1WTk7mtl2tGcyo3SgP8Lm21067k29RWYrQYd
         y6LIZ7xYrVc18j0ZtH4vq/OuAD1EbusnSkvv2XXjTpHAKGR3313nkVhtTOBAKqUMPz2I
         lOwAYit5E5TMDRcMGcYXarFbBG3W/3Uh3O/f+neDZFNrQQIIVZVk9r/ymBbFHMbfH7ix
         knIMP0wC8OvC7MSFewaX56XfovM0xy86wtIFRNxvsGCP+le4PxmD0xoYkGd7LMI04BVC
         G0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Qv0ctZNGjuMHErRKtH6tt/mtgdEahUlvx8zamL6m8vU=;
        b=w644idWkAnQbCxULRbVYHH7l9OUC8CTtKwOda8J0EzisIxw/lriPOWDAiP3qT/DXAP
         /4EgZcMSUK/i5wxEJSNkoHi5xFHEvI2a8HhoSFZ3d/J0X1rOkGbnp3Wys+hYnzrrr1PR
         D+iMb1/ZLPbmWm8yoJm+TxbBYJgeQkik/WcoyAwT08zQbaLUiQIsJtQ6I6JYm6zC53B+
         H9AB4jZLC82nkSXRmZ8f+GYXo+fdf5hO9jRM7iFxzDmyezOsjS4N/m3sAIJuCwf1eZEq
         5JQSLn74QXWg78kyWk8okh+JOkPBbrKWFelU/FzmxILniBgFj715j+ImDIF+WwZe7+jD
         Mt8w==
X-Gm-Message-State: AOAM53351B3U5WVl8rupeowApvRcaEjmctyamsJANhxmJnnKsoVOZ5SF
        fHWQ6wNetb5uePpC3qMR/ZhW8g==
X-Google-Smtp-Source: ABdhPJy5i3gwDYd7vSs1vykIh+CiaOKmshYveHelWbXlHgFMTOzOBV14bFOfIjB2517O3ai/dZGfQQ==
X-Received: by 2002:a05:6638:2388:b0:311:d1bb:ed46 with SMTP id q8-20020a056638238800b00311d1bbed46mr21122474jat.212.1647270308486;
        Mon, 14 Mar 2022 08:05:08 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x14-20020a056e021bce00b002c7ada1bec5sm512482ilv.88.2022.03.14.08.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 08:05:08 -0700 (PDT)
Message-ID: <0d79b44c-d51e-282c-99a0-78ae6c9f6f01@kernel.dk>
Date:   Mon, 14 Mar 2022 09:05:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] sr: simplify the local variable initialization in
 sr_block_open()
Content-Language: en-US
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, kernel-janitors@vger.kernel.org
References: <20220314150321.17720-1-lukas.bulwahn@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220314150321.17720-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/14/22 9:03 AM, Lukas Bulwahn wrote:
> Commit 01d0c698536f ("sr: implement ->free_disk to simplify refcounting")
> refactored sr_block_open(), initialized one variable with a duplicate
> assignment (probably an unintended copy & paste duplication) and turned one
> error case into an early return, which makes the initialization of the
> return variable needless.
> 
> So, simplify the local variable initialization in sr_block_open() to make
> the code a bit more clear.
> 
> No functional change. No change in resulting object code.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Christoph, please ack.
> 
> Jens, please pick this minor clean-up on your -next branch on top of the
> commit above.

Should it have a Fixes line?

-- 
Jens Axboe

