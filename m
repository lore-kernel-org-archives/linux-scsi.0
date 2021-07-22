Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 378C5C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D4A960EB2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhGVS2B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:28:01 -0400
Received: from verein.lst.de ([213.95.11.211]:35661 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230383AbhGVS17 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 14:27:59 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0261867373; Thu, 22 Jul 2021 21:08:32 +0200 (CEST)
Date:   Thu, 22 Jul 2021 21:08:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 12/24] block: add a queue_max_sectors_bytes helper
Message-ID: <20210722190831.GA14921@lst.de>
References: <20210712054816.4147559-1-hch@lst.de> <20210712054816.4147559-13-hch@lst.de> <f09654a9-a3aa-d75b-0f2a-666cdb02917e@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f09654a9-a3aa-d75b-0f2a-666cdb02917e@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 22, 2021 at 10:37:36AM -0700, Bart Van Assche wrote:
> On 7/11/21 10:48 PM, Christoph Hellwig wrote:
>> +static inline int queue_max_sectors_bytes(struct request_queue *q)
>> +{
>> +	return min_t(unsigned int, queue_max_sectors(q), INT_MAX >> 9) << 9;
>> +}
>
> Should this function return a signed or an unsigned integer? I'm asking 
> because I see 'unsigned int' as the first argument for min_t().

Yes, it really should be unsigned.
