Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87B7C4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 08:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA1452173E
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 08:33:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fZpUdZcg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgEAIdz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 04:33:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39593 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728345AbgEAIdz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 04:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588322034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9m2SfPn+y7SUHxD1zi8RvVgtwkO6MdlJLiNdU9aPZ60=;
        b=fZpUdZcgs9WWiZkEeh92g3pVErWGe3hv3GRrt4qainFLw+OuXtMqis0KsemOr/cMSdgX2I
        TyXJpDGxAVJFC14hG9/FBj8UKQOVxKJiF7EqgRnQU4WzFiSdwR1sLvxqYor3sUzRkgfGya
        83wZDW+NUXrM3DJI4OEuvkav2TtU5j0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-Ijrp9sqPPFSBbseAd1AtHA-1; Fri, 01 May 2020 04:33:50 -0400
X-MC-Unique: Ijrp9sqPPFSBbseAd1AtHA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB263468;
        Fri,  1 May 2020 08:33:48 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E6AB22B4B6;
        Fri,  1 May 2020 08:33:41 +0000 (UTC)
Date:   Fri, 1 May 2020 16:33:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC v3 22/41] block: implement persistent commands
Message-ID: <20200501083337.GA1009055@T590>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-23-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430131904.5847-23-hare@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 30, 2020 at 03:18:45PM +0200, Hannes Reinecke wrote:
> Some LLDDs implement event handling by sending a command to the
> firmware, which then will be completed once the firmware wants
> to register an event.
> So worst case a command is being sent to the firmware then the
> driver initializes, and will be returned once the driver unloads.
> To avoid these commands to block the queues during freezing or
> quiescing this patch implements support for 'persistent' commands,
> which will be excluded from blk_queue_enter() and blk_queue_exit()
> calls.

This way is quite dangerous from block layer viewpoint, and it should
have been done in driver/device specific way instead of polluting block
layer.


thanks, 
Ming

