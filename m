From: Jens Axboe <axboe@kernel.dk>
Subject: Re:
Date: Thu, 01 Jul 2010 14:29:48 +0200
Message-ID: <4C2C8A3C.8000803@kernel.dk>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40351 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab0GAM3u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2010 08:29:50 -0400
In-Reply-To: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: snitzer@redhat.com, hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org

On 2010-07-01 12:49, FUJITA Tomonori wrote:
> This patchset fixes page leak issue in discard commands with unprep
> facility that James posted:
> 
> http://marc.info/?l=linux-scsi&m=127791727508214&w=2
> 
> The 1/3 patch adds unprep facility to the block layer (identical to
> what James posted).
> 
> The 2/3 patch frees a page for discard commands by using the unprep
> facility. James' original patch doesn't work since it accesses to
> rq->bio in q->unprep_rq_fn. We hit oops since q->unprep_rq_fn is
> called when all the data buffer (req->bio and scsi_data_buffer) in the
> request is freed.
> 
> I use rq->buffer to keep track of an allocated page as the block layer
> sets rq->buffer to the address of bio's page. scsi-ml (and llds) don't
> use rq->buffer (rq->buffer is set to NULL). So I can't say that I like
> it lots. Any other way to do that?
> 
> The 3/3 path just removes the dead code.

I've queued up these three for 2.6.36.

-- 
Jens Axboe

