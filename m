Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57889C11F66
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 10:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45D7D619AD
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 10:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhGFKPx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 06:15:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231362AbhGFKPw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 06:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625566392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UdbP9WvOMnnXkMiAx8SSh/Xyar5eu75VziOeoXPg7vQ=;
        b=iU3xpg6W0FClU5Cxrx6MrCR2tpAAWXzfr4WskUM7G8gFKTdvYdrnPMGwNGilB6pKmk1ueE
        GH89O+IEF6RIYwnk0c8EHEIpgQ7c7uzeb+aOMdfwiylU/VctCr8FJjnptp3QPJnREcoDYI
        YjDToyB1VXebMzrtXZ9RjbR30cwjIZY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-nh2qb5PIP3mimEoZBgyOtg-1; Tue, 06 Jul 2021 06:13:11 -0400
X-MC-Unique: nh2qb5PIP3mimEoZBgyOtg-1
Received: by mail-wm1-f70.google.com with SMTP id m31-20020a05600c3b1fb02902082e9b2132so918443wms.5
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jul 2021 03:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UdbP9WvOMnnXkMiAx8SSh/Xyar5eu75VziOeoXPg7vQ=;
        b=h3K1M5vbY8Gl6esOcHncu5AmC0uU7vNNeLSIbkIpWDbfXNoPblMIIuJynkijZD0kIe
         708f3SsxD1OvAliJBRVKmDK0or0kFqJ14lX0h8U4ngIzpD1cacCDxmPegAiWzevNzox6
         ez954b/PBTCgf++D9N4/RKVWShDZj5C/Z7whzogBb0soYUtKkOI1fhMGJbkHOqK+g2I/
         k8X6ZgzEAIaenH4HhnfYuxlkKgKymfDx06lwhMM3MlItF5kYpIG7KNIK0YXso9KESY4B
         u7XODvs6lIAjkTi43biZzF/y7gGmjokaRTDacWu2AdrC8VK4QeostTQVEC3Gc+Bm8ore
         87cg==
X-Gm-Message-State: AOAM532xhIDjtOr6SbhidN32HVkxUIsu/NLVH/cJt4Z12auImD2BLftQ
        SpuhgjBlbZwOznJ6UfTCogjW9u2iZX61chCYb/8sktzrd7vy34NoD+SVHJ6+c5TdrHoOxOdAqj0
        xcVKBFL/wC9LbHIVFivhFiA==
X-Received: by 2002:adf:f54e:: with SMTP id j14mr20648365wrp.373.1625566390312;
        Tue, 06 Jul 2021 03:13:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4V2nazX3V0PXum+kvfO29LxwBUB/ZWyTGJPIPsll6HWmlVpOewleeKpK4mLBKQCrXh9hJEQ==
X-Received: by 2002:adf:f54e:: with SMTP id j14mr20648301wrp.373.1625566389908;
        Tue, 06 Jul 2021 03:13:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w22sm2345342wmc.4.2021.07.06.03.13.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 03:13:09 -0700 (PDT)
To:     Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, emilne@redhat.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nkoenig@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Alasdair G Kergon <agk@redhat.com>
References: <20210628151558.2289-1-mwilck@suse.com>
 <20210628151558.2289-4-mwilck@suse.com> <20210701075629.GA25768@lst.de>
 <de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
 <20210701113442.GA10793@lst.de>
 <003727e7a195cb0f525cc2d7abda3a19ff16eb98.camel@suse.com>
 <e6d76740-e0ed-861a-ef0c-959e738c3ef5@redhat.com>
 <5909eff8-82fb-039e-41d3-1612c22498a9@suse.de>
 <a088aa5c8459c001403bda9384b38213f8232fc6.camel@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 3/3] dm mpath: add CONFIG_DM_MULTIPATH_SG_IO
 - failover for SG_IO
Message-ID: <e5fc1d54-8443-49f4-078e-1453c6a97ba7@redhat.com>
Date:   Tue, 6 Jul 2021 12:13:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a088aa5c8459c001403bda9384b38213f8232fc6.camel@suse.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/07/21 15:48, Martin Wilck wrote:
> On Mo, 2021-07-05 at 15:11 +0200, Hannes Reinecke wrote:
>> On 7/5/21 3:02 PM, Paolo Bonzini wrote:
>>> On 02/07/21 16:21, Martin Wilck wrote:
>>>>> SG_IO gives you raw access to the SCSI logic unit, and you get
>>>>> to
>>>>> keep the pieces if anything goes wrong.
>>>>
>>>> That's a very fragile user space API, on the fringe of being
>>>> useless
>>>> IMO.
>>>
>>> Indeed.  If SG_IO is for raw access to an ITL nexus, it shouldn't
>>> be supported at all by mpath devices.  If on the other hand SG_IO is
>>> for raw access to a LUN, there is no reason for it to not support
>>> failover.
>>
>> Or we look at IO_URING_OP_URING_CMD, to send raw cdbs via io_uring.
>> And delegate SG_IO to raw access to an ITL nexus.
>> Doesn't help with existing issues, but should get a clean way
>> forward.
> 
> I still have to understand how this would help with the retrying
> semantics. Wouldn't we get the exact same problem if a path error
> occurs?

Also, how would the URING_CMD API differ from SG_IO modulo one being a 
ioctl and one being io_uring-based?  In the end what you have to do is 
1) send a CDB and optionally some data 2) get back a status and 
optionally some data and sense.  Whether the intended use of the API is 
for an ITL nexus or a LUN doesn't really matter.  So, what is the 
rationale for "SG_IO is for a nexus" in the first place, if you think 
that "raw CDBs for a LUN" is a useful operation?  You can still use 
DM_TABLE_STATUS (iirc) to address a specific ITL nexus if desired.

Besides the virtualization case, think of udev rules that use SG_IO to 
retrieve the device identification page for an mpath device and create 
corresponding symlinks in /dev.  They would fail if the first path is 
not responding, which is not desirable.

Paolo

