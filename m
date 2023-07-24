Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A54C001B0
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 16:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjGXQCM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjGXQCL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 12:02:11 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA34E76
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 09:02:06 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1bba2318546so9169935ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 09:02:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690214526; x=1690819326;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C0uJEn5H1PmTNTbFinPqkAz6nSkeYlXS24RSpXVugAU=;
        b=CI9A+TsHKxKDimL+pkYyiDZ3XeO/68IDWV/fYZaNlfr42EBg7Gr68TkkhMvbuHu2Lc
         yae34Wx+tMhfQMsy9fnyYMJjhReWWl7Q+4MFc+xYVFBrm/ve1KbfBAoRHgHty4y3y0xl
         ODS2NnKCmL1V3Xbp1qr5BkSRLhVHxLroECVS4txA4iR4Fj6PhxXMfL5uFxU4+1QxJbDJ
         /m5RiEEQ+zaYQLIspNJ9L1bXKLD1vlsrbXqkcCvKVzLbaflbvyb51vJlb0p3LmjlDVGL
         YP5qHiVLsgRJXpVmwfGbVCV5v5LV6Y+giaXPRdIcM78CKxx3nbUkd4S84qXxuIdzgAcb
         L1OA==
X-Gm-Message-State: ABy/qLY3fcLFuCRhUiyEm+oW1E5D06ZD0zxEpSNY2b4wfym3YwD+EvSg
        A+8/JQppdgS1GsddBUTsAfE=
X-Google-Smtp-Source: APBJJlGFrqg4hmFiowbWpCOCCEovxbIAUoLTDb/Esasq1Cqn9aJsHQzDyVHSuIlUJyzgXH9zPRmLcQ==
X-Received: by 2002:a17:902:cec5:b0:1b7:ecbb:aa06 with SMTP id d5-20020a170902cec500b001b7ecbbaa06mr13105809plg.55.1690214525426;
        Mon, 24 Jul 2023 09:02:05 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:78f7:fefe:440e:5451? ([2620:15c:211:201:78f7:fefe:440e:5451])
        by smtp.gmail.com with ESMTPSA id i5-20020a170902c94500b001b892aac5c9sm9086606pla.298.2023.07.24.09.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 09:02:05 -0700 (PDT)
Message-ID: <98ef41e0-6805-dd81-a25e-55395c2475eb@acm.org>
Date:   Mon, 24 Jul 2023 09:02:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 2/3] scsi: ufs: Fix residual handling
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
References: <20230721160154.874010-1-bvanassche@acm.org>
 <20230721160154.874010-3-bvanassche@acm.org>
 <DM6PR04MB6575C3A5197457FAE3F6C438FC3DA@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575C3A5197457FAE3F6C438FC3DA@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/22/23 22:31, Avri Altman wrote:
>>
>> +       WARN_ON_ONCE(overflow && underflow);
>> +       WARN_ON_ONCE(!overflow && !underflow && resid);
> Do we really need to debug the hw? - see Table 10.16 (3.1 spec).

I was wondering about this too while writing this patch. If nobody objects I
will leave the above two WARN_ON_ONCE() statements out when reposting this patch.

Thanks,

Bart.

