From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Sun, 29 May 2016 12:15:39 -0700
Message-ID: <1464549339.2287.30.camel@linux.vnet.ibm.com>
References: <1464407471-3712-1-git-send-email-fangwei1@huawei.com>
	 <20160529065452.GA21677@infradead.org>
	 <1464536473.2287.6.camel@linux.vnet.ibm.com>
	 <20160529180649.GA6486@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:57100 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483AbcE2TPs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 May 2016 15:15:48 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Sun, 29 May 2016 13:15:47 -0600
In-Reply-To: <20160529180649.GA6486@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Wei Fang <fangwei1@huawei.com>, tj@kernel.org, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 2016-05-29 at 11:06 -0700, Christoph Hellwig wrote:
> On Sun, May 29, 2016 at 08:41:13AM -0700, James Bottomley wrote:
> > Actually, it doesn't look fine at all.  The same mechanism that's
> > supposed to protect the host_failed decrement is also supposed to
> > protect the list_move_tail().  If there's a problem with the former
> > then we're also in danger of corrupting the list.
> 
> No, that's not the case.  eh_entry is used for two things:
> 
>  a) shost->eh_cmd_q, which is used to queue up command for the EH
>     thread, and is locked using the host lock.
>  b) various on-stack lists in the EH thread

Actually, no, in the ata error handler case we have per port queues
which are part of the struct ata_port, so it's neither a) nor b).

However, because the ata_port is per sas domain device, and the
sas_ata_strategy_handler fires off one async thread per domain device,
we're concurrency safe on the per-ata_port queues.

Just checking some of the other scsi eh assumptions this may be
violating.

James


> scsi_eh_finish_cmd is only called for case b) as all EH thread
> implementations move the commands from eh_cmd_q to a local list
> as the very first thing.
> 
> host_fail on the other hand is incremented under the host_lock
> in scsi_eh_scmd_add, but decremented without any lock from the
> EH thread.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

