Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB9CC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 19:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343525AbhK3TUW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 14:20:22 -0500
Received: from mail-pf1-f171.google.com ([209.85.210.171]:41886 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245734AbhK3TT4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 14:19:56 -0500
Received: by mail-pf1-f171.google.com with SMTP id g19so21600659pfb.8
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 11:16:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f1GbbMfWsY+kjrnQS0Yy5NHtinI+2HPXzH06O0mgGTA=;
        b=UfadiW+x9k3df4n99yeE5W6JeIMirn2ba/EQSHphhiO1iYB85srvrh+K3IAEsyMgfX
         Va7Is7efF21I3THAYSE4g2EAuhIgoY6ApkrwhwyLerNOIybviv7Du2vIE3cBvqpTSirf
         N5DszmA3T6vJOfv0hOA9CTVnDta0bGYGiWm3YKH5XekrgYYXo63pPbefUda4Io1s89bx
         VKYqO06rdyX6cVa/aP1W/rg49BedGHDHE1M7lWKOSPYeDMYCViQWYZjUWw+qAsOoLM96
         Q2U4vIebbxKlkL2Pp+B85goQ49LMb/ZlWItwHMKLWzQIi7cJN8qVVmWCEqUe1FJ6Sraw
         Z6FA==
X-Gm-Message-State: AOAM530gjfg2QnS7f3K7qB+9nxP9Gn5apS3fpubTvYNaCtCYiPexHWXV
        m5S8UDB/d7CuebLDjR2BSSE=
X-Google-Smtp-Source: ABdhPJyiVsXjHWvpT35y0pF5gHk+8gj1SD7oJ0d3xS52DpgtHxZ6Et4a1uCLvwOqy1slA2n6277Z4A==
X-Received: by 2002:a63:f008:: with SMTP id k8mr876880pgh.189.1638299796133;
        Tue, 30 Nov 2021 11:16:36 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id s15sm3275354pjs.51.2021.11.30.11.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 11:16:35 -0800 (PST)
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
 <4e4fb79a-6783-0613-9fbd-d22b7c18d079@acm.org>
 <7d135f3b-dcf3-f612-dfba-8a72f1026c79@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ef6164d4-be37-cb3f-8621-99bfb1c21ca9@acm.org>
Date:   Tue, 30 Nov 2021 11:16:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7d135f3b-dcf3-f612-dfba-8a72f1026c79@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/21 11:02 AM, Adrian Hunter wrote:
> On 30/11/2021 20:00, Bart Van Assche wrote:
>> ufshcd_abort() only calls
>> ufshcd_release_scsi_cmd() after ufshcd_try_to_abort_task() succeeded.
>> That means that the command has not completed and hence that
>> ufshcd_update_monitor() must not be called.
> 
> AFAICT the monitor is for successful commands, which is why I suggested
> checking the 'result'.
> 
> So make that change to __ufshcd_transfer_req_compl() and then it will
> work for ufshcd_abort() and provide tracing.

ufshcd_abort() does not set cmd->result because it doesn't have to.
Additionally, __ufshcd_transfer_req_compl() calls scsi_done() while an
abort handler should not call scsi_done(). In other words, my point of
view is that ufshcd_abort() should not call __ufshcd_transfer_req_compl().

Thanks,

Bart.
