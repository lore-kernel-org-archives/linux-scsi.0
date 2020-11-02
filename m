Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A7FC00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 05:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43F1020870
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 05:57:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZG4s69P9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgKBF5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 00:57:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727306AbgKBF5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 00:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604296636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Chvvc87ZiQGdVbH/KclajGTi8q9ae76wxWdLpfbOgtM=;
        b=ZG4s69P9c0aw/s9vJGrf7CwU/1fvDvoWEFI4vq7zkicP2uuT8ZV6s8qIlNIswbxaUPq4R2
        dvXZDMwVXpagXL0p1AAE2ziaStGfWK1PJ57SMPcZGru9+Y5oChOTaWfPGMKtH/qlCsDpx5
        T8TqNCvbn/d71PHV0OtYwPRCOkQ6cTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374--oFwCbQCN82weSN9FUtC5w-1; Mon, 02 Nov 2020 00:57:14 -0500
X-MC-Unique: -oFwCbQCN82weSN9FUtC5w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E0C81074651;
        Mon,  2 Nov 2020 05:57:13 +0000 (UTC)
Received: from [10.72.13.42] (ovpn-13-42.pek2.redhat.com [10.72.13.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 317F560C15;
        Mon,  2 Nov 2020 05:57:03 +0000 (UTC)
Subject: Re: [PATCH 04/17] vhost: prep vhost_dev_init users to handle failures
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-5-git-send-email-michael.christie@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0f4a5f72-01e7-46d1-f214-c61cbb812859@redhat.com>
Date:   Mon, 2 Nov 2020 13:57:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1603326903-27052-5-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/10/22 上午8:34, Mike Christie wrote:
> This is just a prep patch to get vhost_dev_init callers ready to handle
> the next patch where the function can fail. In this patch vhost_dev_init
> just returns 0, but I think it's easier to check for goto/error handling
> errors separated from the next patch.
>
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> ---
>   drivers/vhost/net.c   | 11 +++++++----
>   drivers/vhost/scsi.c  |  7 +++++--
>   drivers/vhost/test.c  |  9 +++++++--
>   drivers/vhost/vdpa.c  |  7 +++++--
>   drivers/vhost/vhost.c | 14 ++++++++------
>   drivers/vhost/vhost.h | 10 +++++-----
>   drivers/vhost/vsock.c |  9 ++++++---
>   7 files changed, 43 insertions(+), 24 deletions(-)


Acked-by: Jason Wang <jasowang@redhat.com>


