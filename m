Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C7CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 06:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E06E610FF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 06:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhIGGzm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 02:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234472AbhIGGzl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2021 02:55:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22A9C061575
        for <linux-scsi@vger.kernel.org>; Mon,  6 Sep 2021 23:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e4H5jvWAL27xpniZcurZrz9ZJJT1dHQB8ot2bLbD3P4=; b=LW0Uet4e5Mr+2x3RYVnDpBfEO4
        jU8wvYL54jPFNa7BLq7n5SvpwpvP/1mYRoD7uSXiHlOzknrR5sMt1pjs00viRlqiC315OfupifbZ6
        2MYAvKDSC/zCPOKzoyySLeGVmy1lfRcQtW5Sp099L4yjQdHJRdAtjGz8MtrVxOyBIQv55UPWKd7xu
        le6Mq2FYnxeQlSSe//qiKE1QAXCbvCNV0u0EW8VIGodeJhqdJ/mhk7rAo450rj9aCQr3OwCg+caXl
        ZS4Fd47cSvmvmyPOnB2Y7Suz9Pwaca3fCxncg1FB5RLVhRyBkNkv7VLEem2KIoZLuo8fEFTIxS7VF
        843pKheA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mNUz7-007bqi-3x; Tue, 07 Sep 2021 06:53:59 +0000
Date:   Tue, 7 Sep 2021 07:53:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: free 'scsi_disk' device via put_device
Message-ID: <YTcMbapVQX4dGqne@infradead.org>
References: <20210906090112.531442-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906090112.531442-1-ming.lei@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 06, 2021 at 05:01:12PM +0800, Ming Lei wrote:
> Once the device is initialized via device_initialize(), it should be
> freed via put_device, so fix it. Meantime get the parent before adding
> device, the release handler can work as expected always.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
