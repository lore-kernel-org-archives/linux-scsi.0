From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 31 Jul 2003 09:28:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059661704.1781.13.camel@mulgrave>
References: <20030716132036.GB833@suse.de>	<1058364455.1856.28.camel@mulgrave>	<20030716
	170456.GK833@suse.de>	<20030717015756.135a3f5a.akpm@osdl.org>	<2003071708595
	2.GX833@suse.de>	<3F1672D9.7070309@cyberone.com.au>	<20030717102926.GE833@su
	se.de>	<3F167F98.60006@cyberone.com.au>	<20030717105641.GF833@suse.de>	<3F16
	83F5.4030107@cyberone.com.au>	<20030717111059.GI833@suse.de>	<3F168846.90902
	@cyberone.com.au>	<1058474814.4638.11.camel@markh1.pdx.osdl.net>	<1058481553
	.19508.5.camel@markh1.pdx.osdl.net>	<1058485621.7424.30.camel@dell_ss5.pdx.o
	sdl.net>	<20030717170055.5dbe20c1.akpm@osdl.org>
	<3F17821A.307@cyberone.com.au>	<1058540605.20130.48.camel@markh1.pdx.osdl.ne
	t>	<1058545730.20130.62.camel@markh1.pdx.osdl.net>	<1058547377.1826.61.camel
	@mulgrave> 	<1058550386.20130.75.camel@markh1.pdx.osdl.net>
	<1058559719.1826.106.camel@mulgrave>  <3F28C24B.2020604@cyberone.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:34822 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S273611AbTGaO2r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2003 10:28:47 -0400
In-Reply-To: <3F28C24B.2020604@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <piggin@cyberone.com.au>
Cc: Mark Haverkamp <markh@osdl.org>, Andrew Morton <akpm@osdl.org>, Daniel McNeil <daniel@osdl.org>, Jens Axboe <axboe@suse.de>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2003-07-31 at 02:16, Nick Piggin wrote:
> What is the status of this stuff? I see Andrew's latest tree still
> has your "HACK: ***" in it, James. Who is putting together a complete
> patch for Andrew?

The status of this stuff in the -test2 kernel is:

Jens' requeue hook is in along with my block layer requeue fixes and the
SCSI layer changes.

This should fix all of the SCSI requeue problems and provide the general
framework.  However, in your as-iosched.c requeue hook I put this:

/*
 * FIXME: HACK for AS requeue problems
 */
static void as_requeue_request(request_queue_t *q, struct request *rq)
{
	elv_completed_request(q, rq);
	__elv_add_request(q, rq, 0, 0);
}

Which was the original hack (except that it now works for all the scsi
queueing cases).  I've tested this in all of the SCSI requeue cases with
my test harness and it seems to work.  You should now be able to
substitute the correct code in here.

I also had a brief conversation with Paul Larson where he said he'd do
LTP SCSI queueing tests if I put the ability to trigger the requeueing
errors in scsi_debug, so hopefully we should get quick warning of any
issues like this in future.

The only outstanding thing is I didn't know whether AS wants a requeue
between end_that_request_first and end_that_request_last treated as a
requeue or a new request.  Following the default logic, it currently
gets treated as a requeue, but it strikes me that this may not strictly
be true, since SCSI will treat the thing as a new and separate command.

James


