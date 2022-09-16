Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98380ECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 21:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiIPVkB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Sep 2022 17:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIPVj7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2022 17:39:59 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9797E1FCFC
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 14:39:58 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id bh13so21515852pgb.4
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 14:39:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Feo+txNMREv9gGYCjdzt5aBtj7MBH0ePNzjWAS9UyuM=;
        b=ovgpZ+lIg1Z+el0aixzkh6dZyuQTllEvWuzbb5YlgG55CJ+uIDvFBq1W2zaLSPd8+g
         PN3jMsxzmCUCAxr99byXlhci4RIxLosfAZRNFKGK/1t4EIrcQUgCr8q+QwGSiTTKJsiW
         tmPIZm89eWa8B+VqaNudycVofnLcWBxdVAog9bqeBb2afXv5Kn7stYqVGvlghbQeRrmr
         5mk8L8JN6FoNn2q9RKO3VFvb9r9tGV7oM81cHu+NiKQAL1pMp73NSLq72GyTyND/v0Kh
         fhMdCLBfcjyQcqOMvaIfjToFLnSU7OMgFP+mAHbuQbVARBAchIT0zw/4NhJN2fLRqQs+
         k/tQ==
X-Gm-Message-State: ACrzQf03XGR/ZaewQeTlEc6JNdlUB3Dhg91chnBBKpP5fmMzdNANN3ND
        xiPgcDLrIXVsd+12UMreleZ9FBddCz0=
X-Google-Smtp-Source: AMsMyM6p8gWMfSJV3B4FCygHSVhBVqmPBmHt/1vOfGsiDEZrbQB9Ri2VCzj+jj+rqlXZpQV8lyJQow==
X-Received: by 2002:a63:4f08:0:b0:438:d81c:2d32 with SMTP id d8-20020a634f08000000b00438d81c2d32mr6218859pgb.411.1663364397672;
        Fri, 16 Sep 2022 14:39:57 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090a134300b001fe2ab750bbsm1949644pjf.29.2022.09.16.14.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Sep 2022 14:39:56 -0700 (PDT)
Message-ID: <4fadab02-5ab7-03d5-e849-55eaa26113cf@acm.org>
Date:   Fri, 16 Sep 2022 14:39:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v1] ufs: core: bypass get rpm when err handling with
 pm_op_in_progress
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220915115858.7642-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220915115858.7642-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/22 04:58, peter.wang@mediatek.com wrote:
> -static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
> +static void ufshcd_err_handling_prepare(struct ufs_hba *hba, bool *rpm_put)
>   {
> -	ufshcd_rpm_get_sync(hba);
> +	if (!hba->pm_op_in_progress) {
> +		ufshcd_rpm_get_sync(hba);
> +		*rpm_put = true;
> +	}
> +

Hi Peter,

I don't think that this patch is sufficient. If 
ufshcd_err_handling_prepare() is called by the host reset handler 
(ufshcd_eh_host_reset_handler()) then the host state will be 
SHOST_RECOVERY. In that state SCSI command submission will hang and 
hence any ufshcd_rpm_get_sync() call will hang.

How about removing the ufshcd_rpm_get_sync() call from 
ufshcd_err_handling_prepare() and the ufshcd_rpm_put() call from 
ufshcd_err_handling_unprepare()? It is guaranteed that no commands are 
in progress for a runtime suspended LUN so the code for aborting pending 
requests in the UFS error handler will be skipped anyway if it is 
invoked for a runtime suspended device.

Thanks,

Bart.
