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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C65C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 13:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B631660F6D
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 13:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbhHBNP2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 09:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbhHBNP2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 09:15:28 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8784CC06175F
        for <linux-scsi@vger.kernel.org>; Mon,  2 Aug 2021 06:15:18 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so11000947wmb.5
        for <linux-scsi@vger.kernel.org>; Mon, 02 Aug 2021 06:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=HiYKmje75RhgGlzEUBRexkD/NONa1zlzj/ueRGcUmI8=;
        b=EwUXQgTn6irMtAKDcfVgervn0YkdpP/NHl8fyBkzUKIzoHBkyjmAYovWCKDZqYzb1C
         nii1YUzZ4FI8zQG48lz8ypN+u1KmSnOUKttbx4Lcek8712s0ZLs+ZiX/ZNF975ZdEUn8
         prntDGA2iS2dWM7sl9GXy43WP8f0BIoVopplauRBC42eg+zd5Y5ZZZb7kUYcv/ZwZp3L
         3DbubGLbTJU7mcA9a7a3A0auGxiIjmAmhFwHjsi/5nRPgEwP3ZHX8hRivAsp4XVoQVaE
         uaigGy/n0zBakfG8b37GEJCB6B2SNSBhG/jHE+0j5Iw+49DFeSBMvVzqeMcmJXd6NCWg
         xu1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=HiYKmje75RhgGlzEUBRexkD/NONa1zlzj/ueRGcUmI8=;
        b=HXXRjfbSNjSyLBXgNWTjGKjWhrIZ/Xn+q77wEcMB6B3CEHBgtfTKXiHCPPzX90qSHJ
         jkfUi98mdLh0M8iDFPwZSfM0e3DqlP7ITRKkrKKoI9kjYHvjjjfj/ohT5xbvB+b346Md
         +iE7QWk1biBkR+0/PgCa4Mfpm6cYce+yedv8wGpcvB3akT4GVE/EMmnW0cBHkL8EVGqG
         emFYW/a8ZHKBjKjwClTt6HHr5Q/v0TdFr8ZJmzqmR8vhHwoJ9MCZNGQiva92Gi2/bvOc
         oD7A/NZFHwCNMk+8MAw5bPgR6fBMpUXvgF2pKtpkH9c3SsRTHaHPDwl1Dw8NelZZ7NmZ
         u+7Q==
X-Gm-Message-State: AOAM530/3zKwow4vN/FtH4U0PygzIz/kkTgNOzv3AfhlwrejKUu8kV6L
        09CyTLGLzOQDEbzwCr4JWvM=
X-Google-Smtp-Source: ABdhPJwC80bNaFGxkLUutvHEhRuA21gXSVo+PT76J45BYSQD149QkvqKG/C4QT697YDaY2QRQLc2Mg==
X-Received: by 2002:a1c:cc1a:: with SMTP id h26mr16493324wmb.47.1627910117212;
        Mon, 02 Aug 2021 06:15:17 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id u23sm5945182wmc.24.2021.08.02.06.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:15:17 -0700 (PDT)
Message-ID: <37339a2b61573c01af27272e474a0a10b06a25f7.camel@gmail.com>
Subject: Re: [PATCH v3 14/18] scsi: ufs: Fix the SCSI abort handler
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
        Bean Huo <beanhuo@micron.com>
Date:   Mon, 02 Aug 2021 15:15:15 +0200
In-Reply-To: <20210722033439.26550-15-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
         <20210722033439.26550-15-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-21 at 20:34 -0700, Bart Van Assche wrote:
> Make the following changes in ufshcd_abort():
> - Return FAILED instead of SUCCESS if the abort handler notices that
> a SCSI
>   command has already been completed. Returning SUCCESS in this case
>   triggers a use-after-free and may trigger a kernel crash.
> - Fix the code for aborting SCSI commands submitted to a WLUN.
> 
> The current approach for aborting SCSI commands that have been
> submitted to
> a WLUN and that timed out is as follows:
> - Report to the SCSI core that the command has completed
> successfully.
>   Let the block layer free any data buffers associated with the
> command.
> - Mark the command as outstanding in 'outstanding_reqs'.
> - If the block layer tries to reuse the tag associated with the
> aborted
>   command, busy-wait until the tag is freed.
> 
> This approach can result in:
> - Memory corruption if the controller accesses the data buffer after
> the
>   block layer has freed the associated data buffers.
> - A race condition if ufshcd_queuecommand() or ufshcd_exec_dev_cmd()
>   checks the bit that corresponds to an aborted command in
> 'outstanding_reqs'
>   after it has been cleared and before it is reset.
> - High energy consumption if ufshcd_queuecommand() repeatedly returns
>   SCSI_MLQUEUE_HOST_BUSY.
> 
> Fix this by reporting to the SCSI error handler that aborting a SCSI
> command failed if the SCSI command was submitted to a WLUN.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Fixes: 7a7e66c65d41 ("scsi: ufs: Fix a race condition between
> ufshcd_abort() and eh_work()")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 


Reviewed-by: Bean Huo <beanhuo@micron.com>

