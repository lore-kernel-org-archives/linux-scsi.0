From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 18 Jul 2003 13:34:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058553262.3372.78.camel@mulgrave>
References: <20030716132036.GB833@suse.de>
	<1058364455.1856.28.camel@mulgrave> <20030716 170456.GK833@suse.de>
	<20030717015756.135a3f5a.akpm@osdl.org> <2003071708595 2.GX833@suse.de>
	<3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@su se.de>
	<3F167F98.60006@cyberone.com.au> <20030717105641.GF833@suse.de> <3F16
	83F5.4030107@cyberone.com.au> <20030717111059.GI833@suse.de>
	<3F168846.90902 @cyberone.com.au>
	<1058474814.4638.11.camel@markh1.pdx.osdl.net> <1058481553
	.19508.5.camel@markh1.pdx.osdl.net>
	<1058485621.7424.30.camel@dell_ss5.pdx.o sdl.net>
	<20030717170055.5dbe20c1.akpm@osdl.org> <3F17821A.307@cyberone.com. au>
	<20030717222534.0295c44e.akpm@osdl.org> <3F1785D9.5000905@cyberone.com.au>
	<1058537776.1863.6.camel@mulgrave> <20030718093006.5e07b6e2.akpm@osdl.org>
	<1058546495.1863.57.camel@mulgrave>  <20030718104514.291c942f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:23300 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270280AbTGRSTn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 14:19:43 -0400
In-Reply-To: <20030718104514.291c942f.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: piggin@cyberone.com.au, daniel@osdl.org, markh@osdl.org, Jens Axboe <axboe@suse.de>, cliffw@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-07-18 at 12:45, Andrew Morton wrote:
> James Bottomley <James.Bottomley@steeleye.com> wrote:
> >
> > > Nick is probably on a plane by now.  I sent Mark's original one-liner to
> > > Linus last night.
> > 
> > That's not a fix, it only catches one out of the five requeue cases in
> > SCSI.
> 
> Well yes, it's a bandaid.  Anton was having hangs (sym2 I guess) and
> if fixed them, too.

Well, OK, but how about the attached bandaid which at least covers all
the queuing cases and confines the fix to the as code:

===== drivers/block/as-iosched.c 1.7 vs edited =====
--- 1.7/drivers/block/as-iosched.c	Fri Jul 18 00:31:01 2003
+++ edited/drivers/block/as-iosched.c	Fri Jul 18 13:28:21 2003
@@ -1306,6 +1306,15 @@
 	as_update_arq(ad, arq); /* keep state machine up to date */
 }
 
+/*
+ * FIXME: HACK for AS requeue problems
+ */
+static void as_requeue_request(request_queue_t *q, struct request *rq)
+{
+	elv_completed_request(q, rq);
+	__elv_add_request(q, rq, 0, 0);
+}
+
 static void
 as_insert_request(request_queue_t *q, struct request *rq,
 			struct list_head *insert_here)
@@ -1821,6 +1830,7 @@
 	.elevator_next_req_fn =		as_next_request,
 	.elevator_add_req_fn =		as_insert_request,
 	.elevator_remove_req_fn =	as_remove_request,
+	.elevator_requeue_req_fn = 	as_requeue_request,
 	.elevator_queue_empty_fn =	as_queue_empty,
 	.elevator_completed_req_fn =	as_completed_request,
 	.elevator_former_req_fn =	as_former_request,

I'll send this one in, if everyone is OK with it.

It still fails in my test harness, but that's a much more severe test
than most things people will come across in the field.

James


