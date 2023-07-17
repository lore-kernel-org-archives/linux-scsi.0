Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46ABAEB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 19:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbjGQT1C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 15:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjGQT06 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 15:26:58 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FDCE49
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 12:26:54 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6687466137bso3150978b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 12:26:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689622014; x=1692214014;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wjBN+72PYw2JGGUS3jbRod54wwy5HBBfXbml7qoCTMs=;
        b=eMESaLqnk/rq5oqC9f76CqUP9zrlkZ9Idxxi6SXPBidHUc0tTyx46XwwH1cQ/VYT+H
         Lq8Rfz1OEzMwKJDMTXOD7N9feSSj9IoEKK6sfS60VsgPZHk1bNrjXWoLqZG9LO0G56Hs
         Kt2sHaCPDqk/NYh07JOGZyLf1JiD77uH0YgbpBoiXISB6q/kWfSlIBUjpq5LPGm6LNpB
         0mlHOkBo9yMazsJWIMVF/cjkIA9+0nTnlgVOnQzMWgyfW8FeSN7uyAWMt0NefS90NCXI
         j8PA+XJS3NB8EaVdVmc5DkmQ6GT8IiN05VFVpwv733kU8Ljli37AS1VdKsibdiEEXvVZ
         UlSw==
X-Gm-Message-State: ABy/qLacv37zqx4YOSJPtaCOAchgLlqFP6hPva723vF1vh8jbGm/sZOU
        2GP7IjxZDHEWaam3gmwvEYU=
X-Google-Smtp-Source: APBJJlHHYuG59/eXF5CNJ21u8cnM6v6p6/Cs3PyEMakkVObb8JPHRo1CS6R7RnuwoxzRmavTi5USbw==
X-Received: by 2002:a05:6a20:258a:b0:135:4858:681 with SMTP id k10-20020a056a20258a00b0013548580681mr1402789pzd.9.1689622013666;
        Mon, 17 Jul 2023 12:26:53 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ac3:b183:3725:4b8f? ([2620:15c:211:201:ac3:b183:3725:4b8f])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902704600b001b9c960ffeasm256601plt.47.2023.07.17.12.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 12:26:53 -0700 (PDT)
Message-ID: <fb5f5cae-e473-cf58-69d3-aa41c984d51b@acm.org>
Date:   Mon, 17 Jul 2023 12:26:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v10 28/33] scsi: ufs: Have scsi-ml retry start stop errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-29-michael.christie@oracle.com>
 <38793488-3785-3685-7919-814a338158a5@acm.org>
 <b624c3a1-84bd-a567-025a-dbfc533f621b@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b624c3a1-84bd-a567-025a-dbfc533f621b@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/17/23 11:29, Mike Christie wrote:
> On 7/17/23 12:05 PM, Bart Van Assche wrote:
>> The original code only retries if ->result > 0. Is my understanding
>> correct that the new code retries SCSI command execution whether
>> ->result is < 0 or > 0? If so, I think this patch introduces an
>> unintended behavior change.
> 
> The new code does not retry when result is < 0.
> 
> SCMD_FAILURE_RESULT_ANY is for cases where result > 0.

Right. Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
