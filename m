Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D249C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 01:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiF2BRy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 21:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiF2BRx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 21:17:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 799AC2E69A
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 18:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656465471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pJAzQeYYGOTk2v7Gi//ZEx8wJbAnYZhjNbkruYBkZtU=;
        b=DaFwnoUBjTbyGnLLuteYCtodnUiVhPSq+4m6mAhee/KnjGaWEgAvmVvvoSwvWJNtE4Gb+u
        gw71qctKEqCocXiBVmqgwLrfCPaY2AvKPxiHSwrYu+RVMaoOVDInp1RNOHb+IyvuaFqkIZ
        1YibNQjksxe6vZQYcjkUe0OlbNyWazU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-at89QDgkNN6yrFJ_bcEL3A-1; Tue, 28 Jun 2022 21:17:40 -0400
X-MC-Unique: at89QDgkNN6yrFJ_bcEL3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 278C0185A79C;
        Wed, 29 Jun 2022 01:17:40 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1872FC26E98;
        Wed, 29 Jun 2022 01:17:34 +0000 (UTC)
Date:   Wed, 29 Jun 2022 09:17:29 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH] scsi: core: Call blk_mq_free_tag_set() earlier
Message-ID: <YruoKUbpBZvAkZ4L@T590>
References: <20220628175612.2157218-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628175612.2157218-1-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 28, 2022 at 10:56:12AM -0700, Bart Van Assche wrote:
> There are two .exit_cmd_priv implementations. Both implementations use the
> SCSI host pointer. Make sure that the SCSI host pointer is valid when
> .exit_cmd_priv is called by moving the .exit_cmd_priv calls from
> scsi_device_dev_release() to scsi_forget_host(). Moving
> blk_mq_free_tag_set() from scsi_device_dev_release() to scsi_forget_host()
> is safe because scsi_forget_host() drains all the request queues that use
> the host tag set. This guarantees that no requests are in flight and also
> that no new requests will be allocated from the host tag set.

Not sure scsi_forget_host really drains all queues since it bypasses
sdev which state is SDEV_DEL, so removal for this sdev could be
in-progress, not done yet.

Thanks,
Ming

