Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A34C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 18:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6102C225A9
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 18:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502218AbgLNSwy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 13:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731829AbgLNSwi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 13:52:38 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6300C0613D3;
        Mon, 14 Dec 2020 10:51:57 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id d17so24016372ejy.9;
        Mon, 14 Dec 2020 10:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kmEWL9N858FqTq18xXGT1VCd7aIAPnn5gZrMzk+8WhI=;
        b=Afo/cIHYdCXKfH752KDHu2O8NkEAZVkf5WOf6ECkwK6ARDFUB9yPT62H0/v8tHgR61
         xevdbRVodazqrMPywJcq0YpH6GAk0IBsIBbAhWWqt9ZMLBqKJ6a9hLu/PipJmUyfGTPo
         Abtg9nUqww/AxeLq/yWXA+dVCSXjo/w6S3SRRs1iXQqrqXPDtKhg1/ET/sIw1wiEq0ZW
         8QKetn2wA0RdciaRs+/YQmdpA6LHbt84IdWgBoWFF/o/lW5ASQssnMQiBqM5PjbMgPh4
         ec4PusS/fQfZ4OjwHcIGGAX00j+4UJPzU7p++7M5Zqc5naun3uQUz+YC2pdd2zVCQL4O
         RbVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kmEWL9N858FqTq18xXGT1VCd7aIAPnn5gZrMzk+8WhI=;
        b=CuFahRSrWno3ZCr8AEge5PGnT6iH0DLkZng9NWHwkfzdM5ZzCF+hpzlTxqAjZDV8vL
         GrDOnirnC3qZLTZNhCWrdQ0CpSbZKLFPsEsTf1VCrrTvV9oYqgvws/8xzgwm8mGCaZGk
         fK/4p3hk9u/8mRTgKEJTYY38YCcHpBUAB9PWqzlhHJxr/EflEpB2z8YLG8KocYENcS5i
         cE2KO8aiJamF44bf9cpvTw9jiqUEzofE9a6UoVEwTiyVPAERXVKla94nXpdaj4HXUJA5
         sWjHW+czeL44uHNkt/mcgQu8XPtdCHTLFYCtrpFHg68lpTk51NxbKLMZG34gcxoVI+jM
         AkzA==
X-Gm-Message-State: AOAM532iX1sLMkEhNOxq9aD4dd0h+3rLm+SFMnftxKcx+pOr2w13u028
        oEaXDsj6Urp38f2jghsn7Jo=
X-Google-Smtp-Source: ABdhPJxrxN33uribVUjiZKJXkD851HxLdfh1YJ77xbUmPGGGbrrluHT7/CfnPcd+aN6YyEq31DBpFQ==
X-Received: by 2002:a17:907:4271:: with SMTP id nq1mr19563127ejb.358.1607971916648;
        Mon, 14 Dec 2020 10:51:56 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id h23sm14154997ejg.37.2020.12.14.10.51.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 10:51:56 -0800 (PST)
Message-ID: <f23cea390a812f5126dbb232b1944e5499cc40dc.camel@gmail.com>
Subject: Re: [PATCH v2 1/6] scsi: ufs: Remove stringize operator '#'
 restriction
From:   Bean Huo <huobean@gmail.com>
To:     Joe Perches <joe@perches.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 14 Dec 2020 19:51:55 +0100
In-Reply-To: <ade665cbfa138d1851343576caad84a61e904c46.camel@perches.com>
References: <20201214161502.13440-1-huobean@gmail.com>
         <20201214161502.13440-2-huobean@gmail.com>
         <ade665cbfa138d1851343576caad84a61e904c46.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-14 at 08:46 -0800, Joe Perches wrote:
> > However, we have other cases, the symbol and enum name are not the
> > same,
> > we can redefine EM/EMe, but there will introduce some redundant
> > codes.
> > This patch is to remove this restriction, let others reuse the
> > current
> > EM/EMe definition.
> 
> I think the other way (adding new definitions for the cases when the
> name and string are different) is less error prone.
> 
yes, agree with you, but here it is ok, it is not too much copy/paste.

> > diff --git a/include/trace/events/ufs.h
> > b/include/trace/events/ufs.h
> 
> []
> > +#define
> > UFS_LINK_STATES                                              \
> > +     EM(UIC_LINK_OFF_STATE, "UIC_LINK_OFF_STATE")            \
> > +     EM(UIC_LINK_ACTIVE_STATE, "UIC_LINK_ACTIVE_STATE,")     \
> 
> For instance:
> 
> Like here where you added an unnecessary and unwanted comma

Thanks, I will fix it in next version.

Bean


