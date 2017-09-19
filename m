From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 09/10] SCSI: transport_spi: resume a quiesced device
Date: Tue, 19 Sep 2017 11:49:24 +0800
Message-ID: <20170919034925.9894-10-ming.lei@redhat.com>
References: <20170919034925.9894-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49788 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750921AbdISDv1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Sep 2017 23:51:27 -0400
In-Reply-To: <20170919034925.9894-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Ming Lei <ming.lei@redhat.com>

We have to preempt freeze queue in scsi_device_quiesce(),
and unfreeze in scsi_device_resume(), so call scsi_device_resume()
for the device which is quiesced by scsi_device_quiesce().

Tested-by: Cathy Avery <cavery@redhat.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_transport_spi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index d0219e36080c..bdecf99b6ab1 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1040,6 +1040,9 @@ spi_dv_device(struct scsi_device *sdev)
 
 	scsi_target_resume(starget);
 
+	/* undo what scsi_device_quiesce() did */
+	scsi_device_resume(sdev);
+
 	spi_initial_dv(starget) = 1;
 
  out_free:
-- 
2.9.5
