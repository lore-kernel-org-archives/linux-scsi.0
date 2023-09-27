Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA048E82CBD
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 18:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjI0ScB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 14:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjI0ScB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 14:32:01 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F307DD
        for <linux-scsi@vger.kernel.org>; Wed, 27 Sep 2023 11:32:00 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1bd9b4f8e0eso90373825ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 27 Sep 2023 11:32:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695839520; x=1696444320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sdtpFZ1EvsiUgYGIQxr1KkBCv19dYm4xAAovByDGV0Y=;
        b=IN2ohy5dXr6TxwF8+Y595YPj6uH3pbDS5XaP2FvNaxlPbYklyGAnvxX7pOS6m4/TfG
         pRoFQ5AshX5kKKnDvV82qpc0WvF1cqxEtiiGMtPURVi3lilki8s9+Z9WQOOXfpZbowaG
         AtUKmYsambJ9q/tsLRwSZ5HOiPX7uHdqySuXrQleFMJGhGyL0D2v/+bCP28KfcK37fhr
         UTgtmmZh1nwHk4S5DOiCrhKUjy+MNH/kPN8qyqeHq9rygDwF98thF7h9o94i7OVXskA2
         72dfCHflKI6QIlMCR3pV2eoEWymk7ngnfyLe018530XJuhkFPHh2xN2aeVq1HAI+Qhm9
         bkxg==
X-Gm-Message-State: AOJu0YyAelYDfSJdFaDV2wF71Nm5sfyZpMbaebHpsCJhnai1IONx9+pn
        qJOtB6jovOvzu2mHC5soWJs=
X-Google-Smtp-Source: AGHT+IHJ5CKwAWtTVnOVEymAXvVCUl/CUoSq+qoF0UzEwQdaOpiEsG9Ud7negXgsuHdMyOEypDzOZw==
X-Received: by 2002:a17:902:6806:b0:1c5:8401:356c with SMTP id h6-20020a170902680600b001c58401356cmr2421503plk.62.1695839519747;
        Wed, 27 Sep 2023 11:31:59 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:8f39:a76e:2f15:c958? ([2620:15c:211:201:8f39:a76e:2f15:c958])
        by smtp.gmail.com with ESMTPSA id az4-20020a170902a58400b001b8baa83639sm909908plb.200.2023.09.27.11.31.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Sep 2023 11:31:59 -0700 (PDT)
Message-ID: <2c428d68-5fee-4db7-8349-eee245c62ff8@acm.org>
Date:   Wed, 27 Sep 2023 11:31:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] ufs: core: wlun send SSU timeout recovery
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
References: <20230927033557.13801-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230927033557.13801-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/23 20:35, peter.wang@mediatek.com wrote:
> +	if (hba->pm_op_in_progress) {
> +		if (ufshcd_link_recovery(hba))
> +			err = FAILED;
> +
> +		return err;
> +	}

This patch looks good to me but I wish the above code would have been
written using the style that is preferred in the Linux kernel:

	if (hba->pm_op_in_progress && ufshcd_link_recovery(hba) < 0)
		return FAILED;

Thanks,

Bart.

