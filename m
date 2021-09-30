Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01F9C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 06:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C755D6141B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 06:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348257AbhI3GY3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 02:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348249AbhI3GY2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 02:24:28 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AA8C06161C
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 23:22:46 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r18so17601758edv.12
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 23:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F92H0ATZfvidSJXdKEWFws2fOUyUtBdw6KKZVbOXCIc=;
        b=COK0z5d1lYm3Ld/0vnOJ5twhLIZk7jvj1PqEUAwpyA9Nk9+KFGRxyNO6tXTvX1eYJv
         FXHgL4kOU+P2pDRRbWbZOzzdyBDWcvEUh74aXP9uhwhGMXNZRs1MHouB/jtWVr5jbNG3
         Nn0Bb3Jjy/Y56xeauaw6zvdOGSDhtGS8KeuPEIvpj7tJqmvLXdXs5MGRNbIqZK5LesIP
         pn+u30EAfDJh4lZVMLvnnd0LaOlJVVSyD+PvazJL3/WmeX8LsvKKUwXZhYSzaDt6sjYh
         Dj01osNIvAP8zdTCoxApfzVEfZR7tWZjMGci2wjk3fnF+4ID+EgwHsWEJfSODJa4Wfeu
         a31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F92H0ATZfvidSJXdKEWFws2fOUyUtBdw6KKZVbOXCIc=;
        b=yoZgsIKb9GHB25ToVgCy/vXTHgmQJoksAk54xqsgihu5u4O089mQroOnHOjcJlp6Hd
         PxTr2U37b7E++9TDvnrSBkrrAaOrK2fMMOat4K/EiPyfIR63n18DnhlqqjLtNAzFbpYa
         rgLqv+gdF3eOYLmybuAj4h7Wfguk8mXKfCKKm9q5CgwC1Fda7w7HYxy8Y00GbFXOiAnw
         a5Jqul+qcaW+5GYyALXYLvJPLu9ggOG2TkE2xCltQnEDq5Fx6Z6T6qb6OVBHc6Gppemf
         74cAKkV+QtGWzumAq7zNF/ZNVY52sQS+kuMPgvll4PZsTdKJSLQmdwKjowMaR1i0mLVd
         +CHA==
X-Gm-Message-State: AOAM530Je9XeeIOwhCQADF/lXb5EdZM0AHo6amWXlldFVNwfaQL7LHOP
        E/9C/FznLGuBJfle+OpNnwx0t+G8nMfJcRf6SOhCvA==
X-Google-Smtp-Source: ABdhPJyvYTvcuqP/6KLDcsHFpkzCov1UGf8O3pvqf7cgZ7uBdurIn/Kjm+0hIiv2U931VvopdrSKEOp2j6UoDPI3SDI=
X-Received: by 2002:a17:906:5d6:: with SMTP id t22mr4814561ejt.98.1632982965160;
 Wed, 29 Sep 2021 23:22:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210929025847.646999-1-ipylypiv@google.com>
In-Reply-To: <20210929025847.646999-1-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 30 Sep 2021 08:22:34 +0200
Message-ID: <CAMGffEnbWbTnVp-QqUvojS=z6dGvqbReTUwDmfF7d=6p8PiAMA@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: pm80xx: Fix misleading log statement in pm8001_mpi_get_nvmd_resp()
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 29, 2021 at 4:58 AM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> pm8001_mpi_get_nvmd_resp() handles a GET_NVMD_DATA response, not
> a SET_NVMD_DATA response, as the log statement implies.
>
> Fixes: 1f889b58716a ("scsi: pm80xx: Fix pm8001_mpi_get_nvmd_resp()
> race condition")
>
> Reviewed-by: Changyuan Lyu <changyuanl@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index b73d286bea60..69e5f3db336b 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3169,7 +3169,7 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>          * fw_control_context->usrAddr
>          */
>         complete(pm8001_ha->nvmd_completion);
> -       pm8001_dbg(pm8001_ha, MSG, "Set nvm data complete!\n");
> +       pm8001_dbg(pm8001_ha, MSG, "Get nvmd data complete!\n");
>         ccb->task = NULL;
>         ccb->ccb_tag = 0xFFFFFFFF;
>         pm8001_tag_free(pm8001_ha, tag);
> --
> 2.33.0.685.g46640cef36-goog
>
