Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70578C77B75
	for <linux-scsi@archiver.kernel.org>; Fri, 19 May 2023 22:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjESW6Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 May 2023 18:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjESW6T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2023 18:58:19 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFA2FD;
        Fri, 19 May 2023 15:58:11 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-64d247a023aso1663316b3a.2;
        Fri, 19 May 2023 15:58:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684537091; x=1687129091;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6pu+8aRcfgtcNruskc5zAa8xIdJbIwySv6ca1i0RvkQ=;
        b=drCiu3y/iMjYlVmSI0piIEdRri9l2hE/9sYhRX7bS2obHbr08I2TsEAQ/3XBsAu/7L
         G3QedVFU2a7JigGHMS8qzalGGP7SCVqfTXv12g50+H4Q+mS0/IHGKRVj4A44243dNIhD
         I/w/7mmMb7ctufs3N1o2tvhMuBCdaIIT770Lzcly2OjXpqJnYMZUWY9BEAOf02pc9eHu
         vZ5vC1SNZrXbPMMZRerr0Sx0yIHoK5bv6PRWN+1vJprSBZQxuhZwVkVxQbl5GinYHh48
         B0wnzEWGZunM+GGenuqySxJ1kbe7LTqi8PCOwb0t0BJwKzVZ1jSL+v2ZR6xLl1pS2pze
         q3kA==
X-Gm-Message-State: AC+VfDzUSAOFRdMGL3ErMEd079mUcR+2Tj1/kJHQ92ftAo4xzT4eElK1
        HBfELwvXHuJdTFB0to2wahs=
X-Google-Smtp-Source: ACHHUZ6Jqn305p9PHdM6bK6s3PjWuaeiu4yJy9KNvr2S5fWMVW0ZfnMdj3MhK0HovwXTiXNEpIfo/g==
X-Received: by 2002:a05:6a00:2d90:b0:64d:2487:5b3c with SMTP id fb16-20020a056a002d9000b0064d24875b3cmr4774925pfb.29.1684537090998;
        Fri, 19 May 2023 15:58:10 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:102a:f960:4ec2:663d? ([2620:15c:211:201:102a:f960:4ec2:663d])
        by smtp.gmail.com with ESMTPSA id x23-20020aa793b7000000b0064d32771fafsm189173pff.97.2023.05.19.15.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 15:58:10 -0700 (PDT)
Message-ID: <bf99c588-e7fb-bd41-fe5d-b350c12df88f@acm.org>
Date:   Fri, 19 May 2023 15:58:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5 4/7] ufs: mcq: Add support for clean up mcq resources
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        open list <linux-kernel@vger.kernel.org>
References: <cover.1683872601.git.quic_nguyenb@quicinc.com>
 <5cf9b73b2de151e941de697b17410f282b35e548.1683872601.git.quic_nguyenb@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5cf9b73b2de151e941de697b17410f282b35e548.1683872601.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/11/23 23:28, Bao D. Nguyen wrote:
> Update ufshcd_clear_cmd() to clean up the mcq resources similar
> to the function ufshcd_utrl_clear() does for sdb mode.
> 
> Update ufshcd_try_to_abort_task() to support mcq mode so that
> this function can be invoked in either mcq or sdb mode.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


