Return-Path: <SRS0=DEWY=5Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB332C2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 01:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C24CF208E4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 01:24:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HFf879Xb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgDIBYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 21:24:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21970 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726571AbgDIBYw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 21:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586395492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NbqUujqUBgWimkq47tbzopEW+FIVMfLk+fggqhU1i0c=;
        b=HFf879XbJCOPWBf9EO9dJ9rR9VSmiMKhMsurL47+DmO0z2UP3nDRN1liMjBQH8fv6X+qe2
        PgNJha53Rgoc7MLk35QrYEApDRfv8fcbUMn5aF7F3j0oKRw2+eFqfrjXYh/iC0nDOiCQ0R
        GysrQ33whGywK0ylaEVaOavFzQ1QC5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-qVDO5DX0OIiAl8SojBTAHw-1; Wed, 08 Apr 2020 21:24:48 -0400
X-MC-Unique: qVDO5DX0OIiAl8SojBTAHw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FB808017F5;
        Thu,  9 Apr 2020 01:24:46 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DF1A46;
        Thu,  9 Apr 2020 01:24:35 +0000 (UTC)
Date:   Thu, 9 Apr 2020 09:24:30 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        paolo.valente@linaro.org, groeck@chromium.org,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        sqazi@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] Revert "scsi: core: run queue if SCSI device
 queue isn't ready and queue is idle"
Message-ID: <20200409012430.GC369792@localhost.localdomain>
References: <20200408150402.21208-1-dianders@chromium.org>
 <20200408080255.v4.4.I630e6ca4cdcf9ab13ea899274745f9e3174eb12b@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408080255.v4.4.I630e6ca4cdcf9ab13ea899274745f9e3174eb12b@changeid>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 08, 2020 at 08:04:02AM -0700, Douglas Anderson wrote:
> This reverts commit 7e70aa789d4a0c89dbfbd2c8a974a4df717475ec.
> 
> Now that we have the patches ("blk-mq: In blk_mq_dispatch_rq_list()
> "no budget" is a reason to kick") and ("blk-mq: Rerun dispatching in
> the case of budget contention") we should no longer need the fix in
> the SCSI code.  Revert it, resolving conflicts with other patches that
> have touched this code.
> 
> With this revert (and the two new patches) I can run the script that
> was in commit 7e70aa789d4a ("scsi: core: run queue if SCSI device
> queue isn't ready and queue is idle") in a loop with no failure.  If I
> do this revert without the two new patches I can easily get a failure.
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
> I don't know for sure that we can revert this patch, but in the very
> least the original test case now passes.  If there is any question
> about this, we can just drop this patch.

I think it is safe to revert this patch.

This patch should have been one workaround in case of dispatch from hctx->dispatch,
since there is one race. When dispatch from scheduler queue, any
IO completion will re-run all hctxs, so no need to do the trick.

Reviewed-by: Ming Lei <ming.lei@redhat.com>


thanks,
Ming

