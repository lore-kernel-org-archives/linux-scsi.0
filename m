Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F2AC388F7
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 09:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CB4220829
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 09:28:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H8QFWIYt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgKJJ2f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 04:28:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgKJJ2e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Nov 2020 04:28:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605000513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Ec+6ZQtRo8XVMn8uxsrYDedFkoS+9ZcsqpLGSrJMak=;
        b=H8QFWIYtSh5CFbXpV1FxZVV5zsHvG3JwLe4tmczaOOevLNg7rKACeT5z8V7bxkcgi48k99
        aaWGQB03nvajZFKKU7tYubtFaRIQHOHbs9eHeIzEMbZ6rryHHWMW33RL8fugf85fsPGC/s
        CJlkAqeYuGj+yRmzdo/FNEDQcp/FGHo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-4jIgp8J3Op2JG9PvyFdW3Q-1; Tue, 10 Nov 2020 04:28:31 -0500
X-MC-Unique: 4jIgp8J3Op2JG9PvyFdW3Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D72611008312;
        Tue, 10 Nov 2020 09:28:29 +0000 (UTC)
Received: from T590 (ovpn-12-202.pek2.redhat.com [10.72.12.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1C245C5BB;
        Tue, 10 Nov 2020 09:28:21 +0000 (UTC)
Date:   Tue, 10 Nov 2020 17:28:17 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 for 5.11 11/12] scsi: make sure sdev->queue_depth is
 <= shost->can_queue
Message-ID: <20201110092817.GD372588@T590>
References: <20200923013339.1621784-1-ming.lei@redhat.com>
 <20200923013339.1621784-12-ming.lei@redhat.com>
 <5b229af8-520d-d3cf-caa0-5d3b11fa1083@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b229af8-520d-d3cf-caa0-5d3b11fa1083@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 23, 2020 at 08:38:44AM +0100, John Garry wrote:
> On 23/09/2020 02:33, Ming Lei wrote:
> > Obviously scsi device's queue depth can't be > host's can_queue,
> > so make it explicitely in scsi_change_queue_depth().
> 
> ha, why not can_queue * nr_hw_queues?

Yeah, you are right, it should be can_queue * nr_hw_queues for
non-shared-tags.


Thanks,
Ming

