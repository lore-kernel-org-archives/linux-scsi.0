Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E7AFA3743
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 21:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbiJ0VdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235514AbiJ0VdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2022 17:33:19 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3DC6A520;
        Thu, 27 Oct 2022 14:33:19 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id l6so2923446pjj.0;
        Thu, 27 Oct 2022 14:33:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wjYDd+AjqtK1fAhzqo1MyWUPaoispfMqozNlwB2bOZk=;
        b=FCYJobNNCUhcaer/UCGF4hzDFc/JiFQpf//y95HRmw3XyIpylpUWC71hsHr4WG1yEb
         i0ORT0OC26PSuMzgeN2+Cv3U2fYhJGshy6HIpHjyz78F58FGlH3bCESE8KGKs54S+9na
         r1CmyT9y4efrvvI0QI4P3H0mcPPbc5wXshuqEJcfrYDK5L3UgDjDJ9v0Dg5ZIttailXV
         sRMo94adcuhc526DzAqdt6sJyl6RMpjFsLnEqKm/TNdtFbJnwaxgCby8rkM40i88FFDw
         VmoowlWTxd3vmwKs0d4qMhhhVrJ+lETBJlDZR42NXb3DUu9yowVaAlFhJ3Z/gSNblntW
         2ZaA==
X-Gm-Message-State: ACrzQf2uWkI4Ae1lqXJPhBGKG85oAFoV/2AO4FU/eU/q4rESwr/xpfd9
        9IdTwbAauPmzMyBj7N2WlY0=
X-Google-Smtp-Source: AMsMyM7qGz52m/OQbEcFWzGhVdXAgPxigNC8c9DDXXU6wane0zG5CUVpGsjPVvG8bZAdVWCzI9e/ZA==
X-Received: by 2002:a17:90b:380e:b0:213:8cf1:2ab6 with SMTP id mq14-20020a17090b380e00b002138cf12ab6mr156956pjb.217.1666906398644;
        Thu, 27 Oct 2022 14:33:18 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:bc2b:ff19:1b02:257b? ([2620:15c:211:201:bc2b:ff19:1b02:257b])
        by smtp.gmail.com with ESMTPSA id t8-20020a1709027fc800b00179eb1576bbsm1600410plb.190.2022.10.27.14.33.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 14:33:17 -0700 (PDT)
Message-ID: <800cb947-7337-d35e-c4fb-87ea302265d0@acm.org>
Date:   Thu, 27 Oct 2022 14:33:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 05/17] ufs: core: mcq: Introduce Multi Circular Queue
Content-Language: en-US
To:     Asutosh Das <quic_asutoshd@quicinc.com>, quic_cang@quicinc.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     quic_nguyenb@quicinc.com, quic_xiaosenh@quicinc.com,
        stanley.chu@mediatek.com, eddie.huang@mediatek.com,
        daejun7.park@samsung.com, avri.altman@wdc.com, mani@kernel.org,
        beanhuo@micron.com, quic_richardp@quicinc.com,
        linux-arm-msm@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
References: <cover.1666288432.git.quic_asutoshd@quicinc.com>
 <22246916a139954e931cda8eb0990bcbf105ddc2.1666288432.git.quic_asutoshd@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <22246916a139954e931cda8eb0990bcbf105ddc2.1666288432.git.quic_asutoshd@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20/22 11:03, Asutosh Das wrote:
> Introduce multi-circular queue (MCQ) which has been added
> in UFSHC v4.0 standard in addition to the Single Doorbell mode.
> The MCQ mode supports multiple submission and completion queues.
> Add support to configure the number of queues.

Introduce -> Add support for?

> +static int ufshcd_alloc_mcq(struct ufs_hba *hba)
> +{
> +	int ret;
> +
> +	ret = ufshcd_mcq_init(hba);
> +
> +	return ret;
> +}

Although a later patch will modify the above function, please change the 
function body into the following in this patch:

         return ufshcd_mcq_init(hba);

Otherwise this patch looks good to me.

Thanks,

Bart.
