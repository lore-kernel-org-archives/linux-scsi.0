From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: oops in ibmvstgt
Date: Thu, 4 Dec 2008 21:23:49 +0900
Message-ID: <20081204212414H.fujita.tomonori@lab.ntt.co.jp>
References: <20081203145857.GA10070@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:32966 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbYLDMX4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2008 07:23:56 -0500
In-Reply-To: <20081203145857.GA10070@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olh@suse.de
Cc: linux-scsi@vger.kernel.org

On Wed, 3 Dec 2008 15:58:57 +0100
Olaf Hering <olh@suse.de> wrote:

> 
> change init order to fix crash due to uninitalized shost_data

I think that calling crq_queue_create leads to the creation of a rport
so we need to set up everything before that. The current code is racy.


> No idea if the patch is correct.

Almost correct, I think. Needs to modify the error handling
too. Probably, it would be better to call scsi_tgt_alloc_queue before
crq_queue_create.

How about this?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ibmvstgt: move crq_queue_create at the end of initialization

Calling crq_queue_create could lead to the creation of a rport. We
need to set up everything before creating a rport. This moves
crq_queue_create at the end of initialization to avoid a race.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 2a5b29d..8dcb59e 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -864,21 +864,19 @@ static int ibmvstgt_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	INIT_WORK(&vport->crq_work, handle_crq);
 
-	err = crq_queue_create(&vport->crq_queue, target);
+	err = scsi_add_host(shost, target->dev);
 	if (err)
 		goto free_srp_target;
 
-	err = scsi_add_host(shost, target->dev);
+	err = scsi_tgt_alloc_queue(shost);
 	if (err)
-		goto destroy_queue;
+		goto free_srp_target;
 
-	err = scsi_tgt_alloc_queue(shost);
+	err = crq_queue_create(&vport->crq_queue, target);
 	if (err)
-		goto destroy_queue;
+		goto free_srp_target;
 
 	return 0;
-destroy_queue:
-	crq_queue_destroy(target);
 free_srp_target:
 	srp_target_free(target);
 put_host:
-- 
1.5.5.GIT

