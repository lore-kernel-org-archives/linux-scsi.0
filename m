Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265ADC4361B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 14:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3F97233CE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 14:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgLPOTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 09:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbgLPOTf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2020 09:19:35 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C323C061794;
        Wed, 16 Dec 2020 06:18:55 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id jx16so32919447ejb.10;
        Wed, 16 Dec 2020 06:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1x6UIm6ChoVP2lx7Doa+z702riG0eMq473CvCBJAJkI=;
        b=IbmLch6kYi0kzaudGF5T1OFEzQhBCwsyw/Y/rSNWB/VrmqAVK/4eq4OoMNERkcr3Cp
         Cgmxr/ZeLv9NmtjyEDlHbVt82xO7LDjtQ2beeXqIMxUeilTOvFQe39LEz+LAKaE0rEII
         XG3Vz8aOGqEZXYAuqFG42SJo5ixr7JEps2HFnt0j0DutO4NtKg5dE1kezpTy+vdCxxF8
         aTAC+g2QWVkXpmu3l1VNVXlhkGGsL3nIbsU2R0dxNoxnijyF5KvQhjOOQftrESfetNY4
         vLH4cqrb6PAEzXpeL0UyHgqmhup49ewfgPrpHWdpAE6xFqFjneoNi+Uk05135WkpdWMR
         /VIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1x6UIm6ChoVP2lx7Doa+z702riG0eMq473CvCBJAJkI=;
        b=UNSXq8A5AaEYAuLjsaH5Bf81y5cG3JEjGc22VweD1mKslbtJmpUa4oYHCgIUT8oSza
         Rx8/is3mC+YJ+i3ggTynVWX8k5TeJp9BUtyYHwk3CdDHcOM0RyY68lOJwcRsnQ0EZwoU
         p8VfNZ9faI1w2oBvwxUvy1CuYSVZnH1sOU2gMzjed7a8vAoqjiGDdprJJrxrO/Zbq+mt
         fnPiVMkxFH1smn6zwqjUxl77wC67lJxXD80uYdqPMQ7bNhgUTzixYf9OmqQ14Wu7YnkS
         lw+AjB5pUQ8zoxbYxpW6oDAgoXsCuk6XYNibjSDC2JqyXHsGtD8C1jeYKVkJyNexfS5J
         46Cw==
X-Gm-Message-State: AOAM531J2DcLj6rfr+kO6aDHut5okHhUtYdPi3dEqTY40SQQ0ZRn7Fv0
        SNUsP0S1n+0M51LQKHTBR0M=
X-Google-Smtp-Source: ABdhPJw4GGTL7lCKtM9gU5Z6sfXBvVUt1ZCe9Wwp7yA2j1gGmeMTePfPNP/Xbkni6pAIzcWf6KA/FA==
X-Received: by 2002:a17:906:39d5:: with SMTP id i21mr29885616eje.339.1608128333540;
        Wed, 16 Dec 2020 06:18:53 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id z10sm1484419ejl.30.2020.12.16.06.18.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Dec 2020 06:18:52 -0800 (PST)
Message-ID: <8088bd0a89f18f2812c2503bcc25f2d72aadf82d.camel@gmail.com>
Subject: Re: [PATCH v4 2/3] scsi: ufs: Clean up
 ufshcd_exit_clk_scaling/gating()
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 16 Dec 2020 15:18:51 +0100
In-Reply-To: <1607877104-8916-3-git-send-email-cang@codeaurora.org>
References: <1607877104-8916-1-git-send-email-cang@codeaurora.org>
         <1607877104-8916-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-12-13 at 08:31 -0800, Can Guo wrote:
> ufshcd_hba_exit() is always called after ufshcd_exit_clk_scaling()
> and
> ufshcd_exit_clk_gating(), so move ufshcd_exit_clk_scaling/gating() to
> ufshcd_hba_exit().
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>

