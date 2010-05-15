From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 22/37] drivers/scsi/mpt2sas: Use kmemdup
Date: Sat, 15 May 2010 23:19:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1005152319310.21345@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -u -p a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -6056,7 +6056,7 @@ mpt2sas_scsih_event_callback(struct MPT2
 		return 1;
 	}
 	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
-	fw_event->event_data = kzalloc(sz, GFP_ATOMIC);
+	fw_event->event_data = kmemdup(mpi_reply->EventData, sz, GFP_ATOMIC);
 	if (!fw_event->event_data) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -6064,8 +6064,6 @@ mpt2sas_scsih_event_callback(struct MPT2
 		return 1;
 	}
 
-	memcpy(fw_event->event_data, mpi_reply->EventData,
-	    sz);
 	fw_event->ioc = ioc;
 	fw_event->VF_ID = mpi_reply->VF_ID;
 	fw_event->VP_ID = mpi_reply->VP_ID;
