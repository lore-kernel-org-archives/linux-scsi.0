Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9C4C56202
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 21:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAD2E20866
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 21:09:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g7LSYe/1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgKXVJ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 16:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729619AbgKXVJZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 16:09:25 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168FAC0613D6;
        Tue, 24 Nov 2020 13:09:23 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id k9so15718754ejc.11;
        Tue, 24 Nov 2020 13:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=elrmmGmMMQ6PzIopqvZQCkanN6h0/gWDnjrJZkGJIrc=;
        b=g7LSYe/1dvjbcmdkl2nhyDWaLYIFni5VjHt4WQ/sh6N4iEqA9z4kUOjkpDf/ZTbbsb
         geuhN8jGiWp9hCsnMWIAfw9neXc1C82DlAgzW8v+vNCLtYbilVlfHhLogZtDm+Ggs6g7
         rNQ4Ux8H0Q4jp41z8sKlhyeBNd7hTE81Y06Rcpj/xz7BjJJIJc3EL2vPVY+FmcZocYBK
         +P4lu6pswz1/nVv3upEM3bTW7GBJnyRtM1EVAo8flLsOde5HWzHxXFN6/TsnGDb1YP6m
         BDjqmrJfBTs/3Nq2qCsMbLVMJ5Z9GDlft5E6XTpAYu7FrXhk44MVVVfowJlT3Yx7uBUU
         bkvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=elrmmGmMMQ6PzIopqvZQCkanN6h0/gWDnjrJZkGJIrc=;
        b=Wcx4oBxZd6wm8f6ZTPmqmXI8L2iqrBAZ1B7uO27RyT+MDxrYhBekSPwD6tvkczQs7p
         LzUzvkDwi1jGJq4R3+t2m6+SqyjMRK0huKpFiMR50PbslHOcl+g4YBVKUI7wH+SR/yNu
         GHocYjQue7s7zJypak9iJFbeZ0I4CVqmYCUknuhDkVRSprW+We4Zgup5kbmVVgDdBfo5
         kFQXF/iDD0vIEYvPGiGEFhhteUUgZD/JUvz1rAK4KgrhJp7lCtN86NqP/UimrOikSe5C
         YBEylzt+G9cJ2xKZMHlnjLBL4NvPs2NFHJJgmPiVV6N7AhlXLt6gROyFNnXWg0sgpYIT
         bojQ==
X-Gm-Message-State: AOAM5314OYanR9p3cm9TFZSIG+X/NF+zoomVwxNBS5S45c4OwCS1mRi2
        b/IRLgghTXuYtJzObGQ8ITk=
X-Google-Smtp-Source: ABdhPJw+oOzt0sqIybHqz+LalDY0mFf5wSqrIieAWHVKK2WTxgTVcNENN+x2eHJPL6OZB9sIwONulw==
X-Received: by 2002:a17:906:490:: with SMTP id f16mr353412eja.12.1606252161779;
        Tue, 24 Nov 2020 13:09:21 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee2a.dynamic.kabel-deutschland.de. [95.91.238.42])
        by smtp.googlemail.com with ESMTPSA id v8sm52468edt.3.2020.11.24.13.09.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Nov 2020 13:09:21 -0800 (PST)
Message-ID: <9070660d115dd96c70bc3cc90d5c7dab833f36a8.camel@gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Refector ufshcd_setup_clocks() to
 remove skip_ref_clk
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 24 Nov 2020 22:09:18 +0100
In-Reply-To: <1606202906-14485-2-git-send-email-cang@codeaurora.org>
References: <1606202906-14485-1-git-send-email-cang@codeaurora.org>
         <1606202906-14485-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-11-23 at 23:28 -0800, Can Guo wrote:
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -229,6 +229,8 @@ struct ufs_dev_cmd {
>   * @max_freq: maximum frequency supported by the clock
>   * @min_freq: min frequency that can be used for clock scaling
>   * @curr_freq: indicates the current frequency that it is set to
> + * @always_on_while_link_active: indicate that the clk should not be
> disabled if
> +                                link is still active
>   * @enabled: variable to check against multiple enable/disable
>   */
>  struct ufs_clk_info {
> @@ -238,6 +240,7 @@ struct ufs_clk_info {
>         u32 max_freq;
>         u32 min_freq;
>         u32 curr_freq;
> +       bool always_on_while_link_active;

Can,
using a sentence as a parameter name looks a little bit clumsy to me.
The meaning has been explained in the comments section. How about
simplify it and in line with other parameters in the structure?

Thanks,
Bean 

>         bool enabled;
>  };
>  

