From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: oops in ibmvstgt
Date: Tue, 9 Dec 2008 20:03:50 +0900
Message-ID: <20081209200428P.fujita.tomonori@lab.ntt.co.jp>
References: <20081203145857.GA10070@suse.de>
	<20081204212414H.fujita.tomonori@lab.ntt.co.jp>
	<493D73CE.6040405@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60850 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbYLILEB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Dec 2008 06:04:01 -0500
In-Reply-To: <493D73CE.6040405@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, olh@suse.de, linux-scsi@vger.kernel.org

On Mon, 08 Dec 2008 13:21:50 -0600
Brian King <brking@linux.vnet.ibm.com> wrote:

> FUJITA Tomonori wrote:
> > On Wed, 3 Dec 2008 15:58:57 +0100
> > Olaf Hering <olh@suse.de> wrote:
> > 
> >> change init order to fix crash due to uninitalized shost_data
> > 
> > I think that calling crq_queue_create leads to the creation of a rport
> > so we need to set up everything before that. The current code is racy.
> > 
> > 
> >> No idea if the patch is correct.
> > 
> > Almost correct, I think. Needs to modify the error handling
> > too. Probably, it would be better to call scsi_tgt_alloc_queue before
> > crq_queue_create.
> > 
> > How about this?
> 
> Don't we need to do a little more in the error handling like this:

Duh, you are right. Thanks a lot!

I slightly modified the description.

=
From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] ibmvstgt: move crq_queue_create at the end of initialization

Calling crq_queue_create could lead to the creation of a rport. We
need to set up everything before creating a rport. This moves
crq_queue_create at the end of initialization to avoid a race.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reported-by: Olaf Hering <olh@suse.de>
Cc: stable@kernel.org
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 2a5b29d..e2dd6a4 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -864,21 +864,23 @@ static int ibmvstgt_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	INIT_WORK(&vport->crq_work, handle_crq);
 
-	err = crq_queue_create(&vport->crq_queue, target);
+	err = scsi_add_host(shost, target->dev);
 	if (err)
 		goto free_srp_target;
 
-	err = scsi_add_host(shost, target->dev);
+	err = scsi_tgt_alloc_queue(shost);
 	if (err)
-		goto destroy_queue;
+		goto remove_host;
 
-	err = scsi_tgt_alloc_queue(shost);
+	err = crq_queue_create(&vport->crq_queue, target);
 	if (err)
-		goto destroy_queue;
+		goto free_queue;
 
 	return 0;
-destroy_queue:
-	crq_queue_destroy(target);
+free_queue:
+	scsi_tgt_free_queue(shost);
+remove_host:
+	scsi_remove_host(shost);
 free_srp_target:
 	srp_target_free(target);
 put_host:
-- 
1.5.5.GIT

