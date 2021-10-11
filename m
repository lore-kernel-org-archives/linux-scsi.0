Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F489C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 06:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 705CC60E9C
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 06:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbhJKGzB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 02:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbhJKGzA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2021 02:55:00 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD797C061570
        for <linux-scsi@vger.kernel.org>; Sun, 10 Oct 2021 23:53:00 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e12so52646017wra.4
        for <linux-scsi@vger.kernel.org>; Sun, 10 Oct 2021 23:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=xkZFpz7blKJwekeS5LX7/rnU72HuU26i3y9yTfo5Kts=;
        b=kjNBjwSb5adVo8P4uwzULmtx4hw83x8NoW1e3YyWwvnlWN5OsnTT31ZA2OYN4fEIgx
         bRAKLg7dVfvukvEcdUCexQtGL7ZiyDkzUlWxHGkGmnMCKxfenS/FIt0nEXN7IlEKGAq6
         2cDKb/Mb6H9lCR/FcEmBWQTMrqNRPFSqgjkL25d7C9XDREHLFR9GuucExIfKajv8+34E
         qPVj1z1Td6+Mp6PhVf2HO2aLn+i2aNiiLMPVCgxWShbZ1CuDEgnPI57d3IgeRRJBKS+1
         OcvKLIXCifC/6m8ZqPUd8hJ0IhSO7uq3A7IdjECS8roWKBkBkyYsTpTXRXnxbnDyQmQX
         fOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=xkZFpz7blKJwekeS5LX7/rnU72HuU26i3y9yTfo5Kts=;
        b=IWqdI7epJMcOffaMffyvu7XsbFH1JPdpmFS50HOXIxN6hm4p70R3Eo3Eswlqyd/n/Q
         VOSDJUesxrbCW8e/EapbbuTjeGW28kr0wcyfhwM3SQ0LoTfCEWmowamyHJzdfW2l0WVg
         t03mE/5e80YDPw3m+PFqC4vDYcuS7+BeefS8aHPc6CbJgjOmKQ7agkkRHxPaPonnuivZ
         XQ4GorG5p9KG1pB55WA0VovWwdP06uX04pqSRkAibhiYqclRJ7nieJkx2BjfDGFYslwK
         gjqugO6VLX0zkRJhW+a590lqBpcwa6EVEEn12is2SydSqB9YaOWXTRN63Hm0vHIYYmGf
         7lIw==
X-Gm-Message-State: AOAM532vDVQS3LkcRXkq6OLLoHZv7h879kv5fIPlzsQGUOG2s5sGVge1
        qYI1+N175/sM4Ms6R49pClI=
X-Google-Smtp-Source: ABdhPJw+jD/NjVISlPmQDNU5/YwPQ0nkzynUY3ux9uH2wt4zBsF0ppC/kgLSyvUV7U4zo9RQ586C3Q==
X-Received: by 2002:adf:a745:: with SMTP id e5mr22323297wrd.406.1633935179553;
        Sun, 10 Oct 2021 23:52:59 -0700 (PDT)
Received: from p200300e94717cf90f2d50f07879b9054.dip0.t-ipconnect.de (p200300e94717cf90f2d50f07879b9054.dip0.t-ipconnect.de. [2003:e9:4717:cf90:f2d5:f07:879b:9054])
        by smtp.googlemail.com with ESMTPSA id l2sm6979550wrw.42.2021.10.10.23.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 23:52:59 -0700 (PDT)
Message-ID: <9786cf49c8edaf9b298c26a057af39865374c9d5.camel@gmail.com>
Subject: Re: [PATCH v4] scsi: ufs: support vops pre suspend for mediatek to
 disable auto-hibern8
From:   Bean Huo <huobean@gmail.com>
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        jonathan.hsu@mediatek.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com, mikebi@micron.com
Date:   Mon, 11 Oct 2021 08:52:58 +0200
In-Reply-To: <20211006054705.21885-1-peter.wang@mediatek.com>
References: <20211006054705.21885-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-10-06 at 13:47 +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> 
> 
> Mediatek UFS design need disable auto-hibern8 before suspend.
> 
> This patch introduce an solution to do pre suspned before SSU
> 
> (sleep) command.
> 
> 
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Hi Peter,
Looks like the older version of MTK UFSHCI driver also needs this
patch. Probably fix tag is needed. 


Reviewed-by: Bean Huo <beanhuo@micron.com>

Kind regards,
Bean

