From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 18 Jul 2003 11:56:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058547377.1826.61.camel@mulgrave>
References: <20030716132036.GB833@suse.de>
	<1058364455.1856.28.camel@mulgrave>	<20030716170456.GK833@suse.de>
	<20030717015756.135a3f5a.akpm@osdl.org>	<20030717085952.GX833@suse.de>
	<3F1672D9.7070309@cyberone.com.au>	<20030717102926.GE833@suse.de>
	<3F167F98.60006@cyberone.com.au>	<20030717105641.GF833@suse.de>
	<3F1683F5.4030107@cyberone.com.au>	<20030717111059.GI833@suse.de>
	<3F168846.90902@cyberone.com.au>
	<1058474814.4638.11.camel@markh1.pdx.osdl.net>
	<1058481553.19508.5.camel@markh1.pdx.osdl.net>
	<1058485621.7424.30.camel@dell_ss5.pdx.osdl.net>
	<20030717170055.5dbe20c1.akpm@osdl.org>  <3F17821A.307@cyberone.com.au>
	<1058540605.20130.48.camel@markh1.pdx.osdl.net>
	<1058545730.20130.62.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:19460 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270255AbTGRQli (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 12:41:38 -0400
In-Reply-To: <1058545730.20130.62.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@osdl.org>, Daniel McNeil <daniel@osdl.org>, Jens Axboe <axboe@suse.de>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2003-07-18 at 11:28, Mark Haverkamp wrote:
> I thought more about what you were saying about checking arq == NULL so
> I have enclosed a patch (compilation of everything) which works for us
> here on our hardware.  I have created file systems on multiple disks,
> did copies and also writes to a raw device as well and have had no
> problems yet.

This one still hangs for me a few I/O operations after my test harness
throws its first device busy.

This:

> +	if (arq) 
> +		if (arq->io_context && arq->io_context->aic) {
> +			arq->state = AS_RQ_DISPATCHED;
> +			atomic_inc(&arq->io_context->aic->nr_dispatched);
> +		}
> +	else
> +		WARN_ON(!(rq->flags & REQ_HARDBARRIER) && blk_fs_request(rq));

Needs braces around the first if otherwise gcc may get where the else
belongs wrong.

James


