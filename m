Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E71BC43331
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 01:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2666206F6
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 01:55:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BUIuowfY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390268AbgDCBzf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 21:55:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55226 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389366AbgDCBze (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2020 21:55:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585878933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6UVH/bl3Y/P5P1Dx58QAUYpAkcmQtr6lMSzOobeDRtQ=;
        b=BUIuowfYLv8EGZ5zL6K8ldiAbOjah/0MHnBAuci4kdMKHkKpGGXyDHO1ca1IEE2Y590tjF
        FM8RtHqapDsnC8rDm+cfbMx+PWOMjdi4jzLRzvl00ZHTDJC7pwJvLpb6P1BvAkWTz87SY8
        1JDOckPBINzLoTc6XE1DnXPIm6Y0pr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-MV1UBRw7NqyIiZlPvzOJag-1; Thu, 02 Apr 2020 21:55:31 -0400
X-MC-Unique: MV1UBRw7NqyIiZlPvzOJag-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE885107ACC4;
        Fri,  3 Apr 2020 01:55:29 +0000 (UTC)
Received: from ming.t460p (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E981F5C290;
        Fri,  3 Apr 2020 01:55:21 +0000 (UTC)
Date:   Fri, 3 Apr 2020 09:55:16 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        paolo.valente@linaro.org, sqazi@google.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        groeck@chromium.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] blk-mq: In blk_mq_dispatch_rq_list() "no budget"
 is a reason to kick
Message-ID: <20200403015516.GC6987@ming.t460p>
References: <20200402155130.8264-1-dianders@chromium.org>
 <20200402085050.v2.1.I1f95c459e51962b8d2c83e869913b6befda2255c@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402085050.v2.1.I1f95c459e51962b8d2c83e869913b6befda2255c@changeid>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 02, 2020 at 08:51:29AM -0700, Douglas Anderson wrote:
> In blk_mq_dispatch_rq_list(), if blk_mq_sched_needs_restart() returns
> true and the driver returns BLK_STS_RESOURCE then we'll kick the
> queue.  However, there's another case where we might need to kick it.
> If we were unable to get budget we can be in much the same state as
> when the driver returns BLK_STS_RESOURCE, so we should treat it the
> same.

The situation is really similar, especially the restart handler may
not see the request which may not be added to hctx->dispatch, so

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks, 
Ming

