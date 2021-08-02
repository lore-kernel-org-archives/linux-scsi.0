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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9D7C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 12:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B28960EFD
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 12:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhHBMLw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 08:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbhHBMLw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 08:11:52 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECFBC06175F
        for <linux-scsi@vger.kernel.org>; Mon,  2 Aug 2021 05:11:41 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d8so21202609wrm.4
        for <linux-scsi@vger.kernel.org>; Mon, 02 Aug 2021 05:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=m6c4sRmLvdTF5IUNx9X9eEPcaog8tcfT64nS9Q0448w=;
        b=oK3I9G9C6uR8WQkDUHc94vUWQajqOoroIFY2xq7XnjlakbSFrb1ThTOT7TpKHLipIp
         svypQkA8f1SsrnQQMi42UWnFnTClYzRJoSBO+TdSbc1HJqi7wn8yjgb2zwEOxqcIAsTX
         5bYUuR7kgDW8Q7LY+V5SiD4TE4w86Cc30ZGZt48TpGMGKf9noxD4H0e8arKru1abcLiT
         3+eC+Zy7ZzYbZXhBgE2F36uy9bD5B95uHeZSnM74ZBYseAa3d6UbDxdnSji7222ldRxx
         +RVxKddcm008dvaLMVqnZRlh5Gdc7ni5TB7lfy0kKsJmKzlIrf0S/A/uv0Wf6GXupf+L
         FOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=m6c4sRmLvdTF5IUNx9X9eEPcaog8tcfT64nS9Q0448w=;
        b=saCvg1CrXs6jr73YcIPEhMuHXPlzJChN1/T1ZwJlK7KvGLB2L8hYjZB3ityqbOwE0O
         bg0fXnnD3DgM50Plc66NQuE9iyTlo9h1YrRDt48gvSPJWIQXVKpFTjuCQWTRPKG7gNG9
         2s7m8g3FIsTsNOe6cn/f0kqLelTYmIdSUqG3M7enHUyPDzVNsrHI9+mLgVEhqSpNdkcC
         2AwdFWNVmyLFxHRLQd+mayWJ54ZPUpVJ2x3j+CrBy2LiD0si+VvC0dPIGt71HoghXSVI
         echasW/1rF6AI20rp/jNXkn1EWVMWv00McRlEj8E376gL1vxumO87OKSkbFIkgvf0+K3
         Bfig==
X-Gm-Message-State: AOAM532aTIO2OzHRAxkZeRW5SUGgwjljFOuwo7267eTEMZIYhE0G/C2c
        VTVhmtvvVn35K1SqJd5gt3A=
X-Google-Smtp-Source: ABdhPJwx8Bk7GrTLtlyz5+f51Mh/yqMszm3YSPYV5TaFZriacNaQOmCIGAZlYiStemAcyhRhGJjWsQ==
X-Received: by 2002:a5d:5147:: with SMTP id u7mr17320916wrt.181.1627906300461;
        Mon, 02 Aug 2021 05:11:40 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id u11sm11424463wrt.89.2021.08.02.05.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 05:11:40 -0700 (PDT)
Message-ID: <b5c4456d588d5dc644acb90063469a8c01be000a.camel@gmail.com>
Subject: Re: [PATCH v3 13/18] scsi: ufs: Optimize SCSI command processing
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
Date:   Mon, 02 Aug 2021 14:11:39 +0200
In-Reply-To: <20210722033439.26550-14-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
         <20210722033439.26550-14-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-21 at 20:34 -0700, Bart Van Assche wrote:
> Use a spinlock to protect hba->outstanding_reqs instead of using
> atomic
> 
> operations to update this member variable.
> 
> 
> 
> This patch is a performance improvement because it reduces the number
> of
> 
> atomic operations in the hot path (test_and_clear_bit()) and because
> it
> 
> reduces the lock contention on the SCSI host lock. On my test setup
> this
> 
> patch improves IOPS by about 1%.
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

Reviewed-by: Bean Huo <beanhuo@micron.com>

