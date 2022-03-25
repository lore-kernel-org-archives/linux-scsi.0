Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F41C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Mar 2022 09:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354111AbiCYJIe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Mar 2022 05:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiCYJId (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2022 05:08:33 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5310CD33A;
        Fri, 25 Mar 2022 02:06:59 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id k10so8485236edj.2;
        Fri, 25 Mar 2022 02:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VhdVUAWHXjzUGq4oP9g7su55g+qs75mizf7QQXpvJEw=;
        b=euZVYebCE4XJ6h2KVEIZN/sxeNdWBhCLQ41F3VbBi73AFa8s6umon5UZl9YlT8u9vD
         fp5poY35XXFvreG/fDo9a+X3woO+AKZa38cO0DSYqK+Dg+LmytrvB9q4rUXqVhP0E0qK
         bWQTPeb835PslboqVCKK8yVwr6+RZXn+Pcj5irL12oEbLAKjT/cPXQAmCp4Uz1Wu1Kjg
         +tffZ3ZZLqEIRodZ7+iJuewi0Age1X4soOIbsnvEAit3U5iUNsTTEoz4k4QfSfCdqEHh
         yH+VoYrCj3wY1l5+lrFZJAzocKld8uAYeFiOVipvXPyK+TigtwMG/UQDqaT08hNZyR6C
         HZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VhdVUAWHXjzUGq4oP9g7su55g+qs75mizf7QQXpvJEw=;
        b=es+MrmEUR4sGbkxC2OWDgyCL+qq+RKcAA4YuZVLgT4RISul2PO3ataL5PF849JifjP
         JEeRWdlxw5mIUH1/dvURJn+eSc96T5XDY4/nEzP6w48NvB1WMBXaiqu6wRSuZ1+vqemS
         g5sbd5QnhydkSOVIci/5sJB50sJuspeICtbmOTHEHNorNOZ7p7hlIFh+b/iUVSb95kiP
         J9Wsu1tFAMRgHG8o1iI+pAzWwvHR0l0elY8D8F2SXxCBvRTWet+k+dzVm1WWOuQUYhQb
         EaKTxqcqTvlPVKstERTCVs1F9tNTCUQiCiYEQOYQowwcu79rrmXxYv5ED+2uHy6ffKrW
         sRQg==
X-Gm-Message-State: AOAM532NasESIedtkyxqnHrWKwzRKMrEJJzVgkFGnjhufBjUGfJj6s4c
        eT/xbNSEs3DM4hK3UEpmk98=
X-Google-Smtp-Source: ABdhPJx01pPWcYHPsWa/D2UX3hyEAgDAM3v69gqG2zc9S5TZfdLa41DCwYMxLs2+YR31sY0zcWOsoQ==
X-Received: by 2002:a05:6402:4315:b0:419:2e38:ab8f with SMTP id m21-20020a056402431500b004192e38ab8fmr11628871edc.250.1648199218448;
        Fri, 25 Mar 2022 02:06:58 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id e9-20020a170906c00900b006d4a45869basm2087116ejz.199.2022.03.25.02.06.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 02:06:58 -0700 (PDT)
Message-ID: <d15369a8-7a98-1b1a-b950-40d78ed5e9ec@gmail.com>
Date:   Fri, 25 Mar 2022 10:06:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC 3/3] scsi: target: tcmu: Support zero copy
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-mm@kvack.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, xuyu@linux.alibaba.com
References: <20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com>
 <20220318095531.15479-4-xiaoguang.wang@linux.alibaba.com>
 <94b00e49-5efb-658f-3142-42e7cc551d19@gmail.com>
 <57da7e54-f582-3b10-52a9-5166adacf4e6@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <57da7e54-f582-3b10-52a9-5166adacf4e6@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 23.03.22 15:33, Xiaoguang Wang wrote:

... snip ...

>> What happens if the tcmu device currently is not open / mapped?
> I'm not sure how it will happen.
> But we may check whether udev->vma has a valid value. If yes,
> it'll enter tcmu_cmd_zerocopy_map().
> 

Yeah, but what I also wanted to suggest is, that if userspace maps
the uio device while zero copy cmds already being in the ring,
you have to iterate over those cmds and populate the mapping.

Bodo
