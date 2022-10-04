Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F4EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJDWsf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiJDWsc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:48:32 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18D8520A3
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:48:31 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id u24so6916590plq.12
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:48:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=uJI9bpcr9CylHT6FvwKyeHKnSaiQnluDzPj7Ua+vdYI=;
        b=SUvnUpwUN+zMeNSqIlxgsCFEbbXODdrODpOz2E2IcGPMOsZydsaMxBT1NfuJjh6uAA
         1dfeqlSdHwFaAqI3rAqN70A+vtUkn1qP+wXctz8fvbJleNx10o9LHBN/CB0A8HV90UTJ
         OfppNZjgByJSp0IVcWog1nS2ubef3JP8v8tjIswvsDTa+tJNou3J9/A85p1NYnmTcWoc
         +TR06x1LFsQTiluXNttc1PlwXrP4gAUH6Z+15/2oyedSw1PNVVCmUXot9qKm06/0cZM0
         8B/fNI7aNBb9PgMO9T38z2x1BM8GyFQh+YZz6uBBNFYmL7zu1YmvwS6v/iQtFG1he5t/
         H1Hw==
X-Gm-Message-State: ACrzQf1REEI9fEZLLtJa7RXjGqivR7QZyxGtqpdOeUyhqcOcorSn398d
        uCJdsTL9P/O5vUkQ8pCWSDg=
X-Google-Smtp-Source: AMsMyM4kFhUptcbJdQwkPzPJ/tz+vZea+SjlA0DOR9wpIG/Yj1zyYxV1oowmIEsIW/f0u84+x+pZpQ==
X-Received: by 2002:a17:902:f70e:b0:178:9a17:8e42 with SMTP id h14-20020a170902f70e00b001789a178e42mr29623450plo.14.1664923711138;
        Tue, 04 Oct 2022 15:48:31 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id x25-20020aa79419000000b00561c179e17dsm2011796pfo.76.2022.10.04.15.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:48:30 -0700 (PDT)
Message-ID: <fb3500d8-cb11-746a-b50e-cefddbf5c825@acm.org>
Date:   Tue, 4 Oct 2022 15:48:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 17/35] scsi: ufshcd: Convert to scsi_exec_req
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-18-michael.christie@oracle.com>
 <2063d871-2798-06e4-d6d0-bce1d6e32da9@acm.org>
In-Reply-To: <2063d871-2798-06e4-d6d0-bce1d6e32da9@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/4/22 15:47, Bart Van Assche wrote:
> On 10/3/22 10:53, Mike Christie wrote:
>> scsi_execute* is going to be removed. Convert to scsi_exec_req so
>> we pass all args in a scsi_exec_args struct.
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

(replying to my own email)

Hi Mike,

Please ignore the above Reviewed-by since I already replied with an
Acked-by to this patch.

Bart.


