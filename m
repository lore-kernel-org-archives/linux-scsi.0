Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547F3C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 09:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 360876103B
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 09:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhG2JNB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 05:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbhG2JNA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 05:13:00 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA01C061757
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 02:12:56 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h14so5976940wrx.10
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 02:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=bhbXZZV4BIUVvXiueBPsT+j3iAydMmS8/J8erPUJs5w=;
        b=MPpxItcd0iDnjHypt1wpBR7OFW4J/A8XDX0RBU8WmMu/f7QbvEcGHRKuPFdpylMyQ9
         3Rx29gDrybThMVOuyF6NTrddxSIHlzc2OXBqPePOWlUyniQJ6P4eqbQ9OOjoZIA8d0GT
         2D9URHys1M6G8WfMFsFKtB6y34xlwiKEwrBQzeUNbQld1Su1b4k1ZV/8Hb2fXjIQS4kt
         gizqCTj+wGNafr+3g0aBcaGzC22S0ViCxwf7qFVvhIC2XvYBo+5tgZDucJ699Xg8Snum
         Oc5DQXFIXjK256+gVmjD/I+IBhC89A2TjUsnHqPsHJ9jIKucBeCjnWYA6CZX9KoDUBdU
         l/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=bhbXZZV4BIUVvXiueBPsT+j3iAydMmS8/J8erPUJs5w=;
        b=muGCAsxNIOuKCekVatsyzttq9rEiBzhcR++xMkioRut5+PY+V2CPBgbPrOjhny3mQh
         1epdTFvqnMynl8ju1Q9KJieZkg3eo7iH+SKIWmANraBw40mkpGkazZav0IrxZHEB5vJs
         ufYAyjBa7njqZuP7qCdvqsng9z58m74OOxpVjoqT05M3v3RVftd4xKAZQQHTlvRSuvNR
         YcupSIy8DoVvvju/wLqsxjk7PhyKxgDUHG08SBaKlOZ98EBcyr4MDAAdOOT93N1uBLIm
         9sdIDzpDMkQS3VZmzt5+wit0kgpcQvfBFkv/JMwC4jKAv+kkZEmxmkguT5dfdQ1MaH15
         EsIQ==
X-Gm-Message-State: AOAM5325nTVF+0Q0diqzIi+qnIOkGPxy1vz6xXVGgF5f97oVrY825bWm
        JEn/vfxP6WcPBoXIMak676Q=
X-Google-Smtp-Source: ABdhPJz91mNu600ai8QGw5pUbUn/wg7ZglsGluA8r8GgkQIC4yJiN+g5cFkNlPZ7fLehf9tDG2vXOg==
X-Received: by 2002:adf:f282:: with SMTP id k2mr3709880wro.183.1627549975021;
        Thu, 29 Jul 2021 02:12:55 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id j140sm2673235wmj.37.2021.07.29.02.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 02:12:54 -0700 (PDT)
Message-ID: <75b72176a497e4156ad4e80e1078b78c1956d879.camel@gmail.com>
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
Date:   Thu, 29 Jul 2021 11:12:52 +0200
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
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> 
> index 436d814f4c1e..a3ad83a3bae0 100644
> 
> --- a/drivers/scsi/ufs/ufshcd.c
> 
> +++ b/drivers/scsi/ufs/ufshcd.c
> 
> @@ -2095,12 +2095,14 @@ void ufshcd_send_command(struct ufs_hba *hba,
> unsigned int task_tag)
> 
>         ufshcd_clk_scaling_start_busy(hba);
> 
>         if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
> 
>                 ufshcd_start_monitor(hba, lrbp);
> 
> -       spin_lock_irqsave(hba->host->host_lock, flags);
> 
> +
> 
> +       spin_lock_irqsave(&hba->outstanding_lock, flags);
> 
>         if (hba->vops && hba->vops->setup_xfer_req)
> 
>                 hba->vops->setup_xfer_req(hba, task_tag, !!lrbp-
> >cmd);

Bart,

Removing hba->host->host_lock, use hba->outstanding_lock, the issue
fixed by your patch [12/18] still be fixed?

Bean

