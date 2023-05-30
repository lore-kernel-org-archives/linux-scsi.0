Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97488C77B73
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 23:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbjE3XVu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 19:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbjE3XVt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 19:21:49 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CE9E5D
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 16:21:21 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64d426e63baso5702118b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 16:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685488880; x=1688080880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=olkd5FdK39xwOU4GbWWKQgW5dE56bKupA6Kog3J0D9U=;
        b=I66TxfywFbovbwxMYfgVqGu6OQ15EAfC3r2Nk3gU4AlgjbxZUqZpUbVpAQIfdtnc0h
         FXdv3YrEUG2H/4wiPbkwiLFyuNcTd0PSOSnje+7kLQbCtU2x4t9OprLMMRCowpallEeS
         F/GnpmvW0w9OTMOmfTk+HT/pzqBqo7VJ/JVhM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685488880; x=1688080880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olkd5FdK39xwOU4GbWWKQgW5dE56bKupA6Kog3J0D9U=;
        b=UP/b97YMUXhMsNIbO5zMFO8qkSHko0FKsfIHRv6xCrj0hIU34PBhg0IIrduKy5WCur
         NpW8q6GBVDxQXhnYiTSzHO6jJ6Te3CVywsTj9VRlDKY4s4A6cuygy4ttkujw9ptdGCsN
         s6IJP6h4nc5NYT3RHGRQopN3jpPf+/9GYCteD/zOgjx67EHF/yV5nahAQ+sE36W9M89h
         Crh92Kf8QTLllljbbY9bbRZMb62/dE4YhUCtARWpOzvyipSbPJLjlbKnNlEfymbWDBEw
         iNYvWXbwL7Y/Qw2Xv2XVSz5DiaDn+DBsGDUbXcaoMwUkbvxTZFkUJ26sGS0O/XM0kMuA
         C5hA==
X-Gm-Message-State: AC+VfDwbPIpOTw1xIev4WkT9v3covGivJo8gC8n9JxlK9es6gNBk1pHG
        GvpZv1XRBAzVp4evJ8GFudrJjg==
X-Google-Smtp-Source: ACHHUZ5L6QnQe2Ow2yj0s6as1ruiWEChEcxKhwrITISgxHUHXQuY8n8FjIRUt7C3pCP0LPYNw5yo5w==
X-Received: by 2002:a05:6a00:1787:b0:645:cfb0:2779 with SMTP id s7-20020a056a00178700b00645cfb02779mr4255573pfg.26.1685488880576;
        Tue, 30 May 2023 16:21:20 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id u25-20020a62ed19000000b0063f2e729127sm2171189pfh.144.2023.05.30.16.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 16:21:20 -0700 (PDT)
Date:   Tue, 30 May 2023 16:21:19 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Replace all non-returning strlcpy with strscpy
Message-ID: <202305301621.3D086C4C@keescook>
References: <20230530164131.987213-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530164131.987213-1-azeemshaikh38@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 30, 2023 at 04:41:31PM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> No return values were used, so direct replacement is safe.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
