From: Jakob Normark <jakobnormark@gmail.com>
Subject: [PATCH 1/1] bfa: Fixes for 0-terminated strncpy and possible null pointer dereference
Date: Wed, 15 May 2013 21:41:51 +0200
Message-ID: <1368646911-22620-1-git-send-email-jakobnormark@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jakob Normark <jakobnormark@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch fixes two cppcheck errors in drivers/scsi/bfa/bfad_im.c
Kernel version: v3.10-rc1

Signed-off-by: Jakob Normark <jakobnormark@gmail.com>
---
 drivers/scsi/bfa/bfad_im.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 5864f98..9489c56 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -944,13 +944,15 @@ static int
 bfad_im_slave_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
-	struct bfad_itnim_data_s *itnim_data =
-				(struct bfad_itnim_data_s *) rport->dd_data;
-	struct bfa_s *bfa = itnim_data->itnim->bfa_itnim->bfa;
+	struct bfad_itnim_data_s *itnim_data;
+	struct bfa_s *bfa;
 
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
+	itnim_data = (struct bfad_itnim_data_s *) rport->dd_data;
+	bfa = itnim_data->itnim->bfa_itnim->bfa;
+
 	if (bfa_get_lun_mask_status(bfa) == BFA_LUNMASK_ENABLED) {
 		/*
 		 * We should not mask LUN 0 - since this will translate
@@ -1037,6 +1039,7 @@ bfad_fc_host_init(struct bfad_im_port_s *im_port)
 
 	strncpy(symname, bfad->bfa_fcs.fabric.bport.port_cfg.sym_name.symname,
 		BFA_SYMNAME_MAXLEN);
+	symname[BFA_SYMNAME_MAXLEN - 1] = '\0';
 	sprintf(fc_host_symbolic_name(host), "%s", symname);
 
 	fc_host_supported_speeds(host) = bfad_im_supported_speeds(&bfad->bfa);
-- 
1.7.9.5
