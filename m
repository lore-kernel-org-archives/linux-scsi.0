Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6987C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C5D564F96
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCQINa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhCQINU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:13:20 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25217C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:13:09 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id d8-20020a1c1d080000b029010f15546281so526128wmd.4
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WfpCUY1UJ7qOjlg2Vr5i3kzC42xTpe413tD2Ys270Wk=;
        b=Brjewc+eW72WLOrPIXgP+4LnvrrU5icL+fe4ssNdXpQsMMs+He+yT/vts95CzF/B/I
         FTt9l2SN5akVEdwbeW3WNKqYfwzvW91O7FJo3WwELqO8Ov2oYXbVJI/Ev4t7+dcZPtOj
         Nyom49utEuVUo/dLRtFcF3AWzNHoJzpTEXcf6e+DObmFQ5RE2vaYLD049jn7iyXbFj+0
         FtuyO7sSCXgLCar1zW78DHkJCv/IHSmCs9vup1GF38m9eCy6u4XOlgdLcvJcQXck8Pcb
         E55exTcG0ABs4KM1mQH3VpCoBB5Qd8eePSj9IQmt+JWxJLN0b61GBIvstS40RPm00qKt
         bNQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WfpCUY1UJ7qOjlg2Vr5i3kzC42xTpe413tD2Ys270Wk=;
        b=XAGJeugJDbqULaJWYqI0L0199a36ezPHRoTPx/Gfe890WOQy5Q9WfauaIPEYWAnhws
         xdNQD1bEdJftsoDl/HfXBL+WA6guhfcXa/oY6ofwS8jTMygpO8LDQ0bTj6qNXeBSZYC3
         StD5PYJ9MUG9ctBNQnH0v86dcYlMxRP2nEnqIbm65OvlKEB+SJJ5psHmu8eIaf77SmbJ
         9+XF+LMu2OTkFPqggAKRgf+1k/pzXoHilEsnVi1vmJMSJyR6csUZ1LBAgbYnXoTOaHOv
         3x+JD9OSR9q2GqjfP/0syyBbD0EQl6ahNKh/MNJ+Pzs7nRWvkpnu60pa2Md0+sxDuMdy
         Ni9A==
X-Gm-Message-State: AOAM5339yPXKnVTNUqcfSC8h+4sO3uAfzyuQYbhlkRNSm8ROPvVSRVH6
        +gFAg1Yutoedpi/oEJ00tajQzQ==
X-Google-Smtp-Source: ABdhPJwgpHrWLMZdfq2X+/lLanw+UKg8Df4rEePqI9mV3ANK2dNkjgLsi5sL+tj0DF9anOlKjFU6jw==
X-Received: by 2002:a7b:cb89:: with SMTP id m9mr2461194wmi.27.1615968787897;
        Wed, 17 Mar 2021 01:13:07 -0700 (PDT)
Received: from dell ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id 18sm1621033wmj.21.2021.03.17.01.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:13:07 -0700 (PDT)
Date:   Wed, 17 Mar 2021 08:13:04 +0000
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
Message-ID: <20210317081304.GG701493@dell>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
 <yq15z1r6db8.fsf@ca-mkp.ca.oracle.com>
 <20210316071725.GZ701493@dell>
 <yq1blbi36zm.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq1blbi36zm.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 16 Mar 2021, Martin K. Petersen wrote:

> 
> Lee,
> 
> > Would you like them in 1 or 2 sets?
> 
> As long as they are trivial, one set is fine.
> 
> What does help is to split by complexity. In your two previous series I
> would have preferred the mpt3sas and bfa patches that actually change
> code to be posted separately. Just to make sure they don't get lost in a
> sea of trivial changes.
> 
> IOW, if the patches contain substantial functional changes I'd prefer
> them to be separate from all the kernel-doc, function prototype,
> etc. fixes.

At the moment, my process involves a script which opens each file and
works it's way through the reported issues.

I'll take a look through the remaining patches and try to pull out any
that are more complex.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
