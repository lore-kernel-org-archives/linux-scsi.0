Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC035C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 06:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244834AbiCOGXQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 02:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbiCOGXP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 02:23:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B5B645AC1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 23:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647325321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ONk51odIqoD3r932HGF8x8p1wv6Py7AXFFq2FkD+6IY=;
        b=MLdWDTfSrjf8BISpgqegJ8t7rc4z+gIgK9bt2WjlymgJULHNxjub/O/1+a5TY2s0nrNxm3
        40hzS67crZqj4YvJRzlpM6V/SWLms4gJE3K7AJVqdsTw/IjoKWdMgX1PDi5fxWv3hKT0zM
        SA6oZkKRkSb4031AMRdqleAASSxwuRI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-CoF4HFwkOLGI4tt3mTr7xQ-1; Tue, 15 Mar 2022 02:21:56 -0400
X-MC-Unique: CoF4HFwkOLGI4tt3mTr7xQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 328333803507;
        Tue, 15 Mar 2022 06:21:56 +0000 (UTC)
Received: from T590 (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AADDC28102;
        Tue, 15 Mar 2022 06:21:50 +0000 (UTC)
Date:   Tue, 15 Mar 2022 14:21:46 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     David Jeffery <djeffery@redhat.com>
Cc:     linux-scsi@vger.kernel.org, Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Laurence Oberman <loberman@redhat.com>,
        John Pittman <jpittman@redhat.com>
Subject: Re: [PATCH] fnic: finish scsi_cmnd before dropping the spinlock to
 prevent abort race
Message-ID: <YjAweu8lM8mUFxDC@T590>
References: <20220311184359.2345319-1-djeffery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311184359.2345319-1-djeffery@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 11, 2022 at 01:43:59PM -0500, David Jeffery wrote:
> When aborting a scsi command through fnic, there is a race with the fnic
> interrupt handler which can result in the scsi command and its request
> being completed twice. If the interrupt handler claims the command by
> setting CMD_SP to NULL first, the abort handler assumes the interrupt
> handler has completed the command and returns SUCCESS, causing the request
> for the scsi_cmnd to be re-queued.
> 
> But the interrupt handler may not have finished the command yet. After it
> drops the spinlock protecting CMD_SP, it does memory cleanup before
> finally calling scsi_done to complete the scsi_cmnd. If the call to
> scsi_done occurs after the abort handler finishes and re-queues the
> request, the completion of the scsi_cmnd will advance and try to double
> complete a request already queued for retry.
> 
> This patch fixes the issue by moving scsi_done and any other use of
> scsi_cmnd to before the spinlock is released by the interrupt handler.

This way provides one simple fix for the race between normal completion
and abort, looks fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks, 
Ming

