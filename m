Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C246C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 14:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06E1C2078E
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 14:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="DEE5OKKG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgIBOtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 10:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgIBODD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 10:03:03 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000DBC061247
        for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2020 07:02:51 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z25so5859289iol.10
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2020 07:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ku7e+DesYlsL/c7k5HJw65rc3jrpfmGqzPu51jyJxJY=;
        b=DEE5OKKGh1r8VHsSbRDOHXyr0EY/JZmo9R9NjqSjJKawRaCP4hU7gd7TYcJP/9YZM7
         f9ePonEEbp/l91A6T4zFQxTQLDeZxmy0LMYDoRrMahsz8WSo30cFpFYAnwscMWxFdIlp
         oD8CXLDbgxFmE3UimYbtHYWaCjvm1HLjDP1Jf/oc196Q0dgg3xrDzjQ3BN32QyrfzGEu
         BAA+ZfhsIf58ZQsISLcJD7bVqjEF28U7NRblbSxZYn9AOlHAjsBMyhDBaU/uxguqX2OT
         X2fZVbjEQa6505uyiqaXXm9chdV79wx7RHjRntV/V2w1d3oytjJ926JWuLbQ8ZonRWBw
         7Msg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ku7e+DesYlsL/c7k5HJw65rc3jrpfmGqzPu51jyJxJY=;
        b=dscWG43nUE6QzNp8Fu3Ep7vI5rlT7Ly/8cim6UgkzS7uMZ7cHTWLrW06Z7ZPg4CVLs
         QWNWHpljni4+AdGZ71Z1g9EXWA67qU27BhkR0xeKnwGGsTSi3p78kO0g9cMmKOxdwJQC
         k2gxnf0EDqlqwq0JjXIA7SQhaUzgCvi20rm4J5qcibFwhABhCQt1e8IVeuy4rr5rIzOQ
         jwtMePDKGzCcRLSH68HyRQD3TOzoOVG9U58u0MOqFvOARYTre3wtY6fhxOE8ry9fD54T
         +Cd8IrApN2lnB67ecZgKdhohX/trCf9WWSdHnpmOjOuw2ZkeodEcI36zTbnaEZj1V4Ie
         gzfA==
X-Gm-Message-State: AOAM533F6lfu+SExVMjsX0ovf3unnnADbiWWHk/WTrEV2TLR2VROYjTd
        uysc64JpSEMW71xWFYZtHa7waA==
X-Google-Smtp-Source: ABdhPJxFrZXWesZv0xLmVsuUB1MDZ450c11yMQmgXL3dPEcVh+WgJjGeEIGPOaG+O49/dxLkaoYMdQ==
X-Received: by 2002:a05:6602:2043:: with SMTP id z3mr3472576iod.93.1599055371125;
        Wed, 02 Sep 2020 07:02:51 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s10sm616030ilo.53.2020.09.02.07.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 07:02:50 -0700 (PDT)
Subject: Re: remove revalidate_disk()
To:     Christoph Hellwig <hch@lst.de>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Dan Williams <dan.j.williams@intel.com>, dm-devel@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        nbd@other.debian.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20200901155748.2884-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <78d5ab8a-4387-7bfb-6e25-07fd6c1ddc10@kernel.dk>
Date:   Wed, 2 Sep 2020 08:02:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200901155748.2884-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/1/20 9:57 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series removes the revalidate_disk() function, which has been a
> really odd duck in the last years.  The prime reason why most people
> use it is because it propagates a size change from the gendisk to
> the block_device structure.  But it also calls into the rather ill
> defined ->revalidate_disk method which is rather useless for the
> callers.  So this adds a new helper to just propagate the size, and
> cleans up all kinds of mess around this area.  Follow on patches
> will eventuall kill of ->revalidate_disk entirely, but ther are a lot
> more patches needed for that.

Applied, thanks.

-- 
Jens Axboe

