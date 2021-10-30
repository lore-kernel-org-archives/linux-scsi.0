Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65412C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 07:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F51A60E0C
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 07:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhJ3HRz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Oct 2021 03:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhJ3HRy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Oct 2021 03:17:54 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFA0C061570;
        Sat, 30 Oct 2021 00:15:22 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id y196so525970wmc.3;
        Sat, 30 Oct 2021 00:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=PFGDK9bCYbd4pBxhevoLI4HDoaNJZr1Sew/oRuGM/KA=;
        b=h8BT8l1IBxijVsphHwXpq4gvLRhYXHkFbRQl/2j9lQ5c0LR97LQuV/k+xcAd+oZYov
         X0oJTZ6yL2BLfOmbJ1O2sVGCVBcldhiH2VqexC71vpOUMs3vwTfg99OMLfYojfAKAWja
         27cChN+NoUiTmOTS6l0fc1aBhFO17Rsod1Ry7IpUK0wZb/5+mKE+DsMPUxBtKXTORA7C
         fR/ZykWPNTXC3Lbc0bld1CVIMR35v6zAFGWbb9+PNybprSBqe65RRKCwiRG2QtqyTaLa
         Gh7NbgwSX+uIjaypuonaUePZuvoru0wFoDOoGt7bhBK4Ab/s9bHvMJqlhgtoXZx0cLS8
         P04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=PFGDK9bCYbd4pBxhevoLI4HDoaNJZr1Sew/oRuGM/KA=;
        b=Ene2utnb17UhGg109Z3Hu9PAHlk7WHE7esmMpQCx1nw6B+781pmaS9L9U7gN9Yj7c6
         sEAP+uWNj5qpHXf/Ovudx1nmoJK/9n/9f3ZXBFptGjp5uwZ/1h0kHigep4aDtDvui7f2
         5QzzErvRZW9MpcY0+cP+ycc8IN/s/mFWxBHB/c/73hXiCKEKjtXGYaQF2/oHIkKrBy1W
         JazIaerv9ZK7N3MCjtkGICCFSOzOlVvuzvF9m3yqF1q35VMw8FH/efghjDFZ9yZen94o
         8/usD4Etsojb1WKljdVqqEAaLU4g5G9/EcIx8Ns5EVE+lkYphLmV4ATv33gaTss0G3Rl
         iM4w==
X-Gm-Message-State: AOAM5324S3H60vdZQ1HGmbJrw9nlaxI8A6rp5io1e941ucC2sVkCNSlV
        Dgb0MEbF8Uwe1cCbLoBS6ow=
X-Google-Smtp-Source: ABdhPJyRn7ImEEqyDZEooVWhl/2m/t/nVqwhX+5PFa88iopn2lKGEM5KsMnLbwII2fJNRgXPB/Hemg==
X-Received: by 2002:a05:600c:19d3:: with SMTP id u19mr23987716wmq.164.1635578120902;
        Sat, 30 Oct 2021 00:15:20 -0700 (PDT)
Received: from p200300e94719c92a81a9947a27df1b21.dip0.t-ipconnect.de (p200300e94719c92a81a9947a27df1b21.dip0.t-ipconnect.de. [2003:e9:4719:c92a:81a9:947a:27df:1b21])
        by smtp.googlemail.com with ESMTPSA id s8sm7755852wrr.15.2021.10.30.00.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 00:15:20 -0700 (PDT)
Message-ID: <0f81b6d74a6bde6606ac93e20b65cc59b9bed5df.camel@gmail.com>
Subject: Re: [PATCH v3] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat, 30 Oct 2021 09:15:19 +0200
In-Reply-To: <20211030062301.248-1-avri.altman@wdc.com>
References: <20211030062301.248-1-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2021-10-30 at 09:23 +0300, Avri Altman wrote:
> v1 -> v2:
> 
>  - forgot to remove ufshpb_set_write_buf_cmd
> 
> 
> 
> v2 -> v3:
> 
>  - restore bMAX_ DATA_SIZE_FOR_HPB_SINGLE_CMD
> 
>  - remove read_id - it is now always 0
> 
>  - Ignore ufshpb_prep returned error - does not return -EAGAIN no
> more
> 
> 
> 
> HPB allows its read commands to carry the physical addresses along
> with
> 
> the LBAs, thus allowing less internal L2P-table switches in the
> device.
> 
> HPB1.0 allowed a single LBA, while HPB2.0 increases this capacity up
> to
> 
> 255 blocks.
> 
> 
> 
> Carrying more than a single record, the read operation is no longer
> 
> of type "read" per-se, but some sort of a "hybrid" command - writing
> the
> 
> physical address to the device and reading the required payload.
> 
> 
> 
> The HPB JEDEC spec came-up with a dual-command for that operation:
> 
> HPB-WRITE-BUFFER (0x2) to write the physical addresses to device, and
> 
> HPB-READ to read the payload.
> 
> 
> 
> Alas, the current HPB driver design - a single-scsi-LLD-module, has
> no
> 
> other alternative but to spawn the READ10 command into 2 commands:
> 
> HPB-WRITE-BUFFER and HPB-READ.
> 
> This causes a grat deal of aggrevation to the block layer guys, up to
> a
> 
> point, in which that they were willing to revert the entire HPB
> driver,
> 
> regardless of the huge amount of corporate effort already inversted
> in
> 
> it.
> 
> 
> 
> Therefore, remove the pre-req API for now, as a matter of urgency to
> get
> 
> it done before the closing of the merge window.
> 
> 
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com
> >
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> 
> Tested-by: Avri Altman <avri.altman@wdc.com>
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 
> ---
> 
>  drivers/scsi/ufs/ufshcd.c |   7 +-
> 
>  drivers/scsi/ufs/ufshpb.c | 283 +-----------------------------------
> --
> 
>  drivers/scsi/ufs/ufshpb.h |   2 -
> 
>  3 files changed, 4 insertions(+), 288 deletions(-)
> 
> 
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> 
> index f5ba8f953b87..470affdec426 100644
> 
> --- a/drivers/scsi/ufs/ufshcd.c
> 
> +++ b/drivers/scsi/ufs/ufshcd.c
> 
> @@ -2767,12 +2767,7 @@ static int ufshcd_queuecommand(struct
> Scsi_Host *host, struct scsi_cmnd *cmd)
> 
>  
> 
>         lrbp->req_abort_skip = false;
> 
>  
> 
> -       err = ufshpb_prep(hba, lrbp);
> 
> -       if (err == -EAGAIN) {
> 
> -               lrbp->cmd = NULL;
> 
> -               ufshcd_release(hba);
> 
> -               goto out;
> 
> -       }
> 
> +       ufshpb_prep(hba, lrbp);


it is better to add one line comment to highlight that HPB preperation
failure will not impact original read request.

Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>


Bean


 

