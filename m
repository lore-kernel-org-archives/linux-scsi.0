Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3036C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA616610EA
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbhINDYW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:24:22 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:39456 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238901AbhINDYV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 23:24:21 -0400
Received: by mail-pf1-f178.google.com with SMTP id e16so10837585pfc.6;
        Mon, 13 Sep 2021 20:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sXdm6Z9DA7+o083V6MRzxK6U4l2Js+yCvrccU9cF5zI=;
        b=ZfxkElickV39K5h0mR398p2NRoiwDbirXc9AuBkj6a4FkXsaCzSSA3PgB7cFe2YVMJ
         h7Ip7z11I5x9+FE5U72XUGVwEcm7zg9A2X5p3MhrpGtF2cbdRHdO68dLTlf3OPNoxqUV
         9Yn/DHAGH3baHHHViMKvIZT9KV+Xe7/rpbtg/uE0TOyhg5J1fKMMHfyQVvjkMnXdYg2C
         KJi5NfoRi0Hv4hLY2D0gvkI5wOGf8PoV9ijMS7hE9IW8HQIYaShH4gRh1X6ubEtMTCcf
         PUwBTV1xfruau58qSr4t1QjmEtSzBXcb/7vK3A10xB7MGUVvkYrxA2iygw8YuwkOVZry
         rUeQ==
X-Gm-Message-State: AOAM5328+IlY3QVdyZ4zqNF3kk/4pGdcrRFII1jIkXq3HDu0vvHaLT0v
        PnFao5fL/7KIAXTCo747vAk=
X-Google-Smtp-Source: ABdhPJwlGAYaNH88tev/TPlNavWU2YeRy3ZBTX4vmY9xLeXD+LBOR6qK35RfChI49sAR/zW/YDWxzQ==
X-Received: by 2002:a63:7d55:: with SMTP id m21mr14079307pgn.455.1631589784451;
        Mon, 13 Sep 2021 20:23:04 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:e47e:ab85:4d9e:deba? ([2601:647:4000:d7:e47e:ab85:4d9e:deba])
        by smtp.gmail.com with ESMTPSA id q18sm8623247pfj.46.2021.09.13.20.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 20:23:03 -0700 (PDT)
Message-ID: <f277507b-b62e-c874-b2ad-276ea03d2263@acm.org>
Date:   Mon, 13 Sep 2021 20:23:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v2 0/3] scsi: ufs: introduce vendor isr
Content-Language: en-US
To:     Alim Akhtar <alim.akhtar@gmail.com>
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
References: <CGME20210913081148epcas2p21c23ca6a745f40083ee7d6e7da4d7c00@epcas2p2.samsung.com>
 <cover.1631519695.git.kwmad.kim@samsung.com>
 <fbdd02bc-01ab-c5b3-9355-3ebe04601b04@acm.org>
 <CAGOxZ51X-ThsqV35PiTh-awRvAkQ=Fjf9m+KRd1HLZ+pDNi=Xg@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAGOxZ51X-ThsqV35PiTh-awRvAkQ=Fjf9m+KRd1HLZ+pDNi=Xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 10:26, Alim Akhtar wrote:
> Thanks for your input. Completely agree with you, in fact your
> suggestions make sense to me. As a driver developer, surely we can
> take these concerns to the IP designers and see how far we can get in
> terms of standardization. That, however, is not something that can be
> accomplished overnight. My main concern is, what about millions of
> devices which are already in the market? UFS subsystem does support
> _vops_ to handle vendor specific hooks/modifications. I am not saying
> we should always follow this path, but surely until these deviations 
> are either fixed or become part of UFS standard itself, IMO.
Hi Alim,

If there are already millions of devices in the market that support this 
feature then that's an argument to proceed with this patch series.

Thanks,

Bart.
