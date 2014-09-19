From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC 0/8] IB/srp: Add multichannel support
Date: Fri, 19 Sep 2014 12:31:15 -0600
Message-ID: <541C7673.7080201@kernel.dk>
References: <541C27BF.6070609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35583 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687AbaISSbA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2014 14:31:00 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so606265pab.18
        for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2014 11:31:00 -0700 (PDT)
In-Reply-To: <541C27BF.6070609@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>

On 09/19/2014 06:55 AM, Bart Van Assche wrote:
> Hello,
> 
> Although the SRP protocol supports multichannel operation, although
> since considerable time RDMA HCA's are available that support multiple
> completion vectors and although multichannel operation yields better
> performance than using a single channel, the Linux SRP initiator does
> not yet support multichannel operation. While adding multichannel
> support in the SRP initiator I encountered a few challenges of which I
> think these need wider discussion. The topics I would like invite wider
> discussion about are as follows:
> - How to avoid unneeded inter-socket cache traffic. Should the blk-mq
>   layer e.g. assign CPU cores to hardware queues such that all CPU cores
>   associated with a single hardware queue reside on the same CPU socket?
>   (see also patch 1/8)

Right now these are deliberately symmetric, and hence can result in
hardware queues being left unused. Whether it makes sense to make this
change or not, I think will greatly depend on how many queues are
available. There's a crossover point where having more queues doesn't
help, and it can even make things worse (interrupt load, etc). For your
specific case or 4 queues, it probably DOES make sense to use them all,
however.

-- 
Jens Axboe

