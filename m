Return-Path: <SRS0=de5d=CV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15062C43461
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 07:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4A4C21D40
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 07:09:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="THtGOvni"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgILHJq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Sep 2020 03:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgILHJq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Sep 2020 03:09:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7892C061573;
        Sat, 12 Sep 2020 00:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UX+sELG/O2QlTkbk4dZbI5Ic1AnJp5qJR4pe5RJ3BhI=; b=THtGOvnijZZ6IFAddfcATZPhYt
        dv4o9zRVA9jd5pDgPjqnDN1nzCR+xlNk/Qy28gPUCPD/RW27CUaQDbc7NQamLdNCFDfqbaIaTchHm
        QsaqmtoKXG+WXq4KoEGvX5C4QrAtd3U+YrETxQfLb5tHVid/R8ooDRnzDave7xOAsye2+nAOdp/q5
        T6cuWAesZ1JjGizRjAGm+XJkWXG5nZ6jfZusQKjkZDTqU6MqDLcCnQnA3pMi4iJdQg13Ql2GTK2Th
        gh/IlVb3qBQfP7apTJt+3q7MsTcob0Cw7HyNrVkybaSYQ3pw8lG7QjGXCivSyO8OQwdBvvlHve3yJ
        6HC+iKLA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGzf0-0000Xp-Ji; Sat, 12 Sep 2020 07:09:22 +0000
Date:   Sat, 12 Sep 2020 08:09:22 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Balsundar P <balsundar.p@microsemi.com>, hch@infradead.org,
        Zou Wei <zou_wei@huawei.com>, Hannes Reinecke <hare@suse.de>,
        Sagar Biradar <Sagar.Biradar@microchip.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] scsi: aacraid: improve compat_ioctl handlers
Message-ID: <20200912070922.GA1945@infradead.org>
References: <20200908213715.3553098-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908213715.3553098-1-arnd@arndb.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 08, 2020 at 11:36:21PM +0200, Arnd Bergmann wrote:
> @@ -243,8 +244,23 @@ static int next_getadapter_fib(struct aac_dev * dev, void __user *arg)
>  	struct list_head * entry;
>  	unsigned long flags;
>  
> -	if(copy_from_user((void *)&f, arg, sizeof(struct fib_ioctl)))
> -		return -EFAULT;
> +	if (in_compat_syscall()) {
> +		struct compat_fib_ioctl {
> +			u32	fibctx;
> +			s32	wait;
> +			compat_uptr_t fib;
> +		} cf;

I find the struct declaration deep down in the function a little
annoying.

But otherwise this looks good;

Reviewed-by: Christoph Hellwig <hch@lst.de>
