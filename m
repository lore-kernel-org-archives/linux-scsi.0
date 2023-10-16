Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD5EC41513
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 16:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbjJPQ7b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 12:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbjJPQ7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 12:59:17 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7689F44B4;
        Mon, 16 Oct 2023 09:32:38 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-27d5fe999caso911650a91.1;
        Mon, 16 Oct 2023 09:32:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697473958; x=1698078758;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cZ4qnCj7cgF2uTYw67Ao8nqWGK1nROVf78cl6b1udKc=;
        b=dzu725f9MGv079GrGZeFUyIZKz06wn6fENwm15Xfb8p7L1JhhcXxEoJby+JNxglRB0
         Loyfj/qS3V9FDGTvF1YhxF+NOUp6gOjs9tiB2RJ1gECeYLjPb5tfeAvdPBNHH3Hf+PiJ
         fIeZbXbS8H794V4C5b03B51XHNyQ8Lo5yHbeggdstdEfaOsOlsu8lOqFqOUUqilZbRIZ
         m7aTPjuCIHCX1LDV/feMl9gVf+2krpZ86y2wRvIwZKBL/5YRizTCMGmaNKBc1+m+mil3
         N1jRi340kg0qLfYTNYEqqCa3uX8+UKX0O0RTe9l6l/XIQKttNmbo6A5teSwUjp7um9p4
         A42A==
X-Gm-Message-State: AOJu0Yx4arMIW2XBhbe74IQ5YLWdG5vdAHXbiVxMYMmmqwlmzzzigSgL
        NAzfQ1Q0wCKLnYF0WfyAUKI=
X-Google-Smtp-Source: AGHT+IEeRmYVhkdCFEplFGdTEJXlcUDSRc7OfdLPuXJUTbY+17vp84Qvpg6cTN+zUsGknLaGd/2qmQ==
X-Received: by 2002:a17:90b:3d90:b0:27d:661f:59ac with SMTP id pq16-20020a17090b3d9000b0027d661f59acmr3845554pjb.38.1697473957647;
        Mon, 16 Oct 2023 09:32:37 -0700 (PDT)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id rr7-20020a17090b2b4700b00268b9862343sm4917723pjb.24.2023.10.16.09.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 09:32:37 -0700 (PDT)
Message-ID: <c0bd476c-452d-4993-acc8-749bd9585791@acm.org>
Date:   Mon, 16 Oct 2023 09:32:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/15] block: Support data lifetime in the I/O priority
 bitfield
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Hannes Reinecke <hare@suse.de>
References: <20231005194129.1882245-1-bvanassche@acm.org>
 <20231005194129.1882245-4-bvanassche@acm.org>
 <8aec03bb-4cef-9423-0ce4-c10d060afce4@kernel.org>
 <20231016061737.GA26670@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231016061737.GA26670@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 10/15/23 23:17, Christoph Hellwig wrote:
> On Fri, Oct 06, 2023 at 05:19:52PM +0900, Damien Le Moal wrote:
>> Your change seem to assume that it makes sense to be able to combine CDL with
>> lifetime hints. But does it really ?
> 
> Yes, it does.
> 
> 
>> CDL is of dubious value for solid state
>> media and as far as I know,
> 
> No, it's pretty useful and I'd bet my 2 cents that it will eventually
> show up in relevant standards and devices.
> 
> Even if it wasn't making our user interfaces exclusive would be a
> massive pain.
> 
>> The other question here if you really want to keep the bit separation approach
>> is: do we really need up to 64 different lifetime hints ? While the scsi
>> standard allows that much, does this many different lifetime make sense in
>> practice ? Can we ever think of a usecase that needs more than say 8 different
>> liftimes (3 bits) ? If you limit the number of possible lifetime hints to 8,
>> then we can keep 4 bits unused in the hint field for future features.
> 
> Yes, I think this is the smoking gun.  We should be fine with a much
> more limited number of lifetime hints, i.e. the user interface only
> exposes 5 hints, and supporting more in the in-kernel interfaces seems
> of rather doubtfuŀ use.

Thanks for the feedback Christoph. I will address this feedback in the
next version of this patch series.

Bart.
