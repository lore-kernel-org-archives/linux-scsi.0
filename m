Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3513FC07E99
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 13:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0977A6144E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 13:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhGENEv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 09:04:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231266AbhGENEu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 09:04:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625490133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EQiaDZSDRoWhnvLd0y+F7CVOe8BAX1HmtgpDqCLODno=;
        b=UCobMq1xVyocOei0GJppSkR7p6enEZj+efKzAXpkr3P6A3YCw+qO7ZLKWBg+SshPLTcJn1
        uLzVXALMg3C8SLTVPg/yOd5A1gV3X07/QagXc0bhwCf7Nic2Py/Yoy4yvO5K4qJ7XLwGt3
        CH472QUC+/59qszjiahfKKCFfJc2LF8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-54Utm0WYN2S2BfUvqRy-7Q-1; Mon, 05 Jul 2021 09:02:12 -0400
X-MC-Unique: 54Utm0WYN2S2BfUvqRy-7Q-1
Received: by mail-wm1-f72.google.com with SMTP id u64-20020a1cdd430000b02901ed0109da5fso9865620wmg.4
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jul 2021 06:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EQiaDZSDRoWhnvLd0y+F7CVOe8BAX1HmtgpDqCLODno=;
        b=CKNA2aS4KDszFa+cEIrUs5467pgv9bxaGt8Kff4KBuMMJQygyT1T3O+RF/qllEX/9E
         KvU0e/2SBTq50M9zruE40R5w+HkEkF9+U/0z6Apr2H/AsYOLfg/guCIYgrUsKzicVmjs
         jth3CAjeBZkfFTR4OHC9Ji2YfHOy98ufvuXlVW2XOVGwzMJbcW9ImmfJbaB28uWpAym1
         S14Cgq6VhtsFKpLRVonniNoX1/DaxvYlcA2EGfK4WaJUDah3NzjNG9zQdcMHUsZaGfrz
         UPaS/Feu4sPzTpIFj1UOIQxWDl0gNBBAE2BWyikzmyMoRYipm2Qd83dXJyLS7NgE+B15
         Ap0g==
X-Gm-Message-State: AOAM533zyhWdnEM7XdsW2ubDzYSD5VjiUDIbIh4cMWSOXcWRNH7HqSCf
        qu3Fz5ttkhf53JxsWbv6c3FxScfIBDtDCsG24feMiN7LuLzhv4StU3R0rIdaJtGxKWhYzNmGsET
        xN9XbueiIjOU3hDiuWrHsYA==
X-Received: by 2002:a7b:ca43:: with SMTP id m3mr14772436wml.74.1625490131335;
        Mon, 05 Jul 2021 06:02:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzS6R45eQdBafjJCfhd1vm8LmWsahyCdE9gLBl2N2UbSQMBfrvMPQtX8pBLO/KLwWonQWqk0g==
X-Received: by 2002:a7b:ca43:: with SMTP id m3mr14772386wml.74.1625490130998;
        Mon, 05 Jul 2021 06:02:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 16sm12186756wmk.18.2021.07.05.06.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 06:02:09 -0700 (PDT)
Subject: Re: [dm-devel] [PATCH v5 3/3] dm mpath: add CONFIG_DM_MULTIPATH_SG_IO
 - failover for SG_IO
To:     Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>, emilne@redhat.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nkoenig@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Alasdair G Kergon <agk@redhat.com>
References: <20210628151558.2289-1-mwilck@suse.com>
 <20210628151558.2289-4-mwilck@suse.com> <20210701075629.GA25768@lst.de>
 <de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
 <20210701113442.GA10793@lst.de>
 <003727e7a195cb0f525cc2d7abda3a19ff16eb98.camel@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e6d76740-e0ed-861a-ef0c-959e738c3ef5@redhat.com>
Date:   Mon, 5 Jul 2021 15:02:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <003727e7a195cb0f525cc2d7abda3a19ff16eb98.camel@suse.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/07/21 16:21, Martin Wilck wrote:
>> SG_IO gives you raw access to the SCSI logic unit, and you get to
>> keep the pieces if anything goes wrong.
> 
> That's a very fragile user space API, on the fringe of being useless
> IMO.

Indeed.  If SG_IO is for raw access to an ITL nexus, it shouldn't be
supported at all by mpath devices.  If on the other hand SG_IO is for
raw access to a LUN, there is no reason for it to not support failover.

Paolo

