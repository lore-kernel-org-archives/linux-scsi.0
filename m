Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F2DC4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C7C6222B6
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgLOJnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 04:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgLOJnS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 04:43:18 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62113C06179C;
        Tue, 15 Dec 2020 01:42:38 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id ga15so26710773ejb.4;
        Tue, 15 Dec 2020 01:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sbp7bazvQ/Kg/Kx4Lh7f+HzqSKdsXL4CqYh5zWYbn/Q=;
        b=t6rETd8BKnh9JPwR+wiUit332ATV4QQgbXbdlcS7VK4HhpteabSiMrJPrQWZUc1bxk
         rgUgKkfy+CX8IGNZj4ONxneMVg0rL9NbDNXk6Lnf0D3D/37hRX+YgUgLAKowX3F6WN9s
         W2Dobap8Dn0UQiYkgW2MS0yqPIabGP7XcEfRvHjyfcdFkRF/J+z9C4rW9UMteWErlRH/
         fLxUnkCaQsFKEAqf6Ew7IxigWuaaUBMiAKesebEitcTO+lCBkJuTgQ9DBLWH/Bjl0egY
         7vdSqWtWoHdebps5n9yqHUAZ2YPgTErQZjHp+1DMubGJUFGznL9hRAstABRDYqimsMyc
         xKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sbp7bazvQ/Kg/Kx4Lh7f+HzqSKdsXL4CqYh5zWYbn/Q=;
        b=XQkwoOn0RUGYd2GIvZoEmy8ZUckhVrLCOO6DOAHSVsu9OdImgCUDK5mAU6hK2YMHjo
         v5g3GVZQ0GxryJbpKJlPoh1M5hvICa0EWK6/gWDcNRBRPCacVCjefmkjm3TBpaqauqjV
         1pNoc65+43L7VpWJ7YWsd0cN6kiUfAFpLe9Q/+LL0A6VEptT3+XnxQjfb/6qModzAxgs
         +5IIgXvqibhnL04a22NB1F1sjCXVO3zRXFTidCWv1xlFff9Wm6kbx4uCLufggPg2+ORq
         qk4x26xsgCMInxwNmKd71AdKQm3cABwiXtidsOgpwWglYRfnRSstzFMqkAWllcUWj17G
         FXBA==
X-Gm-Message-State: AOAM531Vdfw7cpR9FNL9vi8PWJ+ZWg09XgB0rSVblmMR83dgrTGgVLdG
        Wz0sT6lSAs/MKMUTDLESFiE=
X-Google-Smtp-Source: ABdhPJx6kGVuVXxkYSZKFdzdahp4EjS2CrcsC3/+ew4xrg1WGte4KZ/gpGX/T8bK/uxCyJFaM2JHuQ==
X-Received: by 2002:a17:906:a29a:: with SMTP id i26mr25934867ejz.45.1608025357153;
        Tue, 15 Dec 2020 01:42:37 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id m7sm943808ejo.125.2020.12.15.01.42.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Dec 2020 01:42:36 -0800 (PST)
Message-ID: <615bb13dc394dac2b56fa60787e1841d2db12462.camel@gmail.com>
Subject: Re: [PATCH v4 3/6] scsi: ufs: Group UFS WB related flags to struct
 ufs_dev_info
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 15 Dec 2020 10:42:36 +0100
In-Reply-To: <1608022873.10163.17.camel@mtkswgap22>
References: <20201211140035.20016-1-huobean@gmail.com>
         <20201211140035.20016-4-huobean@gmail.com>
         <1608022873.10163.17.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-15 at 17:01 +0800, Stanley Chu wrote:
> > +     bool    wb_buf_flush_enabled;
> > +     u8      wb_dedicated_lu;
> > +     u8      b_wb_buffer_type;
> > +     u32     d_wb_alloc_units;
> > +
> > +     bool    b_rpm_dev_flush_capable;
> > +     u8      b_presrv_uspc_en;
> 
> Perhaps we could unify the style of these WB related stuff to wb_* ?

yes, agree. I will change them.

> 
> Besides, I am not sure if using tab instead space between the type
> and
> name in this struct is a good idea.
> 
using space, in addition single space, type and parameter names are
mixed. 


use space:

 /* UFS WB related flags */
bool wb_enabled;
bool wb_buf_flush_enabled;
u8
wb_dedicated_lu;
u8 b_wb_buffer_type;
u32 d_wb_alloc_units;

use table:

 /* UFS WB related flags */
bool    wb_enabled;
bool    wb_buf_flush_enabled;
u8      wb_dedicated_lu;
u8      b_wb_buffer_type;
u32     d_wb_alloc_units;

I think, the result is very clear comparing above two examples. yes,
there is no explicit stipulation that we must use space or tab. Both
styles exist in Linux. Maybe this is just matter of personal interest.


Bean

> Thanks,
> Stanley Chu

