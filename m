From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: [4.5-rc4 Regression] qla2xxx: Add irq affinity notification
Date: Mon, 11 Apr 2016 13:26:28 -0400
Message-ID: <570BDE44.5020301@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: quinn.tran@qlogic.com
Cc: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, hch@lst.de, bart.vanassche@sandisk.com, himanshu.madhani@qlogic.com, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

Hello Quinn,

A kernel bug report was opened against Ubuntu [0].  After a kernel
bisect, it was found that reverting the following commit resolved this bug:

commit cdb898c52d1dfad4b4800b83a58b3fe5d352edde
Author: Quinn Tran <quinn.tran@qlogic.com>
Date: Thu Dec 17 14:57:05 2015 -0500
   
    qla2xxx: Add irq affinity notification


However, the prior commit also required the following three commits to
also be reverted:

commit 5327c7dbd1a7fd980608f44789076a636e5ee5fc
Author: Quinn Tran <quinn.tran@qlogic.com>
Date: Wed Feb 10 18:59:14 2016 -0500

    qla2xxx: use TARGET_SCF_USE_CPUID flag to indiate CPU Affinity

commit 9095adaab8c1d82707e4e9961b6ad79b62f3361b
Author: Quinn Tran <quinn.tran@qlogic.com>
Date: Wed Feb 10 18:59:13 2016 -0500
   
    target/transport: add flag to indicate CPU Affinity is observed

commit fb3269baf4ecc2ce6d17d4eb537080035bdf6d5b
Author: Quinn Tran <quinn.tran@qlogic.com>
Date: Thu Dec 17 14:57:06 2015 -0500
   
    qla2xxx: Add selective command queuing



The regression was introduced as of v4.5-rc4.
    
I was hoping to get your feedback, since you are the patch author. The
dependant reverts all look like they are improving cpu affinity, which
would likely impact performance.  Do you thing there is a way forward
instead of the reverts, or would it be best to submit a revert request?
    
    
Thanks,
    
Joe


[0] http://pad.lv/1554003
