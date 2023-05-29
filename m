Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08598C7EE23
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 19:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjE2T6I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 15:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjE2T6H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 15:58:07 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96792B7
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 12:58:05 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-25695bb6461so571162a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 12:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685390285; x=1687982285;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0wq1Xh7+4swbpSMKkec3uM0FF9HDaxIgP69hmeY2x/E=;
        b=NRttw0bSArkxvkbIiJRgDWtu4u4DvY6UDpabqx1xyLq4XEiUWGi3JjUevXyXEu5bEh
         npLVf7b5KS1HQnfn54/swxyxK+B9yKsLGzgKIonzwELIjaLK2P4Jjwus9Oc0Pqj225jm
         RiPk9jqD8/Ohq/guxBaKidjsamX41PKMj8nybB8ZRTyUrh/L5p2ZMSTU7ngDe6S88Iyb
         IzFJkqqtDBvADsJL5l93taM9P4o+oHKmZJsz518iuxA8lhEmcbdCmOBgulqxmB5EI+qY
         1sI6kRs3hI+Qgm0+MitUy2tylegQ0ZTyinup2Yf52wk993ACBicBIl2SAMkrkLsESgou
         Ae8A==
X-Gm-Message-State: AC+VfDxa83F3xbdCZYja6clmaGaqGTZBvc4cuejPrUmpVxXSETxvxX2v
        MGJjmRD5g53uxM3/bNP1PL4=
X-Google-Smtp-Source: ACHHUZ6sjAURffjbA9on/wwfkFXdVzH9Y9hRjFeOsGBTuU4aSDl22++2VJSahbkuqVjcaHJH6h2dxA==
X-Received: by 2002:a17:902:db08:b0:1af:d6fb:199c with SMTP id m8-20020a170902db0800b001afd6fb199cmr9144543plx.16.1685390284870;
        Mon, 29 May 2023 12:58:04 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id bg8-20020a1709028e8800b001ac591b0500sm8623615plb.134.2023.05.29.12.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 12:58:04 -0700 (PDT)
Message-ID: <18ea494e-7d76-8c40-9368-93d86bb6b9f7@acm.org>
Date:   Mon, 29 May 2023 12:58:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 4/4] scsi: ufs: Ungate the clock synchronously
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Adrien Thierry <athierry@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20230526173007.1627017-1-bvanassche@acm.org>
 <20230526173007.1627017-5-bvanassche@acm.org>
 <d8a4d596-9739-25ec-52c4-75fd225eb144@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d8a4d596-9739-25ec-52c4-75fd225eb144@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/29/23 00:29, Adrian Hunter wrote:
> On 26/05/23 20:29, Bart Van Assche wrote:
>> -int ufshcd_hold(struct ufs_hba *hba, bool async);
>> +void ufshcd_hold(struct ufs_hba *hba);
>>   void ufshcd_release(struct ufs_hba *hba);
> 
> Declarations of ufshcd_hold() / ufshcd_release() seem to be
> unnecessarily duplicated in drivers/ufs/core/ufshcd-priv.h
> and include/ufs/ufshcd.h

I will repost this series and add a patch that removes the
duplicated declarations.

Thanks,

Bart.

