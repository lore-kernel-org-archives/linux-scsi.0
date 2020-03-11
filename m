Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B798C10F29
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 06:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CAE82192A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 06:24:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pKbDYw0X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgCKGYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 02:24:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49116 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgCKGYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 02:24:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vyHEmkoxaXTAqtSOiKFNhotidEAINkjnv6/40SDbgGg=; b=pKbDYw0XcK4tyyhTQxFRqTe9Fa
        b77zPLKYFlaM62NzTDA9qixV0eQ8MfDcvYN+uEdtcNUKKxGMHPX7FqiXoOwuYK1lzYeLWDXdx2EFv
        qJekOi61Xk6yU3GkwQybqcM9pn+YHXDkvrQa7PgTdeN0Yut8c84fViIiHtf7eYZ3CShrTgS7xQfXt
        ABXrIQb+RC/4v5h4XX/uCrXrbQMW7395Yn5ZHM4WzthhgiYDbRpnDngMHSpUQhlSoLqEtGZsfU9mo
        dKrtbD/cf8cy3jLpVHH+ltDgWQVLm7jYkSaakGU6HaErM10lYr2wHiKhpNLlrhPsUs12rWlN1W7yH
        GokKRpIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBunW-0001cx-J8; Wed, 11 Mar 2020 06:24:54 +0000
Date:   Tue, 10 Mar 2020 23:24:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/11] Introduce Zone Append for writing to zoned block
 devices
Message-ID: <20200311062454.GB5729@infradead.org>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310164229.GA15878@infradead.org>
 <BYAPR04MB5816A4B727B954E1C409E451E7FC0@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB5816A4B727B954E1C409E451E7FC0@BYAPR04MB5816.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 11, 2020 at 12:37:33AM +0000, Damien Le Moal wrote:
> I do not think we can get rid of it entirely as it is needed for applications
> using regular writes on raw zoned block devices. But the zone write locking will
> be completely bypassed for zone append writes issued by file systems.

But applications that are aware of zones should not be sending multiple
write commands to a zone anyway.  We certainly can't use zone write
locking for nvme if we want to be able to use multiple queues.
