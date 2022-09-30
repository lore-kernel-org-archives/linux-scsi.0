Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D3EC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 20:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiI3Uoc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Sep 2022 16:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiI3Uoa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2022 16:44:30 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D291F4946
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 13:44:30 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso7624924pjq.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 13:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=lQTVmiGy4XA8SJdBOXa49cK5LJCm8IUJP4Jl86RWpeM=;
        b=J3gadySMJ6OZpVnISLB+cFOWG8Mfl5s6UaaAmw8CUq+Dub5tzIoXCS0an6XHPYpGzu
         g9SPv7gVISRFMVVz0WMcLOQJ7ipB+RpoLCyZVSVaU3cYurYD1IhoK63o7Ssk/zwQ3H22
         855oMxfrYc34sKbrSic1aGD0aEPwW7xekNukrwxHd4mMOZ1a6OlgY5WMDs6sBZyaWecl
         K4VnVvJlv3y2+WM6Qe9vygKfm3jN0t2RpjIb68TEGOHqcHCu9TbRTLzaV+5ZjC4fR3pk
         yvfJQ8siYfAqLaaukAHq0dH1Z4qZ98MbFfQo09Dx7x2KUrL4YryS6KjhKvsQrfITHNns
         bq+Q==
X-Gm-Message-State: ACrzQf1S31lWNfNI22E4zi6sXujYj+zUkGv/JBP0tNgXhU6QJEzCEd7M
        2mMnPalritS769jbdnvvpDQ=
X-Google-Smtp-Source: AMsMyM4vtqJtuvFGN5HE9nwADzNivEWqLh9pin2dDmGeUeJD2XG8e1LlvHmbGKYSLhb+l4O+73jTwQ==
X-Received: by 2002:a17:902:c9cc:b0:17a:a81:2a8c with SMTP id q12-20020a170902c9cc00b0017a0a812a8cmr10643885pld.6.1664570669633;
        Fri, 30 Sep 2022 13:44:29 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9b89:d9c:f74c:7711? ([2620:15c:211:201:9b89:d9c:f74c:7711])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a195e00b001ef8ab65052sm2062433pjh.11.2022.09.30.13.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 13:44:28 -0700 (PDT)
Message-ID: <1b0169cf-8158-557b-c544-f1b6df2143c4@acm.org>
Date:   Fri, 30 Sep 2022 13:44:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v1 00/16] Add Multi Circular Queue Support
Content-Language: en-US
To:     Asutosh Das <quic_asutoshd@quicinc.com>, mani@kernel.org,
        quic_nguyenb@quicinc.com, quic_xiaosenh@quicinc.com,
        quic_cang@quicinc.com, quic_nitirawa@quicinc.com,
        quic_rampraka@quicinc.com, quic_richardp@quicinc.com,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        avri.altman@wdc.com, beanhuo@micron.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
References: <cover.1663894792.git.quic_asutoshd@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cover.1663894792.git.quic_asutoshd@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/22 18:05, Asutosh Das wrote:
> Please take a look and let us know your thoughts.

Except for the comments I added this series looks good to me.

Thanks,

Bart.
