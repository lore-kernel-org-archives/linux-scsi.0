From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] [SCSI] mpt2sas: Use kmemdup rather than duplicating its
 implementation
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.291.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c 2011-11-07 19:38:07.896921497 +0100
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c 2011-11-08 10:55:07.719539347 +0100
@@ -7372,7 +7372,7 @@ mpt2sas_scsih_event_callback(struct MPT2
 		return 1;
 	}
 	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
-	fw_event->event_data = kzalloc(sz, GFP_ATOMIC);
+	fw_event->event_data = kmemdup(mpi_reply->EventData, sz, GFP_ATOMIC);
 	if (!fw_event->event_data) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -7380,8 +7380,6 @@ mpt2sas_scsih_event_callback(struct MPT2
 		return 1;
 	}
 
-	memcpy(fw_event->event_data, mpi_reply->EventData,
-	    sz);
 	fw_event->ioc = ioc;
 	fw_event->VF_ID = mpi_reply->VF_ID;
 	fw_event->VP_ID = mpi_reply->VP_ID;
