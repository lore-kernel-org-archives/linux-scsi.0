From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Mon, 04 May 2009 16:08:32 +0400
Message-ID: <49FEDAC0.3040503@ru.mvista.com>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h155.mvista.com ([63.81.120.155]:39362 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753969AbZEDMHR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2009 08:07:17 -0400
In-Reply-To: <1241423927-11871-4-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>

Hello.

Tejun Heo wrote:

> rq->data_len served two purposes - the length of data buffer on issue
> and the residual count on completion.  This duality creates some
> headaches.

> First of all, block layer and low level drivers can't really determine
> what rq->data_len contains while a request is executing.  It could be
> the total request length or it coulde be anything else one of the
> lower layers is using to keep track of residual count.  This
> complicates things because blk_rq_bytes() and thus
> [__]blk_end_request_all() relies on rq->data_len for PC commands.
> Drivers which want to report residual count should first cache the
> total request length, update rq->data_len and then complete the
> request with the cached data length.

> Secondly, it makes requests default to reporting full residual count,
> ie. reporting that no data transfer occurred.  The residual count is
> an exception not the norm; however, the driver should clear
> rq->data_len to zero to signify the normal cases while leaving it
> alone means no data transfer occurred at all.  This reverse default
> behavior complicates code unnecessarily and renders block PC on some
> drivers (ide-tape/floppy) unuseable.

> This patch adds rq->resid_len which is used only for residual count.

> While at it, remove now unnecessasry blk_rq_bytes() caching in
> ide_pc_intr() as rq->data_len is not changed anymore.

> Boaz: spotted missing conversion in osd.

> [ Impact: cleanup residual count handling, report 0 resid by default ]

> Signed-off-by: Tejun Heo <tj@kernel.org>

[...]

> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 7149224..3813a0e 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -380,7 +380,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
>  		}
>  
>  		tape->first_frame += blocks;
> -		rq->data_len -= blocks * tape->blk_size;
> +		rq->resid_len = blk_rq_bytes(rq) - blocks * tape->blk_size;

    Is it already guaranteed that rq->data_len == blk_rq_bytes(rq) here?

MBR, Sergei
