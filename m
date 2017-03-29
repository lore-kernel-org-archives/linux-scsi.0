From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [REGRESSION] v4.11-rc3: lpfc: panic during module removal /
 shutdown
Date: Wed, 29 Mar 2017 13:17:54 +0200
Message-ID: <20170329111754.GA9183@linux-x5ow.site>
References: <99ad422f-8233-ddac-2e69-deda4a43b3d7@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36143 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932302AbdC2LR6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Mar 2017 07:17:58 -0400
Content-Disposition: inline
In-Reply-To: <99ad422f-8233-ddac-2e69-deda4a43b3d7@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "dick.kennedy@broadcom.com" <dick.kennedy@broadcom.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "anton@samba.org" <anton@samba.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Wed, Mar 29, 2017 at 02:29:45AM +0000, Junichi Nomura wrote:
> Since commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications"),
> "rmmod lpfc" starting to cause panic or corruption due to double free.
> 
> The double-free occurs as followings:
>   - During initialization, lpfc_create_wq_cq() binds cq and wq to
>     the same ring in the way that both cq->pring and wq->pring point
>     to the same object.
>   - Upon removal, lpfc_sli4_queue_destroy() ends up calling
>     lpfc_sli4_queue_free() for both wqs and cqs
>     and kfree(queue->pring) is done twice.
> 
> The problem became more visible in v4.11-rc3 because commit 85e8a23936ab
> ("scsi: lpfc: Add shutdown method for kexec") made lpfc_pci_remove_one()
> called during driver shutdown.

Well the obvious band-aid would be setting the pointers to NULL after freeing
them. lpfc_sli4_queue_free() checks for queue's precense and doesn't use
queue->pring prior to freeing it, so the following _should_ to the trick:

>From befa936d8935a1bed01df65b376f515fa42c99da Mon Sep 17 00:00:00 2001
From: Johannes Thumshirn <jthumshirn@suse.de>
Date: Wed, 29 Mar 2017 13:08:55 +0200
Subject: [PATCH] lpfc: prevent double free of lpfc queue ring pointer

Since commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications")
rmoving the lpfc module causes a double free in lpfc_sli4_queue_free().

This can be prevented by setting the queue->pring and queue pointers to NULL,
so kfree() will simply ignore the pointers on a second call.

Reported-by: Junichi Nomura <j-nomura@ce.jp.nec.com>
Fixes: 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications")
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1c9fa45..86e1529 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13759,7 +13759,9 @@ lpfc_sli4_queue_free(struct lpfc_queue *queue)
 		kfree(queue->rqbp);
 	}
 	kfree(queue->pring);
+	queue->pring = NULL;
 	kfree(queue);
+	queue = NULL;
 	return;
 }
 
-- 
2.10.2

I'll have a look if we at the callers of lpfc_sli4_queue_free() as well
and check if there's a better (a.k.a more correct) way to fix this.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
