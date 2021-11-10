Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3483C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 18:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 974E76112F
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 18:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhKJSVH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 13:21:07 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:46944 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhKJSVF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 13:21:05 -0500
Received: by mail-pj1-f47.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so1273464pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2021 10:18:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AsL7ZHFSwjRAR7u0GUkljs7sWbxndmY0cFBzGwbkje0=;
        b=sIAYut+6KMQ8Sf2tK3r7s71Hw998g/q90VU3VEbs0eeMVNYCph++SLpUFrtxKvBGEW
         wlV+2fjH5FAgbUyssKn6o5enB/Vw8QaT9H6YFF0VX1ytjgpTNJqaJSuQv7jkq1k9xIp1
         ShjN50L5ipt71Eai2+tf57HYrRfG2T+YcBHaquri+BBANWCPIFbx8mTR98rOYNVuoEGU
         8iSEAGbd5a4SrRivCIzY6r+cdY8X2maAXYW7mzhZH8lX/Dgp37uJzcuOiKilN4fBkoUa
         9yW7T4MhbQtj7/XCTFmBDwGDreUABX+rBd92UDyJb3oFZnxPjF9HEgzXxxGIGWQPlFkI
         WAJw==
X-Gm-Message-State: AOAM533TexwvF1yo6dWTLRhFkjNsSdKPQk3RR4HoQbMvwlJBKSwkAKJE
        ktrUdPa0iY+poXPBKAx2X3BUYKfomlnPrw==
X-Google-Smtp-Source: ABdhPJzHwojcbASJgNz+wBz+hrkwU7wNAGior+EjAyIAj3c3WeZSw73jk/WQFdk+91ZvZ9/HPocg1w==
X-Received: by 2002:a17:902:ba84:b0:142:5514:8dd6 with SMTP id k4-20020a170902ba8400b0014255148dd6mr662639pls.19.1636568297327;
        Wed, 10 Nov 2021 10:18:17 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:b41d:11d3:d117:fe23])
        by smtp.gmail.com with ESMTPSA id i15sm327958pfu.151.2021.11.10.10.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 10:18:16 -0800 (PST)
Subject: Re: ufs: setting "hba" private pointer too late -- oops in
 ufshcd_devfreq_get_dev_status()
To:     Alexey Dobriyan <adobriyan@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com
Cc:     linux-scsi@vger.kernel.org
References: <YYvYGBuzZzAuNzxp@localhost.localdomain>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <831b95a6-c097-9425-a6a8-cc599a14614c@acm.org>
Date:   Wed, 10 Nov 2021 10:18:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YYvYGBuzZzAuNzxp@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/21 6:32 AM, Alexey Dobriyan wrote:
> I've stumbled into a race while working on an earlier kernel,
> but it looks like mainline is affected as well.
> 
>          err = ufshcd_init(hba, mmio_base, irq);
> 		async_schedule(ufshcd_async_scan, hba);
> 		ufshcd_add_lus(hba);
> 		if (ufshcd_is_clkscaling_supported(hba)) {
> 			[enable devfreq]
> 
>          platform_set_drvdata(pdev, hba);
> 
> Device's private pointer is set too late, as devfreq hook get HBA
> pointer from private data and uses it:
> 
> 	static int ufshcd_devfreq_get_dev_status(struct device *dev, struct devfreq_dev_status *stat)
> 	{
> 	        struct ufs_hba *hba = dev_get_drvdata(dev);
> 		if (!ufshcd_is_clkscaling_supported(hba))
> 			return -EINVAL;
> 
> Unable to handle kernel NULL pointer dereference at virtual address ...0f10
> pc :	ufshcd_devfreq_get_dev_status
> lr :	devfreq_simple_ondemand_func
> 	update_devfreq
> 	devfreq_monitor
> 
> 
> I reproduced it by turning async LU scan into sync, so it is easier to
> trigger.

Hi Alexey,

Thanks for having reported this. Do you perhaps plan to post a patch to 
fix this?

Thanks,

Bart.


