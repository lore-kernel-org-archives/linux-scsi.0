Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBF2C25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 00:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbiHLACK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 20:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiHLACI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 20:02:08 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40F0A1D11
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 17:02:05 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id f20so27560948lfc.10
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 17:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=aG0MaOOicTLKoXhdDzIunPnILVWL/GvZc5Wv6G241k8=;
        b=p4Ri5brQ+NDUAXBYfBeXIqusZEGsmWnbJulo4Iy6u1VBgglcOKP7ZT3YgP16HCObpr
         dxbAZFAKAFgAPSwW3/rJTH2xW++ucwB4DIED/4Q7xf0MCth1dMCHHmifd6lgXonnNA9C
         zIfb9rUs2jbypP/UvtsfTXA3VwP1KkDDijeUyQ7Enx0ZrfT1FZ8TKl2hrDLpfyra215f
         dddfdSVpL8BEPUeweaflXy9Knfm8SETo8gMdZNzckoiQYC8TFc8trISBPCOzVgBZ/6Ab
         Nv0DhtnUO8JTlE19D+R0Qg0P8sJRAQFFb52WKsp652fnEG2qbHwz4sGysWALVCazEoky
         6XqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=aG0MaOOicTLKoXhdDzIunPnILVWL/GvZc5Wv6G241k8=;
        b=jPr6WnKWqBNqrI9zLnAojqxe15gLmdGXnkpfalzaM1uQm5r9UCeYra2StMNMQaOH8N
         to/brtY3/vqGihGmNUOX5TWGmwNwVPASW7xdq5cyeEAFAsAd7h2kJcwLJC4KnPh0/9ct
         5prmHkWmET3/UUP0fDXUp9xn1KVYu0iCeSrKLL2fS2QcI/46+dYsz0EeOuFtL0dV72LK
         fQQfuo9HtxrWqHwHS9H3GA7ioGlfxaI8qiZhKMWx0RUT+vwLynDAwKSVJQ7FH7U+Gfra
         wqjJJFlCZJQBBCAVnkH7UMRs/sJzvpO8GNw9zkxnWFDIb8FHVEcmF9i1WJQ+bX6wWw4q
         8DZw==
X-Gm-Message-State: ACgBeo1WaBColMH/Mje8iFNgEGbhKu51eBM/qK55lIW7CfTMTyJ4nbmW
        p9aeHyBz5BBCBgwtStCS5ma/69OodOJ2zpyXzSbBgI9fVA==
X-Google-Smtp-Source: AA6agR5Jbg54V5eh455hviqXhzXSi+INiFiQ044ph4PVTOTFGYpe9hcx8EauQizZjR2xraezosuR8E4zIVi2mptSgH8=
X-Received: by 2002:a05:6512:3dac:b0:48b:694:bb35 with SMTP id
 k44-20020a0565123dac00b0048b0694bb35mr535840lfv.215.1660262523778; Thu, 11
 Aug 2022 17:02:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220811234401.1957911-1-bvanassche@acm.org>
In-Reply-To: <20220811234401.1957911-1-bvanassche@acm.org>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Fri, 12 Aug 2022 08:01:51 +0800
Message-ID: <CAGaU9a-97MBZHWKWc8HZm5mhbdYa4jyyU0d4ODQOHTVkE4_aHw@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: Reduce the power mode change timeout
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 12, 2022 at 7:52 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> The current power mode change timeout (180 s) is so large that it can
> cause a watchdog timer to fire. Reduce the power mode change timeout to
> 10 seconds.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
