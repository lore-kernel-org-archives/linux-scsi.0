Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E88BC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 07:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AFAB60D07
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 07:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhJ3HVW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Oct 2021 03:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbhJ3HVV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Oct 2021 03:21:21 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ADDC061570;
        Sat, 30 Oct 2021 00:18:51 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id z11-20020a1c7e0b000000b0030db7b70b6bso13413396wmc.1;
        Sat, 30 Oct 2021 00:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=oVcNCx2IbAJ0wX8mqH7Uz5fTRfj9jXWXASNFwbc4lx0=;
        b=KU7L3Ss03GDMunJYmFi8WaDD0j+MButs+kfWEFlcesCOaoo5pbTqia3pGZLy2aBrM6
         ZRXvBgXkPNQ8Exfsar/s2k8t34YkJLJYyb0OyWR425v3swxoCKRLE611YE89QwD7fkSZ
         5eX//L16kVspCZSPUhWGLZC3wrVCmWy9ArHFSOnHlJnFK8ZeTWKgS9Z4bvsT46s5Y8/n
         S4uJrUSWPoU3Yrr87BJL8s4aOjqdUu+KkBpwX7HkEJf76bWMsv0sCSevDSnFMTNxgceJ
         bEiPZ+tzl2Cio3ez+hukkDbX0dBCNQHCTIdqF3a+5sHT9fHeyg3kJCEfeXbvIm/JnDoY
         Yobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oVcNCx2IbAJ0wX8mqH7Uz5fTRfj9jXWXASNFwbc4lx0=;
        b=JUO+MRAHHHItdS+2suhF1zVvJg+sxK4tgpJDjclOONLVRh805LehuJA9YdYHgnZ6M2
         P3RuacZ+Hj5JcK2cYrRirGjmMAeo959/0VcbT/OKpSR2UfjdotXyxaCCF1an+lgt6DVh
         OCn6MakcZQyiGq1ayj20b5flHbcL7IpooLqwF9vJltsBcSdpy0lrroEMnyLw5l2DI3v8
         /wS/KKMthj3DZceEt0jrLvTDDokzUn4e2LmqgoN0qCU1wCp3ZDGwwo993anOZFqCHrTt
         vF2lVpbYLQW77okWZTT973cgDsVkya2bISbnoElXby7P1i/rAV8i3sej20f2XnTOwav1
         sUOg==
X-Gm-Message-State: AOAM5314nLceBBHg4hktHg1yG1pIlz5DyjO1HBcNWFJZxJMj9n5I0MfI
        UwGDTRCwn++fvhmfdYiBdSY=
X-Google-Smtp-Source: ABdhPJwVMiAS5hNCE9cSf1+mvLG+NkA/S/EMLY/bXbmZtcT0LqnYL8sx9FRH2m0vc+/SREa+K4kCQQ==
X-Received: by 2002:a1c:a405:: with SMTP id n5mr16388836wme.49.1635578330546;
        Sat, 30 Oct 2021 00:18:50 -0700 (PDT)
Received: from p200300e94719c92a81a9947a27df1b21.dip0.t-ipconnect.de (p200300e94719c92a81a9947a27df1b21.dip0.t-ipconnect.de. [2003:e9:4719:c92a:81a9:947a:27df:1b21])
        by smtp.googlemail.com with ESMTPSA id l20sm12318956wmq.42.2021.10.30.00.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 00:18:50 -0700 (PDT)
Message-ID: <29a3fd17a9a8b369af4adefb2b2b1eaabc56cb8c.camel@gmail.com>
Subject: Re: [PATCH v2 0/2] Clean UFS HPB 2.0
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 30 Oct 2021 09:18:49 +0200
In-Reply-To: <20211029194931.293826-1-huobean@gmail.com>
References: <20211029194931.293826-1-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ignore this series of patches, because Avri's latest V3 already
contains these changes.


On Fri, 2021-10-29 at 21:49 +0200, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Hi Martin and  Bart,
> 
> These patches are based on Avri's patch "scsi: ufs: ufshpb: Remove
> HPB2.0 flows",
> which has been applied to 5.15/scsi-fixes.
> 
> v1-v2:
>     fix typoes in the commit message
> 
> Bean Huo (2):
>   scsi: core: Ignore the UFSHPB preparation result
>   scsi: ufshpb: Delete ufshpb_set_write_buf_cmd()
> 
>  drivers/scsi/ufs/ufshcd.c | 11 +++++------
>  drivers/scsi/ufs/ufshpb.c | 14 --------------
>  2 files changed, 5 insertions(+), 20 deletions(-)
> 

