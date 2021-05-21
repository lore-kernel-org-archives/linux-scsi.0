Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1061EC4707A
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 22:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6644613D8
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 22:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhEUWjE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 18:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhEUWjD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 18:39:03 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8588BC06138E
        for <linux-scsi@vger.kernel.org>; Fri, 21 May 2021 15:37:31 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c12so4357726pfl.3
        for <linux-scsi@vger.kernel.org>; Fri, 21 May 2021 15:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ccivkmqRxvbEoQM0V9sS14GS9yzetYD2ZYyUao6LYL8=;
        b=HOGxRJT+S3zcq6hG9tZPy7cA+K51TbarsJRrSVikqTSau6Cy77dyYdOclcQ4KvkpHL
         5ki+DoCGpNRtNv4oENFijvD3ZkT/t1aN2qNTMepSrH0L94PGE0RLEjmqtf8E00t3c/86
         CDqc01/JsB/YG4kBmyYNC+6VoiJyGqMitHpngLrllV4yPODbvzUlEsqIsK6f0hlR8Tcb
         C8K/mEhs8pnXSwp444dQA5fcf7dakjkkfbgdlRkymTXroZ2d6+yqAh452WDayssVLPJm
         nhKApahBosgELZ6FlET1/n1KNxZ2IiCLlx/30dQUtLw8acr4TeNRu03XZcXHHQwKaJ3h
         1zFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ccivkmqRxvbEoQM0V9sS14GS9yzetYD2ZYyUao6LYL8=;
        b=NFlcbr/NdcnWtq5cmhrA6InCgwGFUEYWNFGUYqnjfCL+7kDAePw4CV2ck/qQmToXma
         1SGjJwldNf4cOgVfyeViW8/t9c9VlDWUPJAzItR+pbVRJcnKg9NNUSriRv/z6D8evGk+
         bpG+rF6QaiMA2cd3b5+AXQP1U9xLScTgWUM4cMlyyqtgaePQJG5e7YxKLdqe9ZKDCXKq
         WkfKcaCoojjZ5efz668nFXDzSJSVFihx2ZhwruzjSFxtKgyvD4zxQMfn9saR6p+cA2mx
         qK+TzCjdsDGs92GIAU7FtJ9/yUAzkpJpw0HjiSxSzBZwiGGqFX7Q19RmthHYDzRRQDgj
         KBEQ==
X-Gm-Message-State: AOAM531zm7hyr60wnoY0uUzy3GOGKSxbwuWB2F5s7pwleEydpynV7ynD
        3vBfPOscFE7m95G+O16Sx2yByg==
X-Google-Smtp-Source: ABdhPJwzK3VZ3KUvllj7T7UMXQIPumDuGJJFVNI/o3u4lcUKHfVMLwumBcQE4Nn84BsmiwpYUjd3Pw==
X-Received: by 2002:a62:3682:0:b029:2dd:ed69:6e85 with SMTP id d124-20020a6236820000b02902dded696e85mr12537608pfa.20.1621636650955;
        Fri, 21 May 2021 15:37:30 -0700 (PDT)
Received: from relinquished.localdomain ([2620:10d:c090:400::5:1e18])
        by smtp.gmail.com with ESMTPSA id pg5sm2712122pjb.28.2021.05.21.15.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 15:37:29 -0700 (PDT)
Date:   Fri, 21 May 2021 15:37:27 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "mb@lightnvm.io" <mb@lightnvm.io>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "clm@fb.com" <clm@fb.com>,
        "josef@toxicpanda.com" <josef@toxicpanda.com>,
        "dsterba@suse.com" <dsterba@suse.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "osandov@fb.com" <osandov@fb.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
        "hch@lst.de" <hch@lst.de>
Subject: Re: [RFC PATCH 0/8] block: fix bio_add_XXX_page() return type
Message-ID: <YKg2J5n3oY9RpgVb@relinquished.localdomain>
References: <20210520062255.4908-1-chaitanya.kulkarni@wdc.com>
 <PH0PR04MB74169D71E3DCB347DFCBFCB59B299@PH0PR04MB7416.namprd04.prod.outlook.com>
 <BYAPR04MB496577D8AC414B1FFD44722486299@BYAPR04MB4965.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB496577D8AC414B1FFD44722486299@BYAPR04MB4965.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 21, 2021 at 09:37:43PM +0000, Chaitanya Kulkarni wrote:
> On 5/21/21 03:25, Johannes Thumshirn wrote:
> > I couldn't spot any errors, but I'm not sure it's worth the effort.
> >
> > If Jens decides to take it:
> > Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> >
> 
> It does create confusion on the code level which can result in
> invalid error checks.

Do you have any examples of bugs caused by this confusion (whether they
were fixed in the past, currently exist, or were caught in code review)?
That would be good justification for doing this.
