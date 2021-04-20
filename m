Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08957C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA03861354
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhDTAD2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:03:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229471AbhDTAD1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Apr 2021 20:03:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618876975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MkQYY1YhLAGxJ+P+RRJ8TgW3u0cbwVCrA1wlEg9E7R4=;
        b=Ftvw7fl8C8yJWGsVEfKeAQHM6CiU1975eaOHSBd7jaxqIzmYqMD6yvRozhi3u+TwdPKCjn
        iuNG8+xkawWH9icK32dsRqaWEt/BzaSNTANUSvA0mSixWR3NFBlN9BeNQnjGGkFZgXd6Yt
        BZGvHDeKLCI0MK8iPGcbILJ5gUXxVAE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-GDaPQQXlN7qyclJ-YA0Txw-1; Mon, 19 Apr 2021 20:02:54 -0400
X-MC-Unique: GDaPQQXlN7qyclJ-YA0Txw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A053B107ACE6;
        Tue, 20 Apr 2021 00:02:52 +0000 (UTC)
Received: from T590 (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4185860CF0;
        Tue, 20 Apr 2021 00:02:42 +0000 (UTC)
Date:   Tue, 20 Apr 2021 08:02:40 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kashyap.desai@broadcom.com, dgilbert@interlog.com
Subject: Re: [PATCH] scsi: core: Cap initial sdev queue depth at
 shost.can_queue
Message-ID: <YH4aIECa/J/1uS5S@T590>
References: <1618848384-204144-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618848384-204144-1-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 20, 2021 at 12:06:24AM +0800, John Garry wrote:
> Function sdev_store_queue_depth() enforces that the sdev queue depth cannot
> exceed shost.can_queue.
> 
> However, the LLDD may still set cmd_per_lun > can_queue, which leads to an
> initial sdev queue depth greater than can_queue.
> 
> Stop this happened by capping initial sdev queue depth at can_queue.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
> Topic originally discussed at:
> https://lore.kernel.org/linux-scsi/85dec8eb-8eab-c7d6-b0fb-5622747c5499@interlog.com/T/#m5663d0cac657d843b93d0c9a2374f98fc04384b9
> 
> Last idea there was to error/warn in scsi_add_host() for cmd_per_lun >

No, that isn't my suggestion.

> can_queue. However, such a shost driver could still configure the sdev
> queue depth to be sound value at .slave_configure callback, so now thinking
> the orig patch better.

As I mentioned last time, why can't we fix ->cmd_per_lun in
scsi_add_host() using .can_queue?

-- 
Ming

