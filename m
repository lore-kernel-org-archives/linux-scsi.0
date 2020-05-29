Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF73C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 08:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30763206A4
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 08:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590739558;
	bh=lmmUdZavgSWWJI88lwNJQxEXBjg5ptFnhm41Nw8mR5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=D9rbwJxxhz+yB+deaWOFftobCmWNbjGe/lo3gGXuvE+h5XmxFtAi1R8Oo+xru4WQS
	 qWWnR9+Pat4LpV9sZnta9LVh2owbthJTt/wO1RPwOjIFZBunII7CNrkbuGQSehbwUn
	 tCo9hA81yA3I3KyPh2OScbx+EK3O7S97xlKUlpjI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgE2IF5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 04:05:57 -0400
Received: from mail-ej1-f68.google.com ([209.85.218.68]:40359 "EHLO
        mail-ej1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgE2IFw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 04:05:52 -0400
Received: by mail-ej1-f68.google.com with SMTP id d7so1174691eja.7;
        Fri, 29 May 2020 01:05:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=aH7E55+g7tLuSmdUOuHD3M6Gj2I7pkdvk/bOkBrFD9s=;
        b=aWy44fvGPmS9kfAO8oyaixY+yxR8/9+ymtIlqTIto0oabqHOs4OnN4VEg6xq1aRoxt
         BGZzvexS6uCfNHYvLr5DXa4hyKsXE26gKC12XB/xTxUj/VZQp1MNTFeAIWVAM9PehGUb
         VsVs9P251HhU/KEIhHKmL4m3TPNNWHtXF0jRB8boy1Ox+lAgGPYNIHDNohaGHkz+qKkT
         y687c6kyU/qsCAZz4EJ4F1+T4+8YdcMIZ1dM4a2KN4kQxXZQ7ILW0J6Ovki/lpxDL41L
         QTNZ1HDW3ylo5gF/WzeZ4WZLMpeoltqaE8jWz152PnzcIgEoJ7NEywrwKmFKwcaKCnvl
         i8yg==
X-Gm-Message-State: AOAM532GvAE2AF08RPJ7RGrw0BajekcX3iK6rV2G9xFutgZ/gm9SHL3K
        XBLCjlj/Pt70OW21UcZS8e8=
X-Google-Smtp-Source: ABdhPJx+ramGOxadWDDPayrB2z7pr/lamG6HZzIkpX+Z0OBDsG27LJ9P+Xa/l75LOv7pVv0uNZiXIQ==
X-Received: by 2002:a17:906:70ca:: with SMTP id g10mr6704592ejk.171.1590739550084;
        Fri, 29 May 2020 01:05:50 -0700 (PDT)
Received: from kozik-lap ([194.230.155.118])
        by smtp.googlemail.com with ESMTPSA id k90sm6207616edc.2.2020.05.29.01.05.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2020 01:05:49 -0700 (PDT)
Date:   Fri, 29 May 2020 10:05:46 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, avri.altman@wdc.com,
        martin.petersen@oracle.com, kwmad.kim@samsung.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 10/10] arm64: dts: Add node for ufs exynos7
Message-ID: <20200529080546.GB23221@kozik-lap>
References: <20200528011658.71590-1-alim.akhtar@samsung.com>
 <CGME20200528013245epcas5p37851891649512882c7b1ffb5f903c506@epcas5p3.samsung.com>
 <20200528011658.71590-11-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200528011658.71590-11-alim.akhtar@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 28, 2020 at 06:46:58AM +0530, Alim Akhtar wrote:
> Adding dt node foe UFS and UFS-PHY for exynos7 SoC.
> 
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> Tested-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> ---
>  .../boot/dts/exynos/exynos7-espresso.dts      |  4 ++
>  arch/arm64/boot/dts/exynos/exynos7.dtsi       | 43 ++++++++++++++++++-

Thanks, applied to next/dt-late. It might miss this merge
window and in such case I will keep it for v5.9 cycle.

Best regards,
Krzysztof

