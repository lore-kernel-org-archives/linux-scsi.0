Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB30C636CD
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Feb 2023 22:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjBGWy6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Feb 2023 17:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjBGWy5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2023 17:54:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B046B3E637
        for <linux-scsi@vger.kernel.org>; Tue,  7 Feb 2023 14:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675810447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eS+aatdit4HbVwWsONGRhggGP/LK/Nx2vVC/BHTKQkY=;
        b=calOvhaEsSKtCfbY+VTCiAjLwD8b1HpGYoHLUXZtnFICBu+Ezio5kqaIyLUc2AiCzwYROt
        x41v8UtKmeNdijyB2WrkyHLPfGxEl4g8TzfwHNoGjXkpQRnO9Jyxewppib9dT2QCfpmosx
        16I+ckBnBASVhbHFfc/08frZy7zI2SU=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-31-uoToxPKrMqGpTkkFYcp3CA-1; Tue, 07 Feb 2023 17:54:06 -0500
X-MC-Unique: uoToxPKrMqGpTkkFYcp3CA-1
Received: by mail-qk1-f199.google.com with SMTP id a198-20020ae9e8cf000000b007259083a3c8so10804185qkg.7
        for <linux-scsi@vger.kernel.org>; Tue, 07 Feb 2023 14:54:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eS+aatdit4HbVwWsONGRhggGP/LK/Nx2vVC/BHTKQkY=;
        b=cGIeYyXcgI8He4nahUzgEpV8OAKhJqzHyWxajPAV3TQ9MIfp1Zm4DwUgRu/JjmB0H0
         L3UvRKMxFI7alRo99AerWRsBRrW5+BF9gSg8syxfuTUifbsiGa5N5tcRWqcvmq5NY71F
         Qd0BjG2Np97Xpg7rvSl3zbJU/nGR0glIVbZSB5NA7uOUxINvsTeofQ0rf1QCzexSIIqH
         TP95QMu+S1ILXW5TIS0Hy9rYh+ITO8cXGUEFPTbR2hYACX8bRox0DOMJRGT6C0jaNVNj
         HvoyVYeCvlOBsLr/VMfBDv3Fr40EarCLs98DgGEW5ZZK9w12JmVELU5V1zAJ1ygqYMgx
         RG6g==
X-Gm-Message-State: AO0yUKVRSDwTvfcIdPUwq+GSLMrFW8z+mdj+xIf1u437BQlyns4vStag
        q4R/vr8HiRTpJ4b+Ub5erx7wuhhR3qc8gO/8aI+dYI8pyKxxMplpBtv+UlRzS/LktsHZtngo7rF
        uXNPY+gqzTCbIB+2HBCUcPA==
X-Received: by 2002:a05:622a:1346:b0:3b8:6ae9:b104 with SMTP id w6-20020a05622a134600b003b86ae9b104mr8933940qtk.17.1675810445925;
        Tue, 07 Feb 2023 14:54:05 -0800 (PST)
X-Google-Smtp-Source: AK7set97zZlaJwlx99nJnLQD+QvklamhuaFSDZ3+DrQvTZLaE/T2ZW6BEba83sshy5amQGUGJ0TyZg==
X-Received: by 2002:a05:622a:1346:b0:3b8:6ae9:b104 with SMTP id w6-20020a05622a134600b003b86ae9b104mr8933922qtk.17.1675810445736;
        Tue, 07 Feb 2023 14:54:05 -0800 (PST)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id o6-20020ac85546000000b003b2ea9b76d0sm10219355qtr.34.2023.02.07.14.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 14:54:05 -0800 (PST)
Date:   Tue, 7 Feb 2023 17:54:03 -0500
From:   Adrien Thierry <athierry@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: probe hba and add lus synchronously
Message-ID: <Y+LWi3MrLQV/se/j@fedora>
References: <20230202182116.38334-1-athierry@redhat.com>
 <0e955a31-1d3a-beca-4581-dbcdefc47674@acm.org>
 <Y91xPMM+/BfaRLle@fedora>
 <90e4fb52-6b09-00d9-7591-7140b859ed15@acm.org>
 <Y914yu4rSqvpSoRZ@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y914yu4rSqvpSoRZ@fedora>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> Another solution could be to change the kernel Kconfigs to force
> DEVFREQ_GOV_SIMPLE_ONDEMAND (and possibly other devfreq-related options as
> well) to be builtin when SCSI_UFSHCD is enabled (builtin or module). Is
> that what you meant?

After diving more into this, I could not find a way in the Kconfig 
language to force a module to be builtin, so I'm not sure if the idea is 
implementable.

I had another idea. Instead of running the whole ufshcd_async_scan()
function synchronously (and potentially slow down boot time on Android
devices as you mentioned), we could only move devfreq initialization out
of the async routine, ie. this chunk of code:

drivers/ufs/core/ufshcd.c:8140

        if (ufshcd_is_clkscaling_supported(hba)) {
                memcpy(&hba->clk_scaling.saved_pwr_info.info,
                        &hba->pwr_info,
                        sizeof(struct ufs_pa_layer_attr)); 
                hba->clk_scaling.saved_pwr_info.is_valid = true;
                hba->clk_scaling.is_allowed = true;

                ret = ufshcd_devfreq_init(hba);
                if (ret)
                        goto out;

                hba->clk_scaling.is_enabled = true;
                ufshcd_init_clk_scaling_sysfs(hba);
        }

I tested this idea on the Qualcomm sa8540p-ride, and UFS clock scaling
seems to be working without issue. No error on boot and the
/sys/kernel/tracing/events/ufs/ufshcd_clk_scaling traces are similar with
and without the change when running fio to put UFS under load.

Do you think this could be an acceptable compromise for boot time? It
should not slow things down too much since the really time-consuming parts
(ie. UFS initialization) would still be in the async routine.

Best,

Adrien

