Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C690C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 13:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354950AbhK0NqN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 08:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239495AbhK0NoM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 08:44:12 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B7EC06174A
        for <linux-scsi@vger.kernel.org>; Sat, 27 Nov 2021 05:40:58 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id v23so14915832iom.12
        for <linux-scsi@vger.kernel.org>; Sat, 27 Nov 2021 05:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+C1eCBisUZmPf4XwFZefJXfNuaIvZbpstQOMoYzueNI=;
        b=45LlVGpAa8ZJjwB+km986MoMsAsnUJcUqiqjUEWT0aM29S5ToBEi6XxhmYa5ZejUtX
         qaBOnXSkbku2NutcT2Xjb1O0Qss+sUqAMCs8tzgEkTjOpJGlEgr3+gxLvSCpz7LM/YyA
         ahmPWm9IR+GjUEwNuujbdFUR9s21wbDOVcTOYIKG6Gkslc3nRv4GvAviUqoa1aq0Pt43
         uoGsgp+0V6KZ85RaY7NdXoF85GCfIRmEH+2UeZ2SUZX1sYPpiaBUC/PqN0ObC/kbnj1F
         tOzkUrJB9ab7Ph7krGxN2SDedltJ8jkKgvY00sXTrkAjpJ2vqE9xFkOUR1pGQCCcZ03C
         J5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+C1eCBisUZmPf4XwFZefJXfNuaIvZbpstQOMoYzueNI=;
        b=68IHdhw3QBoDDU7ddn9vPvhWdIx+T/K27Gjs8aqzLz0L9UYTkcMcO04SH4ZBu1GU5M
         sQ5x2a8p3TuhA30DPbEl7QfIGRZla21qdTJO4uMq4ab1gFw8x1EiJhXiwdjz3Vma/dLH
         4hI0ye1SWfDrdPyJYCh5Z1q+dNFzgG7/zY3SWtwckmzhYYocPt4kwoQGLombrqc5RDUW
         dLGM89Hc6Zhpy2Ec6U9O4XSnhP12fO25GRdpvQDvDn/PZ+ywVwDnJZTH67+ui+px+ncI
         hYsLktsFOQo22vb+yvOcmD59YEHB8+YcblFfZ4yvVzuyveZRdOSYs8IiAB3JvKMifz0R
         S09A==
X-Gm-Message-State: AOAM533VbNYnmZfizBG4VjTjX+WDARda4lUwkGnQK/TGQ8ooi5R57/Ya
        dWc1X/VMDtHMz/YLuouJAgAwE9DQb02u++lQ
X-Google-Smtp-Source: ABdhPJzLny7SclSJ9Z+WRYPXp3qdAuXW2pq8fNtaLFr9DrbDz5Q/e3rkFakNK9qDd2AZQF9VQB1f1w==
X-Received: by 2002:a05:6602:1513:: with SMTP id g19mr43361702iow.31.1638020457843;
        Sat, 27 Nov 2021 05:40:57 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y8sm4690925iox.32.2021.11.27.05.40.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 05:40:57 -0800 (PST)
Subject: Re: remove ->rq_disk v2
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org
References: <20211126121802.2090656-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ba3ceb5f-009f-c679-91a5-7d70b0588d02@kernel.dk>
Date:   Sat, 27 Nov 2021 06:40:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211126121802.2090656-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/21 5:17 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series removes the rq_disk field in struct request, which isn't
> needed now that we can get the disk from the request_queue.

Can we get an ack/review on the SCSI change? Would like to pull
this in.

-- 
Jens Axboe

