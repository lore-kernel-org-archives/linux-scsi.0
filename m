Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 279DDC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 06:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2B4820855
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 06:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QsmY8rYd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgIJGOw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 02:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgIJGOu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 02:14:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039A4C061573
        for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2020 23:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I5A/NWliYowuqv5800TZALov5Nmua+v17Nuu5Zrjw0o=; b=QsmY8rYdNOe5Ol3ELvHyiQ4dyp
        E8ptzEuyGTL1Ys9/v6KB8XHF+5H5m1S1+Eyc04T975nimGRJdtSWZ22uoIkDQknPpo1kb+a1xNA1e
        O/6ImaBMJQoI+9qrKAX5rJVbm9Wj8+84ZzW0hzIPExp+uwaeFUYP47dCPMIWFvvsm/7vXXiC1DrwQ
        W9BA2D0rxSUBkbA1+4s+p8t07Tixk+WHIQNyEbN3GTEqiWJLIQ3rbCmgvnLZa8dPtf90sGNMqJSzu
        DTxWcvxxHEYRKMTr83F3fOiRyNO/+T2qLrJJbI8tJOqYU6KwF+LwHKD4umfThRcJ/cZr89ZDxZVJv
        mX2ar1qA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGFr6-0005qP-C6; Thu, 10 Sep 2020 06:14:48 +0000
Date:   Thu, 10 Sep 2020 07:14:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Bunker <brian@purestorage.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: fix for kernel BUG at
 drivers/scsi/device_handler/scsi_dh_alua.c:662!
Message-ID: <20200910061448.GA21631@infradead.org>
References: <FF501332-F768-46E2-9CB4-CAD103952509@purestorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FF501332-F768-46E2-9CB4-CAD103952509@purestorage.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 09, 2020 at 10:08:55AM -0700, Brian Bunker wrote:
> Would it be better to move the unsetting the address of sdev to NULL lower? This would protect
> against the crash we see when the alua_rtpg function tries to access the sdev address
> that has been set to NULL in alua_bus_detach by another thread.
> 
> --- a/linux-5.4.17/drivers/scsi/device_handler/scsi_dh_alua.c	2020-07-29 22:48:30.000000000 -0600
> +++ b/linux-5.4.17/drivers/scsi/device_handler/scsi_dh_alua.c	2020-09-07 13:38:23.771575702 -0600
> @@ -1146,15 +1146,15 @@
>  
>  	spin_lock(&h->pg_lock);
>  	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
> -	rcu_assign_pointer(h->pg, NULL);
> -	h->sdev = NULL;
> -	spin_unlock(&h->pg_lock);
>  	if (pg) {
>  		spin_lock_irq(&pg->lock);
>  		list_del_rcu(&h->node);
>  		spin_unlock_irq(&pg->lock);
>  		kref_put(&pg->kref, release_port_group);
>  	}
> +	rcu_assign_pointer(h->pg, NULL);
> +	h->sdev = NULL;
> +	spin_unlock(&h->pg_lock);
>  	sdev->handler_data = NULL;
>  	kfree(h);

I don't think we can call the kref_put inside ->pg_lock.  But I think
doing the list del early as in you patch, but keeping the put after
the unlock looks sensible.  Can you submit a properly formatted patch
with a commit log and signoff for that?
