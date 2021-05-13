Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5026BC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 21:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C28B61076
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 21:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhEMVMt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 17:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbhEMVMt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 17:12:49 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6ACAC061574;
        Thu, 13 May 2021 14:11:38 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id l7so32537387edb.1;
        Thu, 13 May 2021 14:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ccm1ANNkF7ktIVVOd0ImVs+nS3U0CVzOXbPzh4549ds=;
        b=I1AshWsAmLAtAcvAiACAp9TQ0bnZ3IRkhL9mos8789Phnh9Ex59TyY5L3sqzCELI3B
         t1aiqiLQPKe/38XtaIqVwfEV84iLEeAC9oe/WOpcaRey2u7Ct+ATZaEtIhLyMzjdGTQO
         GX2MGr4vjI7YKgZliAlml5UF2UeBs/ZkMe/oQsPMK4nZ7/P6DAw7TWOr6IAtsPJNLMrj
         8WSfDp9pvPcI0TW0b3fTFKWqI3+UjqzqRbh6tWW4tS435cwl3tWh6lS1atAN99NEb6kQ
         JwwXdvT6pFyJeKMw3nJHshVeQ/CnG6K/9ahxsE+wO6jsJSpQPdfcEKdtFmPs8HC8re5y
         exwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ccm1ANNkF7ktIVVOd0ImVs+nS3U0CVzOXbPzh4549ds=;
        b=LD/pa7Nz/pNISDBo3qj34K7FFBWymsrkH7VFm9vafs8pavo1VlMoTo/p67trqmAGIT
         uyGahEOXNWmklPApaDxXQsq9BwztWusn+WF42StnzRFWKRfdejW+uCI2y/hAmT9JHz2Y
         ea6Wm6OOhAh4GwL4a9ef2OoqXzsiTUx7/tNvq0ith6CEICSaaZnnr/mN/GwBmpUZ5c4f
         uxVJBuRaV4i/0ua5QKRaEvdIG0Rfh0XKn2xDV5MpGzI/P7asrrucH1Ha/Cjus0CVUjtG
         1OCm48ZITgStGwvyDYRvJj+rKfcrTRfxrnTDkKdjMcVNUHyMcfvMFNuxrD/7Xbj/qQZO
         hjFw==
X-Gm-Message-State: AOAM533Fk2QjD63T9upW/E6TsnphYcSybhHgfN7VIGq0dLCJq0eDqJso
        +Q+qEtMD/kDnE/wdD45Mu7I=
X-Google-Smtp-Source: ABdhPJwt3zT6Dt0F6U4vkL0yttxVF/tDWP9klBZpNkBDvTEMIKIi071CXA3LWXzgZtvPfDIRNabzCA==
X-Received: by 2002:a50:bec7:: with SMTP id e7mr53657355edk.295.1620940297708;
        Thu, 13 May 2021 14:11:37 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id v18sm2177431ejg.63.2021.05.13.14.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 14:11:37 -0700 (PDT)
Message-ID: <51ddc84208e6f9b59c6c1b02b4b49872b999f556.camel@gmail.com>
Subject: Re: [PATCH v5 2/2] scsi: ufs: Add support for hba performance
 monitor
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 13 May 2021 23:11:36 +0200
In-Reply-To: <1619058521-35307-3-git-send-email-cang@codeaurora.org>
References: <1619058521-35307-1-git-send-email-cang@codeaurora.org>
         <1619058521-35307-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-04-21 at 19:28 -0700, Can Guo wrote:
> Add a new sysfs group which has nodes to monitor data/request
> transfer
> 
> performance. This sysfs group has nodes showing total
> sectors/requests
> 
> transferred, total busy time spent and max/min/avg/sum latencies.
> 
> 
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>

