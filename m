From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] pm8001: Fix bogus interrupt state flag issue.
Date: Thu, 1 Mar 2012 17:22:25 +0300
Message-ID: <20120301142225.GA9789@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:43158 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031098Ab2CAOWr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 09:22:47 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santoshprasadnayak@gmail.com
Cc: Jack Wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org

Hello Santosh Nayak,

The patch bdaefbf580cd: "[SCSI] pm8001: Fix bogus interrupt state 
flag issue." from Feb 26, 2012, leads to the following warning:
drivers/scsi/pm8001/pm8001_hwi.c:2400 mpi_sata_completion()
	 error: double unlock 'irq:'


        } else if (t->uldd_task) {
-               spin_unlock_irqrestore(&t->task_state_lock, flags);
+               spin_unlock_irq(&t->task_state_lock);
                ^^^^^^^^^^^^^^^
                pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
                mb();/* ditto */
-               spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+               spin_unlock_irq(&pm8001_ha->lock);
                ^^^^^^^^^^^^^^^
It doesn't make sense to enable IRQs twice.  I'm not sure if it should
be the first or second unlock which enables them.

                t->task_done(t);
-               spin_lock_irqsave(&pm8001_ha->lock, flags);
+               spin_lock_irq(&pm8001_ha->lock);
        } else if (!t->uldd_task) {
-               spin_unlock_irqrestore(&t->task_state_lock, flags);
+               spin_unlock_irq(&t->task_state_lock);
                ^^^^^^^^^^^^^^^
                pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
                mb();/*ditto*/
-               spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+               spin_unlock_irq(&pm8001_ha->lock);
                ^^^^^^^^^^^^^^^
Same thing again.

                t->task_done(t);
-               spin_lock_irqsave(&pm8001_ha->lock, flags);
+               spin_lock_irq(&pm8001_ha->lock);
        }

regards,
dan carpenter

