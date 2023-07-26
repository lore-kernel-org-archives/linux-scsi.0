Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84C5C0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 15:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbjGZPQ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 11:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbjGZPQS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 11:16:18 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A7F2689;
        Wed, 26 Jul 2023 08:15:55 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-686d8c8fc65so551269b3a.0;
        Wed, 26 Jul 2023 08:15:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690384550; x=1690989350;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=40AQ+XJtyU4wwLajz5n0xznNpRCm8LEwpMPI/0Nzfig=;
        b=AJwOrH390Mi9kvrxa1Hj1NDZQ5qk6N0vQDzyi2KXzBaEAJ1KDvLxoV3JUojPiysORP
         v19GdO3NPU/eq2qNqSY3lt0bURJMFgcaj+QDLtrgWcoNcHkSHc+9QOxVeVhemcPqxl0e
         USfksh+8nQ94JF0B0AIMsJ2lQPQPWp5/6tu24NpuqcOT75ZB3jD/9H+Vo9QiKyDYCWlk
         Wz8rWAn1ZJzbNKmE5w680qKX0idYITmnKVyWALs/nnX74Ti9t7E0hh84ukW+DbnTSOgS
         q2bFUTP2zVQo1e9CO1tyHIKz9qV9ypjejj+OGPja3KBevsW/ff6E8tTUyKRjkoJlPJXN
         Qn4g==
X-Gm-Message-State: ABy/qLYH3wlZKaJSySX5aO3rgGEr4hqGGdU1/g9cqAL8UjyYefNXElHP
        Oa2CS+nMI+MWNwDZmbYonsyBoC0VYq8=
X-Google-Smtp-Source: APBJJlHqGQPyqEqeCryi2vnEVxVRhMDF2EtGYa5yBPkqQu3AdMGWF42HPtc7d/xyEzyuiSl2fFULMA==
X-Received: by 2002:a05:6a21:78a3:b0:12e:ae87:45d2 with SMTP id bf35-20020a056a2178a300b0012eae8745d2mr2151952pzc.51.1690384549821;
        Wed, 26 Jul 2023 08:15:49 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:7ecb:b0e6:dc38:b05f? ([2620:15c:211:201:7ecb:b0e6:dc38:b05f])
        by smtp.gmail.com with ESMTPSA id x9-20020a056a00270900b00654228f9e93sm11585586pfv.120.2023.07.26.08.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jul 2023 08:15:49 -0700 (PDT)
Message-ID: <f3a58522-3957-bd70-df87-9df7e4547195@acm.org>
Date:   Wed, 26 Jul 2023 08:15:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH 2/3] target: core: apply the new wrapper to spc
Content-Language: en-US
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        martin.petersen@oracle.com, michael.christie@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux@yadro.com
References: <20230726115509.357-1-a.kovaleva@yadro.com>
 <20230726115509.357-3-a.kovaleva@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230726115509.357-3-a.kovaleva@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/26/23 04:55, Anastasia Kovaleva wrote:
> +#define TARGET_PREFIX "core"

I'm not sure this is a good choice for a logging prefix since this name 
does not make it clear that log lines come from the SCSI target core. 
How about "scsi_tgt" as prefix? "stgt" is probably not a good choice 
since this is the former name of a user-space SCSI target project 
(https://github.com/fujita/tgt).

Bart.

