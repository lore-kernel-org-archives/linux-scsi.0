Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D5AC54EAA
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 20:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbjA0Uod (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 15:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbjA0Uob (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 15:44:31 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D3E7E05F
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2023 12:44:03 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id b10so5707112pjo.1
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2023 12:44:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=52wpdKvl7nLqTMNq3a1fe6Tc4ELdw994Z1EKdlORxMw=;
        b=Y2wbe1xT9RVSTVB3QMOs21WEIfbmXFanilxxCpw1P1kdzJR1SH+pI528HNNZSyUGwB
         +uPVydyLWGtTiXAbb4xOrroM6UO7uoFxibBn0IZhf/qCcT062SKv6DJiVvzV6r/BgNm5
         +K6h0sdoCHQVXrWRsrtLzHu160/JF1Vq7fAf8qWyKfs1PRm2192LdNLxq+BAYhIeN7+i
         lSRmeZ9nicOEU9rqFfqSekLoDFoRtNClcGuI8lFvPkWV9lUg/hFprE4m7S+na7INDJlk
         UvlKKratFGB4k+oYKWti1ufkq4G9tmG+hJ2kGpBlAWpyRTG/P/SjmRgpJ0hKKwvqSpxy
         0W8A==
X-Gm-Message-State: AO0yUKW/QLCyEgjnQN54pC3fW1VooiVyO3DkBbXW7Qe1+ieTansxQvbQ
        pFYy7WMT+Sq3rUVqJkwasqw=
X-Google-Smtp-Source: AK7set8MhvieNBTCdIZBXtTk+2aXo/4hiqQRJ+6Ox4t+QnfH4uZ001EX0dngFo22A8a1Rznk3/OwSQ==
X-Received: by 2002:a17:902:dacf:b0:196:15bc:e200 with SMTP id q15-20020a170902dacf00b0019615bce200mr16693804plx.4.1674852195599;
        Fri, 27 Jan 2023 12:43:15 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5051:6ed0:9022:37aa? ([2620:15c:211:201:5051:6ed0:9022:37aa])
        by smtp.gmail.com with ESMTPSA id ix1-20020a170902f80100b001960e9dd05esm3282796plb.112.2023.01.27.12.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 12:43:14 -0800 (PST)
Message-ID: <65e11f62-0109-ee6f-0cd0-56ae30dd1208@acm.org>
Date:   Fri, 27 Jan 2023 12:43:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: The PQ=1 saga
Content-Language: en-US
To:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
 <4f9794d2-00ed-22da-2b4b-e8afa424bf17@acm.org>
 <d0ac216445c33e9bf98e8c850f4d900acf0787bd.camel@suse.com>
 <9545766a-298d-1358-46f0-64ccfaf30ca0@suse.de>
 <6A8AA317-32B0-48F4-82DC-82B65A221A9F@purestorage.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6A8AA317-32B0-48F4-82DC-82B65A221A9F@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/23 11:57, Brian Bunker wrote:
> So the question becomes how should initial scan work when a LUN has a PQ=1 set.
> It is a valid, by spec with ALUA state unavailable but doesn’t seem to be
> handled. Why allow an sg device but not an sd one on initial scan in this case? There
> are probably many ways to fix this. I think the simplest is to allow sd device creation
> on LUNs were PQ=1, and only restrict PQ=3. I am not sure the side effect of this on other
> targets. The other approach which will no longer work after the revert is to trigger a
> rescan from the target. This is sub-optimal since it is disruptive. Any approach involving
> the ALUA device handler will not help since there is no device to transition if it is
> discovered with PQ=1.

When Mike Christie and I looked into the ALUA unavailable state many 
years ago we concluded that using this state is so troublesome that it's 
better not to use this state. How about using active/optimized and 
active/non-optimized instead?

Thanks,

Bart.

