Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372E8C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Nov 2022 01:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiKSBqV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 20:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiKSBqB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 20:46:01 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DC325F5;
        Fri, 18 Nov 2022 17:11:42 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id g10so5983733plo.11;
        Fri, 18 Nov 2022 17:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GWOuxOTYykRXqc3Xt2c+Su79gr+2rT37rwi5II2WE3k=;
        b=i75zmSTkVUK/u80Lu3z79AhtG8eNZ8pEfxAvkMiqHrLdpMdkOe50zd/swsrlDTG/Ai
         P+e4kILfZ3DVSYt2v54NM6dCv3jxcF0YAhBb3v6EYojhJh6o2UvJrtjKCW3w7Kxrw/Rz
         LIvFeZq59LpsdLxl4tuSzPQxjcG7o5ZihzaxWM6Hlo2BGunmVSOl40X1ev6l8QqAH5na
         2Bi2c/+LrMVjFME8r9r/11mY0Rh5ENZGTBlksq/zU0wM5vSvLTommpDV8MWR7SNKI+zw
         krZOkVeDodOn63mOZfJ2ksJ1Mw0q0WTN/gBdfaFScm6tQs226CQLFVh+hIOcYldj5U3L
         u4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GWOuxOTYykRXqc3Xt2c+Su79gr+2rT37rwi5II2WE3k=;
        b=lMn0VSlSEDTTqKcJ9mawFYr88DQExksIK28aoGEWk+GdBVBveYxn5qdu46y4sZ1K/l
         imoowKwYEhsGmy0+OpA/w6fboj3Ldj57JOX67PgYiEGb9aWebP6d2hibFdMtDV+SvYjJ
         nSoanD3SmTiWvqS1rd6wH9CO9aQbtrYBjpMTimllqjvF/89VaefcCxAcEBLzmSwGGm9H
         aK3VpdKqC9LhMFnvKQI5Ph+6xRTb4x102fUEQVJPNo8Rsecy3ICkSne6pMq6sGIYhDOs
         0GdY5xA7vWfuJaj81hc1b/fOlRTUTbK9sBkJI7QF0dsWr6qLs1E7bgi7gksRhSqfUp5J
         VJ2g==
X-Gm-Message-State: ANoB5pltzRk5LMTPTwYq/98rfAKfGe8k7C033XLfpYaOxEOIkapcttLR
        3DQX7ZNqMsViBvE9hIZEjBYsh7hO5Mw=
X-Google-Smtp-Source: AA0mqf6oizKt1BzAckPSYHffygIOtx1rle7D1nOjhyS5g0DMUPO/XCQjBl6VmHXzeoooOLJCts9uJg==
X-Received: by 2002:a17:90b:1942:b0:213:2262:e3f8 with SMTP id nk2-20020a17090b194200b002132262e3f8mr16257096pjb.82.1668820301457;
        Fri, 18 Nov 2022 17:11:41 -0800 (PST)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id oe4-20020a17090b394400b00213c7cf21c0sm3429592pjb.5.2022.11.18.17.11.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 17:11:39 -0800 (PST)
Message-ID: <40bcbc23-b510-b1fa-7e07-378db4a418e8@gmail.com>
Date:   Fri, 18 Nov 2022 17:11:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC] scsi: core: remove unsed 'restarts' from scsi_device
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, ming.lei@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com
References: <20221118113052.1324140-1-yukuai1@huaweicloud.com>
From:   Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <20221118113052.1324140-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/22 03:30, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>

Regarding the subject: unsed -> unused?

