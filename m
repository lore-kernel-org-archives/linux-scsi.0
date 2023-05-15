Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2AC4C77B75
	for <linux-scsi@archiver.kernel.org>; Mon, 15 May 2023 08:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjEOIq1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 May 2023 04:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEOIq0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2023 04:46:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE8FB0
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2023 01:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684140349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FzdTTm54ffhyFjajMYLOi/MjjYQueX7ItYGaiPJCBpg=;
        b=EpuyWmVQBIudAP/kLwZIFUQsRFrFmyVjm7JmF36m+3WqbU/1GNLwRtN/L59dMw9vmKRVpy
        iDEtW1Q494Rp/KE+9l5S6NGoFvrzVulhAXVrX3ggw5aemO3u2jjlTMsJxMzB0DrNbpU6qQ
        szL0N6iTWpI7AY7N678oqPCPq3tKMqI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-GrXF1C4eMKagw6RDus72XQ-1; Mon, 15 May 2023 04:45:44 -0400
X-MC-Unique: GrXF1C4eMKagw6RDus72XQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8D62802A95;
        Mon, 15 May 2023 08:45:43 +0000 (UTC)
Received: from ovpn-8-26.pek2.redhat.com (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A84BC63F5F;
        Mon, 15 May 2023 08:45:39 +0000 (UTC)
Date:   Mon, 15 May 2023 16:45:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Wenchao Hao <haowenchao2@huawei.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linfeilong@huawei.com, louhongxiang@huawei.com
Subject: Re: [PATCH 1/2] Revert "scsi: core: Do not increase scsi_device's
 iorequest_cnt if dispatch failed"
Message-ID: <ZGHxLixW2rR34S+e@ovpn-8-26.pek2.redhat.com>
References: <20230515070156.1790181-1-haowenchao2@huawei.com>
 <20230515070156.1790181-2-haowenchao2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515070156.1790181-2-haowenchao2@huawei.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 15, 2023 at 03:01:55PM +0800, Wenchao Hao wrote:
> the "atomic_inc(&cmd->device->iorequest_cnt)" in scsi_queue_rq() would
> causes kernel panic, because cmd->device may be freed after returning
> from scsi_dispatch_cmd().
> 
> This reverts commit cfee29ffb45b1c9798011b19d454637d1b0fe87d.
> 
> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
> Reported-by: Ming Lei <ming.lei@redhat.com>
> Closes:https://lore.kernel.org/linux-scsi/8e0f2d31-e6ff-ec4a-3974-450560ad49c5@huawei.com/T/#t

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

