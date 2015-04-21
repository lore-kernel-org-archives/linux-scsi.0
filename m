From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: aha1542: rework locking
Date: Tue, 21 Apr 2015 12:26:03 +0300
Message-ID: <20150421092603.GC12098@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28078 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbbDUJ0V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 05:26:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux@rainbow-software.org
Cc: linux-scsi@vger.kernel.org

Hello Ondrej Zary,

The patch 1b0224b0ec60: "aha1542: rework locking" from Feb 6, 2015,
leads to the following static checker warning:

	drivers/scsi/aha1542.c:448 aha1542_queuecommand()
	error: scheduling with locks held: 'spin_lock:host_lock'

drivers/scsi/aha1542.c
   400          /* Use the outgoing mailboxes in a round-robin fashion, because this
   401             is how the host adapter will scan for them */
   402  
   403          spin_lock_irqsave(sh->host_lock, flags);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Holding lock.

   404          mbo = aha1542->aha1542_last_mbo_used + 1;
   405          if (mbo >= AHA1542_MAILBOXES)
   406                  mbo = 0;
   407  

[ snip ]

   442          if (bufflen) {
   443                  struct scatterlist *sg;
   444                  struct chain *cptr;
   445                  int i, sg_count = scsi_sg_count(cmd);
   446  
   447                  ccb[mbo].op = 2;        /* SCSI Initiator Command  w/scatter-gather */
   448                  cmd->host_scribble = kmalloc(sizeof(*cptr)*sg_count,
   449                                                           GFP_KERNEL | GFP_DMA);
                                                                 ^^^^^^^^^^
Sleeping allocation.

   450                  cptr = (struct chain *) cmd->host_scribble;
   451                  if (cptr == NULL) {
   452                          /* free the claimed mailbox slot */
   453                          aha1542->int_cmds[mbo] = NULL;
   454                          spin_unlock_irqrestore(sh->host_lock, flags);
   455                          return SCSI_MLQUEUE_HOST_BUSY;
   456                  }
   457                  scsi_for_each_sg(cmd, sg, sg_count, i) {
   458                          any2scsi(cptr[i].dataptr, isa_page_to_bus(sg_page(sg))
   459                                                                  + sg->offset);
   460                          any2scsi(cptr[i].datalen, sg->length);
   461                  };

regards,
dan carpenter
