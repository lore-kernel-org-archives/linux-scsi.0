Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4DCC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 02:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FB3C60FE8
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 02:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239350AbhHaCse (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 22:48:34 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:55215 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbhHaCsd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 22:48:33 -0400
Received: by mail-pj1-f42.google.com with SMTP id fs6so10798127pjb.4
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 19:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3fg13iXsKn4rqDa733c2qnMua3+XBlp2C+4HCh2lEFU=;
        b=UzCaXGh/eqVjr3y5vOgbukidyxuV/WzO9OduZAkcID/NODE4hlUXMgPD3M6jC7Vfbg
         m+Ww4ddeyZjzPbkh2InwdQhuqH7DSXGIFPof8eHAcj/K6hoblmg0Hy6lLO/Ks6cxnX4M
         f4d4l6Mdt70ErBzSJU4Q+8yjqG1JSx9Q/iiYMz2Qet+5SamFxFnAmNS9pdOM7h9/lyo8
         ywFgD3m3PCy0WBnlDjQV4hzBOxgJx/6rSRJ5OvpT0T71ik5rFoqvMmXxA/i8e2cMkd+f
         P+lDL3OF+jetAiRTkhprRij04gJN7l6TS0ZrizD2ab0xUUFw2wV4lKmbFQuiARSYwqJu
         iqow==
X-Gm-Message-State: AOAM532utxt7l0vVFmEqOVz5rm/m5oH8tTOWioAcrmv102xckveS5ZDC
        NKnp27ivxZzBnyUOs4667Jc=
X-Google-Smtp-Source: ABdhPJydeiE+yRYPqtoxh5/wunq8epbATPfbfzIL8F9MF3FdZVNTD5RNLWADgGC32kZA5POCn+E//g==
X-Received: by 2002:a17:902:690a:b0:12d:86cf:d981 with SMTP id j10-20020a170902690a00b0012d86cfd981mr2463466plk.39.1630378058879;
        Mon, 30 Aug 2021 19:47:38 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:7088:a165:5c26:c716? ([2601:647:4000:d7:7088:a165:5c26:c716])
        by smtp.gmail.com with UTF8SMTPSA id p9sm5921179pfq.15.2021.08.30.19.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 19:47:38 -0700 (PDT)
Message-ID: <dda8eb67-fe56-8bc0-5ce8-a62bd4e6b995@acm.org>
Date:   Mon, 30 Aug 2021 19:47:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH v1] scsi: ufs: ufs-mediatek: Change dbg select by check hw
 version
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        jonathan.hsu@mediatek.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com
References: <1630325486-11741-1-git-send-email-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1630325486-11741-1-git-send-email-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/30/21 05:11, peter.wang@mediatek.com wrote:
> +static void ufs_mtk_dbg_sel(struct ufs_hba *hba)
> +{
> +	static u32 hw_ver;
> +
> +	if (!hw_ver)
> +		hw_ver = ufshcd_readl(hba, REG_UFS_MTK_HW_VER);
> +
> +	if (((hw_ver >> 16) & 0xFF) >= 0x36) {
> +		ufshcd_writel(hba, 0x820820, REG_UFS_DEBUG_SEL);
> +		ufshcd_writel(hba, 0x0, REG_UFS_DEBUG_SEL_B0);
> +		ufshcd_writel(hba, 0x55555555, REG_UFS_DEBUG_SEL_B1);
> +		ufshcd_writel(hba, 0xaaaaaaaa, REG_UFS_DEBUG_SEL_B2);
> +		ufshcd_writel(hba, 0xffffffff, REG_UFS_DEBUG_SEL_B3);
> +	} else {
> +		ufshcd_writel(hba, 0x20, REG_UFS_DEBUG_SEL);
> +	}
> +}

Can ufs_mtk_dbg_sel() be called from multiple threads at the same time? 
Does the 'hw_ver' variable need to be protected against concurrent writes?

Thanks,

Bart.
