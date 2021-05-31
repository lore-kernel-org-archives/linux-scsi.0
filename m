Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BD1C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 17:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE3D0610A8
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 17:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhEaR1I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 13:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbhEaR0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 13:26:54 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C60C07210D;
        Mon, 31 May 2021 09:04:20 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id q5so762705wrm.1;
        Mon, 31 May 2021 09:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=hjP2GgSblleAgp88n/FXlq2IIJg58iX4N95E14USZQU=;
        b=SbQoM9XZG1WvqI841iaaDi7bVckm7JjLL2FIKg6QoDCycc+qaIN1WeMQJrBk8Ahoa6
         nKyxzpzOnmzLGrgfTtdd3UeRMBwWISktetIF5GkwXMoX1UtljdDP9NW6LLZc3cp18SfH
         LC9lJrsBl+sxTedFNcp+1PFCMcoCj2DcJi2PnpWsYQklBGlBSVsmgJEvxMF8jGP+VOuq
         zEAvF2XV5VbaUyRIiaYLfBNQC9VuupDPsPBQfxbSal5/nWx9p2j+ktIrbe5+IIPeFik5
         i3vg5nVbTDXe1Qab1z6ax1u+oQvzKbaZH2zfAoXDgDmSYlGuZ6ORnaSW913pv3VeUNtw
         cVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hjP2GgSblleAgp88n/FXlq2IIJg58iX4N95E14USZQU=;
        b=a2YOT8jhRCj5Y5h0Xmd0oOqVOICCWZviXGMxFWLkc7C3e/AHOIv1r10Rd5t8y1uD1/
         Q68cRDlbFs8S41xZJEWxVTt4EuKSkA+PrdHKHc2ACm8IZdPNgr2mt2I5axsdwG/0YHG9
         E6saoXnw0965vSbjoBGKypBNZVupLyl7ndsC55WC8Lggi5gcX7Pwdy0NUxuXQsrLw9K9
         sYAiVbOOhMU2WWIN4sniIbVMxM5MPBGPtNChg62IfWPWPzhHuLBaTvCXNtid2l4S8nXd
         HpI6P9NM09Dbf+p4Kg/w+hRQ7WbXRAxUfql23UPrwpGmWk7boAAr+1EqyQFGT3zqco1Z
         Z1UA==
X-Gm-Message-State: AOAM532+Z8uxF8B6yKA2FbXs6LYWROFChGIpIgk1Y7oQVojv/uZ5Fayt
        KcRgHYccYo1mkF+djTdaa5g=
X-Google-Smtp-Source: ABdhPJwIKNm2vDybB1eaApkJIC8exiL2TQu44XUOYBgaEmyuzIdO8B0DmWXiuMTmywNXoBV5g2ecTg==
X-Received: by 2002:adf:f7d2:: with SMTP id a18mr7685854wrq.111.1622477058688;
        Mon, 31 May 2021 09:04:18 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id 6sm6766413wmg.17.2021.05.31.09.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 09:04:18 -0700 (PDT)
Message-ID: <6d6d296a84f1e62f65fda4d172a85bb35d9a3684.camel@gmail.com>
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer
 requests send/compl paths
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Date:   Mon, 31 May 2021 18:04:17 +0200
In-Reply-To: <1621845419-14194-3-git-send-email-cang@codeaurora.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
         <1621845419-14194-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-05-24 at 01:36 -0700, Can Guo wrote:
> Current UFS IRQ handler is completely wrapped by host lock, and
> because
> 
> ufshcd_send_command() is also protected by host lock, when IRQ
> handler
> 
> fires, not only the CPU running the IRQ handler cannot send new
> requests,
> 
> the rest CPUs can neither. Move the host lock wrapping the IRQ
> handler into
> 
> specific branches, i.e., ufshcd_uic_cmd_compl(),
> ufshcd_check_errors(),
> 
> ufshcd_tmc_handler() and ufshcd_transfer_req_compl(). Meanwhile, to
> further
> 
> reduce occpuation of host lock in ufshcd_transfer_req_compl(), host
> lock is
> 
> no longer required to call __ufshcd_transfer_req_compl(). As per
> test, the
> 
> optimization can bring considerable gain to random read/write
> performance.
> 
> 
> 
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> 
> Co-developed-by: Asutosh Das <asutoshd@codeaurora.org>
> 
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>

Can,
The patch looks good to me.
I did a UFS queue limitation test before, observed that once the queue
is full, then the active task number in the queue will get down. For
the Nvme, the scenario is the same. You can refer to the slide 23, and
slide 24 in the pdf:
https://elinux.org/images/6/6c/Linux_Storage_System_Bottleneck_Exploration_V0.3.pdf I don't know if your patch can fix this
issue.

Unfortunately, I cannot verify UTRLCNR usage flow since my platform is
v2.1. But at least my test can prove that the patch doesn't impact the
legacy(UFSHCI is less than v3.0) doorbell usage flow.

Reviewed-by: Bean Huo <beanhuo@micron.com>


Bean

