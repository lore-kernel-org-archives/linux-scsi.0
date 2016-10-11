From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 18/44] scsi: fc: provide fc_bsg_to_shost() helper
Date: Tue, 11 Oct 2016 13:28:49 +0200
Message-ID: <f7c01ac5cf9b79054dfb6751b1e41e5139989b87.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Provide fc_bsg_to_shost() helper that will become handy when we're moving from
struct fc_bsg_job to a plain struct bsg_job.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 include/scsi/scsi_transport_fc.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index eca8ed7..efb9488 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -819,6 +819,11 @@ fc_vport_set_state(struct fc_vport *vport, enum fc_vport_state new_state)
 	vport->vport_state = new_state;
 }
 
+static inline struct Scsi_Host *fc_bsg_to_shost(struct fc_bsg_job *job)
+{
+	return job->shost;
+}
+
 struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
-- 
1.8.5.6
