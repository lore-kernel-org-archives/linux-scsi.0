Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E2DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 22:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BD7361391
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 22:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243075AbhI1WQz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 18:16:55 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:37402 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243081AbhI1WQx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 18:16:53 -0400
Received: by mail-pl1-f182.google.com with SMTP id j14so111948plx.4;
        Tue, 28 Sep 2021 15:15:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u+wU0UNwE9U7ML4E5YeDwEVo3ll8p4b4GuTH3bKRfp0=;
        b=7eSXS3URDZkDavmOMHJ5I3lSRW9Dy1PDDKun8PPAbSQrwuO2Gaiu5j4uEWWMcPesrR
         Vf1I3KeAr4KSHaKD7mTIo/u6DSLye34xrz289N8kvVdisuoziPTtJ9s/3mbCgoHv0Elc
         TvjLndYIcOsg/EXDENNhrDeKQlhTZyL4aDq1szcW+ckumS3DcNc9ogIVjWk1ZwzAqvS5
         YgIlqfNHUzrtbostumoCdmeYvZFFIC1yXdGWENrSIY7vV8joOLFNbQUzgN8sIKjL2ui9
         2/GjdvwIrL4hQIGuFJ1OpGc/2EeUkJ3RDZRBYo9Y9iMlsSN/IZCjasYYLvq4NKdsbmrZ
         Gf4g==
X-Gm-Message-State: AOAM533KtltUJuLz8tSBBdmn9zuA51iMSWWY2sMpfIg7+JOgWndJgzsT
        4WdKN6rIpJA+TDv41gHI8+4zVBuDPTs=
X-Google-Smtp-Source: ABdhPJyebXyiAdd17B444Ior58P3VgWvo9thvts2PdMirOsFE0lieNY+jzjuAbN6qqfjK7Lh1VhRKg==
X-Received: by 2002:a17:902:a613:b0:13d:d95c:c892 with SMTP id u19-20020a170902a61300b0013dd95cc892mr7024074plq.35.1632867312759;
        Tue, 28 Sep 2021 15:15:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f36:4e58:55a1:b506])
        by smtp.gmail.com with ESMTPSA id m9sm140259pfo.44.2021.09.28.15.15.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 15:15:12 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Fix a non-constant function
 argument name
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org,
        daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210928214150.779202-1-huobean@gmail.com>
 <20210928214150.779202-3-huobean@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d769cc3c-15ea-7c07-eeaa-e938b8d8483f@acm.org>
Date:   Tue, 28 Sep 2021 15:15:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210928214150.779202-3-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 2:41 PM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Since commit 568dd9959611 ("scsi: ufs: Rename the second
> ufshcd_probe_hba() argument"), the second ufshcd_probe_hba()
> argument has been changed to init_dev_params.
> 
> Fixes: 568dd9959611 ("scsi: ufs: Rename the second ufshcd_probe_hba() argument")
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index debef631c89a..081092418e2d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -225,7 +225,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
>   static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
>   static void ufshcd_hba_exit(struct ufs_hba *hba);
>   static int ufshcd_clear_ua_wluns(struct ufs_hba *hba);
> -static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
> +static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params);
>   static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
>   static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
>   static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);

What is a "non-constant function argument name"?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
