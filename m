From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 5/7] lpfc 8.3.13: BSG management fixes
Date: Mon, 17 May 2010 15:24:43 +0900
Message-ID: <20100517152627C.fujita.tomonori@lab.ntt.co.jp>
References: <20100514183051S.fujita.tomonori@lab.ntt.co.jp>
	<4BED5428.8090703@emulex.com>
	<4BED5E97.1060909@emulex.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41834 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab0EQGYy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 May 2010 02:24:54 -0400
In-Reply-To: <4BED5E97.1060909@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Fri, 14 May 2010 10:30:47 -0400
James Smart <james.smart@emulex.com> wrote:

> Actually, it may be just checking the file->private_data pointer for NULL at 
> the file entry points.

bsg clears file->private_data in bsg_release() so nobody should not
see file->private_data NULL pointer...


>  Although, the minor should not be deallocated from bsg 
> until all releases are called.

bsg deallocate minor in bsg_unregister_queue(). It means, for example,
after a sas LLD frees a remote port, user-space application can't
access to it. I guess that it's the right thing.

The tricky part is, when a sas LLD frees a remote port, there might be
some user-space applications that still open a bsg device. So you
can't call blk_cleanup_queue() at that time.

You might hit the similar problem to the commit
93c20a59af4624aedf53f8320606b355aa951bc1. The following fix works?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_transport_fc: fix the lifetime of sas bsg objects

fc_bsg_remove can't call blk_cleanup_queue() since there might be
applications that open a fc_host (or rport).

The commit 93c20a59af4624aedf53f8320606b355aa951bc1 fixed the same
lifetime problem of scsi_transport_sas.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_transport_fc.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 0681378..885b26b 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1897,6 +1897,10 @@ static int fc_target_match(struct attribute_container *cont,
 static void fc_rport_dev_release(struct device *dev)
 {
 	struct fc_rport *rport = dev_to_rport(dev);
+
+	if (rport->rqst_q)
+		blk_cleanup_queue(rport->rqst_q);
+
 	put_device(dev->parent);
 	kfree(rport);
 }
@@ -3944,6 +3948,13 @@ fc_bsg_rport_handler(struct request_queue *q)
 	fc_bsg_request_handler(q, shost, rport, &rport->dev);
 }
 
+static void fc_host_bsg_release(struct device *dev)
+{
+	struct fc_host_attrs *fc_host = shost_to_fc_host(dev_to_shost(dev));
+
+	if (fc_host->rqst_q)
+		blk_cleanup_queue(fc_host->rqst_q);
+}
 
 /**
  * fc_bsg_hostadd - Create and add the bsg hooks so we can receive requests
@@ -3981,7 +3992,7 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
 	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
 
-	err = bsg_register_queue(q, dev, bsg_name, NULL);
+	err = bsg_register_queue(q, dev, bsg_name, fc_host_bsg_release);
 	if (err) {
 		printk(KERN_ERR "fc_host%d: bsg interface failed to "
 				"initialize - register queue\n",
@@ -4048,10 +4059,8 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
 static void
 fc_bsg_remove(struct request_queue *q)
 {
-	if (q) {
+	if (q)
 		bsg_unregister_queue(q);
-		blk_cleanup_queue(q);
-	}
 }
 
 
-- 
1.6.5

