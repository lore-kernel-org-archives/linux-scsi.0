From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] bfa: move the dereference below the NULL test
Date: Mon, 10 Sep 2012 12:53:50 +0800
Message-ID: <CAPgLHd_p0K+OkPgUHgY8Qzg94XuuK32R41HXGYKHtGQnH0wd7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55341 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2IJExu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2012 00:53:50 -0400
Received: by qcro28 with SMTP id o28so777725qcr.19
        for <linux-scsi@vger.kernel.org>; Sun, 09 Sep 2012 21:53:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: huangj@brocade.com, kgudipat@brocade.com, JBottomley@parallels.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/bfa/bfad_im.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 2eebf8d..e778f35 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -951,13 +951,15 @@ static int
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
 
+	itnim_data = (struct bfad_itnim_data_s *)rport->dd_data;
+	bfa = itnim_data->itnim->bfa_itnim->bfa;
+
 	if (bfa_get_lun_mask_status(bfa) == BFA_LUNMASK_ENABLED) {
 		/*
 		 * We should not mask LUN 0 - since this will translate


