Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C7C9C38147
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 22:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjAQWlY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 17:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjAQWk6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 17:40:58 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A09223C63;
        Tue, 17 Jan 2023 13:52:49 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso322022pjt.0;
        Tue, 17 Jan 2023 13:52:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Fx/Ac7f2UuF43h9XcVfG+gRV6XadeBjViZ6ZyjLZqw=;
        b=P5I7C1oc/IHhDP7XDJ9mUJYcALtkTtTbcvBnAri1b+C+kdL8BlzH5ph9vfLA35Qtdr
         Ea93yJhthjJOCTPrYoFntyitK1AVMT0bErCrLxfW3vOOajNYshWI1OD/n7d4XJJ3/nRx
         aiIs9cP8WZFSDznipXu/GFzl194tM9QnFQcEpb3+D9+vwnPXnJOa+QS00y0orZm/0bsk
         y+HN5Y4bk7ADGXVurk52BHBxurhgIxRwWVbrprepQCIQyL9Egf2/L+vuBP/yy//GLgll
         B8l891+188AheOUNJejVz9GTXBD1BRnZUFwA68nWxP4DYBKuCXoT/wQ4J2I38avl39U7
         08Aw==
X-Gm-Message-State: AFqh2koBeTCl7prx4mjIh7XO0zFtYVWI9h2Qfrlo7N4DPw9UCSeWsNkG
        eUcVtgjAKf3+V3e7X0gvO3c=
X-Google-Smtp-Source: AMrXdXtlz+9mZa+pAtDV4R+HvpQyxOsfMyY1BaaTos3fAWh+f9TOnibHNLH73OOh6u5ebO3voE/aBg==
X-Received: by 2002:a05:6a20:3d23:b0:b0:4c16:10a6 with SMTP id y35-20020a056a203d2300b000b04c1610a6mr6111582pzi.0.1673992368838;
        Tue, 17 Jan 2023 13:52:48 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:f632:d9f5:6cbb:17d0? ([2620:15c:211:201:f632:d9f5:6cbb:17d0])
        by smtp.gmail.com with ESMTPSA id bg7-20020a056a02010700b004785c24ffb4sm8772093pgb.26.2023.01.17.13.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 13:52:48 -0800 (PST)
Message-ID: <2bea9c3e-2a61-a51e-c13b-796adabe6f71@acm.org>
Date:   Tue, 17 Jan 2023 13:52:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>,
        Steffen Maier <maier@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
 <017b6c73f56505e63519e4b79fe69d66abddf810.camel@suse.com>
 <a9da2b27-882f-bc8e-3400-cb53440e2159@acm.org>
 <125f247806396f19fd27dcfa71f530b5b4a529a6.camel@suse.com>
 <c23a6bf4-0b6e-0bbb-b74d-af69756bcf9a@acm.org>
 <ab7d61dd7f7c0289114e36fef6e9f282ad5c976b.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ab7d61dd7f7c0289114e36fef6e9f282ad5c976b.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 13:48, Martin Wilck wrote:
> Yes, that was my suggestion. Just defer the scsi_device_put() call in
> alua_rtpg_queue() in the case where the actual RTPG handler is not
> queued. I won't have time for that before next week though.

Hi Martin,

Do you agree that the call trace shared by Steffen is not sufficient to 
conclude that this change is necessary?

Thanks,

Bart.

