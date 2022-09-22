Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71148C6FA8B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 17:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiIVRDo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 13:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiIVRDk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 13:03:40 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F4630F7A
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 10:03:36 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id l65so9903095pfl.8
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 10:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hIDv9nB8sJ9lg6B3kvWDXQ2HReVJNqKYyuCsa3fcc34=;
        b=F9/VgopNGlpDi/Ce37kFgCwuoqcQ1sjzqUcfFeVqruqTWs7cAEXvlveKUfnkLDahcd
         au5zdrAaOuYLqLIEuiGi3SlE2i0EZSEmsFWMitM/uvcHpFKSAOdakdLx5w6aLOWX4Et2
         l6NXo5ogf7irJE2HveyN0BaLeh5v/zb2b7pIfnuv+QMp9To/Cm1A8UbxhtVamPyTSWVP
         xzBkHSDltQvHODm3jHEoTk/VlDYo2wx1djhdOerz0Yel89HTOlxDuY4O3uJnIeKTX0i1
         y0RMua6gMSaTDAn5T8FgInpJsS/q5fLVxHg2GUxGpv4IMWyiSjQ0EcfLpw6y7npDo87X
         BtUw==
X-Gm-Message-State: ACrzQf09FG+0lrecpeE9fgNEcH8TYPyyeQ21zhn1GjJvCRiG5gqtG8vI
        X4nI07lhPo9v5+4hVkxSih0=
X-Google-Smtp-Source: AMsMyM5pNd+nwN+oBJO1txkdLUXza5umKx8mT/aM04IAtrOVTzSqBIMseME575RZPEfHV+XFyMN40Q==
X-Received: by 2002:a65:5184:0:b0:439:14cb:fbe4 with SMTP id h4-20020a655184000000b0043914cbfbe4mr3761634pgq.166.1663866215595;
        Thu, 22 Sep 2022 10:03:35 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:7c7b:f882:f26a:23ca? ([2620:15c:211:201:7c7b:f882:f26a:23ca])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902b68100b0017519b86996sm4282506pls.218.2022.09.22.10.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 10:03:34 -0700 (PDT)
Message-ID: <1cc0e85d-a530-a8da-42a0-91230b65c6b4@acm.org>
Date:   Thu, 22 Sep 2022 10:03:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH RFC 04/22] scsi: Have scsi-ml retry scsi_probe_lun errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220922100704.753666-1-michael.christie@oracle.com>
 <20220922100704.753666-5-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220922100704.753666-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/22 03:06, Mike Christie wrote:
> +	struct scsi_failure failures[] = {
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = 0x28,
> +			.ascq = 0,
> +			.allowed = 3,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{
> +			.sense = UNIT_ATTENTION,
> +			.asc = 0x29,
> +			.ascq = 0,
> +			.allowed = 3,
> +			.result = SAM_STAT_CHECK_CONDITION,
> +		},
> +		{},
> +	};

Can the 'failures' array be declared 'static const'?

Thanks,

Bart.
