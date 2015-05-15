From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] lpfc 8.2.7 : Rework the worker thread
Date: Fri, 15 May 2015 12:49:34 +0300
Message-ID: <20150515094934.GA23199@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28124 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbbEOJtp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2015 05:49:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 5e9d9b827698: "[SCSI] lpfc 8.2.7 : Rework the worker
thread" from Jun 14, 2008, leads to the following static checker
warning:

	drivers/scsi/lpfc/lpfc_sli.c:9365 lpfc_sli_host_down()
	warn: test_bit() takes a bit number

drivers/scsi/lpfc/lpfc_sli.c
  9357          spin_lock_irqsave(&phba->hbalock, flags);
  9358          for (i = 0; i < psli->num_rings; i++) {
  9359                  pring = &psli->ring[i];
  9360                  prev_pring_flag = pring->flag;
  9361                  /* Only slow rings */
  9362                  if (pring->ringno == LPFC_ELS_RING) {
  9363                          pring->flag |= LPFC_DEFERRED_RING_EVENT;
  9364                          /* Set the lpfc data pending flag */
  9365                          set_bit(LPFC_DATA_READY, &phba->data_flags);

LPFC_DATA_READY is defined as:

#define LPFC_DATA_READY         (1<<0)

The intention seems to be that we use BIT(0) but because set_bit() has
a shift built in it is using BIT(1).  In other words:

Good:	set_bit(0, &phba->data_flags);
 Bad:   set_bit(BIT(0), &phba->data_flags);

This seems to be used consistently so I think it's fine, but static
checkers will complain.  I think this is the only ->data_flag that we
use so it doesn't matter (I haven't looked very hard at this code).

  9366                  }
  9367                  /*
  9368                   * Error everything on the txq since these iocbs have not been
  9369                   * given to the FW yet.
  9370                   */

regards,
dan carpenter
