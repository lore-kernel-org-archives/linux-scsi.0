Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF54ACCA473
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 03:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiGADo5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 23:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiGADoi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 23:44:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4160765D5D
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 20:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656647076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cyrmgt5rZNPWv71R+wzluEW6d4TFAXSgtVS6QGGoli8=;
        b=BOJ0uzBL1fKvKM4ShyJZktdjN0crRHAgQ1G+VM+Mrx7iF2f0bX8HpvNYB3JdW86Xrw7WI/
        7QSd5Ml1DsbQDpV1fde3r8Mi89zcxCTiHt43VEvHdl0MREcgaqEEmvvGJ6aQH3eveY1uUF
        rH/CDrCfT0sY1xJqsl0k8maI4W1oyls=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-Zyeg1f0dNnaHsBdzYXppYQ-1; Thu, 30 Jun 2022 23:44:31 -0400
X-MC-Unique: Zyeg1f0dNnaHsBdzYXppYQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 258CF9675A2;
        Fri,  1 Jul 2022 03:44:31 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 29C32815B;
        Fri,  1 Jul 2022 03:44:25 +0000 (UTC)
Date:   Fri, 1 Jul 2022 11:44:20 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH v2 3/3] scsi: core: Call blk_mq_free_tag_set() earlier
Message-ID: <Yr5tlDkrTTldwjSq@T590>
References: <20220630213733.17689-1-bvanassche@acm.org>
 <20220630213733.17689-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630213733.17689-4-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 30, 2022 at 02:37:33PM -0700, Bart Van Assche wrote:
> There are two .exit_cmd_priv implementations. Both implementations use
> resources associated with the SCSI host. Make sure that these resources are

Please document what the exact resources associated with this SCSI host is.

We need the root cause.

I understand it might be related with module unloading, since ib_srp may
be gone already, but not sure if it is the exact one in this report.

> still available when .exit_cmd_priv is called by moving the .exit_cmd_priv
> calls from scsi_host_dev_release() to scsi_forget_host(). Moving
> blk_mq_free_tag_set() from scsi_host_dev_release() to scsi_forget_host() is
> safe because scsi_forget_host() drains all the request queues that use the
> host tag set. This guarantees that no requests are in flight and also that
> no new requests will be allocated from the host tag set.
> 
> This patch fixes the following use-after-free:
> 
> ==================================================================
> BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
> Read of size 8 at addr ffff888100337000 by task multipathd/16727

What is the 8bytes buffer which triggers UAF? what does srp_exit_cmd_priv+0x27
point to?


Thanks, 
Ming

