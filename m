Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD1DC432BE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 03:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF58260EFE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 03:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhHRDFL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 23:05:11 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:40646 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbhHRDFK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 23:05:10 -0400
Received: by mail-pj1-f42.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso7932135pjh.5;
        Tue, 17 Aug 2021 20:04:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kFS3Uq6ZsmHwK49T3dK2XWC9mQnUHrZ+V1QDcN5t0xw=;
        b=VRH2gXd/7zoS7GPxz6HWcKbM+99zzoPXYl+dJrq6qRf6mer4YCnO5SAaGkXCeZp53e
         6qIp3fT8SyP83wiMcwecrWAwItf8OSTbnlNn8fDqn2fVTVH0oT/rFpn29gli76R25ORb
         qPzWBoT2frQMMfLIHbkRKivSTsUhu2gjIyncl3hO9A7HxrxuGMPyjey69KR7J6Rj/zif
         CeETkvoF+usOCsPmG7GZgH1yPmefh8JJ/aSeq2Z/if9uE2AY3bgJgZIQoPZuYG2qE6Tr
         GYDxnozPQQVcrAHZ/P6qepZrJFdJ9oyHW2mBf/H+wfq7i/vfRTV8WRmcqRedGsrvIak/
         L7PA==
X-Gm-Message-State: AOAM53090V7Y9CiPT/pQWMtQ9XDbxtsupG9XYFzeOd6fi1mBAI6UUed9
        DNcmzwfb+2/oGl4GguF7g0rkvOQrbJE=
X-Google-Smtp-Source: ABdhPJwiosH7FRNM+MeGt6bzDDz27hcq7NauAuf6SA6Kd4OUf3t5QxW8j9tarrxTkYERVxYBJNYY4Q==
X-Received: by 2002:a17:902:e850:b0:12d:91c6:1cd with SMTP id t16-20020a170902e85000b0012d91c601cdmr5415481plg.16.1629255875931;
        Tue, 17 Aug 2021 20:04:35 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:a2e:bdc6:d31c:3f87? ([2601:647:4000:d7:a2e:bdc6:d31c:3f87])
        by smtp.gmail.com with ESMTPSA id y12sm4995991pgk.7.2021.08.17.20.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 20:04:35 -0700 (PDT)
Subject: Re: [PATCH] scsi: ibmvfc: Stop using scsi_cmnd.tag
To:     John Garry <john.garry@huawei.com>, tyreld@linux.ibm.com,
        mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, hare@suse.de, hch@lst.de,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au
References: <1629207817-211936-1-git-send-email-john.garry@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7c43a1e8-d10d-901c-a3a2-de36bb238ae5@acm.org>
Date:   Tue, 17 Aug 2021 20:04:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1629207817-211936-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 6:43 AM, John Garry wrote:
> Use scsi_cmd_to_rq(scsi_cmnd)->tag in preference to scsi_cmnd.tag.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
