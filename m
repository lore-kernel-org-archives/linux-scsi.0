Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B0CC636CE
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 03:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52E8D61029
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 03:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhGSDKW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Jul 2021 23:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhGSDKV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jul 2021 23:10:21 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B868FC061762;
        Sun, 18 Jul 2021 20:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=jOxOrvxXe2YG379GfZIWS0YoTeAsoMulfNMrXiQceAI=; b=pmi+5Pitxv8K0U37loQLttYy9K
        j61IstkorQVL8G3HFHtTQycGZ0NatvEQctLXP1AVxMsNmkOZlLRk+8vbc4ICJAzuHut7D2vdg27Q/
        w8IOOOlE4aPG3As+Uc2Go71fBimOW0QUUQgtDkiReNmiOR2Jdy8SvVDcdaz+oUBAjkGjjzit/JOPF
        MtdHey5gNXmT2UxNJXQdMz/v7LERhebqf1mMmhNo65rJEqj0V67khyDZ12+uf+Yu3BtPwJg/NFlDJ
        /+5DsVBXubjPUFWbsXYsqECXBxDh6oVexJ4lyAl+w/mcmwYzCJyJIS4PnO4CV26kgiLSVEBm7gO7g
        bT/xLrpQ==;
Received: from [2602:306:c5a2:a380:526b:7c27:e0f6:8e13]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5Jcg-0014Ml-85; Mon, 19 Jul 2021 03:07:15 +0000
Subject: Re: [PATCH 3/6] ps3disk: replace flush_kernel_dcache_page with
 flush_dcache_page
To:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc:     Russell King <linux@armlinux.org.uk>, Guo Ren <guoren@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Paul Cercueil <paul@crapouillou.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alex Shi <alexs@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
References: <20210712060928.4161649-1-hch@lst.de>
 <20210712060928.4161649-4-hch@lst.de>
From:   Geoff Levand <geoff@infradead.org>
Message-ID: <2b1e3c1b-164d-34e6-d057-6518e1c9dc34@infradead.org>
Date:   Sun, 18 Jul 2021 20:07:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712060928.4161649-4-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,

On 7/11/21 11:09 PM, Christoph Hellwig wrote:
> +++ b/drivers/block/ps3disk.c
>  		offset += size;
> -		flush_kernel_dcache_page(bvec.bv_page);
> +		flush_dcache_page(bvec.bv_page);
>  		bvec_kunmap_irq(buf, &flags);

I tested your series applied to v5.14-rc1 on the PS3
and it seems to be working OK.

Tested-by: Geoff Levand <geoff@infradead.org>

