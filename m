From: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 01/18] ide: dequeue in-flight request
Date: Sat, 9 May 2009 08:56:19 +0200
Message-ID: <20090509065619.GA8966@liondog.tnic>
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-2-git-send-email-tj@kernel.org>
Reply-To: petkovbb@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:65193 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZEIG42 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 May 2009 02:56:28 -0400
Content-Disposition: inline
In-Reply-To: <1241751256-17435-2-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net, Geert.Uytterhoeven@sonycom.com, davem@davemloft.net, Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com, grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk, sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com, zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk

On Fri, May 08, 2009 at 11:53:59AM +0900, Tejun Heo wrote:
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

Acked-by: Borislav Petkov <petkovbb@gmail.com>

-- 
Regards/Gruss,
    Boris.
