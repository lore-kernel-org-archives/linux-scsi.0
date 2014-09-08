From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/6] blk-mq: initialize pdu of flush req explicitly
Date: Mon, 08 Sep 2014 13:03:41 -0600
Message-ID: <540DFD8D.2020804@kernel.dk>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>	<20140907184956.GB23026@lst.de> <CACVXFVP-kUkCoW_pPrxqKWeoSKkxCACLLth2ycv87EVzfr2mUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38599 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbaIHTDe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2014 15:03:34 -0400
Received: by mail-pd0-f181.google.com with SMTP id w10so2426702pde.40
        for <linux-scsi@vger.kernel.org>; Mon, 08 Sep 2014 12:03:34 -0700 (PDT)
In-Reply-To: <CACVXFVP-kUkCoW_pPrxqKWeoSKkxCACLLth2ycv87EVzfr2mUA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>, Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

On 09/08/2014 10:55 AM, Ming Lei wrote:
> On Mon, Sep 8, 2014 at 2:49 AM, Christoph Hellwig <hch@lst.de> wrote:
>> This works fine for me, although I still don't really like it very much.
>>
>> If you really want to go down the path of major surgery in this area we
>> should probably allocate a flush request per hw_ctx, and initialize it
>> using the normal init/exit functions.  If we want to have proper multiqueue
>> performance on devices needing flushes we'll need something like that anyway.
> 
> Yes, that should be the final solution for the problem, and looks the whole
> flush machinery need to move into hctx, I will try to figure out one patch to
> do that.

I had not thought of that, but seems like a great way to clean this up a
lot. It just never felt like the right thing to do.

-- 
Jens Axboe

