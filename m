Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B201C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 01:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiLOBN6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 20:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiLOBN5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 20:13:57 -0500
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B844554E6
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 17:13:56 -0800 (PST)
Received: by mail-qt1-f171.google.com with SMTP id s9so4038404qtx.6
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 17:13:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hh7Y8c7kvM/HzlfphURCvdoZB61L69AgI7sozF0odnw=;
        b=WyEKaiw4hsPd/RK2c/3I+UqN2lDednbmJXo1xuzKXr4mgrNYAmEibCW07006JUDRce
         Nnn+KrjG3KbpEyT8N2bBwh65DkvQjnrOsVNK3eySp8K7zRpc5ePEgLzzpR6cirSKukIe
         Ps1/oRhdqM8yX5gD5KOxWq1lsAJC+6vBKb7E4e6gzQjSVkj/lcqTAfjSTReoixCm/OhD
         oVsS2btDc9N4X7/pWh55zW0MygsFvRBoEcJFf2KEjqEk/72LSyodT3a7bMIvDr5RAOde
         1Xz+vn3zc+iui6u0H5kS+7rjXgKn4b2OU0k9yvS2Qwzs33OKFoxoeW71/3k0S6ue22AR
         I2sA==
X-Gm-Message-State: ANoB5plq99pTbABEOn7VhGS/LX7uUxbf0ebSlZ46PIZErrbqKYBjETCe
        rGtDySY2r47DJ5uVWl9okBI=
X-Google-Smtp-Source: AA0mqf5gr4fUOl4PHC52ELfYuwxzadRK63bvLkHOyNragrm72gOt+dTbFGrD7T6+fT54kj+RWWZ1XA==
X-Received: by 2002:ac8:7383:0:b0:3a8:2bf6:85ea with SMTP id t3-20020ac87383000000b003a82bf685eamr6981131qtp.49.1671066835352;
        Wed, 14 Dec 2022 17:13:55 -0800 (PST)
Received: from [172.22.37.189] (rrcs-76-81-102-5.west.biz.rr.com. [76.81.102.5])
        by smtp.gmail.com with ESMTPSA id d6-20020a05620a240600b006fcb4e01345sm11332645qkn.24.2022.12.14.17.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Dec 2022 17:13:54 -0800 (PST)
Message-ID: <40a872ea-c3c8-965d-6671-94d69480802b@acm.org>
Date:   Wed, 14 Dec 2022 15:13:51 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3 01/15] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221214235001.57267-1-michael.christie@oracle.com>
 <20221214235001.57267-2-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221214235001.57267-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/14/22 15:49, Mike Christie wrote:
> This begins to move the SCSI execution functions to use a struct for
> passing in optional args. This patch adds the new struct, temporarily
> converts scsi_execute and scsi_execute_req ands a new helper,
> scsi_execute_cmd, which takes the scsi_exec_args struct.
> 
> There should be no change in behavior. We no longer alilow users to pass
                                                       ^^^^^^
                                                       allow?
> in any request->rq_flags valu, but they were only passing in RQF_QUIET
                            ^^^^                                ^^^^^^^^^
                            value?                              RQF_PM?
> which we do support by allowing users to pass in the BLK_MQ_REQ flags used
> by blk_mq_alloc_request.
> 
> The next patches will convert scsi_execute and scsi_execute_req users to
> the new helpers then remove scsi_execute and scsi_execute_req.

After the patch description has been updated, please add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
