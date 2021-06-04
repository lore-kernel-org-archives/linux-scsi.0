Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4A8C4743D
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 18:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B37A3613F4
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 18:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhFDSZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 14:25:04 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:44975 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFDSZE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 14:25:04 -0400
Received: by mail-pg1-f178.google.com with SMTP id y11so384117pgp.11
        for <linux-scsi@vger.kernel.org>; Fri, 04 Jun 2021 11:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UX1G2MyuSMoI9qtV/IxvY2Ox2XX3g0K693XM4XnGuQs=;
        b=brEmXwIeWk511PUJq83cxnT/omO9wa73pzK4DBRRfyw6IWWvIhLLWGnHkQu0cTXiId
         osUMl3zdzBrUmpwlIil/zSWrkJ02MAiC0TmLGGOkxs0YiRQNoKaQ23SXe129ISop5J0w
         psq9IuXjXRSwfDxo+lWbs78DFv2LT0K2q7H8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UX1G2MyuSMoI9qtV/IxvY2Ox2XX3g0K693XM4XnGuQs=;
        b=s/stebg1Mu2iOvYiwRhk/p/dWZCWg8eYKLQ2/54I21zrDDp5rdfqYMYFrmK3HmI+cB
         qO7AoLwteL5I/7QaV1BReKvGTBqzt24gximqUsXtkXRU6MBelYkBiQr92/SUqqIfPpbg
         W0bNmWZ2fMY/eXaEFzTPHezeSYtRzvtFKG3OV69tJDZpO9CF7Q9H+2NP2dW5gyHf6pYL
         3W1uJ5b/sNMe3L3kMGJ5R5iEWTOmg/8XgD1uK5JeR0lXVvQnYXE0Avwtt1NovvSJQF4f
         4zMwPyN/cwg6wnpkkwi8BI+NBHVJOmrUfpVBxCFAQ7qeJIgBYFcyNf/z2s5vjJ+e3Kjk
         LAnw==
X-Gm-Message-State: AOAM5306zVPweR9RJ/eflzWmYpRGvtjOee4YTYtqwyi3Wx7rl2X2roe8
        hP8Odq1hYB3QKw3rCqGTqilQGg==
X-Google-Smtp-Source: ABdhPJx/yQn8DS3AzA7xRJxe/WtzLqKi+h8G2XgHEWQGo8dMvTira3vRnBtv6+zBFbCRjJOcdsXa1w==
X-Received: by 2002:a62:148e:0:b029:2e4:e5a5:7e33 with SMTP id 136-20020a62148e0000b02902e4e5a57e33mr5846985pfu.9.1622830937626;
        Fri, 04 Jun 2021 11:22:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t13sm2352888pfh.97.2021.06.04.11.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 11:22:17 -0700 (PDT)
Date:   Fri, 4 Jun 2021 11:22:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: mpi3mr: Fix fall-through warning for Clang
Message-ID: <202106041121.41CF254@keescook>
References: <20210604023530.GA180997@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604023530.GA180997@embeddedor>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 03, 2021 at 09:35:30PM -0500, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a
> fall-through warning by explicitly adding a break statement instead
> of just letting the code fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Looks right.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
