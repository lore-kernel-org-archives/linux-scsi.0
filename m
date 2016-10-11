From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 10/44] zfcp: Use fc_bsg_jobdone()
Date: Tue, 11 Oct 2016 13:28:41 +0200
Message-ID: <6831b3879d76c944b964b380a6ba62b340708fba.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "open list:S390 ZFCP DRIVER" <linux-s390@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Use fc_bsg_jobdone() directly instead of the struct bsg_job::job_done()
callback.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/s390/scsi/zfcp_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 4c4023f..40d8f06 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -892,7 +892,7 @@ static void zfcp_fc_ct_els_job_handler(void *data)
 	jr->reply_payload_rcv_len = job->reply_payload.payload_len;
 	jr->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	jr->result = zfcp_ct_els->status ? -EIO : 0;
-	job->job_done(job);
+	fc_bsg_jobdone(job);
 }
 
 static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
-- 
1.8.5.6
