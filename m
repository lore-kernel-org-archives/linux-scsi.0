Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B224C2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 02:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1234206D8
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 02:50:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EV632HYG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbgKJCup (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 21:50:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727311AbgKJCuo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 21:50:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604976643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cN43+bPvc1CdMAPDr88esBeeC4ALthX2RLH8XdHg4RI=;
        b=EV632HYGHrfN825X0fYEYhmBC6y4ZJ+ifddwoMJkcL9OBCjPK90bPOHUasF8JqhY6gTqGV
        N86wlBzbTsJtod6osLVEUn9ewC4TwXUBmmtassdth60iRohfpX4c7r9InliNcxs8eXYkPg
        Li4JPvJEE9NlP6uMjIrIG+yPUvJ/lLg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-lc8ooORmPL2OfARN71KMng-1; Mon, 09 Nov 2020 21:50:40 -0500
X-MC-Unique: lc8ooORmPL2OfARN71KMng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CA675F9C0;
        Tue, 10 Nov 2020 02:50:39 +0000 (UTC)
Received: from [10.72.13.94] (ovpn-13-94.pek2.redhat.com [10.72.13.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53FEC5D9DD;
        Tue, 10 Nov 2020 02:50:31 +0000 (UTC)
Subject: Re: [PATCH 06/11] vhost: support delayed vq creation
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
 <1604528804-2878-7-git-send-email-michael.christie@oracle.com>
 <56056e8d-d6ff-9a6e-2a7e-1ea1737b1d27@redhat.com>
 <54285b79-637e-3dcd-382f-ddeff44f6019@oracle.com>
 <fc22b679-08c1-85bb-515a-8f63de7148a2@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5a64e2d5-1b8b-7bc6-2793-a34206c59d75@redhat.com>
Date:   Tue, 10 Nov 2020 10:50:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fc22b679-08c1-85bb-515a-8f63de7148a2@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/11/10 上午4:30, Mike Christie wrote:
> On 11/9/20 12:41 PM, Mike Christie wrote:
>>
>> If you want to pair this patchset down to it's bare bug fixes that 
>> prevent users from getting IO errors, I would do ring.addr check only 
>> approach for this bug fix patchset.
>
> Oh yeah, just so we don't have to burn an extra day, above I'm 
> proposing I repost the original patchset:
>
> https://lore.kernel.org/linux-scsi/1600712588-9514-1-git-send-email-michael.christie@oracle.com/t/ 
>
>
> for the bug fix only patches. It will have the compile error fixed and 
> Bart's comment handled.
>
> To even trim it down more I can also drop the last 2 patches:
>
> 0007-vhost-remove-work-arg-from-vhost_work_flush.patch
> 0008-vhost-scsi-remove-extra-flushes.patch
>
> and send separately in a cleanups patchset since the extra flushes it 
> kills don't really hurt.


Fine with me.

Thanks


