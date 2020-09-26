Return-Path: <SRS0=SrIF=DD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EEE8C4741F
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 23:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E191423976
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 23:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h2GnZYiV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgIZXxh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Sep 2020 19:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgIZXxh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Sep 2020 19:53:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B7DC0613CE;
        Sat, 26 Sep 2020 16:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=AShX6aYZtzolArgQidxcdKQkzqt3+K0Op6qSHxq81UM=; b=h2GnZYiVtOlMCAlnfX9OLPDvDw
        /LknYmtY3G1tOnL01mw9vaOZHAKuowHGsEJrtNxl31yIlhZgIBwdG+YZlyXH4akr5I6WcK/8/vqRw
        4G+XElvQ/lAHFwycllXXvalXSSfNELaWnOFLcKumsPYA6p8Vq+L2Iih5AoDxOtV2CEt8bXHvvOdVk
        R9f956okhDgGwj/jPBYWCkm4i/O0tm9w6NX4nvZ3XzMcRaMcFTj0/pX/vKsipqiIOgleqa+qM5+5f
        ZplQ4dp3MJGLhwRtwEjc05+fMBNEQQSgOQpBWPvaiGeMJtJUlE2Wt0ItZceNeYS+OGRdsOpOvE4Pv
        S/6XLksw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kMK0V-0005Ay-DM; Sat, 26 Sep 2020 23:53:35 +0000
Subject: Re: [v5 08/12] Add durable_name_printk
To:     Tony Asleson <tasleson@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-9-tasleson@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <fbd1b019-04ee-5fda-11c8-95fecf031113@infradead.org>
Date:   Sat, 26 Sep 2020 16:53:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200925161929.1136806-9-tasleson@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/25/20 9:19 AM, Tony Asleson wrote:
> Ideally block related code would standardize on using dev_printk,
> but dev_printk does change the user visible messages which is
> questionable.  Adding this function which adds the structured
> key/value durable name to the log entry.  It has the
> same signature as dev_printk.  In the future, code that
> is using this could easily transition to dev_printk when that
> becomes workable.
> 
> Signed-off-by: Tony Asleson <tasleson@redhat.com>
> ---
>  drivers/base/core.c        | 15 +++++++++++++++
>  include/linux/dev_printk.h |  5 +++++
>  2 files changed, 20 insertions(+)

Hi,

I suggest that these 2 new function names should be
	printk_durable_name()
and
	printk_durable_name_ratelimited()

Those names would be closer to the printk* family of
function names.  Of course, you can find exceptions to this,
like dev_printk(), but that is in the dev_*() family of
function names.


> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 72a93b041a2d..447b0ebc93af 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -3975,6 +3975,21 @@ void dev_printk(const char *level, const struct device *dev,
>  }
>  EXPORT_SYMBOL(dev_printk);
>  
> +void durable_name_printk(const char *level, const struct device *dev,
> +		const char *fmt, ...)
> +{
> +	size_t dictlen;
> +	va_list args;
> +	char dict[288];
> +
> +	dictlen = dev_durable_name(dev, dict, sizeof(dict));
> +
> +	va_start(args, fmt);
> +	vprintk_emit(0, level[1] - '0', dict, dictlen, fmt, args);
> +	va_end(args);
> +}
> +EXPORT_SYMBOL(durable_name_printk);
> +
>  #define define_dev_printk_level(func, kern_level)		\
>  void func(const struct device *dev, const char *fmt, ...)	\
>  {								\
> diff --git a/include/linux/dev_printk.h b/include/linux/dev_printk.h
> index 3028b644b4fb..4d57b940b692 100644
> --- a/include/linux/dev_printk.h
> +++ b/include/linux/dev_printk.h
> @@ -32,6 +32,11 @@ int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...);
>  __printf(3, 4) __cold
>  void dev_printk(const char *level, const struct device *dev,
>  		const char *fmt, ...);
> +
> +__printf(3, 4) __cold
> +void durable_name_printk(const char *level, const struct device *dev,
> +			const char *fmt, ...);
> +
>  __printf(2, 3) __cold
>  void _dev_emerg(const struct device *dev, const char *fmt, ...);
>  __printf(2, 3) __cold
> 

Thanks.
-- 
~Randy

