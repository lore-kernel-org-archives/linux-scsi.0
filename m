From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: oops in ibmvstgt
Date: Mon, 08 Dec 2008 13:21:50 -0600
Message-ID: <493D73CE.6040405@linux.vnet.ibm.com>
References: <20081203145857.GA10070@suse.de> <20081204212414H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:33091 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbYLHTWo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2008 14:22:44 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mB8JLxaN008431
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2008 12:21:59 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB8JMfm9206070
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2008 12:22:42 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB8JMeWZ015832
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2008 12:22:40 -0700
In-Reply-To: <20081204212414H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: olh@suse.de, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 3 Dec 2008 15:58:57 +0100
> Olaf Hering <olh@suse.de> wrote:
> 
>> change init order to fix crash due to uninitalized shost_data
> 
> I think that calling crq_queue_create leads to the creation of a rport
> so we need to set up everything before that. The current code is racy.
> 
> 
>> No idea if the patch is correct.
> 
> Almost correct, I think. Needs to modify the error handling
> too. Probably, it would be better to call scsi_tgt_alloc_queue before
> crq_queue_create.
> 
> How about this?

Don't we need to do a little more in the error handling like this:

-Brian

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ibmvstgt: move crq_queue_create at the end of initialization

Calling crq_queue_create could lead to the creation of a rport. We
need to set up everything before creating a rport. This moves
crq_queue_create at the end of initialization to avoid a race.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---

index 2a5b29d..8dcb59e 100644
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvstgt.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvstgt.c~scsi_oops_in_ibmvstgt drivers/scsi/ibmvscsi/ibmvstgt.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvstgt.c~scsi_oops_in_ibmvstgt	2008-12-08 13:04:21.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvstgt.c	2008-12-08 13:16:32.000000000 -0600
@@ -864,21 +864,23 @@ static int ibmvstgt_probe(struct vio_dev
 
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
_
