From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 7/8] scsi: hpsa: call hpsa_hba_inquiry() after adding host
Date: Mon,  5 Feb 2018 23:20:34 +0800
Message-ID: <20180205152035.15016-8-ming.lei@redhat.com>
References: <20180205152035.15016-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180205152035.15016-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

So that we can decide the default reply queue by the map created
during adding host.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Arun Easi <arun.easi@cavium.com>
Cc: Omar Sandoval <osandov@fb.com>,
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
Cc: Christoph Hellwig <hch@lst.de>,
Cc: Don Brace <don.brace@microsemi.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Peter Rivera <peter.rivera@broadcom.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/hpsa.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 287e5eb0723f..443eabf63a9f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8691,12 +8691,9 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Disable discovery polling.*/
 	h->discovery_polling = 0;
 
-
 	/* Turn the interrupts on so we can service requests */
 	h->access.set_intr_mask(h, HPSA_INTR_ON);
 
-	hpsa_hba_inquiry(h);
-
 	h->lastlogicals = kzalloc(sizeof(*(h->lastlogicals)), GFP_KERNEL);
 	if (!h->lastlogicals)
 		dev_info(&h->pdev->dev,
@@ -8707,6 +8704,8 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
 
+	hpsa_hba_inquiry(h);
+
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
 	INIT_DELAYED_WORK(&h->monitor_ctlr_work, hpsa_monitor_ctlr_worker);
-- 
2.9.5
