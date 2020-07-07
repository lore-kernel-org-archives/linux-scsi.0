Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC17C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 19:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18EDC206E9
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 19:12:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ceID0A00"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgGGTMa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 15:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgGGTM3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 15:12:29 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0FCC061755
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 12:12:29 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p3so20442147pgh.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 12:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0rtJaW1CIzPceXxBix0lxHfsoz9kM4OvEzzeaIB/Qlw=;
        b=ceID0A00NrA30OVOP6NYq4VrjpFefqrNowNKF78SiRtAE0ngiys9+PwMWwIfntyo01
         yi2CFT0udAQi+IgcDwFwdcGVy2U27+L4jmMGx1bnN2/flKvhMUx6NgQAWs9wmKUFZjxi
         MVQhYZ/Wj2s2Z08zeIGykAvRo/e7naYuX3mnDXqSdBp8SIzws5Z/+0EyPLKWLwcv33Bg
         +PNZnqss+XsKtkKr+yS9FxecrZzX3LIgWVLXH5H6KmVEPu7jk9/ZmH0aUB4BJ9UIoP68
         SEiwH0p4NFdb1gWqwLuVNtluQP+Y57FbsUDck3C0wnV+utljzTXzUtlTc97KkRuQTePF
         iUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0rtJaW1CIzPceXxBix0lxHfsoz9kM4OvEzzeaIB/Qlw=;
        b=qw2rrtPAmHPLh4AFm3ZaS4UoYt25iznrTH/MH+aRJB8pqy1S91HP01Ugap/nHFGV3/
         Vu6pYLHvxVxyzDKrEaF91Pat7nxc+pARbqEAk91ah1Lv60Qd++MjgDk/FyDr2PRWTY5p
         RSmXmohRDPDWuLp72fA84D8XnvEJDq5yzku6CQLOv/wf1foV+gOPGSsHgHHOTUYirprP
         p6BrOaaQWk8bx7TL336kYACmofQuPIk+GCNMTaCFTIILQBEnx3mrtlsMQ7VZkl798Q4Z
         hq29+LXfRx63eBlB9U7MsqqcnPV98hEnoGl6f73gZu84kyzFfKSINs2J+32jGhSz+rh/
         mpaw==
X-Gm-Message-State: AOAM530PZYqxAoUPNgkYnBiO66sTHigkr1r/T4FoR5+RivLWAWN4toV/
        60zcE6NFqrdN1ZJFcLSiuR2iFQ==
X-Google-Smtp-Source: ABdhPJz4jB7vLBFupmCXgOMuEVP6OtK7G/BZfdP66EdVG353GXSkCV8xaY4vmbYi9/KG0QDjXJuaig==
X-Received: by 2002:a65:46c9:: with SMTP id n9mr44234585pgr.89.1594149148446;
        Tue, 07 Jul 2020 12:12:28 -0700 (PDT)
Received: from google.com (124.190.199.35.bc.googleusercontent.com. [35.199.190.124])
        by smtp.gmail.com with ESMTPSA id d190sm22259042pfd.199.2020.07.07.12.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 12:12:28 -0700 (PDT)
Date:   Tue, 7 Jul 2020 19:12:24 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Cc:     Eric Biggers <ebiggers@google.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 5/5] scsi: ufs-qcom: add Inline Crypto Engine support
Message-ID: <20200707191224.GA2203002@google.com>
References: <20200621173713.132879-1-ebiggers@kernel.org>
 <20200621173713.132879-6-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621173713.132879-6-ebiggers@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jun 21, 2020 at 10:37:13AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add support for Qualcomm Inline Crypto Engine (ICE) to ufs-qcom.
> 
> The standards-compliant parts, such as querying the crypto capabilities
> and enabling crypto for individual UFS requests, are already handled by
> ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
> However, ICE requires vendor-specific init, enable, and resume logic,
> and it requires that keys be programmed and evicted by vendor-specific
> SMC calls.  Make the ufs-qcom driver handle these details.
> 
> I tested this on Dragonboard 845c, which is a publicly available
> development board that uses the Snapdragon 845 SoC and runs the upstream
> Linux kernel.  This is the same SoC used in the Pixel 3 and Pixel 3 XL
> phones.  This testing included (among other things) verifying that the
> expected ciphertext was produced, both manually using ext4 encryption
> and automatically using a block layer self-test I've written.
> 
> I've also tested that this driver works nearly as-is on the Snapdragon
> 765 and Snapdragon 865 SoCs.  And others have tested it on Snapdragon
> 850, Snapdragon 855, and Snapdragon 865 (see the Tested-by tags).
> 
> This is based very loosely on the vendor-provided driver in the kernel
> source code for the Pixel 3, but I've greatly simplified it.  Also, for
> now I've only included support for major version 3 of ICE, since that's
> all I have the hardware to test with the mainline kernel.  Plus it
> appears that version 3 is easier to use than older versions of ICE.
> 
> For now, only allow using AES-256-XTS.  The hardware also declares
> support for AES-128-XTS, AES-{128,256}-ECB, and AES-{128,256}-CBC
> (BitLocker variant).  But none of these others are really useful, and
> they'd need to be individually tested to be sure they worked properly.
> 
> This commit also changes the name of the loadable module from "ufs-qcom"
> to "ufs_qcom", as this is necessary to compile it from multiple source
> files (unless we were to rename ufs-qcom.c).
> 
> Tested-by: Steev Klimaszewski <steev@kali.org> # Lenovo Yoga C630
> Tested-by: Thara Gopinath <thara.gopinath@linaro.org> # db845c, sm8150-mtp, sm8250-mtp
Hi Steev and Thara,

I've sent out the patches that add inline encryption support to UFS
(that these patches build upon) at
https://lore.kernel.org/linux-scsi/20200706200414.2027450-1-satyat@google.com/

Can I add "Tested-by"'s from both of you to that patch series?

Thanks!

> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  MAINTAINERS                     |   2 +-
>  drivers/scsi/ufs/Kconfig        |   1 +
>  drivers/scsi/ufs/Makefile       |   4 +-
>  drivers/scsi/ufs/ufs-qcom-ice.c | 245 ++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-qcom.c     |  12 +-
>  drivers/scsi/ufs/ufs-qcom.h     |  27 ++++
>  6 files changed, 288 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c
> 
> -- 
> 2.27.0
> 
