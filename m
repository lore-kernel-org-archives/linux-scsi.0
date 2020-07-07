Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC62C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 03:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2A6B206E2
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 03:09:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n60iyk8T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgGGDJr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 23:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgGGDJq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 23:09:46 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA00CC061755
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 20:09:46 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id md7so2756255pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2020 20:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=GSx1bT4SdYNNGySVBuLACJLZyLGWhFOan+2snuP4yyc=;
        b=n60iyk8TSMc3vAYz3nvLMJhQu6kwvoHa9l7VQCWMN6Nr2pRxIs5N2zDLFihtdtVvWe
         rk1u8fwxBNu1xANifex1PcWsON37+ZRZ+jWkGjtFzOEJy09/vcNfb0OOdNTD3DyNgJ04
         zVfuorp4LjoM749EGSFwzNA3mjaYsHrJ8EeNteIqSix3iFHg/jXToiC7WqkSydNDeU60
         npm5KTczVL/89WVMUNMiMwu1FufwFiNfJLgyZGadab+bbyqzprjOgsXd0nI3z15LWfLT
         4EQJXEGbVaKzF6KN/3+PBGV8yJiUyHEPAH6VAw86BIcGZzq8LDgqJzPPyZp6qCauR5TQ
         ZASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=GSx1bT4SdYNNGySVBuLACJLZyLGWhFOan+2snuP4yyc=;
        b=QHfivwE4CbBFsTPNqrBA/imENvHt619Nb/5hoRNzLl5NYsQg5z9a6JahcYlUrRlkyp
         hyTCuqLIwH0iOgcUcK4eq5xx81ryuq0Qqwm38Vukvwwj3AprjKXTWkvOHGrrZozJESY5
         QkqgezqFjKtu1mFYAZusKL/+x5r0FSfWSmCW7E8JJtKP6xl5l0exkrmwchOne7BaDt74
         MPUu9P4iya721VTq8i97/tZ3OgEVOqS/OO+9O8ZTyQ57aS+MdMGmf1NQ9HsVfvsBuGA3
         kk5UNP7D01GQdQyTHGtNAaYElKcbQz2ME0a4ZUyK45amLrzibwyCIdVXz0DgU9gTs0nQ
         EiMg==
X-Gm-Message-State: AOAM531rtn73fY9l9JrJ42mwH1xmPyn+4O8TY/0+/EJJHWpWREkPBrbB
        cekI9j3N/x3Bmh4TzizQkDGFNg==
X-Google-Smtp-Source: ABdhPJzJpOUGpyIrAzhJn0zt0rqaPV38yzhlx+vfI25d5Ck4wSSsY3JbDbzRHf293h7qe0iwmb9I5g==
X-Received: by 2002:a17:90a:7483:: with SMTP id p3mr2158077pjk.64.1594091386159;
        Mon, 06 Jul 2020 20:09:46 -0700 (PDT)
Received: from localhost ([122.172.40.201])
        by smtp.gmail.com with ESMTPSA id w1sm20880674pfq.53.2020.07.06.20.09.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 20:09:45 -0700 (PDT)
Date:   Tue, 7 Jul 2020 08:39:43 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Linux PM list <linux-pm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH -next] cpufreq: add stub for get_cpu_idle_time() to fix
 scsi/lpfc driver build
Message-ID: <20200707030943.xkocccy6qy2c3hrx@vireshk-i7>
References: <3a20bf20-247d-1242-dcd0-aef1bbc6e308@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3a20bf20-247d-1242-dcd0-aef1bbc6e308@infradead.org>
User-Agent: NeoMutt/20180716-391-311a52
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06-07-20, 09:44, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> To fix a build error in drivers/scsi/lpfc/lpfc_sli.c when
> CONFIG_CPU_FREQ is not set/enabled, add a stub function for
> get_cpu_idle_time() in <linux/cpufreq.h>.
> 
> ../drivers/scsi/lpfc/lpfc_sli.c: In function ‘lpfc_init_idle_stat_hb’:
> ../drivers/scsi/lpfc/lpfc_sli.c:7330:26: error: implicit declaration of function ‘get_cpu_idle_time’; did you mean ‘set_cpu_active’? [-Werror=implicit-function-declaration]

And why is lpfc_sli.c using a cpufreq (supposedly internal, i.e. for
cpufreq related parts) routine ? I think if you really need this, then
it should be moved to a better common place and let everyone use it.

I also see that drivers/macintosh/rack-meter.c has its own
implementation for this.

>    idle_stat->prev_idle = get_cpu_idle_time(i, &wall, 1);
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: linux-pm@vger.kernel.org
> Cc: James Smart <james.smart@broadcom.com>
> Cc: Dick Kennedy <dick.kennedy@broadcom.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  include/linux/cpufreq.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- linux-next-20200706.orig/include/linux/cpufreq.h
> +++ linux-next-20200706/include/linux/cpufreq.h
> @@ -237,6 +237,10 @@ static inline unsigned int cpufreq_get_h
>  {
>  	return 0;
>  }
> +static inline u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy)
> +{
> +	return 0;
> +}
>  static inline void disable_cpufreq(void) { }
>  #endif
>  

-- 
viresh
