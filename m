Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA2FC433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 14:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26BF2222E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 14:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DVR/bhmC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbgJSOid (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 10:38:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728877AbgJSOid (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 10:38:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603118312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pHfp/yduULZ3skm6VrdINW9K2cdPKvHgQdnlryZPxEw=;
        b=DVR/bhmC18TOOumH/W2xX6XX27OF0apO3LS1T4TqSzsbdeyAKDtO/5Z1t+vohvLimhba3q
        EPPcyGhrbUfddNHN2lPJubQuwrKSNFohk2s9pGRCI2FDRdHjExra5nRJVlAlgjo/HJlxOR
        kczQgKeaCQYXARc73weMn95QfcvxEpU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355--Ui8c2oRNz2A2i_kJsWD8Q-1; Mon, 19 Oct 2020 10:38:30 -0400
X-MC-Unique: -Ui8c2oRNz2A2i_kJsWD8Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE0851060DD6;
        Mon, 19 Oct 2020 14:38:28 +0000 (UTC)
Received: from T590 (ovpn-12-65.pek2.redhat.com [10.72.12.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D27A67A431;
        Mon, 19 Oct 2020 14:38:22 +0000 (UTC)
Date:   Mon, 19 Oct 2020 22:38:18 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: core: don't start concurrent async scan on same
 host
Message-ID: <20201019143818.GA1427336@T590>
References: <20201010032539.426615-1-ming.lei@redhat.com>
 <ff55dd89-f48c-2900-d967-8eb6b1e33289@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff55dd89-f48c-2900-d967-8eb6b1e33289@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 19, 2020 at 07:17:52AM -0700, Bart Van Assche wrote:
> On 10/9/20 8:25 PM, Ming Lei wrote:
> > Current scsi host scan mechanism supposes to fallback into sync host
> > scan if async scan is in-progress. However, this rule isn't strictly
> > respected, because scsi_prep_async_scan() doesn't hold scan_mutex when
> > checking shost->async_scan. When scsi_scan_host() is called
> > concurrently, two async scan on same host may be started, and hang in
> > do_scan_async() is observed.
> > 
> > Fixes this issue by checking & setting shost->async_scan atomically
> > with shost->scan_mutex.
> 
> Did you perhaps mean "by serializing shost->async_scan accesses with
> shost->scan_mutex"?

Specifically, the following checking & setting has to be done atomically,
so shost->scan_mutex is required, just as what scsi_finish_async_scan()
does for clearing shost->async_scan:

scsi_prep_async_scan():

	if (!shost->async_scan)
		return NULL;
	...
	shost->async_scan = 1

> 
> It is not clear to me why the shost->async_scan assignment is protected
> with the host lock. Can spin_lock_irqsave(shost->host_lock, flags) and
> spin_unlock_irqrestore(shost->host_lock, flags) be left out from this
> function?

I think it is doable to remove the ->host_lock from both scsi_prep_async_scan()
and scsi_finish_async_scan(), which can be done as one follow-up cleanup.

With this patch, all reading/writing shost->async_scan are protected by
shost->scan_mutex.

> 
> Anyway:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Thanks!


-- 
Ming

