Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16572C6FA8F
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 16:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjH2QDR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 12:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbjH2QC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 12:02:56 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959E3CC9
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 09:02:49 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1bf48546ccfso23654885ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 09:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693324969; x=1693929769;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EDE5r+QjbhiQhWnKSrJGP+g7I9XnvpRhqgwjPgGc2fI=;
        b=N9kgdtnAFhPGYf83rRf8c2GWNTPAl60D5Lzy4Tu7bh94ysOeCxAbcc0wcO4cNdCGqL
         p4fTiF3peoKE+Qv7Y2Y006cmsG3fRZIYBTqVHL4hgbQQ2LiMgcBtvncVV1c39rhNmgeg
         ZSeJqFyB0CSX34BZp+ux8D6BfsymyWpNkKmiwwEqsmJnILIEwEmRFnFo1m2EQlyynMf+
         qtUiBd3E+P3hPXP+2OQ4coxe4a/l8J2CA+9NxdCljjlACEUdYAf7LBxkuwjjXXfR9fKk
         l2zArKKfMJVIv4QQV1wlLXPYAgOTKsR2oRF8p08H46j3BPur7Av/5jcGOL5+9Zgc9pTd
         YOmA==
X-Gm-Message-State: AOJu0YxdcaZyOGufXFkDHLlSHgwtbN6otz0AxB6C8fOzh4PcQexKmV9I
        ASqr3tL8F0KWn4tRgXxgsgEcJEONXfpBHA==
X-Google-Smtp-Source: AGHT+IEJl/B9LmwPOGZU0bqkDXFTfikNqVL/pfyRyYJ94clabdkgJLktaHurC2pvz9E96D0qt8abCw==
X-Received: by 2002:a17:902:e746:b0:1b8:9f6a:39de with SMTP id p6-20020a170902e74600b001b89f6a39demr26678435plf.65.1693324968809;
        Tue, 29 Aug 2023 09:02:48 -0700 (PDT)
Received: from [172.20.28.156] ([173.214.130.133])
        by smtp.gmail.com with ESMTPSA id q21-20020a170902789500b001b89f6550d1sm9497164pll.16.2023.08.29.09.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 09:02:48 -0700 (PDT)
Message-ID: <79e87c04-c700-4c54-96ab-1523c13cc1ba@acm.org>
Date:   Tue, 29 Aug 2023 09:02:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Fix the build for big endian 32-bit ARM
 systems
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Avri Altman <avri.altman@wdc.com>
References: <20230827233042.12945-1-bvanassche@acm.org>
 <2e916711-e2ce-47d2-bdf5-0524dae7e207@app.fastmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2e916711-e2ce-47d2-bdf5-0524dae7e207@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/27/23 17:28, Arnd Bergmann wrote:
> The fix makes sense, but I think the description is wrong:
> The weird struct padding on Arm randconfig builds happens
> with CONFIG_AEABI disabled (implying the old OABI),
> regardless of CONFIG_CPU_BIG_ENDIAN.

Thanks for the feedback. I will update the patch description.

>> -			union {
>> -				__u8 tm_function;
>> -				__u8 query_function;
>> -			};
>> +			__u8 tm_or_query_function;
>>   			__u8 response;
> 
> The problem on OABI is that any struct or union is word
> aligned. I would assume that marking the union as __packed
> also addresses the problem here, but I have not tested that
> and your patch seems fine.

Marking the union as __packed seems to be sufficient. I prefer that
approach because I would like to keep the union. I will post a second
version of this patch.

Thanks,

Bart.
