From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: bfa: fix type conversion warning
Date: Wed,  6 Dec 2017 15:14:18 +0100
Message-ID: <20171206141444.634681-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A regression fix introduced a harmless type mismatch warning:

drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_im_bsg_vendor_request':
drivers/scsi/bfa/bfad_bsg.c:3137:35: error: initialization of 'struct bfad_im_port_s *' from 'long unsigned int' makes pointer from integer without a cast [-Werror=int-conversion]
  struct bfad_im_port_s *im_port = shost->hostdata[0];
                                   ^~~~~
drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_im_bsg_els_ct_request':
drivers/scsi/bfa/bfad_bsg.c:3353:35: error: initialization of 'struct bfad_im_port_s *' from 'long unsigned int' makes pointer from integer without a cast [-Werror=int-conversion]
  struct bfad_im_port_s *im_port = shost->hostdata[0];

This changes the code back to shost_priv() once more, but encapsulates
it in an inline function to document the rather unusual way of
using the private data only as a pointer to the previously allocated
structure.

I did not try to get rid of the extra indirection level entirely,
which would have been rather invasive and required reworking the entire
initialization sequence.

Fixes: 45349821ab3a ("scsi: bfa: fix access to bfad_im_port_s")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/bfa/bfad_bsg.c |  4 ++--
 drivers/scsi/bfa/bfad_im.c  |  6 ++++--
 drivers/scsi/bfa/bfad_im.h  | 10 ++++++++++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index fa9a966e2c2a..3976e787ba64 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3134,7 +3134,7 @@ bfad_im_bsg_vendor_request(struct bsg_job *job)
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	uint32_t vendor_cmd = bsg_request->rqst_data.h_vendor.vendor_cmd[0];
 	struct Scsi_Host *shost = fc_bsg_to_shost(job);
-	struct bfad_im_port_s *im_port = shost->hostdata[0];
+	struct bfad_im_port_s *im_port = bfad_get_im_port(shost);
 	struct bfad_s *bfad = im_port->bfad;
 	void *payload_kbuf;
 	int rc = -EINVAL;
@@ -3350,7 +3350,7 @@ bfad_im_bsg_els_ct_request(struct bsg_job *job)
 {
 	struct bfa_bsg_data *bsg_data;
 	struct Scsi_Host *shost = fc_bsg_to_shost(job);
-	struct bfad_im_port_s *im_port = shost->hostdata[0];
+	struct bfad_im_port_s *im_port = bfad_get_im_port(shost);
 	struct bfad_s *bfad = im_port->bfad;
 	bfa_bsg_fcpt_t *bsg_fcpt;
 	struct bfad_fcxp    *drv_fcxp;
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 24e657a4ec80..c05d6e91e4bd 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -546,6 +546,7 @@ int
 bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 			struct device *dev)
 {
+	struct bfad_im_port_pointer *im_portp;
 	int error = 1;
 
 	mutex_lock(&bfad_mutex);
@@ -564,7 +565,8 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 		goto out_free_idr;
 	}
 
-	im_port->shost->hostdata[0] = (unsigned long)im_port;
+	im_portp = shost_priv(im_port->shost);
+	im_portp->p = im_port;
 	im_port->shost->unique_id = im_port->idr_id;
 	im_port->shost->this_id = -1;
 	im_port->shost->max_id = MAX_FCP_TARGET;
@@ -748,7 +750,7 @@ bfad_scsi_host_alloc(struct bfad_im_port_s *im_port, struct bfad_s *bfad)
 
 	sht->sg_tablesize = bfad->cfg_data.io_max_sge;
 
-	return scsi_host_alloc(sht, sizeof(unsigned long));
+	return scsi_host_alloc(sht, sizeof(struct bfad_im_port_pointer));
 }
 
 void
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 7f7616c52814..af66275570c3 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -69,6 +69,16 @@ struct bfad_im_port_s {
 	struct fc_vport *fc_vport;
 };
 
+struct bfad_im_port_pointer {
+	struct bfad_im_port_s *p;
+};
+
+static inline struct bfad_im_port_s *bfad_get_im_port(struct Scsi_Host *host)
+{
+	struct bfad_im_port_pointer *im_portp = shost_priv(host);
+	return im_portp->p;
+}
+
 enum bfad_itnim_state {
 	ITNIM_STATE_NONE,
 	ITNIM_STATE_ONLINE,
-- 
2.9.0
