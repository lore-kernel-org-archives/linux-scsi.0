From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 18 Jul 2003 13:45:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058561157.20130.99.camel@markh1.pdx.osdl.net>
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
	 <1058547377.1826.61.camel@mulgrave>
	 <1058550386.20130.75.camel@markh1.pdx.osdl.net>
	 <1058559719.1826.106.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:2283 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S271787AbTGRUbN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 16:31:13 -0400
In-Reply-To: <1058559719.1826.106.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@osdl.org>, Daniel McNeil <daniel@osdl.org>, Jens Axboe <axboe@suse.de>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2003-07-18 at 13:21, James Bottomley wrote:
> On Fri, 2003-07-18 at 12:46, Mark Haverkamp wrote:
> > I'll try out your test harness on our hardware and see what happens.
> 
> OK, I think I found the problem.
> 
> Parts of the SCSI and block code don't distinguish between queueing and
> requeueing, so they trip over the exact same error.
> 
> The (fairly invasive) fix is to add an extra parameter to
> blk_insert_request to tell it if this is a reinsertion or a new request
> (patch attached--against Jens' previous one).
> 
> With this, I now get the AS ioscheduler to survive my tests.
> 
> Incidentally, I'm not sure whether scsi_requeue_command() counts as a
> reinsertion.  It's used to redo I/O after end_that_request_first() but
> before end_that_request_last().
> 
> James

James,

I had just set my machine up with your test harness in the aacraid
driver and was able to get hangs after a short time.  I applied your
patch and now the hangs seem to be gone for me too.


Mark.
-- 
Mark Haverkamp <markh@osdl.org>

