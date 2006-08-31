From: michaelc@cs.wisc.edu
Subject: [PATCH 8/12] libiscsi: only check burst lengths when sending unsol data
Date: Thu, 31 Aug 2006 18:09:31 -0400
Message-ID: <11570621852186-git-send-email-michaelc@cs.wisc.edu>
References: <11570621752047-git-send-email-michaelc@cs.wisc.edu> <11570621761945-git-send-email-michaelc@cs.wisc.edu> <11570621781978-git-send-email-michaelc@cs.wisc.edu> <11570621791237-git-send-email-michaelc@cs.wisc.edu> <11570621801879-git-send-email-michaelc@cs.wisc.edu> <11570621821931-git-send-email-michaelc@cs.wisc.edu> <11570621832165-git-send-email-michaelc@cs.wisc.edu> <1157062184454-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35206 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932479AbWHaXJ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:29 -0400
In-Reply-To: <1157062184454-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The first burst length is only relevant if immedate data = Yes
or if Initial R2T is No.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index fb65311..9387624 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1593,7 +1593,8 @@ int iscsi_conn_start(struct iscsi_cls_co
 		return -EPERM;
 	}
 
-	if (session->first_burst > session->max_burst) {
+	if ((session->imm_data_en || !session->initial_r2t_en) && 
+	     session->first_burst > session->max_burst) {
 		printk("iscsi: invalid burst lengths: "
 		       "first_burst %d max_burst %d\n",
 		       session->first_burst, session->max_burst);
-- 
1.4.1.1

