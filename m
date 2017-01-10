From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] bfa: fix wrongly initialized variable in bfad_im_bsg_els_ct_request()
Date: Tue, 10 Jan 2017 12:54:36 +0100
Message-ID: <20170110115436.15123-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Commit 01e0e15c8b3b ("scsi: don't use fc_bsg_job::request and fc_bsg_job::reply
directly") introduced a typo, which causes that the bsg_request variable in
bfad_im_bsg_els_ct_request() is initialized to itself instead of pointing to
the bsg job's request.

Reported-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/bfa/bfad_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index a9a0016..b2e8c0d 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3363,7 +3363,7 @@ struct bfad_buf_info *
 	struct bfad_fcxp    *drv_fcxp;
 	struct bfa_fcs_lport_s *fcs_port;
 	struct bfa_fcs_rport_s *fcs_rport;
-	struct fc_bsg_request *bsg_request = bsg_request;
+	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	uint32_t command_type = bsg_request->msgcode;
 	unsigned long flags;
-- 
1.8.5.6
