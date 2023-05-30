Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95C8C77B73
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 23:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbjE3XSY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 19:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbjE3XSL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 19:18:11 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4929111D
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 16:17:50 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso4445949a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 16:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685488669; x=1688080669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IRZs/nBDDXW8hF6u2e1Wo2UXvn96rgveDiIWpS60WGY=;
        b=PEbjfLdxYEC5I+F/kOYnuFocUEL0W6zEKS+ZeM8Tp8kj+0TX4vs7zeOjMUUxpEMaUg
         2UkmXa1W8MWhwREV0tpYJAOUSqoNySdONFhTLeKsPtAGpm5i3p8qreXro7IMSJuKZ5Ao
         b5gNXVVDzX4e2emY9dZjDpPCK25JKyQlCcRuM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685488669; x=1688080669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRZs/nBDDXW8hF6u2e1Wo2UXvn96rgveDiIWpS60WGY=;
        b=jQQRg5r2kgoLH5UdVowOpIraa8EMPA9fsO0TcA4zUdBVkQMDwyrgPubY6HFMoST0WQ
         9lHivAVi12DSQG0ZErQahUt2E+Oax77mixD4HpVnKbxK4w9Dzxh3M9BzkplccyyOXkm/
         zScIv6lgtun0byadsydrMuF+BI3Z08mJmItssSoPNp1/iRosnTei5uR+Vk/DODaePKx2
         AdGzIZbt9tr+dZ/h1Dqoe7JwIrnCITCpR/Xqy7HTZRPj+P+uYyuIqLwZMVsPTBLUaITZ
         yxUCQ9q/C1lqxDjeyDpgiT02riplLv+NYIdh+rW5VbMC8xCPZNwPJOhQYTQ/mGRPANNG
         Zauw==
X-Gm-Message-State: AC+VfDyerc7hkPJxVuvc09PkhTNnhjVLrqPPeGG85a3I7hof46/8lQKR
        1hNF7Sr9WC5Rss0Y141fyH3/dA==
X-Google-Smtp-Source: ACHHUZ6/bj4qVsM/B/G8XxPwHiN8FW4+MeCn8RZLVvQyrW0chzy85Wzd7JPVY1jU5UUXF9x7DFfebQ==
X-Received: by 2002:a17:903:244e:b0:1ae:5fb0:4256 with SMTP id l14-20020a170903244e00b001ae5fb04256mr4777826pls.57.1685488669724;
        Tue, 30 May 2023 16:17:49 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id c2-20020a170902b68200b001aaf2e7b06csm10739048pls.132.2023.05.30.16.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 16:17:49 -0700 (PDT)
Date:   Tue, 30 May 2023 16:17:48 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sym53c8xx: Replace all non-returning strlcpy with
 strscpy
Message-ID: <202305301617.2D0EC7BCA9@keescook>
References: <20230530160323.412484-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530160323.412484-1-azeemshaikh38@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 30, 2023 at 04:03:23PM +0000, Azeem Shaikh wrote:
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
