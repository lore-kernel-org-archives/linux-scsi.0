Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2BEC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 17:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9990561A3A
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 17:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238815AbhKPRbN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 12:31:13 -0500
Received: from mail-pg1-f171.google.com ([209.85.215.171]:44838 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238728AbhKPRbL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 12:31:11 -0500
Received: by mail-pg1-f171.google.com with SMTP id m15so14346172pgu.11
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 09:28:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NnBat/piQk+CrxO4bvowT9cpNN621Mj8K7d5Tfaa/N4=;
        b=r4o8VWxmMz/OXjJgr0HmUKtYv4rMNADQcDLT+578htdPtsMtQo/7YDTeIGaAFPTb2F
         dUkahxZTLIDQ4a9tXMADLl6djDPZm0+XmD+46FsgCDGnAihEBz0/TWKnizrsOndwbBf1
         q55KialnbVGhWK+O6wLDOR+Oqj97Rkv8jyB6+DOC0JZuQtU36R5VcmBRYph/TsNERoFq
         tUuArM0o69/8SynuADq2ajRw+NnZga7wOp/02hBdQAkqa+3uMMOw1m8nqTq7jb1qqjlj
         IOPwMbrHtSAfuSicLySyRelRjXbSneqXfzqO/AAnSfFwOur9SRUMtZ2U9rjWF4PasgVg
         nOfw==
X-Gm-Message-State: AOAM531yRS/Eqih4kE8inVHS5DiQSjlcktwcmmKPSjsqav1tSad7CdKZ
        EPj79nfxRFC7Y+jcpghOrMs=
X-Google-Smtp-Source: ABdhPJyGYen8t2lqhjhwyGs9XUkeL3jAqV0YqS082ul0kH2I4m3xoQFg+gL8pZfj6lyp8mx7rr/UkQ==
X-Received: by 2002:a63:d74a:: with SMTP id w10mr387586pgi.341.1637083693686;
        Tue, 16 Nov 2021 09:28:13 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id p43sm8988391pfw.4.2021.11.16.09.28.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 09:28:12 -0800 (PST)
Message-ID: <5c041d7f-dedb-f450-9ba8-683f36a55b30@acm.org>
Date:   Tue, 16 Nov 2021 09:28:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v1] scsi: ufs: fix tm cmd timeout/ISR racing issue
Content-Language: en-US
To:     Peter Wang <peter.wang@mediatek.com>, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        jonathan.hsu@mediatek.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com, mikebi@micron.com
References: <20211111094939.14991-1-peter.wang@mediatek.com>
 <08cff383-d944-56f3-e61e-ad6fdf4bb885@acm.org>
 <f58d107c-df83-0293-dc26-cbaa30ee691f@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f58d107c-df83-0293-dc26-cbaa30ee691f@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/21 22:57, Peter Wang wrote:
> By the way, we observe that 100ms TMC timeout value may not enough for
> some device, maybe we need enlarge this value?

Is that the TM_CMD_TIMEOUT constant? It surprises me that 100 ms is not 
enough. Will increasing that constant have a negative impact on the 
error handler in case it hits a task management timeout?

Thanks,

Bart.
