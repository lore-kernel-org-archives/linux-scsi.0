Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E11C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 16:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7AAD60F14
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 16:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhH0QoV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 12:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhH0QoQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 12:44:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EFEC061757;
        Fri, 27 Aug 2021 09:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uMi9ym/EpEMhp5XJ1/dQn3cCSXMnwFLpTt8mhm2kIVg=; b=E+NhTTurAXC+0jZgTala+SFila
        qn6hP0CfcSsajRdaFtZ+DKG/DFc05q8YSG7HrJcixCp5FOzdmL5zOrxmk+avYz1sVXlUP/uXofVbN
        Md9zesFSUAOK1L/B9C5im9TOUlGbQFhmNBBVliI4+0gCVIwAmypgGLJs3vCewmBKRlFzgLU2341j0
        8wFQMaNcm8lSbSnAu78NUdawmZnGxdufcvpdc2HnK1lj2ny8ZVGJ3XHukVT2EYIGIdioGD4VANCZT
        E+pgufM2KGTIptr57D3Kh0KiALIdJDGmLlZcRSvs91c1xX61bu0YN2+nJsqD8UBo8MUvl2kW1oeX2
        ptQEN69Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJevB-00ElKJ-CV; Fri, 27 Aug 2021 16:41:57 +0000
Date:   Fri, 27 Aug 2021 17:41:37 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Tim Walker <tim.t.walker@seagate.com>
Cc:     Phillip Susi <phill@thesusis.net>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v6 0/5] Initial support for multi-actuator HDDs
Message-ID: <YSkVwSfQ/9RCKfEG@infradead.org>
References: <20210827075045.642269-1-damien.lemoal@wdc.com>
 <874kbbugtw.fsf@vps.thesusis.net>
 <63D90989-AFAF-410B-AD11-EDF71CEEE666@seagate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63D90989-AFAF-410B-AD11-EDF71CEEE666@seagate.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 27, 2021 at 02:28:58PM +0000, Tim Walker wrote:
> There is nothing in the spec that requires the ranges to be contiguous
> or non-overlapping.

Yikes, that is a pretty stupid standard.  Almost as bad as allowing
non-uniform sized non-power of two sized zones :)

> It's easy to imagine a HDD architecture that allows multiple heads to access the same sectors on the disk. It's also easy to imagine a workload scenario where parallel access to the same disk could be useful. (Think of a typical storage design that sequentially writes new user data gradually filling the disk, while simultaneously supporting random user reads over the written data.)

But for those drivers you do not actually need this scheme at all.
Storage devices that support higher concurrency are bog standard with
SSDs and if you want to go back storage arrays.  The only interesting
case is when these ranges are separate so that the access can be carved
up based on the boundary.  Now I don't want to give people ideas with
overlapping but not identical, which would be just horrible.
