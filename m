Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6780AC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 08:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 292DA61420
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 08:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhD3Isi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Apr 2021 04:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhD3Ish (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2021 04:48:37 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5A1C06174A;
        Fri, 30 Apr 2021 01:47:49 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g10so13758997edb.0;
        Fri, 30 Apr 2021 01:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=c1KUEW+MS+1gubEu6Cp1Hn18QCF/UQb5u/emZ+73g34=;
        b=Asi+Xhuj1R9Qmc9qS7Ta3DJcFULEyM0ijfZj1gF8TLzgkTkuYlTDI++qcAh9EVVHkh
         AkegZ0DNFYH8dDvaAx0FUU5VMB0epvL1yWUdO1q1iG7VkSyORhWq6DK4JDUDotAqsIPG
         s3Fo1l/r2Ikq5oLWRBkmscpjhXljDWn9JJ7dg1+/SP9byw7wBQzZ0KC2mXh1HsMVYzGz
         aco89A3ErsqAA4C0JVdD7+qc6hRXm8W3Om2XxDD05wJGpVGl9BgyE4L1KAyawkkwTJC/
         w0//sUMeZEkLxVo6LPt5NhHUfYc8By8WNXumABqx6/3ZikIFulG9Ml8319q+sJhoZea+
         RMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=c1KUEW+MS+1gubEu6Cp1Hn18QCF/UQb5u/emZ+73g34=;
        b=MmxZwFk1E0hmWXBY5xw0kAiaiP+WVCwrjgVOaksGm2/Yr4VAuo0e723brhknDPbVwr
         OyDcCpO6QDXWegiABJuALW2mnrA3Kr+mdClUjj5PdfNxXjYM23IWRxbhRkBCV12GUHad
         KmpE/5oE6OHfzpduPjvJ6JwvgXruURPbzlOUcI/H6nEJoP3Nvaa4lT9LcQts1iikzATo
         F8bwTRDWS0uxVtiFrt6Ld1NLN+sHVuiVLoQ8XnhNk608VrQF0BAOw20iCPSWjSLsLpoh
         Yr1ECA3g51LB43Gz1GWFeAWfZYrsHojtKL4X0xn1fx7aV6snRuVYo1ZZKKm50htFa1+o
         WifA==
X-Gm-Message-State: AOAM5321G0CujQlUyOyKkYo9O3/gFU1A1aSKLRPfnk6qfItoFpaBMUIi
        aS+F6YlzRRf6AmDHacTRiIc=
X-Google-Smtp-Source: ABdhPJz9mR6F8JPImI2fXMKl0ZpfunQHOadZEf9NMuQZoORrQMe6dk/gs4iAnyGNMkqDavy0G/llzw==
X-Received: by 2002:a05:6402:37a:: with SMTP id s26mr4467257edw.159.1619772468236;
        Fri, 30 Apr 2021 01:47:48 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id mt26sm1543575ejc.32.2021.04.30.01.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 01:47:47 -0700 (PDT)
Message-ID: <3c5dde7cd24cf10707b682cce0cac74e5ac37e9b.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: remove redundant initialization of variable
From:   Bean Huo <huobean@gmail.com>
To:     keosung.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Daejun Park <daejun7.park@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
Date:   Fri, 30 Apr 2021 10:47:46 +0200
In-Reply-To: <2038148563.21619749381770.JavaMail.epsvc@epcpadp4>
References: <CGME20210430021419epcms2p402717e968615d301ba18341d28a828ee@epcms2p4>
         <2038148563.21619749381770.JavaMail.epsvc@epcpadp4>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-04-30 at 11:14 +0900, Keoseong Park wrote:
> The variable d_lu_wb_buf_alloc may be repeatedly initialized to 0 in
> a for-loop.
> 
> If the variable is set to a value other than 0, it exits the for-
> loop, so there is no need to reset it to 0.
> 
> 
> 
> Since lun and d_lu_wb_buf_alloc are just being used in a else
> statement inside a local scope, move the declaration of the variables
> to that scope.
> 
> 
> 
> Signed-off-by: Keoseong Park <keosung.park@samsung.com>

UFS Spec 3.1, bDeviceMaxWriteBoosterLUs is 01h, for LU dedicated buffer
mode, WriteBooster Buffer can be configured in only one logical unit.

Bean

