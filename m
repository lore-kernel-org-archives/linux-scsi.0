From: michaelc@cs.wisc.edu
Subject: [PATCH 2/2] bnx2i, be2iscsi: fix custom stats length
Date: Tue,  1 Jul 2014 11:24:38 -0500
Message-ID: <1404231878-3844-3-git-send-email-michaelc@cs.wisc.edu>
References: <1404231878-3844-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52438 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201AbaGAQYz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jul 2014 12:24:55 -0400
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s61GOkHG021409
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 1 Jul 2014 11:24:55 -0500
In-Reply-To: <1404231878-3844-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

The custom stats is an array with custom_length indicating the length
of the array. This patch fixes bnx2i and be2iscsi's setting of the
custom stats length. They both just have the one, eh_abort_cnt, so that should
be in the first entry of the custom array and custom_length should then
be one.

Reported-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: Eddie Wai <eddie.wai@broadcom.com>

---
 drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index fd284ff..8616281 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -914,7 +914,7 @@ void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	stats->r2t_pdus = conn->r2t_pdus_cnt;
 	stats->digest_err = 0;
 	stats->timeout_err = 0;
-	stats->custom_length = 0;
+	stats->custom_length = 1;
 	strcpy(stats->custom[0].desc, "eh_abort_cnt");
 	stats->custom[0].value = conn->eh_abort_cnt;
 }
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 166543f..9bd9b81 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1643,12 +1643,11 @@ static void bnx2i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	stats->r2t_pdus = conn->r2t_pdus_cnt;
 	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
 	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
-	stats->custom_length = 3;
-	strcpy(stats->custom[2].desc, "eh_abort_cnt");
-	stats->custom[2].value = conn->eh_abort_cnt;
 	stats->digest_err = 0;
 	stats->timeout_err = 0;
-	stats->custom_length = 0;
+	strcpy(stats->custom[0].desc, "eh_abort_cnt");
+	stats->custom[0].value = conn->eh_abort_cnt;
+	stats->custom_length = 1;
 }
 
 
-- 
1.7.1

