Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88576C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 13:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E24A2071C
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 13:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FxYUeVkq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKRNVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 08:21:09 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:35229 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfKRNVJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 08:21:09 -0500
Received: by mail-il1-f195.google.com with SMTP id z12so15968134ilp.2;
        Mon, 18 Nov 2019 05:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4fLeOyF9xXkvLiSYWvPfxvPDde4oZ8BjysEdioA42Rg=;
        b=FxYUeVkqVHinyGDq1exbxMEP43VpelHAZUhOEtZesKbp5/mf6ZtmMBQfjn/Nvujr09
         r/itXs/UPQdX4wfROKmcByqd6eF/9687L4mAOCNoQFthUfty1O/UF96hr9u1SQHouQNr
         /IU8mkyVLhBHQNNtBziPVzywstIyHQIxMtKvQw4q5K0mz43qOegFVufAFzXqx3rN0rri
         MT3vuzNAm00NoF7RsWsdzSYyZYqPJFwW7DJUMRS5EeQekJXm/63CpMVrkDNlFn4XP6y2
         12zBLhTbcX3DscpVlxzGvOb8ASPVQeEAvBgAAwddkgvqHvFr0o0Mp7hU9lFuFrunt0Qd
         80mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4fLeOyF9xXkvLiSYWvPfxvPDde4oZ8BjysEdioA42Rg=;
        b=FvzwcT+FSUI9GTzUKIWbJrJ5eQbCAwEa7dTWn+Rpyv3hdTp2YFx1CG/rYA+7wdgjC9
         vdonM5RxFy8g0CD/sx0vF/PUxa3Wx8FYEgZpjaPvv2QNmsekMzRdQl4Hiac4skjjUqx7
         SgY+0RuwN+4UBAZjzLvragmJZ1ypNKffugyjCXdTlVfchRRCeKK4wA926KGywzB47n9y
         N3TkNEzGwdSRM1sF+cTBhMIdVsKctJgqGXhMeq2Qz++aCtvoxlyJGmLIlKSO7UmqPPTs
         NzRltJLNIfP6eF13L3w1tEvRtSbSb/xFuI6b6xvNfH9nxBVdM81QAc5YwrJrHh43b1Wr
         q15g==
X-Gm-Message-State: APjAAAU5PJCSBXe02i0qIpl+kX3aBRCK+o/TNS8yevFMvYd7Wg5QmC8u
        SoHkOYrzTVmlIq8q0SnB28vf9VA5x9EycDrOZos=
X-Google-Smtp-Source: APXvYqyLhdW49HPyJ++cx6Lx4pbKEb+0zVpJcaaB9Fhduv35umdTPpAkuytFtW8TQK8zZA36/iv5QRWnQWCxePIxP50=
X-Received: by 2002:a92:45ca:: with SMTP id z71mr16101637ilj.106.1574083268430;
 Mon, 18 Nov 2019 05:21:08 -0800 (PST)
MIME-Version: 1.0
References: <1574049277-13477-1-git-send-email-cang@codeaurora.org> <0101016e7ca63d9d-c9360196-acbf-4e53-9041-ccf8935f0d2b-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016e7ca63d9d-c9360196-acbf-4e53-9041-ccf8935f0d2b-000000@us-west-2.amazonses.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Mon, 18 Nov 2019 18:50:32 +0530
Message-ID: <CAGOxZ53JFyFVZoLY0bbc8P9YbfPo2ioMiRS4+67VniXNYRjJ6g@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] scsi: ufs: Avoid messing up the compl_time_stamp
 of lrbs
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com,
        Mark Salyzyn <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 18, 2019 at 9:27 AM Can Guo <cang@codeaurora.org> wrote:
>
> To be on the safe side, do not touch one lrb after clear its slot in the
> lrb_in_use bitmap to avoid messing up the next task which would possibly
> occupy this lrb.
>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
Tested-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufshcd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8e7c362..5950a7c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4902,12 +4902,14 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>                         cmd->result = result;
>                         /* Mark completed command as NULL in LRB */
>                         lrbp->cmd = NULL;
> +                       lrbp->compl_time_stamp = ktime_get();
>                         clear_bit_unlock(index, &hba->lrb_in_use);
>                         /* Do not touch lrbp after scsi done */
>                         cmd->scsi_done(cmd);
>                         __ufshcd_release(hba);
>                 } else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
>                         lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
> +                       lrbp->compl_time_stamp = ktime_get();
>                         if (hba->dev_cmd.complete) {
>                                 ufshcd_add_command_trace(hba, index,
>                                                 "dev_complete");
> @@ -4916,8 +4918,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>                 }
>                 if (ufshcd_is_clkscaling_supported(hba))
>                         hba->clk_scaling.active_reqs--;
> -
> -               lrbp->compl_time_stamp = ktime_get();
>         }
>
>         /* clear corresponding bits of completed commands */
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>


-- 
Regards,
Alim
