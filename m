Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE5CC61DA4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 21:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbjBNVtj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 16:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBNVti (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 16:49:38 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8598D24C89
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 13:49:37 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id o8so16044052pls.11
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 13:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=K24hJmuuzDCWGJfa7cedDOeMiqAh7XOOikUOicrsYLk=;
        b=Nop4t4j/Ezoqqr7Wxz59BFFcsJEksG49eS0wzKJYp0Ewg6CRR2Z56e7MIKXOcTQroZ
         jmH+t/mxjQ/cE3U0i3+oUfIcqKyoLXqpDUBtpmA/0ewOc3LRubdiII7zMuWfo6pP5zs/
         U1qsI3khO4ndqEQ+91O3IXBhxmHP6OccfJk/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K24hJmuuzDCWGJfa7cedDOeMiqAh7XOOikUOicrsYLk=;
        b=kH9mz9IXp0/TQjaLKcnRx61Ie6hQ0uqYcvXThFkkhiQphWctpqXjXlMJmp28JeE8BN
         VHeLePHoNdOJpr6UskEJgHCy08cWKf7ieR1nPT+53Tz5OERljwEGHqgXr3hrOMnXY+y5
         2U8snAhLhN/C0GX/Iug3PXhCj2xmOAjupqDKkQgSLLc1zOAn/MxIItsAa9F7/zA+d+GU
         P/8V6GDp42XQu6iBtYUAo5megFlv9yT+1F9rQrCfPiquMsAsuagXH5z1jZcVzdGd1aEs
         ugXI9RMvE1+7HYgj26wuNDScwpL2GzzgP9quhC/FkOKREVBm0bQjRrdAXb6N3TKYMrWg
         K7mg==
X-Gm-Message-State: AO0yUKUl5VG8tQT+7Z6utIseq5Pzfpymps8gAIDLFXXL8cB2a83qOzF6
        q9ARF1GYlvE/fYihjFZ9Dj7SHw==
X-Google-Smtp-Source: AK7set9ijZSYts9u+A6XDClyLfPMQi8mabb6Pc9oedy/Kth90eU0jMozxH4xbvCYUALbaqjcfNSilA==
X-Received: by 2002:a17:90b:4b42:b0:234:5eb:2177 with SMTP id mi2-20020a17090b4b4200b0023405eb2177mr403521pjb.9.1676411376902;
        Tue, 14 Feb 2023 13:49:36 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id q35-20020a17090a1b2600b002343bac52aesm30108pjq.7.2023.02.14.13.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:49:36 -0800 (PST)
Message-ID: <63ec01f0.170a0220.94c76.011e@mx.google.com>
X-Google-Original-Message-ID: <202302141348.@keescook>
Date:   Tue, 14 Feb 2023 13:49:35 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        James Bottomley <James.Bottomley@steeleye.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] [v2] scsi: ipr: work around fortify-string warning
References: <20230214132831.2118392-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214132831.2118392-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 14, 2023 at 02:28:08PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The ipr_log_vpd_compact() function triggers a fortified memcpy() warning
> about a potential string overflow with all versions of clang:

Perhaps this is arch or config specific? I haven't been able to reproduce
this for some reason.

-- 
Kees Cook
