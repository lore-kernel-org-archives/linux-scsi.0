Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199E3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Mar 2022 13:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348064AbiCUNpe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Mar 2022 09:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348058AbiCUNpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2022 09:45:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD1321AD86
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 06:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647870247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pnAmXlnXLTHp0iSG/dGGWw30Ukf/zjdTAa7UkhvknLc=;
        b=NX+j0Dvh5BKNRqXFeQrb9HU0rNb5UcAga2gOBdxYKuu2cAzvWZ1/hImUY2D4N4WDHu8IT7
        VgznPU7YT/2XIs0GSyNM8StkpvaqqVUeXsQWlay22rQDinyPRzWjtj6sQ7J/IuHaqoEKia
        b+i3khRY5SoSS52n/YKX3fk+IuK+2a8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-BCc3l4DoMEm7Dxq_rIPacg-1; Mon, 21 Mar 2022 09:44:06 -0400
X-MC-Unique: BCc3l4DoMEm7Dxq_rIPacg-1
Received: by mail-qt1-f197.google.com with SMTP id x10-20020ac8700a000000b002c3ef8fc44cso9296654qtm.8
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 06:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pnAmXlnXLTHp0iSG/dGGWw30Ukf/zjdTAa7UkhvknLc=;
        b=K7Kqi/uy+sp/ZeUXwnTiGJ6IfI1xH+IRYI9P5VA8m4DVpwhRgH27G+9eIXFJyiqC/y
         4YtlCey5mhvLixq5Ixa/yHKCp8Bh8FTdvH0Z96B9NzSNuwrRWCRlaSQiH/dkMvfD7jkd
         CwgVzobsFtKCWd5A9cy2GSVTv0ejAA7C7IfkoVo5ZQrrOjmMT0waK6bxJrSqrdyQDlRG
         PbJa+5g5/hzmZiZkjKwK7SRvk+e8rZEJ2B+CIz7hUaX9ThjRCwftaOkpkny249/jd094
         lr3Y0ACnehe8saPIB3YPlORHRbjIXw7nFfdpuptgrdshJR0ZU5W2BKwPcXhJ3pZ7YzHR
         0MWw==
X-Gm-Message-State: AOAM533hhZ5dVl/mibwDmYSowsr/O0VD9ayS6YELhsE9iRxfjzbkNXfY
        +7BTZ4Lv2qDkibJrpiDGUsSs1y1AiKi1U6BdgSdQ7KPYv+eHm/61uVjxCPAK5FajzhKWtSMBKf0
        G3oLMDxQTnM+rum2wFiK1xA==
X-Received: by 2002:a05:622a:1052:b0:2e1:fe6b:377d with SMTP id f18-20020a05622a105200b002e1fe6b377dmr13196872qte.229.1647870245099;
        Mon, 21 Mar 2022 06:44:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCbc10lLPdAfISHXGX6/OQIVT02pfqbNlUvvEv/dlqMfFKGpEgfAK1zb2wblj6cYu2rsDSkg==
X-Received: by 2002:a05:622a:1052:b0:2e1:fe6b:377d with SMTP id f18-20020a05622a105200b002e1fe6b377dmr13196847qte.229.1647870244882;
        Mon, 21 Mar 2022 06:44:04 -0700 (PDT)
Received: from xps13 (c-98-239-145-235.hsd1.wv.comcast.net. [98.239.145.235])
        by smtp.gmail.com with ESMTPSA id v3-20020a05622a188300b002e1cbca8ea4sm12420986qtc.59.2022.03.21.06.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 06:44:04 -0700 (PDT)
Date:   Mon, 21 Mar 2022 09:44:03 -0400
From:   Brian Masney <bmasney@redhat.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>
Subject: Re: [RFT] ufs: qcom: drop custom Android boot parameters
Message-ID: <YjiBIx+QY2EtFBtO@xps13>
References: <20220320110616.18355-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220320110616.18355-1-krzk@kernel.org>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Mar 20, 2022 at 12:06:16PM +0100, Krzysztof Kozlowski wrote:
> The QCOM UFS driver requires an androidboot.bootdevice command line
> argument matching the UFS device name.  If the name is different, it
> refuses to probe.  Thise androidboot.bootdevice is provided by
> stock/vendor (from an Android-based device) bootloader.
> 
> This does not make sense from Linux point of view.  Driver should be
> able to boot regardless of bootloader.  Driver should not depend on some
> Android custom environment data.
> 
> Cc: Luca Weiss <luca.weiss@fairphone.com>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

I encountered that same code a few months ago and thought then that
this code doesn't belong here.

Reviewed-by: Brian Masney <bmasney@redhat.com>

