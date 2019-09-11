Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B53C49ED6
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 22:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D21F2087E
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 22:13:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="anYEbfk0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbfIKWNW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 18:13:22 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33975 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbfIKWNW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2019 18:13:22 -0400
Received: by mail-pf1-f196.google.com with SMTP id r12so14613077pfh.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2019 15:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nf55d0M2fgrTAZT8patiiuxPZwICTFJSYQN2V2QrDmQ=;
        b=anYEbfk0b5+4asQZViJ4GPOYj9WhTStLmh+ecrhz8v0xdn4zwEPtVsZfof1Lme4QKG
         b32MZ4jlp1aoNGec5iHuPGezZ3FzV6+R16gp2x0cz7OsJCmV/AthIUpblCcZuw36Gto7
         mJkKm7YXtOUw2VruFSiLqhQj0OJu9fPbzDsFVuzSNY/cxfPyn9H0FwUDZLL1LMqq00G1
         oI1QPoTi1nvd0pX87LlIIbwYg89eK2LT1S43DfayBVQKgXroKePJDLEGsZqSvKP18I9I
         cHuVxbQjxuvEUCu+JKod7gM2xasHWrJxerWu65fq7bPTxfGnDob4I8Jir7+fVc6Xf8Kk
         JWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nf55d0M2fgrTAZT8patiiuxPZwICTFJSYQN2V2QrDmQ=;
        b=QXYrhwgSIXev+r+lsEBeBxuP4rJuMn4jmlY423oEKDPwCTx0UXlikhttG/XolhhMQ2
         o8QcszsYym9AxM+IwizaL8ZcgTCyfRuQEtw4XIXP0ocDMCKQq7T1Fb0HSrbkk8WiTHu9
         i+Ty1jzYesovjdjMUdXvYpOPw4RXoxb/VZmrE3ZzVK5KoHzCx6JetACusrw6xVH6jiHp
         CP4RSEWOLFlxSpzvzZdhoLK37aef49vfFkMwquZdR1dp1D2xC9zWk2Ri68ZhvuK0bAgX
         8m+Z0vuPLoN56kZ3Q96hwk5QrDKmwvXNhXWIu/Z80NdDJduq4GgYyx6EU1WsgPm9nlUB
         9c0A==
X-Gm-Message-State: APjAAAUZ3tAJurandQIs4rJbwn/Sw1VPjukX3XLsTIDxVlolFfx8BoO4
        q2O7lhxfLcT+Jqsjj1sIYfM9Kg==
X-Google-Smtp-Source: APXvYqzPGDfNqvq/dqDwP6b3TOEtC3Bb+5uRpJ4DO9WApq2laqUm31jZznk69DG8lZqgNynRXwxbkg==
X-Received: by 2002:a65:6284:: with SMTP id f4mr13973604pgv.416.1568239999858;
        Wed, 11 Sep 2019 15:13:19 -0700 (PDT)
Received: from [192.168.1.188] ([23.158.160.160])
        by smtp.gmail.com with ESMTPSA id r1sm18455579pgv.70.2019.09.11.15.13.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 15:13:18 -0700 (PDT)
Subject: Re: [PATCH v1 1/2] block: bypass blk_set_runtime_active for
 uninitialized q->dev
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com, matthias.bgg@gmail.com
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, kuohong.wang@mediatek.com,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com
References: <1568183562-18241-1-git-send-email-stanley.chu@mediatek.com>
 <1568183562-18241-2-git-send-email-stanley.chu@mediatek.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <66fddf12-0dc4-1c73-affd-f8404e87342f@kernel.dk>
Date:   Wed, 11 Sep 2019 16:13:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1568183562-18241-2-git-send-email-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/19 12:32 AM, Stanley Chu wrote:
> Some devices may skip blk_pm_runtime_init() and have null pointer
> in its request_queue->dev. For example, SCSI devices of UFS Well-Known
> LUNs.
> 
> Currently the null pointer is checked by the user of
> blk_set_runtime_active(), i.e., scsi_dev_type_resume(). It is better to
> check it by blk_set_runtime_active() itself instead of by its users.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>   block/blk-pm.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/block/blk-pm.c b/block/blk-pm.c
> index 0a028c189897..56ed94f7a2a3 100644
> --- a/block/blk-pm.c
> +++ b/block/blk-pm.c
> @@ -207,6 +207,9 @@ EXPORT_SYMBOL(blk_post_runtime_resume);
>    */
>   void blk_set_runtime_active(struct request_queue *q)
>   {
> +	if (!q->dev)
> +		return;
> +
>   	spin_lock_irq(&q->queue_lock);
>   	q->rpm_status = RPM_ACTIVE;
>   	pm_runtime_mark_last_busy(q->dev);

I'd prefer just doing:

	if (q->dev) {
		...
	}

instead. Other than that little complaint, looks good to me.

-- 
Jens Axboe

