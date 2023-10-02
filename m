Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47215E77361
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 20:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbjJBUde (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 16:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbjJBUdd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 16:33:33 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B46ABF
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 13:33:30 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6907e44665bso154045b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Oct 2023 13:33:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696278810; x=1696883610;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WMfGkv9CjI5rMCQI5zkgH1Bd16hzm6BwL5ZRgN43i6k=;
        b=vlh92s9Ev6Q4wWidF9znjJCBT4X+OWdKdcOm/cQzLArutQvhnvzUZPhCsKYp7TtrG4
         JRV7dCADsmnFph2er714t026hm3LuTJrhGTURV6hBHLs+pehVd/qSpTdJWOBRy6ZaxGZ
         dcm1ZQezVFfo109TxRo5ecXvMKEApWK/8cXKhOYyoRBbBKRrNHlVfDwbMwr3uuRyJVIt
         eBEWKVNmYbdzuNRy/hNzWPRYkpTEPjvwyrZkQvbWlWdXRuuMew1HRlPlWJbxHiobbQ2d
         aNmO+6O84pdLv6FAdh0cC/LAjQrsJB47sZcCTflMqKDAG+8ZzmkKlEoGGQfb0g7PJJ1f
         /MDg==
X-Gm-Message-State: AOJu0YzEi9JXBOzp9onEGMS8PVlwh2WT2K20dHBsVPhLzqGGB3aMhU/R
        6WHWqtPB1k+jr+xqGpwap44=
X-Google-Smtp-Source: AGHT+IHLjYXAOwwyx9EqJnGbuMB0IoQ3i/DXcFLttPKlL+C/RtnwV6RDd+dCN7eTQH4Fe0qy38Uq7Q==
X-Received: by 2002:a05:6a20:5658:b0:161:22c0:541 with SMTP id is24-20020a056a20565800b0016122c00541mr12018174pzc.25.1696278809764;
        Mon, 02 Oct 2023 13:33:29 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:6ad7:f663:5f97:db57? ([2620:15c:211:201:6ad7:f663:5f97:db57])
        by smtp.gmail.com with ESMTPSA id 14-20020aa7914e000000b00690bd3c0723sm20415587pfi.99.2023.10.02.13.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 13:33:28 -0700 (PDT)
Message-ID: <13bb26ca-fb67-4f20-a05b-362d6829a3e5@acm.org>
Date:   Mon, 2 Oct 2023 13:33:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: correct clear tm error log
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
References: <20231002125551.15111-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231002125551.15111-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/23 05:55, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> The clear tm function error log is inverted.
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>   drivers/ufs/core/ufshcd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c2df07545f96..4095d88eee44 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6895,7 +6895,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
>   			mask, 0, 1000, 1000);
>   
>   	dev_err(hba->dev, "Clearing task management function with tag %d %s\n",
> -		tag, err ? "succeeded" : "failed");
> +		tag, err ? "failed" : "succeeded");
>   
>   out:
>   	return err;

Please consider changing "err ?" into "err < 0 ?" to make it more clear
that negative return values represent an error. Additionally, please
consider adding the following:

Fixes: 4693fad7d6d4 ("scsi: ufs: core: Log error handler activity")

Thanks,

Bart.
