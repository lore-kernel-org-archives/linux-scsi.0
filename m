From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 18/18] block: implement and enforce request peek/start/fetch
Date: Sun, 10 May 2009 23:52:32 +0200
Message-ID: <200905102352.33478.bzolnier@gmail.com>
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-19-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241751256-17435-19-git-send-email-tj@kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@hansenpartnership.com, mike.miller@hp.com, donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net, Geert.Uytterhoeven@sonycom.com, davem@davemloft.net, Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com, grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk, sfr@canb.auug.org.au, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com, zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

On Friday 08 May 2009 04:54:16 Tejun Heo wrote:
> Till now block layer allowed two separate modes of request execution.
> A request is always acquired from the request queue via
> elv_next_request().  After that, drivers are free to either dequeue it
> or process it without dequeueing.  Dequeue allows elv_next_request()
> to return the next request so that multiple requests can be in flight.
> 
> Executing requests without dequeueing has its merits mostly in
> allowing drivers for simpler devices which can't do sg to deal with
> segments only without considering request boundary.  However, the
> benefit this brings is dubious and declining while the cost of the API
> ambiguity is increasing.  Segment based drivers are usually for very
> old or limited devices and as converting to dequeueing model isn't
> difficult, it doesn't justify the API overhead it puts on block layer
> and its more modern users.
> 
> Previous patches converted all block low level drivers to dequeueing
> model.  This patch completes the API transition by...
> 
> * renaming elv_next_request() to blk_peek_request()
> 
> * renaming blkdev_dequeue_request() to blk_start_request()
> 
> * adding blk_fetch_request() which is combination of peek and start
> 
> * disallowing completion of queued (not started) requests
> 
> * applying new API to all LLDs
> 
> Renamings are for consistency and to break out of tree code so that
> it's apparent that out of tree drivers need updating.
> 
> [ Impact: block request issue API cleanup, no functional change ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
