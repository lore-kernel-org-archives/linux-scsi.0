From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 16 Jul 2003 08:56:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058360162.1850.15.camel@mulgrave>
References: <1058310172.981.7.camel@markh1.pdx.osdl.net>
	<1058359278.1856.8.camel@mulgrave>  <20030716124549.GX833@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:13063 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270709AbTGPMlY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2003 08:41:24 -0400
In-Reply-To: <20030716124549.GX833@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mark Haverkamp <markh@osdl.org>, Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@osdl.org>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2003-07-16 at 08:45, Jens Axboe wrote:
> Completely agree, see my earlier main on the subject.

Yes, saw that later...processed mails in the order seen.

> SCSI does it right, don't worry. It's a block layer problem that we need
> to find out how to correctly make sure that we deal it. Basically
> elv_next_request() does an implicit elv_started_request(), at least that
> is what AS assumes. So request re-adds should notify the scheduler of
> that fact.

What about exporting a more generic requeue function (perhaps one that
would take care of ending the tag)?

Our current requeue code looks like

	if (blk_rq_tagged(req))
		blk_queue_end_tag(q, req);
	__elv_add_request(q, req, 0, 0);

which looks slightly fragile given that we have to remember to end the
tag and then call a __ function (which are usually private).

If we called an explicit request requeue hook, schedulers that need to
adjust for requeueing would have a single place they could plug into?

James


