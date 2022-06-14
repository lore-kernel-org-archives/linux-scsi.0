Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CBBC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 16:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiFNQeC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 12:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344454AbiFNQeB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 12:34:01 -0400
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E86A28721;
        Tue, 14 Jun 2022 09:34:00 -0700 (PDT)
Received: by mail-pg1-f175.google.com with SMTP id f65so8970438pgc.7;
        Tue, 14 Jun 2022 09:34:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RkwSMFs5tV7VRaLG//B6sO9EUx3D3MkuAWUqMRTF7Bw=;
        b=S2tbwgjlC9kYxBqLNUaYAAsFooH6E3Yk7DrlWyQdctY0m7nSNGQWCHkRlo6oxqP7uD
         2kYN0nhbHzEelyVmuZzMr76VK/jVMJenQAEu+cBKowF/RjR/S3pk4wYogyXNcPWE/qB9
         FgnSo9aafkH04AqW9yo8RWMtvZjAb56wAISpOls6MHszLc5U8W6E28amJLIMytb6XDrA
         yfblMyYLx3QbwWkNhKAfb0KlUNgnDDNpbcM8PrArxwBJPv0SWO5HEzMg7hfpaudoKey6
         cVt05FQJl6a6T0QvCWwQ/PHaW40PUslEKFtc+JTRbnZFUt0Yo016owqQFcyTvrHmeK5q
         ZJWw==
X-Gm-Message-State: AOAM532zLWAHtdp+o5AHhBWCFVQ3ges0kuhzR/TWokQDu3zjyE9E7bTb
        3irJXOkafSOTUPpUWBynbcw=
X-Google-Smtp-Source: ABdhPJy5NVyNVmXrQ2mhwwjtyvfa7FqOz7rXp4n5RH3UDJtiasbysyiTqC2zGhgyiaffvYGRWKJR0Q==
X-Received: by 2002:a05:6a00:2cc:b0:51b:f1d3:e5f with SMTP id b12-20020a056a0002cc00b0051bf1d30e5fmr5300707pft.52.1655224440026;
        Tue, 14 Jun 2022 09:34:00 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ab60:e1ea:e2eb:c1b6? ([2620:15c:211:201:ab60:e1ea:e2eb:c1b6])
        by smtp.gmail.com with ESMTPSA id m25-20020a637119000000b003f6ba49bc57sm7983217pgc.71.2022.06.14.09.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 09:33:59 -0700 (PDT)
Message-ID: <bc6fc2fa-df9a-60cb-3929-9dd5808eced2@acm.org>
Date:   Tue, 14 Jun 2022 09:33:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 04/10] scsi: ufs-mediatek: Fix the timing of
 configuring device regulators
Content-Language: en-US
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        alice.chao@mediatek.com, powen.kao@mediatek.com,
        mason.zhang@mediatek.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com, eddie.huang@mediatek.com,
        tun-yu.yu@mediatek.com, cc.chou@mediatek.com,
        chaotian.jing@mediatek.com, jiajie.hao@mediatek.com
References: <20220614141655.14409-1-stanley.chu@mediatek.com>
 <20220614141655.14409-5-stanley.chu@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220614141655.14409-5-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/14/22 07:16, Stanley Chu wrote:
> +int ufs_mtk_system_suspend(struct device *dev)
> +{
> +	int ret = 0;
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	ret = ufshcd_system_suspend(dev);
> +
> +	if (!ret)
> +		ufs_mtk_vreg_set_lpm(hba, true);
> +
> +	return ret;
> +}


Please use the traditional kernel coding style and return early in case 
of an error. For the above code, that means to rewrite it as follows:

	struct ufs_hba *hba = dev_get_drvdata(dev);
	int ret;

	ret = ufshcd_system_suspend(dev);
	if (ret)
		return ret;

	ufs_mtk_vreg_set_lpm(hba, true);

	return 0;

> +int ufs_mtk_system_resume(struct device *dev)
> +{
> +	int ret = 0;
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	ufs_mtk_vreg_set_lpm(hba, false);
> +
> +	ret = ufshcd_system_resume(dev);
> +
> +	return ret;
> +}

Please remove the variable 'ret' from the above function.

> +int ufs_mtk_runtime_suspend(struct device *dev)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	int ret = 0;
> +
> +	ret = ufshcd_runtime_suspend(dev);
> +
> +	if (!ret)
> +		ufs_mtk_vreg_set_lpm(hba, true);
> +
> +	return ret;
> +}

Please use the "early return" style.

> +int ufs_mtk_runtime_resume(struct device *dev)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	int ret = 0;
> +
> +	ufs_mtk_vreg_set_lpm(hba, false);
> +
> +	ret = ufshcd_runtime_resume(dev);
> +
> +	return ret;
> +}

Please remove the variable 'ret' from the above function.

Thanks,

Bart.
