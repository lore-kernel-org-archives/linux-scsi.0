Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F1AC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB93260EB6
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhGVSkL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:40:11 -0400
Received: from verein.lst.de ([213.95.11.211]:35748 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhGVSkL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 14:40:11 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2416C67373; Thu, 22 Jul 2021 21:20:43 +0200 (CEST)
Date:   Thu, 22 Jul 2021 21:20:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 21/24] scsi: consolidate the START STOP UNIT handling
Message-ID: <20210722192042.GB15240@lst.de>
References: <20210712054816.4147559-1-hch@lst.de> <20210712054816.4147559-22-hch@lst.de> <75da1d81-4a0f-ae5e-d511-6a036d0d2472@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75da1d81-4a0f-ae5e-d511-6a036d0d2472@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 22, 2021 at 11:44:33AM -0700, Bart Van Assche wrote:
> On 7/11/21 10:48 PM, Christoph Hellwig wrote:
>> +	char cdb[MAX_COMMAND_SIZE] = { };
>
> How about using 'u8' instead of 'char'?

Sure.

>
> Additionally, MAX_COMMAND_SIZE equals 16. According to SBC-4 6 bytes is 
> enough for the START STOP UNIT command.

This just keeps the existing logic.

>
>> +	cdb[0] = START_STOP;
>> +	cdb[4] = data;
>
> Please combine the above two statements with the cdb[] declaration into a 
> single line.

Just keeping the style of the existing code, which seems fine.  Even
when initializing at declaration time this would have to be multiple
lines to stay readable.

> Additionally, please split data into two arguments to make calls of this 
> function easier to read. This is what I found in SBC-4:
> * bit 1 of byte 4 has the name LOEJ (load eject).
> * bit 0 of byte 4 has the name START (start unit).

Not sure how that really helps anyone.  And again I'm not trying to
do a grand rewrite, just consoidating the existing code a bit.
