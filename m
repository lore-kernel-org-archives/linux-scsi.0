Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0A2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 06:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiGFG4m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 02:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiGFG4l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 02:56:41 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9D31D0FB
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 23:56:40 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id y18so6396036ljj.6
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jul 2022 23:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dZ0To80wgdekuL2hyZGIgermbtkhesmEIoMBMbQ82tQ=;
        b=Z/1jtAlZWICe5vn5+geZN3yVRVnVjMaw1TSPghZRYylwEC+OuLEB46PwXHYIKm48ph
         dFrQNoJCHgYBUQh4Dyk8fWDCRKQ8G+ezdJtrW7vUUrBnNxs2m7TqYYZWERilI3jfc8xX
         4gCr+EGrefFA9rIGZbbmgcuy84ycqDq0ZlRpA4meBWidGmUsz6bgi1S8S+w6VMoLw7O0
         fP+5QA9PffLp5LwbEIOueCAV7Kyr8ZLx6Y7Sgqx4BHpWSZMdhOm1+0nxo7wXfl/6AsOI
         idiJLhXhayY5vOThJpVQKlTPo4BMC+BmLFMWHws1GZKYAbXa9P1uEZ8cyzyuvs5sgJDU
         XG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dZ0To80wgdekuL2hyZGIgermbtkhesmEIoMBMbQ82tQ=;
        b=mqj0QrMq078vqROyPGqsTbm+47olNL19G+AKDJPJNTYvisW8eytgVTjWzMLARpnr+9
         LCNMCPpBJViymP9t4s1Q3oh0W8z0DFaWKv+pbW6xpck4lIs9vCNeIp35j3QJ4JMSuy4m
         wCi3zTFtmGrhmkhfRWQNc2VHRTAPK1bvNdOPaoyzjsIAnj+khbqlSIm0Vw9znHHXg87v
         ihYkz6vcO9BpP6LO3EcTBwFrI6WWZat3yx5WYZt71+FtBUonc7m34OtuM4W8tihWYMyx
         uO56kjzWkvdDoAbA30cq0TfgPN82seW+7ZP9R1sIWoCiFhSaxslPY00JjdUMcA4jibEP
         3aPA==
X-Gm-Message-State: AJIora81+YL7cbzEnqrDb3dG8XYrBKd/jbTs8ZnwgTke+PE9rzxSxIPs
        1IwdmWYx0wAy2P/yf4sywN3E/A==
X-Google-Smtp-Source: AGRyM1t+FtQEWMzZAGSJ6USAizbm35hIvCOAr/zIS1APEwOpW70KzXLCRRlgGceJMVRTLlwxkT535w==
X-Received: by 2002:a2e:2243:0:b0:25a:9dc3:fd81 with SMTP id i64-20020a2e2243000000b0025a9dc3fd81mr21433054lji.387.1657090598560;
        Tue, 05 Jul 2022 23:56:38 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id y22-20020a05651c107600b0025d38eb7390sm643961ljm.43.2022.07.05.23.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 23:56:38 -0700 (PDT)
Message-ID: <da999ea7-dbd1-c4ac-132e-7e6720fa469a@linaro.org>
Date:   Wed, 6 Jul 2022 08:56:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 3/3] ufs: ufs-exynos: change ufs phy control sequence
Content-Language: en-US
To:     Chanho Park <chanho61.park@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
References: <20220706020255.151177-1-chanho61.park@samsung.com>
 <CGME20220706020541epcas2p1c74a1d1b5ca37ee4795bf9ec0da23fa9@epcas2p1.samsung.com>
 <20220706020255.151177-4-chanho61.park@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220706020255.151177-4-chanho61.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/07/2022 04:02, Chanho Park wrote:
> Since commit 1599069a62c6 ("phy: core: Warn when phy_power_on is called
> before phy_init"), below warning has been reported.
> 
> phy_power_on was called before phy_init
> 
> To address this, we need to remove phy_power_on from
> exynos_ufs_phy_init and move it after phy_init. phy_power_off and
> phy_exit are also necessary in exynos_ufs_remove.
> 
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
