Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84918C12002
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 21:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61725613D2
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 21:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhGNVZV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhGNVZT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 17:25:19 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773FEC06175F;
        Wed, 14 Jul 2021 14:22:27 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id m11-20020a05600c3b0bb0290228f19cb433so4759882wms.0;
        Wed, 14 Jul 2021 14:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=CIRnAXS4kpWdvJcn2XozsC0b0WhxNiBbiK8rnYsAOog=;
        b=i/0D/Lo4dBaqJRALJ4RSwYbveiNR3saCBf1mPZUInMxD82/qO+QJNvSxdTUTmG+Rfn
         VBwva0TJgM3RJuLjuslygW46LuCW1uEDm6dI5dGDxCSP0qa4fJi4dSw5wyWNOB+AiWjv
         gOKF7e7wRXueiEZGP0Wi0ZBZr+BieCmQAc6kpK/fLKgqIf9Apj/qoX8B7Ho/CMPJvAZL
         XB2xm/67POuQKWWDcv2AFf3CLvgRZ1RQuKsxtDZZThnOwBJRwRFJRGro8/w6H3PQyrcR
         Z65aNit6OI5gyOsHoAOLsjE6m4GxLZtDxums9XUAAYpC5z2BTToqP1dEgBwhJfXIi+YJ
         eryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CIRnAXS4kpWdvJcn2XozsC0b0WhxNiBbiK8rnYsAOog=;
        b=aBmT4cwLiYSqikVZXi7VrUI6AVm2tWtQl5MBcVWRMZjYL4vil6f/S98CorkAK4Ge5J
         66BS9zgT3hAQSFWTbxvYwEt5sjCn3vScH3T9co1kDAOS+0i4WbNJLCEQlIF0/GPMt5st
         pjpWTH35S/m25U1RuHSfKBh9qS5+wPrdFzzGx9nMJSCG3FK8n0WLqjlgm2mse2cHtkNa
         MevJ/s8uvx0atWmBhYjltjh4gpiKexAMGukiVqtiS2Abb0NqTCsExehoYwn8KKk+ZRmx
         kEFKhJojO/J52MRn0+/2YZarOTYcv5+R1ACGQgIUnF6wzkYi3AEly13UJWb8xiH5vIwP
         LF3Q==
X-Gm-Message-State: AOAM532tF8feTBlac9kNw77n6v/LwUYIKUZ9NVoUAiJxxKGO6XX7E6BE
        p83+B8JHxlTmPeBguhJeb+g=
X-Google-Smtp-Source: ABdhPJwDrCz9FsDZKoBjaAgL29ifocM6k4N6g7tfFpetT5EWq/0u75rtEoJnjOn7zd8cHYK67Uylvw==
X-Received: by 2002:a7b:c452:: with SMTP id l18mr6146605wmi.164.1626297746109;
        Wed, 14 Jul 2021 14:22:26 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec65.dynamic.kabel-deutschland.de. [95.91.236.101])
        by smtp.googlemail.com with ESMTPSA id v2sm3825333wro.48.2021.07.14.14.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 14:22:25 -0700 (PDT)
Message-ID: <5f6b14c0a86e419b05102599602307a4782d8c64.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: add missing host_lock in setup_xfer_req
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Wed, 14 Jul 2021 23:22:24 +0200
In-Reply-To: <b0cd26d0-6ebc-b633-8669-a558597cc91d@acm.org>
References: <20210701005117.3846179-1-jaegeuk@kernel.org>
         <38432018-e8bf-f9f3-00bf-cd4b81c95c88@acm.org>
         <69b367bc44084f901d0d71fb8f9633ea7e5df36b.camel@gmail.com>
         <b0cd26d0-6ebc-b633-8669-a558597cc91d@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-14 at 11:09 -0700, Bart Van Assche wrote:
> On 7/13/21 12:45 PM, Bean Huo wrote:
> 
> > This change only impacts on the Samsung exynos platform. and Can's
> > optimization patch is to optimise the host_lock,, and removed
> > host_lock, now add back in this function makes sense to me.
> > but I am thinking how about hba->host_sem?
> 
> 
> Hi Bean,
> 
> 
> 
> Calls of exynos_ufs_specify_nexus_t_xfer_req() must be serialized,
> hence 
> 
> Jaegeuks' patch. This function is called from the I/O submission path
> so 
> 
> performance matters. My understanding is that spinlocks have less 
> 
> overhead than semaphores. Hence the choice for a spinlock.
> 
> 
> 
> Thanks,

> 
Bart,

After adding spin_lock/unlock_irqsave()
in ufshcd_vops_setup_xfer_req(), there will be 4 times of call of
host_lock lock/unlock in ufshcd_send_command(). Reduce the code scope
of protection, but increase the number of calls to
spin_lock/unlock_irqsave().  Almost each sub-funciton
in ufshcd_send_command() calls spin_lock/unlock_irqsave(). why not
directly take spin_lock/unlock_irqsave() away from each sub-fun, and
increase the scope in ufshcd_send_command()?

Bean







> Bart

