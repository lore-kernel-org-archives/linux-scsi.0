Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A01C18E5B
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 654A8222C3
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:45:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qLOtkiXq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgCJQpZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:45:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57726 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgCJQpY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 12:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fqzaxIDv2B8AiKxZE4hq9H1A1wFaea9VpdgoY2v1QZE=; b=qLOtkiXqJijSoOtq31oD9wYMfB
        eCit8NWcJMEk5szwZmfO2S/fhi8wef4QCNjLb6vdMDtouDJn4kJGaB7FxXHgDTNB65TjJWg/1A+Og
        3kiS3KryMNnRRdI9SWO64K6c35ShLDCaUfZ2/yMm8+KclNyI+Uz8rwdN5ELPPXpZQyY+A81kshYUg
        33+QyLrZJoZ5DKX8+9t/79u24XBTO9WlI4cgb48MBiUbfR9iCkKtqGVTO9bO48b4NNpRHDbqVmfRZ
        Q4/S6cN+L6kQ4yKtslNZ+xFf2S4EjRBm9vnIU6JYM+fRSLrtyf4hyM1CJZdjN4C/Wn3yPIBveEfk0
        hAMrx7lw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBi0R-0006c6-HZ; Tue, 10 Mar 2020 16:45:23 +0000
Date:   Tue, 10 Mar 2020 09:45:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/11] block: delay un-dispatchable request
Message-ID: <20200310164523.GF15878@infradead.org>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310094653.33257-9-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310094653.33257-9-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 10, 2020 at 06:46:50PM +0900, Johannes Thumshirn wrote:
> When a LLDD can't dispatch a request to a specific zone, it will return
> BLK_STS_ZONE_RESOURCE indicating this request needs to be delayed, e.g.
> because the zone it will be dispatched to is still write-locked.
> 
> If this happens set the request aside in a local list to continue trying
> dispatching requests such as READ requests or a WRITE/ZONE_APPEND
> requests targetting other zones. This way we can still keep a high queue
> depth without starving other requests even if one request can't be
> served due to zone write-locking.
> 
> All requests put aside in the local list due to BLK_STS_ZONE_RESOURCE
> are placed back at the head of the dispatch list for retrying the next
> time the device queues are run again.

This needs to go into the main zone append patch.  Also I think some
of the above explanation would be useful in comments in the code.
