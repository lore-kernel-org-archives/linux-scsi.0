Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D4CC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 20:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbjFGUz4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbjFGUzy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 16:55:54 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537D392
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 13:55:53 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-5149c76f4dbso2405647a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jun 2023 13:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686171352; x=1688763352;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ektklZhVWRcOKwLrtgBZu6BNUNHtSSmuP1mClXRp1IA=;
        b=ZJQCvZ2evpXakBg7UM+ZGV2vEfFJUL+otFwGoYsMilw8hZ/dmb3ZEpVF/H2JLy1bBb
         mL5KPS/bVkURvhOxOIcaj7uS36s0d3LZ++mt2auPceBZnlXQwjxf80aRa4rhjpcH3Lsn
         QjJ2k6MeYZ5eVW+7pEeousOI7Xn1dU4POLz9Mr1Z7UjSsP8uwhz/K4xhlL9Oa9FL/XAG
         w0DJclQ0osy7zY+ds88Ji8XX+oyAZ5Zvqs7wR0rjEfqm2TcX9y6YhSnUPYY7YoRLMtNT
         Wwe58AFO+wg7mvc7z07My8RaNRiu//L1HuX549Qr3VJst9CoAlshZ3HAbGNq6bI5gOBJ
         EiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686171352; x=1688763352;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ektklZhVWRcOKwLrtgBZu6BNUNHtSSmuP1mClXRp1IA=;
        b=RcVlKq9cETpDmaajvwRfccqOo15qCELUgcfBrCT35skzsZSfe5RAaTUrv8ntCuUcSK
         7IcXNocxes00l/CbTQsbXG5owohZ3JDNkAwfe5cCKVXdKUOEISX3uHktfwLmaHxblmzB
         paUZwdNjSovou079nwaANsVaxBbYvat756WWV/OPk5Ckwo2NMhsDgtqPrek5dJsXSXyO
         0SmA9ijXBKxLB1WZXmWq9tBMaCTlLg8Uo32xqnvrtkVGIYrfFr5nGMFYvaa4e9CxlWj+
         jzlyr3SzG2hjLdzlBJM6JLmRDTswZ5NEp2cXNPQb33IrStSAbZ+HMWp0R4R3IDOHAkZg
         eqyA==
X-Gm-Message-State: AC+VfDxIC4hfOV1n6See+c3PNvqy3qgp2SUnLu990VtNwGPcumiyz4pa
        OQx5wLa/u+DCSGk3PU/MqEs=
X-Google-Smtp-Source: ACHHUZ7ktgMsEnCJrIw+CDa8sE9m+55xNzqZ6GbTUBd6F2W4LOuZCGHuFVCTLv8c8KF2elfUp+PekQ==
X-Received: by 2002:a17:907:e88:b0:977:e916:9b83 with SMTP id ho8-20020a1709070e8800b00977e9169b83mr8002143ejc.8.1686171351527;
        Wed, 07 Jun 2023 13:55:51 -0700 (PDT)
Received: from ?IPV6:2a01:598:b97f:2abf:5939:fccc:ab6a:6807? ([2a01:598:b97f:2abf:5939:fccc:ab6a:6807])
        by smtp.gmail.com with ESMTPSA id u16-20020aa7d550000000b005149c3fa632sm6673716edr.13.2023.06.07.13.55.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 13:55:50 -0700 (PDT)
Message-ID: <a53bca5b-c730-7558-0a59-16bda9fbc22c@gmail.com>
Date:   Wed, 7 Jun 2023 22:55:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] scsi: ufs: Remove a ufshcd_add_command_trace() call
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
References: <20230531224050.25554-1-bvanassche@acm.org>
From:   Bean Huo <huobean@gmail.com>
In-Reply-To: <20230531224050.25554-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01.06.23 12:40 AM, Bart Van Assche wrote:
> ufshcd_add_command_trace() traces SCSI commands. Remove a
> ufshcd_add_command_trace() call from a code path that is not related to
> SCSI commands.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0856f01b761d..1f7a4ec211ff 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5400,7 +5400,6 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>   		   lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
>   		if (hba->dev_cmd.complete) {
>   			hba->dev_cmd.cqe = cqe;
> -			ufshcd_add_command_trace(hba, task_tag, UFS_DEV_COMP);
>   			complete(hba->dev_cmd.complete);
>   			ufshcd_clk_scaling_update_busy(hba);
>   		}

The tracepoint entry here is of no use, it's never executed, it just 
returns.

Reviewed-by: Bean Huo <beanhuo@micron.com>

