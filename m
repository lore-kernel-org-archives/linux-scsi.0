From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 31 Jul 2003 07:40:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059662443.27432.2.camel@markh1.pdx.osdl.net>
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
	 <1058559719.1826.106.camel@mulgrave>  <3F28C24B.2020604@cyberone.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:9432 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S272498AbTGaOk4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2003 10:40:56 -0400
In-Reply-To: <3F28C24B.2020604@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <piggin@cyberone.com.au>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Daniel McNeil <daniel@osdl.org>, Jens Axboe <axboe@suse.de>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2003-07-31 at 00:16, Nick Piggin wrote:
> James Bottomley wrote:
> 
> >On Fri, 2003-07-18 at 12:46, Mark Haverkamp wrote:
> >
> >>I'll try out your test harness on our hardware and see what happens.
> >>
> 
> Sorry for coming in a few weeks late here. Thanks everyone who
> has been taking time on this.
> 
> What is the status of this stuff? I see Andrew's latest tree still
> has your "HACK: ***" in it, James. Who is putting together a complete
> patch for Andrew?
> 
> >
> >OK, I think I found the problem.
> >
> 
> Yes, the problem with AS just the I-don't-know-about-requeue thing.
> As you have found there are other non AS problems there.
> 
> Thanks again everyone.

Nick,

Here is the requeue function I have been using for a while.  It is based
on your original requeue function.  It has been working for me.

Mark.

===== drivers/block/as-iosched.c 1.9 vs edited =====
--- 1.9/drivers/block/as-iosched.c	Fri Jul 25 11:19:44 2003
+++ edited/drivers/block/as-iosched.c	Thu Jul 31 07:30:04 2003
@@ -1307,12 +1307,30 @@
 }
 
 /*
- * FIXME: HACK for AS requeue problems
+ * requeue the request. The request has not been completed, nor is it a
+ * new request, so don't touch accounting.
  */
 static void as_requeue_request(request_queue_t *q, struct request *rq)
 {
-	elv_completed_request(q, rq);
-	__elv_add_request(q, rq, 0, 0);
+	struct as_data *ad = q->elevator.elevator_data;
+	struct as_rq *arq = RQ_DATA(rq);
+
+	if (arq) {
+		if (arq->io_context && arq->io_context->aic) {
+			arq->state = AS_RQ_DISPATCHED;
+			atomic_inc(&arq->io_context->aic->nr_dispatched);
+		}
+	} else
+		WARN_ON(!(rq->flags & REQ_HARDBARRIER) && blk_fs_request(rq));
+
+	list_add_tail(&rq->queuelist, ad->dispatch);
+
+	/* Stop anticipating - let this request get through */
+	if (ad->antic_status == ANTIC_WAIT_REQ
+			|| ad->antic_status == ANTIC_WAIT_NEXT)
+		as_antic_stop(ad);
+
+	return;
 }
 
 static void

-- 
Mark Haverkamp <markh@osdl.org>

