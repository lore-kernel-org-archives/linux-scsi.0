Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE446C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 21:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA22B610A0
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 21:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbhHSVhD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 17:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhHSVhC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 17:37:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2623FC061575;
        Thu, 19 Aug 2021 14:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QV0dWseqFMclr/zqGrEDjOkYP6s8c79Id+PbXOyIPA0=; b=QvzKcPciNrwRl34U6IKk5qbZsE
        oXC7jSTKyMA38uvXtpE16IbNo3JygN1D1n/Qxl32l2ekBTQlQDOfXc0GPKXW/0Me41C3M6qotODP6
        5u/cW8kh7ggfefo432TBCaqFNtRGlK1xQSWHkbHmFgvG8l2/XBAywfES1FWBp1lLv2fOWQvUih4iv
        5zR1sj+RSvvisRX6+mpI6Tr81nJcITRF86N1BOQ7mkGZgjUYutvflCVYC4aP7RD1T9JHh4KDBBCOK
        N72ZQLQvPyd+CPEqqNsjen2gZ7rnrXlsnKogqs0oJP+Gg9ixwt3BK11DVLvTxM1mqh0VeXbvigYqN
        v3+gW8VQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mGpi1-009UEi-CS; Thu, 19 Aug 2021 21:36:21 +0000
Date:   Thu, 19 Aug 2021 14:36:21 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/9] sg: do not allocate a gendisk
Message-ID: <YR7O1YS4sO1ZU4Ho@bombadil.infradead.org>
References: <20210816131910.615153-1-hch@lst.de>
 <20210816131910.615153-4-hch@lst.de>
 <YR7OJ+lmps2H2fN/@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YR7OJ+lmps2H2fN/@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 19, 2021 at 02:33:27PM -0700, Luis Chamberlain wrote:
> On Mon, Aug 16, 2021 at 03:19:04PM +0200, Christoph Hellwig wrote:
> > sg is a character driver and thus does not need to allocate a gendisk,
> > which is only used for file system-like block layer I/O on block
> > devices.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> You forgot to do something like this too:

Sorry that comment and Reviewed-by tag was meant for the st patch, not sg.

  Luis
