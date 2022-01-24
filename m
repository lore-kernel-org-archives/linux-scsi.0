Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304DCC4321E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 00:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2363529AbiAYAbI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 19:31:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30324 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382445AbiAXX2E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jan 2022 18:28:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643066880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IlNQPGOZpWmo+k7nBEmHz0ohqpEuOKZGrpMVc+NcfrY=;
        b=NjzQMGVz6hWLo9y1ebl5mppwuZ+b/sRo0D/Zgkwmlzr80WW12xzWzyyqVx2XKhUCppfPR3
        Gt0SVlJBmRCFFJYFxygMRVsywtWadAc4mTtQHlsIR8lDuwJUCDy0TJXZlfkWzwMkCzjgN+
        Qe1I6/h7KjJnqPEanTfcpgsiLWCHyvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-S8mqnyQoPgqAjdxJr3dxPQ-1; Mon, 24 Jan 2022 18:27:57 -0500
X-MC-Unique: S8mqnyQoPgqAjdxJr3dxPQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03D271006AA6;
        Mon, 24 Jan 2022 23:27:56 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E2AC5DB95;
        Mon, 24 Jan 2022 23:27:42 +0000 (UTC)
Date:   Tue, 25 Jan 2022 07:27:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 10/13] block: add helper of disk_release_queue for
 release queue data for disk
Message-ID: <Ye816Xu9gPU7Q8Ug@T590>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
 <20220122111054.1126146-11-ming.lei@redhat.com>
 <20220124131624.GI27269@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124131624.GI27269@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 24, 2022 at 02:16:24PM +0100, Christoph Hellwig wrote:
> On Sat, Jan 22, 2022 at 07:10:51PM +0800, Ming Lei wrote:
> > Add one helper of disk_release_queue for releasing queue data for disk.
> 
> Please explain what "queue data for disk" is, and why this helper is

Here it means elevator, blk-cgroup and rq qos, all actually serve FS
IOs, maybe it should be changed to FS IOs.

> useful.  Right now it seems to just move a few things around without a
> rationale or explanation of why it is safe.

This patch just moves two function calls into the helper, and there
doesn't have functional change, so no need rationale and explanation.


Thanks,
Ming

