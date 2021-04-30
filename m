Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9559C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 06:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8855161409
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 06:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhD3GSl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:18:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229482AbhD3GSl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Apr 2021 02:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619763472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d/a5f7BiE/hF13LnvxuuJd8UFbF17t6uXrPk5xfB2i8=;
        b=UJg17xcIM6CTyBKCTV61Iricqc5kOveLCAIJc3qPcE50J3dy89FsdSfL4V7KymDW7V4qsn
        yCSbJmYf0Lln32txUpHEjZpqVFgXtOql9cxAmY938JQzwVEkAe91lqjjEi32GV4FYLN/aF
        izQm7kzyJ6p+W7gc6oplAE+EZgHUVfY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-8ALGgvRcPCOc7RU-HbYoeA-1; Fri, 30 Apr 2021 02:17:48 -0400
X-MC-Unique: 8ALGgvRcPCOc7RU-HbYoeA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4084D1006C81;
        Fri, 30 Apr 2021 06:17:47 +0000 (UTC)
Received: from T590 (ovpn-12-77.pek2.redhat.com [10.72.12.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11D2D5C559;
        Fri, 30 Apr 2021 06:17:40 +0000 (UTC)
Date:   Fri, 30 Apr 2021 14:17:51 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/3] fnic: use scsi_host_busy_iter() to traverse commands
Message-ID: <YIuhD7jsJ2sXLiVG@T590>
References: <20210429122517.39659-1-hare@suse.de>
 <20210429122517.39659-3-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429122517.39659-3-hare@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 29, 2021 at 02:25:16PM +0200, Hannes Reinecke wrote:
> Use scsi_host_busy_iter() to traverse commands instead of
> hand-crafted routines walking the command list.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/fnic/fnic_scsi.c | 821 ++++++++++++++++------------------
>  1 file changed, 375 insertions(+), 446 deletions(-)

Looks fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

