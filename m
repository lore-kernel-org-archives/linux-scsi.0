From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH AB1/5] SCSI: SG pools allocation cleanup.
Date: Wed, 25 Jul 2007 11:08:22 +0300
Message-ID: <46A704F6.2040500@panasas.com>
References: <46A5BCB6.9050102@panasas.com> <46A5BDEB.3040506@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:31326 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763850AbXGYIJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2007 04:09:31 -0400
In-Reply-To: <46A5BDEB.3040506@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

I have a very serious and stupid bug in this patch
which did not show in my tests. Please forgive me.
Below is a diff of the bug. As an answer to this mail 
I will resend 2 revised patches AB1, and A2 is also affected.

Sorry
Boaz

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c065de5..29adcc6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1649,7 +1649,7 @@ int __init scsi_init_queue(void)
 
 	for (i = 0, size = 8; i < SG_MEMPOOL_NR; i++, size <<= 1) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
-		sgp->size = size;
+		sgp->size = (i != SG_MEMPOOL_NR-1) ? size : SCSI_MAX_SG_SEGMENTS;
 		sgp->slab = kmem_cache_create(sg_names[i],
 				sgp->size*sizeof(struct scatterlist),
 				0, 0, NULL);

