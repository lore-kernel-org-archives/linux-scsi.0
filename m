From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: aha1542: rework locking
Date: Tue, 21 Apr 2015 12:39:40 +0200
Message-ID: <201504211239.40423.linux@rainbow-software.org>
References: <20150421092603.GC12098@mwanda>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1.atlantis.sk ([92.240.247.91]:34097 "EHLO
	smtp-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbbDUKjq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 06:39:46 -0400
In-Reply-To: <20150421092603.GC12098@mwanda>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday 21 April 2015, Dan Carpenter wrote:
> Hello Ondrej Zary,
> 
> The patch 1b0224b0ec60: "aha1542: rework locking" from Feb 6, 2015,
> leads to the following static checker warning:
> 
> 	drivers/scsi/aha1542.c:448 aha1542_queuecommand()
> 	error: scheduling with locks held: 'spin_lock:host_lock'
> 
> drivers/scsi/aha1542.c
>    400          /* Use the outgoing mailboxes in a round-robin fashion, because this
>    401             is how the host adapter will scan for them */
>    402  
>    403          spin_lock_irqsave(sh->host_lock, flags);
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Holding lock.
> 
>    404          mbo = aha1542->aha1542_last_mbo_used + 1;
>    405          if (mbo >= AHA1542_MAILBOXES)
>    406                  mbo = 0;
>    407  
> 
> [ snip ]
> 
>    442          if (bufflen) {
>    443                  struct scatterlist *sg;
>    444                  struct chain *cptr;
>    445                  int i, sg_count = scsi_sg_count(cmd);
>    446  
>    447                  ccb[mbo].op = 2;        /* SCSI Initiator Command  w/scatter-gather */
>    448                  cmd->host_scribble = kmalloc(sizeof(*cptr)*sg_count,
>    449                                                           GFP_KERNEL | GFP_DMA);
>                                                                  ^^^^^^^^^^
> Sleeping allocation.

Thanks, I missed that as it was already wrong before (since at least when
DEF_SCSI_QCMD was introduced). And it worked despite that.

Should I just change that to GFP_ATOMIC?

-- 
Ondrej Zary
