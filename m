Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0088AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 06:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346323AbiA1GRV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346320AbiA1GRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 01:17:21 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0845C06173B
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 22:17:20 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id j2so7662901edj.8
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 22:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c/CkclFENvNU9iJxmtfyZRvpKKJMHcuyFFvdF23dkus=;
        b=iztXq6G/En1JOcuqfxwuQmEkrxjeY7ud/8FaRAl+JRzteWH4DWbgMyinAXl6UUKoAa
         KhXlvR0Azbo/gEj4XGIR/qGK5sCwzS2Yaw2lMcN2I4Paf+osEG4xu4H3Ulz8erxSzwZR
         JzwqoXxTcl9BfZUDCrt300Bte+UMRi7cQJf+803Dvm3mQagBODamM4azgTpqFkt+YIVp
         sbbDJa44C23DRjBJ6sp57wUBPqjeOAP4bmupcSlBwYlsG8x0ws5sVxmNshnTjAOneyil
         o+pwyqowZgZY5gyJ+8pr+ST5u4CfavieEA05NKZ4pby0qRAXW8pWtqEcCtm8RHaoKqCT
         Il5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c/CkclFENvNU9iJxmtfyZRvpKKJMHcuyFFvdF23dkus=;
        b=e2l/1J50z+MJExZ8OzMh9GaJws957oyO13qF977EdDXpMSAN292MtSOavpugix7mCZ
         8n0nG+mbVj2p+mWzpyU9q6jw86VlPiNi2zX92pZfZi4tnElr3cfLh6AWJzybI75FQP2e
         B1xWI3Ss2WXJE5MzoEtj2qHKXS4YmOAbvyyEkoBR5l43lO3UZtZjgyxTeVEirmJCvC9r
         5qMZoMy2NGIxpdypfU7UzxCg9qU+xakOdSTS6KgrY7VQNFMhecQf/heaHmg+7IxwWkKD
         /QwbQX8Xb5OE6sDUXOKEOjIIjJXXp8WC23YUgFuSQfj3ClTwgobWcwFyH2/9CVwjlGFq
         mVyA==
X-Gm-Message-State: AOAM532kua1ysRMxF7B8qeNdc7/EXhQlOWWpFNJ8GgJ+Z3H6EA3vnFwS
        vSFuIR4fxYQnO6XLT/fnB6barivuhX7r0RZWr7kWyQ==
X-Google-Smtp-Source: ABdhPJximxN0cZ3CWdkmtsyoHacjX2ErQykMiikn16RMEAC6KRVTgwYOyVzCzo4dRU9f+G2tcWmtARMhvZQJD8dbAWg=
X-Received: by 2002:a05:6402:5241:: with SMTP id t1mr6658992edd.161.1643350639264;
 Thu, 27 Jan 2022 22:17:19 -0800 (PST)
MIME-Version: 1.0
References: <1643289172-165636-1-git-send-email-john.garry@huawei.com> <1643289172-165636-2-git-send-email-john.garry@huawei.com>
In-Reply-To: <1643289172-165636-2-git-send-email-john.garry@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 28 Jan 2022 07:17:08 +0100
Message-ID: <CAMGffE=wKvNe5yoGpYY=Gcs8P5CAvoaoZjXuzO71S4mCx5g60Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] scsi: pm8001: Fix warning for undescribed param in process_one_iomb()
To:     John Garry <john.garry@huawei.com>
Cc:     jinpu.wang@ionos.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, damien.lemoal@opensource.wdc.com,
        Ajish.Koshy@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viswas.G@microchip.com,
        chenxiang66@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 27, 2022 at 2:18 PM John Garry <john.garry@huawei.com> wrote:
>
> make W=1 complains of an undescribed function pararm:
>
> drivers/scsi/pm8001/pm80xx_hwi.c:3938: warning: Function parameter or member 'circularQ' not described in 'process_one_iomb'
>
> Fix it.
>
> Reported-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
Thx John!
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index bbf538fe15b3..ce38a2298e75 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3931,6 +3931,7 @@ static int ssp_coalesced_comp_resp(struct pm8001_hba_info *pm8001_ha,
>  /**
>   * process_one_iomb - process one outbound Queue memory block
>   * @pm8001_ha: our hba card information
> + * @circularQ: outbound circular queue
>   * @piomb: IO message buffer
>   */
>  static void process_one_iomb(struct pm8001_hba_info *pm8001_ha,
> --
> 2.26.2
>
