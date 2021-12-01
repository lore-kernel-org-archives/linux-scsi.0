Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50403C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 13:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243984AbhLANsP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 08:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243581AbhLANsO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2021 08:48:14 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D26C061574
        for <linux-scsi@vger.kernel.org>; Wed,  1 Dec 2021 05:44:52 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id o19-20020a1c7513000000b0033a93202467so1175645wmc.2
        for <linux-scsi@vger.kernel.org>; Wed, 01 Dec 2021 05:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ubdX53k0t6kTvPFFGJYZjFLjOSKYwViF4MWvLH7T/DE=;
        b=l2Wte9XDBaZVenBSt1vSzWTUKb+3dvRS7j3lhAoennKJ1cHxmCeBd108zfs/lw6XmM
         58nHs6NukDhzTKzQLnUCDuimjlojSKhwB533BUiP1frkW7V5JBja4Ki/tOn0vJ87dYZJ
         b4AIwGEKrXhoanDhg7UchkgGVIcTwr1fM5Lc0XWfdzVLUN9bXkD548/+NKwRCjFWWBuT
         iRyp0dUdfOYBoR5cANrZG/WpMtSkm/3IDI/8Hf/KhYi6ZkhxmrLCjqupMsO8z7OlxMAu
         tKDM28siCyUthZfhXnucAxFX1AJD5Ou3E12V2IbwMHI5YrWsO1d3UUB0HdIGL4aY58vd
         3Yxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ubdX53k0t6kTvPFFGJYZjFLjOSKYwViF4MWvLH7T/DE=;
        b=0t/0nro0cR3eCisH/dbrBY18KRhTFTF5Y/cEHsy3oQlTxZR9cUIiYkP0ClLviefhRk
         MlLhRPTx/XRWN5VFFhcf3ZyMRv71fPYV6DC37ZdvC6JOCsODf1Baj0aaaVWcn1qEafkt
         nZIMoE19lmXWGN+QlGlHaU+9DLhMmXkZUrU+CRY2zx4EGeVFZJ2a0w8APsR6CdFlvLuN
         0tQpw5soYZ4IzX1FlQ34qByZQ8RhMvHUZNTFiHLVmrBmHVD71MhPr5ieGfvDhLfiNumR
         ynTrPmvfi7O0F6AM+XjkiMmH6b7rbDzYAoG1GoGurkWaBZk3QfOPCHe6ibH/wfNy5pZy
         6o4Q==
X-Gm-Message-State: AOAM532TeLHMqMneiMwvNG6+PTbKx+EuMFdCQ/nTpBrZj/nL4uUzATjg
        o/fXN6KzA5jvrbjlUBbaP9A=
X-Google-Smtp-Source: ABdhPJzPaapcZrShfKJkJeLV1fUl5vWIQDYPACtD6eazp5U0LAeie1REzX6tIB7gTHGGNnEIF8RakA==
X-Received: by 2002:a7b:c7cd:: with SMTP id z13mr5227870wmk.59.1638366290696;
        Wed, 01 Dec 2021 05:44:50 -0800 (PST)
Received: from p200300e94719c9b4fab514138d9f6674.dip0.t-ipconnect.de (p200300e94719c9b4fab514138d9f6674.dip0.t-ipconnect.de. [2003:e9:4719:c9b4:fab5:1413:8d9f:6674])
        by smtp.googlemail.com with ESMTPSA id l26sm1388161wms.15.2021.12.01.05.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 05:44:50 -0800 (PST)
Message-ID: <062f4ad2381d652162c010755600557cce2211dd.camel@gmail.com>
Subject: Re: [PATCH v2 13/20] scsi: ufs: Fix a deadlock in the error handler
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Wed, 01 Dec 2021 14:44:46 +0100
In-Reply-To: <235fe40e-5695-a7a6-7422-68fc6d33cdac@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
         <20211119195743.2817-14-bvanassche@acm.org>
         <788d060573ed475a902f17bc32d05540b78e66da.camel@gmail.com>
         <235fe40e-5695-a7a6-7422-68fc6d33cdac@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-11-30 at 11:32 -0800, Bart Van Assche wrote:
> On 11/30/21 12:54 AM, Bean Huo wrote:
> > We are looking for alternative
> > methods: for example, to fix this problem from the SCSI layer;
> > Add a new dedicated hardware device management queue on the UFS
> > device
> > side.
> 
> Hi Bean,
> 
> I don't think that there are any alternatives. If all host controller
> tags
> are in use, it is not possible to implement a mechanism in software
> to
> create an additional tag. Additionally, stealing a tag is not
> possible since
> no new request can be submitted to a UFS controller if all tags are
> in use.
> 
> Thanks,
> 
> Bart.

Bart, 

How about adding a hardware-specific UFS device management queue to the
UFS device? Compared with NVMe and eMMC CMDQ, they both have dedicated
tags for device management commands. NVMe is queue 0, eMMC CMDQ is CMDQ
slot 31.

I'm thinking about the benefits of using this device manage queue. If
the benefits are significant, we can submit the Jedec proposal for the
UFS equipment management queue.

Kind regards,
Bean

