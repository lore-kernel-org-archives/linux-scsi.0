From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 03/10] block: add rq->resid_len
Date: Wed, 29 Apr 2009 09:41:54 -0500
Message-ID: <1241016114.3369.9.camel@mulgrave.int.hansenpartnership.com>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
	 <1240996428-10159-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1240996428-10159-4-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-04-29 at 18:13 +0900, Tejun Heo wrote:
> rq->data_len served two purposes - the length of data buffer on issue
> and the residual count on completion.  This duality creates some
> headaches.
> 
> First of all, block layer and low level drivers can't really determine
> what rq->data_len contains while a request is executing.  It could be
> the total request length or it coulde be anything else one of the
> lower layers is using to keep track of residual count.  This
> complicates things because blk_rq_bytes() and thus
> [__]blk_end_request_all() relies on rq->data_len for PC commands.
> Drivers which want to report residual count should first cache the
> total request length, update rq->data_len and then complete the
> request with the cached data length.
> 
> Secondly, it makes requests default to reporting full residual count,
> ie. reporting that no data transfer occurred.  The residual count is
> an exception not the norm; however, the driver should clear
> rq->data_len to zero to signify the normal cases while leaving it
> alone means no data transfer occurred at all.  This reverse default
> behavior complicates code unnecessarily and renders block PC on some
> drivers (ide-tape/floppy) unuseable.
> 
> This patch adds rq->resid_len which is used only for residual count.
> 
> While at it, remove now unnecessasry blk_rq_bytes() caching in
> ide_pc_intr() as rq->data_len is not changed anymore.
> 
> [ Impact: cleanup residual count handling, report 0 resid by default ]

This looks good (although I'd like to test it first).

Might it not be better to have an accessor setting resid_len?  All the
other patches in the series insulate users from the actual members of
struct request by accessors, so this is a bit the odd man out.

James


