From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 25/44] zfcp: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
Date: Tue, 11 Oct 2016 13:28:56 +0200
Message-ID: <8375976dc02fb84b926d770a2c2700a75fe53b70.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "open list:S390 ZFCP DRIVER" <linux-s390@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/s390/scsi/zfcp_fc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 87f6330..813c286 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -905,7 +905,7 @@ static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
 	preamble_word1 = bsg_request->rqst_data.r_ct.preamble_word1;
 	gs_type = (preamble_word1 & 0xff000000) >> 24;
 
-	adapter = (struct zfcp_adapter *) job->shost->hostdata[0];
+	adapter = shost_priv(fc_bsg_to_shost(job));
 
 	switch (gs_type) {
 	case FC_FST_ALIAS:
@@ -987,7 +987,7 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 	struct zfcp_fsf_ct_els *ct_els = job->dd_data;
 	struct fc_bsg_request *bsg_request = job->request;
 
-	shost = job->rport ? rport_to_shost(job->rport) : job->shost;
+	shost = job->rport ? rport_to_shost(job->rport) : fc_bsg_to_shost(job);
 	adapter = (struct zfcp_adapter *)shost->hostdata[0];
 
 	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_OPEN))
-- 
1.8.5.6
