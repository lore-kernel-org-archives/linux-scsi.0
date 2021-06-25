Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B79C2B9F4
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 10:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97E3C61440
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 10:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhFYK34 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Jun 2021 06:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbhFYK3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jun 2021 06:29:49 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEE3C061766
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2021 03:27:28 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id nb6so14322314ejc.10
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2021 03:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=sYyv0sOb93svxXExhvnVrC3iNeEivbwHXKMcIQxdK/c=;
        b=RMFJy62QD2vpu1dA2Y6nZo8XB8EGUC8Ol3UAmErNxJqw9mXXbE3KUspnSPmjW8n5+H
         7ZEcnRUirtn4SCeFD4KXujoS0WiWMethNUTRhniNLmJjOBzL+2V6kZU0slilMDfxn3U2
         SRoQD1GVL34DkcopoqzbSg/dH3vlWJfn0lBS3h5JvMv20DTCwnkB392t/N8FyapVO23T
         xu5DfMJheEuxOwm61ti0L0TvHqnWroC6bvRu4zCqyGF+oWdRJKauRT8ctkvMR9MpJxt5
         P+5VNw1eNTsJt9vaP5goMpsg29eJfNDLrPgwtTaw80n4UUy7dJKmFQ2TNSkglAHqmo71
         9OVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=sYyv0sOb93svxXExhvnVrC3iNeEivbwHXKMcIQxdK/c=;
        b=d5tsgFISUvDWYWTbW4/LOwMrLU1IyVF6mzOes/Weo7AtA6qT1uW166DK2UeGqotWvn
         g1TJWegnz8KgDMGQIjYFQA7qBi2yL1B1+nqVXCXV9lDFi1ncfU1NXV7qwo9U5Dj/F6xB
         scGO30W0Oa/UILWjwNW6njMDNDSq1fbNhHJYuyzJffKKHisbwhoKUZsa2GFylFLI1Fu+
         Iw9T13TBSEVMow+EaSPGQteSpLj7i67FWxaN79vgzAM7tVWSH/3BECEQzbOdCLuG7xnw
         tXjdjvEgHakOxy6GhrrT/GvE8BYq8+smjqnNYnhqSxQ1T94TcSp008aNSfNdvtkecfsd
         3gJQ==
X-Gm-Message-State: AOAM530vv8aKdNuvbJ+ja+gg4HOIsUuQgFuiaSIgjNgjUEf/c0w839Hf
        NRcdFkhu/mLx9QioyTvsShk=
X-Google-Smtp-Source: ABdhPJxkXIHK6VO2qnH62RK0TAwMUUMQYCLVUA7T5K1U6+tUt+bIWLanCiXFyM63ZZGS3Euy6/M7uA==
X-Received: by 2002:a17:906:868e:: with SMTP id g14mr10104575ejx.45.1624616846740;
        Fri, 25 Jun 2021 03:27:26 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id dh23sm3648031edb.53.2021.06.25.03.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 03:27:26 -0700 (PDT)
Message-ID: <d6e6ad97257d6e154bf369b71eeed3e598c8a2f3.camel@gmail.com>
Subject: Re: [PATCH v2 1/3] ufs: Reduce code duplication in the runtime
 power managment implementation
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Yue Hu <huyue2@yulong.com>, Kiwoong Kim <kwmad.kim@samsung.com>
Date:   Fri, 25 Jun 2021 12:27:25 +0200
In-Reply-To: <20210624232957.6805-2-bvanassche@acm.org>
References: <20210624232957.6805-1-bvanassche@acm.org>
         <20210624232957.6805-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-06-24 at 16:29 -0700, Bart Van Assche wrote:
> Move the dev_get_drvdata() calls into the ufshcd_{system,runtime}_*()
> 
> functions. Remove ufshcd_runtime_idle() since it is empty. This patch
> 
> does not change any functionality.
> 
> 
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

looks good to me.

Reviewed-by: Bean Huo <beanhuo@micron.com>

