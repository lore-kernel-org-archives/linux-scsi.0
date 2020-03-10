Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25176C18E5B
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF54922B48
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:43:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p5iDQcJi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgCJQnu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:43:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54872 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgCJQnu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 12:43:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=E6gKD5j+BQnPyVgT5/EVwdhDwqyx5bHdc+GS5ZTD7j4=; b=p5iDQcJi/0GqQNb/SxqtHYw3Z5
        smZc4ENPqH8wTG3XsgGjqfaJGRgtOrs3wRiwkAUltpuUpVqzWBhAAa5JJRh2MMtM8TVv53TyANEu3
        CitxYN76F2d7hvQJHBP9unG0rU6ugb2U2KFZxf1n5fA67xkAy5p0kBjuNrZsIN84P92ZDE6+2I479
        nR0MoQFsVvfQfqU+zBskpFPZhQSiyV7GKUjdXd6sbNXu3EMctMRY4l4KeZpp/8E/32JzhdMJboB0M
        dBqUh08myNapegMNU0Wu3nu2NF8Gv9HpHbCjxbMWWCNaVeEiv3bde8IEev5W5tMBlE26YucU8upzM
        U/K5pOXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBhyv-0004kz-HB; Tue, 10 Mar 2020 16:43:49 +0000
Date:   Tue, 10 Mar 2020 09:43:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 05/11] block: introduce BLK_STS_ZONE_RESOURCE
Message-ID: <20200310164349.GD15878@infradead.org>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310094653.33257-6-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310094653.33257-6-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 10, 2020 at 06:46:47PM +0900, Johannes Thumshirn wrote:
> BLK_STS_ZONE_RESOURCE is returned from the driver to the block layer if
> zone related resources are unavailable, but the driver can guarantee the
> queue will be rerun in the future once the resources become available
> again.

This needs to go into the main zone append patch.
