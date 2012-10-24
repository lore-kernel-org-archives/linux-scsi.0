From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] Make blk_cleanup_queue() wait until request_fn
 finished
Date: Wed, 24 Oct 2012 12:11:28 -0700
Message-ID: <20121024191128.GD12182@atj.dyndns.org>
References: <50758EBE.7050202@acm.org>
 <50758F90.4020407@acm.org>
 <20121016235152.GL16166@google.com>
 <50868A8C.1070204@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50732 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161085Ab2JXTLg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2012 15:11:36 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so1178360iea.19
        for <linux-scsi@vger.kernel.org>; Wed, 24 Oct 2012 12:11:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <50868A8C.1070204@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello, Bart.

On Tue, Oct 23, 2012 at 02:16:12PM +0200, Bart Van Assche wrote:
> On 10/17/12 01:51, Tejun Heo wrote:
> >>-void blk_drain_queue(struct request_queue *q, bool drain_all)
> >>+static void blk_drain_queue(struct request_queue *q, bool drain_all)
> >>  {
> >>  	int i;
> >>
> >>  	while (true) {
> >>-		bool drain = false;
> >>+		int drain = 0;
> >
> >I don't think this is necessary.  bool conversion works fine
> >regardless how high the bits are.  Isn't avoiding signed/unsigned
> >autocast maze one of the reasons why we're using bool to begin with?
> 
> My concern is about statements like "drain |= q->nr_rqs[i]". As far
> as I know nr_rqs can exceed the value 255 ?

How would that be a problem?  Can you please elaborate (or better
demonstrate) the problem case?  And if such problem exists, please
make it a separate bug fix patch.

Thanks.

--
tejun
