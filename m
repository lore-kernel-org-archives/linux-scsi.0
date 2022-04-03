Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9A5C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 03:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbiDCDW0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Apr 2022 23:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiDCDWZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2022 23:22:25 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139412FFF7
        for <linux-scsi@vger.kernel.org>; Sat,  2 Apr 2022 20:20:32 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso5946872pjb.5
        for <linux-scsi@vger.kernel.org>; Sat, 02 Apr 2022 20:20:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bicyjnBwWkMmNYDlVhy7vDd58IG0QIQb8tpHSmKXQck=;
        b=zangEzhVbg+UDzXyp5a+q8dwkiGM0cFXhlNf4ebiWw0ZWLwxnil51DmR2NcK+RhRmA
         BGjXS/6TxtFX/cGV0scL4eQb9blwHgmiz6dVR2ClExxbH5pcQrfDJYFJleD7nfEzNY0K
         +BmEhf1wbjrwCby3EjIhM6zaWmPeiFTKG7DpHIPZMfgQpTnM8MnarzaFA9h/fC/gPM4j
         1h2weCkbiuoWMKgWUkY6z/AFPYUMwBT6OK/Moww+GhaHmUWDRq0MItYYn6hHbj+/ycwN
         VlSckqqzWGYQAwgdhw7kZZTUNPiF7mhdGO7LI0suCJz5MNHYN+AZGFqgk2VYOFe7jndK
         tZyQ==
X-Gm-Message-State: AOAM531v106wDvP7ZAT25lpKNGr0400XuBG3jDBnk6rmLRC56EQUvnvM
        x6DVwlKf84/RybPxzIaAV1o=
X-Google-Smtp-Source: ABdhPJw3RRHA4BUC550x2PNcj5x4tJHm6xskkDfY77Gx4mpbxArOq6jjSNQ3ubQpuVFRUbw5o6ZBjw==
X-Received: by 2002:a17:902:ef47:b0:156:646b:58e7 with SMTP id e7-20020a170902ef4700b00156646b58e7mr11386949plx.57.1648956031144;
        Sat, 02 Apr 2022 20:20:31 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id j22-20020a637a56000000b003984be1f515sm6389012pgn.69.2022.04.02.20.20.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 20:20:30 -0700 (PDT)
Message-ID: <291d191c-6d39-35b7-1a1f-b7022d97fe25@acm.org>
Date:   Sat, 2 Apr 2022 20:20:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 02/29] scsi: ufs: Remove superfluous boolean conversions
Content-Language: en-US
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Andy Gross <agross@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-3-bvanassche@acm.org> <YkY88lHdTiiaBcB7@ripper>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YkY88lHdTiiaBcB7@ripper>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/22 16:44, Bjorn Andersson wrote:
> On Thu 31 Mar 15:33 PDT 2022, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index 0d2e950d0865..808b677f6083 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -299,8 +299,7 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>>   	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>>   	struct phy *phy = host->generic_phy;
>>   	int ret = 0;
>> -	bool is_rate_B = (UFS_QCOM_LIMIT_HS_RATE == PA_HS_MODE_B)
>> -							? true : false;
>> +	bool is_rate_B = UFS_QCOM_LIMIT_HS_RATE == PA_HS_MODE_B;
> 
> UFS_QCOM_LIMIT_HS_RATE is defined as PA_HS_MODE_B. I wonder if this is
> expected to change at some point, or if we could clean this up further
> (in a future change).

If someone would like to work on this I can help with reviewing the 
resulting patches.

Thanks,

Bart.
