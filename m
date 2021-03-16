Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181A1C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 07:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2FF564F80
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 07:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhCPHSB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 03:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhCPHR3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 03:17:29 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAA3C061756
        for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2021 00:17:29 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo810270wmq.4
        for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2021 00:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oZuUvGFA5U2S6/itOAzxPtROAaukApCNjMGTGxgU3HQ=;
        b=GJE1ydr9bcaCTx5Zg7jSOp9KA8TA4vgJxxjqgfzCx7lM7vzrcDp7DDJaxo5y19IuLe
         Wa6PJP0fKG2kna4IxKVLtxAeAUxUEusGQsxm9VZKT9m6MSXGmJTjd48RluFRz06T0QB2
         Hcgc5LtxahnTIEuPlzeiGFtPhNcYnOX0ghkeHQsKF78wm55qmtLuZVteLbliM+HfEQDV
         nmfplYMjeE0EnvtZgIGMpJCHZSwcmz7S4gGK5JXeUBBBsE194HsqEDwuwsYhzmV5b1EM
         IJLV+K5kwqqP3PE66f84iyg3jdylWaFRj+3OBmb+BwhWcgL2RbxCg9IE7OEYZd8SpFTi
         vYyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oZuUvGFA5U2S6/itOAzxPtROAaukApCNjMGTGxgU3HQ=;
        b=KwhdDIh2vx/XSxrn6PuAjblkwvP0guQVstzB4fJottA3OwUIUCZMhLSxm/s3boEnVr
         bcRRTdkfcyrHrnBLH/6ywDu/o6NhPYZFbSGV7f8mANwpsf+l+9mkexg14uwbuSYRGgcD
         TxyZZRAiSjTsVq97OA36VSf9rWcZHvbK92SGVleQXj9dnNrvc8V5sZ3YrdZbWuTN/DPo
         6t9yYOmR4kaJUZkurR/m5oIAHrW1yvzFz9FVidgqCvop1cCBED3rLOlQvJF+7sBdjKbc
         iumsyW5MBK8SyHrq1P0wO6Va70q2VTPZeE/GXRXqzJx3xFkr72egf+R1Tu2bLnqPXWi7
         nPiA==
X-Gm-Message-State: AOAM533Gmewq2uxoP6GY+oOrVPeukJEy95GMh3Yh1ysFe4HwPCu+z95q
        o5g9XuQjFCOmWsac165mzteM6w==
X-Google-Smtp-Source: ABdhPJzgV7Xt6PwMLLbkmCtGY7U3PeWH7Ot13DkNSrnIYuATbE7mWyPIaCkR7zcFI+EbI0VbJyiYxw==
X-Received: by 2002:a7b:c2f7:: with SMTP id e23mr1578338wmk.30.1615879047977;
        Tue, 16 Mar 2021 00:17:27 -0700 (PDT)
Received: from dell ([91.110.221.243])
        by smtp.gmail.com with ESMTPSA id w11sm22538094wrv.88.2021.03.16.00.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 00:17:27 -0700 (PDT)
Date:   Tue, 16 Mar 2021 07:17:25 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, Adam Radford <aradford@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ali Akcaagac <aliakc@web.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andre Hedrick <andre@suse.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Anil Veerabhadrappa <anilgv@broadcom.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bas Vermeulen <bvermeul@blackstar.xs4all.nl>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Brian Macy <bmacy@sunshinecomputing.com>,
        Christoph Hellwig <hch@lst.de>,
        "C.L. Huang" <ching@tekram.com.tw>, dc395x@twibble.org,
        de Melo <acme@conectiva.com.br>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Dimitris Michailidis <dm@chelsio.com>,
        Doug Ledford <dledford@redhat.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Erich Chen <erich@tekram.com.tw>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Smart <james.smart@broadcom.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Jan Kotas <jank@cadence.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Joel Jacobson <linux@3ware.com>, Karen Xie <kxie@chelsio.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Kurt Garloff <garloff@suse.de>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-drivers@broadcom.com, Linux GmbH <hare@suse.com>,
        linux-scsi@vger.kernel.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Marcelo Tosatti <marcelo@conectiva.com.br>,
        MPT-FusionLinux.pdl@avagotech.com,
        MPT-FusionLinux.pdl@broadcom.com,
        Nathaniel Clark <nate@misrule.us>,
        "Nicholas A. Bellinger" <nab@kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        Oliver Neukum <oliver@neukum.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Santosh Yaraganavi <santosh.sy@samsung.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vinayak Holikatti <h.vinayak@samsung.com>,
        Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 00/30] [Set 2] Rid W=1 warnings in SCSI
Message-ID: <20210316071725.GZ701493@dell>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
 <yq15z1r6db8.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq15z1r6db8.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 15 Mar 2021, Martin K. Petersen wrote:

> 
> Lee,
> 
> > This set is part of a larger effort attempting to clean-up W=1 kernel
> > builds, which are currently overwhelmingly riddled with niggly little
> > warnings.
> 
> Applied to 5.13/scsi-staging, thanks!

Superstar!  Thanks Martin.

Just FYI, there are more 44 more patches left until clean.

Would you like them in 1 or 2 sets?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
