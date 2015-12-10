From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 11/15] dm stripe: support copy
Date: Thu, 10 Dec 2015 12:31:00 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512101214320.25927@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Support the copy operation for the stripe target.

In stripe_merge, we verify that the underlying device supports copy. If it
doesn't, we can fail fast without any bio being contructed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stripe.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-4.3-rc1/drivers/md/dm-stripe.c
===================================================================
--- linux-4.3-rc1.orig/drivers/md/dm-stripe.c	2015-09-14 16:06:36.000000000 +0200
+++ linux-4.3-rc1/drivers/md/dm-stripe.c	2015-09-14 16:23:01.000000000 +0200
@@ -169,6 +169,7 @@ static int stripe_ctr(struct dm_target *
 	ti->num_flush_bios = stripes;
 	ti->num_discard_bios = stripes;
 	ti->num_write_same_bios = stripes;
+	ti->copy_supported = 1;
 
 	sc->chunk_size = chunk_size;
 	if (chunk_size & (chunk_size - 1))
