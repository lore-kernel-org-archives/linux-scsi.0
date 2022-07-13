Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4763C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 01:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiGMBeS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 21:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiGMBeM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 21:34:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDBB654649
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 18:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657676050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wkw5vU32ivd5qyDLMVpQA/49hWIaCOdrT7mZmC2KgVc=;
        b=iQJwCjFWqOPCZQRbUsuqG4KQlptm/8YAlfpHWXi57AIVkKpg9TOomUDlHy/8+cGW48Kmtx
        vQtlsgWWIDz078el74Qp0n+5fzGIu6I8QBNEjxDTv1c4dBvubbNKfQ5/c/gCtIZwwdJQxt
        5OQigL8DXNe/XPQpoOCHMuWqS//XQ+0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-F1Uak3ZsPzKSTVbq0O7CWg-1; Tue, 12 Jul 2022 21:34:04 -0400
X-MC-Unique: F1Uak3ZsPzKSTVbq0O7CWg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F20C2101A589;
        Wed, 13 Jul 2022 01:34:03 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 02F8E2026D07;
        Wed, 13 Jul 2022 01:33:57 +0000 (UTC)
Date:   Wed, 13 Jul 2022 09:33:52 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH v4 1/4] scsi: core: Make sure that targets outlive devices
Message-ID: <Ys4hAJPNCo7jcdkE@T590>
References: <20220712221936.1199196-1-bvanassche@acm.org>
 <20220712221936.1199196-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712221936.1199196-2-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 12, 2022 at 03:19:33PM -0700, Bart Van Assche wrote:
> This patch prevents that the following sequence triggers a kernel crash:
> * Deletion of a SCSI device is requested via sysfs. Device removal takes
>   some time because blk_cleanup_queue() is waiting for the SCSI error
>   handler.
> * The SCSI target associated with that SCSI device is removed.
> * scsi_remove_target() returns and its caller frees the resources
>   associated with the SCSI target.
> * The error handler makes progress and invokes an LLD callback that
>   dereferences the SCSI target pointer.
> 
> Reported-by: Mike Christie <michael.christie@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Li Zhijian <lizhijian@fujitsu.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks fine,

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

