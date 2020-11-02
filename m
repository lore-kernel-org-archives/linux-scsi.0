Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEC1C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 06:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF06F223B0
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 06:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZBIO8VmN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgKBGt4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 01:49:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726684AbgKBGt4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 01:49:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604299795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C7K4jgC+Vx55SiPAes+d1icJNBJZqTlzcr28+KO7H0E=;
        b=ZBIO8VmNIsNDMqMu1PUOkJGKzvSNioillYQ1ZyxIUE1B73a7xvvb0E60z9W/9bq98QLjFR
        qxgKpMIIUuOt/Xf1iI7INdgJwQclNd627+OPgNX7h7DbbeC+d+aValat8JTR1l21QlH90u
        2M/uerA9adFBUYVz631avcdo1khObYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-IFKll4nFNgq9855A5-ewGg-1; Mon, 02 Nov 2020 01:49:53 -0500
X-MC-Unique: IFKll4nFNgq9855A5-ewGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B0D21006C88;
        Mon,  2 Nov 2020 06:49:52 +0000 (UTC)
Received: from [10.72.13.42] (ovpn-13-42.pek2.redhat.com [10.72.13.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF6A355761;
        Mon,  2 Nov 2020 06:49:43 +0000 (UTC)
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
From:   Jason Wang <jasowang@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, stefanha@redhat.com,
        pbonzini@redhat.com
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
 <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
 <49c2fc29-348c-06db-4823-392f7476d318@oracle.com>
 <20201030044402-mutt-send-email-mst@kernel.org>
 <688e46b6-77f1-1629-0c93-e3a27d582da5@redhat.com>
Message-ID: <cf74844c-bfa6-e66c-fc3a-07dfd7af3092@redhat.com>
Date:   Mon, 2 Nov 2020 14:49:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <688e46b6-77f1-1629-0c93-e3a27d582da5@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/11/2 下午2:36, Jason Wang wrote:
>>
>> The need to share event/control vqs between devices is a problem though,
>> and sending lots of ioctls on things like reset is also not that 
>> elegant.
>> Jason, did you have a good solution in mind?
>
>
> Nope, I'm not familiar with SCSI so I don't even know sharing evt/cvq 
> is possible. Consider VHOST_SCSI_MAX_VQ is already 128 per device. 
> Mike's proposal seems to be better.
>
> Thanks 


Btw, it looks to me vhost_scsi_do_evt_work() has the assumption of iovec 
layout which needs to be fixed.

Thanks

