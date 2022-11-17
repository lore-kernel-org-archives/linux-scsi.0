Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED3FC4167B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 11:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239501AbiKQLNO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 06:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239465AbiKQLMz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 06:12:55 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DD66E57E
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 03:12:15 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id s8so2243051lfc.8
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 03:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u3PS+VtSrFrxLksaUjnv7uLieMcy5jFloUEXJRVxtOw=;
        b=dWMhfGpYSMRZJAxIILk4u5bI3xKHNpB9c8PUTWjK131B/VgIL8hqAbEfGulPqqM5It
         1p9LZFgipPZkjqITTGFLt91nhdzY+NI6Y6AeU6jL2KIvSA2m/n5ofvO15gkfD2GA9Acx
         NOuyF2A5Yw/vaypN6gXmPzzH6jhw7KY+r4eOzoaHt55o4o8Q+Bns6mFoR4GW2j+0eXVf
         7wuVSgL/uBUbnndzuTIE4SXhg6RBndCsY8eH/lldeBJiJwV9Ei+zrXn6KywDaN9fjTyc
         kDsfGeHJGEzvPYdUhZgUaZ+a9zuJWKOwZ1AX60FX1dzFQq7/ufkBqwxYzyKQj3mdR8Ke
         m4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u3PS+VtSrFrxLksaUjnv7uLieMcy5jFloUEXJRVxtOw=;
        b=N+sQ5Of5ZEcq+2Yzgd6+Xryuk2e8D3Fpdvt5RFceeIXz6dk/zL7LtuDJoQxPSiboUw
         0NcOQr+J/GFtEbwONX273WkOujhvp6IRx5jYwGbI+YL8ZGtYQP+mow9SmUTgfDI4STXx
         2pINDxKI/lxwiicjy752aBMuQusNTIvX8ARVDLj4VvUnLrehFKFfc76oSr7VXxSOw8Nm
         6+J8b/6U3MJAkkn6PYjSkLME8MzyqBedl7NHdmUryp15OAy/TMJhp/ZqOjMiSy7eZs+U
         onzVA6LZ2QgW6NjJwmmDTtrgctmoSEJl0dtlsol5neOajePvBj3dkXKH3f2vRhbZAJDk
         EJeA==
X-Gm-Message-State: ANoB5pn2BZKzIQgjhGQDwGObpEjaHJTPuyQo7Tw6UVOxO8QafBgkwqyo
        RfSLMXIhVP6zIFbwrIoUwisCui7mk1udRWGy
X-Google-Smtp-Source: AA0mqf5N4xGvnBI+PoB5w8yEjy1UI3IH54OWh4czbWfAtjvgFBUfw9FYA92M5a7b3uV7o7xGW8+3hQ==
X-Received: by 2002:a05:6512:3c83:b0:4a2:3a78:106d with SMTP id h3-20020a0565123c8300b004a23a78106dmr677594lfv.419.1668683534199;
        Thu, 17 Nov 2022 03:12:14 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id m22-20020a0565120a9600b004a608ec6d8csm102436lfu.27.2022.11.17.03.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 03:12:13 -0800 (PST)
Message-ID: <ebd7e9f1-da9b-253d-0053-2327fd86e7f1@linaro.org>
Date:   Thu, 17 Nov 2022 12:12:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 0/2] qcom: add basic interconnect support to UFS
Content-Language: en-US
To:     Brian Masney <bmasney@redhat.com>, andersson@kernel.org
Cc:     agross@kernel.org, konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20221117104957.254648-1-bmasney@redhat.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221117104957.254648-1-bmasney@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/11/2022 11:49, Brian Masney wrote:
> This patch set adds very basic support for the interconnect framework
> to the Qualcomm portion of the UFS framework since the firmware on
> these platforms expects the interconnect votes to be present. The
> maximum throughput is requested to match what's already done in a few
> other drivers.
> 
> Here's the relevant entries from the interconnect_summary file in
> debugfs that shows the two ICC paths are setup for the first UFS
> host controller on the SA8540p automotive board (sc8280xp).

I wonder whether this is solving the same or orthogonal problem as my
old patchset here:

https://lore.kernel.org/all/20220513061347.46480-1-krzysztof.kozlowski@linaro.org/

Best regards,
Krzysztof

