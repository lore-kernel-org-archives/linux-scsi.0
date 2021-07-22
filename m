Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0B9C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F40560ED4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhGVSYk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:24:40 -0400
Received: from verein.lst.de ([213.95.11.211]:35636 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230262AbhGVSYj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 14:24:39 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8C81268AFE; Thu, 22 Jul 2021 21:05:11 +0200 (CEST)
Date:   Thu, 22 Jul 2021 21:05:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 01/24] bsg: remove support for SCSI_IOCTL_SEND_COMMAND
Message-ID: <20210722190511.GA14806@lst.de>
References: <20210712054816.4147559-1-hch@lst.de> <20210712054816.4147559-2-hch@lst.de> <07be7708-2084-d682-15f8-626ad0a5753f@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07be7708-2084-d682-15f8-626ad0a5753f@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 22, 2021 at 10:31:13AM -0700, Bart Van Assche wrote:
>> +				current->comm);
>> +		return -EINVAL;
>>   	default:
>>   		return -ENOTTY;
>>   	}
>
> The Fixes: tag will cause this patch to be backported to stable trees. Is 
> that intentional?

Yes, as this ioctl actively does the wrong thing for non-scsi queues.
