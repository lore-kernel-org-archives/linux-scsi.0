From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/5] qla2xxx: Fixed a bug in number of response queue creation logic.
Date: Wed, 17 Jun 2009 10:30:28 -0700
Message-ID: <1245259832-8595-2-git-send-email-andrew.vasquez@qlogic.com>
References: <1245259832-8595-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:16588 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759070AbZFQRac (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 13:30:32 -0400
In-Reply-To: <1245259832-8595-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Cc: stable@kernel.org
Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index dcf0116..f0396e7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1663,7 +1663,7 @@ skip_pio:
 		/* queue 0 uses two msix vectors */
 		if (ql2xmultique_tag) {
 			cpus = num_online_cpus();
-			ha->max_rsp_queues = (ha->msix_count - 1 - cpus) ?
+			ha->max_rsp_queues = (ha->msix_count - 1 > cpus) ?
 				(cpus + 1) : (ha->msix_count - 1);
 			ha->max_req_queues = 2;
 		} else if (ql2xmaxqueues > 1) {
-- 
1.6.3.2.306.g4f4fa

