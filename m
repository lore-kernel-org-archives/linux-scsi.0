Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD02C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 18:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245102AbhK3SEJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 13:04:09 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:47103 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238677AbhK3SEI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 13:04:08 -0500
Received: by mail-pg1-f176.google.com with SMTP id r138so20606029pgr.13
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 10:00:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aNd3Dt2g23Jh38dBfLSot1h5dcwD5+CuGYY2pa6kFZg=;
        b=q4BdyiwDK+oGnaddbKfDVmbCvtHI3N23cKtR5u26MSAZIH9wZJKOXf6InHHq6m0Cm7
         MHdhIrQNj3kx3Vb/0lhj/kXXQ1IZURqMsGg5C0oYjDLIuY+IoI8GHWe7HiX7BB3nKmmQ
         pAZFCdje0g5PlBXcHiaqCVR2IOtmaH5ak6Qn/xpYFFgdtVmcPngQ5WQQd+uetdNGt/Ao
         LPM0qWqLFtdg2j36YCHNuuw0jFWNmKbDO2p9JKZHqUC1fEqc1ysk66aiHrTx6ItAmMDN
         srDOFJa/Gm2h6maU6bLOim8qFP0S0Rw59pXAK899IfRp743VgdfiOjL7tSn56cMXYbdT
         4/rQ==
X-Gm-Message-State: AOAM531/kh4YnevfKKINzhgDNqMbs1RKojHqvnQplkFb9FcUzMMwdv0u
        SUVkOuVqZ9x5KIDi/iLauMU=
X-Google-Smtp-Source: ABdhPJxHOz8Ehn8fyJqZRfoDExzOgaEQ82Me7SqPHr1AExOS/mj5VMwalH1GCTYRq1GQMJ7XhlTZxg==
X-Received: by 2002:a05:6a00:1a4d:b0:4a3:5029:ecbf with SMTP id h13-20020a056a001a4d00b004a35029ecbfmr780727pfv.54.1638295248881;
        Tue, 30 Nov 2021 10:00:48 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id l1sm3061084pjh.28.2021.11.30.10.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 10:00:48 -0800 (PST)
Subject: Re: [PATCH v2 14/20] scsi: ufs: Introduce ufshcd_release_scsi_cmd()
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-15-bvanassche@acm.org>
 <1383eeb3-dc40-6498-7388-b5d35b923f88@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4e4fb79a-6783-0613-9fbd-d22b7c18d079@acm.org>
Date:   Tue, 30 Nov 2021 10:00:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1383eeb3-dc40-6498-7388-b5d35b923f88@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/24/21 4:03 AM, Adrian Hunter wrote:
> On 19/11/2021 21:57, Bart Van Assche wrote:
>> +/* Release the resources allocated for processing a SCSI command. */
>> +static void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
>> +				    struct ufshcd_lrb *lrbp)
>> +{
>> +	struct scsi_cmnd *cmd = lrbp->cmd;
>> +
>> +	scsi_dma_unmap(cmd);
>> +	lrbp->cmd = NULL;	/* Mark the command as completed. */
>> +	ufshcd_release(hba);
>> +	ufshcd_clk_scaling_update_busy(hba);
>> +}
> 
> That seems to leave a gap in the handling of tracing.
> 
> Wouldn't we be better served to tweak the monitoring code
> in __ufshcd_transfer_req_compl() and then use
>   __ufshcd_transfer_req_compl()? i.e.
> 
> 	result = ufshcd_transfer_rsp_status(hba, lrbp);
> 	if (unlikely(!result && ufshcd_should_inform_monitor(hba, lrbp)))
> 		ufshcd_update_monitor(hba, lrbp);

Which gap are you referring to? ufshcd_abort() only calls
ufshcd_release_scsi_cmd() after ufshcd_try_to_abort_task() succeeded.
That means that the command has not completed and hence that
ufshcd_update_monitor() must not be called.

Bart.
