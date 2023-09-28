Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF28E732E8
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 16:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjI1QbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjI1QbB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Sep 2023 12:31:01 -0400
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2151A8
        for <linux-scsi@vger.kernel.org>; Thu, 28 Sep 2023 09:30:52 -0700 (PDT)
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-57b67c84999so7107590eaf.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Sep 2023 09:30:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695918652; x=1696523452;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2iqyjYpQGTrxNm51cwmEMqS/kvTM8R+SxrC6ZJz7Qc=;
        b=SyWVl1/v4xQImSwdx8GhHoPqLRkTRRmNh3Vk4DXYzlmqB8qMq5r0t5HsuPeuBjFklM
         yBjRQt90wEO9zwxQ85rodqpvuq1qPKNdiepMHpeaB5NmeivNY9iZ/HRM3HOEn4yn6Cz5
         b6CkPeuobPDVkUDf5ydFeBXmEr8l+PSKqVmq04G/vW9IaROWwGamXyhs1nUcIwOMQaBg
         3zHhMDnZ7QnAIcwyoxfhyI6fhhpjoSDeazYrcl2B51sf5PiMvKtjS08rfC5U1jkka9XB
         l4ZCoNTGf99h4340S6PCClvRWW/WU6B8eAAupWgHy0Mr8+MO2frTL1gVbQ7LdqbgyxfQ
         anwA==
X-Gm-Message-State: AOJu0YxRMztIWOKAtZ4ZpWpzFFUE8CdzlcndW9bxrfO9LusXndeez5pf
        8rLI6uKXLW87sW5VPpKKms0=
X-Google-Smtp-Source: AGHT+IF7pCy57fl4xj1AT8sSnvd4RelGdW4sNUL0MQQFCnsQevUl9J895xnVbGqCHtzAiiVC314krg==
X-Received: by 2002:a05:6358:4297:b0:143:9b23:e850 with SMTP id s23-20020a056358429700b001439b23e850mr1942507rwc.24.1695918651885;
        Thu, 28 Sep 2023 09:30:51 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:4d78:c1af:9677:9afd? ([2620:15c:211:201:4d78:c1af:9677:9afd])
        by smtp.gmail.com with ESMTPSA id c15-20020aa7880f000000b00690d64a0cb6sm13592829pfo.72.2023.09.28.09.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Sep 2023 09:30:51 -0700 (PDT)
Message-ID: <ba3a0af8-8464-43d4-a2e6-a82de7ebe2ae@acm.org>
Date:   Thu, 28 Sep 2023 09:30:49 -0700
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
> When runtime pm send SSU times out, the SCSI core invokes
> eh_host_reset_handler, which hooks function ufshcd_eh_host_reset_handler
> schedule eh_work and stuck at wait flush_work(&hba->eh_work).
> However, ufshcd_err_handler hangs in wait rpm resume.
> Do link recovery only in this case.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
