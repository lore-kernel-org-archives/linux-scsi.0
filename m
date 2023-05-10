Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DE5C77B7C
	for <linux-scsi@archiver.kernel.org>; Wed, 10 May 2023 21:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbjEJVZN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 17:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbjEJVZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 17:25:07 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9034486;
        Wed, 10 May 2023 14:25:06 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-643aad3bc41so6778944b3a.0;
        Wed, 10 May 2023 14:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683753906; x=1686345906;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IIacPj4XUMfoP021IVdaoKOIUKuOcFLdZdLoQ79NbTw=;
        b=M1/Uk0tfwFwd3/4w1ph2wc/s99ZM1E970mk0rPOBjbARSF5alWswy6a0Atyg7TmSBN
         dhCJ0iz0mNuq1brNhvHZ+889Ga6iapyq/prrxnA8OeI/MGzV9uGHPvhU10fNZ7tp0aXi
         9vnD2o6+XB+YQ6nlX2kqYglSWgE+rtzzv36ZoCx0xw4exNSROHKbGzzyhjqIFf6m3Guh
         B5CbzlweGjk22ynKk85UmCI34Wf16PyTTuu333jQ9e1WfSVRzgXps44qLeL8mM1OKX4d
         pSQAgZ3acRf3EMn82+hgp2H8BmgwHGsBw/W3Ix9aPhyhh2TBmjsHje4xV+VEXKOwDC0O
         zb8w==
X-Gm-Message-State: AC+VfDwo2SoARtJIMvGkqkH22CPXEmWNvitueBL1Vn8WtneRadezpoJ1
        FVJFCRaAesISzYdiwICFKandOgKMZvaBdg==
X-Google-Smtp-Source: ACHHUZ7UpQy5QXG4yifsyrXlYRQh0Ep8+JNk2OSsJ7cLZYS9yVO3iaCSp4kdHBPlQpDeqVqfz9reLA==
X-Received: by 2002:a05:6a20:442a:b0:ff:68f1:679 with SMTP id ce42-20020a056a20442a00b000ff68f10679mr22446714pzb.52.1683753906355;
        Wed, 10 May 2023 14:25:06 -0700 (PDT)
Received: from ?IPV6:2001:4958:15a0:30:b447:995b:bf4d:6d9b? ([2001:4958:15a0:30:b447:995b:bf4d:6d9b])
        by smtp.gmail.com with ESMTPSA id y67-20020a636446000000b0051b7e3546acsm3680033pgb.22.2023.05.10.14.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 14:25:05 -0700 (PDT)
Message-ID: <f4aa63fa-ee2f-3ee4-1077-1b11b81fe36b@acm.org>
Date:   Wed, 10 May 2023 14:25:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3 2/7] ufs: core: Update the ufshcd_clear_cmds()
 functionality
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        open list <linux-kernel@vger.kernel.org>
References: <cover.1683688692.git.quic_nguyenb@quicinc.com>
 <6c9990cd13220ceea343b1e5ba463732c4ccffb9.1683688693.git.quic_nguyenb@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6c9990cd13220ceea343b1e5ba463732c4ccffb9.1683688693.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/9/23 22:24, Bao D. Nguyen wrote:
> -		dev_err(hba->dev, "%s: failed to clear requests %#lx\n",
> -			__func__, not_cleared);
> +			dev_err(hba->dev, "%s: failed to clear requests %#lx\n",
> +				__func__, not_cleared);
> +		}

Please change "requests" into "request" and "not_cleared" into "pos". 
Otherwise this patch looks good to me. Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
