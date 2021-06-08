Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63031C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 05:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 397AD6023E
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 05:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhFHFZM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 01:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHFZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 01:25:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC88C061574;
        Mon,  7 Jun 2021 22:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qr65buNId8cP7B428HOi/lrezQZJN+Wrw8UApPCn9jQ=; b=iZg7obBbT6sHTgAMJocvGLkqoe
        BeSvqRnXxrGz6Tu9GjjRwJ+xr1QKvWjk+fFrJuViYBhRMs1MaYl+UNgvmfCfKpCWFFGXsAe65tGuP
        i4WB6K1H4/vfrKA+XkV/mMLTegPIGDKW2pj2dq/ge9pA6zliGkOdw0ifvNyGB23wMUi0mWhXTMpB7
        yBw8bacAWq3yEQRwC8C5/WUqNVYsOBzPgyKI+3/drIIhxDx/ZM/gAnfX3FkC9c3n99FXVUr9d2Zev
        E9Q1Fk5WwJ01rqxoSdhIKkXcOrZFlUF6brPkx5G2UiJqdz5f5DAvwqsr0DQHr9CNq+FnkcH0z6lzz
        lUOaEfTA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqUBw-00Gada-19; Tue, 08 Jun 2021 05:22:22 +0000
Date:   Tue, 8 Jun 2021 06:22:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Changheun Lee <nanich.lee@samsung.com>, damien.lemoal@wdc.com,
        Avri.Altman@wdc.com, Johannes.Thumshirn@wdc.com,
        alex_y_xu@yahoo.ca, alim.akhtar@samsung.com,
        asml.silence@gmail.com, axboe@kernel.dk, bgoncalv@redhat.com,
        cang@codeaurora.org, gregkh@linuxfoundation.org,
        jaegeuk@kernel.org, jejb@linux.ibm.com, jisoo2146.oh@samsung.com,
        junho89.kim@samsung.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, ming.lei@redhat.com,
        mj0123.lee@samsung.com, osandov@fb.com, patchwork-bot@kernel.org,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        tj@kernel.org, tom.leiming@gmail.com, woosung2.lee@samsung.com,
        yi.zhang@redhat.com, yt0928.kim@samsung.com
Subject: Re: [PATCH v12 1/3] bio: control bio max size
Message-ID: <YL7+jEBxeLt4+xFR@infradead.org>
References: <DM6PR04MB70812AF342F46F453696A447E73B9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <CGME20210604075331epcas1p13bb57f9ddfc7b112dec1ba8cf40fdc74@epcas1p1.samsung.com>
 <20210604073459.29235-1-nanich.lee@samsung.com>
 <63afd2d3-9fa3-9f90-a2b3-37235739f5e2@acm.org>
 <YL2+HeyKVMHsLNe2@infradead.org>
 <221377e3-05d1-f250-1ad8-6e5c9485d756@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <221377e3-05d1-f250-1ad8-6e5c9485d756@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 07, 2021 at 09:46:56AM -0700, Bart Van Assche wrote:
> In case you would not yet have had the time to do this, please take a
> look at the call trace available on
> https://lore.kernel.org/linux-block/20210425043020.30065-1-bvanassche@acm.org/.
> That call trace shows how bio_add_pc_page() is called by the SCSI core
> before alloc_disk() is called. I think that sending a SCSI command
> before alloc_disk() is called is fundamental in the SCSI core because
> the SCSI INQUIRY command has to be sent before it is known whether or
> not a SCSI LUN represents a disk.

I have a plan for that as well, stay tuned :)
