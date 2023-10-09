Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8D5CD6137
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 21:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbjJIVQk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 17:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbjJIVQY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 17:16:24 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4952E1FC0
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 14:15:13 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2c1807f3400so60879331fa.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Oct 2023 14:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696886111; x=1697490911; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GF8sVvByPhILrt0ONAgfOaeyuIu1HrfcOafsBj1Kszo=;
        b=jDW6Nw2XwVMmxv3s8Jy+owRjhpcl5rJmP3z0COTeBVfsRHY9GcZUB4KPVeRQSXZH9D
         4MLHVGV1POq1NppcUkViz3eI+FU59J5Ehm57PoONo/2e1ORENe5noa6zeUVgqrQGrrFo
         CNJh5uv3xW+mhwd8G64i0pvvugzbzAzpF/Q+WAs7AIbEwMWkMzCjqo3eDS1M0QacNhjH
         vTyv9oWjeWlhCuBaE+5lfeXcxEsxQTg8fktc902n5xmIA07DOQvQUr2YKbMqy5ZB6ID1
         XAbQoAR69MwFli0bPcNhzFyFhGDcn+hPZHglfYqSirAIoJdNJ6iOLaLwgQy6YNDRk7Xg
         bm1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696886111; x=1697490911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GF8sVvByPhILrt0ONAgfOaeyuIu1HrfcOafsBj1Kszo=;
        b=LEPcy6fOyClJRIYQTmM+6Moa1Trexml4gv8w2V+kENcEpLFZhXzIaLJ0z5JeTymBLH
         r9IvdbAt6eOEsp6ojXqvU7Yi8E/L2icws5ZsVyW6Us3nKGDt9ZC2nbh1y3/XTcy5vs6Y
         joXCPs+zybqsDrX5zNn/cuxspXs3SWkbC0T6ZTPm0MeU5QDjaRpL2b2ue944vlF6BRbF
         PwF0hxXWU+o9urezhplBJUupDRGpdmNdX3As+k1XajsGzFXUyern/W+NeMhmsjAbPJOS
         YHBQ0MV7EwDazoYzs6b87FXUeZcuB3CZTZRIIf3txFeZWhsIhwJxkQgkEMQyDTm/k0bV
         O3ig==
X-Gm-Message-State: AOJu0YxbBD9GIcZvwinSqtYTgXCUgHQM9UfVkjsgvwRP/gw2HQK+fvYH
        1cKB38l6MDA/xycRpUJWyBOqoA==
X-Google-Smtp-Source: AGHT+IHPANy7utWKq+Nt0JGanJ/qxGKrfFVdkzSlLFJqrNsi+LPmEIbl3s9Am1RcS03FjaY5Al1gyQ==
X-Received: by 2002:a05:651c:2049:b0:2c0:12f9:3b7c with SMTP id t9-20020a05651c204900b002c012f93b7cmr10214544ljo.11.1696886111428;
        Mon, 09 Oct 2023 14:15:11 -0700 (PDT)
Received: from [172.30.204.90] (UNUSED.212-182-62-129.lubman.net.pl. [212.182.62.129])
        by smtp.gmail.com with ESMTPSA id n10-20020a2e86ca000000b002c029a4b681sm2175771ljj.15.2023.10.09.14.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 14:15:11 -0700 (PDT)
Message-ID: <c4d418b3-86e7-4768-8d18-bf0c05690ddc@linaro.org>
Date:   Mon, 9 Oct 2023 23:15:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] arm64: dts: qcom: sm7125-xiaomi-common: Add UFS nodes
Content-Language: en-US
To:     David Wronek <davidwronek@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Joe Mason <buddyjojo06@outlook.com>
Cc:     cros-qcom-dts-watchers@chromium.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        hexdump0815@googlemail.com, ~postmarketos/upstreaming@lists.sr.ht,
        phone-devel@vger.kernel.org
References: <20231007140053.1731245-1-davidwronek@gmail.com>
 <20231007140053.1731245-7-davidwronek@gmail.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20231007140053.1731245-7-davidwronek@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 10/7/23 15:58, David Wronek wrote:
> Enable the UFS found on the SM7125 Xiaomi smartphones.
> 
> Signed-off-by: David Wronek <davidwronek@gmail.com>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
