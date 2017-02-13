From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: aacraid: Include HBA direct interface
Date: Mon, 13 Feb 2017 21:41:02 +0300
Message-ID: <20170213184101.GA4762@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18349 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752528AbdBMSlS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2017 13:41:18 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: RaghavaAditya.Renukunta@microsemi.com
Cc: linux-scsi@vger.kernel.org

Hello Raghava Aditya Renukunta,

The patch 423400e64d37: "scsi: aacraid: Include HBA direct interface"
from Feb 2, 2017, leads to the following static checker warning:

	drivers/scsi/aacraid/commsup.c:762 aac_hba_send()
	error: double unlock 'sem:&fibptr->event_wait'

drivers/scsi/aacraid/commsup.c
   757          if (wait) {
   758                  spin_unlock_irqrestore(&fibptr->event_lock, flags);
   759                  /* Only set for first known interruptable command */

This comment just confuses me...  What is a "known interruptable command?"

   760                  if (down_interruptible(&fibptr->event_wait)) {

down_interruptible() return -EINTR on failure so this test looks
reversed.  It should probably be:

			if (!down_interruptible(&fibptr->event_wait)) {


   761                          fibptr->done = 2;
   762                          up(&fibptr->event_wait);
   763                  }
   764                  spin_lock_irqsave(&fibptr->event_lock, flags);
   765                  if ((fibptr->done == 0) || (fibptr->done == 2)) {
   766                          fibptr->done = 2; /* Tell interrupt we aborted */
   767                          spin_unlock_irqrestore(&fibptr->event_lock, flags);
   768                          return -ERESTARTSYS;
   769                  }
   770                  spin_unlock_irqrestore(&fibptr->event_lock, flags);
   771                  WARN_ON(fibptr->done == 0);
   772  
   773                  if (unlikely(fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT))
   774                          return -ETIMEDOUT;
   775  
   776                  return 0;
   777          }

regards,
dan carpenter
