Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0777BE7E654
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 18:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235552AbjIZS3s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 14:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235678AbjIZS3m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 14:29:42 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015E7CCC
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2023 11:29:33 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1c5c91bec75so67227825ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2023 11:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695752973; x=1696357773;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PqCnKovqYNIj8DxAuxi3A8OvLmIv66iPRLv7SkxKqmw=;
        b=J17s+vQFLvpJvZU81qHttL+PvHp74tYO+xWm/kI9DfHTey+yspNyQXzgwixaLhSeL6
         Om9QwUTmWZS6t/Vwu6+hHUW7Aim1Btub2HGWeKl5OSLj7u/HENqCFuzn1HIYqwuuqDyy
         FJD/wa6ddDBQoc5i33fZrnhirWtSrvbZVPPx3tT+++ErR5+4FB2Xv8fEl/C8sChTt9d6
         C/hp9rl/gClAhpv8l81KhfHYX85BJKXSxAsomTRCNa8/93njUWG6Jg7b4aOYLUatAB+c
         /u0j/vc7EdmLt4geOEc4enePebmYGHr7pOY+FEzTMIvoF7kel/gaMvAWGXHVTFUDyixQ
         EzbQ==
X-Gm-Message-State: AOJu0Yz1WqZQl8dvZmsuSkRGz2MSHf/SPz9KX68vqZbs4u41x5q+P+q7
        E1UFbPVDLE2G1b/HFEn83Hs2KNmxTmg=
X-Google-Smtp-Source: AGHT+IHMqjzi7c5raBEJ21qHqYKV/IIXP9BNuusQNOPnQ8IVTL/LruBVyInOe/dyW6slLLnR4GuA8g==
X-Received: by 2002:a17:902:c10c:b0:1c5:741d:f388 with SMTP id 12-20020a170902c10c00b001c5741df388mr8372368pli.9.1695752973263;
        Tue, 26 Sep 2023 11:29:33 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a80d:6f65:53d4:d1bf? ([2620:15c:211:201:a80d:6f65:53d4:d1bf])
        by smtp.gmail.com with ESMTPSA id je20-20020a170903265400b001c5fc291f02sm7458673plb.216.2023.09.26.11.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 11:29:32 -0700 (PDT)
Message-ID: <f10fff07-8a7d-473e-b793-95c2796e63f2@acm.org>
Date:   Tue, 26 Sep 2023 11:29:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ufs: core: wlun send SSU timeout recovery
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
References: <20230922090925.16339-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230922090925.16339-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/23 02:09, peter.wang@mediatek.com wrote:
> +	/*
> +	 * If runtime pm send SSU and got timeout, scsi_error_handler
> +	 * stuck at this function to wait flush_work(&hba->eh_work).
> +	 * And ufshcd_err_handler(eh_work) stuck at wait runtime pm active.
> +	 * Do ufshcd_link_recovery instead shedule eh_work can prevent
> +	 * dead lock happen.
> +	 */

The above comment is hard to understand because of grammatical issues.
Please try to improve this comment. A few examples: I think that "wait"
should be changed into "wait for" and also that "happen" should be changed
into "to happen".

> +	dev = &hba->ufs_device_wlun->sdev_gendev;
> +	if ((dev->power.runtime_status == RPM_RESUMING) ||
> +		(dev->power.runtime_status == RPM_SUSPENDING)) {
> +		err = ufshcd_link_recovery(hba);
> +		if (err) {
> +			dev_err(hba->dev, "WL Device PM: status:%d, err:%d\n",
> +				dev->power.runtime_status,
> +				dev->power.runtime_error);
> +		}
> +		return err;
> +	}

ufshcd_link_recovery() returns a Unix error code (e.g. -ETIMEDOUT) while
ufshcd_eh_host_reset_handler() should return one of the following values:
SUCCESS or FAILED. Please fix this.

Thanks,

Bart.
