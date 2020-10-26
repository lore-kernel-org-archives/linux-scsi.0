Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0524AC2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 03:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 928C92168B
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 03:52:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fMVhCsJf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421963AbgJZDv7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 23:51:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411352AbgJZDv7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Oct 2020 23:51:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603684318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B96VQp5HaByKyaBby/4vR2lYXsuofffHkRFppaIEY0Y=;
        b=fMVhCsJf/sxaU5ZC+fdwsXxLF9K7o35Do1iGlm/IAeKmvZ3U6G2Gn6BR0LJIm1R1sMH0J/
        pBMEzR8UBVMXVQyxC50BVoL/leZj/c7xt58Sut6LFB9MmHCqA7L5ldYfWFDzWGjHCQU/tF
        W9aYqFvb2OTpWNHaf2DIW0KKnfG3dvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-3oe9CLd_Ni6fMvt4f2OxRw-1; Sun, 25 Oct 2020 23:51:54 -0400
X-MC-Unique: 3oe9CLd_Ni6fMvt4f2OxRw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 273658049CF;
        Mon, 26 Oct 2020 03:51:53 +0000 (UTC)
Received: from [10.72.13.201] (ovpn-13-201.pek2.redhat.com [10.72.13.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1062D55781;
        Mon, 26 Oct 2020 03:51:38 +0000 (UTC)
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
Date:   Mon, 26 Oct 2020 11:51:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/10/22 上午8:34, Mike Christie wrote:
> Each vhost-scsi device will need a evt and ctl queue, but the number
> of IO queues depends on whatever the user has configured in userspace.
> This patch has vhost-scsi create the evt, ctl and one IO vq at device
> open time. We then create the other IO vqs when userspace starts to
> set them up. We still waste some mem on the vq and scsi vq structs,
> but we don't waste mem on iovec related arrays and for later patches
> we know which queues are used by the dev->nvqs value.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/vhost/scsi.c | 19 +++++++++++++++----
>   1 file changed, 15 insertions(+), 4 deletions(-)


Not familiar with SCSI. But I wonder if it could behave like vhost-net.

E.g userspace should known the number of virtqueues so it can just open 
and close multiple vhost-scsi file descriptors.

Thanks

