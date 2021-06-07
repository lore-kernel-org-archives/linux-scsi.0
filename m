Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE298C4743D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 02:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7437611C0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 02:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhFGCUa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Jun 2021 22:20:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20729 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230130AbhFGCUa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2021 22:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623032319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/YSBBQ9cGooM1hAnJfrax+C1tCPnWfT7V7/0+qUaI/k=;
        b=WkRHesx/Dtb7jd8qpLScFGqe3Xq0hPC0aJk4KknY8qXrpo3ZMoJuNtTW0hesZ5pf8nkeKX
        NAJFsMsZsTcVB1dizvb0TxybO2w8H4F1VGSsBVSkfbQMvYxuYD2TnUnv/V5Gf3oTZxhchn
        LGXlYIZ+lrEux+1sMcvX3i+xDEdbCy8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-UHk4V0ItO_SbWzQS2DY9jw-1; Sun, 06 Jun 2021 22:18:38 -0400
X-MC-Unique: UHk4V0ItO_SbWzQS2DY9jw-1
Received: by mail-pj1-f71.google.com with SMTP id y17-20020a17090aa411b02901649daab2b1so10376281pjp.5
        for <linux-scsi@vger.kernel.org>; Sun, 06 Jun 2021 19:18:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/YSBBQ9cGooM1hAnJfrax+C1tCPnWfT7V7/0+qUaI/k=;
        b=LPDLKxttLETLKbLQAhjHGrNlvZzfWa87em9JRJborzBFQQP9CapB3opA7c4Ssan7JP
         gINfmHWZnsXlERcBzXBF3A49ApDWajH9Fezu+Nm2+SVjLpIjG6oNA0kn8Po3aqeMqM2t
         lAD4U1UykN0p1kVn4pjMuVz5aaaPKkeDNQSC7QhAajp8VTYKczFgoOkmBKdp6tRnYClW
         t93OstjrTCUC22iV9MM+69zmDK0UwGrhb7hH2k3gnxRn+MBmaEZGBPDLENGCk46TmfO4
         VIIP3XNayNd/PmQ+Hs4rqCEbgiGXwVuqVm+W2tpLpFTaNPim4q5hYWqOBBfPJhoC2j7Q
         yBjA==
X-Gm-Message-State: AOAM5303aPxMhr93tFXNmeW+1mhIDtEmsxppb5S3cFQ9TVWxqrcUg+UT
        0NSnWCY1EZ0QmKvSwdRSO7pjNd7AOgx+RwIH2R7vP30731VP2+eoahE/WvUgB9I7xEXEjuDLJUA
        6YMZ4uaPnP4cuwi70pPxHvQ==
X-Received: by 2002:a17:902:c403:b029:106:7793:3fcc with SMTP id k3-20020a170902c403b029010677933fccmr15707463plk.81.1623032317076;
        Sun, 06 Jun 2021 19:18:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1Mz9rWZDNywIxinqZddVbgfmBbg3wbcfPQEw6zpB+wsjqIzZBnXaVdGeLRKGzInGbXtwyVA==
X-Received: by 2002:a17:902:c403:b029:106:7793:3fcc with SMTP id k3-20020a170902c403b029010677933fccmr15707445plk.81.1623032316810;
        Sun, 06 Jun 2021 19:18:36 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w21sm2048729pfq.143.2021.06.06.19.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 19:18:36 -0700 (PDT)
Subject: Re: [PATCH 9/9] vhost: support sharing workers across devs
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210525180600.6349-1-michael.christie@oracle.com>
 <20210525180600.6349-10-michael.christie@oracle.com>
 <YLjoDjas6ga3Ovad@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f475f7fe-75ec-02fe-34a3-df8c863e8a73@redhat.com>
Date:   Mon, 7 Jun 2021 10:18:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YLjoDjas6ga3Ovad@stefanha-x1.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


在 2021/6/3 下午10:32, Stefan Hajnoczi 写道:
> On Tue, May 25, 2021 at 01:06:00PM -0500, Mike Christie wrote:
>> This allows a worker to handle multiple device's vqs.
>>
>> TODO:
>> - The worker is attached to the cgroup of the device that created it. In
>> this patch you can share workers with devices with different owners which
>> could be in different cgroups. Do we want to restict sharing workers with
>> devices that have the same owner (dev->mm value)?
> Question for Michael or Jason.


I thing sharing workers within a cgroup should be fine.

The differences is that if we restrict the works with the same owner, it 
may only work in the case where an VM have multiple vhost devices.

Thanks



