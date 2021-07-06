Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3C7C07E96
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 16:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D7761C29
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 16:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhGFQmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 12:42:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230003AbhGFQmo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 12:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625589605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C7aeEiE0261u8W/0alOEA+0ULo/TNVUkzeKthLCdrp4=;
        b=CG00CNIg7MILKLdV0XCZ1/iJZWqXN5ql6dt8w17+qb2ZfCNjKKVA40JQyw/yCfyocgXJaS
        GQKDJ6bqM5YfFX+CeO3N2QkK2pMLzGVhtiSqBXLBBogZZpP/DUw9I0idGN4kI8w6Gqeez3
        AUD0HXLdf/Fps3ka762artGFGhvOqTA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-z1A4f5xhMDWEwBhsn33Azw-1; Tue, 06 Jul 2021 12:40:04 -0400
X-MC-Unique: z1A4f5xhMDWEwBhsn33Azw-1
Received: by mail-wm1-f70.google.com with SMTP id p6-20020a05600c3586b029020b46124c2eso663289wmq.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jul 2021 09:40:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C7aeEiE0261u8W/0alOEA+0ULo/TNVUkzeKthLCdrp4=;
        b=SeNdGYdvT8j/gkTWFI4NdaJfwbvENtPlmH6FikDKyPRuFzW0ib5QdbaHmquL0H8Rq+
         AMM6zA088aH9Joz2dA30lhSC7tdI7c2qk7Jxbn7eevGzcytf1bZJN/GiTcQnc/5FNMxC
         y3Km3V13qyBcz0S6RLaP7YjyF8xPE9YEBF3oRJwBoPqigDygwAoLVzHSCAWC4QVitxuR
         CJn1aAt3aZSOoQzXSm4I8zMfocXu7iLebJbbuUabWtSK6XGgu7kS+rqzN4qbWsVSqyP0
         RiCstGQkqoPvngBURqFQ+IB6eoGDCNqUT5MrrGAO00ccDit8S5XjZJupe+OvznVVUiPg
         5DfA==
X-Gm-Message-State: AOAM531jDedzyUEqJUvArSdZAETF4vksAvUob94s4AYSyKamWGzxBIp/
        Oant33KqNLVl26VMDVpAcp5HVo8W81C31Jw0hAh+k/R+fDa0AR8oYNXqHqG6BtMfQCvo6EpEV/P
        5G/7fIMbEuYivBOl0d41R5Q==
X-Received: by 2002:a05:6000:c7:: with SMTP id q7mr23180010wrx.161.1625589603379;
        Tue, 06 Jul 2021 09:40:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNa8oOAmHc+evx+g5AXkNFehnVgc0Nv+HoZ2GPwmuf0hZx2Q0JR3vf24Nzu8rCgpPOuZ1Thg==
X-Received: by 2002:a05:6000:c7:: with SMTP id q7mr23179993wrx.161.1625589603216;
        Tue, 06 Jul 2021 09:40:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z3sm20259622wrv.45.2021.07.06.09.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 09:40:02 -0700 (PDT)
Subject: Re: [PATCH v4 1/3] scsi: scsi_ioctl: export
 __scsi_result_to_blk_status()
To:     Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Martin Wilck <mwilck@suse.com>, Mike Snitzer <snitzer@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alasdair G Kergon <agk@redhat.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Benjamin Marzinski <bmarzins@redhat.com>, nkoenig@redhat.com,
        emilne@redhat.com
References: <20210628095210.26249-2-mwilck@suse.com>
 <20210628095341.GA4105@lst.de>
 <4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
 <20210629125909.GB14372@lst.de>
 <2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
 <20210629212316.GA3367857@dhcp-10-100-145-180.wdc.com>
 <1aa1f875e7a85f9a331e88e4f8482588176bdb3a.camel@suse.com>
 <YNyVafnX09cOIZPe@redhat.com>
 <da3039c75c892f7d4031161f7c8719e50de36057.camel@suse.com>
 <1c05c65e-64a2-0584-1888-1f544998365e@acm.org>
 <20210701061901.GA22293@lst.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f96bf6c9-d7a3-bfdc-a645-b6b070f9e9cc@redhat.com>
Date:   Tue, 6 Jul 2021 18:40:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701061901.GA22293@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/07/21 08:19, Christoph Hellwig wrote:
> http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/scsi-ioctl
> 
> But more importantly, dm has no business interpreting the errors.  Just
> like how SG_IO processing generally does not look at the error and
> just returns it to userspace and leaves error handling to the caller
> so should be the decision to resubmit it in a multi-path setup.

The problem is that userspace does not have a way to direct the command 
to a different path in the resubmission.  It may not even have 
permission to issue DM_TABLE_STATUS, or to access the /dev nodes for the 
underlying paths, so without Martin's patches SG_IO on dm-mpath is 
basically unreliable by design.

Paolo

