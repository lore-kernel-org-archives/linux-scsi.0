From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 01/18] ide: dequeue in-flight request
Date: Sat, 9 May 2009 17:58:39 +0200
Message-ID: <200905091758.40306.bzolnier@gmail.com>
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241751256-17435-2-git-send-email-tj@kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@hansenpartnership.com, mike.miller@hp.com, donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net, Geert.Uytterhoeven@sonycom.com, davem@davemloft.net, Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com, grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk, sfr@canb.auug.org.au, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com, zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

On Friday 08 May 2009 04:53:59 Tejun Heo wrote:
> ide generally has single request in flight and tracks it using
> hwif->rq and all state handlers follow the following convention.
> 
> * ide_started is returned if the request is in flight.
> 
> * ide_stopped is returned if the queue needs to be restarted.  The
>   request might or might not have been processed fully or partially.
> 
> * hwif->rq is set to NULL, when an issued request completes.
> 
> So, dequeueing model can be implemented by dequeueing after fetch,
> requeueing if hwif->rq isn't NULL on ide_stopped return and doing
> about the same thing on completion / port unlock paths.  These changes
> can be made in ide-io proper.
> 
> In addition to the above main changes, the following updates are
> necessary.
> 
> * ide-cd shouldn't dequeue a request when issuing REQUEST SENSE for it
>   as the request is already dequeued.
> 
> * ide-atapi uses request queue as stack when issuing REQUEST SENSE to
>   put the REQUEST SENSE in front of the failed request.  This now
>   needs to be done using requeueing.
> 
> [ Impact: dequeue in-flight request ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Cc: Borislav Petkov <petkovbb@googlemail.com>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
