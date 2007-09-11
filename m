From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH 7/7] blk_end_request: change rq->end_io to
	cover request completion as a whole
Date: Tue, 11 Sep 2007 11:22:40 +0200
Message-ID: <20070911112240.pe40oufzz4k8wsg8@imap.suse.de>
References: <20070831.184357.125900174.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:53313 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762067AbXIKJWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 05:22:42 -0400
In-Reply-To: <20070831.184357.125900174.k-ueda@ct.jp.nec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, mike.miller@hp.com, grant.likely@secretlab.ca, dm-devel@redhat.com

Am Sat 01 Sep 2007 12:43:57 AM CEST schrieb Kiyoshi Ueda  
<k-ueda@ct.jp.nec.com>:

> This patch moves the rq->end_io() calling point to the top of
> blk_end_request() from the last of end_that_request_last().
> This means that whole request completion can be hooked by rq->end_io()
> because all device drivers call blk_end_request() to complete request.
>
> Because the meaning of rq->end_io() is changed, existing rq->end_io()
> users are changed as below:
>   o Create a new end_io handler using blk_end_io().
>     blk_end_io() is a default rq->end_io() handler and can take
>     a callback function, which is called after end_that_request_last().
>     So the old end_io() handler can be used as the callback.
>   o Set the new end_io handler to rq->end_io.
>
Hmm. I must say I don't really like it.
Defining a callback function which itself takes a callback as an argument
looks like a conceptual weakness.

It's actually possible to solve it differently: We could insert a bio in
front of the bio list of the cloned request, which can take a pointer to
the request in it's ->bi_endio callback. This way, the bio can serve as
a meta-callback for the request and everything can be done there.

This way we don't have to change the interface at all and everything
works as expected.

I'll post a patch shortly.

Cheers,

Hannes
---
No .sig today, my .message went away ...

