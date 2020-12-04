Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C806C4361B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 08:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38D9225A9
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 08:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgLDI3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 03:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgLDI3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 03:29:40 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D43C061A4F;
        Fri,  4 Dec 2020 00:29:00 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id lt17so7496533ejb.3;
        Fri, 04 Dec 2020 00:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VuVUapvBZOzCnZE6zLH38tG2kKBhvbLGgD5G9pUcXeI=;
        b=hneajKGE+rdsfgBYYw3euCHldlrLYtD1ukxgFTpwxxtSVtDWTHKhHE4hFghC/tyYYy
         uaXNnf2OhdosXlN+BkBwweQDHGS1uI5HP6rWPMuZ+LavT1I/oNGlAQBJ0Hh5UXj2Aecg
         zzi3mARA/ZIwgoElv4L/gOT4keBgDgE43Q7/jXEoGSHwlw7Z767FN2Joe6sjKGekPY4l
         IXJ/+UFj4+BFLX450SYy+btZUI+Pp0oMUYjF9M2q0ggDmLCbo4FLmtAZpP+xteYF3HZt
         fK7UOtus9sL3GYbY91VDyQuHafSdNOLGFLo0Ep9rwD2X26dY5VytJDhjkXVPAJuTqqYR
         D/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VuVUapvBZOzCnZE6zLH38tG2kKBhvbLGgD5G9pUcXeI=;
        b=JzTpbhnNt89BQtDsvu5HjmYMFKVtxmiL2TPOR9wX4OpLRy0gb3PFtuSutGdru0jIhO
         PFPlFAgJ0j2+Y9gptStbsG/5hXSh8aeedGwi5H/CZP22llqBFX3dgo+U3VGIJLVPokCn
         wWIqdOV/MoeGoTw124fW5Bh1sdM2ozlcFoqjy7AZ1K9jQ6vdN3+/p4UHDg6Bv/cqyfWD
         4EbGsr5zOtBQxYlfomzy8CwOlRS5xKeseu3hLdRhC29uEwoRSqomRZ9Yk+aegkXZAwy9
         Vw1PyC5rZxrbZeSTXrr/gfxfbpX89sRbFRID2dcA0X0RhqlRaQm/W/Hb9dGOnDgbTM1Z
         fZLQ==
X-Gm-Message-State: AOAM530oOiP6pQVdr+UF1nYnOyiggZnj++60CuRM+8Xo/RdTENG3qPj2
        b0dyqxmywoGXrk9Lh+ZIOcE=
X-Google-Smtp-Source: ABdhPJxMORfce2kUQwReZ47M86buZbLdNB+F//gpPJa8iRX+0NAazl0bgcTgWX+pNWP/NM8NR/UWNg==
X-Received: by 2002:a17:906:1412:: with SMTP id p18mr6177462ejc.480.1607070538872;
        Fri, 04 Dec 2020 00:28:58 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id q19sm2589800ejz.90.2020.12.04.00.28.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Dec 2020 00:28:58 -0800 (PST)
Message-ID: <2a682e702de6eb431c7f204962d3e54b67dbd2ff.camel@gmail.com>
Subject: Re: [PATCH 2/3] scsi: ufs: Keep device power on only
 fWriteBoosterBufferFlushDuringHibernate == 1
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 04 Dec 2020 09:28:57 +0100
In-Reply-To: <c4e810873ac9e15735369d0159fbb664@codeaurora.org>
References: <20201130181143.5739-1-huobean@gmail.com>
         <20201130181143.5739-3-huobean@gmail.com>
         <c4e810873ac9e15735369d0159fbb664@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-12-04 at 11:26 +0800, Can Guo wrote:
> > 
> >        if (!ufshcd_is_wb_allowed(hba))
> >                return false;
> > +
> > +     if (!hba->dev_info.is_hibern8_wb_flush)
> > +             return false;
> 
> The check is in the wrong place - even if say
> fWriteBoosterBufferFlushDuringHibernate is failed to be enabled,
> ufshcd_wb_need_flush() still needs to reflect the fact that whether
> the wb buffer needs to be flushed or not - it should not be decided
> by the flag.
> 
Can,
you are right, let me take it out from this function, and see if
acceptable.

Thanks,
Bean

> Thanks,
> 
> Can Guo.

