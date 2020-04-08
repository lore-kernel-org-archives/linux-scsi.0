Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15EDC2BB1D
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81D04212CC
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:59:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mVDmhnP6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgDHP7c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:59:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50756 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729609AbgDHP7c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 11:59:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4fAwV5hWu5ePVb+0OWdbW9vNmTTHLT7hXNBgd/lhatw=; b=mVDmhnP6iwlRumVYlPcwVVa5xS
        4ofNpGuqybC9Qto++sMNKpsTG5BCzCr0SpJmQNdomieE1dUJgUBYHtStPyEnARchKxlUiXvB+qPJi
        nrtzyyCeZNzvNlMVe+kUduEB377ioWvTvObCk2z51kxy3GPgYfOzY9GZtQAfNbJDFX87OfBYZH/yu
        FyZhqSlqsCcZ6xb4/zwwb5V+Ig8VUH4T/lp+BJn613QMGNUKOEmOibK6YILvlJWSmRmal98Jz2S4h
        CUAR1dKaEF+2wqUN0RxfLTis7BTezCL3f7g1qK+Y3O/kCOB+pxdrmaPXy0D1Ot9bJd9MseThFzgXu
        nYvf08uA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMD6x-0007ei-Fq; Wed, 08 Apr 2020 15:59:31 +0000
Date:   Wed, 8 Apr 2020 08:59:31 -0700
From:   "hch@infradead.org" <hch@infradead.org>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] scsi: export scsi_mq_uninit_cmnd
Message-ID: <20200408155931.GD29029@infradead.org>
References: <20200403101250.33245-1-johannes.thumshirn@wdc.com>
 <20200403101250.33245-7-johannes.thumshirn@wdc.com>
 <20200407170048.GE13893@infradead.org>
 <SN4PR0401MB3598D625922E9EFCC2F039F09BC00@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB3598D625922E9EFCC2F039F09BC00@SN4PR0401MB3598.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 08, 2020 at 11:32:30AM +0000, Johannes Thumshirn wrote:
> On 07/04/2020 19:00, Christoph Hellwig wrote:
> >   - scsi_mq_free_sgtables - yes, this would need to be done by the driver
> >     and actually is what undoes scsi_init_io.  I think you want to export
> >     this instead (and remove the _mq in the name while you are at it)
> 
> OK, I was afraid to expose too much internals if I export 
> scsi_mq_free_sgtables() but, sure that's a trivial change.

Well, it mirrors scsi_init_io, so if we want to undo scsi_init_io
it seems to be the right export.
