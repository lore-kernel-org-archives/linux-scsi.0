From: <vmohan@brocade.com>
Subject: [PATCH 4/8] bfa: Fix for bcu or hcm faa query hang
Date: Tue, 19 Nov 2013 23:05:42 -0800
Message-ID: <1384931146-3702-5-git-send-email-vmohan@brocade.com>
References: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:58152 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab3KTHoH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Nov 2013 02:44:07 -0500
In-Reply-To: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: agurumur@brocade.com, james.bottomley@hansenpartnership.com

From: Vijaya Mohan Guvva <vmohan@brocade.com>

This patch set fixes the issue of brocade management utility hang
(bcu/HCM) when faa attributes are queried from multiple application
threads. Hang was due to race between the threads and completion handler
corruption.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 520540a..e3f67b0 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -1367,10 +1367,6 @@ bfa_faa_query(struct bfa_s *bfa, struct bfa_faa_attr_s *attr,
 	struct bfa_iocfc_s      *iocfc = &bfa->iocfc;
 	bfa_status_t            status;
 
-	iocfc->faa_args.faa_attr = attr;
-	iocfc->faa_args.faa_cb.faa_cbfn = cbfn;
-	iocfc->faa_args.faa_cb.faa_cbarg = cbarg;
-
 	status = bfa_faa_validate_request(bfa);
 	if (status != BFA_STATUS_OK)
 		return status;
@@ -1378,6 +1374,10 @@ bfa_faa_query(struct bfa_s *bfa, struct bfa_faa_attr_s *attr,
 	if (iocfc->faa_args.busy == BFA_TRUE)
 		return BFA_STATUS_DEVBUSY;
 
+	iocfc->faa_args.faa_attr = attr;
+	iocfc->faa_args.faa_cb.faa_cbfn = cbfn;
+	iocfc->faa_args.faa_cb.faa_cbarg = cbarg;
+
 	iocfc->faa_args.busy = BFA_TRUE;
 	memset(&faa_attr_req, 0, sizeof(struct bfi_faa_query_s));
 	bfi_h2i_set(faa_attr_req.mh, BFI_MC_IOCFC,
-- 
1.8.2.1

