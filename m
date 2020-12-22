Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7298C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 21:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A145322B2B
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 21:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgLVVJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 16:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbgLVVJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 16:09:40 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF34FC0613D3;
        Tue, 22 Dec 2020 13:08:59 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id cw27so14249347edb.5;
        Tue, 22 Dec 2020 13:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GHDD6k758sHyLbm3erfWNgoWWYdDW9BcqtWScl75Bq0=;
        b=fPo2VSkRWpZWaQFqj/NVNxUkZWVOHy8Zu2Hdn69c52GsvU1tnqIPoJ2OsDdAXlw6NE
         sER4Q3LIUEgirrRjdjpa8+hmSHjozQp2uMTD8h1xBHxlFGPuUffEY+FMFUf2Jjgav0u9
         6MKn5Xym/BWVJK8i06HBeVaOA0ttKyu6nQWTMILobWngpNkE+htqgjaeWc9XEv2hS0dM
         02ksBTdKodTczFsShy83tzZGCrv+JenaQoH+93zEXfdYgCEze/32KSL7E86C/Pekz7UL
         VeAjqqZGairLWFsRyFRcV+FKOTA8r1vOmZAw/jd4DIKcI6obUrXiBDSLRRtnI3jzxGOf
         k1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GHDD6k758sHyLbm3erfWNgoWWYdDW9BcqtWScl75Bq0=;
        b=slaTUz2KtuMCkXsphClPSOcmqV4y+bPqJpuL/742KJHRQ9C5QQ2fCwtuAmuSmXeotg
         oCDxdQm8fprqh126nodlxu8ZI5ZL8uyyFpwrpEeJt+dC+smPjrWjZR/rQWBlRFyVx451
         0MneTaZmEtJNGktEFDcZ7iqmq19yBDVEAg5EtEFqEH9nOv1dwDHyvalG1qC/GGDDCOYf
         E1okxRBzsaD4qJ+Swm9WkIe3K+48abGJt1ZNTR8irE2XrHG/+C7b0SL52FYJOQ6rspVT
         DuV5ffO+J9tQh8nmNRjT9yqwBeNtY7sNorX5LkVs9bVVZiqs229ER2CPiR+4skNOfYyB
         Ht/w==
X-Gm-Message-State: AOAM531gf6hTfDwZlKTwfxTo4opJNOM1nb2NfAwhMg2tiO0VSLihYMz9
        cd5S5PpP5Yg08rxI0QYsv4w=
X-Google-Smtp-Source: ABdhPJzX/K7wB0q+1HeUzTF1fduTX101xL+ab0pPI7CuigG//qkSPqrgOEyhCDrl0igGM0imWLX6Eg==
X-Received: by 2002:aa7:df91:: with SMTP id b17mr22467222edy.272.1608671338728;
        Tue, 22 Dec 2020 13:08:58 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id n20sm10663028ejo.83.2020.12.22.13.08.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Dec 2020 13:08:58 -0800 (PST)
Message-ID: <eee9f5b0a1f9e52a1ea569403cc183fb48dd77a9.camel@gmail.com>
Subject: Re: [PATCH v5 1/7] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, cang@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 22 Dec 2020 22:08:56 +0100
In-Reply-To: <4c15956660bd7305b0c095603bfa0e30c7f1610e.camel@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
         <20201215230519.15158-2-huobean@gmail.com>
         <1608617307.14045.3.camel@mtkswgap22>
         <4c15956660bd7305b0c095603bfa0e30c7f1610e.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-22 at 21:50 +0100, Bean Huo wrote:
> > 
> > May this operation race with UFS shutdown flow?
> > 
> > To be more clear, ufshcd_wb_ctrl() here may be executed after host
> > clock
> > is disabled by shutdown flow?
> > 
> > If yes, we need to avoid it.
> > 
> > Thanks,
> > Stanley Chu
> 
> Yes, it is quite possible, but who will mess up this on purpose?
> 
> ok, to counterbalance our concerns, I can add checkup:
> 
> 
> /* UFS device & link must be active before we change WB status */
> if (!ufshcd_is_ufs_dev_active(hba) || !ufshcd_is_link_active(hba))
>         return -EINVAL;
> 
> 
> how do you think about?
> 
> Bean

seems there are only auto_hibern8 and wb will issue command to UFS
device. if you think auto_hibern8 also needs this protection.

I will add in the next version patch, otherwise, just add this checkup
in the WB.

Look forward to your feedback!

Thanks,
Bean

