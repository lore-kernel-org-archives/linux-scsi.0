Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D91C12002
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 20:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F41D613AF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 20:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhGNUnp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 16:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhGNUno (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 16:43:44 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C7DC06175F
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 13:40:51 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id q18-20020a1ce9120000b02901f259f3a250so2248931wmc.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 13:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=bOQjpmSIA7YyHAxSoRAkAktZIRMCMVVSK6LgfcZUiww=;
        b=YsE1POirAbSC1IVcgax1KVBC8kvJhL3o8niszgIhiFBlagd2kuT4/FiGBZWtitf7tJ
         XKg8P0UbfMIMJI8rnVnTp1icxLPNjgnEsO/pJe03AxHOq88uZWSpiCzBQKuvg82LItms
         KCiBtm80rRkjN+OvaK89DURoSAukcrVm6wLXtYOmWfD7JbAwJdMjlYNq1NvdXLRgs/fu
         Bq2Xsts3cs9H+C/ySYCgTlyiD1wV6WVGWYWxSzdx1sNnMZLYqeEOfwqh+FVkEZIMFcoV
         jNjTTjSjb7Y/mr4I0tEagwBrc6NrmSxH7inJIiHBJAPKZOfJOvG35xn32uiIV6kpVUKc
         yOgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=bOQjpmSIA7YyHAxSoRAkAktZIRMCMVVSK6LgfcZUiww=;
        b=qZMlJfrLNFzORPh0eQYQSJfPvyAYxFSVNOjKpjXkW9RR9rnR5bDz4Mx+/H37O4OKhu
         cGsSwplyzso3GAxfh7+x/iHh35DOxqgxBFPNbGH8HqvWFl9zUjavqeFEvWo3do5GUcMh
         IYmr70JcygW1Mvf0vm5mSDrCS+I68has7YF1uCIhmmoBeRp0Rz7fvZWENXtLbkybXaX3
         LHOdynUPrOs5IDKXzPW94YcgIew45JQzL795HhkAM0gd3wbGW6JyptL0F+GYlyRRVtj3
         Bov7IHWbG0HPzvEP48cfsLF9djOAXTSmmqVm3lzNOyudEv1fM1vBtGu4/XTIi+2WSm9s
         RQWw==
X-Gm-Message-State: AOAM530JNjT7qaYfRsSE3O/J32u5merwJGtSrvtRzEYaHVJk8+2cTg1B
        Vjy6JncB1SJoLly851V3dfA=
X-Google-Smtp-Source: ABdhPJwwBSJ/oiGLQCZpD0ubwy20IasCi7+ImolLu/NxqEZgzgHJr4G0bdU0eOjAKqkMkVBilA3u2w==
X-Received: by 2002:a7b:c1cd:: with SMTP id a13mr5944750wmj.75.1626295250214;
        Wed, 14 Jul 2021 13:40:50 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec65.dynamic.kabel-deutschland.de. [95.91.236.101])
        by smtp.googlemail.com with ESMTPSA id r17sm6213433wmq.13.2021.07.14.13.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 13:40:49 -0700 (PDT)
Message-ID: <e4ebdfe7df2fffe22d0b0942304ad9c4e6f13411.camel@gmail.com>
Subject: Re: [PATCH v2 05/19] scsi: ufs: Use DECLARE_COMPLETION_ONSTACK()
 where appropriate
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Date:   Wed, 14 Jul 2021 22:40:48 +0200
In-Reply-To: <20210709202638.9480-7-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
         <20210709202638.9480-7-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-07-09 at 13:26 -0700, Bart Van Assche wrote:
> From Documentation/scheduler/completion.rst: "When a completion is
> declared
> 
> as a local variable within a function, then the initialization should
> 
> always use DECLARE_COMPLETION_ONSTACK() explicitly, not just to make
> 
> lockdep happy, but also to make it clear that limited scope had been
> 
> considered and is intentional."
> 
> 
> 
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> 
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> 
> Cc: Can Guo <cang@codeaurora.org>
> 
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> 
> Cc: Avri Altman <avri.altman@wdc.com>
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

