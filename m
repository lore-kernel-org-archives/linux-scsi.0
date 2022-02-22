Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C72D1C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 15:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbiBVPDt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbiBVPC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:02:59 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7361C10E079
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:01:49 -0800 (PST)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 462FB3FC9E
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 15:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645542108;
        bh=HtdrJ3I4lOo9P+o7lWSeEHgMO5/UUG8VsgHgTsClLgE=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:From:
         In-Reply-To:Content-Type;
        b=G+PMQ6V4Q5in6kK6rSduCkvGNHTtH+X25bfzi4EQKTEGYL2UaIAxtYU7TZnqBh49l
         v7Yt4WGFM5fBf038GUvq20EPjmfg4kG59j2HkCrisb9aV+f36+HXOrFrUdXkeQBD6D
         OuVyVGbdGwGATWXtS9bkM6DCW4oAvTptqzUxZz5ZWBTO2+CFASoT60Ng7EkwBVqwf2
         iaNnYpLLwionXg74HKRub/LqIfvP2BYMalwNZ593fuTbzA1TRbjy8mCkF+FWhrmHJa
         x/nBB7uWI2mBzw4KBqK8UK46vTIMBisnesHdKrMVC7VZ9r0+PttR8L6krPtv8pjlTs
         B/fy0EWWyZiqQ==
Received: by mail-ej1-f71.google.com with SMTP id ky6-20020a170907778600b0068e4bd99fd1so5882907ejc.15
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:01:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HtdrJ3I4lOo9P+o7lWSeEHgMO5/UUG8VsgHgTsClLgE=;
        b=Pxv1fWh2BOh24xjN83h0H27Is4t47zKxCL1gQYXdd8P3W5TiZTPqzO2r9xYAWf68Fh
         avEVt+RiNGNz9clYRtAHrPYIREF9aJ1gvm1JbfuUs7mXXozTc36So0NK8lhlRiGNY5Ym
         m/NAwiYXQ+UERYdJCtAqlr/7NpSwz96Z78olduSojF+Ye5KA9FRZhfbOtcaepu28Xfo6
         yPv89ay8MepeuVeDm86WlwVFyHqYYH5VwkBD3W2f7sMZ3h3UqKQKoqYfMyQwBVeq6+gr
         8nJYb10nyF/HZWsDjU1UU8PiBxGfSw02ciNcVlFu5ebL08qnaXqD4aUMwkjSls+IcQLa
         /BEw==
X-Gm-Message-State: AOAM530GoHl9vWpSYox0WbIjqbLpr793bFjbmEKJQ/RsyLJCN+uzjaeT
        WkiEeCLDVpbUDDk0NUClFAtQ0myQWehzIpJTDeABYMHGFQi9o/K8zvKnWISe4xTYPPhEULKD9p3
        GicJ8uC6ldDwuu8e1Mi2omWl/+fJFxU95xcuyjP4=
X-Received: by 2002:a17:906:b005:b0:6b4:8861:597b with SMTP id v5-20020a170906b00500b006b48861597bmr19372058ejy.238.1645542107960;
        Tue, 22 Feb 2022 07:01:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyl5ajALOLJhstZXNm4FFrBok2iV4kiyLbSmxL7nyMkd0sVGKDRLluG1qlnkwVf1Pl3ETi9Pw==
X-Received: by 2002:a17:906:b005:b0:6b4:8861:597b with SMTP id v5-20020a170906b00500b006b48861597bmr19372009ejy.238.1645542107580;
        Tue, 22 Feb 2022 07:01:47 -0800 (PST)
Received: from [192.168.0.124] (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id ci16sm6345629ejb.128.2022.02.22.07.01.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 07:01:47 -0800 (PST)
Message-ID: <4e459bbb-ca6c-4ca2-efe9-8ab4d4f3b648@canonical.com>
Date:   Tue, 22 Feb 2022 16:01:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 05/15] dt-bindings: ufs: qcom,ufs: convert to dtschema
Content-Language: en-US
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wei Xu <xuwei5@hisilicon.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jan Kotas <jank@cadence.com>, Li Wei <liwei213@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org
References: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
 <20220222145854.358646-6-krzysztof.kozlowski@canonical.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220222145854.358646-6-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/02/2022 15:58, Krzysztof Kozlowski wrote:
> Convert the Qualcomm Universal Flash Storage (UFS) Controller to DT
> schema format.
> 
> Except the conversion, add also properties already present in DTS:
> iommus, interconnects and power-domains.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../devicetree/bindings/ufs/qcom,ufs.yaml     | 241 ++++++++++++++++++
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt |  90 -------
>  2 files changed, 241 insertions(+), 90 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
>  delete mode 100644 Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> new file mode 100644
> index 000000000000..356217124222
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> @@ -0,0 +1,241 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/qcom,ufs.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm Universal Flash Storage (UFS) Controller
> +
> +maintainers:
> +  - Yaniv Gardi <ygardi@codeaurora.org>

This email bounces ("User doesn't exist: ygardi@codeaurora.org"), so
maintainer is needed for Qualcomm UFS bindings.

Best regards,
Krzysztof
