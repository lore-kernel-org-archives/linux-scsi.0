Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347CDC7EE2E
	for <linux-scsi@archiver.kernel.org>; Fri,  5 May 2023 19:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbjEETAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 May 2023 15:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbjEETAi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2023 15:00:38 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FC41C0EC
        for <linux-scsi@vger.kernel.org>; Fri,  5 May 2023 12:00:32 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1aaea3909d1so19640595ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 05 May 2023 12:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683313231; x=1685905231;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AcJeSVm1C3g0ndIbyxgYi31N59Y86J4o4CNr3SUsqM4=;
        b=gd7bJMGZgxBvqD5SlE22Ityrw2NPoL8osX1wl/WYrWAP17bddWEi9lg1zTKZb8tBBu
         4uu/NQuD4lYZXtIQ9VF/7lKOZBtprLcw3JXYNNoDXg54FVTauu+aHmEjCiEU6fDgiga7
         MgoEb5N1zhbST9fISa5OWzUdKZoAdGhSMFz9RbBLTAOdokgwZObhh/dhX+1bLxiQei3m
         ++6RooJKnRq/2/l/lTIFEd92Ed/fVvJLlshozn3RkkYpRKmKyZDPBE5cWBK/W9QxMfLX
         LW6Lrf1I7qmy/NMj6Hjv+PPJlxz9Ruh0rIgLGrVDbfFKiNxnzcIjvnKQ2Kr8iVUsy5qi
         ruNQ==
X-Gm-Message-State: AC+VfDxgi8aThijZw8wZlJVpGYOkZi3H96fqzfNoAIaqut2GmcIWfKzr
        5oDkCCFkFnMkaId6BhrnvkM=
X-Google-Smtp-Source: ACHHUZ6Ta7XO7KlAZWNKTJj8vwI6F3ftStaAvc5nT4jCrX0npix1AF9MyeKlpjHH8QJbq33j4i1exQ==
X-Received: by 2002:a17:902:9342:b0:19c:d309:4612 with SMTP id g2-20020a170902934200b0019cd3094612mr2545296plp.6.1683313231047;
        Fri, 05 May 2023 12:00:31 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:da29:1cb6:1b86:9a77? ([2620:15c:211:201:da29:1cb6:1b86:9a77])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902d2ce00b001ab13f1fa82sm2109047plc.85.2023.05.05.12.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 May 2023 12:00:30 -0700 (PDT)
Message-ID: <01d01fa0-9a11-bdad-af82-b1ad9b07ad7b@acm.org>
Date:   Fri, 5 May 2023 12:00:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 4/5] scsi: ufs: core: Unexport ufshcd_hold() and
 ufshcd_release()
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <quic_cang@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230504235052.4423-1-bvanassche@acm.org>
 <20230504235052.4423-5-bvanassche@acm.org>
 <990e73a9-b42f-6d13-59a4-ac84edadd602@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <990e73a9-b42f-6d13-59a4-ac84edadd602@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/5/23 11:40, Bao D. Nguyen wrote:
> On 5/4/2023 4:50 PM, Bart Van Assche wrote:
>> Unexport these functions since these are only used by the UFS core.
>
> Qualcomm uses these ufshcd_hold() and ufshcd_release() functions in ufs-qcom.c. I am going to post Qualcomm's change soon.

Hi Bao,

I will drop this patch.

Does the code that you plan to post pass 'false' or 'true' as second
argument to ufshcd_hold()?

Thanks,

Bart.
