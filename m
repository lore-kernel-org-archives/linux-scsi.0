Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0723EC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 10:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7FB865257
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 10:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhCIKHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 05:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhCIKHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 05:07:32 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DD7C06174A;
        Tue,  9 Mar 2021 02:07:32 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ci14so26170324ejc.7;
        Tue, 09 Mar 2021 02:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=zQQLnrfmFYyRxQbeO0Z9BFMti7UWADJY5NT45xDzPA0=;
        b=qxc7Yh/FkO/28Gdh3p+cFdihgDn8yV4jcF00RJpvd3hg06n2ufVjJDH9A5dFy9m0de
         qg5DNJFZ2mAjvuGZ3sGWrV5MX74zp1bXvCcRrKP/b57IEtv1i932RbHlPsBj6H36AdCG
         6AE4uT50XGSeyLHBOdibNnoSxylzltbigOo4XXMa8eLxBQVnvZfSUcsmFI9nOHlo30mt
         9j3L7VwrE5CjJDkc79Fclksi7tdTHzxdqZ2yysXUZSJjn4gZ6AVg6Ck9e8FYSTIYjvOj
         yhJyopLKyigw3eQbGRXveVj5niYl1RLrHtC9W1xB4J8iGwp4CFy3Qcru3CjIbbbOufxm
         IgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zQQLnrfmFYyRxQbeO0Z9BFMti7UWADJY5NT45xDzPA0=;
        b=awN21lPnGKC1FNXthG2CVVTvrUwGZaYBt3hZoOnuOq+cYXCEKI+R6nVmgSly+2JvJM
         Ll4XV8/+fsKL+zJL8Vjap9RlVsz1Ukb81xYfMqEORLhUASdIW9mqk0C1O4BZ4NyG4JOV
         QkUo8eSwzaAgN0EaI7pWAcDo18jULWGX4h0TRbRh8OF+uNVVUIqsQBvsVtowW/BHza0D
         cBbbpgdHPZi6HvoqDF35m2XPhcj0etEL/h6QUZjXO6VtCylqy9fxWh299G0u9wLhQeht
         F52rgkO0I/0kO7JMJGI72xk+VJXQv/nbz7XsNZbuSezIOTAw4sBrNdlACbL3+VTFRyUU
         93rw==
X-Gm-Message-State: AOAM531dI8zUZ28gXDc+AO0PjLemglTpp8EP/JSE0Jt4U9eVU/aAIDFf
        bYtWHtdCr0sqW8kCHndhryE=
X-Google-Smtp-Source: ABdhPJwLpaovU6jEYp4H3TkfHeAJz5PnepLV4ZyLrsc7OL5ZgUYXRnvAXVp5jlqBD36A8kOlWvJZag==
X-Received: by 2002:a17:906:68c1:: with SMTP id y1mr19352126ejr.289.1615284451049;
        Tue, 09 Mar 2021 02:07:31 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id c20sm8053367eja.22.2021.03.09.02.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 02:07:30 -0800 (PST)
Message-ID: <134e4d8df284cfd0fed911bce6e43a52c0a965bc.camel@gmail.com>
Subject: Re: [PATCH] scsi:ufs: remove duplicate include in ufshcd
From:   Bean Huo <huobean@gmail.com>
To:     menglong8.dong@gmail.com, cang@codeaurora.org
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, jaegeuk@kernel.org, asutoshd@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>
Date:   Tue, 09 Mar 2021 11:07:29 +0100
In-Reply-To: <20210306114706.217873-1-zhang.yunkai@zte.com.cn>
References: <20210306114706.217873-1-zhang.yunkai@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2021-03-06 at 03:47 -0800, menglong8.dong@gmail.com wrote:
> From: Zhang Yunkai <zhang.yunkai@zte.com.cn>
> 
> 
> 
> 'blkdev.h' included in 'ufshcd.c' is duplicated.
> 
> It is also included in the 18th line.
> 
> 
> 
> Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Reviewed-by: Bean Huo <beanhuo@micron.com>

