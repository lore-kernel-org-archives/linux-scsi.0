Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36782C7EE25
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 17:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjFGRTC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjFGRTA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 13:19:00 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E971FE8
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 10:18:57 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-651ffcc1d3dso4467786b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jun 2023 10:18:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686158337; x=1688750337;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dS+0yjhSDxfjAiuUcOw3O6WF9Dqa4TSGn7cZ1ksi9CU=;
        b=k1IVOPgq2ARVSIX66X8XH7y8+1EHmV+NPNW6UjOPejCveBtKLhXXD92Pq33/M1hySt
         QEKjnxcKLSq1fd+LTqFfyDls0MOKnKCYook1wbRnzm+2PqOaE6OdFrLhwbL53mARJzsK
         Pdfq0delmcgzAMuUuVtAkGRifPy43xGJZVmQGE73gUzZ4b9+J0b+1XxqCQn6sP0peX+8
         hn/X2/ZYuSSsa5e8rAtSL41JF+QUkevSvWcczMmbBKsBUevVlOSp/lcsIfdgFxc8KTsD
         LoTjducZl1lXIGeUEEh2WbLfVzGiGLfertcp/IpUBdrWr1Fzq75QbkXRna1CQfzmP83y
         Hp9w==
X-Gm-Message-State: AC+VfDwYBr159aPk5ARgGMLvfL85H6XWXdGE5HOMuUk0LXNDPnCNBvJB
        eb8RoFBxr9ACco6QTeQLpJIIgeWFR2w=
X-Google-Smtp-Source: ACHHUZ44A3bxLgWM/oyGbE7G8HgAuaJwLlqsz0J7S2U0E/hsouqsWE7MbwJULNU5kV/BwNfubrbxMA==
X-Received: by 2002:a05:6a21:9982:b0:10f:500b:18a2 with SMTP id ve2-20020a056a21998200b0010f500b18a2mr2848154pzb.48.1686158337140;
        Wed, 07 Jun 2023 10:18:57 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id u36-20020a631424000000b0053474697607sm9391087pgl.4.2023.06.07.10.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 10:18:56 -0700 (PDT)
Message-ID: <85b7a110-542d-d1d4-ce5f-59114c0e85b7@acm.org>
Date:   Wed, 7 Jun 2023 10:18:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH] scsi: ufs: Remove a ufshcd_add_command_trace() call
Content-Language: en-US
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
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
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230531224050.25554-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/31/23 15:40, Bart Van Assche wrote:
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

Can anyone please help with reviewing this patch?

Thanks,

Bart.
