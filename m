Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24D0C07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 19:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC98A611AC
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 19:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhGMTsj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 15:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhGMTsi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 15:48:38 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C20C0613DD;
        Tue, 13 Jul 2021 12:45:48 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id a5-20020a7bc1c50000b02901e3bbe0939bso3179298wmj.0;
        Tue, 13 Jul 2021 12:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=twofhOfokTrL7AjKMUPk/vtbpxwXjO2o5DC219RSFfs=;
        b=c1DwQ0ZGJ46oPjJ0hVnuMAsX6d1xadhlnM77DaReX92RJ2qDHc6TmNkoRHaVW7jWCU
         6ekXDROww6SyGRDDJwZxsiM1wWzikMVgKLbuS1VFNJv6muS6EhTZ5uGLIRtOcoqHlM3u
         WYgvXYF+PRhLtjIerztS66wLa/6EieaR63tCu6/JBNABlz7hk9tpaUkPPx57Bs+dsa72
         dXmwpM2BVv+Jl0k+PjB5rEJNKgmkSRDkOfQ1ZIDhj8uFj3pVm5rGLdGU94lOQhwoQJNw
         /kOcXh1+u9PlcrYSWVWm45EIqMjJkS08trGDfqxSrjf25+e/uB3UfnE+VEElN/vEjMED
         GOaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=twofhOfokTrL7AjKMUPk/vtbpxwXjO2o5DC219RSFfs=;
        b=C7mBkq0JhCCGCuvZ/sPC2ZSt8VXzrP8YpiQZXrYHS/o6yqfvAYhskSwWlVyb7AMMxa
         LWSHzH0toi0lVzwPMgTyIQu4HEOsxq9I598/N1aGaFiFc1XJMPu5QwslSe3eVYVnJQej
         E9RvrwtTBirSYI4W3WpbAEjgdOkbGqcaY+UpOEqJnlNOCAszGpZ1/Yas50fI5kRR1iv0
         wzfUcUFNJ8Lr5AbntJl46nctdB6xy/FqCbNyQugGl9wp+TCYkwcqaWyID0x4GkoJAnSK
         S6BikV7pB2cCLvCd7cqcdOFVJrHyt31+HjpoG9KGtUu+QQQBxjfY6wowOKAlKBnvUx9Q
         +5mg==
X-Gm-Message-State: AOAM533yCgceAgi4W6nhBEL9ZizGHdWUgyQ+czTbJHT1nw/opd2yo8Mr
        PgRvKXhd3ftfzEFQKT201C0=
X-Google-Smtp-Source: ABdhPJwzgxURELsIwIxUPGQRVz5jBeQGoLeefwidmU/vL+k7N/y3xOJAuZ8bA2jERz18u2EuEP/MRA==
X-Received: by 2002:a05:600c:a07:: with SMTP id z7mr1085763wmp.160.1626205546754;
        Tue, 13 Jul 2021 12:45:46 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec65.dynamic.kabel-deutschland.de. [95.91.236.101])
        by smtp.googlemail.com with ESMTPSA id m15sm2883wmc.20.2021.07.13.12.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 12:45:46 -0700 (PDT)
Message-ID: <69b367bc44084f901d0d71fb8f9633ea7e5df36b.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: add missing host_lock in setup_xfer_req
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Tue, 13 Jul 2021 21:45:45 +0200
In-Reply-To: <38432018-e8bf-f9f3-00bf-cd4b81c95c88@acm.org>
References: <20210701005117.3846179-1-jaegeuk@kernel.org>
         <38432018-e8bf-f9f3-00bf-cd4b81c95c88@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-07-13 at 12:06 -0700, Bart Van Assche wrote:
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -1229,8 +1229,13 @@ static inline int
> > ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
> >    static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba
> > *hba, int tag,
> >                                        bool is_scsi_cmd)
> >    {
> > -     if (hba->vops && hba->vops->setup_xfer_req)
> > -             return hba->vops->setup_xfer_req(hba, tag,
> > is_scsi_cmd);
> > +     if (hba->vops && hba->vops->setup_xfer_req) {
> > +             unsigned long flags;
> > +
> > +             spin_lock_irqsave(hba->host->host_lock, flags);
> > +             hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
> > +             spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +     }
> >    }
> >    
> >    static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba
> > *hba,
> 
> 
> Can anyone help with reviewing this patch?
> 
> 
> 
> Thanks,
> 
> 
> 
Hi Bart,
This change only impacts on the Samsung exynos platform. and Can's
optimization patch is to optimise the host_lock,, and removed
host_lock, now add back in this function makes sense to me.
but I am thinking how about hba->host_sem?

Bean

Bean

> Bart.

