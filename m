Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0347C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 02:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD5C0610D1
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 02:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243907AbhIXCxe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 22:53:34 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:33357 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbhIXCxd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2021 22:53:33 -0400
Received: by mail-pl1-f171.google.com with SMTP id t4so5503416plo.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 19:52:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h87/umItXPfJLYouCCWi7eHEuPMwJhmSqsHVVSY7it8=;
        b=7JxUhRt8nBkDSgbY54bcGnpgH/Bc0tL+U+JFc3D/hwH6JTKzqgSnX14nRzixEjeKyv
         8KtSqHc+1IU5n46iewwwoFXSWnuxRvl+VyhXPEXeggs0LUXRdlWEhQIYWYIPbibaIImr
         HaxXkRTKUb20VpCgWiRL8nlXwn61LD3DmqqntjrtYHZssID02lpQBRUmOPZeMH7Qh3Uw
         uePPAyp1Lmv6aiYfBrNRAkelYJ6ijqvzJS0AiagWUjp3PsCchIcXVBNwluAJGdnako2r
         MPfExwHLlTHS12ky1z3s3Hh2RyLo057wRlk357THB1eQllQ/Dkp5/z4Mdn4/Xo7PdIZq
         WN/w==
X-Gm-Message-State: AOAM533M9iy0+nrub0qyQgaJW0LKeUkngc2nBS5JShmfIiDX+8dwF0cF
        3OeljQ7V94R8cMSk6goQhhw=
X-Google-Smtp-Source: ABdhPJwTPV9cMI9m3fme8cdbYiJD0dsROw4lSuRyLqAg1O40pPA5rUOMqnmeVzrjDe79amUnggjGnw==
X-Received: by 2002:a17:902:b193:b029:11a:a179:453a with SMTP id s19-20020a170902b193b029011aa179453amr7022603plr.69.1632451920957;
        Thu, 23 Sep 2021 19:52:00 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:cbba:97c1:e6a:66d5? ([2601:647:4000:d7:cbba:97c1:e6a:66d5])
        by smtp.gmail.com with ESMTPSA id g17sm7240317pfo.11.2021.09.23.19.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 19:52:00 -0700 (PDT)
Message-ID: <3e9e92ac-b29d-320a-2702-ec870ae7e2f1@acm.org>
Date:   Thu, 23 Sep 2021 19:51:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v1 1/1] scsi: ufs: Fix illegal address reading in upiu
 event trace
Content-Language: en-US
To:     Jonathan Hsu <jonathan.hsu@mediatek.com>, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        alice.chao@mediatek.com, powen.kao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, wsd_upstream@mediatek.com
References: <20210923081038.14032-1-jonathan.hsu@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20210923081038.14032-1-jonathan.hsu@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/23/21 01:10, Jonathan Hsu wrote:
> Fix incorrect index for UTMRD reference in ufshcd_add_tm_upiu_trace().
> 
> Signed-off-by: Jonathan Hsu <jonathan.hsu@mediatek.com>
> Change-Id: I9acab6f3223f96d864948bb5670759d58cf92ad6
> ---
>   drivers/scsi/ufs/ufshcd.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3841ab49f556..36aa27cdc2ab 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -319,8 +319,7 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
>   static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
>   				     enum ufs_trace_str_t str_t)
>   {
> -	int off = (int)tag - hba->nutrs;
> -	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[off];
> +	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[tag];
>   
>   	if (!trace_ufshcd_upiu_enabled())
>   		return;

Please add a Fixes: tag. Is the above patch perhaps a fix for the following
commit: 4b42d557a8ad ("scsi: ufs: core: Fix wrong Task Tag used in task
management request UPIUs")?

Thanks,

Bart.
